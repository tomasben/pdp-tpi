Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'tablero',
		'tamanoCelda',
		'partida'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'initialization' }
TableroMorph >> abrirVentana [ 
|ventana| 
ventana:= SystemWindow new. 
ventana setLabel: 'Buscaminas'. 
ventana extent: self extent + (0@25).
ventana addMorph: self frame: (0@0 corner: 1@1).
ventana openInWorld. 
]

{ #category : 'initialization' }
TableroMorph >> configurarConPartida: unaPartida [
	"Asocia la partida al morph y dibuja el tablero de esa partida."

	partida := unaPartida.
	self configurarConTablero: unaPartida tablero
]

{ #category : 'initialization' }
TableroMorph >> configurarConTablero: unTablero [

    tablero := unTablero.
    self dibujarTablero.
]

{ #category : 'initialization' }
TableroMorph >> dibujarTablero [

    | celdaVisual |

    1 to: tablero filas do: [ :numeroFila |

        1 to: tablero columnas do: [ :numeroColumna |

            celdaVisual := CeldaMorph new.

            celdaVisual configurarFila: numeroFila
                columna: numeroColumna.

            celdaVisual position:
                ((numeroColumna - 1) * 30)
                @
                ((numeroFila - 1) * 30).

            self addMorph: celdaVisual.
        ].
    ].

    self extent:
        (tablero columnas * 30) @ (tablero filas * 30).
]

{ #category : 'accessing' }
TableroMorph >> partida [
	^ partida
]
