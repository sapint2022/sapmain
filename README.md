# Terraform and Azure

## linux-vm
- Naviagte to the linux-vm directory
- Update the AzureRM provider details with actual value for authentication
- Execute the below commands to create a virtual machine
- #### Terraform commands
    - terraform init
    - terraform plan -var-file=./project.tfvars
    - terraform apply -var-file=./project.tfvars -auto-approve
- Once the vm is created try to access the webpage using the public ip address "http://***public-ip-address***/index.html"
## azure-policy
- Naviagte to the azure-policy directory
- Update the AzureRM provider details with actual value for authentication
- Execute the below commands to create azure policies
- #### Terraform commands
    - terraform init
    - terraform plan
    - terraform apply -auto-approve
