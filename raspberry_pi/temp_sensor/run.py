import os
import glob
import time
from datetime import datetime

os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')

base_dir = '/sys/bus/w1/devices/'
device_folder = glob.glob(base_dir + '28*')[0]
device_file = device_folder + '/w1_slave'

def read_temp_raw():
    f = open(device_file, 'r')
    lines = f.readlines()
    f.close()
    return lines

def read_temp():
    lines = read_temp_raw()
    while lines[0].strip()[-3:] != 'YES':
        time.sleep(0.2)
        lines = read_temp_raw()
    equals_pos = lines[1].find('t=')
    if equals_pos != -1:
        temp_string = lines[1][equals_pos + 2:]
        temp_c = float(temp_string) / 1000.0
        return temp_c

while True:
    temp_c = read_temp()
    
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"{timestamp} ; {temp_c:.2f} ;")
    
    timestampfile = datetime.now().strftime("%Y_%m_%d")
    filename = f"{timestampfile}.txt"
    
    # Save to a file with the date as the filename
    with open(filename, "a") as file:
        file.write(f"{timestamp} ; {temp_c:.2f} ;\n")
        
    time.sleep(60)
    
    
