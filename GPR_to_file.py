#GPR.py

from __future__ import print_function
import serial
import serial.tools.list_ports
import time
import sys
import signal
import numpy
import matplotlib.pyplot as plt

def list_serial_ports():
    """List serial ports available on your system"""
    ports = serial.tools.list_ports.comports()
    available_ports = []
    for port, desc, hwid in sorted(ports):
        available_ports.append({"port": port, "desc": desc, "hwid": hwid})
        print(f"{len(available_ports)}. {port} - {desc} [{hwid}]")
    return available_ports


def signal_handler(signal, frame):
    print("\nStopped")
    ser.close()                                   #close port
    sys.exit(0)

def create_new_file():
    # Generates a unique filename based on the current timestamp
    timestamp = time.strftime("%Y%m%d-%H%M%S")
    filename = f"output_{timestamp}.txt"
    print(f"New file created: {filename}")  # Print the name of the new file
    # Open and return the new file
    return open(filename, 'w')

def write_s_array_to_file(file, s_array):
    numpy.savetxt(file, s_array.reshape(1, s_array.size), fmt='%d')
    file.flush()




#print("Available serial ports:")
#available_ports = list_serial_ports()
#
#if not available_ports:
#    print("No available serial ports found.")
#    exit
#choice = input("Type the number of the serial port you want to use: ")
#try:
#    chosen_port = available_ports[int(choice)-1]["port"]
#except (ValueError, IndexError):
#    print("Invalid selection. Please restart the program and select a valid number.")
#    exit

chosen_port="/dev/ttyACM0"

signal.signal(signal.SIGINT, signal_handler)


ser = serial.Serial(port=chosen_port, baudrate=115200) #open serial virtual port created by Arduino

print("Waiting for connection with GPR")
while True:
    ser.write(b'S')  # Send 'S' to initiate communication
    time.sleep(1)  # Small delay before checking for 'G' to avoid overwhelming the receiver

    if ser.in_waiting > 0:
        if ser.read() == b'G':
            print("Received 'G', starting the process.")
            break  # Exit the loop once 'G' is received
            
    # Additional small delay to prevent a tight loop that might overwhelm both the CPU and the serial device.
    time.sleep(0.1)


# Initially, create a file to start writing data to
current_file = create_new_file()

while True:
    if ser.in_waiting == 1:
        # If exactly one byte is available, check for 'F'
        flag_byte = ser.read(1)
        if flag_byte == b'F':
            current_file.close()  # Close the current file
            current_file = create_new_file()  # Open a new file for the next data
            continue  # Skip the rest of the loop and start again
    elif ser.in_waiting >= 512:
        # Assuming we have at least 512 bytes available
        s = ser.read(512)                                 # Read 512 bytes
        dt = numpy.dtype('uint16')
        dt = dt.newbyteorder('>')                         # High byte first
        s_array = numpy.frombuffer(s, dtype=dt)           # Convert to array
        # Write s_array to the currently open file
        write_s_array_to_file(current_file, s_array)

