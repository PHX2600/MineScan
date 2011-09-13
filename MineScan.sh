#! /bin/bash

################################################
## MineFinder.sh                              ##
## Scans address ranges for Minecraft servers.##
## Concept and code by Logic & PHX2600 crew   ##
################################################

#Prepare the environment

if [ ! -e current.txt ]; then
    touch current.txt
else
	echo "" > current.txt
fi

if [ ! -e previous.txt ]; then
    touch previous.txt
fi

if [ ! -e results.txt ]; then
    touch results.txt
fi

# Run Nmap, look for minecraft servers (-p 25565), exclude previously scanned hosts (--excludefile)
# Assume all hosts are up (-PN), make output grepable (-oG) and output to current.txt,
# Use cmdline input for ip range ($1)

nmap -p 25565 -PN --excludefile previous.txt -oG current.txt $1 > /dev/null 2>&1

#Sanitize our output from Nmap
cat current.txt | grep Up | awk '{print $2}' > current_sane.txt

#add new IP's to our running scanned IP List
cat previous.txt current_sane.txt > /tmp/temp.txt
cp /tmp/temp.txt previous.txt

#Look for servers with MC port open
grep open current.txt > /tmp/temp.txt

#Sanitize our output from grep
cat /tmp/temp.txt | awk '{print $2}' > /tmp/open.txt

#Add new machines to our running list of open boxes
cat results.txt /tmp/open.txt > /tmp/temp.txt
cp /tmp/temp.txt results.txt

#Clean up and sort our bounty!
cat results.txt | sort | uniq > /tmp/temp.txt
cp /tmp/temp.txt results.txt

cat previous.txt | sort | uniq > /tmp/temp.txt
cp /tmp/temp.txt previous.txt

#Let us know what we have
echo -n "New servers found: "
grep open current.txt | wc -l
echo  "###############"
grep open current.txt | awk '{print $2}'
echo  "###############"
echo -n "Total Servers: "
cat results.txt | wc -l



