rmmod lirc_serial
setserial /dev/ttyS0 uart none
modprobe lirc_serial
lircd
./irsnd.sh

