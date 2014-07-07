# Rackspace backup agent
sh -c 'wget -q "http://agentrepo.drivesrvr.com/debian/agentrepo.key" -O- | apt-key add -'
sh -c 'echo "deb [arch=amd64] http://agentrepo.drivesrvr.com/debian/ serveragent main" > /etc/apt/sources.list.d/driveclient.list'

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
ufw allow 7678
ufw enable
mv 10periodic /etc/apt/apt.conf.d/
mv 50unattended-upgrades /etc/apt/apt.conf.d/
mv 00logwatch /etc/cron.daily/
echo Now choose a sudo password for the 'deploy' user
passwd deploy

# Set up backup agent
echo Now enter your Rackspace username and API key (see RackSpace UI top right, 'Account Settings' menu)
/usr/local/bin/driveclient --configure
service driveclient start
update-rc.d driveclient defaults

# Docker
docker pull michielbdejong/resite
docker run -d -v /data-michiel:/data -p 80:80 -p 443:443 -p 7678:7678 thirdpartypeople/resite

echo Now restore a data backup to the new Jessie server, check that it's up, and repoint DNS. Thanks!
