# terraform-saltstack-n-docker-swarm
A Docker Swarm cluster started up with terraform and saltstack.

To replicate this environment you'll need to have a Google Cloud account,
clone this repository and follow the steps below:

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

 The first makes the terraform plugin download (cloud provider plugin).
 The second is optional, it's just to see what will be created and its details.
 The last command apply plan (the content of all .tf files) and automatically
 answers yes (-auto-approve).

 Terraform will start a number of instances equals to the count parameter in
 swarm-cluster.tf file and will install the saltstack software.
 The saltstack will install the Docker software and configure the saltstack
 (master and minions).
 The first instance (swarm-cluster-1) will be the salt master, any other will
 be a minion.

 3. Login to the salt master instance

 ```bash
 $ gcloud compute ssh ubuntu@swarm-cluster-1 --zone=us-central1-b --ssh-key-file=THE/PATH/TO/YOUR/PRIVATE/KEY
 ```
 Or

 ```bash
 $ ssh -i THE/PATH/TO/YOUR/PRIVATE/KEY ubuntu@THE_SWARM_CLUSTER_1_PUBLIC_IP
 ```
