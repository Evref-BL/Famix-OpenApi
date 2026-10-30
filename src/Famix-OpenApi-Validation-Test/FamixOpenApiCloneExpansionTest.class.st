"
Tests of FamixOpenApiCloneExpansion (re-rooting of the clones of $ref responses and path items) and of the inventory operations it needs (a copy that owns its indexes, removal of a node, walking a subtree into an inventory).
"
Class {
	#name : 'FamixOpenApiCloneExpansionTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - inventory' }
FamixOpenApiCloneExpansionTest >> testACopyOfAnInventoryOwnsItsIndexes [

	| inventory copy parent |
	inventory := self inventoryOf: self documentOpenApi30Clones.
	copy := inventory copy.
	parent := '#/paths/~1p/get/responses'.
	copy removeNodeAt: parent , '/200'.
	self deny: (copy includesPointer: parent , '/200').
	self assert: (inventory includesPointer: parent , '/200').
	self
		assert: (copy childrenOf: parent) size + 1
		equals: (inventory childrenOf: parent) size.
	self
		assert: (copy nodesOf: 'Reference') size + 1
		equals: (inventory nodesOf: 'Reference') size
]

{ #category : 'tests' }
FamixOpenApiCloneExpansionTest >> testADocumentWithoutCloneSiteIsExpandedToAnEqualCopy [

	| inventory expanded |
	inventory := self inventoryOf: self documentSwagger2Typed.
	expanded := (FamixOpenApiCloneExpansion on: inventory)
		            expandedInventory.
	self deny: expanded identicalTo: inventory.
	self assert: expanded pointers asSet equals: inventory pointers asSet.
	self
		assert: (FamixOpenApiCloneExpansion on: inventory) cloneSitePointers
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiCloneExpansionTest >> testAPointerIsBelowACloneSiteOnlyWhenTheSiteWasCloned [

	| expansion |
	expansion := FamixOpenApiCloneExpansion on:
		             (self inventoryOf: self documentOpenApi30Clones).
	expansion expandedInventory.
	self assert: (expansion isBelowCloneSite: '#/paths/~1q/get').
	self assert:
		(expansion isBelowCloneSite:
			 '#/paths/~1p/get/responses/200/headers/h').
	self deny:
		(expansion isBelowCloneSite: '#/paths/~1p/get/responses/200').
	self deny:
		(expansion isBelowCloneSite: '#/paths/~1p/get/responses/203').
	self deny:
		(expansion isBelowCloneSite: '#/paths/~1p/get/responses/203/content')
]

{ #category : 'tests' }
FamixOpenApiCloneExpansionTest >> testASiteIsReplacedAndNotAddedToItsParentInTheExpandedInventory [
	"The children of the parent of a site are the same nodes as in the original (the replaced one comes last: nothing reads the order of the responses or of the entries)"

	| inventory expanded parent |
	inventory := self inventoryOf: self documentOpenApi30Clones.
	expanded := (FamixOpenApiCloneExpansion on: inventory)
		            expandedInventory.
	parent := '#/paths/~1p/get/responses'.
	self
		assert:
		((expanded childrenOf: parent) collect: #pointer) asArray sorted
		equals:
		((inventory childrenOf: parent) collect: #pointer) asArray sorted.
	self
		assert:
		((expanded childrenOf: '#/paths') collect: #pointer) asArray sorted
		equals:
		((inventory childrenOf: '#/paths') collect: #pointer) asArray sorted
]

{ #category : 'tests - inventory' }
FamixOpenApiCloneExpansionTest >> testASubtreeWalkedIntoAnInventoryGivesItsNodes [
	"The nodes of a value read at a pointer of an inventory, as the clones and the synthesized schemas are"

	| inventory root |
	inventory := (self inventoryOf: self documentSwagger2Typed) copy.
	root := FamixOpenApiSourceNode
		        specObject: 'Schema'
		        pointer: '#/extra'
		        in: inventory
		        value: (NeoJSONReader fromString:
				         '{"type":"array","items":{"type":"string"}}').
	FamixOpenApiSourceWalker new walkRoot: root into: inventory edge: nil.
	self assert: (inventory includesPointer: '#/extra').
	self assert: (inventory includesPointer: '#/extra/items').
	self
		assert: (inventory nodeAt: '#/extra/items') specObject
		equals: 'Schema'
]

{ #category : 'tests' }
FamixOpenApiCloneExpansionTest >> testTheExpandedInventoryHoldsTheTargetAtTheSiteAndTheOriginalIsNotChanged [

	| inventory expansion expanded |
	inventory := self inventoryOf: self documentOpenApi30Clones.
	expansion := FamixOpenApiCloneExpansion on: inventory.
	expanded := expansion expandedInventory.
	self assert: (expanded includesPointer: '#/paths/~1q/get').
	self assert: (expanded includesPointer:
			 '#/paths/~1p/get/responses/200/content/a~1b').
	self deny: (inventory includesPointer: '#/paths/~1q/get').
	self deny: (inventory includesPointer:
			 '#/paths/~1p/get/responses/200/content/a~1b').
	self assert: (inventory nodeAt: '#/paths/~1q') isReference.
	self deny: (expanded nodeAt: '#/paths/~1q') isReference.
	self assert: expansion expandedInventory identicalTo: expanded
]

{ #category : 'tests' }
FamixOpenApiCloneExpansionTest >> testTheSiblingsOfAnOpenApi31PathItemOverrideItsTarget [
	"/p has its own get beside its $ref: its response says `o`, not the `r` of the component"

	| expanded |
	expanded := (FamixOpenApiCloneExpansion on:
		             (self inventoryOf: self documentOpenApi31Clones))
		            expandedInventory.
	self
		assert:
			((expanded nodeAt: '#/paths/~1p/get/responses/200') valueAt:
				 'description')
		equals: 'o'.
	self
		assert:
			((expanded nodeAt: '#/paths/~1q/get/responses/200') valueAt:
				 'description')
		equals: 'r'
]

{ #category : 'tests' }
FamixOpenApiCloneExpansionTest >> testTheSitesThatAreClonedAreTheResolvedOnesOfResponsesAndPathItems [
	"The unresolved and the cyclic response are not cloned; the clones inside the clone of a path item are sites too"

	| expansion |
	expansion := FamixOpenApiCloneExpansion on:
		             (self inventoryOf: self documentOpenApi30Clones).
	self
		assert: expansion cloneSitePointers asArray sorted
		equals:
			#( '#/paths/~1p/get/responses/200' '#/paths/~1p/get/responses/201'
			   '#/paths/~1q' '#/paths/~1q/get/responses/200'
			   '#/paths/~1q/get/responses/201' '#/paths/~1r' '#/paths/~1r/get/responses/200'
			   '#/paths/~1r/get/responses/201' )
]
