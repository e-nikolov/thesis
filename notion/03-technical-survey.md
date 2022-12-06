---
link: https://www.notion.so/03-technical-survey-1735f1212d6f48c3b03d897f610b8164
notionID: 1735f121-2d6f-48c3-b03d-897f610b8164
---
# Technical Survey

In this chapter we will perform a high level survey of the available tools and approaches that could be used for the \gls{e3} and select ones that fit our requirements. In the next chapter we will go more in depth and cover the implementation details using those tools.

Since we are need to work with a heterogeneous runtime environment, we need to choose building blocks that are compatible with as many scenarios as possible while also keeping the complexity low. 

## Deployment

Our primary users are enterprises and power users. Enterprises can employ a variety of \gls{iac} tools in their management process: 

- provisioning - Terraform[@tfDocs], Cloud Formation[@cfDocs], etc.
- deployment automation - Ansible[@ansibleDocs], Puppet[@puppetDocs], Chef[@chefDocs], etc.
- container orchestration - Docker Swarm[@dockerDocs], Kubernetes[@kubeDocs], etc.

According to our definitions, power users typically use physical machines while enterprises can use both virtual machines and container orchestration tools. Based on our requirements for the \gls{e3} we need a cross region deployment. \glspl{vm} can be automatically provisioned across different regions in the cloud using \gls{iac} tools. Once provisioned, a \gls{vm} is usually managed via an automation tool that executes a set of deployment steps over SSH. Those deployment steps can be adapted to physical machines so that power users can make use of them.

Kubernetes is used for dynamically scaling a large number of long-running processes across a cluster of \glspl{vm} within the same geographic region. Enterprises may wish to run MPyC programs in a Kubernetes cluster and might benefit from an example of doing so. But for the purposes of \gls{e3}, it does not provide sufficient benefits compared to using \glspl{vm} directly, while it adds complexity in terms of deploying multiple clusters across regions and adding a cross cluster communication mechanism.

Based on this analysis, we choose to base \gls{e3} on a combination of \glspl{vm} deployed in the cloud and a set of personal devices owned by the authors - a Linux laptop, a Windows desktop with Windows Subsystem for Linux, and an ARM Raspberry Pi 2 to serve as an example of both enterprises and individual power users.

\gls{iac} tools use specifications that are either imperative or declarative. **Imperative** specifications describe the steps needed to be executed for the infrastructure to reach the desired state, while **declarative** specifications describe the desired final state and let the tool worry about how to get there. Imperative tools are more likely to suffer from *configuration drift* - the infrastructure state might become out of sync with the specification due to either manual changes or left-over state from previously applied specifications. On the other hand, if something is removed from a declarative specification, when it gets applied, the corresponding resources will also be removed from the infrastructure. In addition, declarative tools are idempotent - applying the same specification multiple times in a row does not change the state. Therefore in order to achieve high reproducibility, we will prefer declarative tools to imperative ones where possible.

On Linux, software is usually installed via package managers. Most of the popular Linux distributions such as Ubuntu, Debian, Fedora, Arch use package managers that only support automating this process via imperative shell scripts rather than a declarative specification. Additionally those do not offer an easy way of specifying and locking the required software versions to a known good configuration that can be reproduced in the future. NixOS on the other hand is based on the declarative Nix package manager which does support version locking via its **flakes** feature. This is why we choose to use the NixOS operating system for our \glspl{vm}.

Most of the popular application deployment tools such as Ansible, Chef and Puppet are either imperative or have limited support for declarative specifications. Fortunately, the NixOS ecosystem, offers a number of deployment tools that can apply a declarative specification on remote hosts:

- NixOps[@nixopsSource; @nixopsDocs] - official tool
- Colmena [@colmenaSource; @colmenaDocs]
- morph [@morphSource]
- deploy-rs [@deployrsSource]

NixOps is the official deployment tool for NixOS but it was being redesigned at the time of writing. The new version was not complete yet and lacked documentation, while the old one was no longer being supported and depended on a deprecated version of Python. The rest of the tools were still actively maintained. Colmena was the best fit for our use case because it supported both flakes and parallel deploys, while morph lacked support for flakes and deploy-rs could not deploy to multiple hosts in parallel.

The declarative tools that were considered for provisioning were Terraform, Pulumi and Cloud Formation. Cloud Formation only works on AWS which would prevent us from using it with other cloud providers. Pulumi is a newer and less proven tool compared to Terraform, which the authors had more experience with. Therefore our choice was to use Terraform.

We decided to use DigitalOcean as a cloud provider because they are supported by Terraform and offered free credits for educational use.

## Connectivity

There are a number of approaches for communication between our host machines. During the preparation phase of the project we will perform a high level exploration of our options and summarize them. For \gls{e3} we will initially use the simplest to implement one. During the implementation phase of the project we will go more in depth and implement more approaches and analyze how they compare to each other in practice.

\glspl{vpn} are commonly used for securely connecting machines from different \glspl{lan}. They provide software emulation of a network device on the operating system level and allow other software to transparently use the functionality of the \gls{ip} suite without requiring extra changes. Traditional \glspl{vpn} such as OpenVPN[@openVPNDocs] use a centralized service that all (encrypted) client communications must pass through. This introduces a single point of failure and a potential bottleneck that might negatively impact the performance of the multi-party computations due to their \gls{p2p} nature.

On the other hand, mesh \glspl{vpn} such as Tinc[@tincDocs], Tailscale[@tailscaleDocs] and Nebula[@nebulaDocs] utilize direct \gls{p2p} links between the clients for the data traffic. Depending on the chosen mesh \gls{vpn} solution, either one of the hosts that has a fixed public \gls{ip} address or a separate centralized service is needed to help with the initial coordination of the \gls{p2p} links. As we mentioned in the introduction chapter, in a typical home network, only the router has a public \gls{ip} address and the other machines can only initiate 

![nat](https://tailscale.com/blog/how-nat-traversal-works/nat-intro.png "Double NAT from \cite{tailscaleHowNATTraversal})

This is done by a combination of \gls{nat} traversal[@tailscaleHowNATTraversal] techniques and relaying.

  

In a typical home network, there is a router that serves as the interface between the \glspl{lan} and the rest of the Internet.

## Execution

## Secrets

TODOs:

- talk about \gls{nat}
- talk about the differences between Tinc/Tailscale and Nebula and why we chose Tailscale for the initial version
- talk about \glspl{did}
- talk about blockchain-like solutions
- pssh
- secrets

## Summary

In this chapter we compared a number of potential building blocks for \gls{e3} and made some choices informed by our requirements. Specifically, we will use Terraform for provisioning Virtual Machines running NixOS on DigitalOcean and Colmena for deploying to them. Our initial implementation will use Tailscale as the connectivity layer due to its ease of use. In the next phase of the project, we plan to explore solutions based on Nebula, DIDComm, blockchain based solutions and combinations of the above.
