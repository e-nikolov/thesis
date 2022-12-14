\begin{frame}

\frametitle{NAT Traversal}

\begin{tabular}{cl}  
 \begin{tabular}{c}
 
\includegraphics[scale=0.33]{figures/nat-traversal.png}
 \end{tabular}
 
& \begin{tabular}{l}

 \parbox{0.5\linewidth}{

- Session Traversal Utilities for NAT (STUN)
	- Parties connect to a public STUN server (can be another party)
	- The server reports the IPs it "sees" the parties at
	- User Datagram Protocol (UDP) hole punching
		- Reverse channel for the STUN server to talk back to a party
		- Appropriated by the other parties for their own traffic

}

 \end{tabular}
\end{tabular} 
\end{frame}