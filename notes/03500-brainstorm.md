# Brainstorm for custom solutions

- Initial state
    - Here’s my identity, here are the identities of the other parties
- Desired result
    - Executed MPC

With tailscale we’d need to

- Each party:
    - registers a Tailscale account
    - Downloads and installs tailscale on the machine they want to run the MPC on
    - Runs tailscale on their machine and logs into their account in order to link it to their own Tailnet
    - Shares their Tailscale machine with the Tailnets of each of the other parties
    - Downloads the demo they want to run
    - Form the flags for running the chosen demo
        - add -P \$HOST:\$PORT for each party using their Tailscale hostname/virtual IP
    - Run the demo

---

- we don’t need to use the same route for the communication Party A → Party B and Party B → Party A
- we can have something like an asynchronous STUN
- Party A sends a QR code/public URL/json object/DID document containing
    - Party A’s public key
    - Party A’s Mediator URL
- The mediator is a STUN/TURN/DERP server
    - other parties can either use it as a STUN server to find out how to access the hole in party A’s NAT punched by the mediator
    - or use it as a relayer so that Party B can send encrypted packets to party A via the mediator
- Instead of a QR code, the information could be stored on a public ledger and could be resolved via DIDs

---

- There is a generic MPC wrapper program that deals with supporting tasks like generating identities and pulling MPC demos
- One party creates a “lobby” for an MPC session in their program and get a session id/public URL/QR code that can be shared with the other parties
- 

---

- Public Website is visited by everyone
- They prove their identities using a SSI wallet or OIDC
- They get a QR code that serves as an invitation
    - contains their STUN based endpoint and identity
- Somehow everyone needs to scan each other’s qr codes

---

---

---

- One party creates a “lobby” for an MPC session by visiting a public website
    - They provide their identity via OIDC/SSI wallet
- They get a public link/QR code that can be shared with the other parties
- The parties visit the URL and also provide their identities
- The parties obtain the MPC program they want to run
    - MPC program distribution could be done separately via cloning the github repo?
    - They could choose a DEMO and download it from the website?
    - There could also be a program running on the host machines that deals with the source code distribution. Similar to downloading custom maps for warcraft 3 or dota 2?
    - They could specify the source code when creating the MPC session in the website?
    - If the demo is not symmetrical where different parties have different roles and need to execute different programs, the roles could be assigned by the host or the people could choose their preferred role themselves?
- The parties download a configuration file that contains information on how to connect to the other parties
- They run the demos with the downloaded config file
- A temporary Wireguard mesh VPN is created between all parties