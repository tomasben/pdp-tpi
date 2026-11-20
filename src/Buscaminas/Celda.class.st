"
Representa uno de los bloques del tablero
"
Class {
	#name : 'Celda',
	#superclass : 'Object',
	#instVars : [
		'fila',
		'columna',
		'descubierta',
		'marcada'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'instance creation' }
Celda class >> fila: numeroFila columna: numeroColumna [
	^ self new fila: numeroFila columna: numeroColumna
]

{ #category : 'accessing' }
Celda >> columna [
	^ columna
]

{ #category : 'actions' }
Celda >> descubrir [
	descubierta := true
]

{ #category : 'actions' }
Celda >> desmarcar [
	marcada := false
]

{ #category : 'testing' }
Celda >> estaDescubierta [
	^ descubierta
]

{ #category : 'testing' }
Celda >> estaMarcada [
	^ marcada 
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

{ #category : 'actions' }
Celda >> marcar [
	marcada := true
]

{ #category : 'testing' }
Celda >> tieneMina [
	^ self subclassResponsibility
]
