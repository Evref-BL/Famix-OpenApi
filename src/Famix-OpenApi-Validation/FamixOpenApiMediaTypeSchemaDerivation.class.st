"
Derivation #mediaTypeSchema, for the media types of Swagger 2 (they have no node): <owner>/content/<mime> gets the schema of <owner>, the response, the body parameter or the form request body (a node of the expanded inventory, FamixOpenApiSwagger2Schemas); the target is the schema entity that this node gives, or the one its $ref resolves to.
"
Class {
	#name : 'FamixOpenApiMediaTypeSchemaDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiMediaTypeSchemaDerivation >> schemaPointerOf: anOwner in: anInventory [
	"The pointer of the schema of <owner>/content/<mime>: <owner>/schema"

	^ self
		  pointerOf:
		  (anInventory pointerAbove:
			   (anInventory pointerAbove: anOwner pointer))
		  child: 'schema'
]

{ #category : 'deriving' }
FamixOpenApiMediaTypeSchemaDerivation >> targetsOf: anOwner in: aCheck [

	| inventory |
	inventory := aCheck expandedInventory.
	^ self
		  targetOfNode: (inventory
				   nodeAt: (self schemaPointerOf: anOwner in: inventory)
				   ifAbsent: [ nil ])
		  in: aCheck
]
