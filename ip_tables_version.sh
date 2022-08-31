iptables_rules_80=$(iptables -nL | grep ACCEPT | grep -o 80)
iptables_rules_443=$(iptables -nL | grep ACCEPT | grep -o 443)

function iptables_check () {
        if [[ $iptables_rules_80 = 80 ]] && [[ $iptables_rules_443 = 443 ]]
        then
                echo "both port 80, 443 are fully opened."
        elif [[ $iptables_rules_80 != 80 ]]
        then
                echo "port 80 is not fully opened."
        elif [[ $iptables_rules_443 != 443 ]]
        then
                echo "port 443 is not fully opened."
        fi
}