app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>> $1 <<<<<<<<<\e[0m"
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
  func_print_head "copy mongodb repo"
  cp $(script_path)/mongo.repo /etc/yum.repos.d/mongo.repo

   func_print_head "install mongodb client"
  yum install mongodb-org-shell -y

   func_print_head "load schema"
  mongo --host mongosh-dev.devopsb62.online </app/schema/${component}.js
 fi
}

func_nodejs() {
  func_print_head "configuring nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "install nodejs"
  yum install nodejs -y

  func_print_head "add application user"
  useradd $(app_user)

  func_print_head "create application directory"
  rm -rf /app
  mkdir /app

  func_print_head "download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/{component}.zip
  cd /app

  func_print_head "unzip"
  unzip /tmp/${component}.zip

  func_print_head "install nodejs dependencies"
  npm install

  func_print_head "copy user systemd file"
  cp $(script_path)/${component}.service /etc/systemd/system/{component}.service

  func_print_head "start cart service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  func_schema_setup
 }

 func_java() {
   echo -e "\e[36m>>>>>>>> install maven <<<<<<<<<\e[0m"
    yum install maven -y

    echo -e "\e[36m>>>>>>>> create app user <<<<<<<<<\e[0m"
    useradd roboshop

    echo -e "\e[36m>>>>>>>> create app directory<<<<<<<<<\e[0m"
    rm -rf /app
    mkdir /app

    echo -e "\e[36m>>>>>>>> download app content <<<<<<<<<\e[0m"
    curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

    script_path=$(dirname "$script")
    source ${script_path}/common.sh

    echo -e "\e[36m>>>>>>>> extract app content <<<<<<<<<\e[0m"
    cd /app
    unzip /tmp/shipping.zip


    echo -e "\e[36m>>>>>>>> download maven dependencies <<<<<<<<<\e[0m"
    mvn clean package
    mv target/shipping-1.0.jar shipping.jar

     echo -e "\e[36m>>>>>>>> install mysql <<<<<<<<<\e[0m"
    yum install mysql -y

    echo -e "\e[36m>>>>>>>> load schema <<<<<<<<<\e[0m"
    mysql -h mysqlsh-dev.devopsb62.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

    echo -e "\e[36m>>>>>>>> setup systemdservice <<<<<<<<<\e[0m"
    cp $(script_path)/shipping.service /etc/systemd/system/shipping.service

    echo -e "\e[36m>>>>>>>> start shipping service <<<<<<<<<\e[0m"
    systemctl daemon-reload
    systemctl enable shipping
    systemctl restart shipping
 }