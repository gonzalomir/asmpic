#include <p16f84a.inc>	; Carga la cabecera del microcontrolador
radix dec

;***ZONA DE ETIQUETAS***
W	EQU	0	; Registro de Trabajo W como destino
F 	EQU 1	; Registro F como destino
CL	EQU 0	; Pin Reset del 74LS164
CK	EQU 1	; Pin Clock del 74LS164
DAT EQU 2	; Pin Data Input del 74LS164

;***ZONA DE ETIQUETAS DE LA RAM***
VAR1	EQU	0x0C
VAR2	EQU 0x0D
VAR3	EQU 0x0E
AUX1	EQU 0x0F
CTDOR1	EQU 0x10

;***ZONA DE INICIO DEL MICROCONTROLADOR***
		ORG	0x00
		GOTO INICIO	; Ir al inicio del programa
		ORG	0x04	; Zona de interrupciones
		GOTO INICIO	; Ir al inicio del programa
;***ZONA DE SUBRUTINAS***
;*SUBRUTINA DE SALIDA DE DATOS POR EL 74HC164 = SAL164
SAL164	MOVLW 8				; Cargamos el literal 8 en W
		MOVWF CTDOR1		; Cargamos el contenido de W en CTDOR1
BUCLE1	BCF PORTA,CK		; Flanco de bajada en el pin reloj (CK)
		BSF PORTA,DAT		; Ponemos un 1 en el pin datos (DAT)
		BTFSC AUX1, 0		; Si AUX1.0 == 0 Salta 2 posiciones
		BCF PORTA,DAT		; Ponemos un 0 en el pin datos (DAT)
		BSF PORTA,CK		; Flanco de subida en el pin reloj (CK)
		RRF AUX1,F			; Rotamos a la derecha AUX1
		DECFSZ CTDOR1,F		; Decrementamos CTDOR1 y salta si es 0
		GOTO BUCLE1			; Salto incondicional a BUCLE1
		RETURN				; Retorno de rutina

;*SUBRUTINA DE LIMPIEZA DE LOS DATOS DE LOS 74HC164 = LIMPIA
LIMPIA	BSF PORTA,CL		; Ponemos un 1 en el pin clear/reset(CL)
		BCF PORTA,CL		; Ponemos un 0 en el pin clear/reset(CL)
		BSF PORTA,CL		; Ponemos un 1 en el pin clear/reset(CL)
		RETURN				; Retorno de rutina

;*****INICIO DEL PROGRAMA*****
INICIO	CLRF STATUS			; Borra el contenido de STATUS
		BSF	STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW b'11111000'	; Cargamos un valor literal en W
		MOVWF TRISA			; Movemos el valor de W a TRISA, PORTA 5 entradas 3 salidas
		MOVLW b'00000000'	; Cargamos un valor literal en W
		MOVWF TRISB			; Movemos el valor de W a TRISA, PORTB como salida
		BCF STATUS,RP0		; Seleccionamos el Banco 0

		MOVLW B'01010101'	; Carga un literal al W
		MOVWF VAR1			; Pasa del W a VAR1
		MOVLW B'00110011'	; Carga un literal al W
		MOVWF VAR2			; Pasa del W a VAR2
		MOVLW B'00001111'	; Carga un literal al W
		MOVWF VAR3			; Pasa del W a VAR3

		CALL LIMPIA			; Limpiamos los valores de los 74HC164

		MOVF VAR1,W			; Cargamos en W el valor de VAR1
		MOVWF AUX1			; Cargamos el valor de W a AUX1
		CALL SAL164			; Llamamos a la subrutina de salida de datos

		MOVF VAR2,W			; Cargamos en W el valor de VAR2
		MOVWF AUX1			; Cargamos el valor de W a AUX1
		CALL SAL164			; Llamamos a la subrutina de salida de datos

		MOVF VAR3,W			; Cargamos en W el valor de VAR3
		MOVWF AUX1			; Cargamos el valor de W a AUX1
		CALL SAL164			; Llamamos a la subrutina de salida de datos

		GOTO $
		END					; Fin del programa