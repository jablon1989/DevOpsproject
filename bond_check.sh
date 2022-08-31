#!/bin/bash

function print_color () {
  NC='\033[0m'   # no color

  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2${NC}"
}

function bond_check () {
	bond_status=$(ip link show dev bond0 | grep -E -o "state.{1,4}")
	bond_bandwidth=$(ethtool bond0 | grep -E -o "Speed:.{1,10}" | sed 's/Speed:/speed/')
	if [[ "$bond_status" = "state UP" ]]
	then
		print_color "green""1 -  bond0 status is "$bond_status"and runs at $bond_bandwidth."
	else [[ "$bond_status" != 'state UP' ]] || [[ "$bond_bandwidth" != "speed 40000Mb/s" ]]
		print_color "red" "1 - bond0 status is "$bond_status"and runs at $bond_bandwidth."
    fi
}

bond_check