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

{ #category : 'configuration' }
Tablero >> cantidadMinas: cantidad [
	"Establece la cantidad de celdas mina en el tablero. Debe ser menor o igual a la cantidad de celdas."

	celdas := self grillaConMinas: cantidad.
	^ self
]

{ #category : 'accessing' }
Tablero >> columnas [
	^ columnas
]

{ #category : 'configuration' }
Tablero >> densidadMinas: densidad [
	"Establece la proporción de minas respecto de celdas en el talbero. Recibe un número entre 0 y 1"

	| cantidad |
	cantidad := (filas * columnas * densidad) rounded.
	celdas := self grillaConMinas: cantidad.
	^ self
]

{ #category : 'accessing' }
Tablero >> filas [
	^ filas
]

{ #category : 'initialization' }
Tablero >> filas: numeroFilas columnas: numeroColumnas [
	"Establece las dimensiones del Tablero cuando se inicializa. Usa una proporción de minas del 15% por defecto."

	filas := numeroFilas.
	columnas := numeroColumnas.
	celdas := self grillaConMinas: 0.15.
	^ self
]

{ #category : 'private' }
Tablero >> grillaConMinas: cantidad [
	"Genera una colección de celdas con la cantidad de minas especificada"

	| indices minadas |
	indices := (1 to: filas * columnas) asArray shuffled.
	minadas := (indices first: cantidad) asSet.

	^ (1 to: filas) collect: [ :fila |
			  (1 to: columnas) collect: [ :columna |
					  | indice |
					  indice := ((fila - 1) * columnas) + columna.
					  (minadas includes: indice)
						  ifTrue: [ CeldaConMina fila: fila columna: columna ]
						  ifFalse: [ CeldaSinMina fila: fila columna: columna ] ] ]
]
