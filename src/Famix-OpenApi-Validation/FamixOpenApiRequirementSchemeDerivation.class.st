"
Derivation #requirementScheme, for the items of a security requirement (entities without node, at <requirement>/<scheme name>): the target is the security scheme of the components (#/components/securitySchemes/<name>, #/securityDefinitions/<name> in Swagger 2) that the name designates; nothing for a name that is not a scheme of the document (VERIFIED by import: the item exists without scheme).
"
Class {
	#name : 'FamixOpenApiRequirementSchemeDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiRequirementSchemeDerivation >> schemesPointerIn: aCheck [
	"The pointer of the map of the security schemes"

	^ aCheck version = #v2
		  ifTrue: [ '#/securityDefinitions' ]
		  ifFalse: [ '#/components/securitySchemes' ]
]

{ #category : 'deriving' }
FamixOpenApiRequirementSchemeDerivation >> targetsOf: anOwner in: aCheck [

	^ self
		  targetOfNode: (aCheck expandedInventory
				   nodeAt: (self
						    pointerOf: (self schemesPointerIn: aCheck)
						    child: (self lastKeyOf: anOwner pointer))
				   ifAbsent: [ nil ])
		  in: aCheck
]
