#!/bin/bash
sudo su
echo "deb http://files.freeswitch.org/repo/deb/debian/ jessie main" > /etc/apt/sources.list.d/99FreeSWITCH.test.list
wget -O - http://files.freeswitch.org/repo/deb/debian/key.gpg |apt-key add - 
apt-get -y update
apt-get -y upgrade

DEBIAN_FRONTEND=none APT_LISTCHANGES_FRONTEND=none apt-get install -y --force-yes freeswitch-video-deps-most

cd  /usr/src/
git config --global pull.rebase true
git clone https://freeswitch.org/stash/scm/fs/freeswitch.git freeswitch.git
cd /usr/src/freeswitch.git

./bootstrap.sh -j

sed -i 's,#formats/mod_shout,formats/mod_shout,g' /usr/src/freeswitch.git/modules.conf
sed -i 's,#endpoints/mod_portaudio,endpoints/mod_portaudio,g' /usr/src/freeswitch.git/modules.conf
sed -i 's,#endpoints/mod_alsa,endpoints/mod_alsa,g' /usr/src/freeswitch.git/modules.conf


./configure -C
make
make install
make cd-sounds-install
make cd-moh-install
make samples

sed -i 's,<!--<load module="mod_shout"\/>-->,<load module="mod_shout"\/>,g' /etc/freeswitch/autoload_configs/modules.conf.xml
sed -i 's,<!-- <load module="mod_portaudio"\/> -->,<load module="mod_portaudio"\/>,g' /etc/freeswitch/autoload_configs/modules.conf.xml
sed -i 's,<!-- <load module="mod_alsa"\/> -->,<load module="mod_alsa"\/>,g' /etc/freeswitch/autoload_configs/modules.conf.xml


touch /etc/sysctl.d/vid.conf

sed -i -e '$a\
net.core.rmem_max = 16777216\
net.core.wmem_max = 16777216\
kernel.core_pattern = core.%p\' /etc/sysctl.d/vid.conf

sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w kernel.core_pattern=core.%p

sed -i 's,<param name="sip-ip" value="$${local_ip_v4}"/>,<param name="sip-ip" value="192.168.33.10"/>,g' /usr/src/freeswitch.git/conf/vanilla/sip_profiles/external.xml
sed -i 's,<param name="rtp-ip" value="$${local_ip_v4}"/>,<param name="rtp-ip" value="192.168.33.10"/>,g' /usr/src/freeswitch.git/conf/vanilla/sip_profiles/external.xml
sed -i 's,<param name="sip-ip" value="$${local_ip_v4}"/>,<param name="sip-ip" value="192.168.33.10"/>,g' /usr/src/freeswitch.git/conf/vanilla/sip_profiles/external.xml
sed -i 's,<param name="rtp-ip" value="$${local_ip_v4}"/>,<param name="rtp-ip" value="192.168.33.10"/>,g' /usr/src/freeswitch.git/conf/vanilla/sip_profiles/external.xml


apt-get install screen
screen -dmS FREESWITCH /usr/local/freeswitch/bin/freeswitch

