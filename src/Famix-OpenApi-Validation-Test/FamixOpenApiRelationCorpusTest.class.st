"
The relation check (V10) on the 20 files of the corpus (/Users/nicolas.hlad/Documents/Pharo/images/openapi-vibe/test-corpus, skipped when absent), imported without merging, with the diagnostics of the import: the gaps are exactly the frozen list of the REAL importer findings (none: the importer holds in every relation what the source designates), the relation rows that are compared stay compared, the totals have conservative lower bounds, and the mutation sweep detects the change of every relation of three files, one per version.
"
Class {
	#name : 'FamixOpenApiRelationCorpusTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiRelationCorpusTest >> defaultTimeLimit [
	"The sweeps change every relation of the 20 files in turn (about 20000 changes, a few seconds)"

	^ 3 minutes
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> deferredFrequencies [
	"The frequencies of the fields that the extensions check deferred, summed on the files of the corpus"

	| report |
	report := FamixOpenApiExtensionsReport new.
	self specFiles do: [ :file |
		| importer model |
		importer := FamixOpenApiImporter new
			            mergesInlineSchemas: false;
			            yourself.
		model := importer importFromString: file contents.
		report mergeWith: (FamixOpenApiExtensionsCheck new
				 checkInventory: (self inventoryOf: file contents)
				 model: model
				 diagnostics: importer diagnostics) extensions ].
	^ report sortedAllFields select: [ :each | each deferredCount > 0 ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> documentSelectors [
	"The small documents of the tests that have relations to compare"

	^ #( #documentStructure30 #documentRefs30 #documentUnresolved30
	     #documentSharedKinds30 #documentStructure31 #documentSecurity31
	     #documentSharedKinds31 #documentCallbacks31 #documentStructureSwagger2
	     #documentParametersSwagger2 #documentDuplicatesSwagger2 #documentDuplicateOperationIds30
	     #documentUnresolvedSwagger2 #documentFormsSwagger2 )
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> frozenGaps [
	"Rows: file name, pointer, kind, field, expected, found. Empty: the importer holds in every relation compared what the source designates (every pattern that the first runs gave was a rule of the check to write, none was a finding of the importer). The importer was not changed to get there"

	^ #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> mergedCoverage [

	| coverage |
	coverage := FamixOpenApiCoverage new.
	self reports do: [ :each | coverage mergeWith: each value coverage ].
	^ coverage
]

{ #category : 'data' }
FamixOpenApiRelationCorpusTest >> relationKeysComparedInTheCorpus [
	"The coverage keys of the relations (version, spec object, field, class and relation) that the check compared in the 20 files, each at least once: each one must stay compared. Frozen on 158 keys"

	^ #('v2 Info.contact -> OPInfo>>contact' 'v2 Info.license -> OPInfo>>license' 'v2 MediaType.schema -> OPMediaType>>schema' 'v2 Operation.externalDocs -> OPOperation>>externalDocs' 'v2 Operation.parameters -> OPOperation>>parameters' 'v2 Operation.requestBody -> OPOperation>>requestBody' 'v2 Operation.responses -> OPOperation>>responses' 'v2 Operation.security -> OPOperation>>securityRequirements' 'v2 Parameter.content -> OPRequestBody>>content' 'v2 Parameter.schema -> OPParameter>>schema' 'v2 PathItem.operations -> OPPath>>operations' 'v2 PathItem.parameters -> OPPath>>parameters' 'v2 RequestBody.content -> OPRequestBody>>content' 'v2 Response.content -> OPResponse>>content' 'v2 Response.headers -> OPResponse>>headers' 'v2 Schema.additionalProperties -> OPSchema>>additionalProperties' 'v2 Schema.allOf -> OPSchema>>allOf' 'v2 Schema.discriminator -> OPSchema>>discriminator' 'v2 Schema.externalDocs -> OPSchema>>externalDocs' 'v2 Schema.items -> OPSchema>>items' 'v2 Schema.properties -> OPProperty>>valueSchema' 'v2 Schema.properties -> OPSchema>>properties' 'v2 Schema.xml -> OPSchema>>xml' 'v2 SecurityRequirement.{name} -> OPSecurityRequirement>>items' 'v2 SecurityRequirement.{name} -> OPSecurityRequirementItem>>scheme' 'v2 SecurityScheme.flows -> OPSecurityScheme>>flows' 'v2 SecurityScheme.scopes -> OPOAuthFlow>>scopes' 'v2 Swagger.$ref -> OPOpenApi>>unresolvedReferences' 'v2 Swagger.components -> OPOpenApi>>components' 'v2 Swagger.definitions -> OPComponents>>schemas' 'v2 Swagger.externalDocs -> OPOpenApi>>externalDocs' 'v2 Swagger.host -> OPOpenApi>>servers' 'v2 Swagger.info -> OPOpenApi>>info' 'v2 Swagger.parameters -> OPComponents>>parameters' 'v2 Swagger.paths -> OPOpenApi>>paths' 'v2 Swagger.responses -> OPComponents>>responses' 'v2 Swagger.security -> OPOpenApi>>securityRequirements' 'v2 Swagger.securityDefinitions -> OPComponents>>securitySchemes' 'v2 Swagger.tags -> OPOpenApi>>tags' 'v2 Tag.externalDocs -> OPTag>>externalDocs' 'v30 Callback.{expression} -> OPCallback>>pathItems' 'v30 Components.callbacks -> OPComponents>>callbacks' 'v30 Components.examples -> OPComponents>>examples' 'v30 Components.headers -> OPComponents>>headers' 'v30 Components.links -> OPComponents>>links' 'v30 Components.parameters -> OPComponents>>parameters' 'v30 Components.requestBodies -> OPComponents>>requestBodies' 'v30 Components.responses -> OPComponents>>responses' 'v30 Components.schemas -> OPComponents>>schemas' 'v30 Components.securitySchemes -> OPComponents>>securitySchemes' 'v30 Header.schema -> OPHeader>>schema' 'v30 Info.contact -> OPInfo>>contact' 'v30 Info.license -> OPInfo>>license' 'v30 Link.operationId -> OPLink>>operation' 'v30 Link.server -> OPLink>>server' 'v30 MediaType.encoding -> OPMediaType>>encodings' 'v30 MediaType.examples -> OPMediaType>>examples' 'v30 MediaType.schema -> OPMediaType>>schema' 'v30 OAuthFlow.scopes -> OPOAuthFlow>>scopes' 'v30 OpenAPI.$ref -> OPOpenApi>>unresolvedReferences' 'v30 OpenAPI.components -> OPOpenApi>>components' 'v30 OpenAPI.externalDocs -> OPOpenApi>>externalDocs' 'v30 OpenAPI.info -> OPOpenApi>>info' 'v30 OpenAPI.paths -> OPOpenApi>>paths' 'v30 OpenAPI.security -> OPOpenApi>>securityRequirements' 'v30 OpenAPI.servers -> OPOpenApi>>servers' 'v30 OpenAPI.tags -> OPOpenApi>>tags' 'v30 Operation.callbacks -> OPOperation>>callbacks' 'v30 Operation.externalDocs -> OPOperation>>externalDocs' 'v30 Operation.parameters -> OPOperation>>parameters' 'v30 Operation.requestBody -> OPOperation>>requestBody' 'v30 Operation.responses -> OPOperation>>responses' 'v30 Operation.security -> OPOperation>>securityRequirements' 'v30 Operation.servers -> OPOperation>>servers' 'v30 Parameter.content -> OPParameter>>content' 'v30 Parameter.examples -> OPParameter>>examples' 'v30 Parameter.schema -> OPParameter>>schema' 'v30 PathItem.operations -> OPPath>>operations' 'v30 PathItem.parameters -> OPPath>>parameters' 'v30 PathItem.servers -> OPPath>>servers' 'v30 RequestBody.content -> OPRequestBody>>content' 'v30 Response.content -> OPResponse>>content' 'v30 Response.headers -> OPResponse>>headers' 'v30 Response.links -> OPResponse>>links' 'v30 Schema.additionalProperties -> OPSchema>>additionalProperties' 'v30 Schema.allOf -> OPSchema>>allOf' 'v30 Schema.anyOf -> OPSchema>>anyOf' 'v30 Schema.discriminator -> OPSchema>>discriminator' 'v30 Schema.externalDocs -> OPSchema>>externalDocs' 'v30 Schema.items -> OPSchema>>items' 'v30 Schema.not -> OPSchema>>not' 'v30 Schema.oneOf -> OPSchema>>oneOf' 'v30 Schema.properties -> OPProperty>>valueSchema' 'v30 Schema.properties -> OPSchema>>properties' 'v30 Schema.xml -> OPSchema>>xml' 'v30 SecurityRequirement.{name} -> OPSecurityRequirement>>items' 'v30 SecurityRequirement.{name} -> OPSecurityRequirementItem>>scheme' 'v30 SecurityScheme.flows -> OPSecurityScheme>>flows' 'v30 Server.variables -> OPServer>>variables' 'v30 Tag.externalDocs -> OPTag>>externalDocs' 'v31 Components.callbacks -> OPComponents>>callbacks' 'v31 Components.examples -> OPComponents>>examples' 'v31 Components.headers -> OPComponents>>headers' 'v31 Components.links -> OPComponents>>links' 'v31 Components.parameters -> OPComponents>>parameters' 'v31 Components.pathItems -> OPComponents>>pathItems' 'v31 Components.requestBodies -> OPComponents>>requestBodies' 'v31 Components.responses -> OPComponents>>responses' 'v31 Components.schemas -> OPComponents>>schemas' 'v31 Components.securitySchemes -> OPComponents>>securitySchemes' 'v31 Info.contact -> OPInfo>>contact' 'v31 Info.license -> OPInfo>>license' 'v31 MediaType.encoding -> OPMediaType>>encodings' 'v31 MediaType.examples -> OPMediaType>>examples' 'v31 MediaType.schema -> OPMediaType>>schema' 'v31 OAuthFlow.scopes -> OPOAuthFlow>>scopes' 'v31 OpenAPI.$ref -> OPOpenApi>>unresolvedReferences' 'v31 OpenAPI.components -> OPOpenApi>>components' 'v31 OpenAPI.externalDocs -> OPOpenApi>>externalDocs' 'v31 OpenAPI.info -> OPOpenApi>>info' 'v31 OpenAPI.paths -> OPOpenApi>>paths' 'v31 OpenAPI.security -> OPOpenApi>>securityRequirements' 'v31 OpenAPI.servers -> OPOpenApi>>servers' 'v31 OpenAPI.tags -> OPOpenApi>>tags' 'v31 OpenAPI.webhooks -> OPOpenApi>>webhooks' 'v31 Operation.callbacks -> OPOperation>>callbacks' 'v31 Operation.externalDocs -> OPOperation>>externalDocs' 'v31 Operation.parameters -> OPOperation>>parameters' 'v31 Operation.requestBody -> OPOperation>>requestBody' 'v31 Operation.responses -> OPOperation>>responses' 'v31 Operation.security -> OPOperation>>securityRequirements' 'v31 Operation.servers -> OPOperation>>servers' 'v31 Parameter.content -> OPParameter>>content' 'v31 Parameter.examples -> OPParameter>>examples' 'v31 Parameter.schema -> OPParameter>>schema' 'v31 PathItem.operations -> OPPath>>operations' 'v31 PathItem.parameters -> OPPath>>parameters' 'v31 PathItem.servers -> OPPath>>servers' 'v31 RequestBody.content -> OPRequestBody>>content' 'v31 Response.content -> OPResponse>>content' 'v31 Response.headers -> OPResponse>>headers' 'v31 Response.links -> OPResponse>>links' 'v31 Schema.additionalProperties -> OPSchema>>additionalProperties' 'v31 Schema.allOf -> OPSchema>>allOf' 'v31 Schema.anyOf -> OPSchema>>anyOf' 'v31 Schema.discriminator -> OPSchema>>discriminator' 'v31 Schema.externalDocs -> OPSchema>>externalDocs' 'v31 Schema.items -> OPSchema>>items' 'v31 Schema.not -> OPSchema>>not' 'v31 Schema.oneOf -> OPSchema>>oneOf' 'v31 Schema.prefixItems -> OPSchema>>prefixItems' 'v31 Schema.properties -> OPProperty>>valueSchema' 'v31 Schema.properties -> OPSchema>>properties' 'v31 Schema.xml -> OPSchema>>xml' 'v31 SecurityRequirement.{name} -> OPSecurityRequirement>>items' 'v31 SecurityRequirement.{name} -> OPSecurityRequirementItem>>scheme' 'v31 SecurityScheme.flows -> OPSecurityScheme>>flows' 'v31 Tag.externalDocs -> OPTag>>externalDocs')
]

{ #category : 'data' }
FamixOpenApiRelationCorpusTest >> relationKeysWithTargetsInTheCorpus [
	"The keys among them whose relations held at least one target in the corpus (a comparison that could not pass by chance): each one must keep its targets. Frozen on 103 keys"

	^ #('v2 Info.contact -> OPInfo>>contact' 'v2 Info.license -> OPInfo>>license' 'v2 MediaType.schema -> OPMediaType>>schema' 'v2 Operation.parameters -> OPOperation>>parameters' 'v2 Operation.requestBody -> OPOperation>>requestBody' 'v2 Operation.responses -> OPOperation>>responses' 'v2 Operation.security -> OPOperation>>securityRequirements' 'v2 Parameter.content -> OPRequestBody>>content' 'v2 Parameter.schema -> OPParameter>>schema' 'v2 PathItem.operations -> OPPath>>operations' 'v2 RequestBody.content -> OPRequestBody>>content' 'v2 Response.content -> OPResponse>>content' 'v2 Response.headers -> OPResponse>>headers' 'v2 Schema.additionalProperties -> OPSchema>>additionalProperties' 'v2 Schema.allOf -> OPSchema>>allOf' 'v2 Schema.items -> OPSchema>>items' 'v2 Schema.properties -> OPProperty>>valueSchema' 'v2 Schema.properties -> OPSchema>>properties' 'v2 Schema.xml -> OPSchema>>xml' 'v2 SecurityRequirement.{name} -> OPSecurityRequirement>>items' 'v2 SecurityRequirement.{name} -> OPSecurityRequirementItem>>scheme' 'v2 SecurityScheme.flows -> OPSecurityScheme>>flows' 'v2 SecurityScheme.scopes -> OPOAuthFlow>>scopes' 'v2 Swagger.components -> OPOpenApi>>components' 'v2 Swagger.definitions -> OPComponents>>schemas' 'v2 Swagger.externalDocs -> OPOpenApi>>externalDocs' 'v2 Swagger.host -> OPOpenApi>>servers' 'v2 Swagger.info -> OPOpenApi>>info' 'v2 Swagger.paths -> OPOpenApi>>paths' 'v2 Swagger.securityDefinitions -> OPComponents>>securitySchemes' 'v2 Swagger.tags -> OPOpenApi>>tags' 'v2 Tag.externalDocs -> OPTag>>externalDocs' 'v30 Callback.{expression} -> OPCallback>>pathItems' 'v30 Components.links -> OPComponents>>links' 'v30 Components.parameters -> OPComponents>>parameters' 'v30 Components.requestBodies -> OPComponents>>requestBodies' 'v30 Components.responses -> OPComponents>>responses' 'v30 Components.schemas -> OPComponents>>schemas' 'v30 Components.securitySchemes -> OPComponents>>securitySchemes' 'v30 Header.schema -> OPHeader>>schema' 'v30 Info.contact -> OPInfo>>contact' 'v30 Info.license -> OPInfo>>license' 'v30 Link.operationId -> OPLink>>operation' 'v30 MediaType.examples -> OPMediaType>>examples' 'v30 MediaType.schema -> OPMediaType>>schema' 'v30 OAuthFlow.scopes -> OPOAuthFlow>>scopes' 'v30 OpenAPI.components -> OPOpenApi>>components' 'v30 OpenAPI.externalDocs -> OPOpenApi>>externalDocs' 'v30 OpenAPI.info -> OPOpenApi>>info' 'v30 OpenAPI.paths -> OPOpenApi>>paths' 'v30 OpenAPI.security -> OPOpenApi>>securityRequirements' 'v30 OpenAPI.servers -> OPOpenApi>>servers' 'v30 OpenAPI.tags -> OPOpenApi>>tags' 'v30 Operation.callbacks -> OPOperation>>callbacks' 'v30 Operation.parameters -> OPOperation>>parameters' 'v30 Operation.requestBody -> OPOperation>>requestBody' 'v30 Operation.responses -> OPOperation>>responses' 'v30 Operation.security -> OPOperation>>securityRequirements' 'v30 Parameter.examples -> OPParameter>>examples' 'v30 Parameter.schema -> OPParameter>>schema' 'v30 PathItem.operations -> OPPath>>operations' 'v30 PathItem.parameters -> OPPath>>parameters' 'v30 RequestBody.content -> OPRequestBody>>content' 'v30 Response.content -> OPResponse>>content' 'v30 Response.headers -> OPResponse>>headers' 'v30 Response.links -> OPResponse>>links' 'v30 Schema.additionalProperties -> OPSchema>>additionalProperties' 'v30 Schema.allOf -> OPSchema>>allOf' 'v30 Schema.items -> OPSchema>>items' 'v30 Schema.properties -> OPProperty>>valueSchema' 'v30 Schema.properties -> OPSchema>>properties' 'v30 Schema.xml -> OPSchema>>xml' 'v30 SecurityRequirement.{name} -> OPSecurityRequirement>>items' 'v30 SecurityRequirement.{name} -> OPSecurityRequirementItem>>scheme' 'v30 SecurityScheme.flows -> OPSecurityScheme>>flows' 'v30 Server.variables -> OPServer>>variables' 'v30 Tag.externalDocs -> OPTag>>externalDocs' 'v31 Components.parameters -> OPComponents>>parameters' 'v31 Components.schemas -> OPComponents>>schemas' 'v31 Components.securitySchemes -> OPComponents>>securitySchemes' 'v31 MediaType.examples -> OPMediaType>>examples' 'v31 MediaType.schema -> OPMediaType>>schema' 'v31 OAuthFlow.scopes -> OPOAuthFlow>>scopes' 'v31 OpenAPI.components -> OPOpenApi>>components' 'v31 OpenAPI.info -> OPOpenApi>>info' 'v31 OpenAPI.paths -> OPOpenApi>>paths' 'v31 OpenAPI.servers -> OPOpenApi>>servers' 'v31 OpenAPI.tags -> OPOpenApi>>tags' 'v31 OpenAPI.webhooks -> OPOpenApi>>webhooks' 'v31 Operation.requestBody -> OPOperation>>requestBody' 'v31 Operation.responses -> OPOperation>>responses' 'v31 Operation.security -> OPOperation>>securityRequirements' 'v31 Parameter.schema -> OPParameter>>schema' 'v31 PathItem.operations -> OPPath>>operations' 'v31 PathItem.parameters -> OPPath>>parameters' 'v31 RequestBody.content -> OPRequestBody>>content' 'v31 Response.content -> OPResponse>>content' 'v31 Schema.items -> OPSchema>>items' 'v31 Schema.properties -> OPProperty>>valueSchema' 'v31 Schema.properties -> OPSchema>>properties' 'v31 SecurityRequirement.{name} -> OPSecurityRequirement>>items' 'v31 SecurityRequirement.{name} -> OPSecurityRequirementItem>>scheme' 'v31 SecurityScheme.flows -> OPSecurityScheme>>flows')
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> reportOfFile: aFile [
	"The report of the relation check of aFile imported without merging, with the diagnostics of the import"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: aFile contents.
	^ (FamixOpenApiRelationCheck new
		   file: aFile basename;
		   yourself)
		  checkInventory: (self inventoryOf: aFile contents)
		  model: model
		  diagnostics: importer diagnostics
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> reports [
	"Associations file name -> report, for every spec file of the corpus"

	^ self specFiles collect: [ :file |
		  file basename -> (self reportOfFile: file) ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> specFiles [
	"The corpus files that are API descriptions. Skips the running test when the corpus folder is absent"

	^ FamixOpenApiExistenceCorpusTest new specFiles
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testCorpusHasTheTwentyFilesAndTheCheckComparesThem [

	self assert: self reports size equals: 20
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testCorpusRelationGapsAreExactlyTheFrozenOnes [

	| actual |
	actual := Array streamContents: [ :stream |
		          self reports do: [ :each |
			          each value relationGaps do: [ :gap |
				          stream nextPut: {
						          each key.
						          gap sourcePointer.
						          gap kind.
						          gap fieldKey.
						          gap expected.
						          gap found } ] ] ].
	self assert: actual asSet equals: self frozenGaps asSet.
	self assert: actual size equals: self frozenGaps size
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryFileOfTheCorpusIsComparedWithoutPrecondition [

	self reports do: [ :each |
		self assert: (each value gapsOfKind: #preconditionMerged) isEmpty.
		self assert: (each value gapsOfKind: #preconditionVersion) isEmpty ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryKeyThatTheExtensionsCheckDeferredIsNowComparedByARule [
	"The source keys that V9 counted as deferred (relations and implicit structure: 1236 on the corpus): the conformance row of each one is carried by a rule of the table that compared relations in the corpus"

	| rows coverage total |
	coverage := self mergedCoverage.
	rows := FamixOpenApiMetamodelConformance check rows.
	total := 0.
	self deferredFrequencies do: [ :each |
		| row keys |
		row := rows detect: [ :candidate |
			       candidate version = each version and: [
				       candidate specObject = each specObject and: [
					       candidate fieldName = each field ] ] ].
		keys := FamixOpenApiRelationRules rules
			        select: [ :rule | rule carriesRow: row ]
			        thenCollect: [ :rule | rule coverageKeyIn: each version ].
		self assert: keys isNotEmpty description: each printString.
		self
			assert:
			(keys anySatisfy: [ :key | (coverage comparedCountOf: key) > 0 ])
			description: each printString.
		total := total + each deferredCount ].
	self assert: total > 1200
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryRelationOfTheCorpusIsDetectedWhenItIsChanged [

	| changed |
	changed := self specFiles inject: 0 into: [ :sum :each |
		           sum
		           +
		           (self
			            assertRelationSweepIn: each contents
			            named: each basename) ].
	self assert: changed > 15000
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryRelationOfThreeFilesOfTheCorpusIsDetectedWhenItIsChanged [
	"One file per version: a Swagger 2, an OpenAPI 3.0 and an OpenAPI 3.1 document"

	| changed |
	changed := (self specFiles select: [ :each |
		            #( 'petstore-swagger2.json' 'petstore-openapi3.json'
		               'oai-learn-v3.1-tictactoe.json' ) includes:
			            each basename ]) inject: 0 into: [ :sum :each |
		           sum
		           +
		           (self
			            assertRelationSweepIn: each contents
			            named: each basename) ].
	self assert: changed > 2000
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryRelationThatHeldTargetsInTheCorpusStillHoldsThem [

	| coverage |
	coverage := self mergedCoverage.
	self relationKeysWithTargetsInTheCorpus do: [ :each |
		self assert: (coverage linkCountOf: each) > 0 description: each ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryRelationThatWasComparedInTheCorpusIsStillCompared [

	| coverage |
	coverage := self mergedCoverage.
	self relationKeysComparedInTheCorpus do: [ :each |
		self assert: (coverage comparedCountOf: each) > 0 description: each ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testEveryRuleOfTheTableIsComparedByTheSmallDocumentsOrTheCorpus [
	"No relation of the table is left that no document compared (the list of the relations never compared, with their reason, is empty)"

	| coverage |
	coverage := self mergedCoverage.
	self documentSelectors do: [ :each |
		coverage mergeWith:
			(self relationReportFor: (self perform: each)) coverage ].
	#( #v30 #v31 #v2 ) do: [ :version |
		self
			assert:
			(FamixOpenApiRelationRules
				 neverComparedIn: coverage
				 version: version)
			equals: #(  ) ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testNoGapOfAnyKindIsInTheReportsOfTheCorpus [

	self reports do: [ :each |
		self assert: each value gaps isEmpty description: each key ]
]

{ #category : 'tests' }
FamixOpenApiRelationCorpusTest >> testTheTotalsOfTheCorpusHaveConservativeLowerBounds [
	"Observed: 18757 relations compared, 5038 targets, 3276 relations with targets, 158 relation rows, 0 deferred"

	| coverage |
	coverage := self mergedCoverage.
	self assert: coverage totalCompared > 15000.
	self assert: coverage totalLinks > 4500.
	self assert: coverage totalInformative > 3000.
	self assert: coverage comparedKeys size > 140.
	self assert: coverage totalMismatched equals: 0.
	self assert: coverage totalDeferred equals: 0
]
