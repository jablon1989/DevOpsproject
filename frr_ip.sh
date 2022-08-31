#!/bin/bash

#FRR IP announced:

frr_ip_bgp_neighbor=$(vtysh -c 'show ip bgp neighbors' | grep 'BGP neighbor is ' | awk '{print $4}' | sed 's/,//')
frr_ip_bgp_announced=$(vtysh -c 'show ip bgp neighbors '$frr_ip_bgp_neighbor' advertised-routes' | grep /32 | sed 's/*> //')

#FRR IP check:

function bgp_check () {

    if [ "$frr_ip_bgp_announced" != "" ]
    then
        echo "FRR is OK and ${frr_ip_bgp_neighbor} IP is announced."
    else
        echo "No IP announced."
    fi
}

echo $frr_ip_bgp_neighbor
echo $frr_ip_bgp_announced
bgp_check