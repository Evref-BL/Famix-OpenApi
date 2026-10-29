Class {
	#name : 'FamixOpenApiPathVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#instVars : [
		'activeReferences'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> addPathItemNamed: anExpression from: aNode at: aPointer to: aCallback [

	| path |
	path := self
		        callbackPathItemNamed: anExpression
		        from: aNode
		        at: aPointer.
	(aCallback pathItems includes: path) ifFalse: [
		aCallback addPathItem: path ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> callbackNamed: aKey from: aNode at: aPointer [
	"Answer the Callback aKey: the shared target when aNode is a reference (nil when it cannot be resolved), a new Callback otherwise."

	| callback |
	(self isReferenceNode: aNode) ifTrue: [
		^ self sharedTargetOf: aNode at: aPointer expecting: OPCallback ].
	callback := self newEntity: OPCallback named: aKey pointer: aPointer.
	self fillCallback: callback from: aNode at: aPointer.
	^ callback
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> callbackPathItemNamed: anExpression from: aNode at: aPointer [
	"Answer the Path of the callback expression: the entity already registered when aNode is a reference to one, a new Path otherwise (a reference that designates no entity yet is read again here)."

	| path |
	(self isReferenceNode: aNode) ifTrue: [
		path := context
			        resolveQuietly: (aNode at: '$ref')
			        at: aPointer
			        expecting: OPPath.
		path ifNotNil: [ ^ path ] ].
	path := self newPathNamed: anExpression at: aPointer.
	self fillPathItem: path from: aNode at: aPointer.
	^ path
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> cloneInto: aPath from: aReferenceNode at: aPointer [
	"Read at aPointer the path item designated by the reference aReferenceNode (its siblings override it in OpenAPI 3.1)."

	| ref target |
	ref := aReferenceNode at: '$ref'.
	aPath ref: ref.
	(activeReferences includes: ref) ifTrue: [
		^ self diagnostics
			  error: #refCycle
			  pointer: aPointer
			  message: 'Path item reference cycle through ' , ref printString ].
	target := self referencedNodeFor: ref at: aPointer.
	target ifNil: [ ^ self ].
	activeReferences add: ref.
	[
	self
		fillPathItemContent: aPath
		from: (self node: aReferenceNode overriding: target at: aPointer)
		at: aPointer ] ensure: [ activeReferences removeLast ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillCallback: aCallback from: aNode at: aPointer [
	"Fill aCallback, created empty, from aNode: every key that is not an extension is an expression whose value is a path item."

	aCallback extensions:
		(self extensionsOf: aNode known: aNode keys at: aPointer).
	aNode keysAndValuesDo: [ :expression :node |
		| pointer |
		(self specVersion isExtensionKey: expression) ifFalse: [
			pointer := self pointer: aPointer appending: expression.
			node isDictionary
				ifTrue: [
					self
						guard: [
							self
								addPathItemNamed: expression
								from: node
								at: pointer
								to: aCallback ]
						at: pointer ]
				ifFalse: [
				context wrongNodeAt: pointer expecting: 'an object' found: node ] ] ].
	context
		recordSourceTextOf: aCallback
		from: aNode
		category: (self sourceCategoryOf: aCallback)
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillCallbacksOf: anOperation from: aNode at: aPointer [
	"Add to anOperation the Callbacks of the callbacks object of aNode (shared when they are references)."

	self
		entriesAt: 'callbacks'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			(self callbackNamed: key from: node at: pointer) ifNotNil: [
				:callback |
				(anOperation callbacks includes: callback) ifFalse: [
					anOperation addCallback: callback ] ] ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillOperation: anOperation from: aNode at: aPointer [
	"Fill anOperation, created with its verb, from aNode."

	| operationId |
	operationId := self stringAt: 'operationId' in: aNode at: aPointer.
	anOperation
		operationId: operationId;
		name: (operationId ifNil: [
					 self synthesizedNameFor: anOperation at: aPointer ]);
		summary: (self stringAt: 'summary' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		deprecated: (self booleanAt: 'deprecated' in: aNode at: aPointer);
		tagNames: (self tagNamesIn: aNode at: aPointer);
		externalDocs: (self externalDocsIn: aNode at: aPointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known: self operationKeys
				 extra: self swagger2ExtensionKeys
				 unmodelled: #(  )
				 at: aPointer).
	self fillServersOf: anOperation from: aNode at: aPointer.
	self parameterVisitor
		addParametersTo: anOperation
		from: aNode
		at: aPointer.
	self fillRequestBodyOf: anOperation from: aNode at: aPointer.
	self responseVisitor
		fillResponsesOf: anOperation
		from: aNode
		at: aPointer.
	self fillCallbacksOf: anOperation from: aNode at: aPointer.
	self securityVisitor
		fillSecurityOfOperation: anOperation
		from: aNode
		at: aPointer.
	context
		recordSourceTextOf: anOperation
		from: aNode
		category: #operation
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillPathItem: aPath from: aNode at: aPointer [
	"Fill aPath, created empty at aPointer, from the path item aNode. When aNode is a reference the referenced path item is read again at aPointer, so that the operations belong to aPath, and aPath keeps the reference in its ref."

	(self isReferenceNode: aNode)
		ifTrue: [ self cloneInto: aPath from: aNode at: aPointer ]
		ifFalse: [ self fillPathItemContent: aPath from: aNode at: aPointer ].
	context recordSourceTextOf: aPath from: aNode category: #pathItem
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillPathItemContent: aPath from: aNode at: aPointer [
	"Fill aPath from the path item aNode that has no reference: attributes, servers, parameters and operations (in the order of the document)."

	aPath
		summary: (self stringAt: 'summary' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		extensions:
			(self extensionsOf: aNode known: self pathItemKeys at: aPointer).
	self fillServersOf: aPath from: aNode at: aPointer.
	self parameterVisitor addParametersTo: aPath from: aNode at: aPointer.
	aNode keysAndValuesDo: [ :key :value |
		(self verbs includes: key) ifTrue: [
			self
				visitOperation: key
				node: value
				of: aPath
				at: (self pointer: aPointer appending: key) ] ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillRequestBodyOf: anOperation from: aNode at: aPointer [

	| node |
	self specVersion isSwagger2 ifTrue: [
		^ self
			  fillSwagger2RequestBodyOf: anOperation
			  from: aNode
			  at: aPointer ].
	node := self dictionaryAt: 'requestBody' in: aNode at: aPointer.
	node ifNil: [ ^ self ].
	anOperation requestBody: (self contentVisitor
			 requestBodyIn: node
			 at: (self pointer: aPointer appending: 'requestBody'))
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> fillSwagger2RequestBodyOf: anOperation from: aNode at: aPointer [
	"Swagger 2 has no requestBody: the in body parameter of aNode is the request body of anOperation, with the pointer of the parameter and the consumes media types. Without body parameter, the formData parameters build a form request body. The body wins over the formData parameters, and the body parameters after the first one are ignored: both are reported."

	| bodies forms |
	bodies := self parameterVisitor
		          swagger2ParametersLocated: 'body'
		          in: aNode
		          at: aPointer.
	forms := self parameterVisitor
		         swagger2ParametersLocated: 'formData'
		         in: aNode
		         at: aPointer.
	bodies size > 1 ifTrue: [
		bodies allButFirst do: [ :each |
			self diagnostics
				warning: #extraBodyParameter
				pointer: each key
				message:
				'Only the first body parameter is the request body: this one is ignored' ] ].
	bodies ifNotEmpty: [
		forms ifNotEmpty: [
			self diagnostics
				info: #conflictingBodyAndFormData
				pointer: aPointer
				message:
				'The operation has body and formData parameters: the formData parameters are ignored' ].
		anOperation requestBody: (self
				 swagger2RequestBodyFrom: bodies first value
				 at: bodies first key
				 operation: aNode).
		^ self ].
	forms ifNotEmpty: [
		anOperation requestBody: (self
				 swagger2FormRequestBodyFrom: (forms collect: #value)
				 at: (self pointer: aPointer appending: 'requestBody')
				 operation: aNode) ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> formMediaTypesFor: anOperationNode hasFile: aBoolean [
	"Answer the form media types of the consumes of anOperationNode (multipart/form-data and application/x-www-form-urlencoded); when it has none, multipart/form-data if a parameter is a file, else application/x-www-form-urlencoded."

	| forms |
	forms := (self mediaTypesFor: 'consumes' in: anOperationNode)
		         select: [ :each |
			         #( 'multipart/form-data' 'application/x-www-form-urlencoded' )
				         includes: each ].
	forms ifNotEmpty: [ ^ forms ].
	^ aBoolean
		  ifTrue: [ #( 'multipart/form-data' ) ]
		  ifFalse: [ #( 'application/x-www-form-urlencoded' ) ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> initialize [

	super initialize.
	activeReferences := OrderedCollection new
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> newPathNamed: aKey at: aPointer [

	^ (self newEntity: OPPath named: aKey pointer: aPointer)
		  relativePath: aKey;
		  yourself
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> node: aReferenceNode overriding: aTargetNode at: aPointer [
	"Answer the node read for a reference with siblings: the siblings win in OpenAPI 3.1 and are ignored (reported) before."

	| merged |
	aReferenceNode size = 1 ifTrue: [ ^ aTargetNode ].
	self specVersion isOpenApi31 ifFalse: [
		self diagnostics
			info: #refSiblingsIgnored
			pointer: aPointer
			message: 'Keys next to $ref are ignored: '
				, (aReferenceNode keys copyWithout: '$ref') asArray printString.
		^ aTargetNode ].
	merged := aTargetNode copy.
	aReferenceNode keysAndValuesDo: [ :key :value |
		key = '$ref' ifFalse: [ merged at: key put: value ] ].
	^ merged
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> operationKeys [

	^ #( 'tags' 'summary' 'description' 'externalDocs' 'operationId'
	     'parameters' 'requestBody' 'responses' 'callbacks' 'deprecated'
	     'security' 'servers' )
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> pathItemKeys [

	^ #( '$ref' 'summary' 'description' 'servers' 'parameters' )
	  , self verbs
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> reportDuplicateOperationIds [
	"Report a duplicateOperationId warning for each operationId shared by several Operations of the model (all are kept)."

	| byId |
	byId := OrderedDictionary new.
	(self model allWithType: OPOperation) do: [ :each |
		each operationId ifNotNil: [ :id |
			(byId at: id ifAbsentPut: [ OrderedCollection new ]) add: each ] ].
	byId keysAndValuesDo: [ :id :operations |
		operations size > 1 ifTrue: [
			self diagnostics
				warning: #operationIdDuplicate
				pointer: operations first canonicalPointer
				message: 'operationId ' , id printString , ' is used by '
					, (', ' join: (operations collect: #canonicalPointer)) ] ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> swagger2ExtensionKeys [
	"Answer the keys that only Swagger 2 operations have and that are kept in the extensions."

	^ self specVersion isSwagger2
		  ifTrue: [ #( 'consumes' 'produces' 'schemes' ) ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> swagger2FormRequestBodyFrom: aCollection at: aPointer operation: anOperationNode [
	"Answer a new RequestBody at aPointer (synthetic: the document has none) whose schema is made of the formData parameters aCollection (nodes), for each form media type consumed by anOperationNode. It is required when one of the parameters is."

	| body schemaNode |
	body := self newEntity: OPRequestBody named: nil pointer: aPointer.
	schemaNode := self parameterVisitor swagger2FormSchemaNodeFor:
		              aCollection.
	body required: (schemaNode at: 'required') isEmpty not.
	self contentVisitor
		fillSwagger2ContentOf: body
		from: (Dictionary with: 'schema' -> schemaNode)
		mediaTypes: (self
				 formMediaTypesFor: anOperationNode
				 hasFile: (aCollection anySatisfy: [ :each |
						  (each at: 'type' ifAbsent: [ nil ]) = 'file' ]))
		at: aPointer.
	^ body
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> swagger2RequestBodyFrom: aParameterNode at: aPointer operation: anOperationNode [
	"Answer a new RequestBody described by the body parameter aParameterNode located at aPointer, its content being its schema for each media type consumed by anOperationNode."

	| body |
	body := self newEntity: OPRequestBody named: nil pointer: aPointer.
	body
		description:
			(self stringAt: 'description' in: aParameterNode at: aPointer);
		required:
			(self booleanAt: 'required' in: aParameterNode at: aPointer);
		extensions: (self
				 extensionsOf: aParameterNode
				 known: #( 'name' 'in' 'required' 'description' 'schema' )
				 at: aPointer).
	self contentVisitor
		fillSwagger2ContentOf: body
		from: aParameterNode
		mediaTypes: (self mediaTypesFor: 'consumes' in: anOperationNode)
		at: aPointer.
	context
		recordSourceTextOf: body
		from: aParameterNode
		category: (self sourceCategoryOf: body).
	^ body
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> synthesizedNameFor: anOperation at: aPointer [
	"Answer a name for the operation that has no operationId, and report it."

	| name |
	name := FamixOpenApiNaming
		        synthesizedOperationNameFor: anOperation httpMethod
		        path: (anOperation path
				         ifNotNil: [ :path |
				         path relativePath ifNil: [ path name ifNil: [ '' ] ] ]
				         ifNil: [ '' ]).
	self diagnostics
		warning: #operationIdMissing
		pointer: aPointer
		message: 'Operation without operationId; named ' , name printString.
	^ name
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> tagNamesIn: aNode at: aPointer [

	| tags |
	tags := self listAt: 'tags' in: aNode at: aPointer.
	^ (tags ifNil: [ #(  ) ]) asArray select: #isString
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> verbs [

	^ #( 'get' 'put' 'post' 'delete' 'options' 'head' 'patch' 'trace' )
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> visitOperation: aVerb node: aNode of: aPath at: aPointer [
	"Create the Operation of aVerb at aPointer in aPath and fill it. One failing operation does not stop the others."

	aNode isDictionary ifFalse: [
		^ context wrongNodeAt: aPointer expecting: 'an object' found: aNode ].
	self
		guard: [
			| operation |
			operation := self
				             newEntity: OPOperation
				             named: nil
				             pointer: aPointer.
			aPath addOperation: operation.
			operation httpMethod: aVerb.
			self fillOperation: operation from: aNode at: aPointer ]
		at: aPointer
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> visitPaths [
	"Read the paths of the document: one Path per entry of the paths object, with its operations."

	self
		fixedEntriesAt: 'paths'
		in: self json
		at: '#'
		do: [ :key :node :pointer |
			| path |
			path := self newPathNamed: key at: pointer.
			self openApi addPath: path.
			self fillPathItem: path from: node at: pointer ]
]

{ #category : 'visiting' }
FamixOpenApiPathVisitor >> visitWebhooks [
	"Read the webhooks of the document (OpenAPI 3.1): one Path per entry of the webhooks object."

	self
		fixedEntriesAt: 'webhooks'
		in: self json
		at: '#'
		do: [ :key :node :pointer |
			| path |
			path := self newPathNamed: key at: pointer.
			self openApi addWebhook: path.
			self fillPathItem: path from: node at: pointer ]
]
