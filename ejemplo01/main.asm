#include p16f84a.inc	; Carga la cabecera del microcontrolador
	radix	dec			; Por defecto los numeros estaran
 						; expresados en decimal 

	ORG	0x00
	GOTO INICIO	; Ir al inicio del programa
	ORG	0x04	; Zona de interrupciones
	GOTO INICIO	; Ir al inicio del programa
	
;*****INICIO DEL PROGRAMA*****
INICIO
	CLRF STATUS		; Borra el contenido de STATUS
	BSF	STATUS,5	; Seleccionamos el Banco 1
	MOVLW b'00000000' ; Cargamos un valor literal en W
	MOVWF TRISB		; Movemos el valor de W a TRISB,
					; configurando el puerto como salida
	BCF STATUS,5	; Seleccionamos el Banco 0
	MOVLW b'10100101' ; Cargamos un valor literal en W
	MOVWF PORTB		; Movemos el valor de W a PORTB
	END				; Fin del programa