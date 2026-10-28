Extension { #name : 'OPOperation' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> allParameters [
	"Answer the parameters of the receiver plus the parameters of its path. A parameter of the operation overrides a path parameter with the same name and location."

	| ownParameters |
	ownParameters := self parameters asOrderedCollection.
	self path ifNil: [ ^ ownParameters ].
	^ ownParameters , (self path parameters reject: [ :pathParameter |
		   ownParameters anySatisfy: [ :each |
			   each name = pathParameter name and: [ each location = pathParameter location ] ] ])
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> effectiveSecurity [
	"Answer the security requirements that apply to the receiver, as alternatives. The answer is empty when the receiver disables the security (#securityDisabled). Otherwise it is made of the requirements of the receiver when it declares some, else of the ones of its document (empty when the receiver is not attached to a document)."

	| document |
	self securityDisabled ifTrue: [ ^ #(  ) ].
	self securityRequirements ifNotEmpty: [ :own | ^ own ].
	document := self declaringOpenApi.
	document ifNil: [ ^ #(  ) ].
	^ document securityRequirements
]
