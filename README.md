# circleci-server4-manager

#### Prerequisites

- The following orbs need to be imported:
  - `circleci/path-filtering@0.1.3`
  - `circleci/aws-cli@3.1`

Docs on how to import a public orb: https://circleci.com/docs/server-3-operator-orbs/#import-a-public-orb

- The following contexts:
  - `server4-deploy` with the following env_vars:
    
    ```
     - $AZURECR_USER
     - $AZURECR_PWD
     - $AWS_DEFAULT_REGION
     - $AWS_ACCESS_KEY
     - $AWS_SECRET_KEY
    ```
