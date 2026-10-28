Extension { #name : 'OPCallback' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPCallback >> declaringOpenApi [
	"Answer the OpenAPI document declaring the receiver, as a reusable callback or as an inline callback of an operation. Answer nil when the receiver is not attached to a document."

	self operation ifNotNil: [ :anOperation |
		^ anOperation declaringOpenApi ].
	^ self components ifNotNil: [ :reusableObjects |
		  reusableObjects openApi ]
]
