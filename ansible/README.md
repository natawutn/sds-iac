# IaC @ software-defined-system / ansible
Ansible is the provisioning tool being taught in the class.  This repository contains ansible example inventory and several ansible playbooks.  They are designed to work with GCP compute-engine instances created by multiple compute-engine instances terraform example.

## Installation
You must first install ansible.  One of the easiest way is to use pip.
- Run the following command:
```pip install ansible```
- Set the UTF8 locale by adding the following codes to .bashrc/.zshrc:
```
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
```
- Create a configuration (~/.ansible.cfg), this can be done by using the following tool that comes with ansible:
```
$ ansible-config init --disabled > ~/.ansible.cfg
```
- Suppose, you put inventory in the ~/ansible directory, edit the configration file to include inventory location by adding the following line after default section:
```
[defaults]
inventory       = ~/ansible/inventory
```
