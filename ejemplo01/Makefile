# MPLAB IDE generated this makefile for use with GNU make.
# Project: ejemplo01.mcp
# Date: Fri Aug 08 13:16:55 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

main.cof : main.o
	$(CC) /p16F84A "main.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"main.cof" /M"main.map" /W /x

main.o : main.asm C:/Archivos\ de\ programa/Microchip/MPASM\ Suite/p16f84a.inc
	$(AS) /q /p16F84A "main.asm" /l"main.lst" /e"main.err" /d__DEBUG=1

clean : 
	$(CC) "main.o" "main.hex" "main.err" "main.lst" "main.cof"

