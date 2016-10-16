# aristaZTP
My version of Arista ZTP using CSV file

# Assumptions: I installed on ubuntu 16.04 and run the setup script

The CSV file needs to be created and available in the tftpboot directory

The template.txt file need to be in the tftpboot directory

When the ZTP switch boot it looks for the file to download from the dhcp settings.

In this case boot.py is downloaded to the switch and executed.

The CSV and Template are copied over and the CSV file is read 

A process loop looks through the CSV file to find a MAC address match for the swicth.

The Template function is used to replace the variables in the template.txt file and 
it is saved as the startup-config.

The switch reboots.

You are now ready to manage the switch with my Ansible repo here:

https://github.com/xod442/eos-ansible-quick-start.git

Or add the switches into the Cloud Vision Portal Server LQQK Here!:

http://techworldwookie.com/?p=205

You can maintain the CSV file with switchdb located here:

https://github.com/xod442/scriptsonly/tree/master/switchdb



