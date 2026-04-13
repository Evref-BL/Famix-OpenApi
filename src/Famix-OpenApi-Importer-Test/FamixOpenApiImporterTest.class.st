Class {
	#name : #FamixOpenApiImporterTest,
	#superclass : #TestCase,
	#category : 'Famix-OpenApi-Importer-Test'
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
	FamixOpenApiGenerator generate
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testGeneratedClassLookupUsesCurrentPrefix [
	| generatedApiClass expectedApiClassName |
	expectedApiClassName := (FamixOpenApiGenerator prefix asString , 'API') asSymbol.
	generatedApiClass := self generatedClassNamed: #API.
	self assert: generatedApiClass name equals: expectedApiClassName
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCreatesOneApiEntity [
	| model apiClass |
	model := FamixOpenApiImporter new importFromJsonString: self minimalSwaggerJson.
	apiClass := self generatedClassNamed: #API.
	self assert: (model allWithType: apiClass) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportCreatesPathAndOperationEntities [
	| model pathClass operationClass |
	model := FamixOpenApiImporter new importFromJsonString: self minimalSwaggerJson.
	pathClass := self generatedClassNamed: #Path.
	operationClass := self generatedClassNamed: #Operation.
	self assert: (model allWithType: pathClass) size equals: 1.
	self assert: (model allWithType: operationClass) size equals: 1
]

{ #category : 'tests' }
FamixOpenApiImporterTest >> testImportFromJsonStringReturnsModel [
	| model |
	model := FamixOpenApiImporter new importFromJsonString: self minimalSwaggerJson.
	self assert: model notNil
]
