# terraform-saltstack-n-docker-swarm
A Docker Swarm cluster started up with terraform and saltstack.

To replicate this environment you'll need to have a Google Cloud account, clone this repository and follow the steps below:

 1. Change the variables at the start of the swarm-cluster.tf file

 You can change any of the variables, but the main changes are:

 - gcp_project,
 - credentials,
 - pub_key and,
 - priv_key

 2. Run the terraform commands:

 ```bash
 $ terraform init
 $ terraform plan
 $ terraform apply -auto-approve
 ```
