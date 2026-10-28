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
