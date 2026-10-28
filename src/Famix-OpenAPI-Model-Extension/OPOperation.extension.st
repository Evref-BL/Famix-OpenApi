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
OPOperation >> collectDeclaringOpenApisInto: aCollection visited: visitedEntities [
	"Add to aCollection the documents declaring the path item of the receiver."

	self path ifNotNil: [ :aPath |
		aPath
			collectDeclaringOpenApisInto: aCollection
			visited: visitedEntities ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> declaringOpenApi [
	"Answer the OpenAPI document declaring the receiver through its path item, or nil when the receiver has no path item."

	^ self path ifNotNil: [ :aPath | aPath declaringOpenApi ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> declaringOpenApis [
	"Answer the distinct OpenAPI documents declaring the receiver through its path item. Answer an empty collection when the receiver has no path item. See OPPath>>#declaringOpenApis."

	| documents |
	documents := OrderedCollection new.
	self collectDeclaringOpenApisInto: documents visited: IdentitySet new.
	^ documents
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> effectiveParameters [
	"Answer the parameters that apply to the receiver: its own parameters followed by the parameters of its path item. A parameter of the operation overrides a path parameter with the same name and location."

	| ownParameters |
	ownParameters := self parameters asOrderedCollection.
	self path ifNil: [ ^ ownParameters ].
	^ ownParameters , (self path parameters reject: [ :pathParameter |
		   ownParameters anySatisfy: [ :each |
			   each name = pathParameter name and: [
				   each location = pathParameter location ] ] ])
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

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> tags [
	"Answer the Tag entities named by #tagNames, in the order of #tagNames. A name that is not declared by the document is skipped; the answer is empty when the receiver is not attached to a document."

	| document |
	document := self declaringOpenApi.
	document ifNil: [ ^ #(  ) ].
	^ self tagNames
		  flatCollect: [ :tagName |
		  document tags select: [ :tag | tag name = tagName ] ]
		  as: OrderedCollection
]
