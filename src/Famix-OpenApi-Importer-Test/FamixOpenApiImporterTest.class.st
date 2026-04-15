Class {
	#name : 'FamixOpenApiImporterTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'private' }
FamixOpenApiImporterTest >> assertEntityHasNonEmptyName: anEntity [
	self assert: (anEntity respondsTo: #name).
	self assert: anEntity name notNil.
	self assert: anEntity name asString isEmpty not
]

{ #category : 'private' }
FamixOpenApiImporterTest >> assertEntityHasNonEmptySourceText: anEntity [
	self assert: (anEntity respondsTo: #sourceText).
	self assert: anEntity sourceText notNil.
	self assert: anEntity sourceText asString isEmpty not
]

{ #category : 'private' }
FamixOpenApiImporterTest >> generatedClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
				at: generatedClassName
				ifAbsent: [ self fail: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'private' }
FamixOpenApiImporterTest >> githubOfficialOpenApiJson [
	| response |
	[ response := ZnEasy get: self githubOfficialOpenApiJsonUrl ]
		on: Error
		do: [ :error |
			self fail: 'Failed to download GitHub official OpenAPI JSON: ', error messageText ].
	^ response contents
]

{ #category : 'private' }
FamixOpenApiImporterTest >> githubOfficialOpenApiJsonUrl [
	^ 'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json'
]

{ #category : 'private' }
FamixOpenApiImporterTest >> minimalOpenApi3Json [
	^ '{"openapi":"3.0.4","info":{"title":"Sample OpenAPI 3 API","version":"1.0.0"},"paths":{"/pets":{"parameters":[{"$ref":"#/components/parameters/TraceId"}],"post":{"operationId":"createPet","parameters":[{"name":"limit","in":"query","required":false,"schema":{"type":"integer"}}],"requestBody":{"$ref":"#/components/requestBodies/PetPayload"},"responses":{"201":{"description":"created","content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}}}}}}}},"components":{"schemas":{"Pet":{"type":"object","description":"A pet schema","required":["id"],"properties":{"id":{"type":"string"},"name":{"type":"string","enum":["cat","dog"]}}},"PetList":{"type":"array","items":{"$ref":"#/components/schemas/Pet"}},"TagList":{"type":"array","items":{"type":"string"}}},"requestBodies":{"PetPayload":{"description":"payload","required":true,"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}}}}},"responses":{"GenericError":{"description":"generic error"}},"parameters":{"TraceId":{"name":"traceId","in":"header","required":false,"schema":{"type":"string"}}},"securitySchemes":{"ApiKeyAuth":{"type":"apiKey","name":"X-API-Key","in":"header"}}}}'
]

{ #category : 'private' }
FamixOpenApiImporterTest >> minimalOpenApi3JsonWithPathParametersOnly [
	^ '{"openapi":"3.0.4","info":{"title":"Sample OpenAPI 3 API","version":"1.0.0"},"paths":{"/pets":{"parameters":[{"$ref":"#/components/parameters/TraceId"}],"get":{"operationId":"listPets","responses":{"200":{"description":"ok"}}}}},"components":{"parameters":{"TraceId":{"name":"traceId","in":"header","required":false,"schema":{"type":"string"}}}}}'
]

{ #category : 'private' }
FamixOpenApiImporterTest >> minimalOpenApi3JsonWithResponseInlineComplexProperty [
	^ '{"openapi":"3.0.4","info":{"title":"Inline Response API","version":"1.0.0"},"paths":{"/movies":{"get":{"operationId":"searchMovie","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"type":"object","properties":{"results":{"type":"array","items":{"type":"object","properties":{"id":{"type":"integer"},"title":{"type":"string"}}}}}}}}}}}}}}'
]

{ #category : 'private' }
FamixOpenApiImporterTest >> minimalSwaggerJson [
	^ '{"swagger":"2.0","info":{"title":"Sample API","version":"1.0.0"},"paths":{"/pets":{"summary":"Pets path","description":"Operations about pets","get":{"operationId":"listPets","responses":{"200":{"description":"ok"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiImporterTest >> minimalSwaggerJsonWithReferences [
	^ '{"swagger":"2.0","info":{"title":"Sample API","version":"1.0.0"},"paths":{"/pets":{"$ref":"#/paths/~1pets","get":{"operationId":"listPets","responses":{"default":{"$ref":"#/responses/GenericError"}}}}}}'
]

{ #category : 'running' }
FamixOpenApiImporterTest >> setUp [
	super setUp.

]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testGeneratedClassLookupUsesCurrentPrefix [
	| generatedApiClass expectedApiClassName |
	expectedApiClassName := (FamixOpenApiGenerator prefix asString , 'Api') asSymbol.
	generatedApiClass := self generatedClassNamed: #Api.
	self assert: generatedApiClass name equals: expectedApiClassName
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCopiesRefOnReferenceableEntities [
	| model path pathClass response responseClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJsonWithReferences.
	pathClass := self generatedClassNamed: #Path.
	responseClass := self generatedClassNamed: #Response.
	path := (model allWithType: pathClass) anyOne.
	response := (model allWithType: responseClass) anyOne.
	self assert: path ref equals: '#/paths/~1pets'.
	self assert: response ref equals: '#/responses/GenericError'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCopiesSummaryAndDescriptionOnPath [
	| model path pathClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJson.
	pathClass := self generatedClassNamed: #Path.
	path := (model allWithType: pathClass) anyOne.
	self assert: path summary equals: 'Pets path'.
	self assert: path description equals: 'Operations about pets'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCreatesOneApiEntity [
	| model apiClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJson.
	apiClass := self generatedClassNamed: #Api.
	self assert: (model allWithType: apiClass) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCreatesPathAndOperationEntities [
	| model pathClass operationClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJson.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	self assert: (model allWithType: pathClass) size equals: 1.
	self assert: (model allWithType: operationClass) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCreatesResponseAndResponseEntryEntities [
	| model responseClass responseEntryClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJson.
	responseClass := self generatedClassNamed: #Response.
	responseEntryClass := self generatedClassNamed: #ResponseEntry.
	self assert: (model allWithType: responseClass) size equals: 1.
	self assert: (model allWithType: responseEntryClass) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportFromJsonFileReturnsModel [
	| fileReference model |
	fileReference := FileSystem memory / 'minimal-openapi.json'.
	fileReference
		writeStreamDo: [ :stream | stream nextPutAll: self minimalSwaggerJson ].

	model := FamixOpenApiImporter new modelFromJsonFile: fileReference.
	self assert: model notNil
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportFromJsonStringReturnsModel [
	| model |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJson.
	self assert: model notNil
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportNamesAreInstantiated [
	| api apiClass model operation operationClass path pathClass response responseClass responseEntry responseEntryClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalSwaggerJson.

	apiClass := self generatedClassNamed: #Api.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	responseClass := self generatedClassNamed: #Response.
	responseEntryClass := self generatedClassNamed: #ResponseEntry.

	api := (model allWithType: apiClass) anyOne.
	path := (model allWithType: pathClass) anyOne.
	operation := (model allWithType: operationClass) anyOne.
	response := (model allWithType: responseClass) anyOne.
	responseEntry := (model allWithType: responseEntryClass) anyOne.

	self assert: api name equals: 'Sample API'.
	self assert: path name equals: '/pets'.
	self assert: operation name equals: 'listPets'.
	self assert: responseEntry name equals: '200'.
	self assert: response name equals: 'ok'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOfficialGithubOpenApiJson [
	| api apiClass model operation operationClass path pathClass |
	model := FamixOpenApiImporter new modelFromJsonString: self githubOfficialOpenApiJson.
	apiClass := self generatedClassNamed: #Api.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	self assert: (model allWithType: apiClass) size equals: 1.
	self assert: (model allWithType: pathClass) size > 0.
	self assert: (model allWithType: operationClass) size > 0.

	api := (model allWithType: apiClass) anyOne.
	path := (model allWithType: pathClass) anyOne.
	operation := (model allWithType: operationClass) anyOne.

	self assertEntityHasNonEmptyName: api.
	self assertEntityHasNonEmptyName: path.
	self assertEntityHasNonEmptyName: operation
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3ComponentsAndRequestBody [
	| api apiClass components componentsClass mediaTypeEntry mediaTypeEntryClass model operation operationClass petSchemaEntry requestBodyClass requestBodyEntry response |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalOpenApi3Json.

	apiClass := self generatedClassNamed: #Api.
	componentsClass := self generatedClassNamed: #Components.
	operationClass := self generatedClassNamed: #Operation.
	requestBodyClass := self generatedClassNamed: #RequestBody.
	mediaTypeEntryClass := self generatedClassNamed: #MediaTypeEntry.

	api := (model allWithType: apiClass) anyOne.
	components := (model allWithType: componentsClass) anyOne.
	operation := (model allWithType: operationClass) anyOne.
	response := operation responses anyOne value.

	self assert: api openapi equals: '3.0.4'.
	self assert: (model allWithType: componentsClass) size equals: 1.
	self assert: components requestBodies size equals: 1.
	requestBodyEntry := components requestBodies anyOne.
	self assert: requestBodyEntry key equals: 'PetPayload'.
	self assert: requestBodyEntry value description equals: 'payload'.
	self assert: requestBodyEntry value required equals: true.
	self assert: operation requestBody notNil.
	self assert: operation requestBody == requestBodyEntry value.
	self assert: operation requestBody ref equals: '#/components/requestBodies/PetPayload'.
	self assert: response content size > 0.
	petSchemaEntry := components schemas detect: [ :each | each key = 'Pet' ].
	mediaTypeEntry := response content detect: [ :each | each key = 'application/json' ].
	self assert: mediaTypeEntry value schema == petSchemaEntry value.
	self assert: (model allWithType: requestBodyClass) size >= 1.
	self assert: (model allWithType: mediaTypeEntryClass) size > 0
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3PathAndOperationParameters [
	| componentParameter components componentsClass model operation operationClass path pathClass |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalOpenApi3Json.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	componentsClass := self generatedClassNamed: #Components.
	path := (model allWithType: pathClass) anyOne.
	operation := (model allWithType: operationClass) anyOne.
	components := (model allWithType: componentsClass) anyOne.
	componentParameter := (components parameters detect: [ :each | each key = 'TraceId' ]) value.

	self assert: path parameters size equals: 1.
	self assert: (path parameters anyOne) == componentParameter.
	self assert: (path parameters anyOne) ref equals: '#/components/parameters/TraceId'.
	self assert: operation parameters size equals: 1.
	self assert: (operation parameters anyOne) name equals: 'limit'.
	self assert: (operation parameters anyOne) location equals: 'query'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3PathParametersAreCopiedToOperationWhenOperationHasNone [ 
	| components componentsClass model operation operationClass path pathClass traceIdParameter |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalOpenApi3JsonWithPathParametersOnly.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	componentsClass := self generatedClassNamed: #Components.
	path := (model allWithType: pathClass) anyOne.
	operation := path get.
	components := (model allWithType: componentsClass) anyOne.
	traceIdParameter := (components parameters detect: [ :each | each key = 'TraceId' ]) value.

	self assert: path parameters size equals: 1.
	self assert: (path parameters anyOne) == traceIdParameter.
	self assert: operation parameters size equals: 0.
	self assert: operation allParameters size equals: 1.
	self assert: (operation allParameters anyOne) == traceIdParameter
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3SchemaItemsAndRefResolution [
	| components componentsClass model petListSchema petSchema tagListItemsSchema tagListSchema |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalOpenApi3Json.
	componentsClass := self generatedClassNamed: #Components.
	components := (model allWithType: componentsClass) anyOne.
	petSchema := (components schemas detect: [ :each | each key = 'Pet' ]) value.
	petListSchema := (components schemas detect: [ :each | each key = 'PetList' ]) value.
	tagListSchema := (components schemas detect: [ :each | each key = 'TagList' ]) value.
	tagListItemsSchema := tagListSchema items.

	self assert: petListSchema items notNil.
"	self assert: petListSchema items = petSchema."
	self assert: tagListItemsSchema notNil.
	self assert: tagListItemsSchema ~~ petSchema.
	self assert: tagListItemsSchema type equals: 'string'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportOpenApi3SchemaProperties [
	| components componentsClass idProperty model nameProperty petSchema schemaEntry |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalOpenApi3Json.
	componentsClass := self generatedClassNamed: #Components.
	components := (model allWithType: componentsClass) anyOne.
	schemaEntry := components schemas detect: [ :each | each key = 'Pet' ].
	petSchema := schemaEntry value.
	idProperty := petSchema properties detect: [ :each | each name = 'id' ].
	nameProperty := petSchema properties detect: [ :each | each name = 'name' ].

	self assert: petSchema properties size equals: 2.
	self assert: idProperty required equals: true.
	self assert: nameProperty required equals: false.
	self assert: nameProperty enum asArray equals: #('cat' 'dog').
	self assert: idProperty valueSchema type equals: 'string'.
	self assert: nameProperty valueSchema type equals: 'string'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportResponseInlineComplexPropertyCreatesValueSchemaTree [
	| idProperty itemsSchema model operation operationClass response resultsProperty rootSchema titleProperty |
	model := FamixOpenApiImporter new
		modelFromJsonString: self minimalOpenApi3JsonWithResponseInlineComplexProperty.
	operationClass := self generatedClassNamed: #Operation.
	operation := (model allWithType: operationClass) anyOne.
	response := (operation responses detect: [ :each | each key = '200' ]) value.
	rootSchema := ((response content detect: [ :each | each key = 'application/json' ]) value) schema.
	resultsProperty := rootSchema properties detect: [ :each | each name = 'results' ].
	itemsSchema := resultsProperty valueSchema items.
	idProperty := itemsSchema properties detect: [ :each | each name = 'id' ].
	titleProperty := itemsSchema properties detect: [ :each | each name = 'title' ].

	self assert: resultsProperty valueSchema notNil.
	self assert: resultsProperty valueSchema type equals: 'array'.
	self assert: itemsSchema notNil.
	self assert: idProperty valueSchema notNil.
	self assert: idProperty valueSchema type equals: 'integer'.
	self assert: titleProperty valueSchema type equals: 'string'
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportStoresSourceTextOnCreatedEntities [
	| api apiClass components componentsClass model operation operationClass path pathClass schemaEntry |
	model := FamixOpenApiImporter new modelFromJsonString: self minimalOpenApi3Json.
	apiClass := self generatedClassNamed: #Api.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	componentsClass := self generatedClassNamed: #Components.

	api := (model allWithType: apiClass) anyOne.
	path := (model allWithType: pathClass) anyOne.
	operation := (model allWithType: operationClass) anyOne.
	components := (model allWithType: componentsClass) anyOne.
	schemaEntry := components schemas detect: [ :each | each key = 'Pet' ].

	self assertEntityHasNonEmptySourceText: api.
	self assertEntityHasNonEmptySourceText: path.
	self assertEntityHasNonEmptySourceText: operation.
	self assertEntityHasNonEmptySourceText: components.
	self assertEntityHasNonEmptySourceText: schemaEntry.
	self assertEntityHasNonEmptySourceText: schemaEntry value
]
