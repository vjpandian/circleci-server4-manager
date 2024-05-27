
if [ -z "${NAMESPACE}" ]; then
  echo "NAMESPACE is not set. Exiting..."
  exit 1
fi

major_version=$(echo "$HELM_VERSION" | cut -d '.' -f 1)
minor_version=$(echo "$HELM_VERSION" | cut -d '.' -f 2)


if [ "$major_version" -eq 4 ] && [ "$minor_version" -le 2 ]; then
    VALUES_FILE="${NAMESPACE}-pre_43_helm-values.yaml"
    echo "$VALUES_FILE will be used for helm deploy"
elif [ "$major_version" -eq 4 ] && [ "$minor_version" -ge 3 ] && [ "$minor_version" -le 5 ]; then
    VALUES_FILE="${NAMESPACE}-post_43_helm-values.yaml"
    echo "$VALUES_FILE will be used for helm deploy"
else
    echo "Version not supported: $HELM_VERSION"
    exit 1
fi


if [ -z "${VALUES_FILE}" ]; then
  echo "Helm values var is not set. Exiting..."
  exit 1
fi

namespace_exists=$(kubectl get namespace $NAMESPACE 2>/dev/null --ignore-not-found)

if [ -z "$namespace_exists" ]; then
    echo "Namespace $NAMESPACE will be created."
    kubectl create ns $NAMESPACE
    echo "helm install $VALUES_FILE $HELM_VERSION will be run"
    helm registry login cciserver.azurecr.io -u $CUSTENG_AZURECR_USER -p $CUSTENG_AZURECR_PWD
    helm install cci-$NAMESPACE oci://cciserver.azurecr.io/circleci-server -n $NAMESPACE --version $HELM_VERSION -f ${VALUES_FILE} --username $CUSTENG_AZURECR_USER --password $CUSTENG_AZURECR_PWD
else
    echo "Namespace $NAMESPACE already exists...will skip namespace creation"
    echo "helm upgrade --install $VALUES_FILE $HELM_VERSION will be run"
    helm registry login cciserver.azurecr.io -u $CUSTENG_AZURECR_USER -p $CUSTENG_AZURECR_PWD
    helm upgrade --install cci-$NAMESPACE oci://cciserver.azurecr.io/circleci-server -n $NAMESPACE --version $HELM_VERSION -f ${VALUES_FILE} --username $CUSTENG_AZURECR_USER --password $CUSTENG_AZURECR_PWD
fi
