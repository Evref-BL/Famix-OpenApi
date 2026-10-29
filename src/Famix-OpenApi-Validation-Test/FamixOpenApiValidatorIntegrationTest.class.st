"
Integration tests: the validator answers neither errors nor warnings on models really built by the importer, from inline OpenAPI 3.0, 3.1 and Swagger 2 petstore-like documents and from the external corpus (skipped cleanly when absent), with the inline schemas merged or not. Known importer findings, if any, are frozen in #knownCorpusFindings.
"
Class {
	#name : 'FamixOpenApiValidatorIntegrationTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> assertDocument: aJsonString [
	"The validator answers no error and no warning on the model of aJsonString, imported with and without merging of the inline schemas."

	#( true false ) do: [ :merging |
		| findings |
		findings := FamixOpenApiModelValidator new validate:
			            (self import: aJsonString merging: merging).
		self
			assertNoErrorsNorWarningsIn: findings
			described: ('merging={1}' format: { merging }) ]
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> assertNoErrorsNorWarningsIn: aFindings described: aString [

	self
		assert:
		(aFindings errors isEmpty and: [ aFindings warnings isEmpty ])
		description: (String streamContents: [ :stream |
				 stream
					 nextPutAll: aString;
					 nextPutAll: ': ';
					 nextPutAll: aFindings summary.
				 aFindings do: [ :each |
					 stream
						 cr;
						 print: each ] ])
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> corpusDirectory [
	"The folder holding the external spec files (outside the repository)."

	^ '/Users/nicolas.hlad/Documents/Pharo/images/openapi-vibe/test-corpus/'
		  asFileReference
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> corpusFiles [
	"Answer the *.json files of the corpus, sorted by name; skip the running test when the corpus folder is absent."

	| directory |
	directory := self corpusDirectory.
	directory exists ifFalse: [
		self skip: 'Missing corpus folder ' , directory fullName ].
	^ (directory files select: [ :each | each extension = 'json' ])
		  sorted: [ :a :b | a basename <= b basename ]
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> corpusFindingLines [
	"Answer the sorted description (file, merging, severity, code, entity class, pointer) of every finding of the validator on the corpus."

	^ (self corpusFiles flatCollect: [ :file |
		   #( true false ) flatCollect: [ :merging |
			   self findingLinesOf: file merging: merging ] ]) asArray sorted
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> findingLinesOf: aFile merging: aBoolean [

	| findings |
	findings := FamixOpenApiModelValidator new validate:
		            (self import: aFile contents merging: aBoolean).
	^ findings collect: [ :each |
		  String streamContents: [ :stream |
			  stream
				  nextPutAll: aFile basename;
				  nextPutAll: ' merging=';
				  print: aBoolean;
				  space;
				  nextPutAll: each printString;
				  nextPutAll: ' [';
				  nextPutAll:
					  (each entity
						   ifNil: [ '' ]
						   ifNotNil: [ :entity | entity class name ]);
				  nextPut: $] ] ]
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> import: aJsonString merging: aBoolean [
	"Answer the OPModel the importer builds from aJsonString."

	^ FamixOpenApiImporter new
		  mergesInlineSchemas: aBoolean;
		  importFromString: aJsonString
]

{ #category : 'support' }
FamixOpenApiValidatorIntegrationTest >> knownCorpusFindings [
	"The findings the validator is known to report on the corpus, frozen: none. A finding listed here is a real importer behaviour recorded, not fixed, by the validation step (file, merging, finding, entity class)."

	^ #(  )
]

{ #category : 'documents' }
FamixOpenApiValidatorIntegrationTest >> openApi30Document [

	^ '{"openapi":"3.0.3","info":{"title":"Petstore","version":"1.0","contact":{"name":"Team"},"license":{"name":"MIT"}},"servers":[{"url":"https://pets.example.com"}],"tags":[{"name":"pets"}],"paths":{"/pets":{"get":{"operationId":"listPets","tags":["pets"],"parameters":[{"$ref":"#/components/parameters/Limit"}],"responses":{"200":{"description":"ok","headers":{"X-Rate":{"schema":{"type":"integer"}}},"content":{"application/json":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/Pet"}}}}},"default":{"description":"error","content":{"application/json":{"schema":{"$ref":"#/components/schemas/Error"}}}}}},"post":{"operationId":"addPet","requestBody":{"content":{"application/json":{"schema":{"$ref":"#/components/schemas/NewPet"}}}},"responses":{"201":{"description":"created","content":{"application/json":{"schema":{"type":"object","properties":{"id":{"type":"integer"},"name":{"type":"string"}}}}}}}}},"/pets/{petId}":{"get":{"operationId":"showPet","parameters":[{"name":"petId","in":"path","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}}}}}}}},"components":{"parameters":{"Limit":{"name":"limit","in":"query","schema":{"type":"integer"}}},"securitySchemes":{"key":{"type":"apiKey","name":"X-Key","in":"header"}},"schemas":{"Pet":{"type":"object","required":["id"],"properties":{"id":{"type":"integer"},"name":{"type":"string"},"tag":{"type":"string"},"category":{"$ref":"#/components/schemas/Category"}}},"NewPet":{"allOf":[{"$ref":"#/components/schemas/Pet"},{"type":"object","properties":{"extra":{"type":"string"}}}]},"Category":{"type":"object","properties":{"name":{"type":"string"}}},"Error":{"type":"object","properties":{"code":{"type":"integer"},"message":{"type":"string"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiValidatorIntegrationTest >> openApi31Document [

	^ '{"openapi":"3.1.0","info":{"title":"Petstore","version":"1.0"},"paths":{"/pets":{"get":{"operationId":"listPets","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/Pet"}}}}}}}}},"webhooks":{"newPet":{"post":{"operationId":"onNewPet","requestBody":{"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}}}},"responses":{"200":{"description":"ok"}}}}},"components":{"schemas":{"Pet":{"type":["object","null"],"properties":{"id":{"type":"integer"},"name":{"type":"string"},"kind":{"const":"dog"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiValidatorIntegrationTest >> swagger2Document [

	^ '{"swagger":"2.0","info":{"title":"Petstore","version":"1.0"},"host":"pets.example.com","basePath":"/v1","schemes":["https"],"paths":{"/pets":{"get":{"operationId":"listPets","produces":["application/json"],"parameters":[{"name":"limit","in":"query","type":"integer"}],"responses":{"200":{"description":"ok","schema":{"type":"array","items":{"$ref":"#/definitions/Pet"}}},"default":{"description":"error","schema":{"$ref":"#/definitions/Error"}}}},"post":{"operationId":"addPet","consumes":["application/json"],"parameters":[{"name":"body","in":"body","required":true,"schema":{"$ref":"#/definitions/Pet"}}],"responses":{"201":{"description":"created","schema":{"type":"object","properties":{"id":{"type":"integer"},"name":{"type":"string"}}}}}}},"/pets/{petId}":{"parameters":[{"name":"petId","in":"path","required":true,"type":"string"}],"get":{"operationId":"showPet","responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Pet"}}}}}},"definitions":{"Pet":{"type":"object","required":["id"],"properties":{"id":{"type":"integer"},"name":{"type":"string"},"tag":{"type":"string"}}},"Error":{"type":"object","properties":{"code":{"type":"integer"},"message":{"type":"string"}}}}}'
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testCorpusIsCoherentWithAndWithoutMerging [
	"The validator reports exactly the known findings on the corpus files, merging the inline schemas or not; the failure lists every finding with its file."

	| lines |
	lines := self corpusFindingLines.
	self
		assert: lines = self knownCorpusFindings asArray
		description:
		'Validator findings on the corpus: ' , (String cr join: lines)
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testOpenApi30PetstoreIsCoherent [

	self assertDocument: self openApi30Document
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testOpenApi31PetstoreIsCoherent [

	self assertDocument: self openApi31Document
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testSamplesYieldSomeEntitiesAndOneRoot [

	#( #openApi30Document #openApi31Document #swagger2Document ) do: [
		:selector |
		| model |
		model := self import: (self perform: selector) merging: true.
		self assert: (model allWithType: OPOpenApi) size equals: 1.
		self assert: model allModelEntities size > 10 ]
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testSwagger2PetstoreIsCoherent [

	self assertDocument: self swagger2Document
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testValidationClassesDoNotReferenceTheImporter [

	| classes |
	classes := {
		           FamixOpenApiFinding.
		           FamixOpenApiFindings.
		           FamixOpenApiValidationRule.
		           FamixOpenApiModelValidator.
		           FamixOpenApiNamedEntitiesRule.
		           FamixOpenApiContainmentRule.
		           FamixOpenApiOneRootRule }.
	classes do: [ :each |
		{
			each.
			each class } do: [ :side |
			side methods do: [ :method |
				self deny:
					(method sourceCode includesSubstring: 'FamixOpenApiImporter').
				self deny:
					(method sourceCode includesSubstring: 'FamixOpenApiDiagnostic') ] ] ]
]

{ #category : 'tests' }
FamixOpenApiValidatorIntegrationTest >> testValidationOfAnImportedModelDoesNotModifyIt [

	| model before |
	model := self import: self openApi30Document merging: true.
	before := self snapshotOf: model.
	FamixOpenApiModelValidator new validate: model.
	self assert: (self snapshotOf: model) equals: before
]
