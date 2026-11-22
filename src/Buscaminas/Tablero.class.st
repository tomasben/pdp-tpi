"
Representa el tablero de juego

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
Tablero class >> dificultadDificil [
	^ self filas: 16 columnas: 30 cantidadMinas: 99 
]

{ #category : 'instance creation' }
Tablero class >> dificultadFacil [
	^ self filas: 9 columnas: 9 cantidadMinas: 10
]

{ #category : 'instance creation' }
Tablero class >> dificultadMedia [
	^ self filas: 16 columnas: 16 cantidadMinas: 40
	
]

{ #category : 'instance creation' }
Tablero class >> filas: numeroFilas columnas: numeroColumnas cantidadMinas: numeroMinas [

	^ self new filas: numeroFilas columnas: numeroColumnas cantidadMinas: numeroMinas.
]

{ #category : 'accessing' }
Tablero >> cantidadCeldasSegurasPorDescubrir [
	"Devuelve el número de celdas sin mina que faltan por descubrir."

	^ celdas sum: [ :fila | fila count: [ :celda | celda tieneMina not and: celda estaDescubierta not ] ]
]

{ #category : 'configuration' }
Tablero >> cantidadMinas: cantidad [
	"Regenera la grilla con la cantidad de minas indicada y calcula las minas vecinas de cada celda."

	| totalCeldas |
	totalCeldas := filas * columnas.
	cantidad isInteger ifFalse: [ self error: 'La cantidad de minas debe ser un número entero' ].

	(cantidad >= 0 and: cantidad <= totalCeldas) ifFalse: [
		self error: 'La cantidad de minas debe estar entre 0 y ' , totalCeldas asString , ', inclusive' ].

	celdas := self grillaConMinas: cantidad.
	celdas do: [ :fila |
		fila do: [ :celda |
			celda cantidadMinasVecinas: (self cantidadMinasVecinasDe: celda)
		].
	].

	^ self
]

{ #category : 'private' }
Tablero >> cantidadMinasVecinasDe: unaCelda [
	^ (self vecinasDe: unaCelda) count: [ :vecina | vecina tieneMina ]
]

{ #category : 'accessing' }
Tablero >> celdaEnFila: numeroFila columna: numeroColumna [
	((numeroFila between: 1 and: filas) and: [
		 numeroColumna between: 1 and: columnas ]) ifFalse: [
		self error: 'La posición está fuera del tablero' ].

	^ (celdas at: numeroFila) at: numeroColumna
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
Tablero >> descubrirCeldaEnFila: numeroFila columna: numeroColumna [

	| celda pendientes |
	celda := self celdaEnFila: numeroFila columna: numeroColumna.
	(celda estaDescubierta or: [ celda estaMarcada ]) ifTrue: [ ^ celda ].

	pendientes := OrderedCollection with: celda.
	[ pendientes isEmpty ] whileFalse: [
			| actual |
			actual := pendientes removeFirst.
			actual descubrir.

		(actual tieneMina not and: [ actual cantidadMinasVecinas = 0 ])
    		ifTrue: [
        		pendientes addAll: ((self vecinasDe: actual) reject: [ :vecina |
            	vecina estaDescubierta or: [
            		vecina estaMarcada or: [ pendientes includes: vecina ] ] ]) ].
	].

	^ celda
]

{ #category : 'accessing' }
Tablero >> filas [
	^ filas
]

{ #category : 'initialization' }
Tablero >> filas: numeroFilas columnas: numeroColumnas cantidadMinas: numeroMinas [
	"Establece las dimensiones del Tablero cuando se inicializa"

	filas := numeroFilas.
	columnas := numeroColumnas.
	self cantidadMinas: numeroMinas
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

{ #category : 'testing' }
Tablero >> todasLasCeldasSinMina [
	^ celdas allSatisfy: [ :filaDeCeldas |
			  filaDeCeldas allSatisfy: [ :celda |
					  celda tieneMina or: [ celda estaDescubierta ] ] ]
]

{ #category : 'private' }
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
