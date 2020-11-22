#!/bin/bash

# Don't leave secrets 'lying around' if the user aborts the (sourced) script
trap "unset proxyuser; unset proxypass; unset http_proxy; unset https_proxy; return" SIGINT

if [ "${BASH_SOURCE[0]}" -ef "$0" ];  then
    echo "Usage:"
    echo "  source ${BASH_SOURCE[0]}"
    echo
    echo "(i.e., source this script rather than executing it directly)"
    exit 1
fi

echo "This script will install a few required packages and create a Python virtual "
echo "environment suitable for running the Ansible playbook."
echo
echo "Please ENSURE YOUR SYSTEM DATE/TIME IS CORRECT before proceeding, otherwise "
echo "the 'apt update' command will fail to detect any valid packages."
echo

printf '%s ' 'Enter proxy username:'
read proxyuser

printf '%s ' 'Enter proxy password:'
read -s proxypass
echo

export http_proxy="http://${proxyuser}:${proxypass}@10.224.200.25:8080/"
export https_proxy="http://${proxyuser}:${proxypass}@10.224.200.25:8080/"
sudo -E apt update
sudo -E apt upgrade -y
sudo -E apt install -y build-essential git libapt-pkg-dev python3-dev python3-venv
mkdir -p ~/projects && cd ~/projects
git clone https://evadeflow@github.com/evadeflow/ubuntu-vm-setup.git
cd ubuntu-vm-setup
python3 -m venv ./venv
source ./venv/bin/activate
pip install -U pip setuptools wheel
pip install -r requirements.txt
echo "Setup complete! You may now run:"
echo
echo "$ ansible-playbook --ask-become-pass --ask-vault-pass playbook.yml"
