"
Tests of the example models built by OPModel class>>exampleSmallPetstore and OPModel class>>exampleMinimalApi: every main concept of the canonical metamodel is instantiated, shared references are reachable from their referrers, derived accessors work on the example and the example can be exported.
"
Class {
	#name : 'FamixOpenApiExampleTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'helpers' }
FamixOpenApiExampleTest >> exportedWith: aSelector [

	^ String streamContents: [ :stream |
		  model perform: aSelector with: stream ]
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> mainConceptClasses [
	"Answer the classes of the main concepts of the metamodel."

	^ {
		  OPOpenApi.
		  OPInfo.
		  OPContact.
		  OPLicense.
		  OPServer.
		  OPServerVariable.
		  OPTag.
		  OPExternalDocumentation.
		  OPComponents.
		  OPPath.
		  OPOperation.
		  OPParameter.
		  OPRequestBody.
		  OPResponse.
		  OPMediaType.
		  OPEncoding.
		  OPHeader.
		  OPExample.
		  OPLink.
		  OPCallback.
		  OPSchema.
		  OPSubSchema.
		  OPProperty.
		  OPDiscriminator.
		  OPDiscriminatorMapping.
		  OPXmlElement.
		  OPSecurityScheme.
		  OPOAuthFlow.
		  OPSecurityScope.
		  OPSecurityRequirement.
		  OPSecurityRequirementItem.
		  OPReference }
]

{ #category : 'helpers' }
FamixOpenApiExampleTest >> openApi [

	^ (model allWithType: OPOpenApi) anyOne
]

{ #category : 'helpers' }
FamixOpenApiExampleTest >> operationNamed: anOperationId [

	^ (model allWithType: OPOperation) detect: [ :each |
		  each operationId = anOperationId ]
]

{ #category : 'helpers' }
FamixOpenApiExampleTest >> schemaNamed: aName [
	^ (model allWithSubTypesOf: OPSchema) detect: [ :each | each name = aName ]
]

{ #category : 'running' }
FamixOpenApiExampleTest >> setUp [

	super setUp.
	model := OPModel exampleSmallPetstore
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testAllPropertiesFollowAllOf [

	self
		assert:
			((self schemaNamed: 'Pet') allProperties collect: #name) sorted
				asArray
		equals: #( 'id' 'name' 'status' 'tag' )
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testAnimalHasADiscriminatorWithTwoMappings [

	self
		assert: (self schemaNamed: 'Animal') discriminator mapping size
		equals: 2
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testCanonicalPointerIsUniqueExceptPropertyAndItsSchema [

	| entities shared |
	entities := model entities select: [ :each |
		            each canonicalPointer notNil ].
	shared := (entities groupedBy: [ :each | each canonicalPointer ])
		          select: [ :group | group size > 1 ].
	self assert: shared notEmpty.
	shared do: [ :group |
		self
			assert: (group collect: #class) asBag asSet
			equals: { OPProperty. OPSchema } asSet.
		self assert: group size equals: 2 ]
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testCanonicalPointerIsUniquePerResponse [

	| responses pointers |
	responses := model allWithType: OPResponse.
	pointers := responses collect: [ :each | each canonicalPointer ].
	self assert: (responses allSatisfy: [ :each | each canonicalPointer notNil ]).
	self assert: pointers asSet size equals: responses size
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testCanonicalPointerOfComponentSchema [

	self
		assert: (self schemaNamed: 'Pet') canonicalPointer
		equals: '#/components/schemas/Pet'
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testComponentsUseTheFinalRelationNames [

	| components |
	components := self openApi components.
	self assert: components schemas isNotEmpty.
	self assert: components responses isNotEmpty.
	self assert: components parameters isNotEmpty.
	self assert: components requestBodies isNotEmpty.
	self assert: components headers isNotEmpty.
	self assert: components examples isNotEmpty.
	self assert: components links isNotEmpty.
	self assert: components callbacks isNotEmpty.
	self assert: components securitySchemes size equals: 2
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testCreatePetRequiresTwoSecuritySchemesTogether [

	| requirement |
	requirement := (self operationNamed: 'createPet')
		               securityRequirements.
	self assert: requirement size equals: 1.
	self assert: requirement first items size equals: 2.
	self
		assert: (requirement first schemes collect: #name) asArray
		equals: #( 'petstore_auth' 'api_key' )
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testEffectiveParametersIncludePathParameter [

	self
		assert: (self operationNamed: 'getPet') effectiveParameters size
		equals: 1.
	self
		assert:
		(self operationNamed: 'getPet') effectiveParameters first name
		equals: 'petId'
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testEveryMainConceptHasAnInstance [

	| missing |
	missing := self mainConceptClasses reject: [ :each |
		           (model allWithType: each) isNotEmpty ].
	self
		assert: missing isEmpty
		description:
		'No instance of ' , (', ' join: (missing collect: #name))
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testExampleHasExactlyOneOpenApi [

	self assert: (model allWithType: OPOpenApi) size equals: 1
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testExampleIsAnOPModel [

	self assert: model class equals: OPModel
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testExampleIsNotEmpty [

	self assert: model size > 0
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testExclusiveBoundsAreNumbers [

	| packSize |
	packSize := (self schemaNamed: 'Dog') properties first valueSchema.
	self assert: packSize exclusiveMinimum equals: 0.
	self assert: packSize exclusiveMaximum equals: 1000.
	self assert: packSize exclusiveMinimum isNumber
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testExportToJSON [

	self assert: (self exportedWith: #exportToJSONStream:) isNotEmpty
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testExportToMSE [

	self assert: (self exportedWith: #exportToMSEStream:) isNotEmpty
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testFluffyExampleIsSharedByTwoMediaTypes [

	| example |
	example := (model allWithType: OPExample) detect: [ :each |
		           each name = 'FluffyExample' ].
	self assert: example usedByMediaTypes size equals: 2.
	self assert: example referrers size equals: 2.
	self assert: example components equals: self openApi components.
	self assert: (example usedByMediaTypes allSatisfy: [ :each |
			 each examples includes: example ])
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testLimitParameterIsReusableUnderComponents [

	| limit |
	limit := (model allWithType: OPParameter) detect: [ :each |
		         each name = 'limit' ].
	self
		assert: limit components
		identicalTo: (model allWithType: OPComponents) anyOne
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testLimitParameterIsSharedByTwoOperations [

	| limit |
	limit := (model allWithType: OPParameter) detect: [ :each |
		         each name = 'limit' ].
	self assert: limit usedByOperations size equals: 2
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testMinimalApiHasOneOperationAndOneResponse [

	model := OPModel exampleMinimalApi.
	self assert: (model allWithType: OPOpenApi) size equals: 1.
	self assert: (model allWithType: OPPath) size equals: 1.
	self assert: (model allWithType: OPOperation) size equals: 1.
	self assert: (model allWithType: OPResponse) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testNotFoundResponseIsCopiedForEachOperationThatUsesIt [

	| original getCopy deleteCopy |
	original := self openApi components responses detect: [ :each |
		            each name = 'NotFound' ].
	getCopy := (self operationNamed: 'getPet') responses detect: [ :each |
		           each statusCode = '404' ].
	deleteCopy := (self operationNamed: 'deletePet') responses detect: [
		              :each | each statusCode = '404' ].
	self deny: getCopy == deleteCopy.
	self deny: getCopy == original.
	self
		assert: getCopy operation
		equals: (self operationNamed: 'getPet').
	self
		assert: deleteCopy operation
		equals: (self operationNamed: 'deletePet').
	self assert: original operation isNil.
	self assert: original canonicalPointer equals: '#/components/responses/NotFound'.
	{
		getCopy.
		deleteCopy } do: [ :each |
		self assert: each ref equals: original canonicalPointer.
		self assert: each description equals: original description ].
	self
		assert: getCopy canonicalPointer
		equals: '#/paths/~1pets~1{petId}/get/responses/404'.
	self
		assert: deleteCopy canonicalPointer
		equals: '#/paths/~1pets~1{petId}/delete/responses/404'
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testOAuthScopesAreRequiredByTheCreatePetOperation [

	| oauthItem |
	oauthItem := (self operationNamed: 'createPet') securityRequirements
		             first items first.
	self assert: oauthItem scheme name equals: 'petstore_auth'.
	self assert: oauthItem scopeNames size equals: 2
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testOperationTagsAreResolvedFromTheOpenApi [

	self assert: (self operationNamed: 'listPets') tags size equals: 1.
	self
		assert: (self operationNamed: 'listPets') tags first name
		equals: 'pets'
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testOperationsOfOpenApiExcludeWebhookOperations [

	self assert: self openApi operations size equals: 5.
	self assert: (model allWithType: OPOperation) size equals: 8
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testOperationsWithoutSecurityDeclarationInheritTheOneOfTheDocument [

	self
		assert: (self operationNamed: 'getPet') effectiveSecurity asArray
		equals: self openApi securityRequirements asArray.
	self
		assert: (self operationNamed: 'createPet') effectiveSecurity asArray
		equals:
		(self operationNamed: 'createPet') securityRequirements asArray
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testPetEventCallbackIsSharedByTwoOperationsAndItsPathItemByTwoCallbacks [
	| callback pathItem |
	callback := (model allWithType: OPCallback) detect: [ :each |
		            each name = 'PetEvent' ].
	self assert: callback usedByOperations size equals: 2.
	pathItem := callback pathItems detect: [ :each |
		            each usedByCallbacks size = 2 ].
	self assert: (pathItem usedByCallbacks includes: callback).
	self assert: pathItem declaringOpenApi equals: self openApi.
	self assert: callback declaringOpenApi equals: self openApi.
	self assert: callback declaringOpenApis asArray equals: { self openApi }
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testPetSchemaHasAnXmlElement [

	| xml |
	xml := (self schemaNamed: 'Pet') xml.
	self assert: xml name equals: 'pet'.
	self assert: xml schema equals: (self schemaNamed: 'Pet').
	self assert: xml prefix equals: 'ps'
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testPetSchemaIsSharedByAtLeastTwoReferrers [

	self assert: (self schemaNamed: 'Pet') referrers size >= 2
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testPetSchemaIsTheItemOfPets [

	self
		assert: (self schemaNamed: 'Pets') items
		identicalTo: (self schemaNamed: 'Pet')
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testPetSummaryIsASubSchemaOfPet [
	| summary pet |
	summary := self schemaNamed: 'PetSummary'.
	pet := self schemaNamed: 'Pet'.
	self assert: summary class equals: OPSubSchema.
	self assert: (summary isKindOf: OPSchema).
	self assert: ((model allWithSubTypesOf: OPSchema) includes: summary).
	self deny: ((model allWithType: OPSchema) includes: summary).
	self assert: (model allWithType: OPSubSchema) asArray equals: { summary }.
	self assert: summary subSchemaOf equals: pet.
	self assert: pet subSchemas asArray equals: { summary }.
	self
		assert: (summary allProperties collect: #name) asSet
		equals: #( 'id' 'name' ) asSet.
	self
		assert: ((pet allProperties collect: #name) includesAll: #( 'id' 'name' )).
	self assert: summary referrers size equals: 1.
	self assert: summary referrers anyOne class equals: OPMediaType
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testRateLimitHeaderIsSharedByTwoResponses [
	| header responses |
	header := (model allWithType: OPHeader) detect: [ :each |
		          each name = 'X-Rate-Limit' ].
	responses := header usedByResponses.
	self assert: responses size equals: 2.
	self assert: (responses allSatisfy: [ :each | each headers includes: header ]).
	self assert: header components equals: self openApi components.
	self assert: header referrers size equals: 2.
	self assert: header usedByEncodings isEmpty
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testRateLimitSchemaKeepsTheMergedPointers [

	| header |
	header := (model allWithType: OPHeader) detect: [ :each |
		          each name = 'X-Rate-Limit' ].
	self assert: header schema mergedPointers size equals: 1.
	self deny:
		(header schema mergedPointers includes:
			 header schema canonicalPointer).
	self assert: (self schemaNamed: 'Pet') mergedPointers isEmpty
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testReferenceIsOwnedByTheOpenApiAndHasNoReferrer [

	| reference |
	reference := (model allWithType: OPReference) anyOne.
	self assert: reference openApi equals: self openApi.
	self
		assert: self openApi unresolvedReferences asArray
		equals: { reference }.
	self assert: reference referrers isEmpty
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testSearchPetsDisablesTheSecurityOfTheDocument [

	| search |
	search := self operationNamed: 'searchPets'.
	self assert: search securityDisabled.
	self assert: search securityRequirements isEmpty.
	self assert: search effectiveSecurity isEmpty.
	self deny: (self operationNamed: 'getPet') securityDisabled
]

{ #category : 'tests' }
FamixOpenApiExampleTest >> testSharedLinkIsUsedByTwoResponsesAndInlineLinkByOne [

	| shared inline |
	shared := (model allWithType: OPLink) detect: [ :each |
		          each name = 'GetPetByIdShared' ].
	inline := (model allWithType: OPLink) detect: [ :each |
		          each name = 'GetPetById' ].
	self assert: shared usedByResponses size equals: 2.
	self assert: shared components equals: self openApi components.
	self assert: inline usedByResponses size equals: 1.
	self assert: inline components isNil
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testWebhookIsNotAmongThePaths [

	self assert: self openApi webhooks size equals: 1.
	self deny: (self openApi paths includesAll: self openApi webhooks)
]
