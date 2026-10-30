"
The schemas that a Swagger 2 document gives without having them as nodes, made nodes of the expanded inventory of FamixOpenApiSyntheticExpectations so that the schema rules apply to them (verified by import experiments): (1) the type, format, items... of a typed (inline) parameter make a schema at <parameter>/schema (rule swagger2ParameterSchema), with the schemas below it (items, and anything an items object holds); (2) the first body parameter of an operation that is a $ref gives a request body at the site, whose schema is read again from the target at <site>/schema (rule swagger2ParameterSchema; an inline body parameter has its schema as a node); (3) the formData parameters of an operation without body parameter make a schema at <operation>/requestBody/schema with one property per parameter name (rule swagger2FormDataRequestBody). Only for Swagger 2.
"
Class {
	#name : 'FamixOpenApiSwagger2Schemas',
	#superclass : 'Object',
	#instVars : [
		'driver',
		'parameters'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiSwagger2Schemas class >> on: aSyntheticExpectations [

	^ self new
		  driver: aSyntheticExpectations;
		  yourself
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Schemas >> addFormSchemaOf: anOperation [
	"The schema of the form request body of an operation without body parameter"

	| forms |
	(driver nodeExpectation firstBodyParameterOf:
		 anOperation pointer , '/parameters') ifNotNil: [ ^ self ].
	forms := parameters formsIn: anOperation.
	forms ifEmpty: [ ^ self ].
	driver
		addSchemaValue: (self formSchemaFrom: forms)
		at: (FamixOpenApiSourceNode
				 pointerOf: (FamixOpenApiSourceNode
						  pointerOf: anOperation pointer
						  child: 'requestBody')
				 child: 'schema')
		rule: #swagger2FormDataRequestBody
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Schemas >> addReferencedBodySchemaOf: aReference [
	"A $ref to the body parameter that is the request body of its operation: the schema of the target is read again below the site"

	| schema |
	((driver expandedInventory siteSpecObjectOf: aReference)
	 = 'Parameter' and: [
		 driver nodeExpectation isFirstBodyParameter: aReference ])
		ifFalse: [ ^ self ].
	schema := (driver nodeExpectation chainTargetOf: aReference)
		          valueAt: 'schema'.
	schema isDictionary ifFalse: [ ^ self ].
	driver
		addSchemaValue: schema
		at:
		(FamixOpenApiSourceNode
			 pointerOf: aReference pointer
			 child: 'schema')
		rule: #swagger2ParameterSchema
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Schemas >> addSchemaNodes [
	"Add to the expanded inventory the nodes of the schemas the importer builds from other keys (Swagger 2 only)"

	driver expandedInventory version = #v2 ifFalse: [ ^ self ].
	(driver eligibleNodesOf: 'Parameter') do: [ :each |
		self addTypedSchemaOf: each ].
	(driver eligibleNodesOf: 'Reference') do: [ :each |
		self addReferencedBodySchemaOf: each ].
	(driver eligibleNodesOf: 'Operation') do: [ :each |
		self addFormSchemaOf: each ]
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Schemas >> addTypedSchemaOf: aParameter [
	"The schema of a typed parameter: its type, format, items... (nothing when it holds none of them)"

	| value |
	(parameters isInline: aParameter) ifFalse: [ ^ self ].
	value := parameters schemaValueOf: aParameter.
	value isEmpty ifTrue: [ ^ self ].
	driver
		addSchemaValue: value
		at:
		(FamixOpenApiSourceNode
			 pointerOf: aParameter pointer
			 child: 'schema')
		rule: #swagger2ParameterSchema
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Schemas >> driver: aSyntheticExpectations [

	driver := aSyntheticExpectations.
	parameters := FamixOpenApiSwagger2Parameters
		              inventory: driver expandedInventory
		              expectation: driver nodeExpectation
]

{ #category : 'deriving' }
FamixOpenApiSwagger2Schemas >> formSchemaFrom: aCollection [
	"The schema of the form: an object with one property per named formData parameter (the later one wins), described by the schema keys of the parameter"

	| properties |
	properties := OrderedDictionary new.
	aCollection do: [ :each |
		(each valueAt: 'name') isString ifTrue: [
			properties
				at: (each valueAt: 'name')
				put: (parameters schemaValueOf: each) ] ].
	^ OrderedDictionary new
		  at: 'type' put: 'object';
		  at: 'properties' put: properties;
		  yourself
]
