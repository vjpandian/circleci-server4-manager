
echo "Updating kubeconfig"
eksctl utils write-kubeconfig --cluster=$CLUSTER

echo "Check if the namespace already exists"
namespace_exists=$(kubectl get namespace $NAMESPACE 2>/dev/null)

if [ -z "$namespace_exists" ]; then
  # Create the namespace
  kubectl create namespace $NAMESPACE
  echo "Namespace '$NAMESPACE' created."
else
  echo "Namespace '$NAMESPACE' already exists...will skip namespace creation"
fi
