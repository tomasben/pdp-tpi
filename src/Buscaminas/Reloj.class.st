"
Cuenta el tiempo transcurrido de una partida. Solo mide, no conoce el juego ni la interfaz.
Tiene diferentes estados:
Reloj Iniciar/reiniciar
Reloj Pausar
Reloj Terminado
"
Class {
	#name : 'Reloj',
	#superclass : 'Object',
	#instVars : [
		'inicio',
		'acumulado',
		'estado'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'actions' }
Reloj >> iniciar [
	"Arranca desde cero."
	self reiniciar.
	inicio := DateAndTime now.
	estado := #corriendo
]

{ #category : 'initialization' }
Reloj >> initialize [
	super initialize.
	self reiniciar
	
]

{ #category : 'actions' }
Reloj >> pausar [
	"Congela el tiempo. Solo tiene efecto si el reloj está corriendo."
	estado = #corriendo ifFalse: [ ^ self ].
	acumulado := self tiempoTranscurrido.
	estado := #pausado
	
]

{ #category : 'actions' }
Reloj >> reanudar [
	"Continúa contando. Solo tiene efecto si el reloj está pausado."
	estado = #pausado ifFalse: [ ^ self ].
	inicio := DateAndTime now.
	estado := #corriendo
]

{ #category : 'actions' }
Reloj >> reiniciar [
	"Vuelve a cero y queda detenido."
	acumulado := Duration zero.
	inicio := nil.
	estado := #detenido
]

{ #category : 'actions' }
Reloj >> terminar [
	"Congela el tiempo final. Después solo se puede reiniciar o iniciar de nuevo."
	(#(corriendo pausado) includes: estado) ifFalse: [ ^ self ].
	self pausar.
	estado := #terminado
]

{ #category : 'accessing' }
Reloj >> tiempoFormateado [
	"Devuelve el tiempo como texto HH:MM:SS, por ejemplo '00:02:35'."
	| segundos |
	segundos := self tiempoTranscurrido asSeconds.
	^ (segundos // 3600 printPaddedWith: $0 to: 2), ':',
		(segundos \\ 3600 // 60 printPaddedWith: $0 to: 2), ':',
		(segundos \\ 60 printPaddedWith: $0 to: 2)
]

{ #category : 'accessing' }
Reloj >> tiempoTranscurrido [
	^ estado = #corriendo
		ifTrue: [ acumulado + (DateAndTime now - inicio) ]
		ifFalse: [ acumulado ]
]
