"
The entities of a Swagger 2 document that are neither nodes nor schemas (verified by import experiments): the OPComponents at #/components when the root has definitions, parameters, responses or securityDefinitions (rule swagger2Components); one OPMediaType per media type of a response that has a schema, at <response>/content/<mime> (rule swagger2MediaType; the media types are the produces of the nearest operation that has a non-empty list, else those of the root, else */*; a response without schema, or whose schema is not an object or is an unresolved $ref, has none); the same for the first body parameter of an operation (inline or $ref) with the consumes at <parameter>/content/<mime>; and for an operation without body parameter whose formData parameters make a request body: the OPRequestBody at <operation>/requestBody and its media types (rule swagger2FormDataRequestBody; the form media types among the consumes, else multipart/form-data when a parameter is a file, else application/x-www-form-urlencoded). A media type listed twice gives two entities at the same pointer, as the importer does.
"
Class {
	#name : 'FamixOpenApiSwagger2Content',
	#superclass : 'Object',
	#instVars : [
		'driver',
		'parameters'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiSwagger2Content class >> dataComponentKeys [
	"The root keys of a Swagger 2 document that make the importer build the components"

	^ #( 'definitions' 'parameters' 'responses' 'securityDefinitions' )
]

{ #category : 'instance creation' }
FamixOpenApiSwagger2Content class >> dataDefaultMimeTypes [
	"The media types the importer uses when neither the operation nor the root declare any"

	^ #( '*/*' )
]

{ #category : 'instance creation' }
FamixOpenApiSwagger2Content class >> dataFileFormMimeTypes [
	"The form media type when none is declared and a parameter is a file"

	^ #( 'multipart/form-data' )
]

{ #category : 'instance creation' }
FamixOpenApiSwagger2Content class >> dataFormMimeTypes [
	"The media types of a form"

	^ #( 'multipart/form-data' 'application/x-www-form-urlencoded' )
]

{ #category : 'instance creation' }
FamixOpenApiSwagger2Content class >> dataPlainFormMimeTypes [
	"The form media type when none is declared and no parameter is a file"

	^ #( 'application/x-www-form-urlencoded' )
]

{ #category : 'instance creation' }
FamixOpenApiSwagger2Content class >> on: aSyntheticExpectations [

	^ self new
		  driver: aSyntheticExpectations;
		  yourself
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> addMediaType: aMime to: anOwnerNode [

	driver
		add: 'OPMediaType'
		at: (self contentPointerOf: anOwnerNode pointer mime: aMime)
		rule: #swagger2MediaType
		origin: anOwnerNode
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> contentPointerOf: anOwnerPointer mime: aMime [

	^ FamixOpenApiSourceNode
		  pointerOf:
		  (FamixOpenApiSourceNode pointerOf: anOwnerPointer child: 'content')
		  child: aMime
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> declaringNodeOf: aKey for: anOperationOrNil [

	^ ({
		   anOperationOrNil.
		   (driver expandedInventory nodeAt:
			    FamixOpenApiSourceNode rootPointer) } reject: #isNil)
		  detect: [ :each | self hasList: aKey in: each ]
		  ifNone: [ nil ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> derive [

	driver expandedInventory version = #v2 ifFalse: [ ^ self ].
	self deriveComponents.
	(driver eligibleNodesOf: 'Response') do: [ :each |
		self deriveResponseMediaTypesOf: each ].
	(driver eligibleNodesOf: 'Operation') do: [ :each |
		self deriveRequestBodyOf: each ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> deriveBodyMediaTypesOf: aBodyParameter operation: anOperation [
	"The media types of the first body parameter: when it is a $ref, the schema of its target is a node below the $ref (FamixOpenApiSwagger2Schemas)"

	(self yieldsSchema: (self schemaNodeOf: aBodyParameter)) ifFalse: [
		^ self ].
	(self mimesFor: 'consumes' in: anOperation) do: [ :mime |
		self addMediaType: mime to: aBodyParameter ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> deriveComponents [
	"Swagger 2 has no components: the importer builds an empty one when the root has definitions, parameters, responses or securityDefinitions (whatever their value)"

	| root |
	root := driver expandedInventory nodeAt:
		        FamixOpenApiSourceNode rootPointer.
	(self class dataComponentKeys anySatisfy: [ :each |
		 root includesKey: each ]) ifFalse: [ ^ self ].
	driver
		add: 'OPComponents'
		at: '#/components'
		rule: #swagger2Components
		origin: root
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> deriveFormBodyOf: anOperation [

	| forms body |
	forms := parameters formsIn: anOperation.
	forms ifEmpty: [ ^ self ].
	body := FamixOpenApiSourceNode
		        pointerOf: anOperation pointer
		        child: 'requestBody'.
	driver
		add: 'OPRequestBody'
		at: body
		rule: #swagger2FormDataRequestBody
		origin: anOperation.
	(self formMimesOf: anOperation forms: forms) do: [ :mime |
		driver
			add: 'OPMediaType'
			at: (self contentPointerOf: body mime: mime)
			rule: #swagger2FormDataRequestBody
			origin: anOperation ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> deriveRequestBodyOf: anOperation [
	"The first body parameter gives the media types of the request body (consumes); without body parameter the formData parameters make a form request body"

	(driver nodeExpectation firstBodyParameterOf:
		 anOperation pointer , '/parameters')
		ifNil: [ self deriveFormBodyOf: anOperation ]
		ifNotNil: [ :body |
		self deriveBodyMediaTypesOf: body operation: anOperation ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> deriveResponseMediaTypesOf: aResponse [
	"One media type per produces entry of a response that has a schema"

	(self yieldsSchema: (self schemaNodeOf: aResponse)) ifFalse: [
		^ self ].
	(self mimesFor: 'produces' in: (self operationOf: aResponse)) do: [
		:mime | self addMediaType: mime to: aResponse ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> driver: aSyntheticExpectations [

	driver := aSyntheticExpectations.
	parameters := FamixOpenApiSwagger2Parameters
		              inventory: driver expandedInventory
		              expectation: driver nodeExpectation
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> formMimesOf: anOperation forms: aCollection [
	"The form media types of the consumes; without any, multipart/form-data for a form with a file, else application/x-www-form-urlencoded"

	| declared |
	declared := (self mimesFor: 'consumes' in: anOperation) select: [
		            :each | self class dataFormMimeTypes includes: each ].
	declared ifNotEmpty: [ ^ declared ].
	^ (aCollection anySatisfy: [ :each | (each valueAt: 'type') = 'file' ])
		  ifTrue: [ self class dataFileFormMimeTypes ]
		  ifFalse: [ self class dataPlainFormMimeTypes ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> hasList: aKey in: aNode [
	"True when the node holds a non-empty list at aKey"

	| value |
	value := aNode valueAt: aKey.
	^ value isArray and: [ value isNotEmpty ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> mimesFor: aKey in: anOperationOrNil [
	"The media types of produces or consumes (aKey): the list of the operation, else the one of the root, when it is not empty; else the default ones"

	^ (self declaringNodeOf: aKey for: anOperationOrNil)
		  ifNil: [ self class dataDefaultMimeTypes ]
		  ifNotNil: [ :node | (node valueAt: aKey) select: #isString ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> operationOf: aNode [
	"The nearest operation above aNode, nil when there is none (a response of the root responses)"

	^ (driver expandedInventory ancestorsOf: aNode)
		  detect: [ :each | each specObject = 'Operation' ]
		  ifNone: [ nil ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> schemaNodeOf: anOwnerNode [
	"The node of the schema of a response or a body parameter, nil when it has none"

	^ driver expandedInventory
		  nodeAt:
		  (FamixOpenApiSourceNode
			   pointerOf: anOwnerNode pointer
			   child: 'schema')
		  ifAbsent: [ nil ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Content >> yieldsSchema: aSchemaNode [
	"True when the importer builds a schema from the node, so that the media types exist: an object that is not an unresolved $ref"

	^ aSchemaNode isNotNil and: [
		  aSchemaNode value isDictionary and: [
			  aSchemaNode referenceText isNil or: [
				  driver nodeExpectation isResolved: aSchemaNode ] ] ]
]
