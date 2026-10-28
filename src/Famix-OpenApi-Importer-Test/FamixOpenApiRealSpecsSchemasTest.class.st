"
Imports the real specifications of the openapi-spec directory (Azure DevOps, Jira, GitHub, Bitbucket, GitLab) and checks that the component schemas and their properties are all imported. The raw counts are computed from the JSON text with NeoJSON, independently of the importer. A test is skipped when its file is absent; the test named Slow imports an 11 MB file.
"
Class {
	#name : 'FamixOpenApiRealSpecsSchemasTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> assertSpecNamed: aFileName hasSchemaCount: aSchemaCount [

	| file raw model |
	file := self specFileNamed: aFileName.
	raw := self rawSchemasOf: file.
	self
		assert: raw size
		equals: aSchemaCount
		description: 'raw schema count of ' , aFileName.
	model := self importJson: file contents.
	self assert: (self componentsIn: model) schemas size equals: raw size
]

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> assertSpecNamed: aFileName hasSchemaCount: aSchemaCount propertyCount: aPropertyCount [

	| file raw model |
	file := self specFileNamed: aFileName.
	raw := self rawSchemasOf: file.
	self
		assert: raw size
		equals: aSchemaCount
		description: 'raw schema count of ' , aFileName.
	self
		assert: (self rawPropertyCountOf: raw)
		equals: aPropertyCount
		description: 'raw property count of ' , aFileName.
	model := self importJson: file contents.
	self assert: (self componentsIn: model) schemas size equals: raw size.
	self
		assert: (self importedPropertyCountOf: model)
		equals: aPropertyCount
]

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> importedPropertyCountOf: aModel [

	^ (self componentsIn: aModel) schemas
		  inject: 0
		  into: [ :count :each | count + each properties size ]
]

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> rawPropertyCountOf: aSchemasDictionary [
	"Answer the number of entries of the properties maps of the component schemas."

	^ aSchemasDictionary values inject: 0 into: [ :count :each |
		  count + (each isDictionary
			   ifTrue: [
			   (each at: 'properties' ifAbsent: [ Dictionary new ]) size ]
			   ifFalse: [ 0 ]) ]
]

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> rawSchemasOf: aFile [
	"Answer the Dictionary of the component schemas (OpenAPI 3) or definitions (Swagger 2) read from the JSON text with NeoJSON, independently of the importer."

	| document |
	document := aFile readStreamDo: [ :stream |
		            NeoJSONReader fromString: stream upToEnd ].
	^ (document includesKey: 'swagger')
		  ifTrue: [ document at: 'definitions' ifAbsent: [ Dictionary new ] ]
		  ifFalse: [
			  (document at: 'components' ifAbsent: [ Dictionary new ])
				  at: 'schemas'
				  ifAbsent: [ Dictionary new ] ]
]

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> specDirectory [

	^ '/Users/nicolas.hlad/Documents/Pharo/images/openapi-vibe/pharo-local/iceberg/Evref-BL/pharo-openapi-generator/openapi-spec/'
		  asFileReference
]

{ #category : 'helpers' }
FamixOpenApiRealSpecsSchemasTest >> specFileNamed: aFileName [
	"Answer the spec file, or skip the running test when it is absent."

	| file |
	file := self specDirectory / aFileName.
	file exists ifFalse: [
		self skip: 'Missing spec file ' , file fullName ].
	^ file
]

{ #category : 'tests' }
FamixOpenApiRealSpecsSchemasTest >> testAzureDevOpsSchemasAndProperties [

	self
		assertSpecNamed: 'azur-devop_openapi.json'
		hasSchemaCount: 58
		propertyCount: 137
]

{ #category : 'tests' }
FamixOpenApiRealSpecsSchemasTest >> testBitbucketDefinitionsAreImportedAsSchemas [
	"A Swagger 2 specification: its 153 definitions become component schemas."

	self assertSpecNamed: 'bitbucket_openapi.json' hasSchemaCount: 153
]

{ #category : 'tests' }
FamixOpenApiRealSpecsSchemasTest >> testGithubSchemasAndPropertiesSlow [
	"Imports an 11 MB specification: slow."

	self
		assertSpecNamed: 'github_openapi.json'
		hasSchemaCount: 837
		propertyCount: 7065
]

{ #category : 'tests' }
FamixOpenApiRealSpecsSchemasTest >> testGitlabDefinitionsAreImportedAsSchemas [
	"A Swagger 2 specification: its 650 definitions become component schemas."

	self assertSpecNamed: 'gitlab-v2_openapi.json' hasSchemaCount: 650
]

{ #category : 'tests' }
FamixOpenApiRealSpecsSchemasTest >> testJiraSchemasAndProperties [

	self
		assertSpecNamed: 'jira_openapi.json'
		hasSchemaCount: 305
		propertyCount: 1268
]
