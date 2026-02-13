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

# Install services on all created machines
install-services:
    echo "Installing services on all machines (Docker, Jenkins, SonarQube, Nexus, Portainer) ..."
    ansible-playbook playbooks/install-services.yml -i inventory/gcp_dynamic.ini

# Install only Docker on all machines
install-docker:
    echo "Installing Docker on all machines ..."
    ansible-playbook playbooks/install-services.yml -i inventory/gcp_dynamic.ini -t docker

# Install only Jenkins
install-jenkins:
    echo "Installing Jenkins on Jenkins machine ..."
    ansible-playbook playbooks/install-services.yml -i inventory/gcp_dynamic.ini -l jenkins

# Install only SonarQube
install-sonarqube:
    echo "Installing SonarQube on SonarQube machine ..."
    ansible-playbook playbooks/install-services.yml -i inventory/gcp_dynamic.ini -l sonarqube

# Install only Nexus
install-nexus:
    echo "Installing Nexus on Nexus machine ..."
    ansible-playbook playbooks/install-services.yml -i inventory/gcp_dynamic.ini -l nexus


