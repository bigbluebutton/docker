# Note if you use a Firewall / NAT
Kurento binds somehow always to the external IP instead of the local one or `0.0.0.0`. For that reason you need to add your external IP to your interface.

#### Temporary  way (until next reboot)
```
$ ip addr add 144.76.97.34/32 dev ens3
```

#### Permanent way
Specific to your linux distribution. Use a search engine of your choice. ;)

## Ports
Also don't forget to forward all necassary ports listed in https://docs.bigbluebutton.org/admin/configure-firewall.html

