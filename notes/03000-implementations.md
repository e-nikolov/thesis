# Implementation notes

## Headscale

- Docker seems to have a 50-100% performance penalty (possibly due to docker's internal NAT) which makes the performance results of the headscale setup worse than they should be
- Modify the deployment setup to
	- not depend on all machines being on the same tailscale network 
	- use the `*.demo.mpyc.tech` hostnames
	- the nodes should switch between the tailscale and headscale network depending on the demo script
	- 