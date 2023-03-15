## Nebula

- [Open source](https://github.com/slackhq/nebula) Mesh VPN
- Similar to Tailscale
- Does not use Wireguard
- NAT traversal via Lighthouses
- Built using the [Noise Protocol Framework](02022-noise) (used in Wireguard)
- Uses a Certificate Authority that needs to sign each Peer’s certificate
    - Certificates contain
        - Peer’s Virtual IP address
        - Peer’s public key