"
Superpone un fondo negro con una abertura circular que se cierra en el centro.
"
Class {
	#name : 'CierreCircularMorph',
	#superclass : 'Morph',
	#instVars : [
		'inicio',
		'progreso',
		'alTerminar'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'initialization' }
CierreCircularMorph >> alTerminar: unBloque [

	alTerminar := unBloque.
	inicio := Time millisecondClockValue
]

{ #category : 'drawing' }
CierreCircularMorph >> dibujarMitadEn: unCanvas radio: radio direccion: direccion [

	| centro semiancho altura puntos |
	centro := self bounds center.
	semiancho := (self width / 2) max: radio + 1.
	altura := ((self height / 2) max: radio + 1) * direccion.
	puntos := OrderedCollection
		          with: centro + (semiancho negated @ 0)
		          with: centro + (semiancho negated @ altura)
		          with: centro + (semiancho @ altura)
		          with: centro + (semiancho @ 0).
	0 to: 24 do: [ :segmento |
		| angulo |
		angulo := Float pi * segmento / 24.
		puntos add: (centro + ((radio * angulo cos) @ (radio * angulo sin * direccion))) rounded ].

	unCanvas drawPolygon: puntos color: Color black borderWidth: 0 borderColor: Color transparent
]

{ #category : 'drawing' }
CierreCircularMorph >> drawOn: unCanvas [

	| radio |
	progreso = 0.0 ifTrue: [ ^ self ].
	progreso = 1.0 ifTrue: [
		^ unCanvas fillRectangle: self bounds color: Color black ].

	radio := self bounds extent r / 2 * (1.0 - progreso).
	unCanvas clipBy: self bounds during: [ :canvasRecortado |
		self dibujarMitadEn: canvasRecortado radio: radio direccion: -1.
		self dibujarMitadEn: canvasRecortado radio: radio direccion: 1 ]
]

{ #category : 'event handling' }
CierreCircularMorph >> handlesMouseDown: anEvent [

	^ true
]

{ #category : 'initialization' }
CierreCircularMorph >> initialize [

	super initialize.
	self color: Color transparent.
	progreso := 0.0
]

{ #category : 'stepping' }
CierreCircularMorph >> step [

	progreso = 1.0 ifTrue: [
		self stopStepping.
		^ alTerminar value ].

	self bounds: self owner bounds.
	progreso := ((Time millisecondsSince: inicio) / 350.0) min: 1.0.
	self changed
]

{ #category : 'stepping' }
CierreCircularMorph >> stepTime [

	^ 16
]

{ #category : 'stepping' }
CierreCircularMorph >> wantsSteps [

	^ alTerminar isNotNil
]
