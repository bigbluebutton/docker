# Running behind a firewall or NAT

BigBlueButton's media services must listen on an address assigned to the host
while advertising the public address that browsers use. The setup script
detects both addresses and writes them to `.env`:

```dotenv
EXTERNAL_IPv4=203.0.113.10
INTERNAL_IPv4=192.168.50.10
```

`EXTERNAL_IPv4` is the public address configured on the router.
`INTERNAL_IPv4` is the address assigned to the BigBlueButton host. On a server
with a directly assigned public address, both values are normally identical.

Verify these values after running `./scripts/setup`. If either address changes,
update `.env`, regenerate Compose, and recreate the affected services:

```bash
./scripts/generate-compose
docker compose up -d --no-build webrtc-sfu coturn
```

The generated configuration makes the WebRTC SFU listen on `INTERNAL_IPv4`
and announce `EXTERNAL_IPv4`. Coturn uses the equivalent public/private
external-address mapping and relays through `INTERNAL_IPv4`. This avoids
binding media processes to a public address that is not assigned to the host.

## Router and firewall rules

Forward the following UDP traffic to `INTERNAL_IPv4` and allow it through the
host firewall:

- `16384-32768` for WebRTC media
- `32769-65535` for TURN relay traffic
- `3478` when using the bundled coturn service

Also allow the Docker network (`10.7.7.0/24` by default) through the host
firewall. See the
[BigBlueButton firewall documentation](https://docs.bigbluebutton.org/administration/firewall-configuration/)
for the complete port list.

If HTTPS terminates on a reverse proxy running on another host, forward TCP
`443` to that proxy and route media UDP ports directly to the BigBlueButton
host. See [existing-web-server.md](existing-web-server.md) for the proxy bind
configuration.
