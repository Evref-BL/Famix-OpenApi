"
Derivation #alias: a schema that is a $ref and has an entity of its own (an alias in the components, an OpenAPI 3.1 schema with keys beside its $ref) holds the schema it designates in its allOf (VERIFIED by import); the target is the one the $ref resolves to. Nothing for every other schema.
"
Class {
	#name : 'FamixOpenApiAliasDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiAliasDerivation >> targetsOf: anOwner in: aCheck [

	| node |
	node := anOwner node.
	(node referenceText isNotNil and: [
		 aCheck node: node givesFamily: family ]) ifFalse: [ ^ #(  ) ].
	^ (aCheck designatedPointerOf: node family: family)
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :pointer | { pointer } ]
]
