script=$(realpath "$0")
realpath $0
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=cart
func_nodejs

func_systemd_setup() {
	  func_print_head "Setup SystemD Service"
	  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
	  func_stat_check $?


	  func_print_head "Start ${component} Service"
	  systemctl daemon-reload &>>$log_file
	  systemctl enable ${component} &>>$log_file
	  systemctl restart ${component} &>>$log_file
	  func_stat_check $?
	}

