# python_client.py
import socket
import time
import struct
import numpy as np
import threading
import sounddevice as sd
from collections import deque

SAMPLE_RATE = 44800  # Hz
BUFFER_SIZE = 65536   # Total size of FIFO buffer
REFILL_THRESHOLD = 16384  # Refill when buffer drops below this
CHUNK_SIZE = 512     # Bytes to stream per audio callback
FIFO = deque()
FIFO_LOCK = threading.Lock()
STOP_PLAYBACK = threading.Event()

def prbs15(seed=0x7FFF, length=255):
    data = bytearray()
    reg = seed
    for _ in range(length * 8):
        bit = ((reg >> 14) ^ (reg >> 13)) & 1
        reg = ((reg << 1) | bit) & 0x7FFF
        if len(data) * 8 <= _:
            data.append(0)
        data[_ // 8] |= (bit << (_ % 8))
    return data

def generate_prbs23(seed=0x7FFFFF, length=255):
    data = bytearray()
    reg = seed
    for _ in range(length * 8):
        bit = ((reg >> 22) ^ (reg >> 17)) & 1
        reg = ((reg << 1) | bit) & 0x7FFFFF
        if len(data) * 8 <= _:
            data.append(0)
        data[_ // 8] |= (bit << (_ % 8))
    return data

def check_prbs23(data, seed=0x7FFFFF):
    expected = generate_prbs23(seed, len(data))
    return expected == data

HOST = "127.0.0.1"
PORT = 12345

def run_prbs_test():
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            print("[Python] Connected to server.")
            while True:
                tx_frame = prbs15()
                s.sendall(tx_frame)
                print("[Python] Sent PRBS15 Frame:", tx_frame.hex())

                rx_frame = s.recv(255)
                if not rx_frame:
                    print("[Python] Server closed connection.")
                    break
                print("[Python] Received PRBS23 Frame:", rx_frame.hex())

                time.sleep(0.1)
    except Exception as e:
        print(f"[Python] Connection error: {e}")
        time.sleep(2)

def run_mode_2_request():
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            print("[Python] Connected to server.")

            length = 255
            print(f"[Python] Requesting {length} bytes of PRBS23...")
            s.sendall(b'\xAA' + struct.pack('>I', length))  # Mode 2 request: 0xAA + 4-byte length

            rx_frame = bytearray()
            while len(rx_frame) < length:
                chunk = s.recv(length - len(rx_frame))
                if not chunk:
                    print("[Python] Server closed connection.")
                    return
                rx_frame.extend(chunk)

            print("[Python] Received PRBS23:", rx_frame.hex())

            if check_prbs23(rx_frame):
                print("[Python] ✅ PRBS23 verification successful!")
            else:
                print("[Python] ❌ PRBS23 verification failed.")

    except Exception as e:
        print(f"[Python] Connection error: {e}")
        time.sleep(2)

def run_mode_3_loop():
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            print("[Python] Connected to server.")

            length = 255
            while True:
                s.sendall(b'\xAA' + struct.pack('>I', length))
                rx_frame = bytearray()
                while len(rx_frame) < length:
                    chunk = s.recv(length - len(rx_frame))
                    if not chunk:
                        print("[Python] Server closed connection.")
                        return
                    rx_frame.extend(chunk)

                print("[Python] Received PRBS23:", rx_frame.hex())

                if check_prbs23(rx_frame):
                    print("[Python] ✅ PRBS23 verification successful!")
                else:
                    print("[Python] ❌ PRBS23 verification failed.")

                time.sleep(0.1)

    except Exception as e:
        print(f"[Python] Connection error: {e}")
        time.sleep(2)

def run_audio_mode_4():
    global FIFO
    FIFO.clear()
    STOP_PLAYBACK.clear()

    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            print("[Python] Connected to C server for audio streaming.")

            # Start fetcher thread
            fetcher = threading.Thread(target=fill_buffer_loop, args=(s,))
            fetcher.start()

            # Start audio playback
            with sd.OutputStream(
                samplerate=SAMPLE_RATE,
                blocksize=CHUNK_SIZE,
                dtype='int16',
                channels=1,
                callback=audio_callback
            ):
                print("[Python] Audio stream started. Press Ctrl+C to stop.")
                try:
                    while not STOP_PLAYBACK.is_set():
                        time.sleep(0.1)
                except KeyboardInterrupt:
                    print("[Python] Stopping audio stream.")
                    STOP_PLAYBACK.set()

            fetcher.join()
    except Exception as e:
        print(f"[Python] Audio mode connection error: {e}")
        STOP_PLAYBACK.set()

def run_audio_mode_5():
    global FIFO, STOP_PLAYBACK, RECORDED_SAMPLES, RECORD_MODE
    import os
    FIFO.clear()
    STOP_PLAYBACK.clear()
    RECORDED_SAMPLES = []
    RECORD_MODE = True

    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            print("[Python] Connected to C server for audio streaming + recording.")

            # Pre-fill buffer with initial data
            while len(FIFO) < SAMPLE_RATE // 2:
                s.sendall(b'\xAA' + struct.pack('>I', 2048))
                chunk = s.recv(2048)
                with FIFO_LOCK:
                    FIFO.extend(chunk)

            # Start fetcher thread
            fetcher = threading.Thread(target=fill_buffer_loop, args=(s,))
            fetcher.start()

            # Start audio playback
            with sd.OutputStream(
                samplerate=SAMPLE_RATE,
                blocksize=CHUNK_SIZE,
                dtype='float32',
                channels=1,
                callback=audio_callback
            ):
                print("[Python] Audio stream started. Press Ctrl+C to stop recording.")
                try:
                    while not STOP_PLAYBACK.is_set():
                        time.sleep(0.1)
                except KeyboardInterrupt:
                    print("[Python] Stopping audio stream.")
                    STOP_PLAYBACK.set()

            fetcher.join()

            # Save as CSV-like text file
            print("[Python] Saving recorded samples to output.txt...")
            with open("output.txt", "w") as f:
                for sample in RECORDED_SAMPLES:
                    f.write(f"{sample:.6f}\n")
            print("[Python] File saved: output.txt")

    except Exception as e:
        print(f"[Python] Audio mode connection error: {e}")
        STOP_PLAYBACK.set()

def fill_buffer_loop(sock):
    try:
        while not STOP_PLAYBACK.is_set():
            with FIFO_LOCK:
                fill = len(FIFO)

            if fill < REFILL_THRESHOLD:
                # Send request: 0xAA + 4-byte length
                request_len = 1024
                request = b'\xAA' + struct.pack('>I', request_len)
                sock.sendall(request)

                rx = bytearray()
                while len(rx) < request_len:
                    chunk = sock.recv(request_len - len(rx))
                    if not chunk:
                        print("[Python] Server disconnected.")
                        STOP_PLAYBACK.set()
                        return
                    rx.extend(chunk)

                with FIFO_LOCK:
                    FIFO.extend(rx)
            time.sleep(0.01)
    except Exception as e:
        print("[Python] Error in buffer filler:", e)
        STOP_PLAYBACK.set()

def audio_callback(outdata, frames, time_info, status):
    if status:
        print("[Python] Audio callback status:", status)
    samples = bytearray()

    with FIFO_LOCK:
        while len(samples) < frames:
            if FIFO:
                samples.append(FIFO.popleft())
            else:
                samples.append(0x00)  # Silence if buffer underflow
                print("Buffer underflow happened")

    # Convert bytes to signed 8-bit samples centered at 0
    outdata[:] = (np.frombuffer(bytes(samples), dtype=np.uint8).astype(np.int16) - 128).reshape(-1, 1)

    # ✅ Make sure this is defined BEFORE recording
    float_array = np.array(samples, dtype='float32')

    if RECORD_MODE:
            RECORDED_SAMPLES.extend(float_array.tolist())  # store float samples directly

def main_menu():
    while True:
        print("\n=== Python Client Menu ===")
        print("1: Start PRBS15/23 Test")
        print("2: PRBS23 test (request N bytes once)")
        print("3: PRBS23 test (loop mode)")
        print("4: Audio Streaming via Sound Card")
        print("5: Audio Streaming + Save to File")
        print("0: Exit")
        choice = input("Enter choice: ").strip()
        
        if choice == "1":
            run_prbs_test()
        elif choice == "2":
            run_mode_2_request()
        elif choice == "3":
            run_mode_3_loop()
        elif choice == "4":
            run_audio_mode_4()
        elif choice == "5":
            run_audio_mode_5()
        elif choice == "0":
            print("Exiting.")
            break
        else:
            print("Invalid choice. Try again.")



if __name__ == "__main__":
    main_menu()
