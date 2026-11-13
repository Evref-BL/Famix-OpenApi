"
Derivation #own: the owner node gives an entity of the family of the targets at its own pointer, and that entity is the target (the oauth2 security scheme of Swagger 2 is also the OAuth flow it holds in flows).
"
Class {
	#name : 'FamixOpenApiOwnDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiOwnDerivation >> targetsOf: anOwner in: aCheck [

	^ (aCheck node: anOwner node givesFamily: family)
		  ifTrue: [ { anOwner node pointer } ]
		  ifFalse: [ #(  ) ]
]
