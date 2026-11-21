Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'tablero',
		'tamanoCelda'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'initialization' }
TableroMorph >> abrirVentana [ 
|ventana| 
ventana:= SystemWindow new. 
ventana setLabel: 'Buscaminas'. 
ventana extent: 400@400. 
ventana addMorph: self frame: (0@0 corner: 1@1).
ventana openInWorld. 
]
