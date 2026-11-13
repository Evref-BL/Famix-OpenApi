"
Derivation #directChildren, several keys (the arguments): the targets are the entities of the nodes held directly by the owner under one of the keys, in the ORDER OF THE DOCUMENT (the operations of a path item: get, put, post... in the order the source writes them; the path items of a callback under their expressions). Same resolution of the $ref children and same collapse of the repeated targets as FamixOpenApiChildrenDerivation.
"
Class {
	#name : 'FamixOpenApiDirectChildrenDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiDirectChildrenDerivation >> targetsOf: anOwner in: aCheck [

	| inventory nodes |
	inventory := aCheck expandedInventory.
	nodes := (inventory childrenOf: anOwner node pointer) select: [ :each |
		         arguments includes: (inventory fieldOf: each) ].
	^ self
		  pointersOfNodes: (self inOrderOf: anOwner node value nodes: nodes)
		  in: aCheck
]
