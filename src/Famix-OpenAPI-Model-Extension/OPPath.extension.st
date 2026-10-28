Extension { #name : 'OPPath' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPPath >> declaringOpenApi [
	"Answer the OpenAPI document declaring the receiver, as a path, a webhook, a reusable path item or a callback path item. Answer nil when the receiver is not attached to a document."

	self openApi ifNotNil: [ :document | ^ document ].
	self webhookOf ifNotNil: [ :document | ^ document ].
	self components ifNotNil: [ :reusableObjects |
		^ reusableObjects openApi ].
	^ self callback ifNotNil: [ :aCallback | aCallback declaringOpenApi ]
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
