"
Documents and detects known fidelity defects (D1..D12) of FamixOpenApiImporter. Tests are expected to be red where they capture a real defect. Each test method comment starts with the defect id.
"
Class {
	#name : 'FamixOpenApiImporterFidelityTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> apiKeySchemeIn: aModel [

	^ (self componentsIn: aModel) securitySchemes
		  detect: [ :each | each name = 'ApiKeyAuth' ]
		  ifNone: [ self fail: 'No security scheme ApiKeyAuth' ]
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> assertOperation: anOperationId hasHttpMethod: aMethod [

	| operation |
	operation := self
		             operationWithId: anOperationId
		             in: (self importOpenApi3: self verbsJson).
	self assert: operation httpMethod asLowercase equals: aMethod
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> assertOperationKnowsItsPath: anOperationId [

	| model operation |
	model := self importOpenApi3: self verbsJson.
	operation := self operationWithId: anOperationId in: model.
	self
		assert:
		operation path == (self entitiesNamed: #Path in: model) anyOne
		description: anOperationId , ' should know the /pets path'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> backwardReferenceJson [

	^ self schemasJson:
		  '`B`:{`type`:`object`},`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/B`}}'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> callbackRequestBodyMembers [

	^ self jsonFrom:
		  '`paths`:{`/subscribe`:{`post`:{`operationId`:`subscribe`,`responses`:{`200`:{`description`:`ok`}},`callbacks`:{`onEvent`:{`{$request.query.callbackUrl}`:{`post`:{`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`object`}}}},`responses`:{`200`:{`description`:`ok`}}}}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> forwardReferenceJson [

	^ self schemasJson:
		  '`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/B`}},`B`:{`type`:`object`}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> importedSchema31: aSchemaJson [
	"Answer the component schema S built from aSchemaJson in an OpenAPI 3.1 document."

	^ self
		  componentSchemaNamed: 'S'
		  in:
		  (self importOpenApi31: (self schemasJson: '`S`:' , aSchemaJson))
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> importedSchema: aSchemaJson [
	"Answer the component schema S built from aSchemaJson."

	^ self
		  componentSchemaNamed: 'S'
		  in:
		  (self importOpenApi3: (self schemasJson: '`S`:' , aSchemaJson))
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> infoNameOfTitle: aTitleJsonString [
	"Answer the name of the Info of a document whose title is the JSON text aTitleJsonString (quotes written as backticks)."

	| model |
	model := self importJson: (self jsonFrom:
			          '{`openapi`:`3.0.0`,`info`:{`title`:' , aTitleJsonString
			          , ',`version`:`1`},`paths`:{}}').
	^ (self openApiIn: model) info name
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> inlineRequestBodyMembers [

	^ self jsonFrom:
		  '`paths`:{`/pets`:{`post`:{`operationId`:`addPet`,`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`object`}}}},`responses`:{`200`:{`description`:`ok`}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> listPetsResponseIn: aModel [

	^ self
		  responseOf: (self operationWithId: 'listPets' in: aModel)
		  code: '200'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> midSizeJson [

	^ self jsonFrom:
		  '`paths`:{`/pets`:{`get`:{`operationId`:`listPets`,`parameters`:[{`name`:`limit`,`in`:`query`,`schema`:{`type`:`integer`}}],`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`$ref`:`#/components/schemas/PetList`}}}}}}}},`components`:{`schemas`:{`PetList`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Pet`}},`Pet`:{`type`:`object`,`properties`:{`owner`:{`$ref`:`#/components/schemas/Owner`}}},`Owner`:{`type`:`object`}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> mutualCycleJson [

	^ self schemasJson:
		  '`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/B`}},`B`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/A`}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> oauthSchemeIn: aModel [

	^ (self componentsIn: aModel) securitySchemes
		  detect: [ :each | each name = 'OAuth' ]
		  ifNone: [ self fail: 'No security scheme OAuth' ]
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> petWithOwnerJson [

	^ self jsonFrom:
		  '`paths`:{},`components`:{`schemas`:{`Owner`:{`type`:`object`},`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`,`format`:`int64`},`name`:{`type`:`string`},`owner`:{`$ref`:`#/components/schemas/Owner`},`tags`:{`type`:`array`,`items`:{`type`:`string`}}}}}}'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> requestBodyNamesIn: aModel [

	^ ((self entitiesNamed: #RequestBody in: aModel) collect: #name)
		  asArray sort
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> richDocumentJson [

	^ self jsonFrom:
		  '`servers`:[{`url`:`https://{env}.example.com`,`variables`:{`env`:{`default`:`prod`,`enum`:[`prod`,`dev`]}}}],`externalDocs`:{`url`:`https://docs.example.com`},`tags`:[{`name`:`pets`}],`security`:[{`ApiKeyAuth`:[]}],`paths`:{`/pets`:{`get`:{`operationId`:`listPets`,`tags`:[`pets`],`externalDocs`:{`url`:`https://op.example.com`},`security`:[{`OAuth`:[`read`,`write`]}],`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate-Limit`:{`description`:`rate`,`schema`:{`type`:`integer`}}},`links`:{`next`:{`operationId`:`listPets`}},`content`:{`application/json`:{`schema`:{`type`:`string`},`encoding`:{`a`:{`contentType`:`text/plain`}}}}}}}}},`components`:{`securitySchemes`:{`ApiKeyAuth`:{`type`:`apiKey`,`in`:`header`,`name`:`X-API-Key`},`OAuth`:{`type`:`oauth2`,`flows`:{`authorizationCode`:{`authorizationUrl`:`https://auth.example.com`,`tokenUrl`:`https://token.example.com`,`scopes`:{`read`:`Read`,`write`:`Write`}}}}}}'
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> securityRequirementNamesIn: aModel [
	"Answer the names of all the security requirements of aModel, sorted."

	^ ((self entitiesNamed: #SecurityRequirement in: aModel) collect:
		   #name) asArray sorted
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> selfReferenceJson [

	^ self schemasJson:
		  '`Tree`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Tree`}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedCallbackJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`callbacks`:{`onEvent`:{`$ref`:`#/components/callbacks/OnEvent`}},`responses`:{`200`:{`description`:`ok`}}}},`/b`:{`post`:{`operationId`:`opB`,`callbacks`:{`onEvent`:{`$ref`:`#/components/callbacks/OnEvent`}},`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`callbacks`:{`OnEvent`:{`{$request.body#/url}`:{`post`:{`operationId`:`notify`,`responses`:{`200`:{`description`:`ok`}}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedComponentIn: aModel section: aSectionName key: aKey [
	"Answer the reusable entity at #/components/<aSectionName>/<aKey>."

	| components |
	components := self componentsIn: aModel.
	^ self
		  componentIn: (components perform: aSectionName asSymbol)
		  pointer: '#/components/' , aSectionName , '/' , aKey
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedComponentsJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`parameters`:[{`$ref`:`#/components/parameters/Limit`}],`post`:{`operationId`:`opA`,`parameters`:[{`$ref`:`#/components/parameters/Limit`},{`name`:`q`,`in`:`query`,`schema`:{`type`:`string`}}],`requestBody`:{`$ref`:`#/components/requestBodies/PetBody`},`responses`:{`404`:{`$ref`:`#/components/responses/NotFound`}}}},`/b`:{`parameters`:[{`$ref`:`#/components/parameters/Limit`}],`post`:{`operationId`:`opB`,`parameters`:[{`$ref`:`#/components/parameters/Limit`}],`requestBody`:{`$ref`:`#/components/requestBodies/PetBody`},`responses`:{`404`:{`$ref`:`#/components/responses/NotFound`}}}}},`components`:{`responses`:{`NotFound`:{`description`:`nf`}},`parameters`:{`Limit`:{`name`:`limit`,`in`:`query`,`schema`:{`type`:`integer`}}},`requestBodies`:{`PetBody`:{`content`:{`application/json`:{`schema`:{`type`:`object`}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedExampleJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`object`},`examples`:{`cat`:{`$ref`:`#/components/examples/Cat`}}}}}}}},`/b`:{`get`:{`operationId`:`opB`,`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`object`},`examples`:{`cat`:{`$ref`:`#/components/examples/Cat`}}}}}}}}},`components`:{`examples`:{`Cat`:{`summary`:`a cat`,`value`:{`name`:`tom`}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedHeaderJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`$ref`:`#/components/headers/Rate`}}}}}},`/b`:{`get`:{`operationId`:`opB`,`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`$ref`:`#/components/headers/Rate`}}}}}}},`components`:{`headers`:{`Rate`:{`description`:`rate`,`schema`:{`type`:`integer`}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedLinkJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`responses`:{`200`:{`description`:`ok`,`links`:{`next`:{`$ref`:`#/components/links/Next`}}}}}},`/b`:{`get`:{`operationId`:`opB`,`responses`:{`200`:{`description`:`ok`,`links`:{`next`:{`$ref`:`#/components/links/Next`}}}}}}},`components`:{`links`:{`Next`:{`operationId`:`opB`,`description`:`go to B`}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedPathItemJson [
	"An OpenAPI 3.1 reusable path item referenced by the callbacks of two operations."

	^ self jsonFrom:
		  '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`callbacks`:{`onEvent`:{`{$request.body#/url}`:{`$ref`:`#/components/pathItems/Common`}}},`responses`:{`200`:{`description`:`ok`}}}},`/b`:{`post`:{`operationId`:`opB`,`callbacks`:{`onEvent`:{`{$request.body#/url}`:{`$ref`:`#/components/pathItems/Common`}}},`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`pathItems`:{`Common`:{`get`:{`operationId`:`commonGet`,`responses`:{`200`:{`description`:`ok`}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedPetSchemaJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`parameters`:[{`name`:`p1`,`in`:`query`,`schema`:{`$ref`:`#/components/schemas/Pet`}},{`name`:`p2`,`in`:`header`,`schema`:{`$ref`:`#/components/schemas/Pet`}}],`requestBody`:{`content`:{`application/json`:{`schema`:{`$ref`:`#/components/schemas/Pet`}},`application/xml`:{`schema`:{`$ref`:`#/components/schemas/Pet`}}}},`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`schemas`:{`Pet`:{`type`:`object`},`Couple`:{`type`:`object`,`properties`:{`first`:{`$ref`:`#/components/schemas/Pet`},`second`:{`$ref`:`#/components/schemas/Pet`}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> sharedResponseWithContentJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`responses`:{`404`:{`$ref`:`#/components/responses/NotFound`}}}},`/b`:{`get`:{`operationId`:`opB`,`responses`:{`404`:{`$ref`:`#/components/responses/NotFound`}}}}},`components`:{`responses`:{`NotFound`:{`description`:`nf`,`content`:{`text/plain`:{`schema`:{`type`:`string`}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> swagger2FormJson [

	^ self jsonFrom:
		  '`paths`:{`/form`:{`post`:{`operationId`:`submit`,`consumes`:[`application/x-www-form-urlencoded`],`parameters`:[{`name`:`a`,`in`:`formData`,`type`:`string`},{`name`:`b`,`in`:`formData`,`type`:`integer`,`required`:true}],`responses`:{`200`:{`description`:`ok`}}}},`/upload`:{`post`:{`operationId`:`upload`,`consumes`:[`multipart/form-data`],`parameters`:[{`name`:`f`,`in`:`formData`,`type`:`file`}],`responses`:{`200`:{`description`:`ok`}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> swagger2MediaTypesJson [

	^ self jsonFrom:
		  '`produces`:[`application/json`],`consumes`:[`application/xml`],`paths`:{`/a`:{`post`:{`operationId`:`opA`,`parameters`:[{`name`:`body`,`in`:`body`,`schema`:{`type`:`object`}}],`responses`:{`200`:{`description`:`ok`,`schema`:{`type`:`string`}}}}},`/b`:{`post`:{`operationId`:`opB`,`produces`:[`text/plain`,`text/csv`],`responses`:{`200`:{`description`:`ok`,`schema`:{`type`:`string`}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> swagger2PetJson [

	^ self jsonFrom:
		  '`paths`:{`/pets`:{`post`:{`operationId`:`addPet`,`parameters`:[{`name`:`body`,`in`:`body`,`schema`:{`$ref`:`#/definitions/Pet`}},{`name`:`ids`,`in`:`query`,`type`:`array`,`items`:{`type`:`integer`,`format`:`int64`},`collectionFormat`:`csv`}],`responses`:{`200`:{`description`:`ok`,`schema`:{`$ref`:`#/definitions/Pet`}},`default`:{`$ref`:`#/responses/GenericError`}}}}},`definitions`:{`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`,`format`:`int64`},`name`:{`type`:`string`}}}},`securityDefinitions`:{`basic`:{`type`:`basic`}},`parameters`:{`Trace`:{`name`:`trace`,`in`:`header`,`type`:`string`}},`responses`:{`GenericError`:{`description`:`error`}}'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> swagger2ReferencedBodyJson [

	^ self jsonFrom:
		  '`paths`:{`/pets`:{`post`:{`operationId`:`addPet`,`parameters`:[{`$ref`:`#/parameters/PetBody`}],`responses`:{`200`:{`description`:`ok`}}}},`/dogs`:{`post`:{`operationId`:`addDog`,`parameters`:[{`$ref`:`#/parameters/PetBody`}],`responses`:{`200`:{`description`:`ok`}}}}},`parameters`:{`PetBody`:{`name`:`body`,`in`:`body`,`schema`:{`type`:`object`}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> swagger2SecurityJson [

	^ self jsonFrom:
		  '`paths`:{},`securityDefinitions`:{`key`:{`type`:`apiKey`,`name`:`X-Key`,`in`:`query`},`oauth`:{`type`:`oauth2`,`flow`:`accessCode`,`authorizationUrl`:`https://auth.example.com`,`tokenUrl`:`https://token.example.com`,`scopes`:{`read`:`Read`}}}'
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testAliasOfAnAliasChainsThroughAllOf [
	"A -> B -> C: each alias is a real schema whose allOf is the next one and whose ref is its own raw ref."

	| model a b c |
	model := self importOpenApi3: (self schemasJson:
			          '`A`:{`$ref`:`#/components/schemas/B`},`B`:{`$ref`:`#/components/schemas/C`},`C`:{`type`:`object`}').
	a := self componentSchemaNamed: 'A' in: model.
	b := self componentSchemaNamed: 'B' in: model.
	c := self componentSchemaNamed: 'C' in: model.
	self assert: (self componentsIn: model) schemas size equals: 3.
	self assert: a allOf asArray equals: { b }.
	self assert: b allOf asArray equals: { c }.
	self assert: a ref equals: '#/components/schemas/B'.
	self assert: b ref equals: '#/components/schemas/C'.
	self assert: c allOf isEmpty
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testAliasWithDescriptionKeepsTheDescription [
	"{$ref, description} is still an alias: the description is kept, no sibling is ignored."

	| model alias |
	model := self importOpenApi3: (self schemasJson:
			          '`Target`:{`type`:`object`},`Alias`:{`$ref`:`#/components/schemas/Target`,`description`:`d`}').
	alias := self componentSchemaNamed: 'Alias' in: model.
	self assert: alias description equals: 'd'.
	self assert: alias allOf size equals: 1.
	self assert:
		(importer diagnostics withCode: #refSiblingsIgnored) isEmpty
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testAliasWithSiblingsInOpenApi30IgnoresTheSiblings [
	"OpenAPI 3.0: the siblings of a $ref (other than description) are ignored and reported as the info #refSiblingsIgnored; the schema is still the alias."

	| model alias |
	model := self importOpenApi3: (self schemasJson:
			          '`Target`:{`type`:`object`},`Sib`:{`$ref`:`#/components/schemas/Target`,`type`:`string`,`title`:`x`}').
	alias := self componentSchemaNamed: 'Sib' in: model.
	self assert: alias types isEmpty.
	self assert: alias title isNil.
	self assert: alias allOf size equals: 1.
	self assert: alias ref equals: '#/components/schemas/Target'.
	self assert:
		(importer diagnostics withCode: #refSiblingsIgnored) notEmpty.
	self assert:
		(importer diagnostics withCode: #refSiblingsIgnored) first isInfo
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testAliasWithSiblingsInOpenApi31IsASiblingWrapper [
	"OpenAPI 3.1: the siblings of a $ref are kept: the schema keeps its own keywords and its allOf holds the target; nothing is ignored."

	| model wrapper |
	model := self importOpenApi31: (self schemasJson:
			          '`Target`:{`type`:`object`},`Sib`:{`$ref`:`#/components/schemas/Target`,`type`:`string`,`title`:`x`}').
	wrapper := self componentSchemaNamed: 'Sib' in: model.
	self assert: wrapper types asArray equals: #( 'string' ).
	self assert: wrapper title equals: 'x'.
	self
		assert: wrapper allOf asArray
		equals: { (self componentSchemaNamed: 'Target' in: model) }.
	self assert: wrapper ref equals: '#/components/schemas/Target'.
	self assert:
		(importer diagnostics withCode: #refSiblingsIgnored) isEmpty
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testAllParametersOfPostOperationMergesPathParameters [
	"D5: allParameters of a POST operation includes the path-level parameter."

	| operation |
	operation := self
		             operationWithId: 'createPet'
		             in: (self importOpenApi3: self verbsJson).
	self
		assert: (operation allParameters collect: #name) asArray
		equals: #( 'traceId' ).
	self assert: operation parameters isEmpty
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testApiExternalDocsAreImported [
	"D8: externalDocs of the document is kept."

	| docs |
	docs := (self openApiIn: (self importOpenApi3: self richDocumentJson))
		        externalDocs.
	self
		assert: docs notNil
		description: 'api externalDocs should be kept'.
	self assert: docs url equals: 'https://docs.example.com'
]

{ #category : 'tests - D9 D10 naming and ref semantics (step B)' }
FamixOpenApiImporterFidelityTest >> testApiKeySchemeKeepsComponentKeyAsName [
	"D9: the security scheme is named after its component key ApiKeyAuth (was: entry key)."

	| schemes |
	schemes := (self componentsIn:
		            (self importOpenApi3: self richDocumentJson))
		           securitySchemes.
	self assert:
		(schemes anySatisfy: [ :each | each name = 'ApiKeyAuth' ]).
	self
		assert:
			(self apiKeySchemeIn: (self importOpenApi3: self richDocumentJson))
				canonicalPointer
		equals: '#/components/securitySchemes/ApiKeyAuth'
]

{ #category : 'tests - D9 D10 naming and ref semantics (step B)' }
FamixOpenApiImporterFidelityTest >> testApiKeySchemeKeepsHeaderNameDistinctFromKey [
	"D9: the apiKey scheme keeps the header name X-API-Key in parameterName and is named after the component key (the name is not overwritten)."

	| scheme |
	scheme := self apiKeySchemeIn:
		          (self importOpenApi3: self richDocumentJson).
	self assert: scheme parameterName equals: 'X-API-Key'.
	self assert: scheme name equals: 'ApiKeyAuth'
]

{ #category : 'tests - D9 D10 naming and ref semantics (step B)' }
FamixOpenApiImporterFidelityTest >> testApiKeySchemeKeepsLocation [
	"D9: the apiKey scheme keeps its location (in: header) as inLocation."

	self
		assert:
			(self apiKeySchemeIn: (self importOpenApi3: self richDocumentJson))
				inLocation
		equals: 'header'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testArrayPropertyExposesItems [
	"D1: an array property exposes the items schema through its own value schema."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'tags'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self assert: property valueSchema items notNil.
	self
		assert: property valueSchema items types asArray
		equals: #( 'string' )
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testArrayWhereSchemaIsExpectedCreatesNoEntityAndDoesNotRaise [
	"D11: a JSON array where a schema object is expected must neither raise nor create a schema entity (it is reported as #wrongNodeType)."

	| model |
	self
		shouldnt: [
			model := self importOpenApi3: (self schemasJson:
					          '`Pet`:{`type`:`object`,`items`:[`a`,`b`],`additionalProperties`:[1]}') ]
		raise: Error.
	self assert: (self schemasIn: model) size equals: 1.
	self assert: (importer diagnostics withCode: #wrongNodeType) notEmpty
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testBackwardReferenceLeavesNoStub [
	"D3: backward reference must not leave a ref-only stub schema in the model."

	self assertNoStubSchemasIn:
		(self importOpenApi3: self backwardReferenceJson)
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testBackwardReferenceResolvesToComponentEntity [
	"D3: B declared before A, A refs B: A items must be the B component entity."

	| model |
	model := self importOpenApi3: self backwardReferenceJson.
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'B' in: model)
		description:
		'A items should be the B component schema (backward reference)'
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testBlankInfoTitleNamesTheInfoInfo [

	self assert: (self infoNameOfTitle: '``') equals: 'info'
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testBooleanAdditionalPropertiesCreatesNoGarbageSchema [
	"D11: additionalProperties true/false is a boolean, not a schema: only the Pet and Closed schemas exist."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`Pet`:{`type`:`object`,`additionalProperties`:true},`Closed`:{`type`:`object`,`additionalProperties`:false}').
	self assert: (self schemasIn: model) size equals: 2
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testBooleanAdditionalPropertiesFalseIsKept [
	"D11: additionalProperties: false is kept as additionalPropertiesAllowed = false."

	self
		assert:
			(self importedSchema:
				 '{`type`:`object`,`additionalProperties`:false}')
				additionalPropertiesAllowed
		equals: false
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testBooleanComponentSchemaDoesNotRaise [
	"D11, meaning changed by design: a boolean schema (true) as a component value does not raise and is no garbage: it is a legal 3.1 schema, so it is imported as the component schema Anything (no type, no content) and the component count stays equal to the raw count. The old test expected no entity at all."

	| model |
	self
		shouldnt: [
		model := self importOpenApi3: (self schemasJson: '`Anything`:true') ]
		raise: Error.
	self assert: (self schemasIn: model) size equals: 1.
	self assert: (self schemasIn: model) anyOne name equals: 'Anything'.
	self assert: (self schemasIn: model) anyOne types isEmpty.
	self assert: (self schemasIn: model) anyOne properties isEmpty
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testBooleanExclusiveMinimumOfOpenApi30MovesTheBound [
	"3.0 boolean exclusiveMinimum is normalised to the numeric 3.1 form."

	| schema |
	schema := self importedSchema:
		          '{`type`:`integer`,`minimum`:5,`exclusiveMinimum`:true}'.
	self assert: schema exclusiveMinimum equals: 5.
	self assert: schema minimum isNil
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testCallbackOperationRequestBodyIsNamedAfterTheCallbackOperation [

	| model callbackOperation |
	model := self importOpenApi3: self callbackRequestBodyMembers.
	callbackOperation := (self entitiesNamed: #Operation in: model)
		                     detect: [ :each | each operationId isNil ].
	self deny: callbackOperation name isNil.
	self
		assert: callbackOperation requestBody name
		equals: callbackOperation name , ' requestBody'
]

{ #category : 'tests - canonical pointers (step B)' }
FamixOpenApiImporterFidelityTest >> testCanonicalPointersOfAllEntitiesAreUnique [
	"The canonical pointer designates one entity of the model (responses and media types copied per operation have their own site pointer). Documented sharing: a Property and its value schema are the same JSON node, so a Property is left out."

	| model pointers propertyClass |
	model := self importOpenApi3: self sharedComponentsJson.
	propertyClass := self generatedClassNamed: #Property.
	pointers := OrderedCollection new.
	model entities do: [ :each |
		((each isKindOf: propertyClass) or: [ each canonicalPointer isNil ])
			ifFalse: [ pointers add: each canonicalPointer ] ].
	self assert: pointers size > 10.
	self assert: pointers asSet size equals: pointers size
]

{ #category : 'tests - canonical pointers' }
FamixOpenApiImporterFidelityTest >> testCanonicalPointersOfSchemasAreUnique [
	"Every schema entity has its own canonical pointer (merged schemas list the other pointers in mergedPointers)."

	| model pointers |
	model := self importOpenApi3: self petWithOwnerJson.
	pointers := (self schemasIn: model) collect: #canonicalPointer.
	self deny: (pointers anySatisfy: #isNil).
	self assert: pointers asSet size equals: pointers size
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testClonedResponseCopiesTheMediaTypesOfTheComponent [
	"D2: the media types of a reusable response are copied to each clone; the schema they point to stays shared."

	| model component opA opB cloneA cloneB componentMediaType |
	model := self importOpenApi3: self sharedResponseWithContentJson.
	component := self
		             componentIn: (self componentsIn: model) responses
		             pointer: '#/components/responses/NotFound'.
	componentMediaType := self mediaTypeNamed: 'text/plain' of: component.
	opA := self operationWithId: 'opA' in: model.
	opB := self operationWithId: 'opB' in: model.
	cloneA := self responseOf: opA code: '404'.
	cloneB := self responseOf: opB code: '404'.
	self assert: cloneA content size equals: 1.
	self assert: cloneB content size equals: 1.
	self assert:
		(self mediaTypeNamed: 'text/plain' of: cloneA) ~~ componentMediaType.
	self assert: (self mediaTypeNamed: 'text/plain' of: cloneA)
		~~ (self mediaTypeNamed: 'text/plain' of: cloneB).
	self assert: (self mediaTypeNamed: 'text/plain' of: cloneA) schema
		== componentMediaType schema.
	self assert: (self mediaTypeNamed: 'text/plain' of: cloneB) schema
		== componentMediaType schema
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testClonedResponseKeepsComponentRefAndOwnSiteData [
	"D2: the copy of a reusable response keeps the component pointer as ref, owns its site pointer, its status code and its operation."

	| model component opA opB cloneA cloneB |
	model := self importOpenApi3: self sharedComponentsJson.
	component := self
		             componentIn: (self componentsIn: model) responses
		             pointer: '#/components/responses/NotFound'.
	opA := self operationWithId: 'opA' in: model.
	opB := self operationWithId: 'opB' in: model.
	cloneA := self responseOf: opA code: '404'.
	cloneB := self responseOf: opB code: '404'.
	self assert: cloneA ref equals: '#/components/responses/NotFound'.
	self assert: cloneB ref equals: '#/components/responses/NotFound'.
	self
		assert: cloneA canonicalPointer
		equals: '#/paths/~1a/post/responses/404'.
	self
		assert: cloneB canonicalPointer
		equals: '#/paths/~1b/post/responses/404'.
	self assert: cloneA statusCode equals: '404'.
	self assert: cloneA operation == opA.
	self assert: cloneB operation == opB.
	self assert: component ref isNil.
	self assert: component operation isNil
]

{ #category : 'tests - canonical pointers' }
FamixOpenApiImporterFidelityTest >> testComponentSchemaCanonicalPointer [

	| model |
	model := self importOpenApi3: self petWithOwnerJson.
	self
		assert:
		(self componentSchemaNamed: 'Pet' in: model) canonicalPointer
		equals: '#/components/schemas/Pet'.
	self
		assert:
		(self componentSchemaNamed: 'Owner' in: model) canonicalPointer
		equals: '#/components/schemas/Owner'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testComponentsEntityIsNamedComponents [

	| model |
	model := self importOpenApi3: '`components`:{`schemas`:{}}'.
	self assert: (self componentsIn: model) name equals: 'components'
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testDanglingReferenceLeavesTheReferringSlotEmpty [

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Missing`}}').
	self assert: (self componentSchemaNamed: 'A' in: model) items isNil
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testDeleteOperationKnowsItsHttpMethod [
	"D5: DELETE operation knows its verb."

	self assertOperation: 'deletePet' hasHttpMethod: 'delete'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testDeleteOperationKnowsItsPath [
	"D5: DELETE operation is linked to its path."

	self assertOperationKnowsItsPath: 'deletePet'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testDuplicateOperationIdIsReported [

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`same`,`responses`:{`200`:{`description`:`ok`}}}},`/b`:{`get`:{`operationId`:`same`,`responses`:{`200`:{`description`:`ok`}}}}}'.
	self
		assert: (self entitiesNamed: #Operation in: model) size
		equals: 2.
	self assert:
		(importer diagnostics withCode: #operationIdDuplicate) notEmpty
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testEmptyOperationSecurityDisablesTheSecurityOfTheDocument [
	"security: [] on an operation sets securityDisabled and creates no requirement."

	| operation |
	operation := self operationWithId: 'open' in: (self importOpenApi3:
			              '`security`:[{`ApiKeyAuth`:[]}],`paths`:{`/open`:{`get`:{`operationId`:`open`,`security`:[],`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`securitySchemes`:{`ApiKeyAuth`:{`type`:`apiKey`,`in`:`header`,`name`:`k`}}}').
	self assert: operation securityDisabled equals: true.
	self assert: operation securityRequirements isEmpty.
	self assert: operation effectiveSecurity isEmpty
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testEmptySchemeKeyAloneNamesTheRequirementAnonymous [

	| model |
	model := self importOpenApi3: '`security`:[{``:[]}],`paths`:{}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'anonymous' )
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testEmptySchemeKeyIsLeftOutOfTheRequirementName [

	| model |
	model := self importOpenApi3:
		         '`security`:[{``:[],`a`:[]}],`paths`:{}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'a' )
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testEmptySecurityArrayCreatesNoRequirementToName [

	| model |
	model := self importOpenApi3: '`security`:[],`paths`:{}'.
	self assert: (self securityRequirementNamesIn: model) isEmpty
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testEmptySecurityRequirementIsNamedAnonymous [

	| model |
	model := self importOpenApi3: '`security`:[{}],`paths`:{}'.
	self
		assert: (self openApiIn: model) securityRequirements anyOne name
		equals: 'anonymous'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testExternalDocsIsNamedByItsUrl [

	| model |
	model := self importOpenApi3:
		         '`externalDocs`:{`url`:`https://docs.example.com`,`description`:`more`}'.
	self
		assert:
		(self entitiesNamed: #ExternalDocumentation in: model) anyOne name
		equals: 'https://docs.example.com'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testExternalDocsWithoutUrlIsNamedByItsDescription [

	| model |
	model := self importOpenApi3:
		         '`externalDocs`:{`description`:`Find more\ninfo`}'.
	self
		assert:
		(self entitiesNamed: #ExternalDocumentation in: model) anyOne name
		equals: 'Find more info'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testExternalDocsWithoutUrlNorDescriptionIsNamedExternalDocs [

	| model |
	model := self importOpenApi3: '`externalDocs`:{}'.
	self
		assert:
		(self entitiesNamed: #ExternalDocumentation in: model) anyOne name
		equals: 'externalDocs'
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testForwardReferenceCreatesNoDuplicateSchema [
	"D3: forward reference must not create a second schema entity named B."

	self
		assertExactlyOneSchemaNamed: 'B'
		in: (self importOpenApi3: self forwardReferenceJson)
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testForwardReferenceLeavesNoStub [
	"D3: forward reference must not leave a ref-only stub schema in the model."

	self assertNoStubSchemasIn:
		(self importOpenApi3: self forwardReferenceJson)
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testForwardReferenceResolvesToComponentEntity [
	"D3: A (visited first) refs B declared later: A items must be the B component entity."

	| model |
	model := self importOpenApi3: self forwardReferenceJson.
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'B' in: model)
		description:
		'A items should be the B component schema (forward reference)'
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testInfoWithoutTitleIsNamedInfo [

	| model |
	model := self importJson: (self jsonFrom:
			          '{`openapi`:`3.0.0`,`info`:{`version`:`1`},`paths`:{}}').
	self assert: (self openApiIn: model) info name equals: 'info'
]

{ #category : 'tests - D9 D10 naming and ref semantics (step B)' }
FamixOpenApiImporterFidelityTest >> testInlineComponentParameterHasNoSourceRef [
	"D10: a component parameter written inline must not look like an alias: its #ref is nil (also when other sites reference it)."

	| parameter |
	parameter := self
		             componentIn:
			             (self componentsIn:
				              (self importOpenApi3: self sharedComponentsJson))
				             parameters
		             pointer: '#/components/parameters/Limit'.
	self
		assert: parameter ref isNil
		description: 'ref should be nil, got ' , parameter ref printString
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testInlineComponentSchemaHasNoSourceRef [
	"D10: a component schema written inline (no $ref in the source) must not look like an alias: its #ref is nil."

	| schema |
	schema := self importedSchema: '{`type`:`object`}'.
	self
		assert: schema ref isNil
		description: 'ref should be nil, got ' , schema ref printString
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testInlineOpenApi31RequestBodyIsNamedAfterItsOperation [

	| operation |
	operation := self
		             operationWithId: 'addPet'
		             in:
		             (self importOpenApi31: self inlineRequestBodyMembers).
	self assert: operation requestBody name equals: 'addPet requestBody'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testInlineOpenApi3RequestBodyIsNamedAfterItsOperation [

	| operation |
	operation := self
		             operationWithId: 'addPet'
		             in:
		             (self importOpenApi3: self inlineRequestBodyMembers).
	self assert: operation requestBody name equals: 'addPet requestBody'.
	self
		assert: operation requestBody canonicalPointer
		equals: '#/paths/~1pets/post/requestBody'
]

{ #category : 'tests - canonical pointers' }
FamixOpenApiImporterFidelityTest >> testInlineSchemaCanonicalPointerIsItsPositionInTheDocument [
	"The pointer of an inline schema is the position where it is written: schema, then property, then its own keywords."

	| model pet |
	model := self importOpenApi3: (self schemasJson:
			          '`Pet`:{`type`:`object`,`properties`:{`tags`:{`type`:`array`,`items`:{`type`:`integer`}}}}').
	pet := self componentSchemaNamed: 'Pet' in: model.
	self
		assert: (self propertyNamed: 'tags' ofSchema: pet) valueSchema
				canonicalPointer
		equals: '#/components/schemas/Pet/properties/tags'.
	self
		assert:
			(self propertyNamed: 'tags' ofSchema: pet) valueSchema items
				canonicalPointer
		equals: '#/components/schemas/Pet/properties/tags/items'
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testLongInfoTitleIsLimitedInTheInfoNameButKeptInItsTitle [

	| model title info |
	title := String new: 100 withAll: $t.
	model := self importJson:
		         (self jsonFrom:
			          '{`openapi`:`3.0.0`,`info`:{`title`:`' , title
			          , '`,`version`:`1`},`paths`:{}}').
	info := (self openApiIn: model) info.
	self assert: info name size equals: FamixOpenApiNaming maxNameLength.
	self assert: info title equals: title
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testLongSecurityRequirementNameIsLimited [

	| model requirement |
	model := self importOpenApi3:
		         '`security`:[{`' , (String new: 60 withAll: $a) , '`:[],`'
		         , (String new: 60 withAll: $b) , '`:[]}],`paths`:{}'.
	requirement := (self openApiIn: model) securityRequirements anyOne.
	self
		assert: requirement name size
		equals: FamixOpenApiNaming maxNameLength.
	self assert:
		(requirement name beginsWith: (String new: 60 withAll: $a)).
	self
		assert: (requirement items collect: #name) asArray sorted first size
		equals: 60
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testLongServerUrlIsLimitedInName [

	| model server |
	model := self importOpenApi3:
		         '`servers`:[{`url`:`https://example.com/'
		         , (String new: 120 withAll: $a) , '`}]'.
	server := (self entitiesNamed: #Server in: model) anyOne.
	self
		assert: server name size
		equals: FamixOpenApiNaming maxNameLength.
	self
		assert: server url size
		equals: 'https://example.com/' size + 120
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testMalformedReferenceIsReportedAsDiagnostic [
	"D11: a malformed $ref (not a string pointer) is reported by the diagnostics of the importer as #wrongNodeType, at the pointer of the $ref value."

	self importOpenApi3:
		(self schemasJson: '`A`:{`type`:`array`,`items`:{`$ref`:42}}').
	self
		assert: importer diagnostics notEmpty
		description: 'The malformed $ref should be reported'.
	self assert: (importer diagnostics withCode: #wrongNodeType) notEmpty.
	self
		assert:
		(importer diagnostics withCode: #wrongNodeType) first pointer
		equals: '#/components/schemas/A/items/$ref'
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testMalformedSecurityItemKeepsTheValidRequirementNamed [

	| model |
	model := self importOpenApi3: '`security`:[1,{`a`:[]}],`paths`:{}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'a' ).
	self assert: importer diagnostics notEmpty
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testMalformedSecurityLeavesNoUnnamedRequirement [

	#( 'null' '`text`' '[1]' '[`x`,null]' ) do: [ :malformed |
		| model |
		model := self importOpenApi3:
			         '`security`:' , malformed , ',`paths`:{}'.
		self
			assert: (self securityRequirementNamesIn: model) isEmpty
			description: malformed ]
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testMediaTypeEncodingIsImported [
	"D8: media type encoding is kept (encodings of the media type, one Encoding per property name)."

	| mediaType |
	mediaType := (self listPetsResponseIn:
		              (self importOpenApi3: self richDocumentJson)) content
		             anyOne.
	self assert: mediaType encodings size equals: 1.
	self assert: mediaType encodings anyOne propertyName equals: 'a'.
	self
		assert: mediaType encodings anyOne contentType
		equals: 'text/plain'
]

{ #category : 'tests - canonical pointers' }
FamixOpenApiImporterFidelityTest >> testMergedPointersNeverRepeatACanonicalPointer [
	"A pointer is either the canonical pointer of a schema or one of its mergedPointers, never both and never in two schemas."

	| model all |
	model := self importOpenApi3: (self schemasJson:
			          '`A`:{`type`:`object`,`properties`:{`x`:{`type`:`string`},`y`:{`type`:`string`},`z`:{`type`:`string`}}}').
	all := OrderedCollection new.
	(self schemasIn: model) do: [ :each |
		all add: each canonicalPointer.
		all addAll: each mergedPointers ].
	self assert: all asSet size equals: all size
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testMixedSecurityRequirementListIsNamedPerRequirementInOrder [

	| model |
	model := self importOpenApi3:
		         '`security`:[{},{`x`:[]}],`paths`:{},`components`:{`securitySchemes`:{`x`:{`type`:`apiKey`,`in`:`header`,`name`:`k`}}}'.
	self
		assert:
		((self openApiIn: model) securityRequirements collect: #name)
			asArray
		equals: #( 'anonymous' 'x' )
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testMutualCycleLeavesNoStubAndNoDuplicate [
	"D3: mutual cycle must not leave a stub nor duplicate A or B."

	| model |
	model := self importOpenApi3: self mutualCycleJson.
	self assertNoStubSchemasIn: model.
	self assertExactlyOneSchemaNamed: 'A' in: model.
	self assertExactlyOneSchemaNamed: 'B' in: model
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testMutualCycleResolvesBothSides [
	"D3: A items -> B and B items -> A must be identical to the component entities."

	| model a b |
	model := self importOpenApi3: self mutualCycleJson.
	a := self componentSchemaNamed: 'A' in: model.
	b := self componentSchemaNamed: 'B' in: model.
	self assert: a items == b description: 'A items should be B'.
	self assert: b items == a description: 'B items should be A'
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testMutualSchemaCycleIsNotReportedAsRefCycle [
	"D3: a cycle through the content of schemas is legal; #refCycle is only for chains of pure aliases."

	self importOpenApi3: self mutualCycleJson.
	self assert: (importer diagnostics withCode: #refCycle) isEmpty.
	self deny: importer diagnostics hasErrors
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testNestedPointerLeavesNoStub [
	"D12: a nested pointer must not leave a ref-only stub schema in the model."

	self assertNoStubSchemasIn: (self importOpenApi3: (self schemasJson:
				  '`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}},`Ids`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Pet/properties/id`}}'))
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testNestedPointerResolvesToTheTargetContent [
	"D12: #/components/schemas/Pet/properties/id points inside Pet: items is the very inline schema of the id property, with the integer content."

	| model items |
	model := self importOpenApi3: (self schemasJson:
			          '`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}},`Ids`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Pet/properties/id`}}').
	items := (self componentSchemaNamed: 'Ids' in: model) items.
	self assert: items notNil description: 'items should be resolved'.
	self assert: items types asArray equals: #( 'integer' ).
	self assert: items == (self
			 propertyNamed: 'id'
			 ofSchema: (self componentSchemaNamed: 'Pet' in: model))
			valueSchema
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testNumericExclusiveBoundsOfOpenApi31AreKept [

	| schema |
	schema := self importedSchema31:
		          '{`type`:`integer`,`exclusiveMinimum`:1,`exclusiveMaximum`:9}'.
	self assert: schema exclusiveMinimum equals: 1.
	self assert: schema exclusiveMaximum equals: 9
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testOAuth2SchemeKeepsAuthorizationUrl [
	"D8: the OAuth2 flow authorizationUrl is kept on the authorizationCode flow of the scheme."

	| flow |
	flow := (self oauthSchemeIn:
		         (self importOpenApi3: self richDocumentJson)) flows anyOne.
	self assert: flow flowType equals: 'authorizationCode'.
	self assert: flow authorizationUrl equals: 'https://auth.example.com'.
	self assert: flow tokenUrl equals: 'https://token.example.com'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testOAuth2SchemeKeepsScopes [
	"D8: the OAuth2 flow scopes are kept as SecurityScope entities of the flow."

	| flow |
	flow := (self oauthSchemeIn:
		         (self importOpenApi3: self richDocumentJson)) flows anyOne.
	self
		assert: flow scopes notNil
		description: 'OAuth2 scopes should be kept'.
	self assert: flow scopes size equals: 2.
	self
		assert: (flow scopes collect: #name) asSet
		equals: #( 'read' 'write' ) asSet.
	self
		assert:
		(flow scopes detect: [ :each | each name = 'read' ]) description
		equals: 'Read'
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testOpenApi31SecurityRequirementsAreNamed [

	| model |
	model := self importOpenApi31:
		         '`security`:[{`b`:[],`a`:[]},{}],`paths`:{},`components`:{`securitySchemes`:{`a`:{`type`:`apiKey`,`in`:`header`,`name`:`ka`},`b`:{`type`:`apiKey`,`in`:`query`,`name`:`kb`}}}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'a + b' 'anonymous' )
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testOpenApiAndInfoKeepTheInfoTitle [

	| model |
	model := self importOpenApi3: '`paths`:{}'.
	self assert: (self openApiIn: model) name equals: 't'.
	self assert: (self openApiIn: model) info name equals: 't'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testOpenApiWithoutInfoIsNamedOpenapi [

	| model |
	model := self importJson:
		         (self jsonFrom: '{`openapi`:`3.0.0`,`paths`:{}}').
	self assert: (self openApiIn: model) name equals: 'openapi'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testOpenApiWithoutInfoTitleIsNamedOpenapiAndInfoInfo [

	| model |
	model := self importJson: (self jsonFrom:
			          '{`openapi`:`3.0.0`,`info`:{`version`:`1`},`paths`:{}}').
	self assert: (self openApiIn: model) name equals: 'openapi'.
	self assert: (self openApiIn: model) info name equals: 'info'.
	self assert: (self openApiIn: model) info title isNil
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationAndPathCanonicalPointers [

	| model operation |
	model := self importOpenApi3: self verbsJson.
	operation := self operationWithId: 'createPet' in: model.
	self
		assert:
		(self entitiesNamed: #Path in: model) anyOne canonicalPointer
		equals: '#/paths/~1pets'.
	self assert: operation canonicalPointer equals: '#/paths/~1pets/post'.
	self
		assert: (self responseOf: operation code: '200') canonicalPointer
		equals: '#/paths/~1pets/post/responses/200'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationExternalDocsAreImported [
	"D8: externalDocs of an operation is kept."

	| docs |
	docs := (self
		         operationWithId: 'listPets'
		         in: (self importOpenApi3: self richDocumentJson))
		        externalDocs.
	self
		assert: docs notNil
		description: 'operation externalDocs should be kept'.
	self assert: docs url equals: 'https://op.example.com'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationHasNoSecurityDisabledByDefault [

	self
		assert: (self
				 operationWithId: 'createPet'
				 in: (self importOpenApi3: self verbsJson)) securityDisabled
		equals: false
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationKeepsBothItsParameters [
	"D2: an operation declaring one $ref parameter and one inline parameter keeps both."

	| model operation |
	model := self importOpenApi3: self sharedComponentsJson.
	operation := self operationWithId: 'opA' in: model.
	self assert: operation parameters size equals: 2.
	self
		assert: (operation parameters collect: #name) asSet
		equals: #( 'limit' 'q' ) asSet
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationSecurityRequirementKeepsScopes [
	"D8: an operation security requirement keeps the scheme and the scopes of each of its items."

	| model requirement item |
	model := self importOpenApi3: self richDocumentJson.
	requirement := (self operationWithId: 'listPets' in: model)
		               securityRequirements.
	self assert: requirement size equals: 1.
	item := requirement anyOne items anyOne.
	self assert: item scopeNames asSet equals: #( 'read' 'write' ) asSet.
	self assert: item scheme == (self oauthSchemeIn: model)
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testOperationSecurityRequirementsAreNamedAndSharedNamesAreAccepted [

	| model first second |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`a`,`security`:[{`k`:[`read`]}],`responses`:{`200`:{`description`:`ok`}}}},`/b`:{`get`:{`operationId`:`b`,`security`:[{`k`:[`read`]}],`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`securitySchemes`:{`k`:{`type`:`apiKey`,`in`:`header`,`name`:`x`}}}'.
	first := (self operationWithId: 'a' in: model) securityRequirements
		         anyOne.
	second := (self operationWithId: 'b' in: model) securityRequirements
		          anyOne.
	self assert: first name equals: 'k'.
	self assert: second name equals: 'k'.
	self deny: first == second.
	self
		assert: first items anyOne scopeNames asArray
		equals: #( 'read' )
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationTagsAreLinkedToTagEntities [
	"D8: operation tags resolve to Tag entities (Operation>>tags from tagNames)."

	| model operation |
	model := self importOpenApi3: self richDocumentJson.
	operation := self operationWithId: 'listPets' in: model.
	self assert: operation tagNames asArray equals: #( 'pets' ).
	self
		assert: operation tags asArray
		equals: (self entitiesNamed: #Tag in: model) asArray
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testOperationWithoutOperationIdGetsASynthesizedNameAndAnInfo [
	"An operation without operationId is named after its verb and path and the importer reports #operationIdMissing."

	| model operation |
	model := self importOpenApi3:
		         '`paths`:{`/pets/{petId}`:{`get`:{`responses`:{`200`:{`description`:`ok`}}}}}'.
	operation := (self entitiesNamed: #Operation in: model) anyOne.
	self assert: operation name equals: 'get_pets_petId'.
	self assert: operation operationId isNil.
	self
		assert: (importer diagnostics withCode: #operationIdMissing) size
		equals: 1
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testPatchOperationKnowsItsHttpMethod [
	"D5: PATCH operation knows its verb."

	self assertOperation: 'updatePet' hasHttpMethod: 'patch'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testPatchOperationKnowsItsPath [
	"D5: PATCH operation is linked to its path."

	self assertOperationKnowsItsPath: 'updatePet'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testPercentEncodedPointerResolvesToComponentKeyWithSpace [
	"D12: #/components/schemas/My%20Schema resolves to the schema keyed 'My Schema'."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`My Schema`:{`type`:`object`},`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/My%20Schema`}}').
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'My Schema' in: model)
		description: 'items should be the My Schema component entity'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testPostOperationKnowsItsHttpMethod [
	"D5: POST operation knows its verb."

	self assertOperation: 'createPet' hasHttpMethod: 'post'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testPostOperationKnowsItsPath [
	"D5: POST operation is linked to its path."

	self assertOperationKnowsItsPath: 'createPet'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyDoesNotMistakeDeclaringSchemaForItsOwnSchema [
	"D1: the value schema of a property is its own type, never the schema that declares it; the declaring schema is reached through Schema>>properties."

	| model pet property |
	model := self importOpenApi3: self petWithOwnerJson.
	pet := self componentSchemaNamed: 'Pet' in: model.
	property := self propertyNamed: 'name' ofSchema: pet.
	self
		assert: property valueSchema notNil
		description: 'the property should have its own value schema'.
	self assert: property valueSchema types asArray equals: #( 'string' ).
	self
		assert: property valueSchema ~~ pet
		description:
		'valueSchema should not be the schema that merely declares the property'.
	self
		assert: (pet properties includes: property)
		description:
		'the declaring schema is reachable through Schema>>properties'.
	self assert: property schema == pet
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyKeepsItsFormat [
	"D1: a property exposes the format of its own inline schema (through valueSchema)."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'id'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self assert: property valueSchema format equals: 'int64'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyKeepsItsType [
	"D1: a property exposes the type of its own inline schema (through valueSchema, types is a collection)."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'id'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self
		assert: property valueSchema types asArray
		equals: #( 'integer' )
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyReferencingComponentExposesResolvedSchema [
	"D1: a property declared with a $ref exposes the referenced schema as valueSchema."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'owner'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self
		assert:
		property valueSchema
		== (self componentSchemaNamed: 'Owner' in: model)
		description:
		'The owner property should reference the Owner component schema entity'
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testPureAliasComponentSchemaIsARealSchemaWhoseAllOfIsTheTarget [
	"A component schema that is only a $ref becomes a real Schema: name = key, ref = the raw ref, allOf = [target], its own pointer. It counts in the component schemas."

	| model alias target |
	model := self importOpenApi3: (self schemasJson:
			          '`Target`:{`type`:`object`},`Alias`:{`$ref`:`#/components/schemas/Target`}').
	alias := self componentSchemaNamed: 'Alias' in: model.
	target := self componentSchemaNamed: 'Target' in: model.
	self assert: (self componentsIn: model) schemas size equals: 2.
	self assert: alias name equals: 'Alias'.
	self assert: alias ref equals: '#/components/schemas/Target'.
	self
		assert: alias canonicalPointer
		equals: '#/components/schemas/Alias'.
	self assert: alias allOf asArray equals: { target }.
	self assert: alias types isEmpty.
	self assert: target ref isNil
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testPureAliasCycleDoesNotRaiseAndLeavesTwoSchemas [
	"A is only a $ref to B and B only a $ref to A: both are real schemas whose allOf point to each other; the import never raises and creates no stub. NOTE: since the alias became a real schema, no #refCycle is reported any more (the old test expected it): flagged as a doubt in the report."

	| model a b |
	self
		shouldnt: [
			model := self importOpenApi3: (self schemasJson:
					          '`A`:{`$ref`:`#/components/schemas/B`},`B`:{`$ref`:`#/components/schemas/A`},`C`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/A`}}') ]
		raise: Error.
	a := self componentSchemaNamed: 'A' in: model.
	b := self componentSchemaNamed: 'B' in: model.
	self assert: a allOf asArray equals: { b }.
	self assert: b allOf asArray equals: { a }.
	self assertNoStubSchemasIn: model
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testPutOperationKnowsItsHttpMethod [
	"D5: PUT operation knows its verb."

	self assertOperation: 'replacePet' hasHttpMethod: 'put'
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testPutOperationKnowsItsPath [
	"D5: PUT operation is linked to its path."

	self assertOperationKnowsItsPath: 'replacePet'
]

{ #category : 'tests - canonical pointers' }
FamixOpenApiImporterFidelityTest >> testReferenceSiteDoesNotCreateAnEntityAtItsOwnPointer [
	"A $ref site designates the component: nothing is registered at the pointer of the site."

	| model |
	model := self importOpenApi3: self forwardReferenceJson.
	self deny: ((self schemasIn: model) anySatisfy: [ :each |
			 each canonicalPointer = '#/components/schemas/A/items' ])
]

{ #category : 'tests - alias components' }
FamixOpenApiImporterFidelityTest >> testReferenceToAnAliasComponentSchemaReachesTheAliasEntity [
	"The alias is a real entity registered at its own pointer: a $ref to it designates it (its allOf leads to the final target); no stub is created."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`Target`:{`type`:`object`},`Alias`:{`$ref`:`#/components/schemas/Target`},`User`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Alias`}}').
	self assert: (self componentSchemaNamed: 'User' in: model) items
		== (self componentSchemaNamed: 'Alias' in: model).
	self assert:
		(self componentSchemaNamed: 'Alias' in: model) allOf anyOne
		== (self componentSchemaNamed: 'Target' in: model).
	self assertNoStubSchemasIn: model
]

{ #category : 'tests - D11 robustness (step B)' }
FamixOpenApiImporterFidelityTest >> testReferenceToAnEntityOfAnotherKindIsReportedAsRefKindMismatch [
	"A schema reference that designates a parameter is an error: #refKindMismatch, and no schema is attached."

	| model |
	model := self importOpenApi3:
		         '`paths`:{},`components`:{`schemas`:{`A`:{`type`:`array`,`items`:{`$ref`:`#/components/parameters/P`}}},`parameters`:{`P`:{`name`:`p`,`in`:`query`,`schema`:{`type`:`string`}}}}'.
	self assert:
		(importer diagnostics withCode: #refKindMismatch) notEmpty.
	self assert: (self componentSchemaNamed: 'A' in: model) items isNil
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testReferencedComponentSchemaKeepsNoRef [
	"D10: a component schema used through a $ref is the entity itself: it never carries the ref of its users."

	| model |
	model := self importOpenApi3: self forwardReferenceJson.
	self assert: (self componentSchemaNamed: 'B' in: model) ref isNil
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testRequestBodyOfLongOperationNameIsLimited [

	| id operation |
	id := String new: 100 withAll: $a.
	operation := self operationWithId: id in: (self importOpenApi3:
			              (self inlineRequestBodyMembers
				               copyReplaceAll: 'addPet'
				               with: id)).
	self
		assert: operation requestBody name
		equals: (FamixOpenApiNaming limited: id , ' requestBody').
	self
		assert: operation requestBody name size
		equals: FamixOpenApiNaming maxNameLength
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testRequestBodyOfOperationWithoutOperationIdUsesTheSynthesizedName [

	| operation |
	operation := (self
		              entitiesNamed: #Operation
		              in: (self importOpenApi3:
				               '`paths`:{`/pets`:{`post`:{`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`object`}}}},`responses`:{`200`:{`description`:`ok`}}}}}'))
		             anyOne.
	self deny: operation name isNil.
	self
		assert: operation requestBody name
		equals: operation name , ' requestBody'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testResponseHeadersAreImported [
	"D8: response headers are kept as Header entities of the response."

	| headers |
	headers := (self listPetsResponseIn:
		            (self importOpenApi3: self richDocumentJson)) headers.
	self assert: headers size equals: 1.
	self assert: headers anyOne name equals: 'X-Rate-Limit'.
	self assert: headers anyOne description equals: 'rate'.
	self
		assert: headers anyOne schema types asArray
		equals: #( 'integer' )
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testResponseLinksAreImported [
	"D8: response links are kept; the link resolves its operationId to the operation."

	| model response |
	model := self importOpenApi3: self richDocumentJson.
	response := self listPetsResponseIn: model.
	self assert: response links size equals: 1.
	self assert: response links anyOne operationId equals: 'listPets'.
	self assert: response links anyOne operation
		== (self operationWithId: 'listPets' in: model)
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testRootAndOperationSecurityRequirementsAreBothNamed [

	| model |
	model := self importOpenApi3:
		         '`security`:[{`g`:[]}],`paths`:{`/a`:{`get`:{`operationId`:`a`,`security`:[{`l`:[`s`]},{}],`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`securitySchemes`:{`g`:{`type`:`apiKey`,`in`:`header`,`name`:`x`},`l`:{`type`:`apiKey`,`in`:`query`,`name`:`y`}}}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'anonymous' 'g' 'l' ).
	self
		assert:
			((self operationWithId: 'a' in: model) securityRequirements
				 collect: #name) asArray
		equals: #( 'l' 'anonymous' )
]

{ #category : 'tests - D5 operations (step B)' }
FamixOpenApiImporterFidelityTest >> testSameNameParametersInDifferentLocationsAreBothKept [
	"D5: a header id and a query id parameter are distinct and both kept."

	| operation |
	operation := self
		             operationWithId: 'listPets'
		             in: (self importOpenApi3:
				              '`paths`:{`/pets`:{`get`:{`operationId`:`listPets`,`parameters`:[{`name`:`id`,`in`:`header`,`schema`:{`type`:`string`}},{`name`:`id`,`in`:`query`,`schema`:{`type`:`string`}}],`responses`:{`200`:{`description`:`ok`}}}}}').
	self assert: operation parameters size equals: 2.
	self
		assert: (operation parameters collect: #location) asSet
		equals: #( 'header' 'query' ) asSet
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSameSchemaIsSharedByTwoMediaTypes [
	"D2: two media types of one request body whose schema is $ref Pet both point to the very same Pet entity."

	| model pet content |
	model := self importOpenApi3: self sharedPetSchemaJson.
	pet := self componentSchemaNamed: 'Pet' in: model.
	content := (self operationWithId: 'opA' in: model) requestBody
		           content.
	self assert: content size equals: 2.
	content do: [ :each |
		self
			assert: each schema == pet
			description: 'Media type ' , each mediaType
				, ' should reference the Pet component schema' ]
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSameSchemaIsSharedByTwoParameters [
	"D2: two parameters whose schema is $ref Pet both point to the very same Pet entity."

	| model pet parameters |
	model := self importOpenApi3: self sharedPetSchemaJson.
	pet := self componentSchemaNamed: 'Pet' in: model.
	parameters := (self operationWithId: 'opA' in: model) parameters.
	self assert: parameters size equals: 2.
	parameters do: [ :each |
		self
			assert: each schema == pet
			description: 'Parameter ' , each name
				, ' should reference the Pet component schema' ]
]

{ #category : 'tests - D2 shared references' }
FamixOpenApiImporterFidelityTest >> testSameSchemaIsSharedByTwoProperties [
	"D2: two properties declared with $ref Pet both expose the very same Pet entity."

	| model pet couple |
	model := self importOpenApi3: self sharedPetSchemaJson.
	pet := self componentSchemaNamed: 'Pet' in: model.
	couple := self componentSchemaNamed: 'Couple' in: model.
	self assert: couple properties size equals: 2.
	couple properties do: [ :each |
		self
			assert: each valueSchema == pet
			description:
			'Property ' , each name
			, ' should reference the Pet component schema' ].
	self assert: pet usedAsPropertyValueBy size equals: 2
]

{ #category : 'tests - count consistency (step B)' }
FamixOpenApiImporterFidelityTest >> testSchemaEntityCountEqualsComponentSchemasPlusInlineSchemas [
	"Count consistency: 3 component schemas + 1 inline schema (the limit parameter) = 4 schema entities; $ref uses must not add stubs."

	| model |
	model := self importOpenApi3: self midSizeJson.
	self assert: (self schemasIn: model) size equals: 4
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testSchemaEntryKeyIsDistinctFromTitle [
	"D9: the component schema is named after its key (Pet) while the title is kept apart."

	| schema |
	schema := (self componentsIn: (self importOpenApi3:
			            (self schemasJson:
				             '`Pet`:{`type`:`object`,`title`:`A pet`}'))) schemas
		          anyOne.
	self assert: schema name equals: 'Pet'.
	self
		assert: schema canonicalPointer
		equals: '#/components/schemas/Pet'.
	self assert: schema title equals: 'A pet'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAdditionalPropertiesBooleanTrue [
	"D6: additionalProperties: true is kept as additionalPropertiesAllowed (renamed from the misspelled additonalPropertiesAllowed)."

	self
		assert:
			(self importedSchema:
				 '{`type`:`object`,`additionalProperties`:true}')
				additionalPropertiesAllowed
		equals: true
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAdditionalPropertiesSchema [
	"D6: additionalProperties given as a schema is kept in additionalProperties (renamed from the misspelled additonalProperties)."

	| schema |
	schema := self importedSchema:
		          '{`type`:`object`,`additionalProperties`:{`type`:`string`}}'.
	self
		assert: schema additionalProperties notNil
		description: 'additionalProperties schema should be kept'.
	self
		assert: schema additionalProperties types asArray
		equals: #( 'string' )
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAllOfMembersResolved [
	"D6: allOf members that are $ref resolve to the component entities."

	| model composed |
	model := self importOpenApi3: (self schemasJson:
			          '`Base`:{`type`:`object`},`Extra`:{`type`:`object`},`Composed`:{`allOf`:[{`$ref`:`#/components/schemas/Base`},{`$ref`:`#/components/schemas/Extra`}]}').
	composed := self componentSchemaNamed: 'Composed' in: model.
	self assert: composed allOf size equals: 2.
	self
		assert: (composed allOf includes:
				 (self componentSchemaNamed: 'Base' in: model))
		description: 'allOf should contain the Base component schema'.
	self
		assert: (composed allOf includes:
				 (self componentSchemaNamed: 'Extra' in: model))
		description: 'allOf should contain the Extra component schema'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAnyOf [
	"D6: anyOf members are kept."

	self
		assert: (self importedSchema:
				 '{`anyOf`:[{`type`:`string`},{`type`:`integer`}]}') anyOf size
		equals: 2
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsCollectionAndObjectBounds [

	| schema |
	schema := self importedSchema:
		          '{`type`:`array`,`minItems`:1,`maxItems`:4,`uniqueItems`:true,`minProperties`:2,`maxProperties`:3,`multipleOf`:5}'.
	self assert: schema minItems equals: 1.
	self assert: schema maxItems equals: 4.
	self assert: schema uniqueItems equals: true.
	self assert: schema minProperties equals: 2.
	self assert: schema maxProperties equals: 3.
	self assert: schema multipleOf equals: 5
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsConstAndExample [
	"const and example are kept as JSON text."

	| schema |
	schema := self importedSchema31:
		          '{`type`:`string`,`const`:`fixed`,`example`:`sample`}'.
	self assert: (self parsedJson: schema constValue) equals: 'fixed'.
	self assert: (self parsedJson: schema exampleValue) equals: 'sample'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsDefault [
	"D6: the default value is kept on the schema (defaultValue, as JSON text)."

	self
		assert: (self parsedJson:
				 (self importedSchema: '{`type`:`string`,`default`:`cat`}')
					 defaultValue)
		equals: 'cat'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsDescriptiveAndFlagKeywords [

	| schema |
	schema := self importedSchema:
		          '{`type`:`string`,`title`:`T`,`description`:`D`,`format`:`uuid`,`readOnly`:true,`writeOnly`:false,`deprecated`:true}'.
	self assert: schema title equals: 'T'.
	self assert: schema description equals: 'D'.
	self assert: schema format equals: 'uuid'.
	self assert: schema readOnly equals: true.
	self assert: schema writeOnly equals: false.
	self assert: schema deprecated equals: true
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsDiscriminator [
	"D6: the discriminator (Swagger 2 string form) becomes a Discriminator entity with its propertyName."

	| schema |
	schema := self importedSchema:
		          '{`type`:`object`,`discriminator`:`petType`,`properties`:{`petType`:{`type`:`string`}}}'.
	self assert: schema discriminator notNil.
	self assert: schema discriminator propertyName equals: 'petType'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsEnum [
	"D6: enum values are kept on the schema (enumValues, as JSON array text)."

	| schema |
	schema := self importedSchema:
		          '{`type`:`string`,`enum`:[`cat`,`dog`]}'.
	self
		assert: schema enumValues isNotNil
		description: 'enum should be kept'.
	self
		assert: (self parsedJson: schema enumValues) asArray
		equals: #( 'cat' 'dog' )
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsExtensionsAsJsonText [

	| schema |
	schema := self importedSchema:
		          '{`type`:`string`,`x-internal`:{`a`:1}}'.
	self
		assert: (self parsedJson: schema extensions)
		equals: (Dictionary new
				 at: 'x-internal' put: (Dictionary new
						  at: 'a' put: 1;
						  yourself);
				 yourself)
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMaxLength [
	"D6: maxLength is kept on the schema."

	self
		assert:
			(self importedSchema:
				 '{`type`:`string`,`minLength`:2,`maxLength`:5}') maxLength
		equals: 5
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMaximum [
	"D6: maximum is kept on the schema."

	self
		assert:
			(self importedSchema: '{`type`:`integer`,`minimum`:1,`maximum`:10}')
				maximum
		equals: 10
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMinLength [
	"D6: minLength is kept on the schema."

	self
		assert:
			(self importedSchema:
				 '{`type`:`string`,`minLength`:2,`maxLength`:5}') minLength
		equals: 2
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMinimum [
	"D6: minimum is kept on the schema."

	self
		assert:
			(self importedSchema: '{`type`:`integer`,`minimum`:1,`maximum`:10}')
				minimum
		equals: 1
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsNot [
	"D6: the not schema is kept (relation not)."

	| schema |
	schema := self importedSchema: '{`not`:{`type`:`string`}}'.
	self assert: schema not notNil.
	self assert: schema not types asArray equals: #( 'string' )
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsNullable [
	"D6: nullable: true is kept as isNullable."

	self
		assert:
		(self importedSchema: '{`type`:`string`,`nullable`:true}')
			isNullable
		equals: true
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsOneOf [
	"D6: oneOf members are kept."

	self
		assert: (self importedSchema:
				 '{`oneOf`:[{`type`:`string`},{`type`:`integer`}]}') oneOf size
		equals: 2
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsPattern [
	"D6: pattern is kept on the schema."

	self
		assert:
			(self importedSchema: '{`type`:`string`,`pattern`:`^[a-z]+$`}')
				pattern
		equals: '^[a-z]+$'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsPrefixItems [

	| schema |
	schema := self importedSchema31:
		          '{`type`:`array`,`prefixItems`:[{`type`:`string`},{`type`:`integer`}]}'.
	self assert: schema prefixItems size equals: 2.
	self
		assert:
		(schema prefixItems collect: [ :each | each types asArray ]) asArray
		equals: #( #( 'string' ) #( 'integer' ) )
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsRequiredPropertiesList [
	"D6: the required list of an object schema is kept on the schema itself (requiredProperties)."

	| schema |
	schema := self importedSchema:
		          '{`type`:`object`,`required`:[`id`,`name`],`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`},`nick`:{`type`:`string`}}}'.
	self
		assert: schema requiredProperties asSet
		equals: #( 'id' 'name' ) asSet
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsTypeArrayAndDerivesNullability [
	"A type array keeps its non-null types in types; null among them sets isNullable."

	| schema |
	schema := self importedSchema: '{`type`:[`string`,`null`]}'.
	self assert: schema types asArray equals: #( 'string' ).
	self assert: schema isNullable equals: true
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsXmlExternalDocsAndDiscriminatorMapping [

	| model pet |
	model := self importOpenApi3: (self schemasJson:
			          '`Dog`:{`type`:`object`},`Pet`:{`oneOf`:[{`$ref`:`#/components/schemas/Dog`}],`discriminator`:{`propertyName`:`petType`,`mapping`:{`dog`:`#/components/schemas/Dog`}},`xml`:{`name`:`pet`,`wrapped`:true},`externalDocs`:{`url`:`https://docs.example.com/pet`}}').
	pet := self componentSchemaNamed: 'Pet' in: model.
	self assert: pet discriminator propertyName equals: 'petType'.
	self assert: pet discriminator mapping size equals: 1.
	self assert: pet discriminator mapping anyOne name equals: 'dog'.
	self
		assert: pet discriminator mapping anyOne value
		equals: '#/components/schemas/Dog'.
	self assert: pet discriminator mapping anyOne schema
		== (self componentSchemaNamed: 'Dog' in: model).
	self assert: pet xml name equals: 'pet'.
	self assert: pet xml wrapped equals: true.
	self
		assert: pet externalDocs url
		equals: 'https://docs.example.com/pet'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaMarksRequiredPropertiesOnProperties [
	"D6: properties listed in the required array are flagged as required."

	| schema |
	schema := self importedSchema:
		          '{`type`:`object`,`required`:[`id`],`properties`:{`id`:{`type`:`integer`},`nick`:{`type`:`string`}}}'.
	self
		assert: (self propertyNamed: 'id' ofSchema: schema) isRequired
		equals: true.
	self
		assert: (self propertyNamed: 'nick' ofSchema: schema) isRequired
		equals: false
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testSchemaNameIsComponentKeyNotTitle [
	"D9: the entity name of a component schema is its component key (Pet), not its title."

	self
		assert: (self componentSchemaNamed: 'Pet' in: (self importOpenApi3:
					  (self schemasJson: '`Pet`:{`type`:`object`,`title`:`A pet`}')))
				name
		equals: 'Pet'
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementNameDoesNotChangeItsPointerOrScopes [

	| model requirement |
	model := self importOpenApi3:
		         '`security`:[{`a`:[`s`]}],`paths`:{},`components`:{`securitySchemes`:{`a`:{`type`:`apiKey`,`in`:`header`,`name`:`k`}}}'.
	requirement := (self openApiIn: model) securityRequirements anyOne.
	self assert: requirement name equals: 'a'.
	self assert: requirement canonicalPointer equals: '#/security/0'.
	self
		assert: (requirement items collect: #scopeNames) asArray
		equals: #( #( 's' ) )
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementNameKeepsSpacesOfSchemeNames [

	| model |
	model := self importOpenApi3:
		         '`security`:[{`my key`:[],`other key`:[]}],`paths`:{}'.
	self
		assert: (self openApiIn: model) securityRequirements anyOne name
		equals: 'my key + other key'
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementOfAnUndeclaredSchemeIsNamedAfterItAndStillReported [

	| model |
	model := self importOpenApi3: '`security`:[{`ghost`:[]}],`paths`:{}'.
	self
		assert: (self openApiIn: model) securityRequirements anyOne name
		equals: 'ghost'.
	self
		assert:
		(importer diagnostics withCode: #securitySchemeUnresolved) size
		equals: 1
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementWithOneSchemeIsNamedAfterIt [

	| model |
	model := self importOpenApi3:
		         '`security`:[{`api_key`:[]}],`paths`:{},`components`:{`securitySchemes`:{`api_key`:{`type`:`apiKey`,`in`:`header`,`name`:`k`}}}'.
	self
		assert: (self openApiIn: model) securityRequirements anyOne name
		equals: 'api_key'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementWithTwoSchemesHasTwoItems [
	"{a: [], b: []} is ONE requirement whose two items must both be satisfied."

	| model requirement |
	model := self importOpenApi3:
		         '`security`:[{`a`:[],`b`:[]}],`paths`:{},`components`:{`securitySchemes`:{`a`:{`type`:`apiKey`,`in`:`header`,`name`:`ka`},`b`:{`type`:`apiKey`,`in`:`query`,`name`:`kb`}}}'.
	requirement := (self openApiIn: model) securityRequirements anyOne.
	self
		assert: (self openApiIn: model) securityRequirements size
		equals: 1.
	self assert: requirement items size equals: 2.
	self
		assert:
		(requirement items collect: [ :each | each scheme name ]) asSet
		equals: #( 'a' 'b' ) asSet.
	self assert: requirement schemes size equals: 2
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementWithTwoSchemesIsNamedWithSortedSchemeNames [

	| model |
	model := self importOpenApi3:
		         '`security`:[{`z_auth`:[],`a_auth`:[]}],`paths`:{},`components`:{`securitySchemes`:{`z_auth`:{`type`:`apiKey`,`in`:`header`,`name`:`z`},`a_auth`:{`type`:`apiKey`,`in`:`query`,`name`:`a`}}}'.
	self
		assert: (self openApiIn: model) securityRequirements anyOne name
		equals: 'a_auth + z_auth'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testSecurityRequirementsAreAlternatives [
	"[{a: []}, {b: []}] are two requirements of one item each."

	| model |
	model := self importOpenApi3:
		         '`security`:[{`a`:[]},{`b`:[]}],`paths`:{},`components`:{`securitySchemes`:{`a`:{`type`:`apiKey`,`in`:`header`,`name`:`ka`},`b`:{`type`:`apiKey`,`in`:`query`,`name`:`kb`}}}'.
	self
		assert: (self openApiIn: model) securityRequirements size
		equals: 2.
	(self openApiIn: model) securityRequirements do: [ :each |
		self assert: each items size equals: 1 ]
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testSelfReferenceIsNotReportedAsRefCycle [

	self importOpenApi3: self selfReferenceJson.
	self assert: (importer diagnostics withCode: #refCycle) isEmpty
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testSelfReferenceLeavesNoStubAndNoDuplicate [
	"D3: self reference must not leave a stub nor a second schema named Tree."

	| model |
	model := self importOpenApi3: self selfReferenceJson.
	self assertNoStubSchemasIn: model.
	self assertExactlyOneSchemaNamed: 'Tree' in: model
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> testSelfReferenceResolvesToItself [
	"D3: a schema whose items is a $ref to itself must have items identical to itself."

	| model tree |
	model := self importOpenApi3: self selfReferenceJson.
	tree := self componentSchemaNamed: 'Tree' in: model.
	self
		assert: tree items == tree
		description: 'Tree items should be Tree itself'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testServerIsNamedByItsUrl [

	| model |
	model := self importOpenApi3:
		         '`servers`:[{`url`:`https://api.example.com/v1`}]'.
	self
		assert: (self entitiesNamed: #Server in: model) anyOne name
		equals: 'https://api.example.com/v1'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testServerVariablesAreImported [
	"D7: server variables are kept (variables of the server, with name, default and enum)."

	| server variable |
	server := (self openApiIn:
		           (self importOpenApi3: self richDocumentJson)) servers
		          anyOne.
	self assert: server variables size equals: 1.
	variable := server variables anyOne.
	self assert: variable name equals: 'env'.
	self assert: variable defaultValue equals: 'prod'.
	self assert: variable enumValues asArray equals: #( 'prod' 'dev' )
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testServerWithoutUrlIsNamedServer [

	| model |
	model := self importOpenApi3: '`servers`:[{`description`:`d`}]'.
	self
		assert: (self entitiesNamed: #Server in: model) anyOne name
		equals: 'server'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testServersAreImported [
	"D7: OAS3 servers are kept (servers of the document)."

	| openApi |
	openApi := self openApiIn:
		           (self importOpenApi3: self richDocumentJson).
	self assert: openApi servers size equals: 1.
	self
		assert: openApi servers anyOne url
		equals: 'https://{env}.example.com'
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedCallbackIsTheSameEntityFromBothUsages [
	"D2: a $ref callback is shared by the operations that declare it."

	| model component |
	model := self importOpenApi3: self sharedCallbackJson.
	component := self
		             componentIn: (self componentsIn: model) callbacks
		             pointer: '#/components/callbacks/OnEvent'.
	self assert:
		(self operationWithId: 'opA' in: model) callbacks anyOne
		== component.
	self assert:
		(self operationWithId: 'opB' in: model) callbacks anyOne
		== component.
	self assert: component usedByOperations size equals: 2.
	self assert: component pathItems size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testSharedComponentRequestBodyKeepsItsComponentKey [

	| model |
	model := self importOpenApi3: self sharedComponentsJson.
	self assert: (self requestBodyNamesIn: model) equals: #( 'PetBody' ).
	self
		assert: (self operationWithId: 'opA' in: model) requestBody name
		equals: 'PetBody'.
	self
		assert: (self operationWithId: 'opB' in: model) requestBody name
		equals: 'PetBody'
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedExampleIsTheSameEntityFromBothUsages [
	"D2: a $ref example is shared by the media types that use it."

	| model component exampleA exampleB |
	model := self importOpenApi3: self sharedExampleJson.
	component := self
		             componentIn: (self componentsIn: model) examples
		             pointer: '#/components/examples/Cat'.
	exampleA := (self
		             mediaTypeNamed: 'application/json'
		             of:
		             (self
			              responseOf: (self operationWithId: 'opA' in: model)
			              code: '200')) examples anyOne.
	exampleB := (self
		             mediaTypeNamed: 'application/json'
		             of:
		             (self
			              responseOf: (self operationWithId: 'opB' in: model)
			              code: '200')) examples anyOne.
	self assert: exampleA == component.
	self assert: exampleB == component.
	self assert: component usedByMediaTypes size equals: 2.
	self assert: component summary equals: 'a cat'.
	self
		assert: (self parsedJson: component value)
		equals: (Dictionary new
				 at: 'name' put: 'tom';
				 yourself)
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedHeaderIsTheSameEntityFromBothUsages [
	"D2: a $ref header is shared: the responses of two operations reach the very same Header, the component."

	| model component headerA headerB |
	model := self importOpenApi3: self sharedHeaderJson.
	component := self
		             componentIn: (self componentsIn: model) headers
		             pointer: '#/components/headers/Rate'.
	headerA := (self
		            responseOf: (self operationWithId: 'opA' in: model)
		            code: '200') headers anyOne.
	headerB := (self
		            responseOf: (self operationWithId: 'opB' in: model)
		            code: '200') headers anyOne.
	self assert: headerA == component.
	self assert: headerB == component.
	self assert: component usedByResponses size equals: 2
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedLinkIsTheSameEntityFromBothUsages [
	"D2: a $ref link is shared by the responses that use it; it targets the linked operation."

	| model component linkA linkB |
	model := self importOpenApi3: self sharedLinkJson.
	component := self
		             componentIn: (self componentsIn: model) links
		             pointer: '#/components/links/Next'.
	linkA := (self
		          responseOf: (self operationWithId: 'opA' in: model)
		          code: '200') links anyOne.
	linkB := (self
		          responseOf: (self operationWithId: 'opB' in: model)
		          code: '200') links anyOne.
	self assert: linkA == component.
	self assert: linkB == component.
	self assert: component usedByResponses size equals: 2.
	self assert:
		component operation == (self operationWithId: 'opB' in: model)
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedParameterIsReachedFromBothOperations [
	"D2: two operations referencing the same #/components/parameters/Limit both reach the same parameter entity."

	| model shared |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          componentIn: (self componentsIn: model) parameters
		          pointer: '#/components/parameters/Limit'.
	self
		assert:
			((self operationWithId: 'opA' in: model) parameters anySatisfy: [
				 :each | each == shared ])
		description: 'opA should reach the shared Limit parameter'.
	self
		assert:
			((self operationWithId: 'opB' in: model) parameters anySatisfy: [
				 :each | each == shared ])
		description: 'opB should reach the shared Limit parameter'.
	self assert: shared usedByOperations size equals: 2
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedParameterIsReachedFromBothPaths [
	"D2: two paths declaring the same path-level #/components/parameters/Limit both reach the same parameter entity."

	| model shared paths |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          componentIn: (self componentsIn: model) parameters
		          pointer: '#/components/parameters/Limit'.
	paths := self entitiesNamed: #Path in: model.
	self assert: paths size equals: 2.
	paths do: [ :each |
		self
			assert:
			(each parameters anySatisfy: [ :parameter | parameter == shared ])
			description:
			'Path ' , each name , ' should reach the shared Limit parameter' ].
	self assert: shared usedByPaths size equals: 2
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedPathItemIsTheSameEntityFromBothUsages [
	"D2: a $ref path item is shared by the callbacks that use it."

	| model component callbackA callbackB |
	model := self importOpenApi31: self sharedPathItemJson.
	component := self
		             componentIn: (self componentsIn: model) pathItems
		             pointer: '#/components/pathItems/Common'.
	callbackA := (self operationWithId: 'opA' in: model) callbacks anyOne.
	callbackB := (self operationWithId: 'opB' in: model) callbacks anyOne.
	self assert: callbackA pathItems anyOne == component.
	self assert: callbackB pathItems anyOne == component.
	self assert: component usedByCallbacks size equals: 2
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedRequestBodyIsReachedFromBothOperations [
	"D2: two operations referencing the same #/components/requestBodies/PetBody both reach the same request body entity."

	| model shared |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          componentIn: (self componentsIn: model) requestBodies
		          pointer: '#/components/requestBodies/PetBody'.
	self
		assert:
		(self operationWithId: 'opA' in: model) requestBody == shared
		description: 'opA should reach the shared PetBody'.
	self
		assert:
		(self operationWithId: 'opB' in: model) requestBody == shared
		description: 'opB should reach the shared PetBody'.
	self assert: shared usedByOperations size equals: 2
]

{ #category : 'tests - D2 shared references (step B)' }
FamixOpenApiImporterFidelityTest >> testSharedResponseIsClonedPerOperation [
	"D2, meaning changed by design: replaces testSharedResponseIsReachedFromBothOperations. A reusable response is copied for each operation, so the two operations reach two distinct responses that both come from #/components/responses/NotFound."

	| model component cloneA cloneB |
	model := self importOpenApi3: self sharedComponentsJson.
	component := self
		             componentIn: (self componentsIn: model) responses
		             pointer: '#/components/responses/NotFound'.
	cloneA := self
		          responseOf: (self operationWithId: 'opA' in: model)
		          code: '404'.
	cloneB := self
		          responseOf: (self operationWithId: 'opB' in: model)
		          code: '404'.
	self
		assert: cloneA ~~ cloneB
		description: 'each operation owns its own response'.
	self assert: cloneA ~~ component.
	self assert: cloneB ~~ component.
	self assert: cloneA description equals: 'nf'.
	self assert: cloneB description equals: 'nf'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testSlashEscapedPointerResolvesToComponentKeyWithSlash [
	"D12: ~1 in a pointer stands for / : #/components/schemas/a~1b resolves to the schema keyed 'a/b'."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`a/b`:{`type`:`object`},`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/a~1b`}}').
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'a/b' in: model)
		description: 'items should be the a/b component entity'.
	self
		assert:
		(self componentSchemaNamed: 'a/b' in: model) canonicalPointer
		equals: '#/components/schemas/a~1b'
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testStringWhereSchemaIsExpectedCreatesNoEntityAndDoesNotRaise [
	"D11: a JSON string where a schema object is expected must neither raise nor create a schema entity (it is reported as #wrongNodeType)."

	| model |
	self
		shouldnt: [
			model := self importOpenApi3: (self schemasJson:
					          '`Pet`:{`type`:`object`,`items`:`string`,`properties`:{`a`:`string`}}') ]
		raise: Error.
	self assert: (self schemasIn: model) size equals: 1.
	self assert: (importer diagnostics withCode: #wrongNodeType) notEmpty
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2ApiKeyDefinitionKeepsNameAndLocation [

	| model scheme |
	model := self importSwagger2: self swagger2SecurityJson.
	scheme := (self componentsIn: model) securitySchemes detect: [ :each |
		          each name = 'key' ].
	self assert: scheme type equals: 'apiKey'.
	self assert: scheme parameterName equals: 'X-Key'.
	self assert: scheme inLocation equals: 'query'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2BodyParameterRefResolvesToDefinition [
	"D4: the body parameter becomes the request body of the operation; its schema $ref #/definitions/Pet is the definition entity."

	| model definition operation |
	model := self importSwagger2: self swagger2PetJson.
	definition := self componentSchemaNamed: 'Pet' in: model.
	operation := self operationWithId: 'addPet' in: model.
	self
		assert: operation requestBody notNil
		description: 'The body parameter should become the request body'.
	self assert: operation requestBody content size equals: 1.
	self
		assert: operation requestBody content anyOne schema == definition
		description: 'The body schema should reference the Pet definition'.
	self
		assert:
		(operation parameters noneSatisfy: [ :each | each name = 'body' ])
		description: 'the body parameter is not a parameter any more'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testSwagger2BodyParameterReferenceToGlobalParameterIsNamedAfterItsOperation [
	"The synthesized body is built from the resolved node at the site pointer: it is an inline request body, named after each operation that uses it."

	| model |
	model := self importSwagger2: self swagger2ReferencedBodyJson.
	self
		assert: (self operationWithId: 'addPet' in: model) requestBody name
		equals: 'addPet requestBody'.
	self
		assert: (self operationWithId: 'addDog' in: model) requestBody name
		equals: 'addDog requestBody'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testSwagger2BodyParameterRequestBodyIsNamedAfterItsOperation [

	| operation |
	operation := self
		             operationWithId: 'addPet'
		             in: (self importSwagger2: self swagger2PetJson).
	self assert: operation requestBody name equals: 'addPet requestBody'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2BodyParameterRequestBodyTakesThePointerOfTheParameter [
	"Convention: canonicalPointer = the position of the SOURCE node. The request body synthesized from the `in: body` parameter has the pointer of that parameter."

	| operation |
	operation := self
		             operationWithId: 'addPet'
		             in: (self importSwagger2: self swagger2PetJson).
	self assert: operation requestBody notNil.
	self
		assert: operation requestBody canonicalPointer
		equals: '#/paths/~1pets/post/parameters/0'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2ConsumesBecomesTheMediaTypesOfTheRequestBody [

	| model body |
	model := self importSwagger2: self swagger2MediaTypesJson.
	body := (self operationWithId: 'opA' in: model) requestBody.
	self
		assert: (body content collect: #mediaType) asArray
		equals: #( 'application/xml' ).
	self
		assert: body content anyOne schema types asArray
		equals: #( 'object' )
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefaultMediaTypeIsWildcardWhenProducesIsAbsent [
	"The version hooks spec: without produces the media type of a response schema is */*."

	| response |
	response := self
		            responseOf: (self
				             operationWithId: 'addPet'
				             in: (self importSwagger2: self swagger2PetJson))
		            code: '200'.
	self
		assert: (response content collect: #mediaType) asArray
		equals: #( '*/*' )
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefinitionIsAlsoReachedThroughTheComponentsPointer [
	"D4: a ref written #/components/schemas/B for a Swagger 2 definition B resolves to the same entity as #/definitions/B (the index accepts both spellings)."

	| model |
	model := self importSwagger2:
		         '`paths`:{},`definitions`:{`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/B`}},`B`:{`type`:`object`}}'.
	self assert: (self componentSchemaNamed: 'A' in: model) items
		== (self componentSchemaNamed: 'B' in: model).
	self assert: (self stubSchemasIn: model) isEmpty
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefinitionLeavesNoStubSchema [
	"D4: resolving #/definitions/Pet must not leave a ref-only stub schema."

	self assertNoStubSchemasIn:
		(self importSwagger2: self swagger2PetJson)
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefinitionReferenceResolvesToSchema [
	"D4: a #/definitions/B reference resolves to the schema imported from the definition B, whose canonicalPointer is its document position #/definitions/B."

	| model |
	model := self importSwagger2:
		         '`paths`:{},`definitions`:{`A`:{`type`:`array`,`items`:{`$ref`:`#/definitions/B`}},`B`:{`type`:`object`}}'.
	self assert: (self componentSchemaNamed: 'A' in: model) items
		== (self componentSchemaNamed: 'B' in: model).
	self
		assert: (self componentSchemaNamed: 'B' in: model) canonicalPointer
		equals: '#/definitions/B'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefinitionsAreImported [
	"D4: definitions are imported as component schemas (name Pet). Convention: canonicalPointer is the position of the SOURCE node the entity comes from, so a Swagger 2 definition keeps its document position #/definitions/Pet (not #/components/schemas/Pet) and its properties live under #/definitions/Pet/properties/..."

	| model schemas pet |
	model := self importSwagger2: self swagger2PetJson.
	schemas := (self componentsIn: model) schemas.
	self assert: schemas size equals: 1.
	pet := schemas anyOne.
	self assert: pet name equals: 'Pet'.
	self assert: pet canonicalPointer equals: '#/definitions/Pet'.
	self assert: pet properties size equals: 2.
	self
		assert: (self propertyNamed: 'name' ofSchema: pet) canonicalPointer
		equals: '#/definitions/Pet/properties/name'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2FileFormDataParameterBecomesABinaryProperty [

	| model body schema |
	model := self importSwagger2: self swagger2FormJson.
	body := (self operationWithId: 'upload' in: model) requestBody.
	self
		assert: (body content collect: #mediaType) asArray
		equals: #( 'multipart/form-data' ).
	schema := body content anyOne schema.
	self
		assert:
		(self propertyNamed: 'f' ofSchema: schema) valueSchema types asArray
		equals: #( 'string' ).
	self
		assert:
		(self propertyNamed: 'f' ofSchema: schema) valueSchema format
		equals: 'binary'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2FormDataParametersBecomeAFormRequestBody [
	"formData parameters are the properties of the schema of a form media type; required ones are listed in requiredProperties."

	| model body schema |
	model := self importSwagger2: self swagger2FormJson.
	body := (self operationWithId: 'submit' in: model) requestBody.
	self assert: body notNil.
	self
		assert: (body content collect: #mediaType) asArray
		equals: #( 'application/x-www-form-urlencoded' ).
	schema := body content anyOne schema.
	self
		assert: (schema properties collect: #name) asArray sort
		equals: #( 'a' 'b' ).
	self assert: schema requiredProperties asArray equals: #( 'b' ).
	self
		assert:
		(self propertyNamed: 'b' ofSchema: schema) valueSchema types asArray
		equals: #( 'integer' ).
	self assert:
		((self operationWithId: 'submit' in: model) parameters noneSatisfy: [
			 :each | each location = 'formData' ])
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testSwagger2FormDataRequestBodyIsNamedAfterItsOperation [

	| model |
	model := self importSwagger2: self swagger2FormJson.
	self
		assert: (self operationWithId: 'submit' in: model) requestBody name
		equals: 'submit requestBody'.
	self
		assert: (self operationWithId: 'upload' in: model) requestBody name
		equals: 'upload requestBody'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2GlobalParametersAreImported [
	"D4: top level parameters are imported as component parameters; convention: canonicalPointer = position of the source node, here #/parameters/Trace."

	| parameters |
	parameters := (self componentsIn:
		               (self importSwagger2: self swagger2PetJson))
		              parameters.
	self assert: parameters size equals: 1.
	self
		assert: parameters anyOne canonicalPointer
		equals: '#/parameters/Trace'.
	self assert: parameters anyOne name equals: 'trace'.
	self assert: parameters anyOne location equals: 'header'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2GlobalResponsesAreImportedAndReferenced [
	"D4: top level responses are imported as component responses and #/responses/GenericError is copied to the default response of the operation (a clone keeping the ref)."

	| model component response |
	model := self importSwagger2: self swagger2PetJson.
	component := self
		             componentIn: (self componentsIn: model) responses
		             pointer: '#/responses/GenericError'.
	response := self
		            responseOf: (self operationWithId: 'addPet' in: model)
		            code: 'default'.
	self assert: (self componentsIn: model) responses size equals: 1.
	self assert: response ref equals: '#/responses/GenericError'.
	self assert: response description equals: component description.
	self assert: response ~~ component
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2HostBasePathAndSchemesBecomeServers [
	"D4: host, basePath and schemes of a Swagger 2 document are imported as servers."

	| openApi |
	openApi := self openApiIn: (self importJson: (self jsonFrom:
				             '{`swagger`:`2.0`,`info`:{`title`:`t`,`version`:`1`},`host`:`api.example.com`,`basePath`:`/v1`,`schemes`:[`https`,`http`],`paths`:{}}')).
	self
		assert: (openApi servers collect: #url) asArray
		equals:
		#( 'https://api.example.com/v1' 'http://api.example.com/v1' )
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2InlineParameterKeepsCollectionFormat [
	"D4: the collectionFormat csv of an inline array parameter becomes style form without explode."

	| model ids |
	model := self importSwagger2: self swagger2PetJson.
	ids := (self operationWithId: 'addPet' in: model) parameters detect: [
		       :each | each name = 'ids' ].
	self assert: ids style equals: 'form'.
	self assert: ids explode equals: false
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2InlineParameterKeepsTypeAndFormatOfItems [
	"D4: an inline array parameter keeps its type and items (with the items format) in the schema of the parameter."

	| model ids |
	model := self importSwagger2: self swagger2PetJson.
	ids := (self operationWithId: 'addPet' in: model) parameters detect: [
		       :each | each name = 'ids' ].
	self assert: ids location equals: 'query'.
	self assert: ids schema notNil.
	self assert: ids schema types asArray equals: #( 'array' ).
	self
		assert: ids schema items notNil
		description: 'The items of the parameter should be kept'.
	self assert: ids schema items types asArray equals: #( 'integer' ).
	self assert: ids schema items format equals: 'int64'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2InlineQueryParameterKeepsItsPositionInTheDocument [
	"The second parameter of the post operation is a regular parameter: its pointer is its position (index 1)."

	| operation |
	operation := self
		             operationWithId: 'addPet'
		             in: (self importSwagger2: self swagger2PetJson).
	self assert: operation parameters size equals: 1.
	self
		assert: operation parameters anyOne canonicalPointer
		equals: '#/paths/~1pets/post/parameters/1'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2NullableExtensionBecomesIsNullable [
	"D4: the Swagger 2 vendor extension x-nullable: true is the nullable flag of the schema."

	| model |
	model := self importSwagger2:
		         '`paths`:{},`definitions`:{`S`:{`type`:`string`,`x-nullable`:true}}'.
	self
		assert: (self componentSchemaNamed: 'S' in: model) isNullable
		equals: true
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2OAuth2AccessCodeFlowBecomesAuthorizationCodeFlow [

	| model scheme flow |
	model := self importSwagger2: self swagger2SecurityJson.
	scheme := (self componentsIn: model) securitySchemes detect: [ :each |
		          each name = 'oauth' ].
	self assert: scheme type equals: 'oauth2'.
	self assert: scheme flows size equals: 1.
	flow := scheme flows anyOne.
	self assert: flow flowType equals: 'authorizationCode'.
	self assert: flow authorizationUrl equals: 'https://auth.example.com'.
	self assert: flow tokenUrl equals: 'https://token.example.com'.
	self assert: (flow scopes collect: #name) asArray equals: #( 'read' )
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2ProducesBecomesTheMediaTypesOfTheResponses [
	"The root produces applies to every operation, an operation produces overrides it."

	| model |
	model := self importSwagger2: self swagger2MediaTypesJson.
	self
		assert:
			((self
				  responseOf: (self operationWithId: 'opA' in: model)
				  code: '200') content collect: #mediaType) asArray
		equals: #( 'application/json' ).
	self
		assert:
			((self
				  responseOf: (self operationWithId: 'opB' in: model)
				  code: '200') content collect: #mediaType) asArray sort
		equals: #( 'text/csv' 'text/plain' )
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2ReferencedDefinitionAndComponentSpellingResolveToTheSameEntityFromAnOperation [
	"A response schema written #/components/schemas/Pet or #/definitions/Pet reaches the same definition."

	| model |
	model := self importSwagger2:
		         '`paths`:{`/a`:{`get`:{`operationId`:`a`,`responses`:{`200`:{`description`:`ok`,`schema`:{`$ref`:`#/definitions/Pet`}}}},`post`:{`operationId`:`b`,`responses`:{`200`:{`description`:`ok`,`schema`:{`$ref`:`#/components/schemas/Pet`}}}}}},`definitions`:{`Pet`:{`type`:`object`}}'.
	self assert: (self
			 mediaTypeNamed: '*/*'
			 of:
			 (self
				  responseOf: (self operationWithId: 'a' in: model)
				  code: '200')) schema == (self
			 mediaTypeNamed: '*/*'
			 of:
			 (self
				  responseOf: (self operationWithId: 'b' in: model)
				  code: '200')) schema
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2ResponseSchemaRefResolvesToDefinition [
	"D4: the response schema $ref #/definitions/Pet becomes the schema of the media type of the response and is the definition entity."

	| model definition response |
	model := self importSwagger2: self swagger2PetJson.
	definition := self componentSchemaNamed: 'Pet' in: model.
	response := self
		            responseOf: (self operationWithId: 'addPet' in: model)
		            code: '200'.
	self assert: response content size equals: 1.
	self
		assert: response content anyOne schema notNil
		description: 'The response schema should be kept'.
	self
		assert: response content anyOne schema == definition
		description: 'The response schema should be the Pet definition'
]

{ #category : 'tests - D4 swagger 2.0 (step C)' }
FamixOpenApiImporterFidelityTest >> testSwagger2SecurityDefinitionsAreImported [
	"D4: securityDefinitions are imported as component security schemes; the basic type becomes http basic."

	| schemes |
	schemes := (self componentsIn:
		            (self importSwagger2: self swagger2PetJson))
		           securitySchemes.
	self assert: schemes size equals: 1.
	self assert: schemes anyOne name equals: 'basic'.
	self
		assert: schemes anyOne canonicalPointer
		equals: '#/securityDefinitions/basic'.
	self assert: schemes anyOne type equals: 'http'.
	self assert: schemes anyOne scheme equals: 'basic'
]

{ #category : 'tests - N3 security requirement names' }
FamixOpenApiImporterFidelityTest >> testSwagger2SecurityRequirementsAreNamed [

	| model |
	model := self importSwagger2:
		         '`security`:[{`oauth`:[`read`],`key`:[]}],`paths`:{},`securityDefinitions`:{`key`:{`type`:`apiKey`,`name`:`X-Key`,`in`:`query`},`oauth`:{`type`:`oauth2`,`flow`:`accessCode`,`authorizationUrl`:`https://auth.example.com`,`tokenUrl`:`https://token.example.com`,`scopes`:{`read`:`Read`}}}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'key + oauth' )
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testSwagger2ServerWithoutHostIsNamedByItsBasePath [

	| model |
	model := self importSwagger2: '`basePath`:`/api`'.
	self
		assert: (self entitiesNamed: #Server in: model) anyOne name
		equals: '/api'
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testSwagger2SynthesizedServerIsNamedByItsUrl [

	| model |
	model := self importSwagger2:
		         '`host`:`h.example.com`,`basePath`:`/api`,`schemes`:[`https`,`http`]'.
	self
		assert:
		((self entitiesNamed: #Server in: model) collect: #name) asSet
		equals:
		#( 'https://h.example.com/api' 'http://h.example.com/api' ) asSet
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2VersionIsStored [
	"D4: the swagger: 2.0 version string is kept in sourceVersion; openapiVersion is the normalised 3.1 one."

	| openApi |
	openApi := self openApiIn:
		           (self importSwagger2: self swagger2PetJson).
	self assert: openApi sourceVersion equals: '2.0'.
	self assert: (openApi openapiVersion beginsWith: '3.1')
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testTagsAreImported [
	"D7: the tags of the document are kept as Tag entities."

	self
		assert:
			(self openApiIn: (self importOpenApi3: self richDocumentJson)) tags
				anyOne name
		equals: 'pets'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testTildeEscapedPointerResolvesToComponentKeyWithTilde [
	"D12: ~0 in a pointer stands for ~ : #/components/schemas/a~0b resolves to the schema keyed 'a~b'."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`a~b`:{`type`:`object`},`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/a~0b`}}').
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'a~b' in: model)
		description: 'items should be the a~b component entity'.
	self
		assert:
		(self componentSchemaNamed: 'a~b' in: model) canonicalPointer
		equals: '#/components/schemas/a~0b'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testTopLevelSecurityRequirementIsImported [
	"D8: the top-level security requirement is kept on the document."

	| model requirements |
	model := self importOpenApi3: self richDocumentJson.
	requirements := (self openApiIn: model) securityRequirements.
	self assert: requirements size equals: 1.
	self assert: requirements anyOne items size equals: 1.
	self assert: requirements anyOne items anyOne scheme
		== (self apiKeySchemeIn: model).
	self assert: requirements anyOne items anyOne scopeNames isEmpty
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testUnmodelledSchemaKeywordIsReported [
	"A JSON Schema keyword the model does not map is reported, not silently dropped."

	self importedSchema31:
		'{`type`:`object`,`patternProperties`:{`^x`:{`type`:`string`}}}'.
	self assert:
		(importer diagnostics withCode: #unmodelledKeyword) notEmpty
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testUnresolvedExternalReferenceIsListedOnTheDocument [
	"D7: a $ref to another document cannot be resolved: it is listed in unresolvedReferences with the $ref as target and the pointer of the site as canonicalPointer."

	| openApi reference |
	openApi := self openApiIn: (self importOpenApi3: (self schemasJson:
				             '`A`:{`type`:`array`,`items`:{`$ref`:`other.json#/components/schemas/Pet`}}')).
	self assert: openApi unresolvedReferences size equals: 1.
	reference := openApi unresolvedReferences anyOne.
	self
		assert: reference target
		equals: 'other.json#/components/schemas/Pet'.
	self
		assert: reference canonicalPointer
		equals: '#/components/schemas/A/items'.
	self assert:
		(importer diagnostics withCode: #unresolvedReference) notEmpty
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testUnresolvedReferenceDoesNotCreateStubSchema [
	"D11: a dangling $ref must not leave a ref-only stub schema in the model."

	self assertNoStubSchemasIn: (self importOpenApi3: (self schemasJson:
				  '`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Missing`}}'))
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testUnresolvedReferenceIsReportedAsDiagnostic [
	"D11: a $ref to a missing target is reported by the diagnostics of the importer instead of silently creating a stub."

	self importOpenApi3: (self schemasJson:
			 '`A`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Missing`}}').
	self
		assert: importer diagnostics notEmpty
		description: 'The dangling $ref should be reported'.
	self assert:
		(importer diagnostics withCode: #unresolvedReference) notEmpty
]

{ #category : 'tests' }
FamixOpenApiImporterFidelityTest >> testWebhookRequestBodyIsNamedAfterTheWebhookOperation [

	| operation |
	operation := self
		             operationWithId: 'onPet'
		             in: (self importOpenApi31:
				              '`paths`:{},`webhooks`:{`petEvent`:{`post`:{`operationId`:`onPet`,`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`object`}}}},`responses`:{`200`:{`description`:`ok`}}}}}').
	self assert: operation requestBody name equals: 'onPet requestBody'
]

{ #category : 'tests - D7 D8 missing sections (step B)' }
FamixOpenApiImporterFidelityTest >> testWebhooksAreImportedAsPathItems [
	"OpenAPI 3.1 webhooks are path items of the document that are not among its paths."

	| model openApi |
	model := self importOpenApi31:
		         '`webhooks`:{`newPet`:{`post`:{`operationId`:`onNewPet`,`responses`:{`200`:{`description`:`ok`}}}}}'.
	openApi := self openApiIn: model.
	self assert: openApi webhooks size equals: 1.
	self assert: openApi webhooks anyOne webhookOf == openApi.
	self assert: openApi paths isEmpty.
	self
		assert: openApi webhooks anyOne canonicalPointer
		equals: '#/webhooks/newPet'.
	self assert: (self operationWithId: 'onNewPet' in: model) path
		== openApi webhooks anyOne
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testWhitespaceInfoTitleNamesTheInfoInfo [

	self assert: (self infoNameOfTitle: '` \n\t `') equals: 'info'
]

{ #category : 'tests - N6 blank names' }
FamixOpenApiImporterFidelityTest >> testWhitespaceSchemeKeyIsLeftOutOfTheRequirementName [

	| model |
	model := self importOpenApi3:
		         '`security`:[{`  `:[],`b`:[],`a`:[]},{` `:[]}],`paths`:{}'.
	self
		assert: (self securityRequirementNamesIn: model)
		equals: #( 'a + b' 'anonymous' )
]

{ #category : 'fixtures' }
FamixOpenApiImporterFidelityTest >> verbsJson [

	^ self jsonFrom:
		  '`paths`:{`/pets`:{`parameters`:[{`name`:`traceId`,`in`:`header`,`schema`:{`type`:`string`}}],`post`:{`operationId`:`createPet`,`responses`:{`200`:{`description`:`ok`}}},`put`:{`operationId`:`replacePet`,`responses`:{`200`:{`description`:`ok`}}},`delete`:{`operationId`:`deletePet`,`responses`:{`200`:{`description`:`ok`}}},`patch`:{`operationId`:`updatePet`,`responses`:{`200`:{`description`:`ok`}}}}}'
]
