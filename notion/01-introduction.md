# Introduction

This report will present the results of the preparation phase of the master thesis project titled “Secure Dynamic Setup for MPyC Sessions to Support (Ad Hoc) Multiparty Computation”. The goal of the preparation phase is to gain sufficient insight into the topic and propose a plan with well defined goals for the implementation phase of the project.

## Background

Secure Multi-party Computation **(MPC)[@devreedeAssortedAlgorithmsProtocols2020]** is a set of techniques and protocols for computing a function over the secret inputs of multiple parties without revealing their values, but only the final result. The basic working model is that each party first splits its secret input into shares and sends one to each of the other parties using a secret sharing scheme such as Shamir’s Secret Sharing **(SSS)** [@shamirHowShareSecret1979]. After this, using a (possibly interactive), protocol involving multiple communication steps and further re-shares of intermediate secret results, each party can compute the final result from the shares it has received from the other parties.

A number of MPC frameworks have been developed for various programming languages and security models. The results of this project should be adaptable to any MPC framework, but we will use the **MPyC**[@schoenmakersMPyCMultipartyComputation2022; @MPyC] framework as a case study. It is an opensource framework developed in Python primarily at TU Eindhoven. MPyC currently requires that all parties know and can reach each other's public IP addresses before they can perform a computation together. This limits its usability in everyday scenarios because IP addresses provided by Internet Service Providers (**ISP**s) to their customers are usually temporary. Additionally, often only the router in a home network has a public IP address, while the individual machines only have a local IP address, which allows them to initiate connections to public IP addresses outside the Local Area Network (**LAN**), but connections to them cannot be initiated from outside. This poses some challenges for the inherently peer-to-peer nature of MPC communications.

## Problem Statement

The goal of this master project is to explore how can MPyC support dynamic sessions where the parties have limited prior knowledge of each other.

The primary research questions are:

- How do parties find each other for an MPyC session?
- How are parties identified and/or authenticated?
- How to establish peer-to-peer links?
- How to do secure communication?
- How to deploy MP(y)C?

## Approach

In the implementation phase of the project we will explore and evaluate various connectivity approaches for MPyC in networking scenarios that closely resemble real world use. In the preparation phase we will develop an extensible test environment in order to support this process by allowing us to easily swap the connectivity layer.
