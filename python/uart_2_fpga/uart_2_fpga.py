#Needs pip install pyserial

import serial
import time
import struct

def calculate_crc(frame: bytes) -> int:
    # Placeholder for CRC calculation
    return 0x12345678

def gen_frame_write_register(address: int, data: int) -> bytes:
    SOF = 0xAA
    CMD_WRITE = 0x00

    # Build the frame without CRC first
    frame = bytearray()
    frame.append(SOF)
    frame.append(CMD_WRITE)
    frame += struct.pack('>H', address)  # 16-bit address, big-endian
    frame += struct.pack('>I', data)     # 32-bit data, big-endian

    # Calculate CRC
    crc = calculate_crc(frame)
    frame += struct.pack('>I', crc)       # 32-bit CRC, big-endian

    return bytes(frame)  # Return as immutable bytes

def gen_frame_read_register(address: int) -> bytes:
    SOF = 0xAA
    CMD_READ = 0x01

    frame = bytearray()
    frame.append(SOF)
    frame.append(CMD_READ)
    frame += struct.pack('>H', address)  # 16-bit address, big-endian

    # No data field for read request

    crc = calculate_crc(frame)
    frame += struct.pack('>I', crc)       # 32-bit CRC, big-endian

    return bytes(frame)

def main():
    try:
        # Open COM6 with 9600 baud rate (you can adjust baudrate if needed)
        ser = serial.Serial('COM6', baudrate=9600, timeout=2)

        # Give the port a second to initialize
        time.sleep(1)

        # Send character 'A'
        ser.write(b'A')
        print("Sent: 'A'")

        # Try to read the response
        response = ser.read(1)  # Read 1 byte

        if response:
            print(f"Received: {response.decode('utf-8')}")
        else:
            print("Error: No data received.")

        ser.close()

    except serial.SerialException as e:
        print(f"Serial error: {e}")

    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()
