# Copyright 2019, 2020. IBM All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



#Variables supplied by terraform.tfvars or ansible
variable "iaas_aws_access_key" {
}

variable "iaas_aws_secret_key" {
}

# variables supplied from terraform.tfvars
variable "iaas_aws_ssh_key" {
}

variable "iaas_aws_region" {
  default = "ap-southeast-1"
}

variable "iaas_aws_security_group" {
}

variable "private_key_path" {
}

data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-8.?.?_HVM-*-x86_64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web-site-iac" {
  ami             = data.aws_ami.rhel.id
  instance_type   = "t2.micro"
  monitoring      = false
  key_name        = var.iaas_aws_ssh_key
  security_groups = [var.iaas_aws_security_group]

  tags = {
    Name = "Example-VM"
  }

  root_block_device {
    delete_on_termination = true
  }

#Remote execute to wait for complete provisioning before moving to Ansible
  provisioner "remote-exec" {
	inline = [ "echo 'Hello World'"]
	
	connection {
		type		= "ssh"
		user		= "ec2-user"
		private_key 	= file("${var.private_key_path}")
		host		= self.public_ip
  	}
	}

}

resource "aws_eip" "ip" {
  instance = aws_instance.web-site-iac.id
}
