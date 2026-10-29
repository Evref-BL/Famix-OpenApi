Class {
	#name : 'FamixOpenApiParameterVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiParameterVisitor >> addParametersTo: anOwner from: aNode at: aPointer [
	"Add to anOwner (a Path or an Operation) the Parameters of the parameters array of aNode: the shared target for a reference, a new Parameter otherwise. A Parameter is added once."

	self
		elementsAt: 'parameters'
		in: aNode
		at: aPointer
		do: [ :node :pointer |
			(self parameterIn: node at: pointer) ifNotNil: [ :parameter |
				(anOwner parameters includes: parameter) ifFalse: [
					anOwner addParameter: parameter ] ] ]
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
