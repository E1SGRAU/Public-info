#!/bin/bash

apt update 
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update
apt install jenkins -y
apt update
apt install fontconfig openjdk-17-jre -y
systemctl enable jenkins
systemctl start jenkins

apt install expect -y
echo "y" | ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -C "S.Alexander130896@gmail.com" -P ""
expect -c "
spawn $ssh-keygen_command
expect \"Enter passphrase (empty for no passphrase):\"
send \"\r\"
expect \"Enter same passphrase again:\"
send \"\r\"
expect eof
"

mkdir -p /var/lib/jenkins/.ssh/
cp /root/.ssh/id_ed25519 /var/lib/jenkins/.ssh/
cp /root/.ssh/id_ed25519.pub /var/lib/jenkins/.ssh/
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/
chmod 700 /var/lib/jenkins/.ssh/
chmod 600 /var/lib/jenkins/.ssh/id_ed25519
chmod 644 /var/lib/jenkins/.ssh/id_ed25519.pub

snap install docker
apt install docker.io -y
sudo -u jenkins ssh-keyscan -t ed25519 github.com >> /var/lib/jenkins/.ssh/known_hosts
systemctl restart jenkins
usermod -aG docker jenkins
service jenkins restart

echo "KEY FROM JENKINS: "
cat /var/lib/jenkins/secrets/initialAdminPassword
echo "SSH_KEY.pub: "
cat /root/.ssh/id_ed25519.pub
echo "SSH_KEY.priv: "
cat /root/.ssh/id_ed25519
echo "FINISH"
