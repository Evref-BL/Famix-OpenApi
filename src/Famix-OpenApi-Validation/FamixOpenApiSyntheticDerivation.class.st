"
Derivation #synthetic, segments (the arguments): the targets are the entities that the importer builds WITHOUT a node of their own (FamixOpenApiSyntheticExpectations: the media types of a Swagger 2 response, the mapping entries of a discriminator, the items of a security requirement, the scopes of a flow) and whose pointer is directly below the pointer of the owner plus the segment (the owner itself for the empty segment), in the order the derivation gives them. A pointer derived twice (a media type listed twice in produces) is held twice by the model.
"
Class {
	#name : 'FamixOpenApiSyntheticDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiSyntheticDerivation >> parentOf: anOwner segment: aSegment [
	"The pointer under which the targets sit: the owner for the empty segment"

	^ aSegment isEmpty
		  ifTrue: [ anOwner pointer ]
		  ifFalse: [ self pointerOf: anOwner pointer child: aSegment ]
]

{ #category : 'deriving' }
FamixOpenApiSyntheticDerivation >> targetsOf: anOwner in: aCheck [

	^ arguments
		  flatCollect: [ :segment |
			  aCheck
				  syntheticChildrenOf: (self parentOf: anOwner segment: segment)
				  family: family ]
		  as: Array
]
