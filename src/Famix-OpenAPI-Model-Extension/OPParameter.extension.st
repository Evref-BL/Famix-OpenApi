Extension { #name : 'OPParameter' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPParameter >> allowEmplyValue [
	"Deprecated alias (typo) of #allowEmptyValue, kept for one cycle."

	^ self allowEmptyValue
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPParameter >> allowEmplyValue: aBoolean [
	"Deprecated alias (typo) of #allowEmptyValue:, kept for one cycle."

	self allowEmptyValue: aBoolean
]
