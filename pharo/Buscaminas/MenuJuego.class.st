Class {
	#name : 'MenuJuego',
	#superclass : 'Morph',
	#instVars : [
		'ventana'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'instance creation' }
MenuJuego class >> abrir [
	^ self new abrirVentana
]

{ #category : 'actions' }
MenuJuego >> abrirVentana [

	| tamaño |
	
	tamaño := 576 @ 384.
	self
		extent: tamaño;
		color: Color black;
		borderWidth: 0.
		
	self agregarTitulo.
	self agregarBotones.

	ventana := SystemWindow new.
	ventana setLabel: 'Buscaminas'.
	ventana addMorph: self frame: (0 @ 0 corner: 1 @ 1).
	ventana openInWorld.
	ventana extent: tamaño + (ventana extent - self extent).
	ventana center: ventana world center.
	ventana fullBounds
]

{ #category : 'private' }
MenuJuego >> agregarBotones [

	| fuente |
	fuente := LogicalFont familyName: 'Press Start 2P' pointSize: 16.
	#( #( facil 'FACIL' ) #( medio 'MEDIO' ) #( dificil 'DIFICIL' ) ) withIndexDo: [ :opcion :indice |
			| boton |
			boton := SimpleButtonMorph new.
			boton
				label: opcion second font: fuente;
				extent: 228 @ 40;
				center: self position + (288 @ (202 + (indice - 1 * 46)));
				color: Color transparent;
				borderWidth: 0;
				target: self;
				actionSelector: #iniciarPartidaConNivel:;
				arguments: { opcion first }.

			boton submorphs first color: Color white.
			self addMorph: boton ]
]

{ #category : 'private' }
MenuJuego >> agregarTitulo [

	| titulo |
	titulo := StringMorph contents: 'BUSCAMINAS' font: (LogicalFont familyName: 'Press Start 2P' pointSize: 24).
	titulo
		color: Color white;
		center: self position + (288 @ 108).
		
	self addMorph: titulo
]

{ #category : 'actions' }
MenuJuego >> iniciarPartidaConNivel: unNivel [

	| partida tableroMorph |
	
	partida := Partida nivel: unNivel.
	
	tableroMorph := TableroMorph new.
	tableroMorph configurarConPartida: partida.
	tableroMorph abrirVentana.
	
	ventana ifNotNil: [ ventana delete ]
]
