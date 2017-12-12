#!/bin/bash

# Remove existing config file
rm /etc/cntlm.conf

if [[ -z "${useraccount}" ]]; then
    echo "Environment Variable 'useraccount' missing!"
elif [[ -z "${userdomain}" ]]; then 
    echo "Environment Variable 'userdomain' missing!"
elif [[ -z "${userpassword}" ]]; then 
    echo "Environment Variable 'userpassword' missing!"
elif [[ -z "${proxyaddress}" ]]; then 
    echo "Environment Variable 'proxyaddress' missing!"
else
    # Setup CNTML configuration file
    echo Username $useraccount > /etc/cntlm.conf  # username
    echo Domain $userdomain >> /etc/cntlm.conf # domain.com
    echo Proxy $proxyaddress >> /etc/cntlm.conf # 192.168.0.10:8080
    echo Listen $listenport >> /etc/cntlm.conf # 127.0.0.1:3128

    # Get hashed password values
    filename="/tmp/passdumpo.txt"
    echo $userpassword | cntlm -H > $filename
    while read -r line
    do
        name="$line"
        if [ "$name" != "Password:" ]; then
            echo $name >> /etc/cntlm.conf
        fi
    done < "$filename"

    #start CNTLM service in foreground to keep container running
    exec cntlm -f
fi



