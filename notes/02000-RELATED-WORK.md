## Related work

- There is a huge amount of primitives and partial solutions that are relevant to our problem, which makes it difficult to review them all, so we will try to design a classification system for them and focus on one or two solutions per class while only briefly mentioning their alternatives

- Make a distinction between
	- primitives - lower level concepts, techniques or frameworks that cannot be used as a solution directly, but are used inside higher level solutions 
		- STUN/TURN/ICE
		- Noise Protocol Framework
		- Identity solutions
	- In terms of topology
		- Star shaped
		- Peer-to-peer
	- In terms of NAT Traversal
		- STUN
		- TURN
	- User/Kernel space
	- In terms of OSI layers:
		- Virtual Network Interface Controller - solutions that emulate a physical network controller in the OS using TUN/TAP driver. Most networked applications are already designed to work with the Internet Protocol Stack (Suite - definitions; Stack - implementations) in the host operating system and they do not need to do anything extra to work with a virtual NIC. Those solutions are usually more general purpose as they allow any other application on the host machine to use the overlay network. Installing an application that also uses this type of a solution may be unintuitive because it will essentially install 2 separate programs - the actual application and another one that manages the virtual network, while the virtual network will not be limited to our application but will also be usable by the others.
			- IPSec
			- Wireguard
			- Tailscale
			- 
		- Application layer - require the applications to be implemented in a way that supports the protocols of the solution by using additional libraries or SDKs to facilitate the communications. Those solutions result in more purpose built applications as it is not possible for an application to use the overlay network if it wasn't specifically designed to be able to.
			- WebRTC
			- OpenZiti
			- 