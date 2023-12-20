helm registry login cciserver.azurecr.io -u $AZURECR_USER -p $AZURECR_PWD
helm upgrade $RELEASE_NAME oci://cciserver.azurecr.io/circleci-server -n $NAMESPACE --version $SERVER_VERSION -f $VALUES_FILE --username $CUSTENG_AZURECR_USER --password $CUSTENG_AZURECR_PWD
