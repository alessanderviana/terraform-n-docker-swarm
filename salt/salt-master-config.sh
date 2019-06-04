echo '========== Configuring Salt master =========='
sudo sed -i 's/#file_roots:/file_roots:/g' /etc/salt/master
sudo sed -i 's/#  base:/  base:/g' /etc/salt/master
sudo sed -i 's/#    - \/srv\/salt/    - \/srv\/salt/g' /etc/salt/master
sudo sed -i 's/#file_recv: False/file_recv: True/' /etc/salt/master
sudo sed -i 's/#pillar_roots:/pillar_roots:/' /etc/salt/master
sudo sed -i 's/#  base:/  base:/' /etc/salt/master
sudo sed -i 's/#    - \/srv\/pillar/    - \/srv\/pillar/' /etc/salt/master
sudo mkdir -p /srv/{salt,pillar}
echo '========== Configuring Salt minion =========='
sudo sed -i 's/#master: salt/master: 127.0.0.1/' /etc/salt/minion
echo '========== Restarting services =========='
sudo systemctl restart salt-master && sudo systemctl restart salt-minion
