variable "region" {
  default = "us-central1"
}
variable "gcp_project" {
  default = "infra-como-codigo-e-automacao"
}
variable "credentials" {
  default = "~/repositorios/terraform/gcloud/credentials.json"
}
variable "vpc_name" {
  default = "default"
}
variable "user" {
  default = "ubuntu"
}
variable "pub_key" {
  default = "~/repositorios/terraform/alessander-tf.pub"
}
variable "priv_key" {
  default = "~/repositorios/terraform/alessander-tf"
}

// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}"
 region      = "${var.region}"
}

// Linux instance - Ubuntu 16.04
resource "google_compute_instance" "swarm-cluster" {
 name         = "swarm-cluster"
 machine_type = "g1-small"  # 1.7 GB RAM
 zone         = "${var.region}-b"

 tags = [ "swarm-cluster" ]

 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20190306"
   }
 }

 network_interface {
   subnetwork = "default"
   access_config { }
 }

 metadata {
   ssh-keys = "${var.user}:${file("${var.pub_key}")}"
 }

 provisioner "file" {
   connection {
     type = "ssh"
     user = "${var.user}"
     private_key = "${file("${var.priv_key}")}"
     agent = false
   }

   source      = "salt"
   destination = "~/"
}

 metadata_startup_script = <<SCRIPT
<<<<<<< HEAD
    curl -L https://bootstrap.saltstack.com | sh
    systemctl stop salt-minion && systemctl disable salt-minion
=======
    HOST_NUMBER=$( hostname | awk -F'-' '{ print $NF }' )
    if [ $HOST_NUMBER -gt 1 ]; then
      curl -L https://bootstrap.saltstack.com | sh
    else
      cd /tmp && curl -L https://bootstrap.saltstack.com -o install_salt.sh
      ln -s /home/ubuntu/salt /srv
      sh /tmp/install_salt.sh -M && bash /srv/salt/salt-master-config.sh
    fi
<<<<<<< HEAD
>>>>>>> 39dfece... Changed a environment variable
    ln -s /home/ubuntu/salt /srv
=======
>>>>>>> 063bfcb... Moved the position of link creation line
    salt-call state.apply --local
    salt-call service.restart nginx --local
    salt-call service.restart jenkins --local
SCRIPT

}
