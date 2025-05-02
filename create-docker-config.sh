#!/bin/bash

AWS_ACCOUNT_ID="129734005271"
AWS_REGION="us-east-1"

TOKEN=$(aws ecr get-login-password --region ${AWS_REGION})

cat <<EOC > config.json
{
    "credsStore": "ecr-login",
    "auths": {
        "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com": {
            "auth": "$(echo -n "AWS:${TOKEN}" | base64)"
        }
    }
}
EOC

kubectl create secret generic docker-config     --from-file=config.json     --namespace jenkins     --dry-run=client -o yaml | kubectl apply -f -
