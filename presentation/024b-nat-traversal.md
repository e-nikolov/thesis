
# NAT Traversal

::: columns

:::: column

!["NAT traversal via STUN"\label{nat-traversal}](../figures/nat-traversal.png "NAT traversal via STUN" ){ height=66% }
  
::::

:::: column

- Session Traversal Utilities for NAT (STUN)
	- Parties connect to a public STUN server (can be another party)
	- The server reports the IPs it "sees" the parties at
	- User Datagram Protocol (UDP) hole punching
		- Reverse channel for the STUN server to talk back to a party
		- Appropriated by the other parties for their own traffic


::::

:::

