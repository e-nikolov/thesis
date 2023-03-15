# Related work

In this chapter we will provide a high level overview of the solutions that will be analyzed in more detail in the following chapters.
There is a large body of existing protocols and applications that are relevant to our problem of connecting the parties of a multiparty computation over the internet. To make reviewing them easier, we will try to approximately map them to the 7 layers of the OSI model, which will not always be entirely accurate because many protocols and applications implement aspects of several layers. The table below 

| OSI Layer       | Description                                                              |          Protocols          | Network overlays                                                             |
|---|--------|--|---|
| 7. Application  | High level protocols that user-facing services use                                                                                        | HTTP, HTTPS, DNS, FTP, SMTP | WebRTC, OpenZiti, Teleport, ngrok, TOR, BitTorrent, IPFS, Ethereum, Freenet |
| \hline 6. Presentation | Translation of data between a networking service and an application, e.g. encoding, compression, encryption           |       MIME, TLS*, Noise       |                                                                       |
| \hline 5. Session      | Session setup, management, teardown, authentication, authorization                                                                            |          SOCKS, X.225                   |                                                                       |
| \hline 4. Transport    | Sending data of variable length over a network while maintaining quality-of-service, e.g. ports, connections, packet splitting |          UDP, TCP, NAT port mapping           |                                                                       |
| \hline 3. Network      | Sending data packets between two nodes, routed via a path of other nodes, e.g. addressing, routing                |          IP, ICMP, NAT           | TUN driver, IPSec, OpenVPN, Tinc, Wireguard, Tailscale, Nebula, ZeroTier                                       |
| \hline 2. Data link    | Sending data frames between two nodes, directly connected via a physical layer, e.g. on a LAN                                         |     MAC, L2TP                        | TAP driver, N2N, OpenVPN, Tinc                                                                   |
| \hline 1. Physical     | Sending raw bits over a physical medium                                                                        |     RS232, Ethernet, WiFi, USB, Bluetooth                        |                                                                       |



## Internet protocol

### IPv4 routing

#### NAT

### NAT Traversal

#### STUN and TURN

!["Two parties behind separate NATs"\label{nat-intro}](../figures/nat-intro.png "Two parties behind separate NATs" ){ height=25% width=50% }

As we mentioned in the introduction chapter, the devices in a typical home network can only initiate connections to public endpoints (via \gls{nat}) but cannot be discovered from outside their \gls{lan}. This poses a challenge when two parties who want to communicate via a direct link are both behind separate \glspl{nat} \ref{nat-intro} and neither can be contacted by the other one first. Mesh \glspl{vpn} solve this issue via \gls{nat} traversal techniques such as \gls{udp} hole punching based on concepts from \gls{stun}. The machines of each party can contact a public \gls{stun} server \ref{nat-traversal}, which will note what \gls{ip} addresses the connections come from and inform the parties. Since the parties initiated the connection to the STUN server, their routers will keep a mapping between their local IP addresses and the port that was allocated for the connection in order to be able to forward the incoming traffic. Those "holes" in the NATs were originally intended for the STUN server, but mesh VPNs use the stateless "fire and forget" UDP protocol for their internal communication, which does not require nor provides a mechanism for the NATs to verify who sent a UDP packet. With most NATs, this is enough to be able to (ab)use the "punched holes" for the purpose of \gls{p2p} traffic from other parties. Mesh VPNs implement the stateful \gls{tcp} and \gls{tls} protocols on top of UDP and expose an regular network interface to the other programs, keeping them shielded from the underlying complexities. Other NAT implementations such as Symmetric NAT and \glspl{cgnat} can be more difficult to "punch through" due to their more complex port mapping strategies. In those cases, establishing P2P connections might involve guess work or even fail and require falling back to routing the (encrypted) traffic via another party or service. 

!["NAT traversal via STUN"\label{nat-traversal}](../figures/nat-traversal.png "NAT traversal via STUN" ){ height=25% width=50% }


## Network overlays

### TUN/TAP driver


### Traditional VPNs

\glspl{vpn} are implemented as Layer 2 or 3 network overlays. They are commonly used for securely connecting machines from different \glspl{lan}. They provide software emulation of a network device on the operating system level and allow other software to transparently use the functionality of the \gls{ip} suite without requiring extra changes. Traditional \glspl{vpn} such as IPSec[@ipSecDocs] and OpenVPN[@openVPNDocs] use a centralized service that all (encrypted) client communications must pass through. This introduces a single point of failure and a potential bottleneck that might negatively impact the performance of the multi-party computations due to their \gls{p2p} nature.


### Wireguard

Wireguard[@donenfeldWireGuardNextGeneration2017] is a VPN protocol built with the Noise Protocol Framework[@noiseProtocol] that focuses on configuration simplicity. It considers issues such as peer discovery and key distribution as out of scope and a responsibility of a higher level system that uses Wireguard as a building block. The snippets below show a minimal set of configuration options that need to be provided in order for two peers to be able to form secure tunnels with each another.

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
Each peer has a public/private key pair that is used for authentication and encryption. The `Address` field specifies the virtual IP address that the local network interface will use, while the `AllowedIPs` field specifies what virtual IP addresses are associated with a peer's public key. A peer's `Endpoint` field specifies the URL at which it can be reached. Only one of the peers must be configured with a reachable endpoint for the other peer. In the above example once `peer1`  initiates communication with `peer2`, `peer2` will learn the current endpoint of `peer1` and will be able to communicate back with it.


### Mesh VPNs


- Tinc
- N2N
- Tailscale
- Nebula
- ZeroTier


Mesh \glspl{vpn} such as Tinc[@tincDocs], Tailscale[@tailscaleDocs] and Nebula[@nebulaDocs] utilize NAT Traversal techniques in order to create direct \gls{p2p} links between the clients for the data traffic. Authentication, authorization and traffic encryption are performed using certificates based on public key cryptography. 

All three are open-source, with the exception of Tailscale's coordination service which handles the peer discovery and identity management. Headscale [@fontJuanfontHeadscale2022] is a community driven open-source alternative   for that component. Tinc is the oldest of the three but has a relatively small community. It is mainly developed by a single author and appears to be more academic than industry motivated. 
Nebula and Tailscale are both business driven. Tailscale was started by a number of high profile ex-googlers and is the most end-user focused of the three, providing a service that allows people to sign up using a variety of identity providers including Google, Microsoft, GitHub and others. They also provide an Admin console that allows a user to easily add their personal devices to a network or share them with others. It also has support for automation tools like Terraform for creating authorization keys and managing an \gls{acl} based firewall.
Nebula was originally developed at the instant messaging company Slack to create overlay networks for their cross region cloud infrastructure, but the authors later started a new company and are currently developing a user-centric platform similar to Tailscale's.  Nebula is more customizable than Tailscale and since it is completely open-source it can be adapted to different use cases, but it is also more involved to set up. A certificate authority needs to be configured for issuing the identities of the participating hosts. Furthermore, publicly accessible coordination servers need to be deployed to facilitate the host discovery.
Tailscale employs a distributed relay network of \gls{derp} servers, while Nebula can be configured to route via one of the other peers in the VPN.


### Layer 7 overlays

- WebRTC
- OpenZiti
- ngrok
- TOR
- BitTorrent
- IPFS
- Ethereum
- Teleport
- Freenet
