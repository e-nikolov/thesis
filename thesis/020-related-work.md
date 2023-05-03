# Related work

In this chapter, we will examine prior works relevant to our problem of connecting multiple parties over The Internet for a joint MPyC computation.  To identify the challenges, we will begin with an overview of The Internet Protocol Suite, which is central to the modern Internet. Following that, we will review several existing network overlay solutions that we can later use as building blocks for an overall solution to our problem. To maintain a consistent mental picture of the solutions, we will map them to the layers of the \gls{osi} model. While many protocols implement aspects of several layers and do not strictly fit inside the OSI model, it is still a useful visualization tool.





## The Internet


The modern Internet is a global multi-tiered network of devices that communicate using the protocols of the Internet Protocol Suite (TCP/IP). Typically, an \gls{isp} manages the physical infrastructure that connects an end-user's devices with the rest of the internet. Figure \ref{osi-map-tcp} describes the responsibilities of the 7 layers of the OSI model and how they fit with the protocols of the Internet Protocol Suite, which are often referred to as the TCP/IP model. The newer TCP/IP model only recognizes 4 layers as it merges the OSI Session (L5) and Presentation (L6) layers into the Application layer (L7), as well as the Physical layer (L1) into the Data link layer (L2). While the TCP/IP model is a more accurate representation of The Internet, the 7-layer numbers of the OSI model are still widely used in the literature.


![OSI model mapping of the Internet Protocol Suite\label{osi-map-tcp}](../figures/osi-map-tcp.drawio.pdf){width=100% }


<!-- IP -->


The **\acrfull{ip}** is a Network (L3) protocol of the Internet Protocol Suite that is responsible for delivering datagrams between devices across the boundaries of their \glspl{lan} by possibly routing traffic via multiple intermediate devices (routers). A datagram is a connectionless packet that is delivered on a best-effort basis. IP datagrams have a header that contains fields such as the **IP addresses** of its source and destination, and a \todo{show a diagram of the internet with multiple local networks} payload that encapsulates the data from the protocols of the layers above. Routers are devices that are part of multiple networks and relay datagrams between them based on a routing table that maps IP address ranges (\gls{cidr}) to networks.

**\acrfull{udp}** and **\acrfull{tcp}** are Transport (L4) protocols that add the concept of ports to allow having multiple communication channels simultaneously between two devices. UDP provides best-effort delivery, while TCP is a reliable transport with delivery guarantees. TCP maintains stateful connections and handles acknowledgments and retransmissions in case packets are lost in transit.

**\acrfull{tls}** is a protocol that adds encryption on top of a reliable transport protocol such as TCP. It is usually placed in the Presentation Layer (L6), but it does not strictly fit in any single OSI layer. It is rather complex because it needs to support many possible use cases across the internet. \todo{tls} The **Noise Protocol Framework** [@noiseDocs] is a more \todo{noise is transport agnostic} \todo{noise has limited cipher suites} recent effort that applies the ideas of TLS in a simplified way by serving as a blueprint for designing use-case specific protocols for establishing secure communication channels based on \gls{ecdh} handshake patterns. It powers the end-to-end encryption in messaging applications such as WhatsApp and Signal, and \gls{vpn} software such as WireGuard and Nebula.

The version of the Internet Protocol that was originally deployed globally (IPv4) uses 32-bit numbers as IP addresses, allowing for around 4 billion unique addresses. Due to the popularity of the internet, there are many more devices than available IPv4 addresses, which has caused challenges. IPv6 is a newer version of the protocol that uses a larger 128-bit address space which is sufficient for assigning 100 addresses for each atom on Earth. Its adoption has been slow, as according to Google as of 2023 only around 37% of the requests to their services use IPv6. Additionally, despite that IPv6 allows for all devices to be addressable on the Internet, for security reasons, most of them would use firewalls to block incoming remote traffic that is not associated with outgoing connections.

A widespread solution to the addressing problem is **\gls{nat}**. It allows many devices without globally unique IP addresses to initiate connections to publicly addressable devices on the Internet via a limited number of gateways that must have globally unique IP addresses. A NAT gateway replaces the local source IP address of each outgoing IP datagram with its own public IP address before passing it on to the next link on the way to the destination while maintaining a mapping between the source and destination IPs in a translation table. The destination host can then address its responses back to the NAT gateway's public IP address, which in turn replaces its own IP from the incoming datagrams with the IP of the local device and relays them to it. If the IP datagrams encapsulate TCP/UDP packets, the gateway additionally rewrites the source and destination ports, which means that NAT techniques can be placed somewhere between Layers 3 and 4 of the OSI model.

NATs have implications on connectivity that are similar to IPv6 firewalls as they allow devices on a local network to initiate bidirectional communication to remote devices with public IP addresses, but connections cannot be natively initiated by the remote devices. As Figure \ref{nat-intro} shows, it follows that when two devices are behind separate NATs, neither can contact the other first. **Client/Server** communications are less affected by this limitation because many local Clients can contact a Server deployed to a public IP address by its administrators. **Peer-to-Peer** communications, however, are more challenging because the peers are often devices in separate residential networks behind different NATs. Several **NAT traversal** techniques try to solve this with different performance tradeoffs and success that varies depending on the NAT [@natBehaviorRFC] and its behaviors when mapping ports and IP addresses. \todo{describe some of the nat behaviors, e.g. if the source IP address/port vary per destination are changed depending on the destination/port mapping algorithms, if it maps ports, IPs, whether the mapped IPs are different per destination and others.} 

![Two parties behind separate NATs\label{nat-intro}](../figures/nat-intro.png){ height=25% }

One approach that fits the Client/Server model is for the devices behind NATs to initiate bidirectional connections to a publicly addressable **relay** server that forwards the Peer-to-Peer traffic to the appropriate recipient. Compared to direct communication, relaying results in a higher network latency due to the longer path that each packet must travel. Maintaining a relay server requires some technical expertise and may be costly depending on the expected throughput. Despite the drawbacks, relaying works under most networking scenarios and is therefore often used as a fallback in case all other approaches fail to find a direct path. Protocols such as **\acrfull{turn}** [@turnRFC] and **\acrfull{derp}** [@derpDocs] can be used to securely implement relaying.

The NAT gateway in many residential networks is a Router device under the customer's control that has a statically or dynamically assigned public IP address. Most routers can be manually configured through their admin page to forward all traffic that arrives at a given port to a specific device on the local network. Remote applications that know the IP address of the router and the forwarded port can then contact it to initiate a connection to the local device. The manual configuration, however, can be inconvenient and many users may be unaware of that setting because it is not necessary for the more familiar Client/Server communications. Some routers also support programmatic configuration of port forwarding via a Layer 7 protocol like **\gls{upnp}** or its successors **\gls{nat-pmp}** and **\gls{pcp}**. Those protocols, however, are not always supported and are often disabled by the local network administrators due to security concerns related to bugs in their implementation, vulnerable IOT devices or malicious programs being able to expose local devices to the internet.

An efficient NAT traversal approach that works with some types of NATs is to use **\gls{stun}** [@stunRFC] in combination with UDP hole punching. STUN is a Client/Server protocol operating at Layer 7 that allows applications to detect the presence of NAT gateways on the network path to a public endpoint, to identify their types and discover the public IP address that they map to. To achieve this, the device uses UDP to contact a public STUN server which responds with the source IP address and port of the incoming datagrams. If a NAT gateway rewrote the IP address and port, then the device will know this by comparing them to its local IP address and port. Additional STUN servers may be contacted to check if the NAT gateway maps consistent IP addresses and ports. UDP hole punching is a related technique that allows two devices 

to contact detect its own NAT type and the public address of the NAT gateway via, which relies on the predictable port mapping algorithms that many routers use and a public third party host that can be contacted by the local devices and later serve as an introduction point for them (Figure \ref{nat-traversal}).

\todo{rewrite this text from the preparation phase by separating the discussions of STUN and Mesh VPNs, which will be introduced in the next section after we have looked at the lower-level protocols}

> \gls{udp} hole punching based on concepts from \gls{stun}. The machines of each party can contact a public \gls{stun} server \ref{nat-traversal}, which will note what \gls{ip} addresses the connections come from and inform the parties. Since the parties initiated the connection to the STUN server, their routers will keep a mapping between their local IP addresses and the port that was allocated for the connection to be able to forward the incoming traffic. Those "holes" in the NATs were originally intended for the STUN server, but mesh VPNs use the stateless "fire and forget" UDP protocol for their internal communication, which does not require nor provides a mechanism for the NATs to verify who sent a UDP packet. With most NATs, this is enough to be able to (ab)use the "punched holes" for the purpose of \gls{p2p} traffic from other parties. Mesh VPNs implement the stateful \gls{tcp} and \gls{tls} protocols on top of UDP and expose a regular network interface to the other programs, keeping them shielded from the underlying complexities. Other NAT implementations such as Symmetric NAT and \glspl{cgnat} can be more difficult to "punch through" due to their more complex port mapping strategies. In those cases, establishing P2P connections might involve guesswork or even fail and require falling back to routing the (encrypted) traffic via another party or service.

![NAT traversal via STUN\label{nat-traversal}](../figures/nat-traversal.png){ height=25% }

In most mobile networks (4G, 5G) the \gls{isp} utilizes a **\gls{cgnat}** as part of their infrastructure, while all devices under the user's control, including the router, only have local IP addresses. STUN techniques would fail to discover a direct path between two parties behind separate CGNATs or other unpredictable NAT algorithms. The only remaining possibility is for a  like **\acrfull{turn}**, where a publicly reachable third-party host is used not only for introducing the peers but also for relaying all (possibly encrypted) traffic between them.

- Hairpinning


- **\acrfull{ipsec}**
  - Layer 3 protocol suite part of the Internet Protocol Suite
  - used inside VPN software
  - has implementations in both user and kernel space as well as hardware implementations
  - rewrites and encrypts the IP headers and payloads
  - virtual routing table
  - Initially was built into IPv6, separate from IPv4

## Network overlays


Most Network Overlay solutions use a combination of the NAT traversal techniques mentioned previously. They can be placed in Layers 2, 3 or 7. Layer 2 overlays act as a virtual network switch, while Layer 3 overlays act as a virtual network router. Layer 7 overlays are implemented in user-space as libraries or applications that run on top of the network stack of the host operating system. Layer 2 and 3 overlays can either be implemented as kernel modules or as user-space applications that use a **TUN/TAP** driver to interface with the kernel.

Figure \ref{osi-map-overlays} shows an approximate OSI model mapping of several protocols and network overlay solutions from the point of view of the systems that use them and the arrows show dependency relations between them.

![OSI model mapping of various protocols \label{osi-map-overlays}](../figures/osi-map-overlays.drawio.pdf){height=90% }

### TUN/TAP driver

- Layer 2 vs Layer 3 Networks
  - Layer 2 overlays bridge networks
    - virtual network switch
    - remote machines are on the same virtual LAN and can share the same IP address range
    - allows broadcast/multicast
    - TAP driver
  - Layer 3 overlays route traffic between separate local networks
    - virtual network router
    - remote machines are on separate LANs
    - simpler to configure
    - TUN driver

### Traditional VPNs

\glspl{vpn} are implemented as Layer 2 or 3 network overlays. They are commonly used for securely connecting machines from different \glspl{lan}. They provide software emulation of a network interface controller via a TUN/TAP driver on the operating system level and allow other software to transparently use the functionality of the \gls{ip} suite without requiring extra changes. Traditional \glspl{vpn} such as IPSec [@ipSecDocs] and OpenVPN [@openVPNDocs] use a centralized service that all (encrypted) client communications must pass through. This introduces a single point of failure and a potential bottleneck that might negatively impact the performance of the multi-party computations due to their \gls{p2p} nature.

### WireGuard

WireGuard [@donenfeldWireGuardNextGeneration2017] is a more recent protocol with a design informed by lessons learned from IPSec and OpenVPN and a key management approach inspired by SSH. It is a lower-level protocol that focuses on configuration simplicity while network topology, peer discovery and key distribution are left as a responsibility of higher-level systems that use it as a building block. Wireguard is implemented as a Layer 3 overlay over UDP tunnels. WireGuard has both user-space implementations that use a TUN driver and also has direct support built into the Linux Kernel since version 5.6 (May 2020). The kernel implementation allows for better performance because it does not need to copy packets between the kernel and user-space memory.

The snippets below show a minimal set of configuration options that need to be provided for two peers to be able to form secure tunnels with each other.

```ini
# peer1.conf
[Interface]
Address = 101.0.0.1/32
ListenPort = 53063
PrivateKey = ePTiXXhHjvAHdWUr8Bimk30n0gh3m241RAzsN0JZDW0=

[Peer]
PublicKey = BSn0ejd1Y3bKuD+Xpg0ZZeOf+Ies/oql0NZxw+SOmkc=
AllowedIPs = 101.0.0.2/32
Endpoint = peer1.example.com:38133
```

```ini
# peer2.conf
[Interface]
Address = 101.0.0.2/32
ListenPort = 38133
PrivateKey = sN/d6XUPEVPGSziVgCCOnOivDK+qAoYC3nxnssQ5Rls=

[Peer]
PublicKey = e/TxvPmrgcc1G4cSH2bHv5J0PRHXKjYxTFoU8r+G93E=
AllowedIPs = 101.0.0.1/32
```

Each peer has a public/private key pair that is used for authentication and encryption based on the Noise Protocol Framework [@noiseDocs]. The `Address` field specifies the virtual IP address that the local network interface will use, while the `AllowedIPs` field specifies what virtual IP addresses are associated with a peer's public key. A peer's `Endpoint` field specifies the URL at which it can be reached. Only one of the peers must be configured with a reachable endpoint for the other one. In the above example once `peer1`  initiates communication with `peer2`, `peer2` will learn the current endpoint of `peer1` and will be able to communicate back with it.

### Mesh VPNs

- Tinc
- N2N
- Tailscale
- Nebula
- ZeroTier

Mesh \glspl{vpn} such as Tinc [@tincDocs], Tailscale [@tailscaleDocs] and Nebula [@nebulaDocs] utilize NAT Traversal techniques to create direct \gls{p2p} links between the clients for the data traffic. Authentication, authorization and traffic encryption are performed using certificates based on public key cryptography.

All three are open-source, except Tailscale's coordination service which handles peer discovery and identity management. Headscale [@fontJuanfontHeadscale2022] is a community-driven open-source alternative for that component. Tinc is the oldest of the three but has a relatively small community. It is mainly developed by a single author and appears to be more academic than industry motivated.
Nebula and Tailscale are both business driven. Tailscale was started by some high-profile ex-googlers and is the most end-user-focused of the three, providing a service that allows people to sign up using a variety of identity providers including Google, Microsoft, GitHub and others. They also provide an Admin console that allows a user to easily add their personal devices to a network or share them with others. It also has support for automation tools like Terraform for creating authorization keys and managing an \gls{acl} based firewall.
Nebula was originally developed at the instant messaging company Slack to create overlay networks for their cross-region cloud infrastructure, but the authors later started a new company and are currently developing a user-centric platform similar to Tailscale's.  Nebula is more customizable than Tailscale and since it is completely open-source it can be adapted to different use cases, but it is also more involved to set up. A certificate authority needs to be configured for issuing the identities of the participating hosts. Furthermore, publicly accessible coordination servers need to be deployed to facilitate the host discovery.
Tailscale employs a distributed relay network of \gls{derp} servers, while Nebula can be configured to route via one of the other peers in the VPN.

### Layer 7 overlays

#### WebRTC is

- WebRTC
  - Uses STUN/TURN
  - d

- OpenZiti
  - uses relays

- ngrok
- TOR
- BitTorrent
- IPFS
- Ethereum
- Teleport
- Freenet
