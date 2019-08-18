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
 count = 2
 name         = "swarm-cluster-${count.index + 1}"
 machine_type = "g1-small"  # 1.7 GB RAM
 zone         = "${var.region}-b"

 tags = [ "swarm-cluster-${count.index + 1}" ]

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

 metadata_startup_script = <<SCRIPT
    cd /root && git clone https://github.com/alessanderviana/terraform-n-docker-swarm.git
    ln -s /root/terraform-n-docker-swarm/salt /srv
    HOST_NUMBER=$( hostname | awk -F'-' '{ print $NF }' )
    if [ $HOST_NUMBER -gt 1 ]; then
      curl -L https://bootstrap.saltstack.com | sh && \
      bash /srv/salt/salt-minion-config.sh
    else
      cd /tmp && curl -L https://bootstrap.saltstack.com -o install_salt.sh
      sh /tmp/install_salt.sh -M && bash /srv/salt/salt-master-config.sh
    fi
    salt-call state.apply --local
SCRIPT

}
