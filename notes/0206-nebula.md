## Nebula
- Mesh VPN
- Similar to Tailscale
- Does not use Wireguard
- Built using the Noise Protocol Framework (used in Wireguard)
- Uses a Certificate Authority that needs to sign each Peer’s certificate
    - Certificates contain
        - Peer’s Virtual IP address
        - Peer’s public key