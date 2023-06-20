
# The State of Multiparty Communications over the Internet

\todo{include a section on MPC?}

<!-- This chapter aims to provide a brief overview of prior work related to multiparty connectivity over the Internet and their suitability for joint MPyC computations.  on the fundamentals of Internet communications, highlighting the challenges faced in communications between multiple independent parties. Additionally,  a systematic overview of the available solutions. -->

<!-- This chapter provides background information on the challenges of Internet communications between multiple independent parties. It also presents a systematic overview of the available solutions, using the \gls{osi} reference model as a conceptual framework. [Section @sec:internet] briefly explores the fundamentals of the Internet, its protocols, the limitations for peer-to-peer protocols, and some of the approaches to overcome them. [Section @sec:overlays] discusses higher-level overlay networks that build on top of the lower-level protocols from [section @sec:internet]. -->


<!-- The presented solutions will be mapped to the layers of the \gls{osi} model. While many protocols implement aspects of several layers and do not strictly fit inside the OSI model, it is still a useful tool for comparing them. -->

## Internet Communications {#sec:internet}

\todo{Is there a more fitting section name than "The Internet"}

This chapter provides important background information on secure Internet communications, the challenges to multiparty communications and the approaches to overcome them.

The Internet is a global network that consists of numerous interconnected computer networks spanning billions of host devices owned by diverse parties from around the world. Key components of the Internet include the Internet Protocol Suite (known as TCP/IP) and the physical infrastructure that connects the individual networks. Sections of the infrastructure are deployed and managed by different tiers of \glspl{isp} who also maintain links between each other. To ensure efficient utilization of the hardware, the Internet relies on packet-switching techniques that divide the data traffic into smaller individually processed **packets**.

<!-- that are handled individually by the network infrastructure. The individual packets can be retransmitted in case of errors and may be routed via different paths to their destination before being reassembled there to restore the original data. Packet switching allows for more efficient use of the underlying hardware and better reliability. -->





<!-- The Internet Protocol Suite utilizes packet-switching, meaning that application layer communications are broken into smaller discrete packets that are handled individually by the network infrastructure. A protocol typically has a \gls{pdu} that describes the information that  c has a header  i  A packet contains multiple nested a header and a payload, where the header identifies the protocol that  that  which protocol which protocols are involvedhierarchically organized information from the protocols.   identifies  information that identifies its from the various communication protocols with each protocol having its own \gls{pdu}. 
The various protocols have their own \glspl{pdu} that have a header that ide  -->



![OSI model mapping of the Internet Protocol Suite\label{osi-map-tcp}](../figures/osi-map-tcp.drawio.pdf){width=100% }

Communication protocols are usually organized into abstraction layers based on the scope of their functionality with higher-layer protocols relying on the services provided by the lower-layer protocols. Several reference models define different layering schemes, for example, the OSI model recognizes 7 layers, while TCP/IP itself combines some of the layers and recognizes 4. Figure \ref{osi-map-tcp} shows how the two models relate to each other and describes the responsibilities of the various layers. Throughout this thesis, we will refer to the 7 layer numbers of the OSI model as they are more widely used in the literature.

The packets that are transmitted over the network contain information from multiple protocols organized in \glspl{pdu} with the lower-layer PDUs **encapsulating** the higher-layer PDUs as a (usually opaque) **payload**. Additionally, the PDU of a protocol contains control information for the protocol itself in the form of a **header** or **footer**.

Services that are implemented as Application layer (L7) protocols on top of TCP/IP include the \gls{www}, file transfer (\as{ftp}), email (\as{smtp}), instant messaging, remote access (\as{ssh} [@sshRFC]) and others. The Web is a collection of interconnected documents that use Web technologies such as \as{html} and JavaScript. It is typically accessed via a user-agent software such as a **Web Browser**.

<!-- 
The \gls{www} or simply the Web is a collection of interconnected documents, e.g. HTML Web Pages, available on the Internet and is typically accessed via a user-agent software such as a **Web Browser**. The term "the Web" is sometimes used interchangeably with the Internet, but the Internet supports other services as well, e.g. file transfer (FTP), email (SMTP), instant messaging, remote access (SSH) and others. -->


<!-- Conceptual frameworks like the \gls{osi} model are useful for understanding the objectives and functions of communication protocols. Figure \ref{osi-map-tcp} describes the responsibilities of the 7 layers of the OSI model and how they relate to the TCP/IP model used by the Internet Protocol Suite. The newer TCP/IP model only recognizes 4 layers as it merges the OSI Session (L5) and Presentation (L6) layers into the Application layer (L7), as well as the Physical layer (L1) into the Data link layer (L2). While the TCP/IP model is a more accurate representation of the Internet, the 7-layer numbers of the OSI model are still widely used in the literature.  -->

<!-- 
The Internet is a global multi-tiered computer network of billions of host devices that communicate using the protocols of the Internet Protocol Suite (TCP/IP). \glspl{isp} are responsible for managing different sections of the infrastructure that connects the \glspl{lan} of various end-users including households and enterprises.  -->





The following sub-sections will briefly cover the main protocols of the Internet Protocol Suite, the issues for multiparty communications and some of the low-level mitigation techniques.

\todo{add a paragraph that describes what the rest of the section will contain}
<!-- IP -->
### Communication Protocols

#### Network Layer (L3)

The \as{ip} [@ipv4RFC] is a Network layer (L3) protocol of the Internet Protocol Suite that is responsible for transferring datagrams between devices across the boundaries of their \glspl{lan} by possibly routing them via multiple intermediate devices (e.g. routers). A datagram is a self-contained unit of data, typically associated with connectionless protocols that provide no guarantees for delivery or ordering (e.g. IP, UDP). \todo{packet is the physical envelope of the IP datagram} IP datagrams have a header that contains fields such as the **IP addresses** of its source and destination, and a \todo{show a diagram of the internet with multiple local networks} payload that encapsulates the data from the Transport Layer (L4) protocols. A **router** is a device that is part of multiple networks and relays datagrams between them based on a routing table that maps IP address ranges to networks.

#### Transport Layer (L4)


\af{udp} is a very thin Transport layer (L4) protocol that only provides port multiplexing and checksumming on top of IP. 
 <!-- \af{udp} [@udpRFC] and \af{tcp} [@tcpRFC] are Transport layer (L4) protocols. -->
- Port multiplexing - uses 16-bit numbers to allow multiple processes behind the same IP address to establish their own communication channels
- Checksumming - used to detect errors in the datagram header and payload

As with IP, UDP packets are referred to as datagrams because they are not delivered reliably and if such features are required, they must be implemented by the consumer of the protocol.

\gls{tcp} is another Transport layer (L4) protocol. Like UDP, it provides port multiplexing and checksumming, but it offers stronger delivery guarantees. Some of the features it offers are listed below:

- Connection management - TCP establishes reliable connections between the communicating hosts and can gracefully terminate them when required
- Segmentation - TCP splits variable-length data streams into segments that fit inside IP datagrams and transmits them individually
- ordering - segments have sequence numbers to ensure that they are reassembled in the correct order at the receiving host
- Error detection and correction - TCP retransmits a segment if its checksum fails

Both TCP and UDP are useful in different scenarios. UDP is faster and is used for applications that can tolerate packet loss, e.g. video streaming, VoIP, or in cases where it is preferable for an application to implement its own reliable delivery. TCP has a higher overhead than UDP but its reliable delivery is a good default for most applications on the Internet.

\gls{quic} is a more recent Transport layer (L4) protocol that is built on top of UDP and offers similar features to TCP, but with lower latency in some scenarios. It provides an additional level of multiplexing within a process, which allows multiple streams of data to be sent over the same connection asynchronously. To better optimize the establishment of secure connections, QUIC is tightly coupled with \as{tls} version 1.3. One of the main uses of QUIC is inside \as{http} version 3.

<!-- \todo{
- QUIC - UDP-based protocol that provides reliable delivery, multiplexing, flow control, congestion control, and security


} -->

<!-- 
\todo{IP multiplexing via ports, TCP segments and segmentation, UDP no segmentation } employ 16-bit port numbers to enable multiple processes on the same host to establish their own communication channels while sharing an IP address. UDP offers faster communication, but only provides best-effort delivery, while TCP is a reliable transport protocol with stronger delivery guarantees at the expense of higher network latency. TCP maintains stateful connections that handle error detection and correction, packet ordering, flow control, acknowledgments and retransmissions in case packets are lost during transmission. -->

#### Application Layer (L7)

\gls{http} is an Application layer (L7) protocol that enables stateless request/response interactions on the Web between web servers and clients (e.g. browsers). Similar to other L7 protocols, it uses \glspl{url} for locating resources.

URL format:

: `scheme://host:port/path?query=value#fragment`

URL example:

: `http://www.example.com:80/path/to/file.html`. 


HTTP up to version 2 uses TCP as a transport protocol and since version 3 uses \as{quic}. HTTP provides several features such as:

- Request Methods - used by the client to specify the action to perform on the resource behind the given URL, e.g. GET, POST, PUT, DELETE, etc.
- Headers - used to provide additional information about a request or response, e.g. Content-Type, Authorization, Cache-Control
- Status codes - used to indicate the result of a request, e.g. if it was successful (200), or if the resource is missing (404)
- Cookies - used to include stateful information about the user kept on the client-side
- Caching - used to specify that the result of a request can be cached for a certain time to avoid repeating the request's action.

The \gls{dns} operates at the Application Layer (L7) and allows the conversion of human-readable domains to IP addresses, e.g. `google.com` to `142.250.179.142`.

### Secure Communication Protocols

The communication protocols from the previous section do not encrypt the payloads of their packets, which allows intruders and routers between the communicating hosts to see the data. This section provides an overview of protocols that provide security to those communication protocols.

#### Transport Layer (L4) to Application Layer (L7)

\af{tls} [@tlsRFC] and its precursor \gls{ssl} are protocols that provide secure communications to Application layer (L7) protocols on top of a reliable Transport layer (L4) protocol like \gls{tcp}. \gls{dtls} is a related protocol that works with connectionless transport protocols like \as{udp}. TLS is usually placed somewhere between the Presentation layer (L6) and the Transport layer (L4) because Application layer (L7) protocols use it as a transport protocol while having to manage the TLS connections. 

TLS relies on digital certificates and \gls{pki} to establish trust between the communicating parties and to prevent man-in-the-middle attacks. A certificate includes information such as:

- Subject - an identifiable name for the certificate's owner. Depending on the use case it can be a domain name, an IP address, an email address or others.
- Subject's public key - an asymmetric public key that is used by other parties to verify that they are communicating with the subject who is expected to be in control of the corresponding private key. The public key can also be used to encrypt messages that only the subject can decrypt.
- Issuer - an entity that is responsible for validating the identity of the subject. It is usually a \gls{ca} that is trusted by the consumer of the certificate, but in the case of a self-signed certificate, it can be the subject itself
- Issuer's signature - a signature of the certificate's contents using the issuer's private key

Trusted CAs that serve as the root of trust are usually included in the operating system or a Web browser. This allows applications to verify the certificates of the servers they communicate with. Web browsers use \gls{https} [@httpsRFC] - a variant of \gls{http} that uses TLS to secure the underlying \as{tcp} or \as{quic} connections of Web applications. The one-way approach where only the server has to authenticate itself to the clients is usually sufficient for most web interactions. TLS can also be used for mutual authentication, where both of the communicating parties have to present a valid certificate to each other, but this requires additional infrastructure to manage the client-side certificates. This mode of operations is sometimes used in Zero Trust networking, in microservice architectures and TLS-based \as{vpn} applications.

Due to asymmetric cryptography being computationally expensive, TLS uses a hybrid approach. The communicating parties use the asymmetric key/s and Diffie–Hellman key exchange to agree on a set of symmetric session keys for authentication and encryption/decryption of their data.

<!-- The key exchange is done using asymmetric cryptography and the symmetric key is used for the rest of the communication. The symmetric key is usually generated by the client and encrypted with the server's public key. The server can then decrypt the key and use it to encrypt the rest of the communication. The key exchange is done using a key exchange algorithm like \gls{dh} or \gls{ecdh}. The key exchange is followed by an authentication step where the server presents its certificate to the client. The client can then verify the certificate and authenticate the server. The client can also present its certificate to the server if mutual authentication is required. The client and the server then agree on a cipher suite that specifies the symmetric encryption algorithm, the message authentication algorithm, and the key exchange algorithm that will be used for the rest of the communication. The cipher suite also specifies the hashing algorithm that will be used for the digital signatures. The client and the server can then start exchanging encrypted messages. The TLS protocol is designed to be extensible and supports many different cipher suites and extensions. The handshake process of -->

TLS is rather complex because it needs to support many possible use cases while remaining backward compatible. It allows the negotiation of security parameters like cipher suits.

TLS operates at the Transport layer (L4) and above so it encrypts the application traffic, but not the IP datagrams. While an \as{isp} or an intruder with access to the network cannot decrypt the traffic to see what is being communicated, it could see which IP addresses are communicating with each other.

\af{ssh} is an Application layer (L7) protocol that allows a client to securely log in and execute commands on a remote server. It does not rely on TLS but uses similar cryptographic primitives. Both the client and the server must authenticate to each other using public-key cryptography or a password. The cryptographic material must be distributed via a side channel either manually or via automation tools.

  <!-- 
owneA party's identity can be verified via certificates that include a public key and  can prove its identity  that wishes to authenticate itself to another party presents a public key certificate, signed by a trusted **certificate authority**. The certificate authority is responsible for verifying the identity of the party and signing the certificate. The party that receives the certificate can verify its authenticity by checking the signature against the certificate authority's public key. The certificate authority's public key is usually included in the operating system or the browser. The certificate authority is also responsible for revoking certificates that are no longer valid. The following list contains some of the features that TLS provides: -->


<!-- despite it needing another Transport to work on top of. Application layer (L7) protocols use TLS as if it were a Transport layer protocol, despite it needing    does not strictly fit in any single OSI layer but it is usually placed somewhere between the Transport Layer (L4) and the Presentation Layer (L6) -->

<!-- \todo{tls certificates} \todo{protects against man in the middle} \todo{an intruder can't see the encrypted traffic, but can see the IP addresses of the servers that are being contacted} -->


<!-- 
\todo{talk about https} -->

#### Network Layer (L3)

<!-- and Data Link Layer (L2) -->

Network layer (L3) security protocols provide host-to-host security in Internet Protocol communications. Their implementations are usually configured in the operating systems of the hosts and are invisible to the higher-layer protocols that depend on the Internet Protocol.

##### IPSec

\af{ipsec} is a Network layer (L3) protocol suite that provides host-to-host secure communications between \as{ip} hosts. It  has two modes of operation:

<!-- This mode secures the direct traffic between two hosts. -->

- Transport mode - encrypts the payload of an IP datagram, but not the header. This mode secures the traffic between two network hosts, but similarly to \as{tls}, the routers between the hosts can still see the IP addresses of the hosts and the ports they are communicating on
- Tunneling mode - encrypts the entire IP datagram and encapsulates it in a new IP datagram with an unencrypted header. This mode is used for secure comm allows a host to decrypt the encapsulated   both the traffic  connection between a client and a server that can decrypt the encapsulated IP datagram and forward it to its destination.is often used to securely connect a client to a server that can decrypt the encapsulated IP datagrams and forward them to their destination. The client 


\todo{\as{vpn}  This way the VPN client can hide the IP addresses of the final destinations of the traffic from hosts between itself and the VPN server. Depending on the use case, the VPN server could either facilitate the client's secure access to other resources on the virtual network, or provide anonymity to the VPN client by hiding its IP address from the hosts its communicating with on the public Internet.}

IPSec always requires mutual authentication, unlike \as{tls}, where it is optional. Authentication can be achieved either via digital certificates, \glspl{psk} or others. 
<!-- encrypting the IP datagrams between two hosts. IPSec is similar in purpose to TLS but operates at the Network Layer (L3).  -->

<!-- \todo{tls requires the clients to be configured with a certificate for the server, IPSec needs to server to also be configured with a certificate for the client.} -->

<!-- \todo{tls works in browsers, IPSec works at the OS level} -->

\todo{The Internet Protocol Security (IPSec) protocol suite is designed specifically to provide secure communication between two hosts at the network layer (L3) of the OSI model. IPSec can be used to secure traffic between two hosts, between a host and a network, or between two networks. It provides a range of services, including data confidentiality, data integrity, and authentication, and is often used in Virtual Private Network (VPN) connections to create secure tunnels between remote networks. IPSec operates in either Transport or Tunnel mode, and can use either the Authentication Header (AH) or Encapsulating Security Payload (ESP) protocols to provide its security services.}

\todo{
- \af{ipsec}
  - Layer 3 protocol suite part of the Internet Protocol Suite
  - used inside VPN software
  - has implementations in both user and kernel space as well as hardware implementations
  - rewrites and encrypts the IP headers and payloads
  - virtual routing table
  - Initially was built into IPv6, separate from IPv4
}

##### OpenVPN Protocol

- 
- 
- 
-   

##### WireGuard


  WireGuard [@donenfeldWireGuardNextGeneration2017] is a more recent protocol with a design informed by lessons learned from IPSec and OpenVPN and a key management approach inspired by \as{ssh}. It is a lower-level protocol that focuses on configuration simplicity while network topology, peer discovery and key distribution are left as a responsibility of higher-level systems that use it as a building block. Wireguard is implemented as a Layer 3 overlay over UDP tunnels. WireGuard has both user-space implementations that use a TUN driver and also has direct support built into the Linux Kernel since version 5.6 (May 2020). The kernel implementation allows for better performance because it does not need to copy packets between the kernel and user-space memory.

  WireGuard's cryptography is based on the **Noise Protocol Framework**[@noiseDocs]. Noise is another recent effort that applies the ideas of TLS in a simplified way. It serves as a blueprint for designing use-case-specific protocols for establishing secure communication channels based on \gls{ecdh} handshake patterns. It powers the end-to-end encryption in messaging applications such as WhatsApp and Signal, and \gls{vpn} software such as WireGuard and Nebula.
\todo{elaborate} \todo{noise is transport agnostic} \todo{noise has limited cipher suites}
  
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
  
  \todo{ \gls{cidr} is a common notation for describing IP address ranges, e.g. `192.168.0.1/16`, where the number after the slash describes the bit-length of the fixed prefix for a subnet.}

### Challenges and Solutions for Multiparty Communications

The version of the Internet Protocol, that was originally deployed globally (IPv4), uses 32-bit numbers as IP addresses, allowing for around 4 billion unique addresses. Due to the popularity of the Internet, there are many more devices than available IPv4 addresses, which has caused challenges. IPv6 is a newer version of the protocol that uses a larger 128-bit address space which is sufficient for assigning 100 addresses for each atom on Earth. However, its adoption has been slow, as according to Google[@IPv6Google] as of 2023 around 41% of their users access their services over IPv6. Additionally, despite that IPv6 allows for all devices to be addressable on the Internet, for security reasons, most of them would use firewalls to block incoming remote traffic that is not associated with outgoing connections.

A widespread solution to the addressing problem is \gls{nat}. It allows many devices without globally unique IP addresses to initiate connections to publicly addressable devices on the Internet via a limited number of gateways that must have globally unique IP addresses. A NAT gateway replaces the local source IP address of each outgoing IP datagram with its own public IP address before passing it on to the next link on the way to the destination while maintaining a mapping between the source and destination IPs in a translation table. The destination host can then address its responses back to the NAT gateway's public IP address, which in turn replaces its own IP from the incoming datagrams with the IP of the local device and forwards them to it. If the IP datagrams encapsulate TCP/UDP packets, the gateway additionally rewrites the source and destination ports, which means that NAT techniques can be placed somewhere between Layers 3 and 4 of the OSI model.

The effect of NAT on connectivity is similar to an IPv6 firewall as they both allow devices on a local network to initiate bidirectional communication to remote devices with public IP addresses, but connections cannot be natively initiated by the remote devices. As Figure \ref{nat-intro} shows, it follows that when two devices are behind separate NATs, neither can contact the other first. **Client/Server** communication is less affected by this limitation because Servers are usually deployed to a public IP address that can be contacted by Clients with local IP addresses. **Peer-to-Peer** communication, however, is more challenging because the peers are often devices in separate residential networks behind different NATs. Several **NAT traversal** techniques try to solve this with different performance tradeoffs and success that varies depending on the NAT [@natBehaviorRFC] and its behavior when mapping ports and IP addresses. \todo{describe some of the nat behaviors, e.g. if the source IP address/port vary per destination are changed depending on the destination/port mapping algorithms, if it maps ports, IPs, whether the mapped IPs are different per destination and others.} 

![Two parties behind separate NATs\label{nat-intro}](../figures/nat-intro.png){ height=25% }

One approach based on the Client/Server model is to use a publicly addressable **relay** server that is contacted by the NATed devices and then forwards the Peer-to-Peer traffic to the intended recipient. Compared to direct communication, relaying results in a higher network latency due to the longer path that each packet must travel. Maintaining a relay server requires some technical expertise and may be costly depending on the expected throughput. Despite the drawbacks, relaying works under most networking scenarios and is therefore often used as a fallback in case all other approaches fail to find a direct path. Protocols such as \af{turn} [@turnRFC] and \af{derp} [@derpDocs] can be used to securely implement relaying.

The NAT gateway in many residential networks is a Router device under the customer's control that has a statically or dynamically assigned public IP address. Most routers can be manually configured through their admin page to forward all traffic that arrives at a given port to a specific device on the local network. Remote applications can then initiate a connection to the local device if they know the IP address of the router and the forwarded port. The manual configuration, however, can be inconvenient and many users may be unaware of that setting because it is not necessary for the more straightforward Client/Server communications. Some routers also support programmatic configuration of port forwarding via a Layer 7 protocol like \gls{upnp} or its successors \gls{nat-pmp} and \gls{pcp}. However, these protocols are not always supported and are often disabled by the local network administrators due to security concerns related to bugs in their implementation, vulnerable IOT devices on the local network or malicious programs being able to expose local devices to the internet.

\todo{connection reversal}

An efficient NAT traversal approach that works with some types of NATs is to use \gls{stun} [@stunRFC] in combination with \as{udp} hole punching (Figure \ref{nat-traversal}). STUN is a protocol operating at Layer 7 that allows a client application to detect the presence of NAT gateways on the network path to a public STUN server, and identify their types and the public IP address that they map to externally. The process usually involves the following steps:

- An application sends \as{udp} datagrams to the STUN server (1, 3 in fig. \ref{nat-traversal})
- The STUN server responds with the source IP address and port specified inside the datagrams (2, 4 in fig. \ref{nat-traversal})
- The application compares its own endpoint with the source endpoint observed by the STUN server and if the values differ, it can be inferred that they were rewritten by a NAT. Additional STUN servers are contacted to determine if the NAT maps IPs and ports in a predictable fashion. 

UDP hole punching is a related technique that, depending on the NAT types, can allow direct communication between two applications behind separate NATs. The applications must discover each other's externally mapped endpoints, perhaps via the STUN server. \todo{If, else?} If the NATs use the same external port regardless of the remote destination:

- The two applications simultaneously send UDP packets to each other's external endpoints (5 in fig. \ref{nat-traversal})
- Their respective NATs will process the outgoing packets to the other peer and create a port mapping for the reverse traffic - a "punched hole"
- When the incoming traffic from a peer arrives at the other peer's NAT, it will be forwarded correctly due to the port mapping that was created earlier 


NATs that map different ports per remote destination sometimes allocate port numbers predictably, which can be used by the peers to try to guess the port that will be opened by the opposing side's NAT.

\todo{Talk about traversal friendly NATs and unfriendly NATs}
\todo{add a bullet list with the steps in the STUN process and relate them to the step numbers in the figure}

![NAT traversal via STUN\label{nat-traversal}](../figures/nat-traversal.png){ height=25% }

In mobile networks like 4G and 5G, the \gls{isp} often utilizes a \gls{cgnat} as part of their infrastructure, while all devices under the user's control, including the router, only have local IP addresses. STUN techniques would fail to discover a direct path between two parties behind separate CGNATs or other unpredictable NAT algorithms. The only remaining possibility is to relay the traffic via a publicly reachable third-party host using a protocol similar to TURN. \todo{only ~65000 ports per IP address means that CGNATs that provide more than 65000 connections from client devices require more than one public IP address}

\todo{hairpinning - Hairpinning, also known as NAT loopback or NAT reflection, is a technique used by NAT devices to allow hosts on a private network to access a public server using its public IP address. Without hairpinning, the NAT device would not recognize the connection as a loopback connection and would route it to the public network, causing the connection to fail. With hairpinning, the NAT device recognizes that the connection is a loopback connection and redirects the traffic back to the same NAT device, which then forwards the traffic to the correct host on the private network. This can be useful in scenarios where a private network is hosting a public-facing server that is also accessed by internal users on the same network using its public IP address.}


\gls{ice} is a protocol that describes a standard way for peers to gather candidate addresses for direct communication via STUN and TURN and then exchange them via a signaling server. The protocol continuously checks which candidates provide the best connection and adjusts them.

\gls{webrtc} is a framework that allows peer-to-peer communications between Web applications in Web browsers. Web applications are normally limited to HTTP connections and cannot use raw UDP or TCP connections. WebRTC implements the ICE functionality in Web browsers and provides an API to Web applications. 


\todo[caption={webrtc}]{
- ICE

- encryption

- Reveals IP addresses
}

