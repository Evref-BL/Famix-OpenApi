"
What the importer decides about the parameters of a Swagger 2 operation (verified by import experiments): the effective node of a parameter is the one at the end of its chain of $ref (an unresolved one is left out); its location is its `in`; the body parameters and the formData parameters of an OPERATION (not of a path item, not of '#/parameters') make the request body; a parameter is inline (typed: its type, format, items... make a schema) when it has an `in` that is neither body nor formData. The data method #dataSchemaKeys lists the keys of a typed parameter that the importer copies in its schema (a copy of the list of FamixOpenApiSwagger2Version>>parameterSchemaKeys: the validation does not depend on the importer; a test compares both).
"
Class {
	#name : 'FamixOpenApiSwagger2Parameters',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'expectation'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiSwagger2Parameters class >> dataSchemaKeys [
	"The keys of a typed parameter that the importer copies in its schema, in its order"

	^ #( 'type' 'format' 'items' 'default' 'enum' 'maximum' 'exclusiveMaximum'
	     'minimum' 'exclusiveMinimum' 'maxLength' 'minLength' 'pattern'
	     'maxItems' 'minItems' 'uniqueItems' 'multipleOf' )
]

{ #category : 'instance creation' }
FamixOpenApiSwagger2Parameters class >> inventory: anInventory expectation: aNodeExpectation [

	^ self new
		  inventory: anInventory expectation: aNodeExpectation;
		  yourself
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> effectiveNodeOf: aNode [
	"The parameter itself, or the one at the end of its chain of $ref (nil when it is unresolved)"

	^ aNode isReference
		  ifTrue: [ expectation chainTargetOf: aNode ]
		  ifFalse: [ aNode ]
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> formsIn: anOperation [
	"The effective nodes of the formData parameters of an operation, in document order"

	^ (self parametersIn: anOperation)
		  select: [ :each | (self locationOf: each) = 'formData' ]
		  thenCollect: [ :each | self effectiveNodeOf: each ]
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> inventory: anInventory expectation: aNodeExpectation [

	inventory := anInventory.
	expectation := aNodeExpectation
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> isInline: aParameterNode [
	"A typed parameter: an object with an `in` that is neither body nor formData"

	^ aParameterNode value isDictionary and: [
		  (aParameterNode includesKey: 'in') and: [
			  (#( 'body' 'formData' ) includes: (aParameterNode valueAt: 'in'))
				  not ] ]
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> locationOf: aNode [
	"The `in` of the effective node of aNode, nil when there is none"

	^ (self effectiveNodeOf: aNode) ifNotNil: [ :effective |
		  effective valueAt: 'in' ]
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> parametersIn: anOperation [
	"The nodes of the parameters of an operation, in document order"

	^ inventory childrenOf: anOperation pointer , '/parameters'
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Parameters >> schemaValueOf: aParameterNode [
	"The schema a typed parameter makes: the keys of its schema that it holds, in the order of dataSchemaKeys (empty when it holds none)"

	| schema |
	schema := OrderedDictionary new.
	self class dataSchemaKeys do: [ :key |
		aParameterNode value
			at: key
			ifPresent: [ :each | schema at: key put: each ] ].
	^ schema
]
