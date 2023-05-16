# Related work

This chapter explores prior work related to multi-party connectivity over The Internet and their suitability for joint MPyC computations. [Section @sec:internet] provides an overview of the protocols of the modern Internet, the challenges for Peer-to-Peer communications and some of the approaches to overcome them. [Section @sec:overlays] discusses higher-level network overlays that use different combinations of the lower-level protocols from the previous section. 

<!-- The presented solutions will be mapped to the layers of the \gls{osi} model. While many protocols implement aspects of several layers and do not strictly fit inside the OSI model, it is still a useful tool for comparing them. -->

## The Internet {#sec:internet}

The Internet is a global multi-tiered computer network of billions of host devices that communicate using the protocols of the Internet Protocol Suite (TCP/IP). \glspl{isp} are responsible for managing different sections of the infrastructure that connects the \glspl{lan} of various end-users including households and enterprises. The \gls{www} or simply The Web is a collection of interconnected documents, e.g. HTML Web Pages, available on The Internet and is typically accessed via a user-agent software such as a ***Web Browser***. The term "The Web" is sometimes used interchangeably with The Internet, but The Internet supports other services as well, e.g. file transfer (FTP), email (SMTP), instant messaging, remote access (SSH) and others. Conceptual frameworks like the OSI model are useful for understanding the objectives and functions of communication protocols. Figure \ref{osi-map-tcp} describes the responsibilities of the 7 layers of the OSI model and how they relate to the TCP/IP model used by the Internet Protocol Suite. The newer TCP/IP model only recognizes 4 layers as it merges the OSI Session (L5) and Presentation (L6) layers into the Application layer (L7), as well as the Physical layer (L1) into the Data link layer (L2). While the TCP/IP model is a more accurate representation of The Internet, the 7-layer numbers of the OSI model are still widely used in the literature.

![OSI model mapping of the Internet Protocol Suite\label{osi-map-tcp}](../figures/osi-map-tcp.drawio.pdf){width=100% }

<!-- IP -->
### Communications

The Internet Protocol Suite utilizes packet-switching, meaning that application layer communications are broken into smaller discrete packets that are handled individually by the network protocols. A protocol typically has a \gls{pdu} that describes the information that  c has a header  i  A packet contains multiple nested a header and a payload, where the header identifies the protocol that  that  which protocol which protocols are involvedhierarchically organized information from the protocols.   identifies  information that identifies its from the various communication protocols with each protocol having its own \gls{pdu}. 
The various protocols have their own \glspl{pdu} that have a header that ide 
The **\acrfull{ip}** [@ipv4RFC] is a Network layer (L3) protocol of the Internet Protocol Suite that is responsible for transferring datagrams between devices across the boundaries of their \glspl{lan} by possibly routing them via multiple intermediate devices (e.g. routers). A datagram is a self-contained unit of data, typically associated with connectionless protocols that provide no guarantees for delivery or ordering (e.g. IP, UDP). \todo{packet is the physical envelope of the IP datagram}. IP datagrams have a header that contains fields such as the **IP addresses** of its source and destination, and a \todo{show a diagram of the internet with multiple local networks} payload that encapsulates the data from the Transport Layer (L4) protocols. A ***router*** is a device that is part of multiple networks and relays datagrams between them based on a routing table that maps IP address ranges to networks. ***\gls{cidr}*** is a common notation for describing IP address ranges, e.g. `192.168.0.1/16`, where the number after the slash describes the bit-length of the fixed prefix for a subnet.

**\acrfull{udp}** [@udpRFC] and **\acrfull{tcp}** [@tcpRFC] are Transport layer (L4) protocols that \todo{IP multiplexing via ports, TCP segments and segmentation, UDP no segmentation } employ 16-bit port numbers to enable multiple applications on the same host to establish their own communication channels while sharing an IP address. Both protocols UDP offers faster communication, but only provides best-effort delivery, while TCP is a reliable transport protocol with stronger delivery guarantees at the expense of higher network latency. TCP maintains stateful connections that handle error detection and correction, packet ordering, flow control, acknowledgments and retransmissions in case packets are lost during transmission.

***\gls{http}*** is an Application layer (L7) protocol that enables interactions on The Web between web servers and clients (e.g. browsers). Traditionally, HTTP offers stateless request/response , but can also . Similar to other L7 protocols, it uses ***\glspl{url}*** for locating resources using the format `scheme://host:port/path?query=value#fragment`, e.g. http://www.example.com:80/path/to/file.html. It is built on top of TCP and provides several features such as:

- Request Methods - used by the client to specify the action to perform on the resource behind the given URL, e.g. GET, POST, PUT, DELETE, etc.
- Headers - used to provide additional information about a request or response, e.g. Content-Type, Authorization, Cache-Control
- Status codes - used to indicate whether or not the result of a request, e.g. if it was successful (200), or if the resource is missing (404)
- Cookies - used to include stateful information about the user kept at the client-side
- Caching - used to specify that the result of a request can be cached for a certain time to avoid repeating the request's action.

The ***\gls{dns}*** operates at the Application Layer (L7) and allows the conversion of human-readable domains to IP addresses, e.g. `google.com` to `142.250.179.142`.

### Host Addressing

The version of the Internet Protocol, that was originally deployed globally (IPv4), uses 32-bit numbers as IP addresses, allowing for around 4 billion unique addresses. Due to the popularity of The Internet, there are many more devices than available IPv4 addresses, which has caused challenges. IPv6 is a newer version of the protocol that uses a larger 128-bit address space which is sufficient for assigning 100 addresses for each atom on Earth. Its adoption has been slow, as according to Google as of 2023 only around 37% of the requests to their services use IPv6. Additionally, despite that IPv6 allows for all devices to be addressable on the Internet, for security reasons, most of them would use firewalls to block incoming remote traffic that is not associated with outgoing connections.

A widespread solution to the addressing problem is **\gls{nat}**. It allows many devices without globally unique IP addresses to initiate connections to publicly addressable devices on the Internet via a limited number of gateways that must have globally unique IP addresses. A NAT gateway replaces the local source IP address of each outgoing IP datagram with its own public IP address before passing it on to the next link on the way to the destination while maintaining a mapping between the source and destination IPs in a translation table. The destination host can then address its responses back to the NAT gateway's public IP address, which in turn replaces its own IP from the incoming datagrams with the IP of the local device and forwards them to it. If the IP datagrams encapsulate TCP/UDP packets, the gateway additionally rewrites the source and destination ports, which means that NAT techniques can be placed somewhere between Layers 3 and 4 of the OSI model.

The effect of NAT on connectivity is similar to an IPv6 firewall as they both allow devices on a local network to initiate bidirectional communication to remote devices with public IP addresses, but connections cannot be natively initiated by the remote devices. As Figure \ref{nat-intro} shows, it follows that when two devices are behind separate NATs, neither can contact the other first. **Client/Server** communication is less affected by this limitation because Servers are usually deployed to a public IP address that can be contacted by Clients with local IP addresses. **Peer-to-Peer** communication, however, is more challenging because the peers are often devices in separate residential networks behind different NATs. Several **NAT traversal** techniques try to solve this with different performance tradeoffs and success that varies depending on the NAT [@natBehaviorRFC] and its behavior when mapping ports and IP addresses. \todo{describe some of the nat behaviors, e.g. if the source IP address/port vary per destination are changed depending on the destination/port mapping algorithms, if it maps ports, IPs, whether the mapped IPs are different per destination and others.} 

![Two parties behind separate NATs\label{nat-intro}](../figures/nat-intro.png){ height=25% }

One approach based on the Client/Server model is to use a publicly addressable **relay** server that is contacted by the NATed devices and then forwards the Peer-to-Peer traffic to the intended recipient. Compared to direct communication, relaying results in a higher network latency due to the longer path that each packet must travel. Maintaining a relay server requires some technical expertise and may be costly depending on the expected throughput. Despite the drawbacks, relaying works under most networking scenarios and is therefore often used as a fallback in case all other approaches fail to find a direct path. Protocols such as **\acrfull{turn}** [@turnRFC] and **\acrfull{derp}** [@derpDocs] can be used to securely implement relaying.

The NAT gateway in many residential networks is a Router device under the customer's control that has a statically or dynamically assigned public IP address. Most routers can be manually configured through their admin page to forward all traffic that arrives at a given port to a specific device on the local network. Remote applications can then initiate a connection to the local device if they know the IP address of the router and the forwarded port. The manual configuration, however, can be inconvenient and many users may be unaware of that setting because it is not necessary for the more straightforward Client/Server communications. Some routers also support programmatic configuration of port forwarding via a Layer 7 protocol like **\gls{upnp}** or its successors **\gls{nat-pmp}** and **\gls{pcp}**. However, these protocols are not always supported and are often disabled by the local network administrators due to security concerns related to bugs in their implementation, vulnerable IOT devices on the local network or malicious programs being able to expose local devices to the internet.

An efficient NAT traversal approach that works with some types of NATs is to use **\gls{stun}** [@stunRFC] in combination with UDP hole punching (Figure \ref{nat-traversal}). STUN is a protocol operating at Layer 7 that allows a client application to detect the presence of NAT gateways on the network path to a public STUN server, and identify their types and the public IP address that they map to externally. An application sends UDP datagrams to the STUN server and it responds with the source IP address and port specified inside them. The application can compare its own endpoint with the source endpoint observed by the STUN server and if the values differ, it can be inferred that they were rewritten by a NAT. Additional STUN servers are contacted to determine if the NAT maps IPs and ports in a predictable fashion. UDP hole punching is a related technique that, depending on the NAT types, can allow direct communication between two applications behind separate NATs. The applications must discover each other's externally mapped endpoints, perhaps via the STUN server. If the NATs use the same external port regardless of the remote destination, the two applications can simultaneously send UDP packets to each other's external endpoints. Their respective NATs will see the outgoing connection to the other peer - the "punched hole" - when the incoming traffic arrives from it and forward it correctly. NATs that map different ports per remote destination sometimes allocate port numbers predictably, which can be used by the peers to try to guess the port that will be opened by the opposing side's NAT.

![NAT traversal via STUN\label{nat-traversal}](../figures/nat-traversal.png){ height=25% }

In mobile networks like 4G and 5G, the \gls{isp} often utilizes a **\gls{cgnat}** as part of their infrastructure, while all devices under the user's control, including the router, only have local IP addresses. STUN techniques would fail to discover a direct path between two parties behind separate CGNATs or other unpredictable NAT algorithms. The only remaining possibility is to relay the traffic via a publicly reachable third-party host. \todo{only ~65000 ports per IP address means that CGNATs that provide more than 65000 connections from client devices require more than one public IP address}

\todo{hairpinning - Hairpinning, also known as NAT loopback or NAT reflection, is a technique used by NAT devices to allow hosts on a private network to access a public server using its public IP address. Without hairpinning, the NAT device would not recognize the connection as a loopback connection and would route it to the public network, causing the connection to fail. With hairpinning, the NAT device recognizes that the connection is a loopback connection and redirects the traffic back to the same NAT device, which then forwards the traffic to the correct host on the private network. This can be useful in scenarios where a private network is hosting a public-facing server that is also accessed by internal users on the same network using its public IP address.}

### Communication Security


**\acrfull{tls}** and its precursor \gls{ssl} provide secure communications to Application Layer (L7) protocols.  to  on top of a reliable transport protocol like TCP; \gls{dtls} is a related protocol that works with connectionless protocols like UDP. TLS does not strictly fit in any single OSI layer but it is usually placed somewhere between the Transport Layer (L4) and the Presentation Layer (L6). It is rather complex because it needs to support many possible use cases while remaining backward compatible.  \todo{tls certificates} \todo{protects against man in the middle} \todo{an intruder can't see the encrypted traffic, but can see the IP addresses of the servers that are being contacted} The **Noise Protocol Framework** [@noiseDocs] is a more \todo{noise is transport agnostic} \todo{noise has limited cipher suites} recent effort that applies the ideas of TLS in a simplified way by serving as a blueprint for designing use-case specific protocols for establishing secure communication channels based on \gls{ecdh} handshake patterns. It powers the end-to-end encryption in messaging applications such as WhatsApp and Signal, and \gls{vpn} software such as WireGuard and Nebula.

***HTTPS*** is an extension to \gls{http} that uses TLS for encryption.

\todo{talk about https}

**\acrfull{ipsec}** is a protocol suite for encrypting the IP datagrams between two hosts. It was originally developed as part of IPv6 but can also be used with IPv4. IPSec is similar in purpose to TLS but operates at the Network Layer (L3). 

\todo{tls requires the clients to be configured with a certificate for the server, IPSec needs to server to also be configured with a certificate for the client.}

\todo{tls works in browsers, IPSec works at the OS level}

\todo{The Internet Protocol Security (IPSec) protocol suite is designed specifically to provide secure communication between two hosts at the network layer (L3) of the OSI model. IPSec can be used to secure traffic between two hosts, between a host and a network, or between two networks. It provides a range of services, including data confidentiality, data integrity, and authentication, and is often used in Virtual Private Network (VPN) connections to create secure tunnels between remote networks. IPSec operates in either Transport or Tunnel mode, and can use either the Authentication Header (AH) or Encapsulating Security Payload (ESP) protocols to provide its security services.}

- **\acrfull{ipsec}**
  - Layer 3 protocol suite part of the Internet Protocol Suite
  - used inside VPN software
  - has implementations in both user and kernel space as well as hardware implementations
  - rewrites and encrypts the IP headers and payloads
  - virtual routing table
  - Initially was built into IPv6, separate from IPv4



## Network overlays {#sec:overlays}


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

\todo{tls vs ipsec vpns. TLS vpns offer a virtual network interface at layer 3, but run over L7 TLS }

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
Nebula and Tailscale are both business driven. Tailscale was started by some high-profile ex-googlers and is the most end-user-focused of the three, providing a service that allows people to sign up using identity providers such as Google, Microsoft, GitHub and others. They also provide an Admin console that allows a user to easily add their personal devices to a network or share them with others. It also has support for automation tools like Terraform for creating authorization keys and managing an \gls{acl} based firewall.
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
