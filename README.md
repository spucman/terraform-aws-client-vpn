# AWS Client VPN Terraform example

An working example how to configure an AWS Client VPN with terraform.

**Important:** The included certificates shouldn't be used beside doing
a proof of concept or playing around with terraform!

## Basic usage

1. Setup AWS Credentials for your CLI (look at the [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-3-upgrade#provider-authentication-updates) for more details)
1. Change the domain name in the `vpn.tf` where you are having access to (this is needed for the DNS verification)
1. perform `terraform init`
1. perform `terraform apply`
1. download the profile from aws
1. fix the certificate section within the profile (remove the third certificate and add the certificates from `ca-chain.crt` and `client-vpn-ca.crt`)
1. connect with your vpn client (e.g. openvpn) `openvpn --config downloaded-client-config.ovpn --pkcs12 certs/client.p12`
