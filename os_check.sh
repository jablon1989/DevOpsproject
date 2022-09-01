#!/bin/bash

set -eu -o pipefail

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

packages=sadsad

### OS CHECK
function os_check () {
    release_check=$(cat /etc/*release* | grep DISTRIB_ID | sed 's/DISTRIB_ID=//g')

    if [[ $release_check = 'Ubuntu' ]]
    then
        print_color "green" "Ubuntu is installed."
        ubuntu_actions
    else
        print_color "green" "RHEL is installed."
        rhel_actions
    fi
}

### UBUNTU
function ubuntu_actions () {
    # CHECK PACKAGE
    function package_check_ubuntu () {
        package_exist_ubuntu=$(dpkg-query -W --showformat='${status}\n' $packages 2>/dev/null | grep -c "ok installed")

        if [[ $package_exist_ubuntu -eq 0 ]]
        then
            print_color "red" "$packages is not installed."
            package_install_ubuntu
        else
            print_color "green" "$packages is installed."
        fi
    }   

    # INSTALL PACKAGE
    function package_install_ubuntu () {
        print_color "green" "Installing $packages package..."
        sudo apt install -y $packages
        print_color "green" "Package $packages installed."
        service_check
    }
package_check_ubuntu
}

### RHEL
function rhel_actions () {
    # CHECK PACKAGE
    function package_check_rhel () {
        package_exist_rhel=$(sudo rpm -q $packages)

        if [[ $package_exist_rhel = '' ]]
        then
            print_color "green" "$packages is installed."
        else
            print_color "red" "$packages is not installed."
            package_install_rhel
        fi
    }

    # INSTALL PACKAGE
    function package_install_rhel () {
        print_color "green" "Installing $packages package..."
        sudo yum install -y $packages
        print_color "green" "Package $packages installed."
        service_check
    }
}
### SERVICE CHECK FOR BOTH OS
function service_check () {
    print_color "green" "Configuring $packages service..."
    sudo systemctl status $packages ; sudo systemctl start $packages ; sudo systemctl enable $packages
    
    check_if_service_is_active=$(systemctl is-active $packages)
    if [[ $check_if_service_is_active = 'active' ]]
    then
        sudo systemctl status $packages
        print_color "green" "$packages service is started and enabled."
    else
        print_color "red" "$packages service is down. Please troubleshoot."
    fi
}

os_check