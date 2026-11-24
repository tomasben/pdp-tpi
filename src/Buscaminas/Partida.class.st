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
		'reloj',
		'vidasResantes'
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

    | celdaActual |
    (self estaEnCurso) ifFalse: [ ^ self ].

    (celda estaDescubierta or: [ celda estaMarcada ])
        ifTrue: [ ^ self ].

    (reloj estaDetenido) ifTrue: [ reloj iniciar ].

    tablero descubrirCeldaEnFila: (celda fila)
        columna: (celda columna).

    "El primer clic puede regenerar el tablero y reemplazar sus celdas."
    celdaActual := tablero celdaEnFila: celda fila columna: celda columna.
    (celdaActual estaDescubierta and: [ celdaActual tieneMina ])
        ifTrue: [ self perderVida ]
        ifFalse: [ self evaluarEstado ].
]

{ #category : 'changes' }
Partida >> estaEnCurso [
"devuelve True si la partida sigue activa, o false si ya termino"
^estado = #enCurso
]

{ #category : 'changes' }
Partida >> evaluarEstado [
	"Verifica si se despejaron todas las celdas seguras."

	(tablero cantidadCeldasSegurasPorDescubrir = 0) ifTrue: [ self terminarConEstado: #ganada ]
]

{ #category : 'initialization' }
Partida >> initialize [

	super initialize.
	estado := #enCurso.
	reloj := Reloj new
]

{ #category : 'accessing' }
Partida >> nivel [
	^ nivel
]

{ #category : 'private' }
Partida >> perderVida [
	vidasResantes := vidasResantes - 1.
	vidasResantes = 0 ifTrue: [ self terminarConEstado: #perdida ]
]

{ #category : 'accessing' }
Partida >> reloj [ 
 ^ reloj 
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
	vidasResantes := self vidasParaNivel: unNivel.
	estado := #enCurso
]

{ #category : 'private' }
Partida >> terminarConEstado: unEstado [
	estado := unEstado.
	reloj terminar.
	estado = #perdida ifTrue: [ tablero descubrirTodasLasMinas ]
]

{ #category : 'private' }
Partida >> vidasParaNivel: unNivel [
	unNivel = #facil ifTrue: [ ^3 ].
	unNivel = #facil ifTrue: [ ^2 ].
	^1
]

{ #category : 'accessing' }
Partida >> vidasRestantes [
	^vidasResantes 
]
