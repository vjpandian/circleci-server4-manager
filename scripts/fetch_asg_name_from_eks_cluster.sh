#!/bin/bash

# Define colors for pretty output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
ENDCOLOR="\e[0m"


# Function to print a section header
print_section() {
  echo -e "${YELLOW}$1${ENDCOLOR}"
}

print_section "Setting kubeconfig using eksctl"
eksctl utils write-kubeconfig --cluster=$CLUSTER

node_group_name=$(aws eks list-nodegroups --cluster-name "$CLUSTER" | jq -r '.nodegroups[1]')

print_section "Fetching nodegroup name from EKS using awscli"

if [[ -z "$node_group_name" ]]; then
  echo -e "${RED}No managed node groups found for cluster: $CLUSTER${ENDCOLOR}"
  exit 1
fi

# Get the ASG name from the first node group
asg_name=$(aws eks describe-nodegroup --cluster-name "$CLUSTER" --nodegroup-name "${node_group_name}" | jq -r '.nodegroup.resources.autoScalingGroups[0].name')

# Fetch the ASG name
print_section "Found ASG name associated with node group '${node_group_name}': ${asg_name}"
