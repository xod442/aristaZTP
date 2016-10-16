# Arista ZTP CSV server configuration script. 
#
#      When finished..... 'sudo chmod 777 /var/lib/dhcp/dhcpd.leases'
#      To check dhcp run 'sudo dhcp -f' look for errors
#--------------------------------------------------------------------------------
#
#       Update & Upgrade, Uncomment if necessary
#
#--------------------------------------------------------------------------------
#chmod 777 ./setup.sh
#apt-get update
#apt-get -y upgrade
#apt-get -y install git
#apt-get -y install python-pip
#apt -y autoremove
#--------------------------------------------------------------------------------
#
#       Install dhcp server and configure conf file
#
#--------------------------------------------------------------------------------
#apt-get -y install isc-dhcp-server
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd_bak.conf
echo 'default-lease-time 3600;' > /etc/dhcp/dhcpd.conf
echo 'authoritative;' >> /etc/dhcp/dhcpd.conf
echo 'max-lease-time 3600;' >> /etc/dhcp/dhcpd.conf
echo 'ddns-update-style none;' >> /etc/dhcp/dhcpd.conf
echo 'subnet 172.20.0.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
echo '    range 172.20.0.10 172.20.0.250;' >> /etc/dhcp/dhcpd.conf
echo '    option tftp-server-name "172.20.0.1";' >> /etc/dhcp/dhcpd.conf
echo '    option bootfile-name "boot.py";' >> /etc/dhcp/dhcpd.conf
echo '}' >> /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
#--------------------------------------------------------------------------------
#
#       Configure local interface. Skip this step if it is already configured
#
#--------------------------------------------------------------------------------
#echo 'source-directory /etc/network/interfaces.d' > /etc/network/interfaces
#echo 'auto lo' >> /etc/network/interfaces
#echo 'iface lo inet loopback' >> /etc/network/interfaces
#echo 'auto ens33' >> /etc/network/interfaces
#echo 'iface ens33 inet static' >> /etc/network/interfaces
#echo '    address 172.20.0.3' >> /etc/network/interfaces
#echo '    netmask 255.255.255.0' >> /etc/network/interfaces
#Edit these for your environment
#ifdown ens33 && ifup ens33
#ifconfig | grep addr
#pip install pyyaml
#echo $PATH
#--------------------------------------------------------------------------------
#
#       Install tftp server and set home directory
#
#--------------------------------------------------------------------------------

#apt-get -y install xinetd tftpd tftp
echo 'service tftp' > /etc/xinetd.d/tftp
echo '{' >> /etc/xinetd.d/tftp
echo 'protocol = udp' >> /etc/xinetd.d/tftp
echo 'port = 69' >> /etc/xinetd.d/tftp
echo 'socket_type = dgram' >> /etc/xinetd.d/tftp
echo 'wait = yes' >> /etc/xinetd.d/tftp
echo 'server = /usr/sbin/in.tftpd' >> /etc/xinetd.d/tftp
echo 'server_args = /home/rick/projects/aristaZTP/tftpboot' >> /etc/xinetd.d/tftp
echo 'disable = no' >> /etc/xinetd.d/tftp
echo 'user = nobody' >> /etc/xinetd.d/tftp
echo '}' >> /etc/xinetd.d/tftp
Edit these to match your tftpboot directory
chmod -R 777 /home/rick/projects/aristaZTP/tftpboot
chown -R nobody /home/rick/projects/aristaZTP/tftpboot
service xinetd restart
#--------------------------------------------------------------------------------
#
#       Install ftp server 
#
#--------------------------------------------------------------------------------
#apt-get -y install vsftpd
cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
sed -i 's/#local_umask/local_umask/' /etc/vsftpd.conf
sed -i 's/#chroot_local_user/chroot_local_user/' /etc/vsftpd.conf
echo 'allow_writeable_chroot=YES' >> /etc/vsftpd.conf
echo 'pasv_enable=YES' >> /etc/vsftpd.conf
echo 'pasv_min_port=40000' >> /etc/vsftpd.conf
echo 'pasv_max_port=40100' >> /etc/vsftpd.conf
service vsftpd restart

netstat -plnut4


