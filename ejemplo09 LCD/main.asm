include 	<P16F84A.INC>
;***************************************************;
;	4 BIT LCD interfaz con PIC						;
;	Implementado solamente en el Puerto B (PORTB)	;
;	RB7-RB4 = DB7-DB4  ; RB3=E ; RB2=RW ; RB1=RS	;
;***************************************************;

;Declaracion de bits
BIT_E	EQU	3		; Pin 3 de PORTB, conectado al pin E del LCD
BIT_RW	EQU	2		; Pin 2 de PORTB, conectado al pin RW del LCD
BIT_RS	EQU	1		; Pin 1 de PORTB, conectado al pin RS del LCD

TEMP	EQU	0x20	; Variable temporal TEMP

V_DLY	EQU	0x21    ; Variable para la rutina DLY
V_DLY1	EQU	0x22    ; for DLY1

Digito	EQU 0x1F; Cursor para leer la tabla de datos.

;****** DIRECTIVAS DE INICIO *****
		ORG 0
		GOTO INICIO
		ORG 4
		GOTO INICIO
		
;****** ZONA DE SUBRUTINAS ******
;*** SUBRUTINA INICIALIZAR PIC = INITPIC ***
INITPIC
		BSF		STATUS,RP0		; Seleccionamos el Banco 1
		MOVLW 	B'00000000'
		MOVWF 	TRISB			; Todos los pines PORTB seran salidas
		BCF		STATUS,RP0 		; Seleccionamos el Banco 0
		CLRF 	PORTB	
		RETURN

;*** SUBRUTINA INICIALIZAR LCD = INITLCD ***		
INITLCD MOVLW	0xFE		; Espera larga (254->W)
		CALL	DLY1		; 254 * 0.5 = Retardo de 127 milisegundos
		; El bit Busy (Ocupado) no puede ser consultado en este momento
		MOVLW	B'00111000'	; FUNCTION SET - 8 BIT, BIT_E = 1
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; BIT_E = 0
		MOVLW	0x0A		; Espera corta (10->W)
		CALL	DLY1 		; 10 * 0.5 = Retardo de 5 milisegundos
		MOVLW	B'00111000'	; FUNCTION SET - 8 BIT, BIT_E = 1
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; BIT_E = 0
		MOVLW	0x02		; Espera corta (2->W)
		CALL	DLY1 		; 2 * 0.5 = Retardo de 1 milisegundo
		MOVLW	B'00111000'	;FUNCTION SET - 8 BIT, BIT_E = 1
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; BIT_E = 0
		; El bit Busy ya puede ser consultado
		CALL	LCDBUSY		; Consulta al bit Busy
		MOVLW	B'00101000'	; FUNCTION SET - 4 BIT , BIT_E = 1
		MOVWF	PORTB
		BCF		PORTB,BIT_E
		; Todos los comandos deben ser cada dos ciclos desde este punto
		CALL	LCDBUSY		; FUNCTION SET
		MOVLW	B'00101000'
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; 1 Ciclo
		MOVLW	B'10001000'
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; 2 Ciclos
		CALL	LCDBUSY		; DISPLAY CONTROL 
		MOVLW	B'00001000'	; Primer Nibble y BIT_E = 1, BIT_RW = 0, BIT_RS  =0
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; 1 Ciclo
		MOVLW	B'11111000'	; DISPLAY CONTROL NIBBLE
							; (DISP=ON,CURSOR=ON,BLINK=ON) AND BIT_E=1,BIT_RW=0,BIT_RS=0
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; 2 Ciclos
		
		CALL	LCDBUSY		; Limpiar el LCD y poner el cursor en Home
		MOVLW	B'00001000'
		MOVWF	PORTB
		BCF		PORTB,BIT_E
		MOVLW	B'00011000'
		MOVWF	PORTB
		BCF		PORTB,BIT_E
		
		CALL	LCDBUSY		; ENTRY SET 
		MOVLW	B'00001000'	; BIT_E=1,BIT_RW=0,BIT_RS=0
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; 1 CYCLE
		MOVLW	B'01101000'	; ENTRY SET - INCREMENT,NO DISP SHIFT(CUR SHIFT),BIT_E=1,BIT_RW=0,BIT_RS=0
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; 2 CYCLE
		
		RETURN

;*** SUBRUTINA DE CONSULTA SI EL LCD ESTA OCUPADO = LCDBUSY ***				
LCDBUSY
		BSF		STATUS,RP0	; Seleccionar el Banco 1
		MOVLW	B'11110000'
		MOVWF	TRISB		; SET RB7-RB4 INPUT
		BCF		STATUS,RP0	; Seleccionar el Banco 0
		
		BSF		PORTB,BIT_RW
		BCF		PORTB,BIT_RS
		
		BSF		PORTB,BIT_E
		MOVF	PORTB,W		; Leer
		BCF		PORTB,BIT_E	; 1 ciclo
		BSF		PORTB,BIT_RW
		BCF		PORTB,BIT_RS
		BSF		PORTB,BIT_E
		NOP					; DO NOTTHING COZ BUSY FLAG IS IN FIRST NIBBLE
		BCF		PORTB,BIT_E	; 2 ciclos
		
		ANDLW	0x80
		BTFSS	STATUS,Z	; Verifica el bit Busy
		GOTO	LCDBUSY		; Esperar que se desocupe el LCD
		
		BCF		PORTB,BIT_RW	;
		BSF		STATUS,RP0		; NOT BUSY SO MAKE PORT B O/P
		MOVLW	0x00
		MOVWF	TRISB
		BCF		STATUS,RP0
		
		RETURN

;*** SUBRUTINAS COMANDOS LCD ***				
;*** COMANDO LINEA 2 = LINE2 ***		
LINE2		;by selecting DDRAM address = 0x40 in case of 16x4 line LCD, see datasheet of HD44780
		CALL	LCDBUSY
		MOVLW	B'11001000'
		MOVWF	PORTB
		BCF		PORTB,BIT_E	; E=0
		MOVLW	B'00001000'
		MOVWF	PORTB
		BCF		PORTB,BIT_E
		RETURN
		
;*** COMANDO ESCRIBIR EN EL LCD = LCDWRITE ***		
LCDWRITE		;Writes data/character in W register to sellected CG/DD RAM, see its use in START routine
		MOVWF	TEMP		; Guarda el valor que se quiere desplegar
		CALL	LCDBUSY		; Preguntamos si el LCD esta libre
		MOVF	TEMP,W		; Pasamos el dato a W
		ANDLW	B'11110000'	; Validamos la parte alta del dato a sacar
		IORLW	B'00001010'	; BIT_E=1, BIT_RW=0, BIT_RS=1
		MOVWF	PORTB		; Pasa a PORTB el dato
		BCF		PORTB,BIT_E	; 1 Ciclo
		SWAPF	TEMP,W		; Intercambio de nibbles de TEMP el resultado lo guarda en W
		ANDLW	B'11110000'	; Validamos la parte alta del dato a sacar
		IORLW	B'00001010'	; BIT_E=1,BIT_RW=0,BIT_RS=1
		MOVWF	PORTB		; Pasa a PORTB el dato
		BCF		PORTB,BIT_E	; 2 Ciclos
		RETURN

;*** SUBRUTINA DE 500 MICROSEGUNDOS CON CRISTAL DE 4 MHZ = DLY ***
							; Llamada a la subrutina 			  2 Ciclos
DLY    	MOVLW	D'165'		; Carga el literal 165 en W (165->W). 1 Ciclo
    	MOVWF	V_DLY		; Carga W en la variable V_DLY.		  1 Ciclo
DLY_LOOP
    	DECFSZ	V_DLY, F    ; Decrementa V_DLY hasta que sea 0. 166 = 165 + 1 Ciclos
    	GOTO	DLY_LOOP    ; Salto a la etiqueta DLY_LOOP      328 = 2 * 164 Ciclos
    	RETURN              ; Retorno de subrutina				  2 Ciclos
							;									----------------------
							; 500 us de retardo			TOTAL = 500 Ciclos

;*** SUBRUTINA DE DELAY N-VECES 500 MICROSEGUNDOS = DLY1 ***
DLY1	MOVWF V_DLY1            
DLY1_LOOP
    	CALL DLY           
    	DECFSZ V_DLY1, F         
    	GOTO DLY1_LOOP     
		RETURN                      

;*** INICIO DE PROGRAMA ***
INICIO	CALL INITPIC		; Inicializa el PIC
		CALL INITLCD		; Inicializa el LCD

		CLRF Digito			;Pone a 0 la variable digito 
REPETIR	MOVF Digito,W		;W=Digito
		CALL DATO_1			;Coge el caracter 
		IORLW 0				;Compara 
		BTFSC STATUS,2		;Es el ultimo? 
		GOTO SIG			;Si 
		CALL LCDWRITE   	;Visualiza caracter 
		INCF Digito,F		;Incrementa numero de Digito
		GOTO REPETIR		;Vuelve a escribir						
			
SIG		CALL LINE2			;set crussor to line 2

		CLRF Digito			;Pone a 0 la variable digito 
REP2	MOVF Digito,W		;W=Digito
		CALL DATO_2			;Coge el caracter 
		IORLW 0				;Compara 
		BTFSC STATUS,2		;Es el ultimo? 
		GOTO LOOP			;Si 
		CALL LCDWRITE   	;Visualiza caracter 
		INCF Digito,F		;Incrementa numero de Digito
		GOTO REP2			;Vuelve a escribir								
		
LOOP	NOP		
		GOTO LOOP			; Fin del programa
	
DATO_1	ADDWF  PCL,1 	; DATO_1="HOLA MUNDO!"
		RETLW  'H' 
		RETLW  'O'
		RETLW  'L' 
		RETLW  'A' 
		RETLW  ' ' 
		RETLW  'M' 
		RETLW  'U' 
		RETLW  'N' 
		RETLW  'D' 
		RETLW  'O' 
		RETLW  '!' 
		RETLW 0x00 

DATO_2	ADDWF  PCL,1 	; DATO_2="LINEA DOS" 
		RETLW  'L' 
		RETLW  'I'
		RETLW  'N' 
		RETLW  'E' 
		RETLW  'A' 
		RETLW  ' ' 
		RETLW  'D' 
		RETLW  'O' 
		RETLW  'S' 
		RETLW 0x00 
	
		END