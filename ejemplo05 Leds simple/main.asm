#include <p16f84a.inc>	; Carga la cabecera del microcontrolador
radix	dec				; Por defecto los numeros estaran
 						; expresados en decimal 
	W 	EQU 0
	F 	EQU 1

;***REGISTROS DE LA RAM***
CTDOR1	EQU 0x0C	;Registro RAM
CTDOR2	EQU 0x0D	;Registro RAM
CTDOR3	EQU 0x0E	;Registro RAM

;***ZONA DE INICIO DEL MICROCONTROLADOR***
	ORG	0x00
	GOTO INICIO	; Ir al inicio del programa
	ORG	0x04	; Zona de interrupciones
	GOTO INICIO	; Ir al inicio del programa

;****ZONA DE SUBRUTINA DE RETARDO****
TEMPO	CLRF CTDOR2
BUCLE	DECFSZ CTDOR2,F
		GOTO BUCLE
		DECFSZ CTDOR1,F
		GOTO BUCLE
		RETLW 0
	
;*****INICIO DEL PROGRAMA*****
INICIO	CLRF STATUS			; Borra el contenido de STATUS
		BSF	STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW 0xFF			; Cargamos un valor literal en W
		MOVWF TRISA			; Movemos el valor de W a TRISA,
							; configurando el puerto entero como entrada
		MOVLW 0x00			; Cargamos un valor literal en W
		MOVWF TRISB			; Movemos el valor de W a TRISA,
							; configurando el puerto entero como entrada
		CLRF PORTB			; Ponemos a cero el puerto B (PORTB)
		CLRF PORTA			; Ponemos a cero el puerto A (PORTA)
		CLRF STATUS			; Ponemos a cero el registro STATUS para partir de unos valores conocidos
;***BUCLE DE RECORRIDO HACIA LA DERECHA DE UN SOLO LED
BUCLE1	CLRF PORTB			; Pone en 0 todos los pines del PORTB
		BSF	STATUS,C		; Pone un 1 en el bit C del registro STATUS
		MOVLW 8				; Carga el literal 8 en W
		MOVWF CTDOR3		; Carga el valor de W en CTDOR3
BUCLE2	RRF PORTB,F			; Rota a la derecha los bits de PORTB
		CALL TEMPO			; Llama a la subrutina de retardo TEMPO
		DECFSZ CTDOR3,F		; Decrementa en 1 CTDOR3 si llega a cero salta dos posiciones
		GOTO BUCLE2			; Salto incondicional a BUCLE2
;***BUCLE DE RECORRIDO HACIA LA IZQUIERDA DE UN SOLO LED
		CLRF PORTB			; Pone en 0 todos los pines del PORTB
		BSF STATUS,C		; Pone un 1 en el bit C del registro STATUS
		MOVLW 8				; Carga el literal 8 en W
		MOVWF CTDOR3		; Carga el valor de W en CTDOR3
BUCLE3	RLF PORTB,F 		; Rota a la izquierda los bits de PORTB
		CALL TEMPO			; Llama a la subrutina de retardo TEMPO
		DECFSZ CTDOR3,F		; Decrementa en 1 CTDOR3 si llega a cero salta dos posiciones
		GOTO BUCLE3			; Salto incondicional a BUCLE3
		GOTO BUCLE1			; Salto incondicional a BUCLE1
		END		;Fin del programa
	