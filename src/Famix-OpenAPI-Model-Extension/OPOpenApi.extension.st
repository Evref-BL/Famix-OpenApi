Extension { #name : 'OPOpenApi' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOpenApi >> operations [
	"Answer all the operations of the path items of the receiver (webhook operations are not included)."

	^ self paths
		  flatCollect: [ :each | each operations ]
		  as: OrderedCollection
]
