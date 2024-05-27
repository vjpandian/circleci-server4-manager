

namespace_exists=$(kubectl get namespace $NAMESPACE 2>/dev/null --ignore-not-found)

echo $namespace_exists

if [ -z "$namespace_exists" ]; then
    echo "Namespace $NAMESPACE will be created."
    kubectl create ns $NAMESPACE
    echo "helm install $values_file $HELM_VERSION will be run"
    helm registry login cciserver.azurecr.io -u $CUSTENG_AZURECR_USER -p $CUSTENG_AZURECR_PWD
    helm install cci-$NAMESPACE oci://cciserver.azurecr.io/circleci-server -n $NAMESPACE --version $HELM_VERSION -f ${values_file} --username $CUSTENG_AZURECR_USER --password $CUSTENG_AZURECR_PWD
else
    echo "Namespace $NAMESPACE already exists...will skip namespace creation"
    echo "helm upgrade --install $values_file $HELM_VERSION will be run"
    helm registry login cciserver.azurecr.io -u $CUSTENG_AZURECR_USER -p $CUSTENG_AZURECR_PWD
    helm upgrade --install cci-$NAMESPACE oci://cciserver.azurecr.io/circleci-server -n $NAMESPACE --version $HELM_VERSION -f ${values_file} --username $CUSTENG_AZURECR_USER --password $CUSTENG_AZURECR_PWD
fi
