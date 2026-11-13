"
Derivation #children, one key (the argument): the targets are the entities that the nodes under that key of the owner give, in the order of the source (an object child: the node at the key; a map or an array: its entries, in the order of the keys or of the elements). A $ref child gives the entity it resolves to (see FamixOpenApiRelationCheck>>targetPointerOf:family:), a child that gives no entity of the family (dropped, wrong shape, unresolved) gives nothing, and the same target is held once (the relations of the model are sets that keep the first occurrence). Not derivable (nil) for an OpenAPI 3.1 schema that is a $ref with the key beside it: the importer reads the keys beside a $ref there, and the inventory does not walk them.
"
Class {
	#name : 'FamixOpenApiChildrenDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiChildrenDerivation >> isBesideReference: aNode [
	"True for an OpenAPI 3.1 $ref that has the key beside it: the importer reads it, the inventory does not walk it"

	^ aNode referenceText isNotNil and: [
		  aNode version = #v31 and: [
			  (aNode valueAt: arguments first) isNotNil ] ]
]

{ #category : 'deriving' }
FamixOpenApiChildrenDerivation >> nodesOf: aNode in: anInventory [
	"The node at the key (an object child), else the entries of the map or the array at the key, in the order of the source"

	| pointer |
	pointer := self pointerOf: aNode pointer child: arguments first.
	^ (anInventory nodeAt: pointer ifAbsent: [ nil ])
		  ifNil: [
			  self
				  inOrderOf: (aNode valueAt: arguments first)
				  nodes: (anInventory childrenOf: pointer) ]
		  ifNotNil: [ :child | { child } ]
]

{ #category : 'accessing' }
FamixOpenApiChildrenDerivation >> reason [

	^ 'keys beside a $ref (OpenAPI 3.1) are not walked'
]

{ #category : 'deriving' }
FamixOpenApiChildrenDerivation >> targetsOf: anOwner in: aCheck [

	| nodes |
	(self isBesideReference: anOwner node) ifTrue: [ ^ nil ].
	nodes := self nodesOf: anOwner node in: aCheck expandedInventory.
	^ self pointersOfNodes: nodes in: aCheck
]
