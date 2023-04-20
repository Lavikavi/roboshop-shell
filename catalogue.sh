echo -e "\e[36m>>>>>> Configuring NodeJS repos <<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>> Install NodeJS <<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>> Create Application Directory <<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>Add Application user repos<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>> Download App Content <<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>> Unzip App Content  <<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>> Install NodeJs Dependencies  <<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>> Copy catalogue SystemD file  <<<<<<\e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>> Start Catalogue Service  <<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[36m>>>>>> Copy MongoDB Repos  <<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>> Install Mongodb Client  <<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>> Load schema <<<<<<\e[0m"
mongo --host mongosh-dev.devopsb62.online </app/schema/catalogue.js