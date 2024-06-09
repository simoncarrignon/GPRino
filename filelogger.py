import serial
import time
import os
from datetime import datetime

# Function to initialize the serial connection
def init_serial(port, baud_rate):
    try:
        ser = serial.Serial(port, baud_rate)
        time.sleep(2)  # Wait for the connection to establish
        return ser
    except Exception as e:
        print(f"Failed to establish serial connection: {e}")
        return None

# Function to save received data to a new file each time
def save_data(data, folder="data"):
    # Ensure the folder exists
    os.makedirs(folder, exist_ok=True)
    # Create a unique filename using the current timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S%f")
    filename = f"received_data_{timestamp}.bin"
    file_path = os.path.join(folder, filename)
    with open(file_path, "wb") as file:  # Write in binary mode
        file.write(data)
    print(f"Data saved to {file_path}")

# Main function to continuously listen and save data
def main():
    ser = init_serial('/dev/serial0', 9600)  # Replace 'COM3' with your Arduino port
    if not ser:
        print("Serial port not open.")
        return

    print("Listening for data...")
    try:
        while True:
            if ser.in_waiting > 0:  # Check if data is available to read
                data = ser.read(ser.in_waiting)  # Read all available data
                save_data(data)
    except KeyboardInterrupt:
        print("Stopped listening.")
    finally:
        ser.close()
        print("Serial port closed.")

if __name__ == "__main__":
    main()


