#block[
= List of Figures
#block[
]
] <thesis__001-preamble.md>
#block[
== Introduction
<thesis__010-intro.md__introduction>
] <thesis__010-intro.md>
#block[
= The State of Multiparty Communications over the Internet
<thesis__020-internet.md__the-state-of-multiparty-communications-over-the-internet>
== Internet Communications
<thesis__020-internet.md__sec:internet>
This chapter provides important background information on secure
Internet communications, the challenges to multiparty communications and
the approaches to overcome them.

The Internet is a global network that consists of numerous
interconnected computer networks spanning billions of host devices owned
by diverse parties from around the world. Key components of the Internet
include the Internet Protocol Suite \(known as TCP/IP) and the physical
infrastructure that connects the individual networks. Sections of the
infrastructure are deployed and managed by different tiers of who also
maintain links between each other. To ensure efficient utilization of
the hardware, the Internet relies on packet-switching techniques that
divide the data traffic into smaller individually processed
#strong[packets];.

#figure([#box(width: 100%, image("thesis/../figures/osi-map-tcp.drawio.pdf"));],
  caption: [
    OSI model mapping of the Internet Protocol Suite
  ]
)

Communication protocols are usually organized into abstraction layers
based on the scope of their functionality with higher-layer protocols
relying on the services provided by the lower-layer protocols. Several
reference models define different layering schemes, for example, the OSI
model recognizes 7 layers, while TCP/IP itself combines some of the
layers and recognizes 4. Figure shows how the two models relate to each
other and describes the responsibilities of the various layers.
Throughout this thesis, we will refer to the 7 layer numbers of the OSI
model as they are more widely used in the literature.

The packets that are transmitted over the network contain information
from multiple protocols organized in with the lower-layer PDUs
#strong[encapsulating] the higher-layer PDUs as a \(usually opaque)
#strong[payload];. Additionally, the PDU of a protocol contains control
information for the protocol itself in the form of a #strong[header] or
#strong[footer];.

Services that are implemented as Application layer \(L7) protocols on
top of TCP/IP include the , file transfer \(), email \(), instant
messaging, remote access \( #cite(<sshRFC>);) and others. The Web is a
collection of interconnected documents that use Web technologies such as
and JavaScript. It is typically accessed via a user-agent software such
as a #strong[Web Browser];.

The following sub-sections will briefly cover the main protocols of the
Internet Protocol Suite, the issues for multiparty communications and
some of the low-level mitigation techniques.

=== Communication Protocols
<thesis__020-internet.md__communication-protocols>
==== Network Layer \(L3)
<thesis__020-internet.md__network-layer-l3>
The #cite(<ipv4RFC>) is a Network layer \(L3) protocol of the Internet
Protocol Suite that is responsible for transferring datagrams between
devices across the boundaries of their by possibly routing them via
multiple intermediate devices \(e.g.~routers). A datagram is a
self-contained unit of data, typically associated with connectionless
protocols that provide no guarantees for delivery or ordering \(e.g.~IP,
UDP). IP datagrams have a header that contains fields such as the
#strong[IP addresses] of its source and destination, and a payload that
encapsulates the data from the Transport Layer \(L4) protocols. A
#strong[router] is a device that is part of multiple networks and relays
datagrams between them based on a routing table that maps IP address
ranges to networks.

==== Transport Layer \(L4)
<thesis__020-internet.md__transport-layer-l4>
is a very thin Transport layer \(L4) protocol that only provides port
multiplexing and checksumming on top of IP. - Port multiplexing - uses
16-bit numbers to allow multiple processes behind the same IP address to
establish their own communication channels - Checksumming - used to
detect errors in the datagram header and payload

As with IP, UDP packets are referred to as datagrams because they are
not delivered reliably and if such features are required, they must be
implemented by the consumer of the protocol.

is another Transport layer \(L4) protocol. Like UDP, it provides port
multiplexing and checksumming, but it offers stronger delivery
guarantees. Some of the features it offers are listed below:

- Connection management - TCP establishes reliable connections between
  the communicating hosts and can gracefully terminate them when
  required
- Segmentation - TCP splits variable-length data streams into segments
  that fit inside IP datagrams and transmits them individually
- ordering - segments have sequence numbers to ensure that they are
  reassembled in the correct order at the receiving host
- Error detection and correction - TCP retransmits a segment if its
  checksum fails

Both TCP and UDP are useful in different scenarios. UDP is faster and is
used for applications that can tolerate packet loss, e.g.~video
streaming, VoIP, or in cases where it is preferable for an application
to implement its own reliable delivery. TCP has a higher overhead than
UDP but its reliable delivery is a good default for most applications on
the Internet.

is a more recent Transport layer \(L4) protocol that is built on top of
UDP and offers similar features to TCP, but with lower latency in some
scenarios. It provides an additional level of multiplexing within a
process, which allows multiple streams of data to be sent over the same
connection asynchronously. To better optimize the establishment of
secure connections, QUIC is tightly coupled with version 1.3. One of the
main uses of QUIC is inside version 3.

==== Application Layer \(L7)
<thesis__020-internet.md__application-layer-l7>
is an Application layer \(L7) protocol that enables stateless
request/response interactions on the Web between web servers and clients
\(e.g.~browsers). Similar to other L7 protocols, it uses for locating
resources.

/ URL format\:: #block[
`scheme://host:port/path?query=value#fragment`
]

/ URL example\:: #block[
`http://www.example.com:80/path/to/file.html`.
]

HTTP up to version 2 uses TCP as a transport protocol and since version
3 uses . HTTP provides several features such as:

- Request Methods - used by the client to specify the action to perform
  on the resource behind the given URL, e.g.~GET, POST, PUT, DELETE,
  etc.
- Headers - used to provide additional information about a request or
  response, e.g.~Content-Type, Authorization, Cache-Control
- Status codes - used to indicate the result of a request, e.g.~if it
  was successful \(200), or if the resource is missing \(404)
- Cookies - used to include stateful information about the user kept on
  the client-side
- Caching - used to specify that the result of a request can be cached
  for a certain time to avoid repeating the request’s action.

The operates at the Application Layer \(L7) and allows the conversion of
human-readable domains to IP addresses, e.g.~`google.com` to
`142.250.179.142`.

=== Secure Communication Protocols
<thesis__020-internet.md__secure-communication-protocols>
The communication protocols from the previous section do not encrypt the
payloads of their packets, which allows intruders and routers between
the communicating hosts to see the data. This section provides an
overview of protocols that provide security to those communication
protocols.

==== Transport Layer \(L4) to Application Layer \(L7)
<thesis__020-internet.md__transport-layer-l4-to-application-layer-l7>
#cite(<tlsRFC>) and its precursor are protocols that provide secure
communications to Application layer \(L7) protocols on top of a reliable
Transport layer \(L4) protocol like . is a related protocol that works
with connectionless transport protocols like . TLS is usually placed
somewhere between the Presentation layer \(L6) and the Transport layer
\(L4) because Application layer \(L7) protocols use it as a transport
protocol while having to manage the TLS connections.

TLS relies on digital certificates and to establish trust between the
communicating parties and to prevent man-in-the-middle attacks. A
certificate includes information such as:

- Subject - an identifiable name for the certificate’s owner. Depending
  on the use case it can be a domain name, an IP address, an email
  address or others.
- Subject’s public key - an asymmetric public key that is used by other
  parties to verify that they are communicating with the subject who is
  expected to be in control of the corresponding private key. The public
  key can also be used to encrypt messages that only the subject can
  decrypt.
- Issuer - an entity that is responsible for validating the identity of
  the subject. It is usually a that is trusted by the consumer of the
  certificate, but in the case of a self-signed certificate, it can be
  the subject itself
- Issuer’s signature - a signature of the certificate’s contents using
  the issuer’s private key

Trusted CAs that serve as the root of trust are usually included in the
operating system or a Web browser. This allows applications to verify
the certificates of the servers they communicate with. Web browsers use
#cite(<httpsRFC>) - a variant of that uses TLS to secure the underlying
or connections of Web applications. The one-way approach where only the
server has to authenticate itself to the clients is usually sufficient
for most web interactions. TLS can also be used for mutual
authentication, where both of the communicating parties have to present
a valid certificate to each other, but this requires additional
infrastructure to manage the client-side certificates. This mode of
operations is sometimes used in Zero Trust networking, in microservice
architectures and TLS-based applications.

Due to asymmetric cryptography being computationally expensive, TLS uses
a hybrid approach. The communicating parties use the asymmetric key/s
and Diffie–Hellman key exchange to agree on a set of symmetric session
keys for authentication and encryption/decryption of their data.

TLS is rather complex because it needs to support many possible use
cases while remaining backward compatible. It allows the negotiation of
security parameters like cipher suits.

TLS operates at the Transport layer \(L4) and above so it encrypts the
application traffic, but not the IP datagrams. While an or an intruder
with access to the network cannot decrypt the traffic to see what is
being communicated, it could see which IP addresses are communicating
with each other.

is an Application layer \(L7) protocol that allows a client to securely
log in and execute commands on a remote server. It does not rely on TLS
but uses similar cryptographic primitives. Both the client and the
server must authenticate to each other using public-key cryptography or
a password. The cryptographic material must be distributed via a side
channel either manually or via automation tools.

==== Network Layer \(L3)
<thesis__020-internet.md__network-layer-l3-1>
Network layer \(L3) security protocols provide host-to-host security in
Internet Protocol communications. Their implementations are usually
configured in the operating systems of the hosts and are invisible to
the higher-layer protocols that depend on the Internet Protocol.

===== IPSec
<thesis__020-internet.md__ipsec>
is a Network layer \(L3) protocol suite that provides host-to-host
secure communications between hosts. It has two modes of operation:

- Transport mode - encrypts the payload of an IP datagram, but not the
  header. This mode secures the traffic between two network hosts, but
  similarly to , the routers between the hosts can still see the IP
  addresses of the hosts and the ports they are communicating on
- Tunneling mode - encrypts the entire IP datagram and encapsulates it
  in a new IP datagram with an unencrypted header. This mode is used for
  secure comm allows a host to decrypt the encapsulated both the traffic
  connection between a client and a server that can decrypt the
  encapsulated IP datagram and forward it to its destination.is often
  used to securely connect a client to a server that can decrypt the
  encapsulated IP datagrams and forward them to their destination. The
  client

IPSec always requires mutual authentication, unlike , where it is
optional. Authentication can be achieved either via digital
certificates, or others.

===== OpenVPN Protocol
<thesis__020-internet.md__openvpn-protocol>
-
-
-
-

===== WireGuard
<thesis__020-internet.md__wireguard>
WireGuard #cite(<donenfeldWireGuardNextGeneration2017>) is a more recent
protocol with a design informed by lessons learned from IPSec and
OpenVPN and a key management approach inspired by . It is a lower-level
protocol that focuses on configuration simplicity while network
topology, peer discovery and key distribution are left as a
responsibility of higher-level systems that use it as a building block.
Wireguard is implemented as a Layer 3 overlay over UDP tunnels.
WireGuard has both user-space implementations that use a TUN driver and
also has direct support built into the Linux Kernel since version 5.6
\(May 2020). The kernel implementation allows for better performance
because it does not need to copy packets between the kernel and
user-space memory.

WireGuard’s cryptography is based on the #strong[Noise Protocol
Framework];#cite(<noiseDocs>);. Noise is another recent effort that
applies the ideas of TLS in a simplified way. It serves as a blueprint
for designing use-case-specific protocols for establishing secure
communication channels based on handshake patterns. It powers the
end-to-end encryption in messaging applications such as WhatsApp and
Signal, and software such as WireGuard and Nebula.

The snippets below show a minimal set of configuration options that need
to be provided for two peers to be able to form secure tunnels with each
other.

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

Each peer has a public/private key pair that is used for authentication
and encryption based on the Noise Protocol Framework #cite(<noiseDocs>);.
The `Address` field specifies the virtual IP address that the local
network interface will use, while the `AllowedIPs` field specifies what
virtual IP addresses are associated with a peer’s public key. A peer’s
`Endpoint` field specifies the URL at which it can be reached. Only one
of the peers must be configured with a reachable endpoint for the other
one. In the above example once `peer1` initiates communication with
`peer2`, `peer2` will learn the current endpoint of `peer1` and will be
able to communicate back with it.

=== Challenges and Solutions for Multiparty Communications
<thesis__020-internet.md__challenges-and-solutions-for-multiparty-communications>
The version of the Internet Protocol, that was originally deployed
globally \(IPv4), uses 32-bit numbers as IP addresses, allowing for
around 4 billion unique addresses. Due to the popularity of the
Internet, there are many more devices than available IPv4 addresses,
which has caused challenges. IPv6 is a newer version of the protocol
that uses a larger 128-bit address space which is sufficient for
assigning 100 addresses for each atom on Earth. However, its adoption
has been slow, as according to Google#cite(<IPv6Google>) as of 2023
around 41% of their users access their services over IPv6. Additionally,
despite that IPv6 allows for all devices to be addressable on the
Internet, for security reasons, most of them would use firewalls to
block incoming remote traffic that is not associated with outgoing
connections.

A widespread solution to the addressing problem is . It allows many
devices without globally unique IP addresses to initiate connections to
publicly addressable devices on the Internet via a limited number of
gateways that must have globally unique IP addresses. A NAT gateway
replaces the local source IP address of each outgoing IP datagram with
its own public IP address before passing it on to the next link on the
way to the destination while maintaining a mapping between the source
and destination IPs in a translation table. The destination host can
then address its responses back to the NAT gateway’s public IP address,
which in turn replaces its own IP from the incoming datagrams with the
IP of the local device and forwards them to it. If the IP datagrams
encapsulate TCP/UDP packets, the gateway additionally rewrites the
source and destination ports, which means that NAT techniques can be
placed somewhere between Layers 3 and 4 of the OSI model.

The effect of NAT on connectivity is similar to an IPv6 firewall as they
both allow devices on a local network to initiate bidirectional
communication to remote devices with public IP addresses, but
connections cannot be natively initiated by the remote devices. As
Figure shows, it follows that when two devices are behind separate NATs,
neither can contact the other first. #strong[Client/Server]
communication is less affected by this limitation because Servers are
usually deployed to a public IP address that can be contacted by Clients
with local IP addresses. #strong[Peer-to-Peer] communication, however,
is more challenging because the peers are often devices in separate
residential networks behind different NATs. Several #strong[NAT
traversal] techniques try to solve this with different performance
tradeoffs and success that varies depending on the NAT
#cite(<natBehaviorRFC>) and its behavior when mapping ports and IP
addresses.

#figure([#box(height: 25%, image("thesis/../figures/nat-intro.png"));],
  caption: [
    Two parties behind separate NATs
  ]
)

One approach based on the Client/Server model is to use a publicly
addressable #strong[relay] server that is contacted by the NATed devices
and then forwards the Peer-to-Peer traffic to the intended recipient.
Compared to direct communication, relaying results in a higher network
latency due to the longer path that each packet must travel. Maintaining
a relay server requires some technical expertise and may be costly
depending on the expected throughput. Despite the drawbacks, relaying
works under most networking scenarios and is therefore often used as a
fallback in case all other approaches fail to find a direct path.
Protocols such as #cite(<turnRFC>) and #cite(<derpDocs>) can be used to
securely implement relaying.

The NAT gateway in many residential networks is a Router device under
the customer’s control that has a statically or dynamically assigned
public IP address. Most routers can be manually configured through their
admin page to forward all traffic that arrives at a given port to a
specific device on the local network. Remote applications can then
initiate a connection to the local device if they know the IP address of
the router and the forwarded port. The manual configuration, however,
can be inconvenient and many users may be unaware of that setting
because it is not necessary for the more straightforward Client/Server
communications. Some routers also support programmatic configuration of
port forwarding via a Layer 7 protocol like or its successors and .
However, these protocols are not always supported and are often disabled
by the local network administrators due to security concerns related to
bugs in their implementation, vulnerable IOT devices on the local
network or malicious programs being able to expose local devices to the
internet.

An efficient NAT traversal approach that works with some types of NATs
is to use #cite(<stunRFC>) in combination with hole punching \(Figure ).
STUN is a protocol operating at Layer 7 that allows a client application
to detect the presence of NAT gateways on the network path to a public
STUN server, and identify their types and the public IP address that
they map to externally. The process usually involves the following
steps:

- An application sends datagrams to the STUN server \(1, 3 in fig.~)
- The STUN server responds with the source IP address and port specified
  inside the datagrams \(2, 4 in fig.~)
- The application compares its own endpoint with the source endpoint
  observed by the STUN server and if the values differ, it can be
  inferred that they were rewritten by a NAT. Additional STUN servers
  are contacted to determine if the NAT maps IPs and ports in a
  predictable fashion.

UDP hole punching is a related technique that, depending on the NAT
types, can allow direct communication between two applications behind
separate NATs. The applications must discover each other’s externally
mapped endpoints, perhaps via the STUN server. If the NATs use the same
external port regardless of the remote destination:

- The two applications simultaneously send UDP packets to each other’s
  external endpoints \(5 in fig.~)
- Their respective NATs will process the outgoing packets to the other
  peer and create a port mapping for the reverse traffic - a "punched
  hole"
- When the incoming traffic from a peer arrives at the other peer’s NAT,
  it will be forwarded correctly due to the port mapping that was
  created earlier

NATs that map different ports per remote destination sometimes allocate
port numbers predictably, which can be used by the peers to try to guess
the port that will be opened by the opposing side’s NAT.

#figure([#box(height: 25%, image("thesis/../figures/nat-traversal.png"));],
  caption: [
    NAT traversal via STUN
  ]
)

In mobile networks like 4G and 5G, the often utilizes a as part of their
infrastructure, while all devices under the user’s control, including
the router, only have local IP addresses. STUN techniques would fail to
discover a direct path between two parties behind separate CGNATs or
other unpredictable NAT algorithms. The only remaining possibility is to
relay the traffic via a publicly reachable third-party host using a
protocol similar to TURN.

is a protocol that describes a standard way for peers to gather
candidate addresses for direct communication via STUN and TURN and then
exchange them via a signaling server. The protocol continuously checks
which candidates provide the best connection and adjusts them.

is a framework that allows peer-to-peer communications between Web
applications in Web browsers. Web applications are normally limited to
HTTP connections and cannot use raw UDP or TCP connections. WebRTC
implements the ICE functionality in Web browsers and provides an API to
Web applications.

] <thesis__020-internet.md>
#block[
== Overlay Networks
<thesis__022-overlays.md__sec:overlays>
An #strong[overlay network] is a higher-order solution that provides
additional networking functionality on top of an existing underlay
network like the Internet. From the point of view of its consumers, an
overlay network may appear at a lower OSI layer, despite being
implemented using protocols from higher layers. For example can provide
virtual interfaces to the Operating System at the Link layer \(L2) or
Network layer \(L3) while being implemented on top of a Transport layer
\(L4) protocol like or a Presentation layer \(L6) protocol like .
Virtual IP addresses can be assigned to the hosts and applications that
are already designed to work with TCP/IP can directly use the virtual
network interfaces via the regular TCP/IP mechanisms provided by the
operating system.

Other overlay networks are both implemented and used at the Application
layer \(L7). To communicate via such an overlay network, applications
often have to implement specific functionality in their software by
utilizing a framework or a library.

Figure shows an approximate OSI model mapping of several protocols and
network overlay solutions from the point of view of the systems that use
them and the arrows show dependency relations between them.

#figure([#box(height: 90%, image("thesis/../figures/osi-map-overlays.drawio.pdf"));],
  caption: [
    OSI model mapping of various protocols
  ]
)

=== Data Link Layer \(L2) and Network Layer \(L3)
<thesis__022-overlays.md__data-link-layer-l2-and-network-layer-l3>
==== Client/Server VPNs
<thesis__022-overlays.md__clientserver-vpns>
Layer 2 virtual networks provide a virtual network switch that allows
remote machines to be on the same virtual LAN and share the same IP
address range. Layer 3 virtual networks provide a virtual network router
that allows remote machines to be on separate LANs. Depending on the
specific implementation, the overlay network can either be implemented
directly in the Operating System’s kernel, or on top of a driver like or
.

- Layer 2 vs Layer 3 Networks
  - Layer 2 overlay networks bridge other networks
    - virtual network switch
    - remote machines are on the same virtual LAN and can share the same
      IP address range
    - allows broadcast/multicast
    - TAP driver
  - Layer 3 overlays route traffic between separate local networks
    - virtual network router

    - remote machines are on separate LANs

    - simpler to configure

    - TUN driver

    - the low-level solutions from the previous section are complex to
      set up.

    - overlay networks package some of those solutions for a specific
      use case Most overlay networks use a combination of the NAT
      traversal techniques mentioned previously. They can be placed in
      Layers 2, 3 or 7. Layer 2 overlays act as a virtual network
      switch, while Layer 3 overlays act as a virtual network router.
      Layer 7 overlays are implemented in user-space as libraries or
      applications that run on top of the network stack of the host
      operating system. Layer 2 and 3 overlays can either be implemented
      as kernel modules or as user-space applications that use a
      #strong[TUN/TAP] driver to interface with the kernel.

    - The term "VPN" is somewhat overloaded as it can refer to different
      related concepts.

    are implemented as Layer 2 or 3 network overlays. They are commonly
    used for securely connecting machines from different . They provide
    software emulation of a network interface controller via a TUN/TAP
    driver on the operating system level and allow other software to
    transparently use the functionality of the suite without requiring
    extra changes. Traditional such as IPSec #cite(<ipSecRFC>) and
    OpenVPN #cite(<openVPNDocs>) use a centralized service that all
    \(encrypted) client communications must pass through. This
    introduces a single point of failure and a potential bottleneck that
    might negatively impact the performance of the multiparty
    computations due to their nature.

===== OpenVPN Client/Server
<thesis__022-overlays.md__openvpn-clientserver>
We already discussed the VPN protocol behind OpenVPN. Here we will go
into the client and server software and how they are implemented and
discuss the typical network topologies.

==== Mesh VPNs
<thesis__022-overlays.md__mesh-vpns>
- Tinc
- N2N
- Tailscale
- Nebula
- ZeroTier

Mesh such as Tinc #cite(<tincDocs>);, Tailscale #cite(<tailscaleDocs>)
and Nebula #cite(<nebulaDocs>) utilize NAT Traversal techniques to
create direct links between the clients for the data traffic.
Authentication, authorization and traffic encryption are performed using
certificates based on public key cryptography.

All three are open-source, except Tailscale’s coordination service which
handles peer discovery and identity management. Headscale
#cite(<fontJuanfontHeadscale2022>) is a community-driven open-source
alternative for that component. Tinc is the oldest of the three but has
a relatively small community. It is mainly developed by a single author
and appears to be more academic than industry motivated. Nebula and
Tailscale are both business driven. Tailscale was started by some
high-profile ex-googlers and is the most end-user-focused of the three,
providing a service that allows people to sign up using identity
providers such as Google, Microsoft, GitHub and others. They also
provide an Admin console that allows a user to easily add their personal
devices to a network or share them with others. It also has support for
automation tools like Terraform for creating authorization keys and
managing an based firewall. Nebula was originally developed at the
instant messaging company Slack to create overlay networks for their
cross-region cloud infrastructure, but the authors later started a new
company and are currently developing a user-centric platform similar to
Tailscale’s. Nebula is more customizable than Tailscale and since it is
completely open-source it can be adapted to different use cases, but it
is also more involved to set up. A certificate authority needs to be
configured for issuing the identities of the participating hosts.
Furthermore, publicly accessible coordination servers need to be
deployed to facilitate the host discovery. Tailscale employs a
distributed relay network of servers, while Nebula can be configured to
route via one of the other peers in the VPN.

=== Application Layer \(L7)
<thesis__022-overlays.md__application-layer-l7>
==== OpenZiti
<thesis__022-overlays.md__openziti>
OpenZiti is a commercial product that provides an SDK for creating
overlay networks. It is developed by NetFoundry, a company that provides
a Software as a Service platform for creating and managing overlay
networks. The SDK is open-source and can be used to create custom
overlay networks. The SDK is written in Go and provides a high-level for
creating and managing the overlay network. It uses a centralized service
for peer discovery and identity management. The data traffic is routed
via a network of relays. The relays are hosted by NetFoundry and are not
open-source. The SDK is available for Go, Java, Python, C\# and C++.

- uses relays

==== LibP2P
<thesis__022-overlays.md__libp2p>
- libP2P
- ngrok
- TOR
- BitTorrent
- IPFS
- Ethereum
- Teleport
- Freenet

] <thesis__022-overlays.md>
#block[
== Digital Identities for Multiparty Computations
<thesis__025-identity.md__digital-identities-for-multiparty-computations>
Digital identity mechanisms provide standardized ways for referring to
entities in the context of digital interactions. We have already seen
some examples of digital identities in the previous chapter:

-  addresses - host identities at the Data link layer \(L2)
-  addresses - host identities at the Network layer \(L3)
- Digital Certificates - identities that can be cryptographically
  verified

Key concepts related to digital identity mechanisms include:

- Issuance - the process of assigning a digital identity to an entity.
  Often this involves a trusted third party like a government or a
  digital identity provider like Google or GitHub. Another option is
  where a user manages their own identity.
- Authentication - the process of verifying the identity of an entity
- Credentials - use case-specific attributes associated with an identity
- Authorization - the process of verifying if an identity’s owner is
  allowed to perform an action on a resource

Other notable examples include:

- Email addresses - identities for entities participating in email
  communications
- User names - user identities in various digital platforms that can be
  verified via a password
- ID cards - government-issued identity documents are increasingly able
  to support digital interactions
- Biometrics - used to prove an identity via sensor data

- IP addresses
  - Cryptographically Generated Addresses - rfc3972
  - Privacy Extensions - rfc4941
  - DNS
- MAC addresses
- Government
  - ID Cards / Passports
    - NFC
  - Estonia’s Digital Government
  - DigiD in NL
  -
- Certificates
- TLS
- IPSec
- WireGuard
- OpenID Connect
- Crypto currency addresses
  - Hierarchical Deterministic Keys
  - ENS
- Self-Sovereign Identity
  - Decentralized Identifiers
  - Verifiable Credentials
  - Identity Overlay Network \(ION) from Microsoft
    - DPKI
- Social Networks
  - Centralized
    - Facebook
    - Twitter
    - Reddit
  - Decentralized
    - Mastodon - Mastodon is an open-source, decentralized social
      networking platform that provides an alternative to traditional
      social media giants like Twitter. It operates on a federated
      model, which means that instead of being a single, centralized
      platform, it is a network of independently operated servers, known
      as "instances". Each instance hosts its own community with its own
      rules, but users on any instance can interact with users on other
      instances thanks to a common protocol, creating a connected,
      distributed social network.
    - Bluesky - An ex-twitter initiative to move away from centralized
      social media platforms, where a single organization controls the
      network. Instead, Bluesky aims to develop a standard protocol for
      social media that would enable the development of a variety of
      interoperable, decentralized platforms.
    - Nostr
- Identity Privacy

] <thesis__025-identity.md>
#block[
= Proof of Concepts and Evaluation
<thesis__030-methods.md__proof-of-concepts-and-evaluation>
== Testing methodology
<thesis__030-methods.md__testing-methodology>
In the following chapters, we will design and implement several
solutions for ad hoc MPC sessions based on a subset of the previously
discussed related works:

- Internet protocol
- Wireguard
- Tailscale
- Headscale
- ? Headscale with DID identity?
- ? WebRTC?
- A custom solution that automates the WireGuard configuration by
  visiting a web page

Additionally, we will analyze and compare them in terms of performance,
security and usability

=== Measuring performance
<thesis__030-methods.md__measuring-performance>
During the preparation phase of the project, we developed the framework
which simplifies and automates the process of deploying machines in
different geographical regions, connecting them via an overlay network
and executing multiparty computations between them, where each machine
represents a different party.

To summarize, is a set of scripts that use several automation tools:

- Terraform - declarative provisioning
- NixOS - declarative Linux distribution
- Colmena - declarative deployment for NixOS
- PSSH - parallel execution of remote scripts over ssh
- DigitalOcean - a cloud provider

It allows us to quickly provision cloud virtual machines in multiple
regions and reproducibly deploy all necessary software for running a
multiparty computation over a chosen network overlay solution. The
source code of can be found on
#link("https://github.com/e-nikolov/mpyc")[GitHub]

Each solution will be deployed using the framework and the performance
will be quantitatively measured in terms of the time it takes to execute
several MPyC demos. The selected demos have different complexities in
terms of communication rounds and message sizes which will allow us to
observe their impact on the overall performance.

+ Secret Santa - high round complexity with small messages
+ Convolutional Neural Network \(CNN) MNIST classifier - low round
  complexity with large messages

The demos will be configured at three different input size levels

- Low,
- Medium
- High

Furthermore, the demos will be executed in several networking scenarios:

+ 1-10 parties in the same geographic region
+ 1-10 parties evenly distributed across two nearby regions
+ 1-10 parties evenly distributed across two distant regions
+ 1-10 parties distributed across multiple distant regions

=== Security
<thesis__030-methods.md__security>
We will analyze aspects such as

- key distribution
- trust model - are there any trusted third parties and what would be
  the consequences if they are corrupted or breached
- traffic encryption
- identity strength

=== Usability
<thesis__030-methods.md__usability>
For each solution, we will describe the steps that the parties need to
perform to execute a joint multiparty computation. Those steps will be
analyzed in terms of:

- Complexity - how much technical expertise is expected from the parties
  to be able to execute the steps
- Initial effort - how much effort is each party expected to put in
  preparing for their first joint computation
- Repeated effort - after the initial setup, how much effort is required
  to perform another computation
  - with the same set of parties
  - with another set of parties
- Finalization effort - how much effort is required to finalize the MPC
  session once it is complete and clean up any left-over artifacts or
  resources so that the machine of each party is in its original state

] <thesis__030-methods.md>
#block[
== Internet Protocol based solution
<thesis__050-internet-protocol.md__internet-protocol-based-solution>
This solution focuses on directly using the internet protocol without
involving an overlay network. Our goal is to analyze the implications of
using only the functionalities that MPyC directly supports to serve as
the reference for our later experiments.

=== Implementation details
<thesis__050-internet-protocol.md__implementation-details>
We will manually set up the multiparty computations via the public IP
addresses of the machines and DNS.

=== Performance analysis
<thesis__050-internet-protocol.md__performance-analysis>
=== Security analysis
<thesis__050-internet-protocol.md__security-analysis>
=== Usability analysis
<thesis__050-internet-protocol.md__usability-analysis>
] <thesis__050-internet-protocol.md>
#block[
== WireGuard based solution
<thesis__060-wireguard.md__wireguard-based-solution>
This solution creates an overlay network by manually configuring
WireGuard on each machine.

=== Implementation details
<thesis__060-wireguard.md__implementation-details>
=== Performance analysis
<thesis__060-wireguard.md__performance-analysis>
=== Security analysis
<thesis__060-wireguard.md__security-analysis>
=== Usability analysis
<thesis__060-wireguard.md__usability-analysis>
] <thesis__060-wireguard.md>
#block[
== Tailscale based solution
<thesis__070-tailscale.md__tailscale-based-solution>
Tailscale is a VPN solution that configures a mesh of direct Wireguard
tunnels between the peers.

=== Implementation details
<thesis__070-tailscale.md__implementation-details>
=== Performance analysis
<thesis__070-tailscale.md__performance-analysis>
=== Security analysis
<thesis__070-tailscale.md__security-analysis>
==== Trust model
<thesis__070-tailscale.md__trust-model>
There is a centralized service that deals with the key distribution,
which needs to be trusted to provide the correct public keys for the
correct parties

==== Identity
<thesis__070-tailscale.md__identity>
Identity is based on third party identity providers such as Microsoft
and GitHub

- Magic DNS

- === Usability analysis
  <thesis__070-tailscale.md__usability-analysis>

With tailscale each party needs to

- register a Tailscale account
- Download and install tailscale on the machine they want to run a
  multiparty computation
- Run tailscale on their machine and logs into their account in order to
  link it to their own Tailnet
- Share their Tailscale machine with the Tailnets of each of the other
  parties
- Download the demo they want to run
- Form the flags for running the chosen demo
  - add -P \$HOST:\$PORT for each party using their Tailscale
    hostname/virtual IP
- Run the demo

] <thesis__070-tailscale.md>
#block[
== Headscale based solution
<thesis__080-headscale.md__headscale-based-solution>
This solution is similar to the Tailscale one, but it uses Headscale - a
self-hosted open-source alternative to the closed-source Tailscale
coordination service.

=== Implementation details
<thesis__080-headscale.md__implementation-details>
=== Performance analysis
<thesis__080-headscale.md__performance-analysis>
=== Security analysis
<thesis__080-headscale.md__security-analysis>
==== Trust model
<thesis__080-headscale.md__trust-model>
There still is a centralized service like in the Tailscale solution, but
here it is self-deployed.

==== Identity
<thesis__080-headscale.md__identity>
=== Usability analysis
<thesis__080-headscale.md__usability-analysis>
] <thesis__080-headscale.md>
#block[
== Web Based Solution
<thesis__090-mpyc-web.md__web-based-solution>
Web aaa based solution for running MPC in browsers on the client side
via WebAssembly and WebRTC for peer-to-peer connectivity.

The lifecycle of a message between the workers of 2 peers, "Peer A" and
"Peer B" looks like this:

#figure([#box(height: 90%, image("thesis/../figures/mpyc-web.png"));],
  caption: [
    MPyC Web
  ]
)

+ Python Worker on Peer A

  - creates a message that contains a secret share computed via the
    mpyc, which serializes it to binary via struct.pack\(). The
    resulting message is non-ascii, but when escaped can look like this:

  ```python
  b'\x06\x00\x00\x00\xc9\x93\\\xc0\xff\xff\xff\xff\x04\x00\x80\x99\x1b\x01'
  ```

  - worker calls a main thread function \(sendRuntimeMessage) via a
    coincident proxy and passes the serialized value, as well as the
    destination Peer’s ID \(Peer B). The worker does not need to await
    the result of this call, but it does because of xworker.sync.

+ Coincident handles the message by:

  - \(Worker) JSON.stringify\() -\> Atomics.wait\()
  - \(Main) JSON.parse\() -\> Run the Main Thread function -\>
    Atomics.notify\()

+ Main thread on Peer A fires an event to notify PeerJS that it needs to
  transport the message and immediately returns in order to not block
  the Worker

+ PeerJS serializes the message with some added fields via MessagePack
  and transmits it to Peer B

+ Main thread on Peer B receives the message and forwards it to the
  appropriate worker callback via coincident

+ Coincident does the JSON.stringify\() -\> Atomics.wait\() stuff \(?)
  from main to worker on Peer B

+ Worker on Peer B handles the message by passing it to an asyncio
  coroutine that is waiting for it or stores it for later use

=== Implementation details
<thesis__090-mpyc-web.md__implementation-details>
=== Performance analysis
<thesis__090-mpyc-web.md__performance-analysis>
=== Security analysis
<thesis__090-mpyc-web.md__security-analysis>
==== Trust model
<thesis__090-mpyc-web.md__trust-model>
There still is a centralized service like in the Tailscale solution, but
here it is self-deployed.

==== Identity
<thesis__090-mpyc-web.md__identity>
=== Usability analysis
<thesis__090-mpyc-web.md__usability-analysis>
] <thesis__090-mpyc-web.md>
