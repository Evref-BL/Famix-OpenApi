Extension { #name : 'OPSecurityRequirement' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSecurityRequirement >> schemes [
	"Answer the security schemes that the items of the receiver require together (logical AND)."

	^ self items collect: [ :each | each scheme ]
]
