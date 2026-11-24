"
Iconos de Buscaminas como PNG de 24 x 24. Cada Form se decodifica al primer uso y se comparte entre las celdas.
"
Class {
	#name : 'IconosBuscaminas',
	#superclass : 'Object',
	#classInstVars : [
		'bandera',
		'bomba'
	],
	#category : 'Buscaminas',
	#package : 'Buscaminas'
}

{ #category : 'accessing' }
IconosBuscaminas class >> bandera [

	^ bandera ifNil: [ bandera := PNGReadWriter formFromStream: self datosBandera base64Decoded readStream ]
]

{ #category : 'accessing' }
IconosBuscaminas class >> bomba [

	^ bomba ifNil: [ bomba := PNGReadWriter formFromStream: self datosBomba base64Decoded readStream ]
]

{ #category : 'private' }
IconosBuscaminas class >> datosBandera [

	^ 'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA3ElEQVR4XmNABgkJCfUTJkzoPnDg
wC8g/k8qPnTo0D6QGQYGBibI5jIABeyABu8nx1BcOD4+PhhuAbUNh2Ggw+3BwUKM4nMTJ/y/k5wA
x8RawtDf399NjEKQoT/YGOGYaAvwRSiygeiYFAv+090CfAZTxQJYRA7dIEL3CQi/MjGgvgXUSqYk
5U4GRgYwHvkW0M8CYGEINxQbJssCkKEwDCxy8VqArBZY7BNnAT4DCVmGYRawmttLUwuwVThUtQBU
QdOiugRhYJxsBtfJwAo6iAaG70dvWdhT3eVAAADVZyUUS8hkhQAAAABJRU5ErkJggg=='
]

{ #category : 'private' }
IconosBuscaminas class >> datosBomba [

	^ 'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAABXUlEQVR4XmMY+WDkg8ED1nBw1FHb
TPvsQLU/phoif0oVWPb+DmHctyWaaW8WGxt1LIpzUf7DyMCwT12Kd1+KCd/fPxMY//7dwvR3pRL7
HkrNrmNmYtybE6z5F+QLkIAJM7P9QzXOP2tV2PfmsLGT7QN7M1PLv2Ii4n/jY1L+KsmrgizYD7PE
DGgJReEtIy37d8qkmX8T4pL+Gumb/OXnFfgrKiQGsuQPzBKyAT+/4J+ujr6/f//8/VeYX/rXUM/0
r6yk/D9ZKbm/fLz8IEsoi1glBZW/xQXlf12dPP86O3j+1VDR+isrBbQAaAkvN99fdjb2eooskBCT
/Gtlbv/XQNfkr7qKJshwkA/AQcTHw/+Pl4evntKUs1dGQu6vnDQ4WIAul/snJiLxl42VjTpBBAT6
bKzse8EuBhoIDRYgzQsyfCoQ21Il5wLxL7DBPBALgPyfQCwy8gvKkQ9oCwDiVXK4KiIG7wAAAABJ
RU5ErkJggg=='
]
