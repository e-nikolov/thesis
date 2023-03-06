---
link: https://www.notion.so/00-abstract-f00cab4b9b584cafae184dee919e1de2
notionID: f00cab4b-9b58-4caf-ae18-4dee919e1de2
---

[TEST](01-introduction.md#background)
[TEST2](#background)
[TEST3](./01-introduction.md#background)

The field of Secure Multiparty Computation provides methods for jointly computing functions without revealing their private inputs from multple parties. This master thesis assignment focuses on the MPyC framework for MPC and explores various approaches for connecting the parties via the internet. A technical survey was performed in the preparation phase to identify viable techniques and tools to achieve that. Furthermore a test environment dubbed $E^3$ was developed to support the exploration process that will take place during the implementation phase of the assignment. It is composed of a combination of physical and virtual machines that are able to execute a multiparty computation together using MPyC. It employs several declarative Infrastructure as Code tools to automate the deployment process and make it reproducible. Specifically, Terraform is used for provisioning NixOS virtual machines on the DigitalOcean cloud provider and Colmena is used for remotely deploying software to them. The reference implementation described in this report uses the Tailscale mesh VPN for connectivity, and a number of additional implementations are planned for the next phase of the project.
