#include p16f84a.inc	; Carga la cabecera del microcontrolador
	radix	dec			; Por defecto los numeros estaran
 						; expresados en decimal 
RP0	EQU	5				; Asignando el alias RP0 el valor de 5

	ORG	0x00
	GOTO INICIO	; Ir al inicio del programa
	ORG	0x04	; Zona de interrupciones
	GOTO INICIO	; Ir al inicio del programa
	
;*****INICIO DEL PROGRAMA*****
INICIO	CLRF STATUS		; Borra el contenido de STATUS
		BSF	STATUS,RP0	; Seleccionamos el Banco 1
		MOVLW 0xFF		; Cargamos un valor literal en W
		MOVWF TRISA		; Movemos el valor de W a TRISA,
						; configurando el puerto entero como entrada
		MOVLW 0x00		; Cargamos un valor literal en W
		MOVWF TRISB		; Movemos el valor de W a TRISA,
						; configurando el puerto entero como entrada
		BCF STATUS,RP0	; Seleccionamos el Banco 0
LEER	MOVF PORTA,0	; Movemos el contenido del PORTA al W
		MOVWF PORTB		; Movemos el valor de W a PORTB
		GOTO LEER		; Salto incondicional a la etiqueta LEER
		END				; Fin del programa