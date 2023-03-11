# Tailscale

Tailscale is a VPN solution that configures a mesh of direct Wireguard tunnels between the peers.  

## Overview

## Usability

With tailscale each party needs to

- register a Tailscale account
- Download and install tailscale on the machine they want to run a multiparty computation
- Run tailscale on their machine and logs into their account in order to link it to their own Tailnet
- Share their Tailscale machine with the Tailnets of each of the other parties
- Download the demo they want to run
- Form the flags for running the chosen demo
	- add -P \$HOST:\$PORT for each party using their Tailscale hostname/virtual IP
- Run the demo


## Security

### Trust model

There is a centralized service that deals with the key distribution, which needs to be trusted to provide the correct public keys for the correct parties

### Identity

Identity is based on third party identity providers such as Microsoft and GitHub

- Magic DNS

## Performance

