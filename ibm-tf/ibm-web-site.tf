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

# variables supplied from terraform.tfvars

variable "iaas_ibm_classic_user" {}
variable "iaas_ibm_classic_api_key" {}
variable "iaas_ibmcloud_api_key" {}
variable "iaas_ibm_region" {default = "dal09"}
variable "iaas_ibm_ssh_key" {}
variable "private_key_path" {}

provider "ibm" {
  iaas_classic_username = "${var.iaas_ibm_classic_user}"
  iaas_classic_api_key	= "${var.iaas_ibm_classic_api_key}"
  ibmcloud_api_key  = "${var.iaas_ibmcloud_api_key}"
  generation = 1
  region = "${var.iaas_ibm_region}"
  version = "~> 0.28"
}

resource "ibm_compute_ssh_key" "test_ssh_key" {
  label = "ibm_cloud_ssh"
  notes	= "ssh key for VM"
  public_key = "${file(var.iaas_ibm_ssh_key)}" 
}

resource "ibm_security_group_rule" "allow_port_ssh_22"{
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  security_group_id = "${ibm_security_group.ssh.id}"
  }

resource "ibm_security_group_rule" "allow_port_http_80"{
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  security_group_id = "${ibm_security_group.ssh.id}"
  }

resource "ibm_security_group" "ssh"{
  name        = "allow_ssh"
  description = "Allow SSH traffic to the VM"
  }

resource "ibm_compute_vm_instance" "vm1" {
  hostname		= "yum-repo-rasp-pi"
  domain		= "sayan.tech"
  os_reference_code	= "REDHAT_7_64"
#  os_reference_code	= "UBUNTU_16_64"
  datacenter		= "dal09"
  network_speed		= 10
  hourly_billing	= true
  private_network_only	= false
  cores			= 1
  memory		= 1024
  disks			= [25, 100]
  tags 			= ["Repository"]
  local_disk		= false
  ssh_key_ids		= ["${ibm_compute_ssh_key.test_ssh_key.id}"]
  public_security_group_ids = ["${ibm_security_group.ssh.id}"] 

###############################################
# Execute Hello World on machine to allow     #
# the machine to settle before returning      #
# control to other configuration processes    #
###############################################
  provisioner "remote-exec"{
  inline = [ "echo 'Hello World'" ]

  connection {
    type        =  "ssh"
    user        = "root"
    private_key = "${file(var.private_key_path)}"
    host        = "${self.ipv4_address}"
    }
  }

}
