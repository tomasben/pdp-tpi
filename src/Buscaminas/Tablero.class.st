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
Tablero class >> constructorDificil [

|nuevoTablero|
nuevoTablero := self filas: 16  columnas: 30. 
nuevoTablero cantidadMinas: 99.
^nuevoTablero
]

{ #category : 'instance creation' }
Tablero class >> constructorFacil [
|nuevoTablero|
nuevoTablero := self filas: 9  columnas: 9. 
nuevoTablero cantidadMinas: 10.
^nuevoTablero
]

{ #category : 'instance creation' }
Tablero class >> constructorMedio [

|nuevoTablero|
nuevoTablero := self filas: 16  columnas: 16. 
nuevoTablero cantidadMinas: 40.
^nuevoTablero
]

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
		actual cantidadMinasVecinas: (self cantidadMinasVecinasDe: actual).

		(actual tieneMina not and: [ actual cantidadMinasVecinas = 0 ])
			ifTrue: [
				(self vecinasDe: actual) do: [ :vecina |
					(vecina estaDescubierta or: [
						 vecina estaMarcada or: [ pendientes includes: vecina ] ])
						ifFalse: [ pendientes add: vecina ] ] ] ].

	^ celda
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

{ #category : 'testing' }
Tablero >> todasLasCeldasSinMina [
	^ celdas allSatisfy: [ :filaDeCeldas |
			  filaDeCeldas allSatisfy: [ :celda |
					  celda tieneMina or: [ celda estaDescubierta ] ] ]
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
