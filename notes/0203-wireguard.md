## Wireguard
- VPN Protocol
- Used by Tailscale
- Whitepaper - [https://www.wireguard.com/papers/wireguard.pdf](https://www.wireguard.com/papers/wireguard.pdf)
- Built with the Noise Protocol Framework
- Typically used as a building block in more complicated systems
- Simple configuration
    - Each peer has a public/private key pair for authentication and traffic encryption
    - Each peer has a config file:
        
        ```toml
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
        
- Creates a virtual network interface in the operating system that looks like an additional network card and can be used for TCP/IP communications
- Handles the encryption of traffic
    - deals with handshakes and generating symmetric session keys
- Cryptokey routing - associates public/private key pairs with IP addresses
- Out of scope:
    - key distribution - managed manually or via other software that builds on top of wireguard
    - peer discovery - for each pair of peers, one needs to have an endpoint that can be reached by the other peer
- Resources
    - [https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/](https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/)