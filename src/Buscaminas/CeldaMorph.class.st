Class {
	#name : 'CeldaMorph',
	#superclass : 'Morph',
	#instVars : [
		'fila',
		'columna',
		'juego'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'initialization' }
CeldaMorph >> configurarFila: unaFila columna: unaColumna [
fila:= unaFila.
columna:= unaColumna.
self extent: 30@30. 
self color: Color lightGray. 
self borderWidth: 1.
self borderColor: Color black.
]

{ #category : 'event handling' }
CeldaMorph >> handlesMouseDown: anEvent [
    ^ true
]

{ #category : 'event handling' }
CeldaMorph >> mouseDown: anEvent [
    anEvent redButtonPressed
        ifTrue: [ self color: Color yellow ].

    anEvent yellowButtonPressed
        ifTrue: [ self color: Color red ].
]
