#!/bin/bash

# First, give execution permission - 'chmod +x deploy.sh'

# Script to automatize deploy of kubernetes

filelist=()

for file in ./*.yaml
do
  echo "$file"
  filelist+=($file)
done

printf "\n\n************* ${filelist[0]} START TASKS ****************\n\n"

## Preconfigure nodes
ansible-playbook -i hosts ${filelist[0]} 

printf "\n\n************* ${filelist[0]} END TASKS ****************\n\n"


printf "\n\n************* ${filelist[1]} START TASKS ****************\n\n"
 
## Configure nfs node
ansible-playbook -i hosts ${filelist[1]} 

printf "\n\n************* ${filelist[1]} END TASKS ****************\n\n"


printf "\n\n************* ${filelist[2]} START TASKS ****************\n\n"

## Configure cluster nodes
ansible-playbook -i hosts ${filelist[2]} 

printf "\n\n************* ${filelist[2]} END TASKS ****************\n\n"


printf "\n\n************* ${filelist[3]} START TASKS ****************\n\n"

## Configure master node
ansible-playbook -i hosts ${filelist[3]} 

printf "\n\n************* ${filelist[3]} END TASKS ****************\n\n"


printf "\n\n************* ${filelist[4]} START TASKS ****************\n\n"

## Configure workers nodes
ansible-playbook -i hosts ${filelist[4]} 

printf "\n\n************* ${filelist[4]} END TASKS ****************\n\n"


printf "\n\n************* ${filelist[5]} START TASKS ****************\n\n"

## Configure app deployment
ansible-playbook -i hosts ${filelist[5]} 

printf "\n\n************* ${filelist[5]} END TASKS ****************\n\n"


## For local testing...
# After remove all vms, remove known_hosts entries in this machine
# ssh-keygen -f "/home/alvaro/.ssh/known_hosts" -R "192.168.122.XXX"