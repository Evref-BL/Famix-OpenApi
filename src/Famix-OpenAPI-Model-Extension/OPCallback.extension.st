Extension { #name : 'OPCallback' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPCallback >> collectDeclaringOpenApisInto: aCollection visited: visitedEntities [
	"Add to aCollection the documents declaring the receiver. The path items and callbacks already in visitedEntities are skipped, so that cycles of shared callbacks end."

	(visitedEntities includes: self) ifTrue: [ ^ self ].
	visitedEntities add: self.
	self components ifNotNil: [ :reusableObjects |
		self addDeclaringOpenApi: reusableObjects openApi to: aCollection ].
	self usedByOperations do: [ :each |
		each
			collectDeclaringOpenApisInto: aCollection
			visited: visitedEntities ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPCallback >> declaringOpenApi [
	"Answer the first OpenAPI document declaring the receiver, or nil when the receiver is not attached to a document. See #declaringOpenApis."

	^ self declaringOpenApis
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :documents | documents first ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPCallback >> declaringOpenApis [
	"Answer the distinct OpenAPI documents declaring the receiver: the one owning it as a reusable callback, then the ones of the operations using it. Answer an empty collection when the receiver is not attached to a document."

	| documents |
	documents := OrderedCollection new.
	self collectDeclaringOpenApisInto: documents visited: IdentitySet new.
	^ documents
]
