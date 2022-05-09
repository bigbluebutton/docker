
## Network Configuration
Services as configured.
|Service | Network | IP address | Other Option |
--- | --- | --- | --- 
| bbb-web | bbb-net | 10.7.7.2 |
| bbb-pads | bbb-net | 10.7.7.18 |
| html5-backend-{{$i}} | bbb-net | 10.7.7.{{add 100 $i}}| Port {{ add 4000 $i }}
| html5-frontend-{{$i}}| bbb-net | 10.7.7.{{add 200 $i}}| Port {{ add 4100 $i }}
| freeswitch| network_mode: host | |
| nginx | network_mode: host| |    extra_hosts: <br />      - "host.docker.internal:10.7.7.1"<br />      - "core:10.7.7.2"<br />      - "etherpad:10.7.7.4"<br />      - "webrtc-sfu:10.7.7.10"<br />      - "html5:10.7.7.11"
| etherpad | bbb-net | 10.7.7.4|
| redis | bbb-net | 10.7.7.5|
| mongodb | bbb-net | 10.7.7.6|
| kurento | network-mode: host | |
| webrtc-sfu | bbb-net |  | network_mode: host
| fsesl-akka | bbb-net | 10.7.7.14 |
| apps-akka | bbb-net | 10.7.7.15 |
| libreoffice | bbb-net | 10.7.7.7 |
| periodic | bbb-net | 10.7.7.12 |
| recordings | bbb-net | 10.7.7.16 |
| webhooks | bbb-net | 10.7.7.17 |
| https_proxy | bbb-net | |network_mode: host
| coturn | network_mode: host | |
| greenlight | | | ports: 10.7.7.1:5000:80
| prometheus | bbb-net | 10.7.7.33 |

```yml
networks:  
  bbb-net:  
    ipam:  
      driver: default  
      config:  
        - subnet: "10.7.7.0/24"
```
