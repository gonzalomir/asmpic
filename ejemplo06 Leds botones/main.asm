#include <p16f84a.inc>	; Carga la cabecera del microcontrolador
radix	dec				; Por defecto los numeros estaran
 						; expresados en decimal 
	W 	EQU 0
	F 	EQU 1

;***ZONA DE INICIO DEL MICROCONTROLADOR***
	ORG	0x00
	GOTO INICIO	; Ir al inicio del programa
	ORG	0x04	; Zona de interrupciones
	GOTO INICIO	; Ir al inicio del programa

;***** ZONA DE SUBRUTINAS Y TABLAS *****
TABLA	ADDWF PCL,F			; Ponsemos en PCL la de suma del PCL, y el W sera el inicio
		RETLW b'00111111'	; Devolvemos el 0
		RETLW b'00000110'	; Devolvemos el 1
		RETLW b'01011011'	; Devolvemos el 2
		RETLW b'01001111'	; Devolvemos el 3
		RETLW b'01100110'	; Devolvemos el 4
		RETLW b'01101101'	; Devolvemos el 5
		RETLW b'01111100'	; Devolvemos el 6
		RETLW b'00000111'	; Devolvemos el 7
		RETLW b'01111111'	; Devolvemos el 8
		RETLW b'01100111'	; Devolvemos el 9

;*****INICIO DEL PROGRAMA*****
INICIO	CLRF STATUS			; Borra el contenido de STATUS
		BSF	STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW b'11111111'	; Cargamos un valor literal en W
		MOVWF TRISA			; Movemos el valor de W a TRISA, PORTA como entrada
		MOVLW b'00000000'	; Cargamos un valor literal en W
		MOVWF TRISB			; Movemos el valor de W a TRISA, PORTB como salida
		BCF STATUS,RP0		; Seleccionamos el Banco 0
LEER	MOVF PORTA,W		; Movemos el valor de PORTA a W (PORTA->W)
		ANDLW b'00000111'	; Operacion AND de W con el binario 00000111
		CALL TABLA			; Extrae un valor de la tabla y lo devuelve en W
		MOVWF PORTB			; Saca el valor de W a traves de PORTB (W->PORTB)
		GOTO LEER			; Salto incondicional a LEER
		END					; Fin del programa
