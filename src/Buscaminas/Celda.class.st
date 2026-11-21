"
Representa un bloque o división del tablero de juego
"
Class {
	#name : 'Celda',
	#superclass : 'Object',
	#instVars : [
		'fila',
		'columna',
		'estaDescubierta',
		'estaMarcada',
		'cantidadMinasVecinas'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'instance creation' }
Celda class >> fila: numeroFila columna: numeroColumna [
	^ self new fila: numeroFila columna: numeroColumna
]

{ #category : 'accessing' }
Celda >> cantidadMinasVecinas [

	^ cantidadMinasVecinas
]

{ #category : 'accessing' }
Celda >> cantidadMinasVecinas: cantidad [

	cantidadMinasVecinas := cantidad
]

{ #category : 'accessing' }
Celda >> columna [
	^ columna
]

{ #category : 'actions' }
Celda >> descubrir [

	estaDescubierta := true
]

{ #category : 'actions' }
Celda >> desmarcar [

	estaMarcada := false
]

{ #category : 'testing' }
Celda >> estaDescubierta [

	^ estaDescubierta
]

{ #category : 'testing' }
Celda >> estaMarcada [

	^ estaMarcada
]

{ #category : 'accessing' }
Celda >> fila [
	^ fila
]

{ #category : 'initialization' }
Celda >> fila: numeroFila columna: numeroColumna [
	"Configura las posiciones de la celda en el tablero"

	fila := numeroFila.
	columna := numeroColumna.
	^ self
]

{ #category : 'initialization' }
Celda >> initialize [
	super initialize.
	estaDescubierta := false.
	estaMarcada := false.
	cantidadMinasVecinas := 0.
]

{ #category : 'actions' }
Celda >> marcar [

	estaMarcada := true
]

{ #category : 'testing' }
Celda >> tieneMina [
	^ self subclassResponsibility
]
