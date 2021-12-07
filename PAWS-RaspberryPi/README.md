# PAWS-RaspberryPi

`PAWS-RaspberryPi` serves as a companion to the `PAWS-iOS` app. The Raspberry Pi software can be setup by following the instructions below. A Raspberry Pi 4B is recommended.

## Install

### Airplay

Install [shairport-sync](https://github.com/mikebrady/shairport-sync) following the guide [here](https://github.com/mikebrady/shairport-sync/blob/master/INSTALL.md) or enter the following:

```bash
# apt-get update
# apt-get upgrade
# iwconfig wlan0 power off
# apt install --no-install-recommends build-essential git xmltoman autoconf automake libtool libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev
# git clone https://github.com/mikebrady/shairport-sync.git
# cd shairport-sync
# autoreconf -fi
# ./configure --sysconfdir=/etc --with-alsa --with-soxr --with-avahi --with-ssl=openssl --with-systemd
# make
# sudo make install
# systemctl enable shairport-sync
# systemctl start shairport-sync
```

### Blutooth Audio

In order to enable audio over classic Bluetooth the Raspberry Pi's Bluettooth must be set to `Discoverable`.

### Enable Code to run on Reboot

Next, make a crontab to run at start up so that our program automatically runs.
On the command line type:

```bash
# sudo crontab -e
```

On the bottom of the file add:

```text
@reboot python /PathToRepo/PAWS/PAWS-RaspberryPi/startup/BLEControl/uart_peripheral.py
@reboot python /PathToRepo/PAWS/PAWS-RaspberryPi/startup/MatrixControl/matrix_control.py
@reboot python /PathToRepo/PAWS/PAWS-RaspberryPi/startup/volume_control.py
```

After saving the file, reboot for the programs to start begin using:

```bash
# reboot
```

Congratulations! PAWS is now running on the Raspberry Pi!
