# Wireguard

Wireguard[@donenfeldWireGuardNextGeneration2017] is a VPN protocol built with the Noise Protocol Framework[@noiseProtocol] that focuses on configuration simplicity. It considers issues such as peer discovery and key distribution as out of scope and a responsibility of a higher level system that uses Wireguard as a building block. The snippets below show a minimal set of configuration options that need to be provided in order for two peers to be able to form secure tunnels with each another.

```toml
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
```toml
# peer2.conf
[Interface]
Address = 101.0.0.2/32
ListenPort = 38133
PrivateKey = sN/d6XUPEVPGSziVgCCOnOivDK+qAoYC3nxnssQ5Rls=

[Peer]
PublicKey = e/TxvPmrgcc1G4cSH2bHv5J0PRHXKjYxTFoU8r+G93E=
AllowedIPs = 101.0.0.1/32

```
Each peer has a public/private key pair that is used for authentication and encryption. It is notable that only one of the peers must be configured with a reachable endpoint for the other peer. In the above example once `peer1`  initiates communication with `peer2`, `peer2` will learn the current endpoint of `peer1` and will be able to communicate back with it.

## Implementation