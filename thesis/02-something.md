

# Testing methodology


During the preparation phase of the project we developed the \gls{e3} framework which simplifies and automates the process of deploying machines in different georgraphical regions, connecting them in an overlay network and executing MPC computations between them, where each machine represents a different party.
During the thesis assignment we will look at a number of solutions for ad hoc MPC sessions and compare them in terms of performance, security and usability.

## Performance

Each solution will be deployed using the \gls{e3} framework and the performance will be quantitatively measured in terms of the speed of execution of a number of pre-selected MPyC demos of different round complexities and message sizes:
- secret santa - high round complexity
