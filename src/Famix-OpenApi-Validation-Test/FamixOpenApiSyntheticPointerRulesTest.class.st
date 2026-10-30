"
Tests of FamixOpenApiSyntheticPointerRules and FamixOpenApiSynthesizedServers: every documented rule accepts the real entities of the fixtures (OpenAPI 3.0, 3.1, Swagger 2) and refuses look-alikes whose source node does not justify them; the synthesised servers have the urls the document implies.
"
Class {
	#name : 'FamixOpenApiSyntheticPointerRulesTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRulesTest >> ruleOfRealEntity: aClass at: aPointer in: aJsonString [
	"The rule that accepts the entity of the real import at aPointer"

	| entities |
	entities := self
		            entityOf: aClass
		            at: aPointer
		            in: (self modelOf: aJsonString).
	self assert: entities size equals: 1.
	^ (FamixOpenApiSyntheticPointerRules on:
		   (self inventoryOf: aJsonString)) ruleNameFor: entities first
]

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRulesTest >> ruleOfStray: aClass at: aPointer in: aJsonString [
	"The rule that accepts a look-alike entity built by hand, nil when none does"

	^ (FamixOpenApiSyntheticPointerRules on:
		   (self inventoryOf: aJsonString)) ruleNameFor: (aClass new
			   canonicalPointer: aPointer;
			   yourself)
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticPointerRulesTest >> testClonedPathItemHoldsClonedOperations [

	| doc |
	doc := self documentOpenApi31.
	self
		assert:
		(self ruleOfRealEntity: OPOperation at: '#/paths/~1a/get' in: doc)
		equals: #cloneSubtree.
	self
		assert: (self
				 ruleOfRealEntity: OPResponse
				 at: '#/paths/~1a/get/responses/200'
				 in: doc)
		equals: #cloneSubtree.
	self
		assert:
		(self ruleOfRealEntity: OPOperation at: '#/webhooks/w2/get' in: doc)
		equals: #cloneSubtree
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticPointerRulesTest >> testClonedResponseHoldsItsContent [

	| doc |
	doc := self documentWithSiblingsIn: '3.1.0'.
	self
		assert: (self
				 ruleOfRealEntity: OPMediaType
				 at: '#/paths/~1c/post/responses/201/content/a~1b'
				 in: doc)
		equals: #cloneSubtree.
	self
		assert: (self
				 ruleOfRealEntity: OPHeader
				 at: '#/paths/~1c/post/responses/201/headers/h'
				 in: doc)
		equals: #cloneSubtree
]

{ #category : 'tests - data' }
FamixOpenApiSyntheticPointerRulesTest >> testEveryDocumentedRuleIsUsedByTheRealImports [
	"The data of the rules and the rules that act must be the same list"

	| used |
	used := Set new.
	self allDocuments do: [ :each |
		| inventory rules |
		inventory := self inventoryOf: each value.
		rules := FamixOpenApiSyntheticPointerRules on: inventory.
		(FamixOpenApiPointerLookup onModel: (self modelOf: each value))
			allEntities
			reject: [ :entity |
			inventory includesPointer: entity canonicalPointer ]
			thenDo: [ :entity | used add: (rules ruleNameFor: entity) ] ].
	self deny: (used includes: nil).
	self
		assert: used
		equals:
		(FamixOpenApiSyntheticPointerRules dataRules collect: #first) asSet
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticPointerRulesTest >> testKeysOfTheNodeAboveGiveSyntheticEntities [

	| doc |
	doc := self documentOpenApi30.
	self
		assert: (self
				 ruleOfRealEntity: OPExample
				 at: '#/paths/~1b/get/parameters/0/example'
				 in: doc)
		equals: #scalarExample.
	self
		assert: (self
				 ruleOfRealEntity: OPDiscriminatorMapping
				 at: '#/components/schemas/A/discriminator/mapping/b'
				 in: doc)
		equals: #discriminatorMappingEntry.
	self
		assert: (self
				 ruleOfRealEntity: OPSecurityScope
				 at: '#/components/securitySchemes/oa/flows/implicit/scopes/read'
				 in: doc)
		equals: #securityScope.
	self
		assert: (self
				 ruleOfRealEntity: OPSecurityRequirementItem
				 at: '#/paths/~1b/post/security/0/oa'
				 in: doc)
		equals: #securityRequirementItem
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticPointerRulesTest >> testLookAlikesWithoutTheirSourceKeyAreRefused [

	| doc |
	doc := self documentOpenApi30.
	self assert: (self ruleOfStray: OPSchema at: '#/zzz' in: doc) isNil.
	self assert:
		(self ruleOfStray: OPSchema at: '#/paths/~1b/get/zzz' in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPExample
			 at: '#/components/parameters/P/example'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPExample
			 at: '#/components/schemas/A/example'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPSecurityScope
			 at: '#/components/securitySchemes/oa/flows/implicit/scopes/zzz'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPSecurityRequirementItem
			 at: '#/paths/~1b/post/security/0/zzz'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPDiscriminatorMapping
			 at: '#/components/schemas/A/discriminator/mapping/zzz'
			 in: doc) isNil.
	self assert:
		(self ruleOfStray: OPServer at: '#/servers/x' in: doc) isNil.
	self assert:
		(self ruleOfStray: OPComponents at: '#/components2' in: doc) isNil.
	self assert: (self ruleOfStray: OPInfo at: nil in: doc) isNil
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticPointerRulesTest >> testMediaTypesOfResponsesAndBodyParametersFollowProducesAndConsumes [

	| doc |
	doc := self documentSwagger2.
	#( '#/responses/R/content/application~1json'
	   '#/responses/R/content/text~1plain'
	   '#/paths/~1b/post/parameters/0/content/a~1b'
	   '#/paths/~1b/post/responses/200/content/c~1d'
	   '#/paths/~1b/get/parameters/1/content/application~1xml' ) do: [
		:pointer |
		self
			assert: (self ruleOfRealEntity: OPMediaType at: pointer in: doc)
			equals: #swagger2MediaType ].
	self assert: (self
			 ruleOfStray: OPMediaType
			 at: '#/responses/R/content/application~1zzz'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPMediaType
			 at: '#/paths/~1b/post/responses/200/content/text~1plain'
			 in: doc) isNil
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticPointerRulesTest >> testRulesOfAnotherClassAreRefused [
	"The pointer of a rule, the class of another one"

	| doc |
	doc := self documentOpenApi30.
	self assert: (self
			 ruleOfStray: OPTag
			 at: '#/paths/~1b/get/parameters/0/example'
			 in: doc) isNil.
	self assert:
		(self ruleOfStray: OPTag at: '#/servers/3' in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPInfo
			 at: '#/components/securitySchemes/oa/flows/implicit/scopes/read'
			 in: doc) isNil
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticPointerRulesTest >> testScalarExampleOfAMediaTypeAndTheDefaultServer [

	| doc |
	doc := self documentOpenApi30Scalars.
	self
		assert: (self
				 ruleOfRealEntity: OPExample
				 at: '#/paths/~1z/get/responses/200/content/a~1b/example'
				 in: doc)
		equals: #scalarExample.
	self
		assert: (self ruleOfRealEntity: OPServer at: '#/servers/0' in: doc)
		equals: #synthesizedServer.
	self assert: (self
			 entityOf: OPExample
			 at: '#/paths/~1z/get/responses/200/headers/h/example'
			 in: (self modelOf: doc)) isEmpty
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticPointerRulesTest >> testScopesAndClonedResponseOfSwagger2 [

	| doc |
	doc := self documentSwagger2.
	self
		assert: (self
				 ruleOfRealEntity: OPSecurityScope
				 at: '#/securityDefinitions/oa/scopes/read'
				 in: doc)
		equals: #securityScope.
	self
		assert: (self
				 ruleOfRealEntity: OPSecurityRequirementItem
				 at: '#/security/0/k'
				 in: doc)
		equals: #securityRequirementItem.
	self
		assert: (self
				 ruleOfRealEntity: OPSchema
				 at: '#/paths/~1b/get/responses/201/schema'
				 in: doc)
		equals: #cloneSubtree
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticPointerRulesTest >> testStringDiscriminatorAndFormDataRequestBody [

	| doc |
	doc := self documentSwagger2.
	self
		assert: (self
				 ruleOfRealEntity: OPDiscriminator
				 at: '#/definitions/A/discriminator'
				 in: doc)
		equals: #swagger2Discriminator.
	self assert: (self
			 ruleOfStray: OPDiscriminator
			 at: '#/definitions/B/discriminator'
			 in: doc) isNil.
	self
		assert: (self
				 ruleOfRealEntity: OPRequestBody
				 at: '#/paths/~1b/put/requestBody'
				 in: doc)
		equals: #swagger2FormDataRequestBody.
	self
		assert: (self
				 ruleOfRealEntity: OPSchema
				 at: '#/paths/~1b/put/requestBody/schema'
				 in: doc)
		equals: #swagger2FormDataRequestBody.
	self assert: (self
			 ruleOfStray: OPRequestBody
			 at: '#/definitions/A/requestBody'
			 in: doc) isNil
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticPointerRulesTest >> testSwagger2RootAndServers [

	| doc |
	doc := self documentSwagger2.
	self
		assert:
		(self ruleOfRealEntity: OPComponents at: '#/components' in: doc)
		equals: #swagger2Components.
	self
		assert: (self ruleOfRealEntity: OPServer at: '#/servers/0' in: doc)
		equals: #synthesizedServer.
	self
		assert: (self ruleOfRealEntity: OPServer at: '#/servers/1' in: doc)
		equals: #synthesizedServer
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticPointerRulesTest >> testSwagger2RulesDoNotApplyToOpenApi3 [

	| doc |
	doc := self documentOpenApi30.
	self assert:
		(self ruleOfStray: OPComponents at: '#/components' in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPDiscriminator
			 at: '#/components/schemas/A/discriminator'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPSchema
			 at: '#/paths/~1b/get/parameters/0/schema'
			 in: doc) isNil
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticPointerRulesTest >> testTypedParameterGivesASchemaWithItsItemsChain [

	| doc |
	doc := self documentSwagger2.
	#( '#/paths/~1b/get/parameters/0/schema'
	   '#/paths/~1b/get/parameters/0/schema/items'
	   '#/paths/~1b/get/parameters/0/schema/items/items'
	   '#/parameters/P/schema' ) do: [ :pointer |
		self
			assert: (self ruleOfRealEntity: OPSchema at: pointer in: doc)
			equals: #swagger2ParameterSchema ].
	self assert: (self
			 ruleOfStray: OPSchema
			 at: '#/paths/~1b/get/parameters/0/schema/items/items/items'
			 in: doc) isNil.
	self assert: (self
			 ruleOfStray: OPSchema
			 at: '#/paths/~1b/get/parameters/0/items'
			 in: doc) isNil
]
