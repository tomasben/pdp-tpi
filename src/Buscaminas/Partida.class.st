"
Representa la partida actual, registrando el tablero asociado, la dificultad, el estado de la partida y la cantidad de banderas restantes

Creación:
Partida nivel: #medio
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

{ #category : 'private' }
Partida class >> configuracionParaNivel: unNivel [

	| configuraciones |
	configuraciones := {
		#facil -> { #crearTablero -> [ Tablero dificultadFacil ]. #vidas -> 3 } asDictionary.
		#medio -> { #crearTablero -> [ Tablero dificultadMedia ]. #vidas -> 2 } asDictionary.
		#dificil -> { #crearTablero -> [ Tablero dificultadDificil ]. #vidas -> 1 } asDictionary
	} asDictionary.

	^ configuraciones at: unNivel ifAbsent: [
		  self error: 'Nivel desconocido: ' , unNivel printString ]
]

{ #category : 'instance creation' }
Partida class >> nivel: unNivel [
	"Crea una partida con el tablero y las vidas de la dificultad elegida."

	| configuracion |
	configuracion := self configuracionParaNivel: unNivel.
	^ self new
		  tablero: (configuracion at: #crearTablero) value
		  nivel: unNivel
		  vidas: (configuracion at: #vidas)
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
	"Permite crear una partida con un tablero personalizado y las vidas del nivel elegido."

	| configuracion |
	configuracion := self class configuracionParaNivel: unNivel.
	^ self
		  tablero: unTablero
		  nivel: unNivel
		  vidas: (configuracion at: #vidas)
]

{ #category : 'private' }
Partida >> tablero: unTablero nivel: unNivel vidas: cantidadVidas [

	tablero := unTablero.
	nivel := unNivel.
	banderasRestantes := unTablero cantidadMinas.
	vidasResantes := cantidadVidas.
	estado := #enCurso
]

{ #category : 'private' }
Partida >> terminarConEstado: unEstado [
	estado := unEstado.
	reloj terminar.
	estado = #perdida ifTrue: [ tablero descubrirTodasLasMinas ]
]

{ #category : 'accessing' }
Partida >> vidasRestantes [
	^vidasResantes 
]
