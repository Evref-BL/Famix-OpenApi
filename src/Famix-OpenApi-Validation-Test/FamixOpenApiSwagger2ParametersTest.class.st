"
Tests of FamixOpenApiSwagger2Parameters: effective node (the end of a $ref chain), location, typed (inline) parameters, formData parameters of an operation and the schema value a typed parameter makes.
"
Class {
	#name : 'FamixOpenApiSwagger2ParametersTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures' }
FamixOpenApiSwagger2ParametersTest >> parametersOn: anInventory [

	^ FamixOpenApiSwagger2Parameters
		  inventory: anInventory
		  expectation: (FamixOpenApiNodeExpectation on: anInventory)
]

{ #category : 'tests' }
FamixOpenApiSwagger2ParametersTest >> testAReferenceParameterIsReadAtTheEndOfItsChainAndAnUnresolvedOneHasNone [

	| inventory parameters |
	inventory := self inventoryOf: self documentSwagger2Typed.
	parameters := self parametersOn: inventory.
	self
		assert: (parameters effectiveNodeOf:
				 (inventory nodeAt: '#/paths/~1p/get/parameters/3')) pointer
		equals: '#/parameters/T'.
	self assert: (parameters effectiveNodeOf:
			 (inventory nodeAt: '#/paths/~1p/get/parameters/4')) isNil.
	self
		assert: (parameters locationOf:
				 (inventory nodeAt: '#/paths/~1p/get/parameters/3'))
		equals: 'query'.
	self assert: (parameters locationOf:
			 (inventory nodeAt: '#/paths/~1p/get/parameters/4')) isNil
]

{ #category : 'tests' }
FamixOpenApiSwagger2ParametersTest >> testOnlyAParameterWithALocationThatIsNeitherBodyNorFormDataIsTyped [
	"Typed: a, h (header, no type but typed by its location), r, c (cookie); not typed: a $ref, an unresolved $ref, a body, a parameter without location"

	| inventory parameters |
	inventory := self inventoryOf: self documentSwagger2Typed.
	parameters := self parametersOn: inventory.
	#( '#/paths/~1p/get/parameters/0' '#/paths/~1p/get/parameters/1'
	   '#/paths/~1p/get/parameters/2' '#/paths/~1p/get/parameters/6' )
		do: [ :each |
			self assert: (parameters isInline: (inventory nodeAt: each)) ].
	#( '#/paths/~1p/get/parameters/3' '#/paths/~1p/get/parameters/4'
	   '#/paths/~1p/get/parameters/5' '#/paths/~1p/get/parameters/7' )
		do: [ :each |
		self deny: (parameters isInline: (inventory nodeAt: each)) ]
]

{ #category : 'tests' }
FamixOpenApiSwagger2ParametersTest >> testTheFormParametersOfAnOperationAreTheirEffectiveNodesInDocumentOrder [

	| inventory parameters |
	inventory := self inventoryOf: self documentSwagger2Forms.
	parameters := self parametersOn: inventory.
	self
		assert:
			((parameters formsIn: (inventory nodeAt: '#/paths/~1p/post'))
				 collect: [ :each | each valueAt: 'name' ])
		equals: #( 'f' 'g' 'ff' 'f' )
]

{ #category : 'tests' }
FamixOpenApiSwagger2ParametersTest >> testTheSchemaValueKeepsTheSchemaKeysInTheOrderOfTheImporter [

	| inventory parameters value |
	inventory := self inventoryOf: self documentSwagger2Typed.
	parameters := self parametersOn: inventory.
	value := parameters schemaValueOf:
		         (inventory nodeAt: '#/parameters/T').
	self assert: value keys asArray equals: #( 'type' 'format' ).
	self assert: (parameters schemaValueOf:
			 (inventory nodeAt: '#/paths/~1p/get/parameters/1')) isEmpty
]
