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

	| totalCeldas |
	totalCeldas := filas * columnas.
	cantidad isInteger ifFalse: [ self error: 'La cantidad de minas debe ser un número entero' ].

	(cantidad >= 0 and: cantidad <= totalCeldas) ifFalse: [
		self error: 'La cantidad de minas debe estar entre 0 y ' , totalCeldas asString , ', inclusive' ].

	celdas := self grillaConMinas: cantidad.
	 celdas do: [ :filaDeCeldas |
        filaDeCeldas do: [ :celda |
            celda cantidadMinasVecinas:
                ((self vecinasDe: celda) count: [ :vecina | vecina tieneMina ]) ] ].
	
	^ self
]

{ #category : 'accessing' }
Tablero >> columnas [
	^ columnas
]

{ #category : 'configuration' }
Tablero >> densidadMinas: densidad [
	"Establece la proporción de minas respecto de celdas en el tablero. Recibe un número entre 0 y 1"

	((densidad >= 0) and: (densidad <= 1))
		ifFalse: [ self error: 'La densidad de minas debe ser un número entre 0 y 1' ].

	^ self cantidadMinas: (filas * columnas * densidad) rounded
]

{ #category : 'actions' }
Tablero >> descubrirCelda: unaCelda [
	(unaCelda estaDescubierta or: unaCelda estaMarcada)
		ifTrue: [  ^ self ].
		
	unaCelda descubrir. 
	unaCelda tieneMina ifTrue: [ ^ self ].
	
	(self vecinasDe: unaCelda) do:	[ :celdaVecina |
		(celdaVecina tieneMina or: celdaVecina estaMarcada) ifFalse: [ celdaVecina descubrir ].
	].

	
]

{ #category : 'accessing' }
Tablero >> filas [
	^ filas
]

{ #category : 'initialization' }
Tablero >> filas: numeroFilas columnas: numeroColumnas [
	"Establece las dimensiones del Tablero cuando se inicializa. Usa una proporción de minas del 15% por defecto"

	filas := numeroFilas.
	columnas := numeroColumnas.
	self densidadMinas: 0.15.
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

{ #category : 'accessing' }
Tablero >> vecinasDe: unaCelda [
    | dx dy vecinas |

    dx := #(-1 0 1 -1 1 -1 0 1).
    dy := #(-1 -1 -1 0 0 1 1 1).
    vecinas := OrderedCollection new.

    1 to: dx size do: [ :i |
        | filaVecina columnaVecina |
        filaVecina := unaCelda fila + (dy at: i).
        columnaVecina := unaCelda columna + (dx at: i).

        ((filaVecina between: 1 and: filas) and: [
            columnaVecina between: 1 and: columnas ]) ifTrue: [
                vecinas add: ((celdas at: filaVecina) at: columnaVecina) ] ].

    ^ vecinas asArray
]
