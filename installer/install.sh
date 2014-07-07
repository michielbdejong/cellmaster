# Rackspace backup agent
sudo sh -c 'wget -q "http://agentrepo.drivesrvr.com/debian/agentrepo.key" -O- | apt-key add -'
sudo sh -c 'echo "deb [arch=amd64] http://agentrepo.drivesrvr.com/debian/ serveragent main" > /etc/apt/sources.list.d/driveclient.list'

# based on http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers
passwd -d root
apt-get -y update
apt-get -y upgrade
apt-get -y install vim ufw fail2ban unattended-upgrades logwatch driveclient docker
useradd -G sudo deploy
mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
mv .ssh/authorized_keys /home/deploy/.ssh/
chmod 400 /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy -R
ufw allow 22
ufw allow 80
ufw allow 443
ufw enable
mv 10periodic /etc/apt/apt.conf.d/
mv 50unattended-upgrades /etc/apt/apt.conf.d/
mv 00logwatch /etc/cron.daily/
passwd deploy

# Docker
docker pull thirdpartypeople/resite
docker run -d -v /data-michiel:/data -p 80:80 -p 443:443 thirdpartypeople/resite
