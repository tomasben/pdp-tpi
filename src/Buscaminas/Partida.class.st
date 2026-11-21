"
Representa la partida actual, registrando el tablero asociado, la dificultad, el estado de la partida y la cantidad de banderas restantes

Creacion:
Partida tablero: 1, estado: en curso, nivel: medio, banderas restantes: 20
"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'estado',
		'nivel',
		'banderasRestantes'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'initalize' }
Partida >> Inicializar [

estado := #enCurso
]

{ #category : 'actions' }
Partida >> actualizarEstado: celda [ 

( self estaEnCurso ) ifTrue: [ 
			tablero descubrirCeldaEnFila: celda fila columna: celda columna.
			( self tieneMina ) ifTrue: [ estado := #perdida ] ifFalse: [ estado := #enCurso ]
	 ]
]

{ #category : 'actions' }
Partida >> alternarBandera: celda [
"Alterna el estado de bandera de una celda y actualiza el contador si la partida sigue en curso."

( self estaEnCurso ) ifTrue: [  
				(celda estaMarcada ) ifTrue: [ celda desmarcar. banderasRestantes := banderasRestantes + 1 ] 
					ifFalse: [
						(banderasRestantes ~= 0) ifTrue: [ celda marcar. banderasRestantes  := banderasRestantes - 1]
						].
		]
]

{ #category : 'changes' }
Partida >> estaEnCurso [
"devuelve True si la partida sigue activa, o false si ya termino"
^estado = #enCurso
]

{ #category : 'changes' }
Partida >> evaluarEstado [
"Verifica si el tablero tiene alguna mina descubierta (perdiste) o si ya se despejaron todas las celdas seguras (ganaste)"

(tablero todasLasCeldasSinMina) ifTrue: [ estado := #Ganada ]
]
