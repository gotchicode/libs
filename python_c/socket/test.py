# python_client.py
import socket
import time
import struct

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


def main_menu():
    while True:
        print("\n=== Python Client Menu ===")
        print("1: Start PRBS15/23 Test")
        print("2: PRBS23 test (request N bytes once)")
        print("3: PRBS23 test (loop mode)")
        print("0: Exit")
        choice = input("Enter choice: ").strip()
        
        if choice == "1":
            run_prbs_test()
        elif choice == "2":
            run_mode_2_request()
        elif choice == "3":
            run_mode_3_loop()
        elif choice == "0":
            print("Exiting.")
            break
        else:
            print("Invalid choice. Try again.")


if __name__ == "__main__":
    main_menu()
