"
Derivation #container, one key (the argument): the owner holds an object (the paths of the document, the responses of an operation, the flows of a security scheme) that is a node itself and that has no entity; the targets are the entities of ITS children, in the order of the document. Same resolution of the $ref children as FamixOpenApiChildrenDerivation.
"
Class {
	#name : 'FamixOpenApiContainerDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiContainerDerivation >> targetsOf: anOwner in: aCheck [

	| pointer inventory |
	inventory := aCheck expandedInventory.
	pointer := self
		           pointerOf: anOwner node pointer
		           child: arguments first.
	^ self
		  pointersOfNodes: (self
				   inOrderOf: (anOwner node valueAt: arguments first)
				   nodes: (inventory childrenOf: pointer))
		  in: aCheck
]
