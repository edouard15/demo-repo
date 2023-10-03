#!/bin/bash

set -x
cd admin
echo $(aws sts get-caller-identity)
sleep 5

terrform fmt -recursive
terrform init 
terrform validate
terrform plan
terrform apply -auto-approve
##########################

cd ../resources
TF_VAR_environment=prod
ENVIRONMENT="${TF_VAR_environment}"
TF_PLAN="${ENVIRONMENT}.tfplan"
TF_PLAN_JSON="${TF_PLAN}.json"
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_AWS_ROLE=ec2-admin-role
export VAULT_TOKEN=$(cat ~/.vault-token)
sleep 5

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
sleep 5

export AWS_CREDS="$(vault read aws/creds/${VAULT_AWS_ROLE} -format=json)"
export AWS_ACCESS_KEY_ID="$(echo $AWS_CREDS | jq -r .data.access_key)"
export AWS_SECRET_ACCESS_KEY="$(echo $AWS_CREDS | jq -r .data.secret_key)"
export AWS_DEFAULT_REGION="us-east-1"

[ -d .terrform ] && rm -rf .terraform


