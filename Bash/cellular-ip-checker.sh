#!/bin/bash
# Tmobile
    #"162.160"
    #"162.184"
    #"162.186"
    #"162.187"
    #"162.190"
    #"162.191"
# Verizon	
	#"66.174"
	#"69.82"
	#"70.192"
	#"72.96"
	#"72.107"
	#"75.192"
	#"75.205"
	#"96.224"
	#"97.0"
	#"97.128"
	#"98.132"
	#"98.104"
	#"166.154"
	#"168.201"
	#"174.192"
	#"174.8"
	#"174.242"

# List of IP addresses to match
ip_list=(
    "162.160"
    "162.184"
    "162.186"
    "162.187"
    "162.190"
    "162.191"
    "66.174"
    "69.82"
    "70.192"
    "72.96"
	"72.107"
    "75.192"
	"75.205"
    "96.224"
    "97.0"
    "97.128"
    "98.132"
    "98.104"
	"166.154"
    "168.201"
    "174.192"
    "174.8"
	"174.242"
)

# Get the current IP using curl
current_ip=$(curl -s https://ipinfo.io/ip)

# Extract the first two octets of the current IP
current_ip_prefix=$(echo "$current_ip" | cut -d'.' -f1,2,)

# Check if the current IP matches the first two octets of any in the list
for ip in "${ip_list[@]}"; do
    if [[ "$current_ip_prefix" == "$ip" ]]; then
        echo "True"
        exit 0
    fi
done

echo "False"