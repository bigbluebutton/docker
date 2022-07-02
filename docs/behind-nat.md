# Note if you use a Firewall / NAT in BBB 2.5 or later
1. When the **setup script** asks for your **external IPv4** select NO and then put the **private ip** of your host.
> Is x.x.x.x your external IPv4 address? (y/n): *n*
> Please enter correct IPv4 address: *192.168.1.100*

This is because the variable **EXTERNAL_IPv4** in .env should be the private ip of the host. If you put the public ip and port forward in your router when the packets reach bbb they would be searching for your PublicIP:port and finally the result would be port unreachable.

2. Now freeswitch and mediasoup bind to the private ip, and we have port forwarded every needed udp port 16384-32768. The problem now is that Mediasoup have an ***announcedIp*** variable that sould ALWAYS be the Public IP, if not, webrtc won't work

3. To change this, we should edit the docker-compose.yml at these lines:
`      
MS_WEBRTC_LISTEN_IPS: '[{"ip":"${EXTERNAL_IPv4}", "announcedIp":"x.x.x.x"}]'
`
`
MS_RTP_LISTEN_IP: '{"ip":"0.0.0.0", "announcedIp":"x.x.x.x"}'
`
where x.x.x.x is your public ip
## Ports
Also don't forget to forward all necassary ports listed in https://docs.bigbluebutton.org/admin/configure-firewall.html