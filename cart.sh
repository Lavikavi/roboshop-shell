script=$(realpath "$0")
realpath $0
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=cart
func_systemd_setup
func_nodejs
