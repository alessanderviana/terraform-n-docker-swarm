echo '========== Getting credentials and auth =========='
gsutil cp gs://terraform-n-docker-swarm/kubernetes-svc.json credentials.json
gcloud auth activate-service-account \
  kubernetes-svc@infra-como-codigo-e-automacao.iam.gserviceaccount.com \
  --key-file=credentials.json
echo '========== Getting master IP =========='
SALT_MASTER_IP=$( gcloud compute instances list --filter="(name=swarm-cluster-1 AND zone:us-central1-b)" --format="value(networkInterfaces[0].networkIP)" )
echo '========== Configuring Salt minion =========='
sed -i 's/#master: salt/master: '$SALT_MASTER_IP'/' /etc/salt/minion
echo '========== Restarting service =========='
systemctl enable salt-minion
