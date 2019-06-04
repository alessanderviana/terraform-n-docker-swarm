docker_repository:
  pkgrepo.managed:
    - humanname: Docker CE REPO
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg

docker-ce:
  pkg.installed:
    - require:
      - pkgrepo: docker_repository
