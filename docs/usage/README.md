# Usage

## Prerequisites

* Ensure that you have a configured AWS account
* Ensure that [AWS-CLI](https://aws.amazon.com/cli/) is installed and configured for terraform usage
  * Ensure `[testudo]` exists within the file `~/.aws/credentials`&#x20;

## Installation

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

## Deployment

```
# Deploy infrastructure
python testudo.py -pt -v

# Retrive status of machines
python testudo.py -s

# Run main ansible playbook
python testudo.py -pa -v
```

Now choose a beverage of your choice and wait. Once Ansible is finished, you and your team will have infrastructure ready to go for your operation! It is highly recommended to change all the default credentials since provisioning is now finished.

## Final Configuration

Now you should be able to use RDP with the specified credentials within `ansible/data/config.json` or SSH directly to the linux jumpbox with the key `linux-key-pair.pem` to finish configuring your team's redirectors and C2 servers.

## Subnet Layout

|    Hosts    |    Subnets    |
| :---------: | :-----------: |
| Redirectors | 172.16.1.0/24 |
|  C2 Servers | 172.16.2.0/24 |
|  Jumpboxes  | 172.16.3.0/24 |

## AWS Diagram

<figure><img src="../.gitbook/assets/Testudo-AWS.png" alt=""><figcaption></figcaption></figure>

