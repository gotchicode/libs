sudo modprobe w1-gpio
sudo modprobe w1-therm
cd /sys/bus/w1/devices/
cd 28-3ca504579ec0
cat w1_slave 
while true; do cat w1_slave ; sleep 10; done