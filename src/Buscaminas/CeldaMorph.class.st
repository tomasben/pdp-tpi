Class {
	#name : 'CeldaMorph',
	#superclass : 'Morph',
	#instVars : [
		'fila',
		'columna',
		'juego'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'actions' }
CeldaMorph >> actualizar [
	"Refleja en pantalla el estado logico de la celda: sin descubrir, marcada o descubierta."

	| celda |
	juego ifNil: [ ^ self ].
	celda := self celdaLogica.

	celda estaDescubierta ifFalse: [
		self color: Color lightGray.
		^ self mostrarTexto: (celda estaMarcada ifTrue: [ 'B' ] ifFalse: [ '' ]) ].

	celda tieneMina ifTrue: [
		self color: Color red.
		^ self mostrarTexto: '*' ].

	self color: Color white.
	self mostrarTexto: (celda cantidadMinasVecinas > 0
			 ifTrue: [ celda cantidadMinasVecinas printString ]
			 ifFalse: [ '' ])
]

{ #category : 'actions' }
CeldaMorph >> alternarBandera [

	juego alternarBandera: self celdaLogica
]

{ #category : 'accessing' }
CeldaMorph >> celdaLogica [
	"Devuelve la celda del tablero que representa este morph."

	^ juego tablero celdaEnFila: fila columna: columna
]

{ #category : 'initialization' }
CeldaMorph >> configurarFila: unaFila columna: unaColumna [
fila:= unaFila.
columna:= unaColumna.
self extent: 30@30. 
self color: Color lightGray. 
self borderWidth: 1.
self borderColor: Color black.
]

{ #category : 'actions' }
CeldaMorph >> descubrir [

	juego actualizarEstado: self celdaLogica
]

{ #category : 'event handling' }
CeldaMorph >> handlesMouseDown: anEvent [
    ^ true
]

{ #category : 'accessing' }
CeldaMorph >> juego: unaPartida [

	juego := unaPartida
]

{ #category : 'private' }
CeldaMorph >> mostrarTexto: unTexto [

	| etiqueta |
	self removeAllMorphs.
	unTexto isEmpty ifTrue: [ ^ self ].
	etiqueta := StringMorph contents: unTexto.
	etiqueta center: self center.
	self addMorph: etiqueta
]

{ #category : 'event handling' }
CeldaMorph >> mouseDown: anEvent [
	"Click izquierdo: descubre la celda. Click derecho: alterna la bandera."

	juego ifNil: [ ^ self ].

	anEvent redButtonPressed ifTrue: [ self descubrir ].
	anEvent yellowButtonPressed ifTrue: [ self alternarBandera ].

	self owner ifNotNil: [ :tableroMorph | tableroMorph actualizar ]
]
