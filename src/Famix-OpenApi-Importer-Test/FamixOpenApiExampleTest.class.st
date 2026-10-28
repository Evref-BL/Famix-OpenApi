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

{ #category : 'helpers' }
FamixOpenApiExampleTest >> mainConceptClasses [
	"Answer the classes of the main concepts of the canonical metamodel."

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
		  OPProperty.
		  OPDiscriminator.
		  OPDiscriminatorMapping.
		  OPSecurityScheme.
		  OPOAuthFlow.
		  OPSecurityScope.
		  OPSecurityRequirement.
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

	^ (model allWithType: OPSchema) detect: [ :each | each name = aName ]
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

{ #category : 'running' }
FamixOpenApiExampleTest >> testAnimalHasADiscriminatorWithTwoMappings [

	self
		assert:
		(self schemaNamed: 'Animal') discriminatorEntity mapping size
		equals: 2
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testCanonicalPointerOfComponentSchema [

	self
		assert: (self schemaNamed: 'Pet') canonicalPointer
		equals: '#/components/schemas/Pet'
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

{ #category : 'running' }
FamixOpenApiExampleTest >> testExportToJSON [

	self assert: (self exportedWith: #exportToJSONStream:) isNotEmpty
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testExportToMSE [

	self assert: (self exportedWith: #exportToMSEStream:) isNotEmpty
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

{ #category : 'running' }
FamixOpenApiExampleTest >> testOAuthScopesAreRequiredByTheCreatePetOperation [

	self
		assert:
			(self operationNamed: 'createPet') securityRequirements first
				securitySchemes first securityScopes size
		equals: 2
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

{ #category : 'running' }
FamixOpenApiExampleTest >> testReferenceIsStandalone [

	self assert:
		(model allWithType: OPReference) anyOne referrers isEmpty
]

{ #category : 'running' }
FamixOpenApiExampleTest >> testWebhookIsNotAmongThePaths [

	self assert: self openApi webhooks size equals: 1.
	self deny: (self openApi paths includesAll: self openApi webhooks)
]
