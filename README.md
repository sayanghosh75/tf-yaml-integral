<!-- This should be the location of the title of the repository, normally the short name -->
# tf-yaml-integral - Terraform Ansible Integration example

<!-- Build Status, is a great thing to have at the top of your repository, it shows that you take your CI/CD as first class citizens -->
<!-- [![Build Status](https://travis-ci.org/jjasghar/ibm-cloud-cli.svg?branch=master)](https://travis-ci.org/jjasghar/ibm-cloud-cli) -->

<!-- Not always needed, but a scope helps the user understand in a short sentance like below, why this repo exists -->
## Scope

The purpose of this repository is to provide example code to demonstrate how a terraform provisioning can be executed from within an ansible playbook. The script demonstrates how the newly provisioned compute resource details can be provided by terraform directly to the ansible playbook for making necessary configuration updates. Script examples are provided for Public Cloud providers.


<!-- A more detailed Usage or detailed explaination of the repository here -->
## Usage

This repository provides terraform scripts for use with AWS and IBM Cloud. The scripts provision a single Virtual Machine on the respective Cloud provider and thereafter install and configure httpd and firewalld on the machine(s).

The scripts transfer an 'index.html' file to the machine, set up appropriate security groups to allow ssh and http access.

The scripts check that the http server is accessible from the local machine  before returning.

Key files:

ibm-secrets.yml: User names and API Keys for accessing IBM Cloud

aws-secrets.yml: API Keys and Secrets for accessing AWS

Uncomment the correct ssh user and key for IBM Cloud or AWS

IMPORTANT: While the above files are provided as examples, it is essential to encrypt these files using 'ansible-vault'

Execution:

Execute ansible-playbook aws-web-site.yml --vault-id @prompt

Execute ansible-playbook ibm-web-site.yml --vault-id @prompt

Files:
1. index.html is located in ./files

Terraform:
1. AWS provider for terraform uses terraform 0.12
2. IBM provider for terraform uses terraform 0.11 - installed in opt/bin2 so as to not override latest version of terraform

Configurations:

ansible.cfg - uncomment the appropriate lines for use with a Public Cloud provider

Cleaning up:
To destroy the provisioned environment, make changes to the script for your own purposes. Simple destruction is by descending into the public cloud terraform directory cd aws-tf or cd ibm-tf and execute 'terraform destroy'

<!-- License and Authors is optional here, but gives you the ability to highlight who is involed in the project -->
## License & Authors

If you would like to see the detailed LICENSE click [here](LICENSE).

- Author: Sayan A Ghosh <sghosh@sg.ibm.com>

```text
Copyright:: 2020-2020 IBM, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
