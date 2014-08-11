#include <p16f84a.inc>	; Carga la cabecera del microcontrolador
radix	dec				; Por defecto los numeros estaran
 						; expresados en decimal 
W	EQU	0				; d=0, destino W
F	EQU 1				; d=1, destino F
;*** REGISTROS EN LA RAM DE PROPOSITO GENERAL ***
VAR1	EQU 0x0C		; VAR1 direccion en RAM 0x0C
VAR2	EQU 0x0D		; VAR2 direccion en RAM 0x0D
VAR3	EQU 0x0E		; VAR3 direccion en RAM 0x0E
	
		ORG	0x00		; Origen del codigo
		GOTO INICIO		; Ir al inicio del programa
		ORG	0x04		; Zona de interrupciones
		GOTO INICIO		; Ir al inicio del programa
	
;*****SUBRUTINA DE RETARDO*****
TEMPO	MOVLW 0x07		; Cargamos el valor 0x07 en W
		MOVWF VAR1		; Cargamos el valor de W en VAR1
		MOVLW 0x2F		; Cargamos el valor 0x2F en W
		MOVWF VAR2		; Cargamos el valor de W en VAR2
		MOVLW 0x03		; Cargamos el valor 0x03 en W
		MOVWF VAR3		; Cargamos el valor de W en VAR3
BUCLE	DECFSZ VAR1,F	; Decrementa VAR1 y salta si es 0.
		GOTO $+2		; Salto incondicional dos posiciones mas
		DECFSZ VAR2,F	; Decrementa VAR2 y salta si es 0.
		GOTO $+2		; Salto incondicional dos posiciones mas
		DECFSZ VAR3,F	; Decrementa VAR3 y salta si es 0.
		GOTO BUCLE		; Salto incondicional a BUCLE
		; Faltan 6 Ciclos
		GOTO $+1		; Salto incondicional una posicion mas
		GOTO $+1		; Salto incondicional una posicion mas
		GOTO $+1		; Salto incondicional una posicion mas
		RETLW 0			; Retorno de la subrutina y carga 0 a W

;*****INICIO DEL PROGRAMA *****
INICIO	CLRF STATUS			; Borra el contenido de STATUS
		BSF	STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW b'11111111' 	; Todo el puerto A sera entrada
		MOVWF TRISA			; Carga la configuracion a TRISA
		MOVLW b'11111110' 	; Todo el puerto B excepto el bit0
							; seran entradas
		MOVWF TRISB			; Carga la configuracion a TRISB
		BCF STATUS,RP0		; Seleccionamos el Banco 0
PARPADEA
		BSF	PORTB,0			; Manda un 1 al bit0 del PORTB
		CALL TEMPO			; Llama al retardo
		BCF PORTB,0			; Manda un 0 al bit0 del PORTB
		CALL TEMPO			; Llama al retardo
		GOTO PARPADEA		; Volver a parpadear
		END					; Fin del programa