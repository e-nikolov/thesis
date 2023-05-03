### Internet Protocol

*   IP addresses
    -   in The Netherlands Ziggo and KPN provide IPv6, but T-Mobile does not. Overall ~40% client-side adoption.

*   Routing
 
*   DNS

*   TLS

#### Network Address Translation (NAT) Traversal

<https://bford.info/pub/net/p2pnat/>

<https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/>

#### Session Traversal Utilities for NAT (STUN)

*   Uses a STUN server for discovery and UDP hole-punching

*   Communications are peer-to-peer

*   Examples:

    *   <https://github.com/shawwwn/Gole>

    *   <https://github.com/malcolmseyd/natpunch-go>

    *   <https://github.com/coturn/coturn> - used in NetBird

    *   <https://github.com/pion/stun> - used in NetBird

    *   <https://github.com/ccding/go-stun> - used in Headscale

#### Traversal Using Relays around NAT (TURN)

*   Peers use a relay server as a mediator to route traffic

*   Examples

    *   <https://github.com/coturn/coturn>

    *   <https://github.com/pion/stun>

#### Universal Plug and Play (UPnP)

- Not always supported
- Often disabled due to security and performance concerns
  - Bugs in the UPnP implementation allowing remote attackers from outside the local network to configure port forwarding
  - IOT devices 
    - might expose themselves to the internet via UPnP
    - often designed to prioritize convenience over security
    - sometimes use default admin user/password
    - Too many ports being configured for forwarding might slow down the network
    - 

#### Interactive Connectivity Establishment (ICE)

*   Umbrella term covering STUN/TURN and other related techniques

#### Designated Encrypted Relay for Packets (DERP)

*   TURN-like protocol by Tailscale

*   Relaying encrypted Wireguard traffic over HTTP

*   Routing based on the Peer’s public key

*   Overview - <https://tailscale.com/kb/1232/derp-servers/>

*   DERP map - <https://login.tailscale.com/derpmap/default>

*   Source code

    *   <https://github.com/tailscale/tailscale/tree/main/cmd/derper>

    *   <https://github.com/tailscale/tailscale/blob/main/derp/derp.go>
