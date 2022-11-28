# Evaluation Setup Design

## Motivation

In order to evaluate various communication strategies for dynamic MPyC sessions, we need a test environment that can demonstrate real world networking scenarios in a way that is easy to automate and reproduce.

We have broadly categorized the potential users of the MPyC framework as enterprises, power users and casual users. The focus of the evaluation setup we are designing during the preparation phase will be on enterprise and power users but where possible casual users will be accommodated as well.

For our purposes we have defined **enterprises** as companies with departments that manage their IT infrastructure and optimize for scale. They usually have large numbers of Linux based servers which are a combination of physical, virtual and container based. Those can be deployed either in the cloud or on premise in an automated way using Infrastructure as Code (IaC) tools. Those include tools for:

- provisioning - Terraform[@TerraformHashiCorpDeveloper], Cloud Formation[@AWSCloudFormationDocumentation], etc.
- deployment automation - Ansible[@AnsibleDocumentation], Puppet, Chef, etc.
- container orchestration - Docker Swarm, Kubernetes, etc.

We define **power users** as users who manage a number of personal physical machines and may have some familiarity with Linux, terminals and shell scripting. They are assumed to be able to execute the necessary steps to setup a machine given a guide.

**Casual users** are defined as people who are used to Windows or Mac, prefer software installers to package managers, Graphical User Interface (GUI) programs rather than Command Line Interface (CLI) based ones and do not feel comfortable with manually modifying their systems or using scripts.

## Requirements

In this section we will describe the requirements for the evaluation setup in terms of complexity, source code, deployment and connectivity.

1. Complexity
    1. Extensible - the test setup should allow for swapping components during the Implementation phase of the project, e.g. the communication method should be easy to change in order to be able to measure and compare their characteristics.
    2. Simple - the initial version of the evaluation setup developed during the preparation phase should be simple given the limited time in this phase, e.g. the easiest to implement communication method should be chosen, or while the techniques used should be adaptable to multiple cloud providers, only one should be chosen for the implementation.
2. Source code
    1. Open-source - the source code of the resulting implementation of the test setup must be available in a public repository, e.g. on Github.com
    2. No plaintext secrets such as API keys and passwords should be present in the public repository, but others should be able to easily provide their own secrets in order to use the test setup in their own environment.
3. Deployment
    1. Cross region - the machines should be provisioned in multiple geographical regions in order to be able to observe the effects of varying latency on the system
    2. Cross platform - in a real world scenario the machines will be controlled by different parties that run various operating systems, hardware architectures and deployed using different tools, e.g. Party A might be an enterprise that uses containers and Kubernetes, while Party B is a power user running a few virtual machines and Party **C** could be using an ARM-based raspberry pi.
    3. Automation - appropriate tools should be chosen to allow automatically deploying and destroying the runtime environment without manual intervention other than running a minimal set of commands
    4. Reproducibility - it should be easy for others to reproduce the test setup in their own environment 
4. Connectivity
    1. Identity - it must be possible for the machines to communicate based on a long-lived identity rather than a potentially temporary IP addresses.
    2. Security - a message sent by a party must be readable only by its intended targets.
    3. Authentication - a party must be able to determine which party a message was sent by
    4. Privacy - no more information than strictly necessary should be revealed about a party. Depending on the method of communication, it may be necessary to choose a tradeoff or introduce a tuning parameter between performance and privacy.

## Analysis

Since we are designing for a heterogeneous runtime environment, we need to choose building blocks that are compatible with as many scenarios as possible while also keeping the complexity low. 

### Deployment

Our primary users are enterprises and power users. According to our definitions, power users typically use physical machines and enterprises can use both virtual machines and container orchestration tools (e.g. Kubernetes). Based on our requirements for the evaluation setup we need a cross region deployment. VMs can be automatically provisioned across different regions in the cloud using IaC tools. Once provisioned, a VM’s management usually involves a tool such as Ansible which executes a set of deployment steps over SSH. Those deployment steps can be adapted to physical machines so that power users can make use of them.

Kubernetes is used for dynamically scaling a large number of long-running processes across a cluster of VMs within the same geographic region. Enterprises may wish to run MPyC programs in a Kubernetes cluster and might benefit from an example of doing so. But for the purposes of our evaluation setup, it does not provide sufficient benefits compared to using VMs directly, while it adds complexity in terms of deploying multiple clusters across regions and adding a cross cluster communication mechanism.

Based on this analysis, we chose to base the evaluation setup on a combination of virtual machines deployed in the cloud and a set of personal devices owned by the authors - a Linux laptop, a Windows desktop with Windows Subsystem for Linux, and an ARM Raspberry Pi 2 to simulate the enterprises and individual power users.

IaC tools use specifications that are either imperative or declarative. **Imperative** specifications describe the steps needed to be executed for the infrastructure to reach the desired state, while **declarative** specifications describe the desired final state and let the tool worry about how to get there. Imperative tools are more likely to suffer from *configuration drift* - the infrastructure state might become out of sync with the specification due to either manual changes or left-over state from previously applied specifications. On the other hand, if something is removed from a declarative specification, when it gets applied, the corresponding resources will also be removed from the infrastructure. In addition, declarative tools are idempotent - applying the same specification multiple times in a row does not change the state. Therefore in order to achieve high reproducibility, we will prefer declarative tools to imperative ones where possible.

On Linux, software is usually installed via package managers. Most of the popular Linux distributions such as Ubuntu, Debian, Fedora, Arch use package managers that only support automating this process via imperative shell scripts rather than a declarative specification. Additionally those do not offer an easy way of specifying and locking the required software versions to a known good configuration that can be reproduced in the future. NixOS on the other hand is based on the declarative Nix package manager which does support version locking via its **flakes** feature. This is why we decided to use the NixOS operating system for our virtual machines.

Most of the popular application deployment tools such as Ansible, Chef and Puppet are either imperative or offer limited support for declarative specifications. The NixOS ecosystem, however, offers a number of deployment tools that can apply a declarative specification on remote hosts:

- NixOps - official tool
- Colmena
- morph
- deploy-rs

NixOps is the official deployment tool for NixOS but it was being redesigned at the time of writing. The new version was not complete yet and lacked documentation, while the old one was no longer being supported and depended on a deprecated version of Python. The rest of the tools were still actively maintained. Colmena was the best fit for our use case because it supported both flakes and parallel deploys, while morph lacked support for flakes and deploy-rs could not deploy to multiple hosts in parallel.

The declarative tools that were considered for provisioning were Terraform, Pulumi and AWS Cloud Formation. AWS Cloud Formation only works on AWS which would prevent us from using it with other cloud providers. Pulumi is a newer and less proven tool compared to Terraform, which the authors had more experience with. Therefore our choice was to use Terraform.

In terms of a Cloud Provider, we decided to use DigitalOcean because they are supported by Terraform and offered free credits for educational use.

### Connectivity

There are a number of approaches for communication between our host machines. During the preparation phase of the project we will perform a high level exploration of our options and summarize them. For the evaluation setup we will initially use the simplest to implement one. During the implementation phase of the project we will go more in depth and implement more approaches and analyze how they compare to each other in practice.

Virtual private networks are 

Virtual Private Networks (VPN)

## Summary

We have developed an extensible setup for running experiments with various MPyC networking scenarios including combinations of cloud and physical machines.

The test setup is currently using DigitalOcean as a cloud provider because they offer free credits to students but the setup can be adapted to other cloud providers.

The cloud provisioning is defined declaratively using Terraform. The setup allows to define a set of machines across the regions supported by DigitalOcean, e.g. Amsterdam, New York City, San Francisco, Singapore and others.

The machines run NixOS - a declarative and highly reproducible Linux distribution.
