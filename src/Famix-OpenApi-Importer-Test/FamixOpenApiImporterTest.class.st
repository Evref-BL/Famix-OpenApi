Class {
	#name : 'FamixOpenApiImporterTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'private' }
FamixOpenApiImporterTest >> generatedClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
				at: generatedClassName
				ifAbsent: [ self fail: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'private' }
FamixOpenApiImporterTest >> assertEntityHasNonEmptyName: anEntity [
	self assert: (anEntity respondsTo: #name).
	self assert: anEntity name notNil.
	self assert: anEntity name asString isEmpty not
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
