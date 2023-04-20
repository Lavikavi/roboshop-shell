

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
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"