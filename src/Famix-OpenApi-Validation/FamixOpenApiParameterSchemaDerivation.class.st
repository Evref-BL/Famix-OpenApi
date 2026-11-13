"
Derivation #parameterSchema, for the schema of a parameter. In OpenAPI 3 and for a Swagger 2 parameter without `in` or with a body or formData one, it is the derivation #children of the key `schema`. A Swagger 2 parameter that HAS an `in` other than body and formData is a typed (inline) parameter, whatever the value of its `in`: a text the importer does not know ('text'), a number, null, a list, an object, a $ref that is not a text (VERIFIED by import experiments; a value that is not a text is also reported as wrongNodeType at the `in`). The importer ignores its `schema` key and makes the schema of its type, format, items... at <parameter>/schema (FamixOpenApiSwagger2Parameters), none when it holds none of them.
"
Class {
	#name : 'FamixOpenApiParameterSchemaDerivation',
	#superclass : 'FamixOpenApiChildrenDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiParameterSchemaDerivation >> isTypedParameter: aNode in: aCheck [
	"True for a Swagger 2 parameter that has an `in` other than body and formData (the value does not matter): the importer makes its schema of its type, format, items..."

	^ aNode version = #v2 and: [
		  (self parametersIn: aCheck) isInline: aNode ]
]

{ #category : 'deriving' }
FamixOpenApiParameterSchemaDerivation >> parametersIn: aCheck [
	"What the importer decides about the parameters of Swagger 2"

	^ FamixOpenApiSwagger2Parameters
		  inventory: aCheck expandedInventory
		  expectation: aCheck nodeExpectation
]

{ #category : 'deriving' }
FamixOpenApiParameterSchemaDerivation >> targetsOf: anOwner in: aCheck [
	"The schema of the type of a typed parameter (the schema node it has at <parameter>/schema, none when it holds no type, format, items...), else the schema child"

	| parameters |
	(self isTypedParameter: anOwner node in: aCheck) ifFalse: [
		^ super targetsOf: anOwner in: aCheck ].
	parameters := self parametersIn: aCheck.
	^ (parameters schemaValueOf: anOwner node) isEmpty
		  ifTrue: [ #(  ) ]
		  ifFalse: [
		  { (self pointerOf: anOwner pointer child: arguments first) } ]
]
