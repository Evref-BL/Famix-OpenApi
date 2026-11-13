"
Derivation #syntheticAt, segments (the arguments): the targets are the entities derived without node (FamixOpenApiSyntheticExpectations) whose pointer is exactly the pointer of the owner plus the segment: the example that the importer makes of the key example of a media type or a parameter, the discriminator of Swagger 2, the request body of the form parameters of Swagger 2, the components of Swagger 2.
"
Class {
	#name : 'FamixOpenApiSyntheticAtDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiSyntheticAtDerivation >> targetsOf: anOwner in: aCheck [

	^ arguments
		  flatCollect: [ :segment |
			  aCheck
				  syntheticAt: (self pointerOf: anOwner pointer child: segment)
				  family: family ]
		  as: Array
]
