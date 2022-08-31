# OS CHECK
function os_check () {
    release_check=$(cat /etc/*release*)

    if [ $release_check = 'Ubuntu' ]
    then
        print_color "green" "Ubuntu is installed."
        package_check_ubuntu
    else
        print_color "green" "RHEL is installed."
        package_check_rhel
    fi
}\

function package_check_rhel () {
    package_exist_rhel=$(sudo rpm -qa | grep $1)

    if [ $package_exist_rhel = 'ansible' ]
    then
        print_color "green" "$1 is installed."
    else
        print_color "red" "$1 is not installed."
        package_install_rhel
    fi
}

function package_install_rhel () {
    sudo yum install $1 -y
}