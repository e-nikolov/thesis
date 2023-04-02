## OSI Model

*   Create a figure that maps the various related components to OSI model layers

*   It can be a "more or less accurate" artistic impression since the components can cover multiple layers and the layers are somewhat fluid

![test](../figures/osi-model-2.png){height=30% width=50%} ![test2](../figures/osi-model-1.png "test2"){height=30% width=40% }

The Open Systems Interconnection (OSI) model distinguishes 7 layers in computer networks:

![OSI model mapping](../Excalidraw/osi-map.excalidraw.png){height=90% }

\newpage

![OSI model mapping 2](../figures/test.png){height=90% }

\newpage

| OSI Layer               | Description                                                                                                                    | Protocols                                                        | Network overlays                                                            |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------- | --------------------------------------------------------------------------- |
| 7. Application          | High level protocols that user-facing services use                                                                             | HTTP, HTTPS, DNS, FTP, SMTP, UPnP, NAT-PMP, PCP, SSH, STUN, TURN | WebRTC, OpenZiti, Teleport, ngrok, TOR, BitTorrent, IPFS, Ethereum, Freenet |
| \hline 6. Presentation  | Translation of data between a networking service and an application, e.g. encoding, compression, encryption                    | MIME, TLS, Noise                                                 |                                                                             |
| \hline 5. Session       | Session setup, management, teardown, authentication, authorization                                                             | SOCKS, X.225                                                     |                                                                             |
| \hline 4. Transport     | Sending data of variable length over a network while maintaining quality-of-service, e.g. ports, connections, packet splitting | UDP, TCP, NAT port mapping                                       |                                                                             |
| \hline 3. Network       | Sending data packets between two nodes, routed via a path of other nodes, e.g. addressing, routing                             | IP, ICMP, NAT                                                    | TUN driver, IPSec, OpenVPN, Tinc, Wireguard, Tailscale, Nebula, ZeroTier    |
| \hline 2. Data link     | Sending data frames between two nodes, directly connected via a physical layer, e.g. on a LAN                                  | MAC, L2TP                                                        | TAP driver, N2N, OpenVPN, Tinc                                              |
| \hline 1. Physical      | Sending raw bits over a physical medium                                                                                        | RS232, Ethernet, WiFi, USB, Bluetooth                            |                                                                             |

\newpage

| Network overlay   | Open source               | OSI Layer  | Peer-to-Peer | NAT Traversal    | Implementation                                |
| ----------------- | ------------------------- | ---------- | ------------ | ---------------- | --------------------------------------------- |
| IPSec             | Yes                       | Layer 3    | No           |                  | TUN driver                                    |
| \hline OpenVPN    | Yes                       | Layer 2, 3 | No           |                  | TUN or TAP driver                             |
| \hline Tinc       | Yes                       | Layer 2, 3 | Yes          | STUN, TURN       | TUN or TAP driver                             |
| \hline N2N        | Yes                       | Layer 2    | Yes          | TURN             | TAP driver                                    |
| \hline Wireguard  | Yes                       | Layer 3    | No           |                  | Linux kernel module or TUN driver; Uses Noise |
| \hline Tailscale  | Yes (client); No (server) | Layer 3    | Yes          | STUN, DERP, UPnP | Uses Wireguard                                |
| \hline Nebula     | Yes                       | Layer 3    | Yes          | STUN, TURN       | Uses Noise                                    |
| \hline ZeroTier   | No                        | Layer 3    | Yes          | STUN, TURN       |                                               |
| \hline WebRTC     | Yes                       | Layer 7    | Yes          | STUN, TURN       |                                               |
| \hline OpenZiti   | Yes                       | Layer 7    | ?            | TURN\*           |                                               |
| \hline Teleport   | Yes                       | Layer 7    | ?            | TURN\*           |                                               |
| \hline ngrok      | No                        | Layer 7    | No           | Proxy            |                                               |
| \hline TOR        | Yes                       | Layer 7    | Yes          | TURN\*           |                                               |
| \hline BitTorrent | Yes                       | Layer 7    | Yes          | ?                |                                               |
| \hline IPFS       | Yes                       | Layer 7    | Yes          | ?                |                                               |
| \hline Ethereum   | Yes                       | Layer 7    | Yes          | ?                |                                               |
| \hline Freenet    | Yes                       | Layer 7    | Yes          | ?                |                                               |

*   Resources

    *   [The OSI model doesn't map well to TCP/IP](https://jvns.ca/blog/2021/05/11/what-s-the-osi-model-/)

