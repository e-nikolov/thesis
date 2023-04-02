---
link: https://www.notion.so/06-conclusions-1de70c943dde4e8198c8b24780d28cee
notionID: 1de70c94-3dde-4e81-98c8-b24780d28cee
---
# Conclusions

In this report we presented the results of the preparation phase for the master thesis assignment "Secure Sessions for Ad Hoc Multiparty Computation in MPyC". We developed an \acrfull{e3} for the purpose of creating ad hoc networks of host machines that perform \acrfullpl{mpc} in hybrid scenarios involving both cloud and physical machines. \gls{e3} makes extensive use of declarative \gls{iac} tools in order to achieve highly reproducible deployments in an automated way. We provided a reference implementation that makes use of the Tailscale mesh VPN that creates a network of RaspberryPis and cloud \glspl{vm} on DigitalOcean. The cloud provisioning is defined declaratively using Terraform and allows to define a set of host machines across the regions supported by DigitalOcean (e.g. Amsterdam, New York City, etc) and automatically add them to a shared Tailscale network. The machines run NixOS - a declarative and highly reproducible Linux distribution while Colmena is used to declaratively manage the software installed on them via \gls{ssh}. The tools `prsync`  and `pssh` are used to run MPyC demos in parallel on the deployed hosts.

#### Implementation phase planning

During the next phase of the thesis assignment, we plan to implement various connectivity approaches for \gls{e3}'s host machines and analyse their suitability for MPyC.

The following is a list of high level tasks that we plan to carry out as part of the implementation phase:

- replace the proprietary Tailscale coordination service from our reference implementation of \gls{e3} with the open-source self-hosted alternative Headscale[@fontJuanfontHeadscale2022]
- develop a network overlay for \gls{e3} based on the Nebula mesh VPN. Nebula only provides a way to manually perform the initial setup, so our implementation should add a way to automatically:
  - allocate virtual IP addresses for the hosts
  - generate identity certificates using the Nebula \gls{ca}
  - distribute the certificates among the hosts
- develop network overlays for \gls{e3} that incorporate parts of the mesh VPN implementations but with alternative identity management approaches:
  - using a \gls{ca} that is managed jointly using MPC
  - using a form of \gls{ssi} such as \glspl{did}
- implement a network overlay for \gls{e3} based on DIDComm
- explore options for enhancing the DIDComm implementation to:
  - support sessions - the DIDComm protocol is currently stateless and uses a new asymmetric key for each message, which negatively impacts performance
  - employ \gls{nat} traversal techniques similar to mesh \glspl{vpn}
- implement a privacy mechanism for \gls{e3} based on \gls{tor} in order to prevent leaking sensitive information like which parties are communicating with each other and their IP addresses
- investigate if we can apply ideas from the \gls{p2p} implementations in other software like the Ethereum [@ethereumDocs; @ethereumYellowPaper] blockchain and the \gls{ipfs} [@ipfsDocs]
- analyse and compare all of the above implementations in terms of:
  - security
  - performance
  - ease of use
  - privacy
- compare \gls{e3} to other work related to deploying MPC such as the Carbyne stack[@robertboschgmbhCarbyneStack2022]
