Class {
	#name : 'FamixOpenApiImporterTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> githubOfficialOpenApiJson [

	| response |
	[ response := ZnEasy get: self githubOfficialOpenApiJsonUrl ]
		on: Error
		do: [ :error |
			self fail: 'Failed to download GitHub official OpenAPI JSON: '
				, error messageText ].
	^ response contents
]

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> githubOfficialOpenApiJsonUrl [

	^ 'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json'
]

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> minimalOpenApi3Json [

	^ self jsonFrom:
		  '{`openapi`:`3.0.4`,`info`:{`title`:`Sample OpenAPI 3 API`,`version`:`1.0.0`},`paths`:{`/pets`:{`parameters`:[{`$ref`:`#/components/parameters/TraceId`}],`post`:{`operationId`:`createPet`,`parameters`:[{`name`:`limit`,`in`:`query`,`required`:false,`schema`:{`type`:`integer`}}],`requestBody`:{`$ref`:`#/components/requestBodies/PetPayload`},`responses`:{`201`:{`description`:`created`,`content`:{`application/json`:{`schema`:{`$ref`:`#/components/schemas/Pet`}}}}}}}},`components`:{`schemas`:{`Pet`:{`type`:`object`,`description`:`A pet schema`,`required`:[`id`],`properties`:{`id`:{`type`:`string`},`name`:{`type`:`string`,`enum`:[`cat`,`dog`]}}},`PetList`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Pet`}},`TagList`:{`type`:`array`,`items`:{`type`:`string`}}},`requestBodies`:{`PetPayload`:{`description`:`payload`,`required`:true,`content`:{`application/json`:{`schema`:{`$ref`:`#/components/schemas/Pet`}}}}},`responses`:{`GenericError`:{`description`:`generic error`}},`parameters`:{`TraceId`:{`name`:`traceId`,`in`:`header`,`required`:false,`schema`:{`type`:`string`}}},`securitySchemes`:{`ApiKeyAuth`:{`type`:`apiKey`,`name`:`X-API-Key`,`in`:`header`}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> minimalOpenApi3JsonWithPathParametersOnly [

	^ self jsonFrom:
		  '{`openapi`:`3.0.4`,`info`:{`title`:`Sample OpenAPI 3 API`,`version`:`1.0.0`},`paths`:{`/pets`:{`parameters`:[{`$ref`:`#/components/parameters/TraceId`}],`get`:{`operationId`:`listPets`,`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`parameters`:{`TraceId`:{`name`:`traceId`,`in`:`header`,`required`:false,`schema`:{`type`:`string`}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> minimalSwaggerJson [

	^ self jsonFrom:
		  '{`swagger`:`2.0`,`info`:{`title`:`Sample API`,`version`:`1.0.0`},`paths`:{`/pets`:{`summary`:`Pets path`,`description`:`Operations about pets`,`get`:{`operationId`:`listPets`,`responses`:{`200`:{`description`:`ok`}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> minimalSwaggerJsonWithReferences [
	"The old fixture referenced #/responses/GenericError without declaring it; the target is declared here so the reference resolves."

	^ self jsonFrom:
		  '{`swagger`:`2.0`,`info`:{`title`:`Sample API`,`version`:`1.0.0`},`paths`:{`/pets`:{`get`:{`operationId`:`listPets`,`responses`:{`default`:{`$ref`:`#/responses/GenericError`}}}}},`responses`:{`GenericError`:{`description`:`generic error`}}}'
]

{ #category : 'fixtures' }
FamixOpenApiImporterTest >> richRootJson [
	"A document whose root object uses every root field of OpenAPI 3.1."

	^ self jsonFrom:
		  '{`openapi`:`3.1.0`,`jsonSchemaDialect`:`https://json-schema.org/draft/2020-12/schema`,`info`:{`title`:`Rich API`,`version`:`2.3.4`,`description`:`long description`,`termsOfService`:`https://example.com/terms`,`contact`:{`name`:`Support`,`url`:`https://example.com/support`,`email`:`support@example.com`},`license`:{`name`:`MIT`,`url`:`https://opensource.org/licenses/MIT`}},`servers`:[{`url`:`https://api.example.com/v1`,`description`:`production`},{`url`:`https://staging.example.com`}],`tags`:[{`name`:`pets`,`description`:`Pet operations`,`externalDocs`:{`url`:`https://docs.example.com/pets`}},{`name`:`stores`}],`externalDocs`:{`url`:`https://docs.example.com`,`description`:`full docs`},`paths`:{}}'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testGeneratedClassLookupUsesCurrentPrefix [

	| generatedOpenApiClass expectedClassName |
	expectedClassName := (FamixOpenApiGenerator prefix asString
	                      , 'OpenApi') asSymbol.
	generatedOpenApiClass := self generatedClassNamed: #OpenApi.
	self assert: generatedOpenApiClass name equals: expectedClassName
]

{ #category : 'tests (step C)' }
FamixOpenApiImporterTest >> testImportCopiesRefOnResponseClones [
	"Changed from testImportCopiesRefOnReferenceableEntities: a shared Path or Parameter is the component itself (no ref), only a Response is cloned per operation and keeps the $ref it comes from."

	| model operation response component |
	model := self importJson: self minimalSwaggerJsonWithReferences.
	operation := self operationWithId: 'listPets' in: model.
	response := self responseOf: operation code: 'default'.
	component := self
		             componentIn: (self componentsIn: model) responses
		             pointer: '#/responses/GenericError'.
	self assert: response ref equals: '#/responses/GenericError'.
	self assert: response ~~ component.
	self assert: response description equals: 'generic error'
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportCopiesSummaryAndDescriptionOnPath [

	| path |
	path := (self
		         entitiesNamed: #Path
		         in: (self importJson: self minimalSwaggerJson)) anyOne.
	self assert: path summary equals: 'Pets path'.
	self assert: path description equals: 'Operations about pets'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCreatesOneOpenApiEntity [
	"Renamed from testImportCreatesOneApiEntity: the root class is OPOpenApi."

	| model |
	model := self importJson: self minimalSwaggerJson.
	self
		assert:
		(model allWithType: (self generatedClassNamed: #OpenApi)) size
		equals: 1
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportCreatesPathAndOperationEntities [

	| model |
	model := self importJson: self minimalSwaggerJson.
	self assert: (self entitiesNamed: #Path in: model) size equals: 1.
	self
		assert: (self entitiesNamed: #Operation in: model) size
		equals: 1
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportCreatesResponseEntities [
	"Replaces testImportCreatesResponseAndResponseEntryEntities: there is no ResponseEntry any more, the Response owns its status code."

	| model |
	model := self importJson: self minimalSwaggerJson.
	self assert: (self entitiesNamed: #Response in: model) size equals: 1.
	self
		assert: (self entitiesNamed: #Response in: model) anyOne statusCode
		equals: '200'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportDocumentWithoutServersGetsTheDefaultServer [
	"An OpenAPI 3 document without servers has the implicit server whose url is /."

	| openApi |
	openApi := self openApiIn: (self importOpenApi3: '`paths`:{}').
	self assert: (openApi servers collect: #url) asArray equals: #( '/' )
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportFromJsonFileReturnsModel [

	| fileReference model |
	fileReference := FileSystem memory / 'minimal-openapi.json'.
	fileReference writeStreamDo: [ :stream |
		stream nextPutAll: self minimalSwaggerJson ].
	model := FamixOpenApiImporter new importFromFile: fileReference.
	self assert: model notNil.
	self assert: (self entitiesNamed: #OpenApi in: model) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportFromJsonStringReturnsModel [

	| model |
	model := self importJson: self minimalSwaggerJson.
	self assert: model notNil.
	self assert: (model isKindOf: (self generatedClassNamed: #Model))
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportKeepsSourceVersionAndNormalisesTheCanonicalOne [
	"3.0.4 is kept in sourceVersion; openapiVersion is the 3.1 version the model is normalised to."

	| openApi |
	openApi := self openApiIn:
		           (self importJson: self minimalOpenApi3Json).
	self assert: openApi sourceVersion equals: '3.0.4'.
	self assert: (openApi openapiVersion beginsWith: '3.1')
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportNamesAreInstantiated [
	"The old test read the response name from its description ('ok') and the entry name from the status code ('200'): both are now plain attributes of the Response."

	| model operation path response |
	model := self importJson: self minimalSwaggerJson.
	path := (self entitiesNamed: #Path in: model) anyOne.
	operation := (self entitiesNamed: #Operation in: model) anyOne.
	response := (self entitiesNamed: #Response in: model) anyOne.
	self assert: (self openApiIn: model) name equals: 'Sample API'.
	self assert: path name equals: '/pets'.
	self assert: operation name equals: 'listPets'.
	self assert: response statusCode equals: '200'.
	self assert: response description equals: 'ok'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOfNonObjectDocumentReportsAnErrorAndDoesNotRaise [

	self shouldnt: [ self importJson: '[1,2]' ] raise: Error.
	self assert: importer diagnostics hasErrors
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOfUnsupportedVersionReportsAnErrorAndDoesNotRaise [

	| model |
	self
		shouldnt: [
			model := self importJson: (self jsonFrom:
					          '{`openapi`:`4.0.0`,`info`:{`title`:`t`,`version`:`1`},`paths`:{}}') ]
		raise: Error.
	self assert:
		(importer diagnostics withCode: #unsupportedVersion) notEmpty.
	self assert: importer diagnostics hasErrors.
	self assert: importer openApi isNil
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportOfficialGithubOpenApiJson [
	"Downloads the GitHub description: it needs network access."

	| model openApi operation path |
	model := self importJson: self githubOfficialOpenApiJson.
	self assert: (self entitiesNamed: #OpenApi in: model) size equals: 1.
	self assert: (self entitiesNamed: #Path in: model) size > 0.
	self assert: (self entitiesNamed: #Operation in: model) size > 0.
	openApi := self openApiIn: model.
	path := (self entitiesNamed: #Path in: model) anyOne.
	operation := (self entitiesNamed: #Operation in: model) anyOne.
	self assertEntityHasNonEmptyName: openApi.
	self assertEntityHasNonEmptyName: path.
	self assertEntityHasNonEmptyName: operation
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportOpenApi3ComponentsAndRequestBody [

	| components mediaType model openApi operation petSchema requestBody response |
	model := self importJson: self minimalOpenApi3Json.
	openApi := self openApiIn: model.
	components := self componentsIn: model.
	operation := self operationWithId: 'createPet' in: model.
	response := operation responses anyOne.
	self assert: openApi sourceVersion equals: '3.0.4'.
	self
		assert: (self entitiesNamed: #Components in: model) size
		equals: 1.
	self assert: components requestBodies size equals: 1.
	requestBody := components requestBodies anyOne.
	self
		assert: requestBody canonicalPointer
		equals: '#/components/requestBodies/PetPayload'.
	self assert: requestBody description equals: 'payload'.
	self assert: requestBody required equals: true.
	self assert: operation requestBody notNil.
	self assert: operation requestBody == requestBody.
	"The old test expected the ref on the operation request body; the shared entity is now the component itself and has no ref."
	self assert: operation requestBody ref isNil.
	self assert: response content size > 0.
	petSchema := self componentSchemaNamed: 'Pet' in: model.
	mediaType := self mediaTypeNamed: 'application/json' of: response.
	self assert: mediaType schema == petSchema.
	self assert:
		(self mediaTypeNamed: 'application/json' of: requestBody) schema
		== petSchema.
	self assert: (self entitiesNamed: #RequestBody in: model) size >= 1.
	self assert: (self entitiesNamed: #MediaType in: model) size > 0
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportOpenApi3PathAndOperationParameters [

	| componentParameter model operation path |
	model := self importJson: self minimalOpenApi3Json.
	path := (self entitiesNamed: #Path in: model) anyOne.
	operation := self operationWithId: 'createPet' in: model.
	componentParameter := self
		                      componentIn:
		                      (self componentsIn: model) parameters
		                      pointer: '#/components/parameters/TraceId'.
	self assert: path parameters size equals: 1.
	self assert: path parameters anyOne == componentParameter.
	"The shared component parameter is the entity itself: it keeps its own pointer and no ref (see D10)."
	self
		assert: path parameters anyOne canonicalPointer
		equals: '#/components/parameters/TraceId'.
	self assert: operation parameters size equals: 1.
	self assert: operation parameters anyOne name equals: 'limit'.
	self assert: operation parameters anyOne location equals: 'query'
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportOpenApi3PathParametersAreCopiedToOperationWhenOperationHasNone [

	| model operation path traceIdParameter |
	model := self importJson:
		         self minimalOpenApi3JsonWithPathParametersOnly.
	path := (self entitiesNamed: #Path in: model) anyOne.
	operation := path get.
	traceIdParameter := self
		                    componentIn:
		                    (self componentsIn: model) parameters
		                    pointer: '#/components/parameters/TraceId'.
	self assert: path parameters size equals: 1.
	self assert: path parameters anyOne == traceIdParameter.
	self assert: operation parameters size equals: 0.
	self assert: operation allParameters size equals: 1.
	self assert: operation allParameters anyOne == traceIdParameter.
	self assert: operation effectiveParameters anyOne == traceIdParameter
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3SchemaItemsAndRefResolution [

	| model petListSchema petSchema tagListItemsSchema tagListSchema |
	model := self importJson: self minimalOpenApi3Json.
	petSchema := self componentSchemaNamed: 'Pet' in: model.
	petListSchema := self componentSchemaNamed: 'PetList' in: model.
	tagListSchema := self componentSchemaNamed: 'TagList' in: model.
	tagListItemsSchema := tagListSchema items.
	self assert: petListSchema items notNil.
	"The old test had this assertion commented out; $ref resolution now makes it hold."
	self assert: petListSchema items == petSchema.
	self assert: tagListItemsSchema notNil.
	self assert: tagListItemsSchema ~~ petSchema.
	self assert: tagListItemsSchema types asArray equals: #( 'string' )
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3SchemaProperties [

	| idProperty model nameProperty petSchema |
	model := self importJson: self minimalOpenApi3Json.
	petSchema := self componentSchemaNamed: 'Pet' in: model.
	idProperty := self propertyNamed: 'id' ofSchema: petSchema.
	nameProperty := self propertyNamed: 'name' ofSchema: petSchema.
	self assert: petSchema properties size equals: 2.
	self assert: idProperty isRequired equals: true.
	self assert: nameProperty isRequired equals: false.
	self assert: petSchema requiredProperties asArray equals: #( 'id' ).
	self
		assert:
		(self parsedJson: nameProperty valueSchema enumValues) asArray
		equals: #( 'cat' 'dog' )
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportRootDocumentHasCanonicalPointer [

	self
		assert: (self openApiIn: (self importJson: self richRootJson))
				canonicalPointer
		equals: '#'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportRootDocumentKeepsInfoContactAndLicense [

	| info openApi |
	openApi := self openApiIn: (self importJson: self richRootJson).
	info := openApi info.
	self assert: openApi name equals: 'Rich API'.
	self assert: info title equals: 'Rich API'.
	self assert: info version equals: '2.3.4'.
	self assert: info description equals: 'long description'.
	self assert: info termsOfService equals: 'https://example.com/terms'.
	self assert: info contact name equals: 'Support'.
	self assert: info contact url equals: 'https://example.com/support'.
	self assert: info contact email equals: 'support@example.com'.
	self assert: info license name equals: 'MIT'.
	self
		assert: info license url
		equals: 'https://opensource.org/licenses/MIT'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportRootDocumentKeepsServersTagsExternalDocsAndDialect [

	| openApi |
	openApi := self openApiIn: (self importJson: self richRootJson).
	self
		assert: openApi jsonSchemaDialect
		equals: 'https://json-schema.org/draft/2020-12/schema'.
	self
		assert: (openApi servers collect: #url) asArray
		equals:
		#( 'https://api.example.com/v1' 'https://staging.example.com' ).
	self assert: openApi servers first description equals: 'production'.
	self
		assert: (openApi tags collect: #name) asArray
		equals: #( 'pets' 'stores' ).
	self
		assert:
		(openApi tags detect: [ :each | each name = 'pets' ]) description
		equals: 'Pet operations'.
	self
		assert:
		(openApi tags detect: [ :each | each name = 'pets' ]) externalDocs
			url
		equals: 'https://docs.example.com/pets'.
	self
		assert: openApi externalDocs url
		equals: 'https://docs.example.com'.
	self assert: openApi externalDocs description equals: 'full docs'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportStoresSourceTextOnCreatedEntities [
	"With the sourceTextPolicy #all every entity keeps the text of its JSON node (a Property is the node of its value schema: the text is on the value schema)."

	| model pet |
	model := self
		         importJson: self minimalOpenApi3Json
		         using: (FamixOpenApiImporter new
				          sourceTextPolicy: #all;
				          yourself).
	pet := self componentSchemaNamed: 'Pet' in: model.
	self assertEntityHasNonEmptySourceText: (self openApiIn: model).
	self assertEntityHasNonEmptySourceText: (self componentsIn: model).
	self assertEntityHasNonEmptySourceText: pet.
	self assertEntityHasNonEmptySourceText:
		pet properties anyOne valueSchema.
	self assert: (self parsedJson: pet sourceText) isDictionary
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testImportStoresSourceTextOnPathAndOperationWithPolicyAll [

	| model |
	model := self
		         importJson: self minimalOpenApi3Json
		         using: (FamixOpenApiImporter new
				          sourceTextPolicy: #all;
				          yourself).
	self assertEntityHasNonEmptySourceText:
		(self entitiesNamed: #Path in: model) anyOne.
	self assertEntityHasNonEmptySourceText:
		(self entitiesNamed: #Operation in: model) anyOne
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImporterExposesModelOpenApiAndSpecVersion [

	| model |
	model := self importJson: self minimalOpenApi3Json.
	self assert: importer model == model.
	self assert: importer openApi == (self openApiIn: model).
	self assert: importer specVersion isOpenApi30.
	self assert: importer diagnostics hasErrors not
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testModelFromJsonFileAliasAnswersTheSameModelAsImportFromFile [

	| fileReference model |
	fileReference := FileSystem memory / 'alias-openapi.json'.
	fileReference writeStreamDo: [ :stream |
		stream nextPutAll: self minimalSwaggerJson ].
	model := FamixOpenApiImporter new modelFromJsonFile: fileReference.
	self assert: (self entitiesNamed: #OpenApi in: model) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testModelFromJsonStringAliasAnswersTheSameModelAsImportFromString [
	"The old selectors stay available as aliases of the facade."

	| model |
	model := FamixOpenApiImporter new modelFromJsonString:
		         self minimalSwaggerJson.
	self assert: (model isKindOf: (self generatedClassNamed: #Model)).
	self assert: (self entitiesNamed: #OpenApi in: model) size equals: 1
]

{ #category : 'tests (step B)' }
FamixOpenApiImporterTest >> testSourceTextPolicyComponentsKeepsSourceTextOnComponentsPathItemsAndOperations [

	| model schemas component inline |
	model := self importJson: self minimalOpenApi3Json.
	schemas := self entitiesNamed: #Schema in: model.
	component := schemas detect: [ :each | each name = 'Pet' ].
	self deny: component sourceText isEmptyOrNil.
	self assert:
		(NeoJSONReader fromString: component sourceText) isDictionary.
	self
		assert:
		((NeoJSONReader fromString: component sourceText) at: 'description')
		equals: 'A pet schema'.
	(self entitiesNamed: #Path in: model) anyOne sourceText ifNotNil: [
		:text | self assert: (NeoJSONReader fromString: text) isDictionary ].
	self deny:
		(self entitiesNamed: #Path in: model) anyOne sourceText isEmptyOrNil.
	self deny:
		(self entitiesNamed: #Operation in: model) anyOne sourceText
			isEmptyOrNil.
	self
		assert: ((NeoJSONReader fromString:
				  (self entitiesNamed: #Operation in: model) anyOne sourceText)
				 at: 'operationId')
		equals: 'createPet'.
	inline := schemas select: [ :each | each name isNil ].
	self deny: inline isEmpty.
	inline do: [ :each | self assert: each sourceText isNil ]
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testSourceTextPolicyComponentsKeepsTheSourceTextOfComponentsOnly [
	"The default policy keeps the text of the reusable component entities."

	| model |
	model := self importJson: self minimalOpenApi3Json.
	self assertEntityHasNonEmptySourceText:
		(self componentSchemaNamed: 'Pet' in: model).
	self assert: (self parsedJson:
			 (self componentSchemaNamed: 'Pet' in: model) sourceText)
			isDictionary
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testSourceTextPolicyNoneKeepsNoSourceText [

	| model |
	model := self
		         importJson: self minimalOpenApi3Json
		         using: (FamixOpenApiImporter new
				          sourceTextPolicy: #none;
				          yourself).
	self assert:
		(self componentSchemaNamed: 'Pet' in: model) sourceText isEmptyOrNil.
	self assert: (self openApiIn: model) sourceText isEmptyOrNil
]
