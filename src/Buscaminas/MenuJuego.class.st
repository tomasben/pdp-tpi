Class {
	#name : 'MenuJuego',
	#superclass : 'Morph',
	#instVars : [
		'dificultadJuego',
		'botonFacil',
		'botonMedio',
		'botonDificil'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'initialization' }
MenuJuego >> Dificil [

	Transcript
		show: 'Seleccionaste Dificil';
		newLine
]

{ #category : 'initialization' }
MenuJuego >> Facil [

	Transcript
		show: 'Seleccionaste Facil';
		newLine
]

{ #category : 'initialization' }
MenuJuego >> Medio [
	Transcript show: 'Seleccionaste Medio'; cr

]

{ #category : 'initialization' }
MenuJuego >> agregarBotones [

	"1. Creamos e inicializamos las variables de los botones"
	self crearBotonFacil.
	self crearBotonMedio.
	self crearBotonDificil.

	"2. Los agregamos directamente al Morph principal (self)"
	self addMorphBack: botonFacil .
	self addMorphBack: botonMedio.
	self addMorphBack: botonDificil.

]

{ #category : 'initialization' }
MenuJuego >> agregarTitulo [
| titulo subtitulo|

titulo:= StringMorph new. 
titulo contents: 'BUSCAMINAS'.
titulo color: Color black .
titulo position: 100@10.

self addMorph: titulo.

subtitulo:= StringMorph new.
subtitulo contents:'Seleccione la dificultad'.
subtitulo color: Color black .
subtitulo position: 80@40.

self addMorph: subtitulo. 

]

{ #category : 'initialization' }
MenuJuego >> crearBotonDificil [


botonDificil := SimpleButtonMorph new.
botonDificil label: 'Dificil'.
botonDificil submorphs first color: Color black.
botonDificil position: 190@80. 
botonDificil color: Color red.

botonDificil 
	target:self;
	actionSelector: #Dificil.
]

{ #category : 'initialization' }
MenuJuego >> crearBotonFacil [

botonFacil:= SimpleButtonMorph new.
botonFacil label: 'Facil'.
botonFacil submorphs first color: Color black.
botonFacil position: 60@80.
botonFacil color: Color green.

botonFacil
	target:self;
	actionSelector: #Facil.
]

{ #category : 'initialization' }
MenuJuego >> crearBotonMedio [

botonMedio := SimpleButtonMorph new.
botonMedio label: 'Medio'.
botonMedio submorphs first color: Color black.
botonMedio position: 120@80.
botonMedio color: Color yellow.

botonMedio
	target:self;
	actionSelector: #Medio. 
]

{ #category : 'initialization' }
MenuJuego >> iniciar [

	| ventana |
	self
		extent: 300@200;
		color: Color lightGray.
        
	self agregarTitulo.
	self agregarBotones.
    
	ventana := SystemWindow new.
	ventana setLabel: 'Buscaminas'.
	ventana addMorph: self frame: (0@0 corner: 1@1).
	ventana openInWorld.

]
