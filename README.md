# fs_vagrant
### A Vagrant box for Freeswitch running on Debian Jessie
I make no claims to being a freeswitch expert, this is only for a little local testing, 
please don't use for anything serious, please do let me know what I can do to improve this.

To get the vagrant box running:
```
git clone https://github.com/csik/fs_vagrant.git
cd fs_vagrant

vagrant up
```
go plant a tree
```
vagrant ssh

ps -e
```
(Do you see Freeswitch?  If not, call me)

```
netstat -lnp | grep 5060
```
(Is tcp & udp traffic on 192.168.33.10:5060?  If not, hit me up on what's app)
launch freeswitch:
```
fs_cli
```
In fs_cli: try status, help, welcome to the bear cave known as Freeswitch.

If everything is running you can test it from your non-vagrant machine.  Let's do a SIP 
(standard internet telephony) test using a softphone to call different test lines in 
Freeswitch.  SIP registers with a server to make or receive a call.

On your computer, use a softphone like Telephone (mac) or x-lite (all).  The configuration should be something like:
user id = 1001 or 1001@192.168.1.71
domain = 192.168.33.10
password = 1234 #CHANGE THIS ASAP

Try calling 9198, 9196, and 1000.  With Telephone you can register 1000 & 1001 and have them call each other.
