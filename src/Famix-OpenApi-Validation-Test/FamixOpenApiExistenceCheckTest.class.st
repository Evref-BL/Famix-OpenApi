"
Tests of FamixOpenApiExistenceCheck on small documents imported by the real importer (OpenAPI 3.0, 3.1, Swagger 2; mergesInlineSchemas false). Every exception of the check is tested twice: positive (the faithful import has no gap) and negative (a MUTATED model - an entity removed, moved, replaced or added - gives the right kind of gap at the right pointer). The sweeps mutate every entity of every fixture, so that a check that no longer looks at some rule fails here.
"
Class {
	#name : 'FamixOpenApiExistenceCheckTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> add: aClass at: aPointer to: aModel [
	"Add a stray entity of aClass at aPointer"

	aModel add: (aClass new
			 canonicalPointer: aPointer;
			 yourself)
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> assertGapsOf: aJsonString after: aBlock are: anArray [
	"anArray holds the expected kind -> pointer associations, in any order"

	self
		assert: (self gapsOf: aJsonString after: aBlock)
		equals: (anArray collect: [ :each |
				 self describeKind: each key pointer: each value ]) asArray sorted
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> describeKind: aKind pointer: aPointer [

	^ aKind asString , ' ' , aPointer asString
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> entity: aClass at: aPointer in: aModel [
	"The only entity of exactly aClass at aPointer"

	| found |
	found := self entityOf: aClass at: aPointer in: aModel.
	self assert: found size equals: 1.
	^ found first
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> gapsOf: aJsonString after: aBlock [
	"The gaps of the model of aJsonString mutated by aBlock (given the model), as sorted 'kind pointer' Strings"

	| model |
	model := self modelOf: aJsonString.
	aBlock value: model.
	^ ((self reportOf: model for: aJsonString) gaps collect: [ :each |
		   self describeKind: each kind pointer: each sourcePointer ])
		  asArray sorted
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> move: aClass at: aPointer to: aNewPointer in: aModel [

	(self entity: aClass at: aPointer in: aModel) canonicalPointer:
		aNewPointer
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> remove: aClass at: aPointer from: aModel [

	aModel remove: (self entity: aClass at: aPointer in: aModel)
]

{ #category : 'mutations' }
FamixOpenApiExistenceCheckTest >> replace: aClass at: aPointer with: anotherClass in: aModel [
	"Replace the entity of aClass at aPointer by one of anotherClass at the same pointer"

	self remove: aClass at: aPointer from: aModel.
	self add: anotherClass at: aPointer to: aModel
]

{ #category : 'tests - sweeps' }
FamixOpenApiExistenceCheckTest >> testAStrayEntityAtAnyNodeIsReportedAsExtra [

	self allDocuments do: [ :each |
		self assertStraysAreDetectedIn: each value named: each key ]
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testBodyParameterNeedsItsRequestBodyAndFormDataHasNoneAtItsPointer [

	| doc |
	doc := self documentSwagger2.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPRequestBody
				at: '#/paths/~1b/get/parameters/1'
				from: model ]
		are: { (#missingEntity -> '#/paths/~1b/get/parameters/1') }.
	{
		(OPRequestBody -> '#/paths/~1b/get/parameters/2').
		(OPParameter -> '#/paths/~1b/get/parameters/2') } do: [ :each |
		self
			assertGapsOf: doc
			after: [ :model | self add: each key at: each value to: model ]
			are: { (#extraEntity -> each value) } ]
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testBooleanSchemasGiveEntitiesOnlyAsComponentsOrProperties [

	| doc |
	doc := self documentOpenApi30.
	self
		assertGapsOf: doc
		after: [ :model |
			self remove: OPSchema at: '#/components/schemas/Bool' from: model ]
		are: { (#missingEntity -> '#/components/schemas/Bool') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				add: OPSchema
				at: '#/components/schemas/A/properties/s'
				to: model ]
		are: { (#extraEntity -> '#/components/schemas/A/properties/s') }.
	self
		assertGapsOf: self documentOpenApi30Scalars
		after: [ :model |
			self
				add: OPSchema
				at: '#/paths/~1z/get/responses/200/content/a~1b/schema/items'
				to: model ]
		are: { (#extraEntity
			 -> '#/paths/~1z/get/responses/200/content/a~1b/schema/items') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testClonedResponseAndPathItemAreRequired [

	| doc |
	doc := self documentOpenApi30.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPResponse
				at: '#/paths/~1b/get/responses/200'
				from: model ]
		are: { (#missingEntity -> '#/paths/~1b/get/responses/200') }.
	self
		assertGapsOf: doc
		after: [ :model | self remove: OPPath at: '#/paths/~1a' from: model ]
		are: { (#missingEntity -> '#/paths/~1a') }.
	self
		assertGapsOf: doc
		after: [ :model |
		self remove: OPReference at: '#/paths/~1a' from: model ]
		are: { (#referenceNotResolved -> '#/paths/~1a') }
]

{ #category : 'tests - synthetic' }
FamixOpenApiExistenceCheckTest >> testClonedSubtreesAreAcceptedBelowTheCloneSiteOnly [

	| doc |
	doc := self documentOpenApi31.
	self
		assertGapsOf: doc
		after: [ :model |
		self add: OPOperation at: '#/paths/~1a/put' to: model ]
		are: #(  ).
	self
		assertGapsOf: doc
		after: [ :model |
		self add: OPOperation at: '#/paths/~1c/put' to: model ]
		are: { (#extraEntity -> '#/paths/~1c/put') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testComponentAliasOfAResponseHasNoEntity [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self add: OPResponse at: '#/components/responses/RA' to: model ]
		are: { (#extraEntity -> '#/components/responses/RA') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testContainersHaveNoEntity [

	| doc |
	doc := self documentOpenApi30.
	{
		(OPPath -> '#/paths').
		(OPResponse -> '#/paths/~1b/get/responses').
		(OPSecurityScheme -> '#/components/securitySchemes/oa/flows') } do: [
		:each |
		self
			assertGapsOf: doc
			after: [ :model | self add: each key at: each value to: model ]
			are: { (#extraEntity -> each value) } ]
]

{ #category : 'tests - positive' }
FamixOpenApiExistenceCheckTest >> testDiagnosticsAreOptional [

	| doc |
	doc := self documentOpenApi30.
	self assert: (FamixOpenApiExistenceCheck
			 checkInventory: (self inventoryOf: doc)
			 model: (self modelOf: doc)
			 diagnostics: nil) isEmpty.
	self assert: (FamixOpenApiExistenceCheck
			 checkInventory: (self inventoryOf: doc)
			 model: (self modelOf: doc)
			 diagnostics: #(  )) isEmpty
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testDroppedBodyParametersOfSwagger2GiveNoEntity [

	| doc |
	doc := self documentSwagger2Parameters.
	{
		(OPParameter -> '#/paths/~1b/parameters/0').
		(OPSchema -> '#/paths/~1b/parameters/0/schema').
		(OPRequestBody -> '#/paths/~1b/post/parameters/1').
		(OPSchema -> '#/paths/~1b/post/parameters/1/schema') } do: [ :each |
		self
			assertGapsOf: doc
			after: [ :model | self add: each key at: each value to: model ]
			are: { (#extraEntity -> each value) } ]
]

{ #category : 'tests - sweeps' }
FamixOpenApiExistenceCheckTest >> testDuplicatingAnyEntityAtANodeIsReported [

	self allDocuments do: [ :each |
		self assertDuplicatesAreDetectedIn: each value named: each key ]
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testEntityOfAnotherFamilyIsMissingAndExtra [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self
				replace: OPInfo
				at: '#/info'
				with: OPTag
				in: model ]
		are: {
				(#missingEntity -> '#/info').
				(#extraEntity -> '#/info') }
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testEntityWithoutPointerIsReported [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model | model add: OPInfo new ]
		are: { (#extraEntity -> nil) }
]

{ #category : 'tests - servers' }
FamixOpenApiExistenceCheckTest >> testExtraServerIsACountMismatch [

	self
		assertGapsOf: self documentOpenApi30Scalars
		after: [ :model | self add: OPServer at: '#/servers/1' to: model ]
		are: { (#countMismatch -> '#/servers') }
]

{ #category : 'tests - positive' }
FamixOpenApiExistenceCheckTest >> testFaithfulImportsHaveNoGap [

	self allDocuments do: [ :each |
		| report |
		report := self reportFor: each value.
		self assert: report isEmpty description: (self describe: {
					 each key.
					 report gaps }) ]
]

{ #category : 'tests - positive' }
FamixOpenApiExistenceCheckTest >> testFileIsStampedOnTheGaps [

	| doc model report |
	doc := self documentOpenApi30.
	model := self modelOf: doc.
	self remove: OPInfo at: '#/info' from: model.
	report := (FamixOpenApiExistenceCheck new
		           file: 'a.json';
		           yourself)
		          checkInventory: (self inventoryOf: doc)
		          model: model
		          diagnostics: nil.
	self assert: report gaps first file equals: 'a.json'
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testItemsOfSwagger2GiveNoEntityAtTheirOwnPointer [

	| doc |
	doc := self documentSwagger2.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				add: OPSchema
				at: '#/paths/~1b/get/parameters/0/items'
				to: model ]
		are: { (#extraEntity -> '#/paths/~1b/get/parameters/0/items') }
]

{ #category : 'tests - preconditions' }
FamixOpenApiExistenceCheckTest >> testMergedImportIsAPreconditionFindingAndNothingElse [

	| doc model report |
	doc := FamixOpenApiValidatorTestCase new richDocument.
	model := self modelOf: doc merging: true.
	report := self reportOf: model for: doc.
	self assert: report size equals: 1.
	self assert: report gaps first kind equals: #preconditionMerged.
	self assert:
		(report gaps first message includesSubstring: 'mergesInlineSchemas')
]

{ #category : 'tests - servers' }
FamixOpenApiExistenceCheckTest >> testMissingDefaultServerIsACountMismatch [

	self
		assertGapsOf: self documentOpenApi30Scalars
		after: [ :model |
		self remove: OPServer at: '#/servers/0' from: model ]
		are: { (#countMismatch -> '#/servers') }
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testMissingEntityIsReported [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model | self remove: OPInfo at: '#/info' from: model ]
		are: { (#missingEntity -> '#/info') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testMissingOPReferenceOfAnUnresolvedRefIsReported [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self remove: OPReference at: '#/paths/~1b/parameters/1' from: model ]
		are: { (#referenceNotResolved -> '#/paths/~1b/parameters/1') }
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testMovedEntityIsMissingAtItsNodeAndExtraAtItsNewPointer [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self
				move: OPContact
				at: '#/info/contact'
				to: '#/zzz'
				in: model ]
		are: {
				(#missingEntity -> '#/info/contact').
				(#extraEntity -> '#/zzz') }
]

{ #category : 'tests - sweeps' }
FamixOpenApiExistenceCheckTest >> testMovingAnyEntityAwayIsReportedAsExtra [

	self allDocuments do: [ :each |
		self assertMovesAreDetectedIn: each value named: each key ]
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testOAuth2SchemeNeedsItsFlowInSwagger2 [

	self
		assertGapsOf: self documentSwagger2
		after: [ :model |
			self remove: OPOAuthFlow at: '#/securityDefinitions/oa' from: model ]
		are: { (#missingEntity -> '#/securityDefinitions/oa') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testOPReferenceAtAResolvedRefIsExtra [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self add: OPReference at: '#/paths/~1b/parameters/0' to: model ]
		are: { (#extraEntity -> '#/paths/~1b/parameters/0') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testPropertiesNeedTheirOPPropertyAndOnlyInlineOnesTheirSchema [

	| doc |
	doc := self documentOpenApi30.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPProperty
				at: '#/components/schemas/A/properties/p'
				from: model ]
		are: { (#missingEntity -> '#/components/schemas/A/properties/p') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPSchema
				at: '#/components/schemas/A/properties/r'
				from: model ]
		are: { (#missingEntity -> '#/components/schemas/A/properties/r') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				add: OPSchema
				at: '#/components/schemas/A/properties/p'
				to: model ]
		are: { (#extraEntity -> '#/components/schemas/A/properties/p') }
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testRefToABodyParameterNeedsItsRequestBodyAtTheSite [

	| doc |
	doc := self documentSwagger2Parameters.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPRequestBody
				at: '#/paths/~1b/delete/parameters/0'
				from: model ]
		are: { (#missingEntity -> '#/paths/~1b/delete/parameters/0') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				add: OPRequestBody
				at: '#/paths/~1b/put/parameters/1'
				to: model ]
		are: { (#extraEntity -> '#/paths/~1b/put/parameters/1') }
]

{ #category : 'tests - sweeps' }
FamixOpenApiExistenceCheckTest >> testRemovingAnyEntityAtANodeIsReportedAsMissing [

	self allDocuments do: [ :each |
		self assertRemovalsAreDetectedIn: each value named: each key ]
]

{ #category : 'tests - positive' }
FamixOpenApiExistenceCheckTest >> testReportCountsNodesExpectedAndFoundEntities [

	| report |
	report := self reportFor: self documentOpenApi30.
	self assert: (report nodeCountsBySpecObject at: 'Info') equals: 1.
	self assert: (report expectedCountsBySpecObject at: 'Info') equals: 1.
	self assert: (report foundCountsBySpecObject at: 'Info') equals: 1.
	self assert: (report nodeCountsBySpecObject at: 'Paths') equals: 1.
	self
		assert: (report expectedCountsBySpecObject at: 'Paths')
		equals: 0.
	self
		assert: (report expectedCountsBySpecObject at: 'Schema')
		equals: (report foundCountsBySpecObject at: 'Schema')
]

{ #category : 'tests - positive' }
FamixOpenApiExistenceCheckTest >> testReportCountsTheSyntheticEntitiesByRule [

	| report |
	report := self reportFor: self documentSwagger2.
	self
		assert: (report syntheticCountsByRule at: #synthesizedServer)
		equals: 2.
	self
		assert: (report syntheticCountsByRule at: #swagger2Components)
		equals: 1.
	self
		assert: (report syntheticCountsByRule at: #securityScope)
		equals: 2.
	self
		assert: (report syntheticCountsByRule at: #swagger2Discriminator)
		equals: 1
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testSchemaAliasIsRequiredAndSchemaRefsInsideSchemasHaveNoEntity [

	| doc |
	doc := self documentOpenApi30.
	self
		assertGapsOf: doc
		after: [ :model |
			self remove: OPSchema at: '#/components/schemas/Alias' from: model ]
		are: { (#missingEntity -> '#/components/schemas/Alias') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				add: OPSchema
				at: '#/components/schemas/A/additionalProperties'
				to: model ]
		are:
		{ (#extraEntity -> '#/components/schemas/A/additionalProperties') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				add: OPSchema
				at: '#/components/schemas/A/properties/r/items'
				to: model ]
		are:
		{ (#extraEntity -> '#/components/schemas/A/properties/r/items') }
]

{ #category : 'tests - 3.1' }
FamixOpenApiExistenceCheckTest >> testSchemaWithSiblingsIsRequiredInOpenApi31AndRefusedInOpenApi30 [

	| path |
	path := '#/paths/~1c/post/responses/200/content/a~1b/schema'.
	self
		assertGapsOf: (self documentWithSiblingsIn: '3.1.0')
		after: [ :model | self remove: OPSchema at: path from: model ]
		are: { (#missingEntity -> path) }.
	self
		assertGapsOf: (self documentWithSiblingsIn: '3.0.3')
		after: [ :model | self add: OPSchema at: path to: model ]
		are: { (#extraEntity -> path) }
]

{ #category : 'tests - 3.1' }
FamixOpenApiExistenceCheckTest >> testSchemasOfKeywordsTheImporterDoesNotReadHaveNoEntity [

	| doc |
	doc := self documentOpenApi31.
	#( '#/components/schemas/S/$defs/D' '#/components/schemas/S/$defs/D/properties/dd'
	   '#/components/schemas/S/if' '#/components/schemas/S/patternProperties/^x' )
		do: [ :pointer |
			self
				assertGapsOf: doc
				after: [ :model | self add: OPSchema at: pointer to: model ]
				are: { (#extraEntity -> pointer) } ]
]

{ #category : 'tests - servers' }
FamixOpenApiExistenceCheckTest >> testServersOfTheDocumentAreNotSynthetic [
	"A document that declares its servers (nodes) expects no server without node: one is a count mismatch"

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model | self add: OPServer at: '#/servers/1' to: model ]
		are: { (#countMismatch -> '#/servers') }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testSharedObjectsHaveNoEntityAtTheirUseSite [

	| doc |
	doc := self documentOpenApi30.
	{
		(OPParameter -> '#/paths/~1b/parameters/0').
		(OPRequestBody -> '#/paths/~1b/get/requestBody').
		(OPCallback -> '#/paths/~1b/get/callbacks/cb').
		(OPHeader -> '#/paths/~1b/get/responses/202/headers/h1').
		(OPLink -> '#/paths/~1b/get/responses/202/links/l1').
		(OPExample -> '#/paths/~1b/get/parameters/0/examples/e2') } do: [
		:each |
		self
			assertGapsOf: doc
			after: [ :model | self add: each key at: each value to: model ]
			are: { (#extraEntity -> each value) } ]
]

{ #category : 'tests - synthetic' }
FamixOpenApiExistenceCheckTest >> testStrayEntitiesLookingLikeSyntheticOnesAreExtra [

	| doc |
	doc := self documentOpenApi30.
	{
		(OPExample -> '#/components/parameters/P/example').
		(OPSecurityScope
		 -> '#/components/securitySchemes/oa/flows/implicit/scopes/zzz').
		(OPSecurityRequirementItem -> '#/paths/~1b/post/security/0/zzz').
		(OPDiscriminatorMapping
		 -> '#/components/schemas/A/discriminator/mapping/zzz').
		(OPSchema -> '#/paths/~1b/get/zzz') } do: [ :each |
		self
			assertGapsOf: doc
			after: [ :model | self add: each key at: each value to: model ]
			are: { (#extraEntity -> each value) } ]
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testStrayEntityWithoutNodeIsReported [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model | self add: OPInfo at: '#/zzz' to: model ]
		are: { (#extraEntity -> '#/zzz') }
]

{ #category : 'tests - preconditions' }
FamixOpenApiExistenceCheckTest >> testSubSchemaOrMergedPointersAreEnoughForThePrecondition [

	| doc |
	doc := self documentOpenApi30.
	self
		assertGapsOf: doc
		after: [ :model | self add: OPSubSchema at: '#/zzz' to: model ]
		are: { (#preconditionMerged -> '#') }.
	self
		assertGapsOf: doc
		after: [ :model |
			(self entity: OPSchema at: '#/components/schemas/B' in: model)
				mergedPointers: #( '#/x' ) ]
		are: { (#preconditionMerged -> '#') }
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testSwagger2ClonedResponseAndReferences [

	| doc |
	doc := self documentSwagger2.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPResponse
				at: '#/paths/~1b/get/responses/201'
				from: model ]
		are: { (#missingEntity -> '#/paths/~1b/get/responses/201') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self
				remove: OPReference
				at: '#/paths/~1b/get/responses/202'
				from: model ]
		are: { (#referenceNotResolved -> '#/paths/~1b/get/responses/202') }.
	self
		assertGapsOf: doc
		after: [ :model |
		self add: OPResponse at: '#/responses/RA' to: model ]
		are: { (#extraEntity -> '#/responses/RA') }
]

{ #category : 'tests - servers' }
FamixOpenApiExistenceCheckTest >> testSwagger2ServersNeedTheirNumberAndUrls [

	| doc |
	doc := self documentSwagger2.
	self
		assertGapsOf: doc
		after: [ :model |
		self remove: OPServer at: '#/servers/1' from: model ]
		are: { (#countMismatch -> '#/servers') }.
	self
		assertGapsOf: doc
		after: [ :model |
			(self entity: OPServer at: '#/servers/1' in: model) url:
				'https://h.com/w' ]
		are: { (#valueMismatch -> '#/servers/1') }.
	self
		assertGapsOf: doc
		after: [ :model |
			(self entity: OPServer at: '#/servers/0' in: model) url:
				'https://h.com/v'.
			(self entity: OPServer at: '#/servers/1' in: model) url:
				'http://h.com/v' ]
		are: {
				(#valueMismatch -> '#/servers/0').
				(#valueMismatch -> '#/servers/1') }
]

{ #category : 'tests - swagger 2' }
FamixOpenApiExistenceCheckTest >> testSwagger2SyntheticEntitiesAreRefusedWhenTheSourceDoesNotJustifyThem [

	| doc |
	doc := self documentSwagger2.
	{
		(OPSchema -> '#/paths/~1b/get/parameters/0/schema/items/items/items').
		(OPMediaType -> '#/responses/R/content/application~1zzz').
		(OPDiscriminator -> '#/definitions/B/discriminator').
		(OPRequestBody -> '#/definitions/A/requestBody').
		(OPComponents -> '#/zzz') } do: [ :each |
		self
			assertGapsOf: doc
			after: [ :model | self add: each key at: each value to: model ]
			are: { (#extraEntity -> each value) } ]
]

{ #category : 'tests - synthetic' }
FamixOpenApiExistenceCheckTest >> testSyntheticEntitiesAreAcceptedButNotRequired [
	"Limit of this level: a synthetic entity that the importer forgets is not a gap (the reverse direction only accepts them); the servers are the exception"

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self
				remove: OPExample
				at: '#/paths/~1b/get/parameters/0/example'
				from: model.
			self
				remove: OPDiscriminatorMapping
				at: '#/components/schemas/A/discriminator/mapping/b'
				from: model ]
		are: #(  )
]

{ #category : 'tests - preconditions' }
FamixOpenApiExistenceCheckTest >> testTheSameDocumentImportedWithoutMergingIsFaithful [

	self assert:
		(self reportFor: FamixOpenApiValidatorTestCase new richDocument)
			isEmpty
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testTwoEntitiesOfTheFamilyAreReported [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model | self add: OPInfo at: '#/info' to: model ]
		are: { (#unexpectedMultiple -> '#/info') }
]

{ #category : 'tests - preconditions' }
FamixOpenApiExistenceCheckTest >> testUnknownVersionIsAPreconditionFinding [

	| report |
	report := self reportFor:
		          '{"openapi":"3.10.0","info":{"title":"t","version":"1"},"paths":{}}'.
	self assert: report size equals: 1.
	self assert: report gaps first kind equals: #preconditionVersion
]

{ #category : 'tests - 3.1' }
FamixOpenApiExistenceCheckTest >> testUnresolvedRefWithSiblingsNeedsBothEntitiesInOpenApi31 [

	| path doc |
	path := '#/paths/~1c/post/responses/200/content/c~1d/schema/allOf/1'.
	doc := self documentWithSiblingsIn: '3.1.0'.
	self
		assertGapsOf: doc
		after: [ :model | self remove: OPSchema at: path from: model ]
		are: { (#missingEntity -> path) }.
	self
		assertGapsOf: doc
		after: [ :model | self remove: OPReference at: path from: model ]
		are: { (#referenceNotResolved -> path) }
]

{ #category : 'tests - references' }
FamixOpenApiExistenceCheckTest >> testUnresolvedReferenceDiagnosticCoversTheMissingOPReference [

	| doc model pointer |
	doc := self documentOpenApi30.
	pointer := '#/paths/~1b/parameters/1'.
	model := self modelOf: doc.
	self remove: OPReference at: pointer from: model.
	self assert: (self
			 reportOf: model
			 for: doc
			 diagnostics: { (FamixOpenApiStubDiagnostic
					  code: #unresolvedReference
					  pointer: pointer) }) isEmpty.
	self
		assert: (self
				 reportOf: model
				 for: doc
				 diagnostics: { (FamixOpenApiStubDiagnostic
						  code: #unresolvedReference
						  pointer: '#/elsewhere') }) size
		equals: 1.
	self
		assert: (self
				 reportOf: model
				 for: doc
				 diagnostics:
				 { (FamixOpenApiStubDiagnostic
					  code: #componentAlias
					  pointer: pointer) }) size
		equals: 1
]

{ #category : 'tests - 3.1' }
FamixOpenApiExistenceCheckTest >> testWebhooksAndPathItemClonesOfOpenApi31 [

	| doc |
	doc := self documentOpenApi31.
	self
		assertGapsOf: doc
		after: [ :model |
		self remove: OPPath at: '#/webhooks/w2' from: model ]
		are: { (#missingEntity -> '#/webhooks/w2') }.
	self
		assertGapsOf: doc
		after: [ :model | self remove: OPPath at: '#/paths/~1a' from: model ]
		are: { (#missingEntity -> '#/paths/~1a') }.
	self
		assertGapsOf: doc
		after: [ :model |
			self add: OPPath at: '#/components/pathItems/PI2' to: model ]
		are: { (#extraEntity -> '#/components/pathItems/PI2') }
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testWrongClassOfTheRightFamilyIsReported [

	self
		assertGapsOf: self documentOpenApi30
		after: [ :model |
			self
				replace: OPSchema
				at: '#/components/schemas/B'
				with: FamixOpenApiStubSchema
				in: model ]
		are: { (#wrongClass -> '#/components/schemas/B') }
]

{ #category : 'tests - servers' }
FamixOpenApiExistenceCheckTest >> testWrongPointerOfTheDefaultServerIsAValueMismatch [

	self
		assertGapsOf: self documentOpenApi30Scalars
		after: [ :model |
			self
				move: OPServer
				at: '#/servers/0'
				to: '#/servers/3'
				in: model ]
		are: { (#valueMismatch -> '#/servers/3') }
]

{ #category : 'tests - negative' }
FamixOpenApiExistenceCheckTest >> testWrongShapeNodeGivesNoEntity [

	| doc |
	doc := '{"openapi":"3.0.3","info":"text","paths":{}}'.
	self assert: (self reportFor: doc) isEmpty.
	self
		assertGapsOf: doc
		after: [ :model | self add: OPInfo at: '#/info' to: model ]
		are: { (#extraEntity -> '#/info') }
]

{ #category : 'tests - servers' }
FamixOpenApiExistenceCheckTest >> testWrongUrlOfTheDefaultServerIsAValueMismatch [

	self
		assertGapsOf: self documentOpenApi30Scalars
		after: [ :model |
			(self entity: OPServer at: '#/servers/0' in: model) url:
				'http://other' ]
		are: { (#valueMismatch -> '#/servers/0') }
]
