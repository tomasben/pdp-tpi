"
Representa el tablero de juego y contiene las dimensiones y celdas que lo componen.

Creación:
Tablero filas: 3 columnas: 5.
"
Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'filas',
		'columnas',
		'celdas'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'instance creation' }
Tablero class >> filas: numeroFilas columnas: numeroColumnas [

	^ self new filas: numeroFilas columnas: numeroColumnas
]

{ #category : 'accessing' }
Tablero >> columnas [
	^ columnas
]

{ #category : 'accessing' }
Tablero >> filas [
	^ filas
]

{ #category : 'instance creation' }
Tablero >> filas: numeroFilas columnas: numeroColumnas [
	"Establece la cantidad de filas y columnas del Tablero en el momento de su creación."

	filas := numeroFilas.
	columnas := numeroColumnas.
	celdas := (1 to: filas) collect: [ :fila |
		(1 to: columnas) collect: [ :columna | Celda fila: fila columna: columna ]
	].
	^ self
	
]
