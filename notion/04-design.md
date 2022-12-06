---
link: https://www.notion.so/04-design-348f729ade21489b82af8f7a7b946221
notionID: 348f729a-de21-489b-82af-8f7a7b946221
---
# Design

## 

## Summary

We have designed an extensible setup for running experiments with various MPyC networking scenarios including combinations of cloud and physical machines.

The test setup is currently using DigitalOcean as a cloud provider because they offer free credits to students but the setup can be adapted to other cloud providers.

The cloud provisioning is defined declaratively using Terraform. The setup allows to define a set of machines across the regions supported by DigitalOcean, e.g. Amsterdam, New York City, San Francisco, Singapore and others.

The machines run NixOS - a declarative and highly reproducible Linux distribution.
