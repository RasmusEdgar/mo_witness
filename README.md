# mo_witness
MoWitness is a simple thing which checks ports when requested to do so. Intended to be used with Keepalived.

You can check both udp and tcp ports.

It returns 1 if port is up and 0 if port is down. For two checks where a port is up on one server and down on another the return code would look like this: 10

On Keepalived you could use this return code to determine what VRRP state Keepalived should be put in.

MoWitness only accepts GET requests and checks the caller for a valid pre-agreed UserAgent ID. All non-matching request are denied with a HTTP 404 code.

This application is not meant to run as root. Setup a local::lib installation for a dedicated MoWitness user.

# Installation

As root:  
```
useradd -s /bin/bash -d /opt/mowitness -m -c "MoWitness user" mowitness
su - mowitness
```
As the mowitness user:  
```
wget -O- https://cpanmin.us | perl - -l $HOME/perl5 App::cpanminus local::lib && echo 'eval `perl -I $HOME/perl5/lib/perl5 -Mlocal::lib`' >> $HOME/.bash_profile && echo 'export MANPATH=$HOME/perl5/man:$MANPATH' >> $HOME/.bash_profile
. .bash_profile
cpanm Data::Dumper Compress::Raw::Zlib Digest::MD5 Digest::SHA IO::Compress::Gzip Mojolicious
git clone https://github.com/RasmusEdgar/mo_witness.git
```
Test the application (still as the mowitness user):  
```
cd mo_witness
morbo -l http://*:4778 script/mo_witness
adjust mo_witness.conf to your liking.
```
Check your browser http://\<url/localhost\>:4778

See the nginx conf example and systemd example in the conf dir.

Run as root:  
Place mo\_witness.env in /etc/sysconfig/  
Place mo\_witness.service in /etc/systemd/system/  
```
systemctl daemon-reload
```

## mo\_witness service - hot deployment

If changes have been made to the config, reload hypnotoad as the mowitness user with:

```
hypnotoad mo_witness/script/mo_witness
```

As root the service may be bumped with systemd:

```
systemctl start mo_witness
```

## Future plans

Implement url and sql checks
