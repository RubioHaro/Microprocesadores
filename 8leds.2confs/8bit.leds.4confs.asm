;
; ESCOM | IPN
;

; Declaraciones
	; Definimos los contadores
	.def temp=r16
	.def cont1=r17
	.def cont2=r18
	.def cont3=r19

	.cseg
	.org 0

	ldi temp,$ff
	out ddrd,temp	
	ldi temp,$03 	
	out portc,temp 

main: 
	;in: lee un puerto, en este caso el puerto C (Input), que contiene los push buttons, 
	; estos push buttons estan conectados a los pines A0 y A1, es decir, los bits 0 y 1 del puerto C.
	in temp,pinc 	
	;andi: operacion logica AND entre registros, en este caso con un valor dado (AND with Immediate)
	; esta operacion
	andi temp,$03 

	;cpi: comparacion entre registros, en este caso con un valor dado (Compare with Immediate)
	cpi temp,$00
	;breq: hace un salto a una etiqueta, en este caso "abrir" si en la instruccion anterior, temp = $00, 
	;el bit "Z" (Zero) del registro de estado está establecido en 1, es decir se cumple la comparacion.
	breq abrir	

	; estas dos instrucciones se pueden omitir, ya que si no se cumple ninguna de las opciones, seguiria la instruccion
	; cerrar, puesta inmediatamente despues del main, y, como todas las instrucciones, hay un rjmp main, que regresa al inicio
	; comparamos, si temp = $01, si se cumple, ejecuta la instruccion siguiente.
	cpi temp,$01
	breq cerrar

	; comparamos, si temp = $02, si se cumple, ejecuta la instruccion siguiente.
	cpi temp,$02 	
	breq doble

	; comparamos, si temp = $03, si se cumple, ejecuta la instruccion siguiente.
	cpi temp,$03 	
	breq normal	
	

cerrar:
	; ldi: carga un valor en un registro, en este caso en el registro temp, 
	; se utiliza $81, ques es equivalente a 1000 0001 en binario
	; ldi temp,$81
	; out portd,temp
	; call delay_uno

	in temp,pind
	; se repite la instruccion anterior, para que se pueda ver el movimiento de los leds
	ldi temp, $81
	out portd,temp
	rcall delay_uno

	; se utiliza $42, que es equivalente a 0100 0010 en binario
	ldi temp, $42
	out portd,temp
	rcall delay_uno

	; se utiliza $24, que es equivalente a 0010 0100 en binario
	ldi temp, $24
	out portd,temp
	rcall delay_uno

	; se utiliza $18, que es equivalente a 0001 1000 en binario
	ldi temp, $18
	out portd,temp
	rcall delay_uno
	
	; se regresa al main
	rjmp main

abrir:
	; Revisar si es util esta instruccion, yo creo que no.
	; ldi temp,$18
	; out portd,temp
	; call delay_uno

	in temp,pind
	; se repite la logica de cerrar, pero cambiando el orden de los leds
	; se usa $18, que es equivalente a 0001 1000 en binario
	ldi temp, $18
	out portd,temp
	rcall delay_uno

	; se usa $24, que es equivalente a 0010 0100 en binario
	ldi temp, $24
	out portd,temp
	rcall delay_uno

	; se usa $42, que es equivalente a 0100 0010 en binario
	ldi temp, $42
	out portd,temp
	rcall delay_uno

	; se usa $81, que es equivalente a 1000 0001 en binario
	ldi temp, $81
	out portd,temp
	rcall delay_uno
	; se regresa al main
	rjmp main

doble:
	; ldi asigna un valor a un registro, en este caso, se asigna el valor $01 a temp
	ldi temp,$01
	; out escribe en un puerto, en este caso, en el puerto D, que es el que controla los leds
	out portd,temp
	; call llama a una funcion, en este caso, a la funcion delay_doble, 
	; que ejecuta 2 veces la funcion delay_general
	call delay_doble
	; in lee un puerto, en este caso, el puerto D, que contiene los leds
	in temp,pind
	; si el valor es $01, es decir el bit menos significativo es 1, se manda a la etiqueta izq,
	; de lo contrario se ejecuta a la etiqueta der
	cpi temp,$01
	breq izq
	
der:
	; lsr: operacion logica de desplazamiento a la derecha, en este caso, se desplaza el valor de temp
	lsr temp
	out portd,temp
	call delay_doble
	cpi temp,$01
	; brne: hace un salto a una etiqueta, en este caso, a la etiqueta der, si el bit "Z" (Zero) del registro de estado 
	; no está establecido en 1, es decir, si no se cumple la comparacion.
	; es decir, se ejecurara la etiqueta der, mientras el valor de temp sea diferente de $01.
	brne der
	rjmp main
izq:
	lsl temp
	out portd,temp
	call delay_doble
	; compara si temp = $80, que es equivalente a 1000 0000 en binario,
	; es decir, si el bit mas significativo es 1 se reinicia el ciclo
	cpi temp,$80
	; breq: hace un salto a una etiqueta, en este caso, a la etiqueta der, si el bit "Z" (Zero) del registro de estado
	; está establecido en 1, es decir, si se cumple la comparacion.
	breq der
	rjmp izq

normal:ldi temp,$01
	; la logica de este ciclo es la misma que la del ciclo doble, pero con una funcion de delay diferente
	out portd,temp
	call delay_normal

	in temp,pind
	cpi temp,$01
	breq izquierda

derecha:lsr temp
	out portd,temp
	call delay_normal
	; compara si temp = $01, que es equivalente a 0000 0001 en binario,
	; es decir, si el bit menos significativo es 1 se reinicia el ciclo, cambiando la direccion
	cpi temp,$01
	brne derecha
	rjmp main

izquierda:lsl temp
	out portd,temp
	call delay_normal
	; compara si temp = $80, que es equivalente a 1000 0000 en binario,
	; es decir, si el bit mas significativo es 1 se reinicia el ciclo, cambiando la direccion
	cpi temp,$80
	breq derecha
	rjmp izquierda

delay_general:
	lazo3:ldi cont2,250
	lazo2:ldi cont3,200
	lazo1:
		; nop: no operation, es decir, no hace nada, se utiliza para retrasar el ciclo
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		
		; dec: decrementa el valor de un registro, en este caso, decrementa el valor de cont3
		dec cont3
		; brne: hace un salto a una etiqueta, en este caso, a la etiqueta lazo1, si el bit "Z" (Zero) del registro de estado
		; no está establecido en 1, es decir, si no se cumple la comparacion.
		brne lazo1
		
		dec cont2
		brne lazo2
		
		dec cont1
		brne lazo3
		
		ret

delay_normal:
	; ldi asigna un valor a un registro, en este caso, se asigna el valor 4 a cont1;
	; es decir, se ejecutara la funcion cuando el valor de cont1 sea 0.
	ldi cont1,4
	; rjmp: hace un salto a una etiqueta, en este caso, a la etiqueta delay_general
	rjmp delay_general

delay_doble:
	; ldi asigna un valor a un registro, en este caso, se asigna el valor 4 a cont1;
	; es decir, se ejecutara la funcion cuando el valor de cont1 sea 0.
	ldi cont1,2
	rjmp delay_general

delay_uno:
	; ldi asigna un valor a un registro, en este caso, se asigna el valor 8 a cont1;
	; es decir, se ejecutara la funcion cuando el valor de cont1 sea 0.
	ldi cont1,8
	rjmp delay_general