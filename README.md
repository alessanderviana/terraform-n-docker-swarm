# Terraform, saltstack and Docker swarm
A Docker Swarm cluster started up with terraform and saltstack.

To replicate this environment you'll need to have a Google Cloud account,
clone this repository and follow the steps below:

 ## 1) Change the variables at the start of the swarm-cluster.tf file

 You can change any of the variables, but the main changes are:

 - gcp_project,
 - credentials,
 - pub_key and,
 - priv_key

 ## 2) Run the terraform commands:

 ```bash
 $ terraform init
 $ terraform plan
 $ terraform apply -auto-approve
 ```

 - The first makes the terraform plugin download (cloud provider plugin).
 - The second is optional, it's just to see what will be created and its details.
 - The last command apply plan (the content of all .tf files) and automatically
 answers yes (-auto-approve).

 Terraform will start a number of instances equals to the count parameter in
 swarm-cluster.tf file and will install the saltstack software.

 The saltstack will install the Docker software and configure the saltstack
 (master and minions).
 The first instance (swarm-cluster-1) will be the salt master, any other will
 be a minion.

 ## 3) Login to the salt master instance

 ```bash
 $ gcloud compute ssh ubuntu@swarm-cluster-1 --zone=us-central1-b --ssh-key-file=THE/PATH/TO/YOUR/PRIVATE/KEY
 ```
 Or

 ```bash
 $ ssh -i THE/PATH/TO/YOUR/PRIVATE/KEY ubuntu@THE_SWARM_CLUSTER_1_PUBLIC_IP
 ```

 If you changed the USER variable in the swarm-cluster.tf file switch them in
 the above commands.
 Do the same to the zone.

 Inside the instance run the command to follow up the syslog and see when is
 gonna finish.

 ```bash
 $ tail -f /var/log/syslog | grep startup-script
 ```
 At the end, it'll be show a saltstack report and a message saying that the
 startup script finished.

 Then to verify if the minions also finished, run the command to list the salt
 unaccepted keys.

 ```bash
 $ salt-key -l un
 ```

 The number of keys listed shall be equals to the total number of instances
 (master + minions). If not, maybe some of them don't have finished the saltstack
 'apply state' yet. I believe this will not happen, because it not happened
 with me after the tests stages.

 But if it happen, you can login in the instance you are not able to see in the
 keys list and verify the syslog. Search by the end of salt 'apply state' command.

 If everything is ok in syslog, you can restart the minion service at this
 instance (with root).

 ```bash
 $ systemctl restart salt-minion
 ```

 Run again the command `salt-key -l un` and with everything right, lets to the
 next step.
