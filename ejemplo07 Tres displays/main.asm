#include <p16f84a.inc>	; Carga la cabecera del microcontrolador
radix	dec				; Por defecto los numeros estaran
 						; expresados en decimal 
;*** ZONA DE ETIQUETAS ***
	W 	EQU 0
	F 	EQU 1
DISP_U	EQU 0
DISP_D	EQU 1
DISP_C	EQU 2

;*** ZONA DE ETIQUETAS DE LOS REGISTROS RAM ***
CTDOR1	EQU 0x0C
CTDOR2	EQU 0x0D
NUM_U	EQU 0x0E
NUM_D	EQU 0x0F
NUM_C	EQU 0x10

;*** ZONA DE INICIO DEL MICROCONTROLADOR ***
	ORG	0x00
	GOTO INICIO	; Ir al inicio del programa
	ORG	0x04	; Zona de interrupciones
	GOTO INICIO	; Ir al inicio del programa

;***** ZONA DE SUBRUTINAS Y TABLAS *****
;***RUTINA DE SACAR EL NUMERO COMPLETO = SACAR_N
SACAR_N	MOVF NUM_U,W		; Carga en W el valor del registro NUM_U
		CALL TABLA			; Conversion de un numero en los niveles de salida necesarios
		BCF PORTA,DISP_U	; Habilitamos el display de unidades
		MOVWF PORTB			; Sacar el valor por el PORTB
		CALL TEMPO			; Llamada a la rutina de retardo
		MOVF NUM_D,W		; Carga en W el valor del registro NUM_D
		CALL TABLA			; Conversion de un numero en los niveles de salida necesarios
		BSF PORTA,DISP_U	; Deshabilitamos el display de unidades

		BCF PORTA,DISP_D	; Habilitamos el display de decenas
		MOVWF PORTB			; Sacar el valor por el PORTB
		CALL TEMPO			; Llamada a la rutina de retardo
		MOVF NUM_C,W		; Carga en W el valor del registro NUM_C
		CALL TABLA			; Conversion de un numero en los niveles de salida necesarios
		BSF PORTA,DISP_D	; Deshabilitamos el display de decenas

		BCF PORTA,DISP_C	; Habilitamos el display de centenas
		MOVWF PORTB			; Sacar el valor por el PORTB
		CALL TEMPO			; Llamada a la rutina de retardo
		BSF PORTA,DISP_C	; Deshabilitamos el display de centenas
		RETLW 0

;***RUTINA DE SUMAR LOS TRES REGISTROS = SUMAR		
SUMAR	INCF NUM_U,F		; Incrementamos el registro de unidades
		MOVLW 10			; Cargamos el literal 10 en W (10->W)
		SUBWF NUM_U,W		; Restamos el valor del W y del registro NUM_U
		BTFSC STATUS,Z		; Comprobamos si NUM_U = 10
		GOTO SI_IG_U		; Si se ha llegado a 10 tendremos que seguir operando
		RETLW 0				; Si no se ha llegado a 10, salimos de la subrutina de sumar
SI_IG_U CLRF NUM_U			; Ponemos a cero las unidades
		INCF NUM_D,F		; Incrementamos el registro de decenas
		MOVLW 10			; Cargamos el literal 10 en W (10->W)
		SUBWF NUM_D,W		; Restamos el valor del W y del registro NUM_U
		BTFSC STATUS,Z		; Comprobamos si NUM_U = 10
		GOTO SI_IG_D		; Si se ha llegado a 10 tendremos que seguir operando
		RETLW 0				; Si no se ha llegado a 10, salimos de la subrutina de sumar
SI_IG_D CLRF NUM_D			; Ponemos a cero las unidades
		INCF NUM_C,F		; Incrementamos el registro de centenas
		MOVLW 10			; Cargamos el literal 10 en W (10->W)
		SUBWF NUM_C,W		; Restamos el valor del W y del registro NUM_U
		BTFSC STATUS,Z		; Comprobamos si NUM_U = 10
		GOTO SI_IG_C		; Si se ha llegado a 10 tendremos que seguir operando
		RETLW 0				; Si no se ha llegado a 10, salimos de la subrutina de sumar
SI_IG_C CLRF NUM_U			; Cuando se alcanza el numero 999 se pone a 0 los tres registros
		CLRF NUM_D
		CLRF NUM_C
		RETLW 0

;***RUTINA DE RETARDO = TEMPO
TEMPO	MOVLW D'200'
		MOVWF CTDOR1
BUCLE	DECFSZ CTDOR1,F
		GOTO BUCLE
		RETLW 0
	
;*** TABLA DISPLAY 7 SEGMENTOS, ANODO COMUN ***
TABLA	ADDWF PCL,F			; Ponsemos en PCL la de suma del PCL, y el W sera el inicio
		RETLW b'11000000'	; Devolvemos el 0
		RETLW b'11111001'	; Devolvemos el 1
		RETLW b'10100100'	; Devolvemos el 2
		RETLW b'10110000'	; Devolvemos el 3
		RETLW b'10011001'	; Devolvemos el 4
		RETLW b'10010010'	; Devolvemos el 5
		RETLW b'10000010'	; Devolvemos el 6
		RETLW b'11111000'	; Devolvemos el 7
		RETLW b'10000000'	; Devolvemos el 8
		RETLW b'10010000'	; Devolvemos el 9

;*****INICIO DEL PROGRAMA*****
INICIO	CLRF STATUS			; Borra el contenido de STATUS
		BSF	STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW b'11111000'	; Cargamos un valor literal en W
		MOVWF TRISA			; Movemos el valor de W a TRISA, PORTA tiene 3 lineas de salida

		MOVLW b'00000000'	; Cargamos un valor literal en W
		MOVWF TRISB			; Movemos el valor de W a TRISA, PORTB como salida en su totalidad

		BCF STATUS,RP0		; Seleccionamos el Banco 0

		MOVLW b'00000111'	; Cargamos un valor en W
		MOVWF PORTA			; Apagamos los displays
		
		MOVLW 7				; Cargamos el literal 7 en W (7->W)
		MOVWF NUM_U			; Cargamos el valor de W en NUM_U (W->NUM_U)
		MOVLW 2				; Cargamos el literal 2 en W (2->W)
		MOVWF NUM_D			; Cargamos el valor de W en NUM_U (W->NUM_D)
		MOVLW 3				; Cargamos el literal 3 en W (3->W)
		MOVWF NUM_C			; Cargamos el valor de W en NUM_U (W->NUM_C)

BUCLE1 	MOVLW 75			; Numero de veces que sacamos un mismo numero (75->CTDOR2)
		MOVWF CTDOR2		; Cargamos en CTDOR2 el valor de W. (W->CTDOR2)
BUCLE2	CALL SACAR_N		; Llamado a la subrutina SACAR_N
		DECFSZ CTDOR2,F		; Repetir el mismo número hasta que CTDOR2 == 0
		GOTO BUCLE2			; Salto incondicional a BUCLE2
		CALL SUMAR			; Llamado a la subrutina SUMAR
		GOTO BUCLE1			; Salto incondicional a BUCLE1
		END					; Fin del programa