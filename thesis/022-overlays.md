## Overlay Networks {#sec:overlays}

An **overlay network** is a higher-order solution that provides additional networking functionality on top of an existing underlay network like the Internet. From the point of view of its consumers, an overlay network may appear at a lower OSI layer, despite being implemented using protocols from higher layers. For example \glspl{vpn} can provide virtual interfaces to the Operating System at the Link layer (L2) or Network layer (L3) while being implemented on top of a Transport layer (L4) protocol like \gls{udp} or a Presentation layer (L6) protocol like \gls{tls}. Virtual IP addresses can be assigned to the hosts and applications that are already designed to work with TCP/IP can directly use the virtual network interfaces via the regular TCP/IP mechanisms provided by the operating system. 

Other overlay networks are both implemented and used at the Application layer (L7). To communicate via such an overlay network, applications often have to implement specific functionality in their software by utilizing a framework or a library.

Figure \ref{osi-map-overlays} shows an approximate OSI model mapping of several protocols and network overlay solutions from the point of view of the systems that use them and the arrows show dependency relations between them.

![OSI model mapping of various protocols \label{osi-map-overlays}](../figures/osi-map-overlays.drawio.pdf){ height=90% }




### Data Link Layer (L2) and Network Layer (L3)

#### Client/Server VPNs 

Layer 2 virtual networks provide a virtual network switch that allows remote machines to be on the same virtual LAN and share the same IP address range. Layer 3 virtual networks provide a virtual network router that allows remote machines to be on separate LANs. Depending on the specific implementation, the overlay network can either be implemented directly in the Operating System's kernel, or on top of a driver like \as{tun} or \as{tap}.

- Layer 2 vs Layer 3 Networks
  - Layer 2 overlay networks bridge other networks
    - virtual network switch
    - remote machines are on the same virtual LAN and can share the same IP address range
    - allows broadcast/multicast
    - TAP driver
  - Layer 3 overlays route traffic between separate local networks
    - virtual network router
    - remote machines are on separate LANs
    - simpler to configure
    - TUN driver

    - the low-level solutions from the previous section are complex to set up. 
    - overlay networks package some of those solutions for a specific use case
    Most overlay networks use a combination of the NAT traversal techniques mentioned previously. They can be placed in Layers 2, 3 or 7. Layer 2 overlays act as a virtual network switch, while Layer 3 overlays act as a virtual network router. Layer 7 overlays are implemented in user-space as libraries or applications that run on top of the network stack of the host operating system. Layer 2 and 3 overlays can either be implemented as kernel modules or as user-space applications that use a **TUN/TAP** \todo{explain the names} driver to interface with the kernel.

    \todo{tls vs ipsec vpns. TLS vpns offer a virtual network interface at layer 3, but run over L7 TLS }

    - The term "VPN" is somewhat overloaded as it can refer to different related concepts.
    
    \glspl{vpn} are implemented as Layer 2 or 3 network overlays. They are commonly used for securely connecting machines from different \glspl{lan}. They provide software emulation of a network interface controller via a TUN/TAP driver on the operating system level and allow other software to transparently use the functionality of the \gls{ip} suite without requiring extra changes. Traditional \glspl{vpn} such as IPSec [@ipSecRFC] and OpenVPN [@openVPNDocs] use a centralized service that all (encrypted) client communications must pass through. This introduces a single point of failure and a potential bottleneck that might negatively impact the performance of the multiparty computations due to their \gls{p2p} nature.
    
    
##### OpenVPN Client/Server

We already discussed the VPN protocol behind OpenVPN. Here we will go into the client and server software and how they are implemented and discuss the typical network topologies.



#### Mesh VPNs

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

### Application Layer (L7)

#### OpenZiti

OpenZiti is a commercial product that provides an SDK for creating \gls{p2p} overlay networks. It is developed by NetFoundry, a company that provides a Software as a Service platform for creating and managing \gls{p2p} overlay networks. The SDK is open-source and can be used to create custom overlay networks. The SDK is written in Go and provides a high-level \gls{api} for creating and managing the overlay network. It uses a centralized service for peer discovery and identity management. The data traffic is routed via a \gls{p2p} network of relays. The relays are hosted by NetFoundry and are not open-source. The SDK is available for Go, Java, Python, C# and C++.

\todo{edit}

  - uses relays


#### LibP2P


- libP2P
- ngrok
- TOR
- BitTorrent
- IPFS
- Ethereum
- Teleport
- Freenet
