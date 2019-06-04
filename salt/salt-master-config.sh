echo '========== Configuring Salt master =========='
sed -i 's/#file_roots:/file_roots:/g' /etc/salt/master
sed -i 's/#  base:/  base:/g' /etc/salt/master
sed -i 's/#    - \/srv\/salt/    - \/srv\/salt/g' /etc/salt/master
sed -i 's/#file_recv: False/file_recv: True/' /etc/salt/master
sed -i 's/#pillar_roots:/pillar_roots:/' /etc/salt/master
sed -i 's/#  base:/  base:/' /etc/salt/master
sed -i 's/#    - \/srv\/pillar/    - \/srv\/pillar/' /etc/salt/master
mkdir -p /srv/pillar
# mkdir -p /srv/{salt,pillar}
echo '========== Configuring Salt minion =========='
sed -i 's/#master: salt/master: 127.0.0.1/' /etc/salt/minion
echo '========== Restarting services =========='
systemctl restart salt-master && systemctl restart salt-minion

# tail -f /var/log/syslog | grep startup-script
# salt-key -L
# salt-key -A -y
# salt '*' test.ping
