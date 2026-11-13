"
Derivation #propertyValue: the owner is the entry of the properties of a schema (an OPProperty); its value schema is the schema that the entry gives (the OPSchema at the same pointer) or the one its $ref resolves to; nothing for a boolean schema or an unresolved $ref.
"
Class {
	#name : 'FamixOpenApiPropertyValueDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiPropertyValueDerivation >> targetsOf: anOwner in: aCheck [

	^ self targetOfNode: anOwner node in: aCheck
]
