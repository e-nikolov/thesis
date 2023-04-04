---
link: https://www.notion.so/01-introduction-145d822b8f9c4d1ab08a056c16f4ea48
notionID: 145d822b-8f9c-4d1a-b08a-056c16f4ea48
---

# Introduction

This report will present the results of the preparation phase of the master thesis project titled "Secure Sessions for Ad Hoc Multiparty Computation in MPyC". The goal of this phase is to gain sufficient insight into the topic, perform some preliminary tasks and propose a plan with well defined goals for the implementation phase of the project.

## Background

\gls{mpc} is a set of techniques and protocols for computing a function over the secret inputs of multiple parties without revealing their values, but only the final result. A good overview can be found on Wikipedia [@wikiMPC]. Yao's Millionaires' Problem [@yaoProtocolsSecureComputations1982] is one famous example in which a number of millionaires want to know who is richer without revealing their net worths. Other practical applications [@laudApplicationsSecureMultiparty2015] include electronic voting, auctions or even machine learning [@knottCrypTenSecureMultiParty2022] where one party's private data can be used as an input for another party's private machine learning model.

The general process is that each party uses a scheme like \gls{sss} [@shamirHowShareSecret1979] to split its secret input into shares and sends one to each of the other parties. A protocol involving multiple communication rounds and further re-shares of intermediate secret results is used by the parties so that each of them can compute the final result from the shares it has received.

A number of \gls{mpc} frameworks have been developed for various programming languages and security models. As part of this project we will focus our efforts on **MPyC** [ @mpycHome; @mpycSource] - an opensource \gls{mpc} Python framework developed primarily at TU Eindhoven,  but our results should be applicable to others as well.

To help us determine the types of solutions we need to consider, we can group the potential users of the MPyC framework into three broad categories: casual users, power users and enterprises.

We define **casual users** as people who are used to Windows or Mac, prefer software installers to package managers, \gls{gui} programs rather than \gls{cli} based ones and do not feel comfortable with manually modifying their systems or using scripts.

We define **power users** as users who manage a number of personal physical machines and may have some familiarity with Linux, terminals and shell scripting. They are assumed to be able to execute the necessary steps to setup a machine given a guide.

For our purposes we define **enterprises** as companies with operations departments that manage their IT infrastructure and optimize for scale. They usually have large numbers of Linux based servers which are a combination of physical, virtual and container based. Those can be deployed either in the cloud or on premise in an automated way using \gls{iac} tools. 

## Problem description

MPyC supports \gls{tcp} connections from the \gls{ip} suite between the \gls{mpc} participants but it does not currently provide a service discovery mechanism. Before performing a joint computation, all parties must know and be able to reach each other's \gls{tcp} endpoints - either via a local \gls{ip} address on a \gls{lan}, or via a public \gls{ip} address or the \gls{dns} on the internet. This is not likely to pose a problem for most enterprise users, who are usually already exposing some public services, e.g. their website. However, most casual users who are not \gls{it} experts typically do not own a domain name nor know how to configure a publicly accessible server. Due to the limited supply of addresses supported by \gls{ip}v4 and the slow adoption of \gls{ip}v6, most \glspl{isp} do not allocate a public address for each machine in the home networks of their residential customers. Usually only their router has a temporary public address and it utilizes techniques such as \gls{nat} in order to enable the other local machines to initiate remote internet connections. However, connections to them cannot be initiated from outside the \gls{lan} without manually configuring port forwarding in the router to send the appropriate traffic to the intended machine. This poses some challenges and limits the usability of MPyC in every day scenarios due to the inherently \gls{p2p} nature of the involved communications.

## Research questions

Based on the problem description above, we formulate the following central research question:

*How can MPyC be extended to enable casual users, power users and enterprises with limited prior knowledge of each other to discover each other and perform a secure multiparty computation under diverse networking conditions?*

We further identify the following sub-questions:

- *What deployment strategies should be supported in order to accommodate the potential users of MPyC programs?*

Depending on the technical background of a user and their typical computing usage, they might have different expectations for how to execute their part of the joint multiparty computation, e.g. enterprises might expect support for automation tools, while casual users could expect simplicity. There should be some safety (not necessarily security) mechanism for detecting and preventing mistakes where the users are accidentally executing incompatible MPyC programs/versions.

- *What are the most suitable approaches for a party to obtain an identity and prove it to other parties for the purposes of MPC?*

A party's digital identity is a persistent mechanism that allows others to provably track it across digital interactions with the party. An identity can either be issued by a digital authority, e.g. an organization like google, or a country's government or it can be self-issued. Depending on the method, an identity verification can involve demonstrating a cryptographic proof of ownership of a public key, or separate communication with the digital authority.

- *What mechanisms can be used by the parties to initially get in contact and discover each other's identities?*

Different approaches should be considered based on the types of users and their prior relationships. Some examples could be for companies to publicly post their identities on their websites, end-users who know each other could use social media or group chats and if they do not know each other, they could use an (anonymous) matchmaking service.

- *How can the parties establish communication channels with each other based on the chosen identity solutions under diverse networking conditions?*

As previously mentioned, some parties could be on a home network and not have a public \gls{ip}, which may require considering approaches that use a mediator.

- *How can the parties communicate securely as part of the MPC execution? To what extent can the parties' privacy be preserved? How efficiently can this be achieved?*

In order for the execution of an \gls{mpc} protocol to be secure, it is important for the parties to be able to cryptographically verify the identity of a message's original sender and be certain that nobody other than themselves can read it. Solutions that do not reveal physically identifying information such as \gls{ip} addresses are also interesting to consider. The performance overhead of the security mechanisms should be evaluated.

## Preparation phase scope

During the implementation phase, we will answer the posed research questions of the project after evaluating various connectivity approaches for MPyC. The scope of the preparation phase will cover a technical survey to identify some of the tools that can be used and the development of an \gls{e3} that will support the evaluation process in the next phase. \gls{e3} must enable fearless experimentation with different implementations of the connectivity layer. \gls{e3} will focus on being reproducible by enterprise and power users while keeping it representative of real world scenarios involving casual users as well.

Below, we formulate our requirements for \gls{e3} and group them in terms of several important characteristics:

- Complexity
  - simple - given the limited time of the preparation phase, \gls{e3} must focus on simplicity, e.g. the easiest to implement connectivity approach should be chosen
  - extensible - \gls{e3} must allow for switching the building blocks during the next phase of the project, e.g. it should be easy to experiment with different connectivity approaches in order to measure and compare their characteristics
- Source code
  - open-source - the source code of the resulting implementation of \gls{e3} must be available in a public repository, e.g. on Github.com
  - no plaintext secrets such as \gls{api} keys and passwords should be present in the public repository, but others should be able to easily provide their own secrets in order to use \gls{e3} in their own environment.
- Deployment
  - cross region - the machines should be provisioned in multiple geographical regions in order to be able to observe the effects of varying latency on the system
  - cross platform - in a real world scenario the machines will be controlled by different parties that run various operating systems, hardware architectures and deployed using different tools, e.g. Party A might be an enterprise that uses containers, while Party B is a power user running a few \glspl{vm} and Party C ****could be using an ARM-based raspberry pi
  - automated - appropriate tools should be chosen to allow automatically deploying and destroying the runtime environment without manual intervention other than running a minimal set of commands
  - reproducible - it should be easy for others to reproduce the test setup in their own environment
  - disposable - \gls{e3} should be easy to destroy and quickly recreate from scratch at any time; as in the famous DevOps analogy [@biasHistoryPetsVs2016], it should be based on machines that are like cattle rather than pets
- Connectivity
  - identity - it must be possible for the machines to communicate based on a long-lived identity rather than a potentially temporary \gls{ip} address.
  - secure - a message sent by a party must be readable only by its intended targets.
  - authenticated - a party must be able to determine which party a message was sent by
  - private - no more information than strictly necessary should be revealed about a party. Depending on the method of communication, it may be necessary to choose a tradeoff or introduce a tuning parameter between performance and privacy.
