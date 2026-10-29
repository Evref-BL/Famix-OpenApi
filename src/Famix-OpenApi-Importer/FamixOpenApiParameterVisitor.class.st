Class {
	#name : 'FamixOpenApiParameterVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> addParametersTo: anOwner from: aNode at: aPointer [
	"Add to anOwner (a Path or an Operation) the Parameters of the parameters array of aNode: the shared target for a reference, a new Parameter otherwise. A Parameter is added once. In Swagger 2 the body and formData parameters are not Parameters: they build the request body of the operation."

	self
		elementsAt: 'parameters'
		in: aNode
		at: aPointer
		do: [ :node :pointer |
			(self isSwagger2RequestBodyParameter: node) ifFalse: [
				(self parameterIn: node at: pointer) ifNotNil: [ :parameter |
					(anOwner parameters includes: parameter) ifFalse: [
						anOwner addParameter: parameter ] ] ] ]
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> fillComponentParameter: aParameter from: aNode at: aPointer [
	"Fill aParameter, a component created with the key as name: its name is the one of the JSON."

	(self stringAt: 'name' in: aNode at: aPointer) ifNotNil: [ :name |
		aParameter name: name ].
	self fillParameter: aParameter from: aNode at: aPointer
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> fillParameter: aParameter from: aNode at: aPointer [
	"Fill aParameter, created with its name, from aNode: attributes, schema, content, examples and extensions."

	| inline |
	inline := self isInlineSwagger2Parameter: aNode.
	aParameter
		location: (self stringAt: 'in' in: aNode at: aPointer);
		required: (self booleanAt: 'required' in: aNode at: aPointer);
		deprecated: (self booleanAt: 'deprecated' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		allowEmptyValue:
			(self booleanAt: 'allowEmptyValue' in: aNode at: aPointer);
		style: (self stringAt: 'style' in: aNode at: aPointer);
		explode: (self booleanAt: 'explode' in: aNode at: aPointer);
		allowReserved:
			(self booleanAt: 'allowReserved' in: aNode at: aPointer);
		schema: (inline
				 ifTrue: [ self inlineSchemaIn: aNode at: aPointer ]
				 ifFalse: [ self schemaIn: aNode at: aPointer ]).
	inline ifTrue: [
		self fillStyleAndExplodeOf: aParameter from: aNode at: aPointer ].
	aParameter extensions: (context
			 extensionsTextOf: aNode
			 known: (inline
					  ifTrue: [
					  self knownKeys , self specVersion parameterSchemaKeys ]
					  ifFalse: [ self knownKeys ])
			 extra: (inline
					  ifTrue: [ #( 'collectionFormat' ) ]
					  ifFalse: [ self laterStepKeys ])
			 unmodelled: #(  )
			 at: aPointer).
	self contentVisitor
		fillContentOf: aParameter
		from: aNode
		at: aPointer.
	self contentVisitor
		fillExamplesOf: aParameter
		from: aNode
		at: aPointer.
	context
		recordSourceTextOf: aParameter
		from: aNode
		category: (self sourceCategoryOf: aParameter)
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> fillStyleAndExplodeOf: aParameter from: aNode at: aPointer [
	"Derive the style and the explode of aParameter from the collectionFormat of aNode, when they have an OpenAPI 3 equivalent."

	| derived |
	(self stringAt: 'collectionFormat' in: aNode at: aPointer) ifNotNil: [
		:format |
		derived := self specVersion
			           styleAndExplodeFor: format
			           in: aParameter location.
		derived ifNotNil: [
			aParameter style: derived first.
			aParameter explode: derived second ] ]
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> inlineSchemaIn: aNode at: aPointer [
	"Answer the Schema built from the schema keys that a Swagger 2 inline parameter (aNode, located at aPointer) has directly in its node, or nil when there is none."

	| schemaNode |
	schemaNode := self schemaNodeOf: aNode.
	schemaNode ifEmpty: [ ^ nil ].
	^ self
		  schemaFrom: schemaNode
		  at: (self pointer: aPointer appending: 'schema')
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> isInlineSwagger2Parameter: aNode [
	"Answer whether aNode is a Swagger 2 parameter that describes its schema itself (type, items...): neither a body nor a formData one."

	| location |
	self specVersion isSwagger2 ifFalse: [ ^ false ].
	aNode isDictionary ifFalse: [ ^ false ].
	location := aNode at: 'in' ifAbsent: [ ^ false ].
	^ (location = 'body' or: [ location = 'formData' ]) not
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> isSwagger2RequestBodyParameter: aNode [
	"Answer whether aNode is, in Swagger 2, a body or a formData parameter: not a Parameter but a part of the request body."

	| location |
	self specVersion isSwagger2 ifFalse: [ ^ false ].
	location := self swagger2LocationOf: aNode.
	^ location = 'body' or: [ location = 'formData' ]
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> knownKeys [

	^ #( 'name' 'in' 'required' 'deprecated' 'description' 'allowEmptyValue'
	     'style' 'explode' 'allowReserved' 'schema' 'content' 'examples'
	     'example' )
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> laterStepKeys [
	"Answer the keys that only Swagger 2 parameters have: they are kept in the extensions until step C reads them."

	^ self specVersion isSwagger2
		  ifTrue: [ #( 'type' 'format' 'items' 'collectionFormat' ) ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> parameterIn: aNode at: aPointer [
	"Answer the Parameter described by aNode: the shared target when it is a reference (nil when it cannot be resolved), a new Parameter otherwise."

	| parameter |
	(self isReferenceNode: aNode) ifTrue: [
		^ self sharedTargetOf: aNode at: aPointer expecting: OPParameter ].
	parameter := self
		             newEntity: OPParameter
		             named: (self stringAt: 'name' in: aNode at: aPointer)
		             pointer: aPointer.
	self fillParameter: parameter from: aNode at: aPointer.
	^ parameter
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> schemaNodeOf: aNode [
	"Answer a node with the keys of aNode that describe the schema of a Swagger 2 inline parameter."

	| schemaNode |
	schemaNode := OrderedDictionary new.
	self specVersion parameterSchemaKeys do: [ :key |
		aNode at: key ifPresent: [ :value | schemaNode at: key put: value ] ].
	^ schemaNode
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> swagger2BodyParameterIn: anOperationNode at: aPointer do: aBlock [
	"Evaluate the two arguments block aBlock with the effective node (references followed) and the pointer, in the document, of the first body parameter of anOperationNode located at aPointer. Does nothing when there is none."

	(self
		 swagger2ParametersLocated: 'body'
		 in: anOperationNode
		 at: aPointer) ifNotEmpty: [ :found |
		aBlock value: found first value value: found first key ]
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> swagger2FormSchemaNodeFor: aCollection [
	"Answer the schema node (type object) whose properties are the formData parameters, the nodes of aCollection: each is described by its schema keys and its description, a file being a binary string. The required ones are listed in required."

	| properties required |
	properties := OrderedDictionary new.
	required := OrderedCollection new.
	aCollection do: [ :node |
		| name |
		name := node at: 'name' ifAbsent: [ nil ].
		name isString ifTrue: [
			| property |
			property := self schemaNodeOf: node.
			(property at: 'type' ifAbsent: [ nil ]) = 'file' ifTrue: [
				property
					at: 'type' put: 'string';
					at: 'format' put: 'binary' ].
			node
				at: 'description'
				ifPresent: [ :text | property at: 'description' put: text ].
			properties at: name put: property.
			(node at: 'required' ifAbsent: [ false ]) == true ifTrue: [
				required add: name ] ] ].
	^ OrderedDictionary new
		  at: 'type' put: 'object';
		  at: 'properties' put: properties;
		  at: 'required' put: required asArray;
		  yourself
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> swagger2LocationOf: aNode [
	"Answer the in of the effective node of aNode, the node itself or the one its references designate, or nil when there is none. Nothing is reported here: an unresolved reference is reported when the parameter is read."

	| node visited |
	node := aNode.
	visited := Set new.
	[ self isReferenceNode: node ] whileTrue: [
		| reference |
		reference := node at: '$ref'.
		(visited includes: reference) ifTrue: [ ^ nil ].
		visited add: reference.
		node := FamixOpenApiJsonPointer
			        resolveReference: reference
			        in: self json.
		node == FamixOpenApiJsonPointer notFound ifTrue: [ ^ nil ] ].
	node isDictionary ifFalse: [ ^ nil ].
	^ node at: 'in' ifAbsent: [ nil ]
]

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> swagger2ParametersLocated: aLocation in: anOperationNode at: aPointer [
	"Answer the associations pointer -> effective node (references followed) of the parameters of anOperationNode (located at aPointer) whose in is aLocation, in document order. Unresolved references are left out."

	| found |
	found := OrderedCollection new.
	self
		elementsAt: 'parameters'
		in: anOperationNode
		at: aPointer
		do: [ :node :pointer |
			(self swagger2LocationOf: node) = aLocation ifTrue: [
				| effective |
				effective := (self isReferenceNode: node)
					             ifTrue: [
					             self
						             referencedNodeFor: (node at: '$ref')
						             at: pointer ]
					             ifFalse: [ node ].
				effective ifNotNil: [ found add: pointer -> effective ] ] ].
	^ found
]
