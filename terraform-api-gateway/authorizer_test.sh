#!/bin/bash
set -eux
#assign credentials to variables
CLIENT_ID = "5t3ejll2p53e7d0j433dcf3qkn"
USER_POOL_ID ="us-east-2_gtOllbdJE"
USERNAME = "testuser"
PASSWORD = "123456"
URL = "https://akrygpsgmc.execute-api.us-east-2.amazonaws.com/prod/movies"
#sign-up user:
aws cognito-idp sign-up \
 --client-id ${CLIENT_ID} \
 --username ${USERNAME} \
 --password ${PASSWORD} 
 
#confirm user:
aws cognito-idp admin-confirm-sign-up  \
  --user-pool-id ${USER_POOL_ID} \
  --username ${USERNAME} 
  
#authenticate and get token
TOKEN=$(
    aws cognito-idp initiate-auth \
 --client-id ${CLIENT_ID} \
 --auth-flow USER_PASSWORD_AUTH \
 --auth-parameters USERNAME=${USERNAME},PASSWORD=${PASSWORD} \
 --query 'AuthenticationResult.IdToken' \
 --output text 
    )
#make API call:
curl -H "Authorization: ${TOKEN}" ${URL} | jq