Extension { #name : 'OPSchema' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalProperties [
	"Deprecated alias (typo) of #additionalProperties, kept for one cycle."

	^ self additionalProperties
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalProperties: aSchema [
	"Deprecated alias (typo) of #additionalProperties:, kept for one cycle."

	self additionalProperties: aSchema
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalPropertiesAllowed [
	"Deprecated alias (typo) of #additionalPropertiesAllowed, kept for one cycle."

	^ self additionalPropertiesAllowed
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalPropertiesAllowed: aBoolean [
	"Deprecated alias (typo) of #additionalPropertiesAllowed:, kept for one cycle."

	self additionalPropertiesAllowed: aBoolean
]
