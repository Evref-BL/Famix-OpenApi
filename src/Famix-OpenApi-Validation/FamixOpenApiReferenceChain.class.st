"
Follows the local $ref of a node of a source inventory the way the importer does (FamixOpenApiNodeVisitor>>referencedNodeFor:at:): the references met on the way are followed (an alias of an alias...) until a node that is not a reference. #outcomeOf: answers #resolved, #unresolved (a target that does not exist in the inventory, an external reference, or a target that is not an object) or #cyclic (the chain comes back to a reference already followed); #targetOf: answers the final node, nil unless the outcome is #resolved. A local reference is a pointer in a URI fragment and may be percent-encoded. The inventory only holds the nodes of the grammar: a target elsewhere in the document is unresolved here (a known limit, see FamixOpenApiSyntheticExpectations class>>knownLimits).
"
Class {
	#name : 'FamixOpenApiReferenceChain',
	#superclass : 'Object',
	#instVars : [
		'inventory'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiReferenceChain class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'references' }
FamixOpenApiReferenceChain >> follow: aReferenceNode [
	"Answer an Association outcome -> final node (nil unless #resolved), the way referencedNodeFor:at: of the importer follows the references"

	| current visited node |
	current := aReferenceNode referenceText.
	visited := Set new.
	[
	node := self nodeForReference: current.
	node ifNil: [ ^ #unresolved -> nil ].
	node referenceText isNotNil ] whileTrue: [
		(visited includes: current) ifTrue: [ ^ #cyclic -> nil ].
		visited add: current.
		current := node referenceText ].
	^ node isWrongShape
		  ifTrue: [ #unresolved -> nil ]
		  ifFalse: [ #resolved -> node ]
]

{ #category : 'accessing' }
FamixOpenApiReferenceChain >> inventory: aSourceInventory [

	inventory := aSourceInventory
]

{ #category : 'references' }
FamixOpenApiReferenceChain >> isCyclic: aReferenceNode [

	^ (self outcomeOf: aReferenceNode) == #cyclic
]

{ #category : 'references' }
FamixOpenApiReferenceChain >> nodeForReference: aText [
	"The node a local reference designates, nil for an external or unresolved one (a pointer of the inventory starts with #)"

	^ inventory nodeAt: aText ifAbsent: [
		  inventory
			  nodeAt: (ZnPercentEncoder new decode: aText)
			  ifAbsent: [ nil ] ]
]

{ #category : 'references' }
FamixOpenApiReferenceChain >> outcomeOf: aReferenceNode [
	"#resolved, #unresolved or #cyclic"

	^ (self follow: aReferenceNode) key
]

{ #category : 'references' }
FamixOpenApiReferenceChain >> targetOf: aReferenceNode [
	"The node at the end of the chain of references of aReferenceNode, nil when the chain is not resolved"

	^ (self follow: aReferenceNode) value
]
