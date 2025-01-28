# Testudo - Red Team Infrastructure Automation

## Overview

Testudo is a project that assists red teamers to spin up redirectors, jumpboxes, and Command and Control (C2) servers that are typically used for red team infrastructure. This allows teams to quickly deploy infrastructure for on the fly operations.

By default, Testudo configures the following:
- One Windows jumpbox
- One Ubuntu jumpbox
- One Ubuntu redirector
- One Ubuntu C2 server
- One Ansible Controller

> If there is a need to add more machines to this environment, please read the documentation [HERE](https://testudo.gitbook.io/wiki/expanding-testudo).

### What this project does:

- Creates the framework required for a typical red team infrastructure via AWS
- Allows the users to change AMIs to fit their security stack / tooling
- Configures network to allow each part of the infrastructure to communicate seamlessly

### What this project does NOT:

- Explains how C2 servers and redirectors work
- Teach AWS infrastructure and its usage
- Teach Ansible and its usage

## Prerequisites

- Ensure that you have a configured AWS account
- Ensure that [AWS-CLI](https://aws.amazon.com/cli/) is installed and configured for terraform usage

## Usage

### Installation

Ensure you edit the `OPERATOR_IPS` and `ROE_IPS` variables within the `vars.tf` file to include your ROE and operator CIDR ranges.

```
git clone https://github.com/0xFFaraday/Testudo.git && cd Testudo

# Initialize project
terraform -chdir=provider/aws init

# Create virtual environment
python3 -m venv .testudo-env

# Active virtual environment
source .testudo-env/bin/activate

# Download and install needed packages
pip install -r requirements.txt

# Time to rock and roll!
python testudo.py --help
```

### Deployment

```
# Deploy infrastructure
python testudo.py -pt -v

# Retrive status of machines
python testudo.py -s

# Run main ansible playbook
python testudo.py -pa -v
```

### Destroy Infrastructure

```
# Destroy infrastructure
python testudo.py -d -v
```

### Final Configuration

Now you should be able to use RDP with the specified credentials within `ansible/data/config.json` or SSH directly to the linux jumpbox with the key `linux-key-pair.pem` to finish configuring your team's redirectors and C2 servers.

#### C2 Installer

Testudo also provides a installer script located at `~/c2-setup-scripts/setup.sh` on all deployed C2 servers to install one of the following C2 servers:
- [Empire](https://github.com/BC-SECURITY/Empire)
- [Sliver](https://github.com/BishopFox/sliver)
- [Havoc](https://github.com/HavocFramework/Havoc)

This script is recommended to be used after the environment is provided and provisioned.

For anything that might not be covered within this README, please go to the [documentation](https://testudo.gitbook.io/wiki) for further information.

## Disclaimer

Testudo is purely made for educational purposes. Testudo's maintainers are not responsible for its usage.

## Shoutouts

I personally wanted to give a shoutout to the [GOAD](https://github.com/Orange-Cyberdefense/GOAD) project and its contributors. Another awesome project I recommend checking out is Michael Taggart's [Seclab](https://github.com/mttaggart/seclab). Both of these projects have been amazing resources for getting Testudo in the place it is today!