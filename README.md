# Terraform, saltstack and Docker swarm
A Docker Swarm cluster started up with terraform and saltstack.

To replicate this environment you'll need to have a Google Cloud account,
fork this repository and follow the steps below:

 ## 1) Change the variables at the start of the swarm-cluster.tf file

 You can change any of the variables, but the main changes are:

 - gcp_project,
 - credentials,
 - pub_key and,
 - priv_key

 You'll have to change also the first line of the startup script in the
 swarm-cluster.tf file to your repository.

 ```
 cd /root && git clone https://github.com/alessanderviana/terraform-n-docker-swarm.git
 ```
 If you changes the repository name, you'll have to change the symlink creation
 line too.

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
 gonna finish. Better with root user.

 ```bash
 # tail -f /var/log/syslog | grep startup-script
 ```
 At the end, it'll be show a saltstack report and a message saying that the
 startup script finished.

 Then to verify if the minions also finished, run the command to list the salt
 unaccepted keys.

 ```bash
 # salt-key -l un
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
 # systemctl restart salt-minion
 ```

 Run again the command `salt-key -l un` and with everything right, lets to the
 next step.

 ## 4) Run the cluster init script

 ```bash
 # bash ~/terraform-n-docker-swarm/salt/docker-swarm-init-cluster.sh
 ```

 ### What does it do?

 This script does the following:

 - Accepts / enables all the salt keys listed in the previous step,
 - Initializes the cluster in the main node (swarm-cluster-1),
 - Gets the join-token for workers nodes,
 - Lists the no main nodes,
 - And joins these nodes to the cluster.

 After that your cluster will be up. To check your cluster nodes you can use
 the command `docker node ls`.

 And have fun!

 You can create a Docker swarm service with any Docker image.

 ```
 docker service create --name phoenix-app -p 4000:4000 --replicas 4 registry.gitlab.com/alessanderviana/sre-challenge/elixir-phoenix:latest
 ```

 | OBS                                                                        |
 | -------------------------------------------------------------------------- |
 | This app takes almost one minute to be available, because it compiles the  |
 | dependencies each time your run a container from its image                 |

 This is a sample app that have the endpoints 'hello' and 'word'. You can access
 them inside the instances with `curl localhost:4000/api/hello` and
 `curl localhost:4000/api/word`.

 Or externally (if the port 4000 is allowed in your Google firewall rules) with
 `curl YOUR_INSTANCE_EXTERNAL_IP:4000/api/hello` and
 `curl YOUR_INSTANCE_EXTERNAL_IP:4000/api/word`.
