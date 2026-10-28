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
		schema: (self schemaIn: aNode at: aPointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known: self knownKeys
				 extra: self laterStepKeys
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
