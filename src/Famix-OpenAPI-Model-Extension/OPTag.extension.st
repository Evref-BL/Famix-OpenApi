Extension { #name : 'OPTag' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPTag >> anApi [
	"Deprecated alias of #api (old opposite name), kept for one cycle."

	^ self api
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPTag >> anApi: anApi [
	"Deprecated alias of #api: (old opposite name), kept for one cycle."

	self api: anApi
]
