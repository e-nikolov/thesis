
## OSI Model

- Create a figure that maps the various related components to OSI model layers
- It can be a "more or less accurate" artistic impression since the components can cover multiple layers and the layers are somewhat fluid


![test](../figures/osi-model-2.png){height=30% width=50%} ![test2](../figures/osi-model-1.png){height=30% width=40% }

The Open Systems Interconnection (OSI) model distinguishes 7 layers in computer networks:



\newpage

| OSI Layer       | Description                                                              |          Protocols          | Network overlays                                                             |
|---|--------|--|---|
| 7. Application  | High level protocols                                                                                           | HTTP, HTTPS, DNS, FTP, SMTP | WebRTC, OpenZiti, ngrok, TOR, BitTorrent, Ethereum, Teleport, Freenet |
| 6. Presentation | Translation of data between a networking service and an application, e.g. encoding, compression, encryption           |       MIME, TLS*        |     Noise Protocol Framework                                                                  |
| 5. Session      | continuous exchange of information                                                                             |                             |                                                                       |
| 4. Transport    | Variable length data over a network while maintaining quality-of-service, e.g. ports, connections, packet splitting |          UDP, TCP           |                                                                       |
| 3. Network      | data packets between two nodes, routed via a path of other nodes, e.g. addressing, routing                |          IP, ICMP           | OpenVPN, IPSec, Tinc, Wireguard, Tailscale, Nebula, ZeroTier                                       |
| 2. Data link    | data frames between two nodes, directly connected via a physical layer                                         |                             | N2N                                                                   |
| 1. Physical     | sending raw bits over a physical medium                                                                        |                             |                                                                       |

- Layer 7 - Application - high level protocols
	- Protocols
		- HTTP
		- HTTPS
		- DNS
		- FTP
		- SMTP
	- Solutions
		- WebRTC
		- OpenZiti
		- ngrok
		- TOR
		- BitTorrent
		- IPFS
		- Ethereum
		- Teleport
		- Freenet
- Layer 6 - Presentation - Translation of data between a networking service and an application
	- Concepts
		- encoding
		- compression
		- encryption
	- Protocols
		- MIME
		- SSL/TLS*
	- Solutions
		- Noise Protocol Famework
- Layer 5 - Session - continuous exchange of information
- Layer 4 - Transport - Variable length data over a network while maintaining quality-of-service
	- Concepts:
		- Ports
		- Stateful Connections / Connectionless
		- Splitting of variable length data into multiple smaller packets
	- Protocols:
		- TCP
		- UDP
- Layer 3 - Network - data packets between two nodes, routed via a path of other nodes 
	- Concepts:
		- Routing
		- IP Addresses
	- Protocols:
		- IP
		- ICMP
	- Solutions
		- IPSec
		- OpenVPN
		- Tinc
		- Wireguard
- Layer 2 - Data link - data frames between two nodes, directly connected via a physical layer
	- Solutions
		- OpenVPN in network bridge mode
		- Tinc
		- N2N
- Layer 1 - Physical - sending raw bits over a physical medium




- Resources
	- [The OSI model doesn't map well to TCP/IP](https://jvns.ca/blog/2021/05/11/what-s-the-osi-model-/)
	- 