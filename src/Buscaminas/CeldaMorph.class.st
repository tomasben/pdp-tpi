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
