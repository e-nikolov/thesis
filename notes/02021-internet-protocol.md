### Internet Protocol

- IP addresses
- Routing
- DNS
- TLS

#### Network Address Translation (NAT) Traversal

[https://bford.info/pub/net/p2pnat/](https://bford.info/pub/net/p2pnat/)

[https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/](https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/)

#### Session Traversal Utilities for NAT (STUN)

- Uses a STUN server for discovery and UDP hole-punching
- Communications are peer-to-peer
- Examples:
	- [https://github.com/shawwwn/Gole](https://github.com/shawwwn/Gole)
	- [https://github.com/malcolmseyd/natpunch-go](https://github.com/malcolmseyd/natpunch-go)
	- https://github.com/coturn/coturn - used in NetBird
	- https://github.com/pion/stun - used in NetBird
	- https://github.com/ccding/go-stun - used in Headscale
#### Traversal Using Relays around NAT (TURN)

- Peers use a relay server as a mediator to route traffic
- Examples
	- https://github.com/coturn/coturn
	- https://github.com/pion/stun

#### Universal Plug and Play (UPnP)

#### Interactive Connectivity Establishment (ICE)

- Umbrella term covering STUN/TURN and other related techniques

#### Designated Encrypted Relay for Packets (DERP)

- TURN-like protocol by Tailscale
- Relaying encrypted Wireguard traffic over HTTP
- Routing based on the Peer’s public key
- Overview - [https://tailscale.com/kb/1232/derp-servers/](https://tailscale.com/kb/1232/derp-servers/)
- DERP map - https://login.tailscale.com/derpmap/default
- Source code
	- [https://github.com/tailscale/tailscale/tree/main/cmd/derper](https://github.com/tailscale/tailscale/tree/main/cmd/derper)
	- [https://github.com/tailscale/tailscale/blob/main/derp/derp.go](https://github.com/tailscale/tailscale/blob/main/derp/derp.go)