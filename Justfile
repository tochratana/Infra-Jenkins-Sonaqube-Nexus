#!/bin/bash

# Create DevOps infrastructure (Jenkins, SonarQube, Nexus)
create-infra:
    echo "Creating GCP infrastructure (Jenkins, SonarQube, Nexus) ..."
    ansible-playbook playbooks/create-infra.yml

# Destroy DevOps infrastructure
destroy-infra:
    echo "Destroying GCP infrastructure ..."
    ansible-playbook playbooks/destroy-infra.yml -e "destroy_infrastructure=true"

# Ping all created machines to verify connectivity
ping-machines:
    echo "Pinging all GCP instances ..."
    ansible -i inventory/gcp_dynamic.ini all -m ping

# Display information about created machines
info-machines:
    echo "GCP Instances Information:"
    cat inventory/gcp_dynamic.ini

# Run k8s masters-workers infrastructure (legacy)
iac: 
    echo "Create all the masters ....  " 
    ansible-playbook playbooks/create-masters-instance.yaml
    echo "Create all the workers ..... "   
    ansible-playbook playbooks/create-workers-instance.yaml

