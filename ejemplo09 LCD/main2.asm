include <p16f84a.inc>
radix dec

TIMER0	EQU	01	; Registro del TIMER0
OPCION	EQU	0x1	; Registro de opciones,p gina 1
PCL		EQU 0x2	; Registro PC
PCLATH	EQU 0x0A; Registro alto del PC
STATUS	EQU 03	; Registro de estado
DATO_A	EQU 0x0C; Registro del dato A
DATO_B	EQU 0x0D; Registro del dato B
RESUL	EQU 0x0E; Registro de resultados
TEMPO1	EQU 0x0F; Registro temporal 1
TEMPO2	EQU 0x10; Registro temporal 2
OFFSET	EQU 0x11; Variable de desplazamientos de mensajes
Digito	EQU 0x1F; Cursor para leer la tabla de datos.

	ORG	0
	GOTO INICIO
	ORG 4
	GOTO INICIO

LCD_E	BSF	PORTA,2		;Activa señal E
		NOP				;Espera 1uS
		BCF PORTA,2		;Desactiva señal E
		RETURN
                
LCD_BUSY
		BSF PORTA,1		;Pone el LCD en modo lectura
		BSF STATUS,RP0	;Selecciona el Banco 1
		MOVLW 0xFF
		MOVWF TRISB		;Puerta B act£a de entrada
		BCF STATUS,RP0	;Selecciona el Banco 0
		BSF PORTA,2		;Activa el LCD (Señal E)
		NOP           
L_BUSY	BTFSC PORTB,7	;Chequea el bit BUSY
		GOTO L_BUSY		;Est  a "1" (Ocupado)
		BCF PORTA,2		;Desactiva el LCD (Se¤al E)
		BSF STATUS,RP0	;Selecciona el Banco 1
		CLRF TRISB		;Puerta B actua como salida
		BCF STATUS,RP0	;Selecciona el Banco 0
		BCF PORTA,1		;Pone el LCD en modo escritura
		RETURN
                              
LCD_REG	BCF	PORTA,0		;Desactiva RS (Modo instruccion)
		MOVWF PORTB		;Saca el codigo de instruccion
		CALL LCD_BUSY	;Espera a que se libere el LCD
		GOTO LCD_E		;Genera pulso en señal E
                              
LCD_DATOS
		BCF PORTA,0		;Desactiva RS (Modo instrucci¢n)
		MOVWF PORTB		;Valor ASCII a sacar por RB
		CALL LCD_BUSY	;Espera a que se libere el LCD
		BSF PORTAA,0	;Activa RS (Modo dato)  
		GOTO LCD_E		;Genera pulso en señal E
                              
LCD_INI	MOVLW b'00111000'
		CALL LCD_REG	;Codigo de instruccion
		CALL DELAY_5MS	;Temporiza 5 mS.
		MOVLW b'00111000'
		CALL LCD_REG	;Codigo de instruccion
		CALL DELAY_5MS	;Temporiza 5 mS.
		MOVLW b'00111000'
		CALL LCD_REG	;Codigo de instruccion
		CALL DELAY_5MS	;Temporiza 5 mS.
		RETURN            
                              
LCD_PORT       
		BSF STATUS,RP0		;Selecciona el banco 1 de datos
		CLRF TRISB			;RB se programa como salida
		MOVLW b'00011000' 	;RA<4:3> se programan como entradas
		MOVWF TRISA			;RA<2:0> se programan como salidas
		BCF STATUS,RP0		;Selecciona el banco 0 de datos
		;MOVLW b'00000000'      
		;MOVWF INTCON		;Desactiva interrupciones
		BCF PORTA,0			;Desactiva RS del modulo LCD
		BCF PORTA,2			;Desactiva E del modulo LCD
                                                     
;DELAY_5MS genera una temporizacion de 5mS necesario para la secuencia de
;inicio del LCD                         
                                        
DELAY_5MS
		MOVLW 0x1A
		MOVWF DATO_B                 
		CLRF DATO_A                  
DELAY_1 DECFSZ DATO_A,1              
		GOTO DELAY_1                 
		DECFSZ DATO_B,1              
		GOTO DELAY_1                 
		RETURN

;****** INICIO PROGRAMA PRINCIPAL *****

INICIO	CLRF Digito			;Pone a 0 la variable digito 
		CALL LCD_PORT		;Puertos en modo LCD 
		BCF PORTA,0			;Desactiva RS del modulo LCD
		BCF PORTA,2			;Desactiva E del modulo LCD 
START	CALL LCD_INI		;Inicia LCD (CFG puertos...) 
		MOVLW b'00000001'	;Borrar LCD y Home 
		CALL LCD_REG 
		MOVLW b'00000110'  
		CALL LCD_REG 
		MOVLW b'00001100'	;LCD On, cursor Off,Parpadeo Off 
		CALL LCD_REG 
		MOVLW 0x80			;Direccion caracter
		CALL LCD_REG 

REPETIR	MOVF Digito,W		;W=Digito
		CALL DATO_1			;Coge el caracter 
		IORLW 0				;Compara 
		BTFSC STATUS,2		;Es el ultimo? 
		GOTO ACABAR			;Si 
		CALL LCD_DATOS   	;Visualiza caracter 
		INCF Digito,F		;Incrementa numero de Digito
		GOTO REPETIR		;Vuelve a escribir

ACABAR	NOP
		GOTO $

;***** TABLA DE DATOS

DATO_1	ADDWF  PCL,1 
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
		RETLW 0x00 
		END