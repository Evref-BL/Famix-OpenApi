"
Tests of FamixOpenApiReferenceChain: how a local $ref is followed along aliases to the node the importer reads, and when it is resolved, unresolved (nothing there, external, not an object) or cyclic.
"
Class {
	#name : 'FamixOpenApiReferenceChainTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures' }
FamixOpenApiReferenceChainTest >> document [
	"Aliases of aliases, a cycle of two, a target that does not exist, an external one, a percent-encoded one, a target that is not an object"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{},"components":{"responses":{"A":{"$ref":"#/components/responses/B"},"B":{"$ref":"#/components/responses/C"},"C":{"description":"c"},"Cyc":{"$ref":"#/components/responses/Cyc2"},"Cyc2":{"$ref":"#/components/responses/Cyc"},"Nope":{"$ref":"#/components/responses/Missing"},"Ext":{"$ref":"other.json#/x"},"Enc":{"$ref":"#/components/responses/a%20b"},"a b":{"description":"spaced"},"Str":{"$ref":"#/components/responses/S"},"S":"text","ToCyc":{"$ref":"#/components/responses/Cyc"}}}}'
]

{ #category : 'tests' }
FamixOpenApiReferenceChainTest >> testACycleOfReferencesIsCyclicAndHasNoTarget [

	| inventory chain |
	inventory := self inventoryOf: self document.
	chain := FamixOpenApiReferenceChain on: inventory.
	#( '#/components/responses/Cyc' '#/components/responses/Cyc2'
	   '#/components/responses/ToCyc' ) do: [ :each |
		| site |
		site := inventory nodeAt: each.
		self assert: (chain outcomeOf: site) equals: #cyclic.
		self assert: (chain isCyclic: site).
		self assert: (chain targetOf: site) isNil ]
]

{ #category : 'tests' }
FamixOpenApiReferenceChainTest >> testAMissingExternalOrNotObjectTargetIsUnresolved [

	| inventory chain |
	inventory := self inventoryOf: self document.
	chain := FamixOpenApiReferenceChain on: inventory.
	#( '#/components/responses/Nope' '#/components/responses/Ext'
	   '#/components/responses/Str' ) do: [ :each |
		| site |
		site := inventory nodeAt: each.
		self assert: (chain outcomeOf: site) equals: #unresolved.
		self deny: (chain isCyclic: site).
		self assert: (chain targetOf: site) isNil ]
]

{ #category : 'tests' }
FamixOpenApiReferenceChainTest >> testAPercentEncodedReferenceIsDecoded [

	| inventory chain |
	inventory := self inventoryOf: self document.
	chain := FamixOpenApiReferenceChain on: inventory.
	self
		assert:
			(chain targetOf: (inventory nodeAt: '#/components/responses/Enc'))
				pointer
		equals: '#/components/responses/a b'.
	self
		assert:
		(chain nodeForReference: '#/components/responses/a%20b') pointer
		equals: '#/components/responses/a b'.
	self assert: (chain nodeForReference: 'other.json#/x') isNil
]

{ #category : 'tests' }
FamixOpenApiReferenceChainTest >> testAnAliasOfAnAliasEndsAtTheNodeThatIsNotAReference [

	| inventory chain site |
	inventory := self inventoryOf: self document.
	chain := FamixOpenApiReferenceChain on: inventory.
	site := inventory nodeAt: '#/components/responses/A'.
	self assert: (chain outcomeOf: site) equals: #resolved.
	self
		assert: (chain targetOf: site) pointer
		equals: '#/components/responses/C'
]
