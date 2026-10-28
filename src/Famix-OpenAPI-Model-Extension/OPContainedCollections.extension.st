Extension { #name : 'OPContainedCollections' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPContainedCollections >> addParamter: aParameter [
	"Deprecated alias (typo) of #addParameter:, kept for one cycle."

	^ self addParameter: aParameter
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPContainedCollections >> paramters [
	"Deprecated alias (typo) of #parameters, kept for one cycle."

	^ self parameters
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPContainedCollections >> paramters: aCollection [
	"Deprecated alias (typo) of #parameters:, kept for one cycle."

	self parameters: aCollection
]
