Extension { #name : 'OPTag' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPTag >> anApi [
	"Deprecated alias of #openApi (former name of the opposite of OpenApi>>tags), kept for one cycle."

	^ self openApi
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPTag >> anApi: anOpenApi [
	"Deprecated alias of #openApi: (former name of the opposite of OpenApi>>tags), kept for one cycle."

	self openApi: anOpenApi
]
