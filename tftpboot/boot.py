#!/usr/bin/env python

'''
 Copyright 2016 Hewlett Packard Enterprise Development LP.
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
__author__ = "@netmanchris"
__copyright__ = "Copyright 2016, Hewlett Packard Enterprise Development LP."
__credits__ = ["Rick Kauffman"]
__license__ = "Apache2"
__version__ = "1.0.0"
__maintainer__ = "Rick Kauffman"
__email__ = "rick@rickkauffman.com"
__status__ = "Prototype"
'''

# Arista  by CSV  wookieware 2016

# uses the python "string" import to access the Template function

import os
import sys
import csv
from string import Template
import json
import subprocess

# Create application variables
#--------------------------------------------------

count = 0
ver ='FastCli -p 15 -c "show version | incl address"'

copytemplate ='FastCli -p 15 -c "copy tftp://172.20.1.1/template.txt flash:/template.txt"'
copycsv ='FastCli -p 15 -c "copy tftp://172.20.1.1/varMatrix.csv flash:/varMatrix.csv"'

#--------------------------------------------------

def copyfiles():

	os.system(copytemplate)

	os.system(copycsv)


def configureSwitch():

	switchMacAddressInfo = subprocess.Popen([ver],stdout=subprocess.PIPE, shell=True)
        (out, err) = switchMacAddressInfo.communicate()

        # Extract MAC address from output

	switchMacAddress = out[21:95]
	# Set counter to track items
	count = 0

	#open the template
        print 'Reading template file..........'
	form = open('/mnt/flash/template.txt', 'r')
	src = Template( form.read() )


	#open the csv file and build List
        print 'Reading CSV file............'
	csvfile = open('/mnt/flash/varMatrix.csv', 'r')
	content = csv.DictReader(csvfile)
	switch = []
	for row in content:
		switch.append(row)

	# how many switches do we have?
	check = len(switch)

	while (count < check):

		#Substitute CSV variables in the template file
		myMac = switch[count]['mac'].strip()
		switchMacAddress = switchMacAddress.strip()


		if str(switchMacAddress) == str(myMac):
			result = src.substitute(switch[count])
			config = open('/mnt/flash/startup-config','w')
			config.write(result)
		count = count + 1

	# Be nice and close the files

	csvfile.close()
	form.close()

def cleanup():
	# Clean this mess up else we all wind up in jail
	pass

copyfiles()
#
configureSwitch()
cleanup()
quit()
