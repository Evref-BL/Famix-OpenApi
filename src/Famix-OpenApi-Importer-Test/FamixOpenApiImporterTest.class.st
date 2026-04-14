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
FamixOpenApiImporterTest >> minimalSwaggerJson [
	^ '{"swagger":"2.0","info":{"title":"Sample API","version":"1.0.0"},"paths":{"/pets":{"get":{"operationId":"listPets","responses":{"200":{"description":"ok"}}}}}}'
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
