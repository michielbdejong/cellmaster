echo Setting up new cell in the Third Party People network.
echo Looking for a virgin Debian Jessy server at IP address $1.
echo Please enter the root password for the new server:
scp -r ./installer/.ssh root@$1:/root/
scp -r ./installer/* root@$1:/root/
ssh root@$1 sh ./install.sh
