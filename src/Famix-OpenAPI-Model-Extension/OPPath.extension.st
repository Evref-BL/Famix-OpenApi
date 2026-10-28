Extension { #name : 'OPPath' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> collectDeclaringOpenApisInto: aCollection visited: visitedEntities [
	"Add to aCollection the documents declaring the receiver. The path items and callbacks already in visitedEntities are skipped, so that cycles of shared callbacks end."

	(visitedEntities includes: self) ifTrue: [ ^ self ].
	visitedEntities add: self.
	self addDeclaringOpenApi: self openApi to: aCollection.
	self addDeclaringOpenApi: self webhookOf to: aCollection.
	self components ifNotNil: [ :reusableObjects |
		self addDeclaringOpenApi: reusableObjects openApi to: aCollection ].
	self usedByCallbacks do: [ :each |
		each
			collectDeclaringOpenApisInto: aCollection
			visited: visitedEntities ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> declaringOpenApi [
	"Answer the first OpenAPI document declaring the receiver, or nil when the receiver is not attached to a document. See #declaringOpenApis."

	^ self declaringOpenApis
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :documents | documents first ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> declaringOpenApis [
	"Answer the distinct OpenAPI documents declaring the receiver, as a path, a webhook, a reusable path item, or a path item shared by callbacks (then the documents declaring these callbacks, found through their components or their operations). The documents declaring the receiver directly come first. Answer an empty collection when the receiver is not attached to a document."

	| documents |
	documents := OrderedCollection new.
	self collectDeclaringOpenApisInto: documents visited: IdentitySet new.
	^ documents
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> delete [
	"Answer the operation declared with the DELETE method, or nil."

	^ self operationForHttpMethod: 'delete'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> get [
	"Answer the operation declared with the GET method, or nil."

	^ self operationForHttpMethod: 'get'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> head [
	"Answer the operation declared with the HEAD method, or nil."

	^ self operationForHttpMethod: 'head'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> operationForHttpMethod: anHttpMethod [
	"Answer the operation of the receiver declared for anHttpMethod (lowercase: 'get', 'put', ...) or nil."

	^ self operations
		  detect: [ :each | each httpMethod = anHttpMethod ]
		  ifNone: [ nil ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> options [
	"Answer the operation declared with the OPTIONS method, or nil."

	^ self operationForHttpMethod: 'options'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> patch [
	"Answer the operation declared with the PATCH method, or nil."

	^ self operationForHttpMethod: 'patch'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> post [
	"Answer the operation declared with the POST method, or nil."

	^ self operationForHttpMethod: 'post'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> put [
	"Answer the operation declared with the PUT method, or nil."

	^ self operationForHttpMethod: 'put'
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> trace [
	"Answer the operation declared with the TRACE method, or nil."

	^ self operationForHttpMethod: 'trace'
]
