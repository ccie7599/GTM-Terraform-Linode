# GTM-terraform-Linode
 
## Overview

These are scripts and Terraform templates designed to automate the process of building an Akamai Global Traffic Management (GTM) domain and property, with backend targets pointing to Linode Virtual Machines that share the same tag. The script can also be run on any interval to refresh target VMs in the event of autoscaling or other recycling events, ensuring that GTM has fresh targets. The script also includes an Akamai DNS Terraform resource to automate the creation of a CNAME pointing to the GTM property name. 

When deployed, these scripts and terraform give the ability to dynamically provision and maintain a global endpoint via GTM for multi-region application deployments using Linode Virtual Machines, even as machines in the deployment are created and destroyed.

## Prerequisites 

- jq and terraform installed on the local machine that is running the scripts.
- An Akamai API token, stored in ~/.edgerc
- The linode-cli client, configured with a valid Linode API token.

## Features 

- The script will read Linode information via the Linode API for all virtual machines that share a defined tag (currently, the tag value is set in the variables section of the ```process-linodejson``` script in this repository.

- In the event that machines share a region, the script will cocatenate the IP addresses from all machines in the region into a single GTM target, with a server entry for each machine.

- The script filters IP addresses within the Linode Private Network range ```192.168/16``` so they are not loaded as GTM target servers.

- 
## To-do

- Add Liveness check automation
- Add Ion, CPS, Kona automation for end-to-end Akamai Provisioning

## Instructions

- Clone this repo locally.
- change the tag variable value to the desire Linode tag within the ```process-linodejson``` file, as shown below with a value of "NATS":
```
#!/bin/bash

LNINPUTFILE="linodejson"
tag="NATS"
```
- Update tf.tfvars with the required variables
  - Akamai contract and group ID (contractid and groupid) (existing, based on your Akamai account)
  - GTM Domain Name (domain) (Initially new on creation, cannot collide with existing GTM Domain names in use)
  - GTM Property Name (property) (Initially new on creation, cannot collide with existing GTM Property names in use within the domain)
  - Common Name (cn) (The DNS name of the CNAME that will point to GTM- must be a DNS domain within same Akamai contract)
  - Zone (zone) (DNS Zonefile to update with the CNAME record)
- Run ```terraform init``` to initialize initial terraform state, followed by ```terraform plan --var-file=tf.tfvars``` to validate your terraform plan, and finally ```terraform apply ---var-file=tf.tfvars``` to apply the terraform plan.

Subsqeuent to the inital GTM domain and property creation, ```./process-targets``` can be run to update property.tf with new server targets as machines are created and destroyed. The new property.tf will then need to be applied in terraform for GTM changes to take effect.

