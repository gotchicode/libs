# python_client.py
import socket
import time

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

def decode_prbs23(data):
    # For simplicity, return the raw data. You can add decoding if needed.
    return data

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
                decoded = decode_prbs23(rx_frame)
                print("[Python] Received PRBS23 Frame:", decoded.hex())

                time.sleep(0.1)
    except Exception as e:
        print(f"[Python] Connection error: {e}")
        time.sleep(2)

def main_menu():
    while True:
        print("\n=== Python Client Menu ===")
        print("1: Start PRBS15/23 Test")
        print("0: Exit")
        choice = input("Enter choice: ").strip()
        
        if choice == "1":
            run_prbs_test()
        elif choice == "0":
            print("Exiting.")
            break
        else:
            print("Invalid choice. Try again.")

if __name__ == "__main__":
    main_menu()
