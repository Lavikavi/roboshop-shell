script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Roboshop Appuser Password Missing
  exit
fi

(rabbitmq_appuser_password)=$1
echo -e "\e[36m>>>>>>>> setup Erlang repos <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>> setup RabbitMq repos <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>> install Erlang & Rabbitmq <<<<<<<<<\e[0m"
yum install erlang rabbitmq-server -y


echo -e "\e[36m>>>>>>>> start Rabbitmq service <<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>> add application userin Rabbitmq <<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop $(rabbitmq_appuser_password)
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"