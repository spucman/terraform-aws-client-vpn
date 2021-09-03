#!/bin/bash
set -e

# Define variables
tfvars_file="${1}"
if [[ -z "${tfvars_file}" ]]; then
  echo "No tfvars file was specified. Specify the path to the tfvars file in argument 1 for this script, exiting..." && exit 1
fi

# Check if tfvars file exists
if [[ ! -e "${tfvars_file}" ]]; then
  echo "Could not locate tfvars file: ${tfvars_file}. Specify the proper location, exiting..." && exit 1
fi

aws_profile="$2"
if [[ -z "${aws_profile}" ]]; then
    echo "Specify an aws profile in argument 2 for this script"
    exit 1
fi

export AWS_ACCESS_KEY_ID=$(aws configure get ${aws_profile}.aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get ${aws_profile}.aws_secret_access_key)

CERTS_DIR="easy-rsa"
if [[ -d "${CERTS_DIR}" ]]; then
    echo "Directory exist... nothing to do."
else 
    git clone https://github.com/OpenVPN/easy-rsa.git
    cd easy-rsa/easyrsa3
    ./easyrsa init-pki
    ./easyrsa build-ca nopass
    ./easyrsa build-server-full server nopass
    ./easyrsa build-client-full "Add Domain here" nopass
    mkdir certs/
    cp pki/ca.crt certs/
    cp pki/issued/server.crt certs/
    cp pki/private/server.key certs/
    cp pki/issued/testing-terraform-for-fun.com.crt certs
    cp pki/private/testing-terraform-for-fun.com.key certs/
    cd ../../
fi


terraform init -backend-config=backend.conf

echo "Starting terraform"
terraform plan -detailed-exitcode -refresh=true -out=plan.out
