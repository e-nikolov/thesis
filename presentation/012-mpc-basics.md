
# MPC Basics

- Lagrange Interpolation
	- Set of  $t+1$ points uniquely identify a polynomial of degree $\leq t$
- Shamir's Secret Sharing
	- $(t, m)$-threshold secret sharing scheme based on Lagrange Interpolation
	- $\geq$ $t+1$ shares to reconstruct the secret $S$
	- Choose random polynomial $f(x)$ of degree $t$ where $f(0) = S$
	- Share $s_i = f(i)$, for $i \in [1,m]$ 
- Secure Multiparty Computation
	- $m$ parties jointly compute a function $f(S_{1},S_{2},\dots,S_{m})$, from their secret inputs
	- Party $i$ secret shares its private input $S_{i}$ with the others
	- Interactive protocol to reconstruct a polynomial $g(x)$, where $g(0)=f(S_1, S_2, \dots, S_m)$


