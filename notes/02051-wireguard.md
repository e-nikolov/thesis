### Wireguard

* Low level VPN Protocol
* Used by Tailscale
* Whitepaper - [https://www.wireguard.com/papers/wireguard.pdf](https://www.wireguard.com/papers/wireguard.pdf)
* Built with the [Noise Protocol Framework](02022-noise.md)d
* Added to Linux Kernel 5.6 in May 2020
* Typically used as a building block in more complicated systems
* Layer 3 over UDP
    * Linux Kernel module
        * faster - packets are not copied between kernel memory and userspace memory
    * Userspace virtual [TUN](02021-internet-protocol) device
        * easier to update because it does not require specific kernel modules
        * available on windows
* Simple configuration
    * Each peer has a public/private key pair for authentication and traffic encryption
    * Each peer has a config file:

\newpage

```ini
[Interface]
Address = 101.0.0.1/32
ListenPort = 53063
PrivateKey = ePTiXXhHjvAHdWUr8Bimk30n0gh3m241RAzsN0JZDW0=

[Peer]
PublicKey = BSn0ejd1Y3bKuD+Xpg0ZZeOf+Ies/oql0NZxw+SOmkc=
AllowedIPs = 101.0.0.2/32
Endpoint = 142.93.135.154:38133
PersistentKeepalive = 25
```

* Creates a virtual network interface in the operating system that looks like an additional network card and can be used for TCP/IP communications
* Handles the encryption of traffic
    * deals with handshakes and generating symmetric session keys
* Cryptokey routing - associates public/private key pairs with IP addresses
* Out of scope:
    * key distribution - managed manually or via other software that builds on top of wireguard
    * peer discovery - for each pair of peers, one needs to have an endpoint that can be reached by the other peer
* Resources
    * [WireGuard: The Next-Gen VPN Protocol](https://blogs.keysight.com/blogs/tech/nwvs.entry.html/2022/09/22/wireguard_the_next-genvpnprotocol-OcEz.html)
    * [WireGuard Endpoint Discovery and NAT Traversal using DNS-SD](https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/)
    * [Kernel Commit](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e7096c131e5161fa3b8e52a650d7719d2857adfd)
    * [Arch Linux Wiki](https://wiki.archlinux.org/title/WireGuard)
    * Examples:
    * https://github.com/takutakahashi/wg-connect
    * https://github.com/stv0g/cunicu
    * 