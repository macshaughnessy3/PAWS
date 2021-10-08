# PAWS-RaspberryPi
`PAWS-RaspberryPi` serves as a companion to the `PAWS-iOS` app. The raspberry pi software can be setup by following the instructions below.

## Install
Install [shairport-sync](https://github.com/mikebrady/shairport-sync) following the guide [here](https://github.com/mikebrady/shairport-sync/blob/master/INSTALL.md) or enter the following:
```
# apt-get update
# apt-get upgrade
# iwconfig wlan0 power off
# apt install --no-install-recommends build-essential git xmltoman autoconf automake libtool libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev
$ git clone https://github.com/mikebrady/shairport-sync.git
$ cd shairport-sync
$ autoreconf -fi
$ ./configure --sysconfdir=/etc --with-alsa --with-soxr --with-avahi --with-ssl=openssl --with-systemd
$ make
$ sudo make install
# systemctl enable shairport-sync
# systemctl start shairport-sync
```

Next, make a crontab to run at start up so that our program automatically runs.
On the command line type:
```
$ sudo crontab -e
```
On the bottom of the file add:
```
@reboot python /home/pi/Code/PAWS/PAWS-RaspberryPi/startup/*.py &
```
this will run any python program in the startup folder to run when turn on.