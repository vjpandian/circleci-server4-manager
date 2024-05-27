

eksctl utils write-kubeconfig --cluster=$CLUSTER

if [ -z "${REGCRED_SECRET}" ]; then
  echo "REGCRED_SECRET var is not set. Exiting..."
  exit 1
fi

# Check if the namespace already exists
regcred_exists=$(kubectl get secret $REGCRED_SECRET -n $NAMESPACE 2>/dev/null --ignore-not-found)


if [ -z "$regcred_exists" ]; then
  # Create the namespace
  # Create regcred secret
  kubectl -n $NAMESPACE create secret docker-registry $REGCRED_SECRET \
    --docker-server=https://cciserver.azurecr.io \
    --docker-username=$CUSTENG_AZURECR_USER \
    --docker-password=$CUSTENG_AZURECR_PWD \
    --docker-email=vijay@circleci.com \
    --dry-run=client -o yaml | kubectl -n $NAMESPACE apply -f -
  echo "Secret $REGCRED_SECRET was created in $NAMESPACE"
else
  echo "$REGCRED_SECRET already exists....will skip creation"
fi
