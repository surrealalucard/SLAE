#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[1;33m'

if [ ! -f "$1.nasm" ]; then
        echo -e $0":" "${RED}$1.nasm not found.\n ${YELLOW}Hint: Do not include .nasm in command line${NC}"
        exit 1
fi

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -m elf_i386 -s  -o $1 $1.o

echo '[+] Done!'



