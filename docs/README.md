# Overview

Testudo is a project that assists red teamers to spin up redirectors, jumpboxes, and Command and Control (C2) servers that are typically used for red team infrastructure. This allows teams to quickly deploy infrastructure for on the fly operations.

By default, Testudo configures the following:

* One Windows jumpbox
* One Ubuntu jumpbox
* One Ubuntu redirector
* One Ubuntu C2 server

## What this project does:

* Creates the framework required for a typical red team infrastructure via AWS
* Allows the users to change AMIs to fit their security stack / tooling
* Configures network to allow each part of the infrastructure to communicate seamlessly

## What this project does NOT:

* Explains how C2 servers and redirectors work
* Teach AWS infrastructure and its usage
* Teach Ansible and its usage
