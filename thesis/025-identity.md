
## Digital Identities for Multiparty Computations

Digital identity mechanisms provide standardized ways for referring to entities in the context of digital interactions. We have already seen some examples of digital identities in the previous chapter:

- \as{mac} addresses - host identities at the Data link layer (L2)
- \as{ip} addresses - host identities at the Network layer (L3)
- Digital Certificates - identities that can be cryptographically verified

Key concepts related to digital identity mechanisms include: 

- Issuance - the process of assigning a digital identity to an entity. Often this involves a trusted third party like a government or a digital identity provider like Google or GitHub. Another option is \as{ssi} where a user manages their own identity.
- Authentication - the process of verifying the identity of an entity
- Credentials - use case-specific attributes associated with an identity
- Authorization - the process of verifying if an identity's owner is allowed to perform an action on a resource



Other notable examples include:

- Email addresses - identities for entities participating in email communications
- User names - user identities in various digital platforms that can be verified via a password
- ID cards - government-issued identity documents are increasingly able to support digital interactions
- Biometrics - used to prove an identity via sensor data 




<!-- A party's digital identity is a persistent mechanism that allows others to provably track it
across digital interactions with the party. An identity can either be issued by a digital authority,
e.g. an organization like google, or a country's government or it can be self-issued. Depending
on the method, an identity verification can involve demonstrating a cryptographic proof of
ownership of a public key, or separate communication with the digital authority. -->




- IP addresses
  - Cryptographically Generated Addresses - rfc3972
  - Privacy Extensions - rfc4941
  - DNS
- MAC addresses
- Government
  - ID Cards / Passports
    - NFC
  - Estonia's Digital Government
  - DigiD in NL
  - 
- Certificates
- TLS
- IPSec
- WireGuard
- OpenID Connect
- Crypto currency addresses
  - Hierarchical Deterministic Keys
  - ENS
- Self-Sovereign Identity
  - Decentralized Identifiers
  - Verifiable Credentials
  - Identity Overlay Network (ION) from Microsoft
    - DPKI
- Social Networks
  - Centralized
    - Facebook
    - Twitter
    - Reddit
  - Decentralized
    - Mastodon - Mastodon is an open-source, decentralized social networking platform that provides an alternative to traditional social media giants like Twitter. It operates on a federated model, which means that instead of being a single, centralized platform, it is a network of independently operated servers, known as "instances". Each instance hosts its own community with its own rules, but users on any instance can interact with users on other instances thanks to a common protocol, creating a connected, distributed social network.
    - Bluesky - An ex-twitter initiative to move away from centralized social media platforms, where a single organization controls the network. Instead, Bluesky aims to develop a standard protocol for social media that would enable the development of a variety of interoperable, decentralized platforms.
    - Nostr
- Identity Privacy  

    