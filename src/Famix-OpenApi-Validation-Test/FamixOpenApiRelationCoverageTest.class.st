"
What the relation check really verified (V10), per version, spec object, field and relation: how many relations were compared (one per owner), how many targets (links), how many were deferred and why, and the list of the relations that were never compared with the reason.
"
Class {
	#name : 'FamixOpenApiRelationCoverageTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> coverageOf: aJsonString [

	^ (self relationReportFor: aJsonString) coverage
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testADeferredRelationIsCountedWithItsReason [

	| coverage |
	coverage := self coverageOf: self documentSecurity31.
	self
		assert: coverage deferredKeys
		equals: #( 'v31 Schema.allOf -> OPSchema>>allOf' ).
	self assert: coverage totalDeferred equals: 1.
	self assert:
		('*| v31 Schema.allOf -> OPSchema>>allOf | 1 | keys beside a $ref (OpenAPI 3.1) are not walked |*'
			 match:
			 (self relationReportFor: self documentSecurity31) markdownSummary)
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testARelationThatWasOnlyDeferredOrOnlyWithoutEntityIsNeverComparedForThatReason [

	| coverage never |
	coverage := FamixOpenApiCoverage new.
	coverage
		recordDeferred: 'v31 Schema.allOf -> OPSchema>>allOf'
		reason: 'why'.
	coverage recordWithoutEntity: 'v31 Schema.items -> OPSchema>>items'.
	never := (FamixOpenApiRelationRules
		          neverComparedIn: coverage
		          version: #v31) asDictionary.
	self
		assert: (never at: 'v31 Schema.allOf -> OPSchema>>allOf')
		equals: 'why'.
	self
		assert: (never at: 'v31 Schema.items -> OPSchema>>items')
		equals: 'the model has no entity for the owners met'
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testAnOwnerWithoutEntityIsCountedNotReported [

	| coverage |
	coverage := self coverageOf: self documentStructure30.
	self
		assert: (coverage withoutEntityCountOf:
				 'v30 Parameter.schema -> OPParameter>>schema')
		equals: 4.
	self
		assert: (coverage comparedCountOf:
				 'v30 Parameter.schema -> OPParameter>>schema')
		equals: 7
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testNoRelationOfTheConformanceIsLeftWithoutARule [

	self assert: FamixOpenApiRelationRules notComparedRows isEmpty
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testTheMarkdownTableOfARelationReportListsTheFieldsCompared [

	| markdown |
	markdown := (self relationReportFor: self documentStructure30)
		            markdownSummary.
	self assert:
		('*| v30 Operation.parameters -> OPOperation>>parameters | 2 | 2 | 0 | 0 | 0 |*'
			 match: markdown)
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testTheRelationsNeverComparedAreListedWithTheirReason [

	| coverage list never |
	coverage := self coverageOf: self documentStructure30.
	list := FamixOpenApiRelationRules
		        neverComparedIn: coverage
		        version: #v30.
	never := list asDictionary.
	self
		assert:
		(never at: 'v30 Callback.{expression} -> OPCallback>>pathItems')
		equals: 'no owner met in the documents checked'.
	self deny: (never includesKey:
			 'v30 Operation.parameters -> OPOperation>>parameters').
	self assert: (list collect: #key) equals: (list collect: #key) sorted
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testTheRelationsOfASwagger2DocumentAreCompared [

	| coverage |
	coverage := self coverageOf: self documentStructureSwagger2.
	#( 'v2 MediaType.schema -> OPMediaType>>schema'
	   'v2 Parameter.content -> OPRequestBody>>content'
	   'v2 RequestBody.content -> OPRequestBody>>content'
	   'v2 SecurityScheme.flows -> OPSecurityScheme>>flows'
	   'v2 SecurityScheme.scopes -> OPOAuthFlow>>scopes'
	   'v2 Swagger.host -> OPOpenApi>>servers'
	   'v2 Swagger.definitions -> OPComponents>>schemas' ) do: [ :each |
		self assert: (coverage linkCountOf: each) > 0 description: each ].
	self assert: coverage totalLinks > 50
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testTheRelationsOfAnOpenApi30DocumentAreComparedPerOwnerWithTheirLinks [

	| coverage |
	coverage := self coverageOf: self documentStructure30.
	self
		assert: (coverage comparedCountOf:
				 'v30 Operation.parameters -> OPOperation>>parameters')
		equals: 2.
	self
		assert: (coverage linkCountOf:
				 'v30 Operation.parameters -> OPOperation>>parameters')
		equals: 6.
	self
		assert: (coverage informativeCountOf:
				 'v30 Operation.parameters -> OPOperation>>parameters')
		equals: 2.
	self
		assert: (coverage linkCountOf:
				 'v30 Operation.responses -> OPOperation>>responses')
		equals: 4.
	self
		assert: (coverage linkCountOf:
				 'v30 Schema.properties -> OPProperty>>valueSchema')
		equals: 2.
	self assert: coverage totalMismatched equals: 0.
	self assert: coverage totalDeferred equals: 0.
	self assert: coverage totalCompared > 150.
	self assert: coverage totalLinks > 50
]

{ #category : 'tests' }
FamixOpenApiRelationCoverageTest >> testTheRelationsOfAnOpenApi31DocumentAreCompared [

	| coverage |
	coverage := self coverageOf: self documentStructure31.
	#( 'v31 OpenAPI.webhooks -> OPOpenApi>>webhooks'
	   'v31 Components.pathItems -> OPComponents>>pathItems'
	   'v31 Schema.prefixItems -> OPSchema>>prefixItems'
	   'v31 Callback.{expression} -> OPCallback>>pathItems'
	   'v31 Link.operationId -> OPLink>>operation' ) do: [ :each |
		self assert: (coverage linkCountOf: each) > 0 description: each ].
	self assert: coverage totalLinks > 40
]
