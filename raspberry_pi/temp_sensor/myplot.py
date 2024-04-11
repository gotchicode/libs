import matplotlib.pyplot as plt
import datetime
import sys

# Function to convert time string to a datetime object
def convert_time(time_str):
    return datetime.datetime.strptime(time_str, '%H:%M:%S')

if len(sys.argv) != 2:
    print("Usage: python script.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

# Initialize lists to store the data
times = []
values = []

# Read the file
try:
    with open(filename, 'r') as file:
        for line in file:
            # Split the line by ';' and strip spaces
            parts = line.strip().split(';')

            # Check if line is correctly formatted
            if len(parts) >= 2:
                time_str, value_str = parts[0].strip(), parts[1].strip()
                try:
                    # Convert time and value
                    time = convert_time(time_str)
                    value = float(value_str)

                    # Append to the lists
                    times.append(time)
                    values.append(value)
                except ValueError:
                    print(f"Invalid line: {line.strip()}")
except FileNotFoundError:
    print(f"File '{filename}' not found.")
    sys.exit(1)

# Plotting
plt.plot(times, values)
plt.xlabel('Time')
plt.ylabel('Value')
plt.title('Plot of Values Over Time')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
