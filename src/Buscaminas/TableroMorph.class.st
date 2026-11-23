Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'tablero',
		'tamanoCelda',
		'partida',
		'tituloMorph',
		'minasMorph',
		'relojMorph'
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

{ #category : 'actions' }
TableroMorph >> actualizar [
	"Refleja en pantalla el estado logico de todas las celdas y se fija si son celdas morph."
    self submorphs do: [ :elemento |
        (elemento isKindOf: CeldaMorph)
            ifTrue: [ elemento actualizar ]
    ].
]

{ #category : 'initialization' }
TableroMorph >> agregarPanelInformacion [

    | panelMinas panelReloj fuente fuenteChica
      textoMinas textoReloj |

    fuente := LogicalFont
        familyName: 'Press Start 2P'
        pointSize: 14.

    fuenteChica := LogicalFont
        familyName: 'Press Start 2P'
        pointSize: 9.

    "Panel de minas"
    panelMinas := Morph new.
    panelMinas
        extent: 210@55;
        color: Color black;
        borderWidth: 1;
        borderColor: Color white.

    panelMinas center: (self width // 4) @ 115.
    self addMorph: panelMinas.

    "Panel del reloj"
    panelReloj := Morph new.
    panelReloj
        extent: 250@55;
        color: Color black;
        borderWidth: 1;
        borderColor: Color white.

    panelReloj center: (self width * 3 // 4) @ 115.
    self addMorph: panelReloj.

    "Textos"
    textoMinas := StringMorph
        contents: 'MINAS'
        font: fuenteChica.

    minasMorph := StringMorph
        contents: partida tablero cantidadMinas printString
        font: fuente.

    textoReloj := StringMorph
        contents: 'TIEMPO'
        font: fuenteChica.

    relojMorph := StringMorph
        contents: '00:00:00'
        font: fuente.

    "Colores"
    textoMinas color: Color white.
    minasMorph color: Color white.
    textoReloj color: Color white.
    relojMorph color: Color white.

    "Agregar textos a sus paneles"
    panelMinas addMorph: textoMinas.
    panelMinas addMorph: minasMorph.

    panelReloj addMorph: textoReloj.
    panelReloj addMorph: relojMorph.

    "Centrar textos dentro de los paneles"

textoMinas center:
    panelMinas position + ((panelMinas width // 2) @ 14).

minasMorph center:
    panelMinas position + ((panelMinas width // 2) @ 40).

textoReloj center:
    panelReloj position + ((panelReloj width // 2) @ 14).

relojMorph center:
    panelReloj position + ((panelReloj width // 2) @ 40).
]

{ #category : 'initialization' }
TableroMorph >> agregarTituloTablero [

    | fuente |

    fuente := LogicalFont
        familyName: 'Press Start 2P'
        pointSize: 24.

    tituloMorph := StringMorph
        contents: 'BUSCAMINAS'
        font: fuente.

    tituloMorph color: Color white.

    tituloMorph center:
        self position + ((self width // 2) @ 45).

    self addMorph: tituloMorph.
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
    tamanoCelda := 30.

    self dibujarTablero.
]

{ #category : 'initialization' }
TableroMorph >> dibujarTablero [

    | celdaVisual anchoTablero altoTablero
      anchoVentana altoVentana origenX origenY |

    self removeAllMorphs.

    anchoTablero := tablero columnas * tamanoCelda.
    altoTablero := tablero filas * tamanoCelda.

    anchoVentana := (anchoTablero + 60) max: 576.
    altoVentana := altoTablero + 200.

    self
        extent: anchoVentana @ altoVentana;
        color: Color black;
        borderWidth: 0.

    "Agregar título y paneles"
    self agregarTituloTablero.
    self agregarPanelInformacion.

    "Centrar horizontalmente la cuadrícula"
    origenX := (anchoVentana - anchoTablero) // 2.
    origenY := 175.

    "Dibujar las celdas"
    1 to: tablero filas do: [ :numeroFila |
        1 to: tablero columnas do: [ :numeroColumna |

            celdaVisual := CeldaMorph new.

            celdaVisual
                configurarFila: numeroFila
                columna: numeroColumna.

            celdaVisual juego: partida.

            celdaVisual position:
                (origenX + ((numeroColumna - 1) * tamanoCelda))
                @
                (origenY + ((numeroFila - 1) * tamanoCelda)).

            self addMorph: celdaVisual.
        ].
    ].
]

{ #category : 'accessing' }
TableroMorph >> partida [
	^ partida
]

{ #category : 'stepping and presenter' }
TableroMorph >> step [

    relojMorph ifNotNil: [
        relojMorph contents: partida reloj tiempoFormateado.
    ].
]

{ #category : 'stepping and presenter' }
TableroMorph >> wantsSteps [
    ^ true
]
