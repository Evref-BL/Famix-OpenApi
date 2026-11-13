"
Derivation #mappingTarget, for the entries of the mapping of a discriminator (entities without node, at <discriminator>/mapping/<key>): the value of the key is the name of a schema of the components or a local $ref (VERIFIED by import); the target is the schema entity at that node. Nothing for a value that designates no schema of the document (unresolved, external, not a text).
"
Class {
	#name : 'FamixOpenApiMappingTargetDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiMappingTargetDerivation >> schemaNodeNamed: aText in: aCheck [
	"The schema node that the value designates: a local $ref, or the name of a schema of the components; nil for any other value"

	aText isString ifFalse: [ ^ nil ].
	(aText beginsWith: '#') ifTrue: [
		^ aCheck nodeExpectation nodeForReference: aText ].
	(aText includes: $/) ifTrue: [ ^ nil ].
	^ aCheck expandedInventory
		  nodeAt: (self pointerOf: '#/components/schemas' child: aText)
		  ifAbsent: [ nil ]
]

{ #category : 'deriving' }
FamixOpenApiMappingTargetDerivation >> targetsOf: anOwner in: aCheck [

	| text |
	text := self textOf: anOwner in: aCheck expandedInventory.
	^ self
		  targetOfNode: (self schemaNodeNamed: text in: aCheck)
		  in: aCheck
]

{ #category : 'deriving' }
FamixOpenApiMappingTargetDerivation >> textOf: anOwner in: anInventory [
	"The value of the key of the entry in the mapping of the discriminator: <discriminator>/mapping/<key>, nil when there is none"

	| discriminator mapping |
	discriminator := anInventory
		                 nodeAt:
		                 (anInventory pointerAbove:
			                  (anInventory pointerAbove: anOwner pointer))
		                 ifAbsent: [ ^ nil ].
	mapping := discriminator valueAt: 'mapping'.
	mapping isDictionary ifFalse: [ ^ nil ].
	^ mapping at: (self lastKeyOf: anOwner pointer) ifAbsent: [ nil ]
]
