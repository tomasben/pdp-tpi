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
		'banderasRestantes',
		'reloj'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'instance creation' }
Partida class >> nivel: unNivel [
	"Crea una partida nueva con el tablero correspondiente al nivel (#facil, #medio o #dificil)."

	^ self new tablero: (self tableroParaNivel: unNivel) nivel: unNivel
]

{ #category : 'private' }
Partida class >> tableroParaNivel: unNivel [

	unNivel = #facil ifTrue: [ ^ Tablero dificultadFacil ].
	unNivel = #medio ifTrue: [ ^ Tablero dificultadMedia ].
	unNivel = #dificil ifTrue: [ ^ Tablero dificultadDificil ].
	^ self error: 'Nivel desconocido: ' , unNivel printString
]

{ #category : 'actions' }
Partida >> alternarBandera: celda [
"Alterna el estado de bandera de una celda y actualiza el contador si la partida sigue en curso."

( self estaEnCurso and: [ celda estaDescubierta not ] ) ifTrue: [  
				(celda estaMarcada ) ifTrue: [ celda desmarcar. banderasRestantes := banderasRestantes + 1 ] 
					ifFalse: [
						(banderasRestantes ~= 0) ifTrue: [ celda marcar. banderasRestantes  := banderasRestantes - 1]
						].
		]
]

{ #category : 'accessing' }
Partida >> banderasRestantes [
	^ banderasRestantes
]

{ #category : 'actions' }
Partida >> descubrirCelda: celda [ 

( self estaEnCurso ) ifFalse: [ ^self ].
(reloj estaDetenido) ifTrue: [ reloj iniciar ].
tablero descubrirCelda: celda.
(celda estaDescubierta and: [celda tieneMina]) ifTrue: [ estado := #perdida ]
															 ifFalse: [ self evaluarEstado ]

]

{ #category : 'changes' }
Partida >> estaEnCurso [
"devuelve True si la partida sigue activa, o false si ya termino"
^estado = #enCurso
]

{ #category : 'changes' }
Partida >> evaluarEstado [
	"Verifica si el tablero tiene alguna mina descubierta (perdiste) o si ya se despejaron todas las celdas seguras (ganaste)"

	(tablero cantidadCeldasSegurasPorDescubrir = 0) ifTrue: [ self terminarConEstado: #ganada ]
]

{ #category : 'initialization' }
Partida >> initialize [

	super initialize.
	estado := #enCurso.
	reloj := reloj new
]

{ #category : 'accessing' }
Partida >> nivel [
	^ nivel
]

{ #category : 'accessing' }
Partida >> tablero [
	^ tablero
]

{ #category : 'initialization' }
Partida >> tablero: unTablero nivel: unNivel [
	"Asocia el tablero y el nivel a la partida, y deja las banderas disponibles igual a la cantidad de minas."

	tablero := unTablero.
	nivel := unNivel.
	banderasRestantes := unTablero cantidadMinas.
	estado := #enCurso
]

{ #category : 'private' }
Partida >> terminarConEstado: unEstado [
	estado := unEstado. "cambia el estado de la partida (#ganada o #perdida)"
	reloj terminar "le pide a reloj que cambie su estado a #termiado"
]
