### terraform-GCP
POC in GCP using Terraform

## Use
* export TF_VAR_account_gcp_path="/dir/credencial.json"
* echo $TF_VAR_account_gcp_path
* gcloud auth application-default login
* terraform init
* terraform plan
* terraform apply