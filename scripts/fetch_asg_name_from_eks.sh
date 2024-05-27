
node_group_name=$(aws eks list-nodegroups --cluster-name "$CLUSTER" | jq -r '.nodegroups[0]')
echo "fetching nodegroup name from EKS using awscli"

if [[ -z "$node_group_name" ]]; then
   echo "No managed node groups found for cluster: $CLUSTER"
   exit 1
fi
            
# Get the ASG name from the first node group
asg_name=$(aws eks describe-nodegroup --cluster-name "$CLUSTER" --nodegroup-name "${node_group_name}" | jq -r '.nodegroup.resources.autoScalingGroups[0].name')

echo $asg_name
                
