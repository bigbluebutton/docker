
## Network Configuration
Services as configured.

|Service | Network | IP address |
--- | --- | --- | --- 
| html5-dev | network_mode: host | |
| bbb-web | bbb-net | 10.7.7.2 |
| freeswitch| bbb-net | 10.7.7.10 |
| nginx | bbb-net | 10.7.7.34 |
| etherpad | bbb-net | 10.7.7.4 |
| bbb-pads | bbb-net | 10.7.7.18 |
| bbb-export-annotations | bbb-net | 10.7.7.19 |
| redis | bbb-net | 10.7.7.5 |
| webrtc-sfu | network_mode: host | |
| fsesl-akka | bbb-net | 10.7.7.14 |
| apps-akka | bbb-net | 10.7.7.15 |
| bbb-graphql-server | bbb-net | 10.7.7.31 |
| bbb-graphql-actions | bbb-net | 10.7.7.30 |
| bbb-graphql-middleware | bbb-net | 10.7.7.32 |
| collabora | bbb-net | 10.7.7.20 |
| periodic | bbb-net | 10.7.7.12 |
| recordings | bbb-net | 10.7.7.16 |
| bbb-webrtc-recorder | network_mode: host | |
| webhooks | bbb-net | 10.7.7.17 |
| haproxy | network_mode: host | |
| coturn | network_mode: host | |
| greenlight | bbb-net | 10.7.7.21 |
| postgres | bbb-net | 10.7.7.22 |
| prometheus-exporter | bbb-net | 10.7.7.33 |

```yml
networks:  
  bbb-net:  
    ipam:  
      driver: default  
      config:  
        - subnet: "10.7.7.0/24"
```
