#!/bin/bash

#####  FUNCTIONS  #####

### COLOR
function print_color () {
  NC='\033[0m'   # no color

  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2${NC}"
}

### PACKAGE CHECKS

# UBUNTU
function package_check_ubuntu () {
    package_exist_ubuntu=$(sudo apt list $1)

    if [[ $package_exist_ubuntu = "*installed*" ]]
    then
        print_color "green" "$1 is installed."
    else
        print_color "red" "$1 is not installed."
        package_install_ubuntu $1
    fi
}

# CENTOS
function package_check_centos () {
    package_exist_centos=$(sudo yum  $1)

    if [ $package_exist_centos = "[installed]" ]
    then
        print_color "green" "$1 is installed."
    else
        print_color "red" "$1 is not installed."
        package_install_ubuntu $1
    fi
}

# PACKAGE INSTALL
function package_install_ubuntu () {
    sudo apt install $1 -y
}

# SERVICE CHECK
function service_check () {
  service_is_active=$(sudo systemctl is-active $1)

  if [ $service_is_active = "active" ]
  then
    print_color "green" "$1 is active and running"
  else~
    print_color "red" "$1 is not active/running"
    service_configure $1
  fi
}

function service_configure () {
    sudo systemctl start $1
    sudo systemctl enable $1
}

#####  Install Packages & Configure Services  #####

# Nginx
print_color "green" "Installing Nginx..."
package_check_ubuntu nginx

print_color "green" "Configuring Nginx service..."
service_configure nginx
 
# Ansible
print_color "green" "Installing Ansible..."
package_check_ubuntu ansible

print_color "green" "Configuring Ansible service..."
service_configure ansible