#include p16f84a.inc	; Carga la cabecera del microcontrolador
	radix	dec			; Por defecto los numeros estaran
 						; expresados en decimal 
RP0	EQU	5				; Asignando el alias RP0 el valor de 5

	ORG	0x00
	GOTO INICIO	; Ir al inicio del programa
	ORG	0x04	; Zona de interrupciones
	GOTO INICIO	; Ir al inicio del programa
	
;*****INICIO DEL PROGRAMA*****
INICIO	CLRF STATUS			; Borra el contenido de STATUS
		BSF	STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW 0xFF			; Cargamos un valor literal en W
		MOVWF TRISA			; Movemos el valor de W a TRISA,
							; configurando el puerto entero como entrada
		MOVLW 0x00			; Cargamos un valor literal en W
		MOVWF TRISB			; Movemos el valor de W a TRISA,
							; configurando el puerto entero como entrada
		BCF STATUS,RP0		; Seleccionamos el Banco 0

LEER_0	BTFSC PORTA,0		; Leemos y analizamos el bit 0 del PORTA
		GOTO LEER_1			; Si no es cero salto incondicional
		MOVLW B'00000110' 	; Cargamos un literal al W. 7Seg(1)->W
		MOVFW PORTB			; Movemos el W al PORTB
		GOTO LEER_0			; Salto incondicional a LEER_0

LEER_1	BTFSC PORTA,1		; Leemos y analizamos el bit 0 del PORTA
		GOTO LEER_2			; Si no es cero salto incondicional
		MOVLW b'01011011' 	; Cargamos un literal al W. 7Seg(2)->W
		MOVFW PORTB			; Movemos el W al PORTB
		GOTO LEER_0			; Salto incondicional a LEER_0

LEER_2	BTFSC PORTA,2		; Leemos y analizamos el bit 0 del PORTA
		GOTO LEER_3			; Si no es cero salto incondicional
		MOVLW b'01001111' 	; Cargamos un literal al W. 7Seg(3)->W
		MOVFW PORTB			; Movemos el W al PORTB
		GOTO LEER_0			; Salto incondicional a LEER_0

LEER_3	BTFSC PORTA,3		; Leemos y analizamos el bit 0 del PORTA
		GOTO LEER_4			; Si no es cero salto incondicional
		MOVLW b'01100110' 	; Cargamos un literal al W. 7Seg(4)->W
		MOVFW PORTB			; Movemos el W al PORTB
		GOTO LEER_0			; Salto incondicional a LEER_0

LEER_4	BTFSC PORTA,4		; Leemos y analizamos el bit 0 del PORTA
		GOTO NO_CERO		; Si no es cero salto incondicional
		MOVLW b'01101101' 	; Cargamos un literal al W. 7Seg(4)->W
		MOVFW PORTB			; Movemos el W al PORTB
		GOTO LEER_0			; Salto incondicional a LEER_0

NO_CERO MOVLW b'00111111'	; Cargamos un literal al W. 7Seg(0)->0
		MOVWF PORTB			; Movemos el W al PORTB
		GOTO LEER_0			; Salto incondicional a LEER_0
		END					; Fin del programa