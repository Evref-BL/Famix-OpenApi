"
Documents and detects known fidelity defects (D1..D12) of FamixOpenApiImporter. Tests are expected to be red where they capture a real defect. Each test method comment starts with the defect id.
"
Class {
	#name : 'FamixOpenApiImporterFidelityTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> apiIn: aModel [

	^ (self entitiesNamed: #Api in: aModel) anyOne
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> apiKeySchemeIn: aModel [

	^ self
		  valueAtKey: 'ApiKeyAuth'
		  inEntries: (self componentsIn: aModel) securitySchemes
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> assert: anObject understands: aSelector [

	self
		assert: (anObject respondsTo: aSelector)
		description:
			anObject class name , ' does not understand #' , aSelector
			, ' (slot or accessor missing in the model)'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> assertExactlyOneSchemaNamed: aName in: aModel [

	self
		assert: (self schemasNamed: aName in: aModel) size = 1
		description: 'Exactly one schema entity should be named ' , aName
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> assertNoStubSchemasIn: aModel [

	self
		assert: (self stubSchemasIn: aModel) isEmpty
		description:
		'A schema entity holding only a $ref (no content) remains in the model'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> assertOperation: anOperationId hasHttpMethod: aMethod [

	| operation |
	operation := self
		             operationWithId: anOperationId
		             in: (self importOpenApi3: self verbsJson).
	self assert: operation understands: #httpMethod.
	self assert: operation httpMethod asLowercase equals: aMethod
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> assertOperationKnowsItsPath: anOperationId [

	| model operation |
	model := self importOpenApi3: self verbsJson.
	operation := self operationWithId: anOperationId in: model.
	self
		assert:
		operation path == (self entitiesNamed: #Path in: model) anyOne
		description: anOperationId , ' should know the /pets path'
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> backwardReferenceJson [

	^ self schemasJson:
		  '"B":{"type":"object"},"A":{"type":"array","items":{"$ref":"#/components/schemas/B"}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> componentSchemaNamed: aKey in: aModel [

	^ self
		  valueAtKey: aKey
		  inEntries: (self componentsIn: aModel) schemas
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> componentsIn: aModel [

	^ (self entitiesNamed: #Components in: aModel) anyOne
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> entitiesNamed: anEntityName in: aModel [

	^ aModel allWithType: (self generatedClassNamed: anEntityName)
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> forwardReferenceJson [

	^ self schemasJson:
		  '"A":{"type":"array","items":{"$ref":"#/components/schemas/B"}},"B":{"type":"object"}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> generatedClassNamed: anEntityName [

	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString
	                       , anEntityName asString) asSymbol.
	^ Smalltalk globals at: generatedClassName ifAbsent: [
		  self fail:
			  'Missing generated class: ' , generatedClassName asString ]
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> importOpenApi3: aMembersString [

	^ FamixOpenApiImporter new modelFromJsonString:
		  (self openApi3Json: aMembersString)
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> importSwagger2: aMembersString [

	^ FamixOpenApiImporter new modelFromJsonString:
		  (self swagger2Json: aMembersString)
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> importedSchema: aSchemaJson [
	"Answer the component schema S built from aSchemaJson."

	^ self
		  componentSchemaNamed: 'S'
		  in:
		  (self importOpenApi3: (self schemasJson: '"S":' , aSchemaJson))
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> listPetsResponseIn: aModel [

	^ self
		  responseOf: (self operationWithId: 'listPets' in: aModel)
		  code: '200'
]

{ #category : 'tests - count consistency' }
FamixOpenApiImporterFidelityTest >> midSizeJson [

	^ '"paths":{"/pets":{"get":{"operationId":"listPets","parameters":[{"name":"limit","in":"query","schema":{"type":"integer"}}],"responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"$ref":"#/components/schemas/PetList"}}}}}}}},"components":{"schemas":{"PetList":{"type":"array","items":{"$ref":"#/components/schemas/Pet"}},"Pet":{"type":"object","properties":{"owner":{"$ref":"#/components/schemas/Owner"}}},"Owner":{"type":"object"}}}'
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> mutualCycleJson [

	^ self schemasJson:
		  '"A":{"type":"array","items":{"$ref":"#/components/schemas/B"}},"B":{"type":"array","items":{"$ref":"#/components/schemas/A"}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> openApi3Json: aMembersString [

	^ '{"openapi":"3.0.0","info":{"title":"t","version":"1"},'
	  , aMembersString , '}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> operationWithId: anOperationId in: aModel [

	^ (self entitiesNamed: #Operation in: aModel)
		  detect: [ :each | each operationId = anOperationId ]
		  ifNone: [ self fail: 'No operation with id ' , anOperationId ]
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> petWithOwnerJson [

	^ '"paths":{},"components":{"schemas":{"Owner":{"type":"object"},"Pet":{"type":"object","properties":{"id":{"type":"integer","format":"int64"},"name":{"type":"string"},"owner":{"$ref":"#/components/schemas/Owner"},"tags":{"type":"array","items":{"type":"string"}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> propertyNamed: aPropertyName ofSchema: aSchema [

	^ aSchema properties
		  detect: [ :each | each name = aPropertyName ]
		  ifNone: [ self fail: 'No property named ' , aPropertyName ]
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> responseOf: anOperation code: aStatusCode [

	^ self valueAtKey: aStatusCode inEntries: anOperation responses
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> richDocumentJson [

	^ '"servers":[{"url":"https://{env}.example.com","variables":{"env":{"default":"prod","enum":["prod","dev"]}}}],"externalDocs":{"url":"https://docs.example.com"},"tags":[{"name":"pets"}],"security":[{"ApiKeyAuth":[]}],"paths":{"/pets":{"get":{"operationId":"listPets","tags":["pets"],"externalDocs":{"url":"https://op.example.com"},"security":[{"OAuth":["read","write"]}],"responses":{"200":{"description":"ok","headers":{"X-Rate-Limit":{"description":"rate","schema":{"type":"integer"}}},"links":{"next":{"operationId":"listPets"}},"content":{"application/json":{"schema":{"type":"string"},"encoding":{"a":{"contentType":"text/plain"}}}}}}}}},"components":{"securitySchemes":{"ApiKeyAuth":{"type":"apiKey","in":"header","name":"X-API-Key"},"OAuth":{"type":"oauth2","flows":{"authorizationCode":{"authorizationUrl":"https://auth.example.com","tokenUrl":"https://token.example.com","scopes":{"read":"Read","write":"Write"}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> schemasJson: aSchemasString [

	^ '"paths":{},"components":{"schemas":{' , aSchemasString , '}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> schemasNamed: aName in: aModel [

	^ (self entitiesNamed: #Schema in: aModel) select: [ :each |
		  each name = aName ]
]

{ #category : 'tests - D3 reference resolution order' }
FamixOpenApiImporterFidelityTest >> selfReferenceJson [

	^ self schemasJson:
		  '"Tree":{"type":"array","items":{"$ref":"#/components/schemas/Tree"}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> sharedComponentsJson [

	^ '"paths":{"/a":{"parameters":[{"$ref":"#/components/parameters/Limit"}],"post":{"operationId":"opA","parameters":[{"$ref":"#/components/parameters/Limit"},{"name":"q","in":"query","schema":{"type":"string"}}],"requestBody":{"$ref":"#/components/requestBodies/PetBody"},"responses":{"404":{"$ref":"#/components/responses/NotFound"}}}},"/b":{"parameters":[{"$ref":"#/components/parameters/Limit"}],"post":{"operationId":"opB","parameters":[{"$ref":"#/components/parameters/Limit"}],"requestBody":{"$ref":"#/components/requestBodies/PetBody"},"responses":{"404":{"$ref":"#/components/responses/NotFound"}}}}},"components":{"responses":{"NotFound":{"description":"nf"}},"parameters":{"Limit":{"name":"limit","in":"query","schema":{"type":"integer"}}},"requestBodies":{"PetBody":{"content":{"application/json":{"schema":{"type":"object"}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> sharedPetSchemaJson [

	^ '"paths":{"/a":{"get":{"operationId":"opA","parameters":[{"name":"p1","in":"query","schema":{"$ref":"#/components/schemas/Pet"}},{"name":"p2","in":"header","schema":{"$ref":"#/components/schemas/Pet"}}],"requestBody":{"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}},"application/xml":{"schema":{"$ref":"#/components/schemas/Pet"}}}},"responses":{"200":{"description":"ok"}}}}},"components":{"schemas":{"Pet":{"type":"object"},"Couple":{"type":"object","properties":{"first":{"$ref":"#/components/schemas/Pet"},"second":{"$ref":"#/components/schemas/Pet"}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> stubSchemasIn: aModel [
	"A stub is a schema carrying a reference but no content at all."

	^ (self entitiesNamed: #Schema in: aModel) select: [ :each |
		  each ref isNotNil and: [
			  each type isNil and: [
				  each properties isEmptyOrNil and: [
					  each items isNil and: [ each allOf isEmptyOrNil ] ] ] ] ]
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> swagger2Json: aMembersString [

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},'
	  , aMembersString , '}'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> swagger2PetJson [

	^ '"paths":{"/pets":{"post":{"operationId":"addPet","parameters":[{"name":"body","in":"body","schema":{"$ref":"#/definitions/Pet"}},{"name":"ids","in":"query","type":"array","items":{"type":"integer","format":"int64"},"collectionFormat":"csv"}],"responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Pet"}},"default":{"$ref":"#/responses/GenericError"}}}}},"definitions":{"Pet":{"type":"object","properties":{"id":{"type":"integer","format":"int64"},"name":{"type":"string"}}}},"securityDefinitions":{"basic":{"type":"basic"}},"parameters":{"Trace":{"name":"trace","in":"header","type":"string"}},"responses":{"GenericError":{"description":"error"}}'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testAllParametersOfPostOperationMergesPathParameters [
	"D5: allParameters of a POST operation includes the path-level parameter."

	| operation |
	operation := self
		             operationWithId: 'createPet'
		             in: (self importOpenApi3: self verbsJson).
	self
		assert: (operation allParameters collect: #name) asArray
		equals: #( 'traceId' )
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testApiExternalDocsAreImported [
	"D8: externalDocs of the api is kept (slot #externalDocs exists)."

	| docs |
	docs := (self apiIn: (self importOpenApi3: self richDocumentJson))
		        externalDocs.
	self
		assert: docs notNil
		description: 'api externalDocs should be kept'.
	self assert: docs url equals: 'https://docs.example.com'
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testApiKeySchemeKeepsComponentKeyAsEntryKey [
	"D9: the security scheme entry key is the component key ApiKeyAuth."

	| entries |
	entries := (self componentsIn:
		            (self importOpenApi3: self richDocumentJson))
		           securitySchemes.
	self assert:
		(entries anySatisfy: [ :each | each key = 'ApiKeyAuth' ])
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testApiKeySchemeKeepsHeaderNameDistinctFromKey [
	"D9: the apiKey scheme keeps name X-API-Key (the header name) and not the component key; entity #name must not be overwritten by the key."

	| scheme |
	scheme := self apiKeySchemeIn:
		          (self importOpenApi3: self richDocumentJson).
	self assert: scheme name equals: 'X-API-Key'
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testApiKeySchemeKeepsLocation [
	"D9: the apiKey scheme keeps its location (in: header)."

	self
		assert:
			(self apiKeySchemeIn: (self importOpenApi3: self richDocumentJson))
				location
		equals: 'header'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testArrayPropertyExposesItems [
	"D1: an array property must expose the items schema (#items; not modelled on Property yet)."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'tags'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self assert: property understands: #items.
	self assert: property items type equals: 'string'
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testArrayWhereSchemaIsExpectedCreatesNoEntityAndDoesNotRaise [
	"D11: a JSON array where a schema object is expected must neither raise nor create a schema entity."

	| model |
	self
		shouldnt: [
			model := self importOpenApi3: (self schemasJson:
					          '"Pet":{"type":"object","items":["a","b"],"additionalProperties":[1]}') ]
		raise: Error.
	self assert: (self entitiesNamed: #Schema in: model) size equals: 1
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

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testBooleanAdditionalPropertiesCreatesNoGarbageSchema [
	"D11: additionalProperties true/false is a boolean, not a schema: only the Pet schema exists."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '"Pet":{"type":"object","additionalProperties":true},"Closed":{"type":"object","additionalProperties":false}').
	self assert: (self entitiesNamed: #Schema in: model) size equals: 2
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testBooleanAdditionalPropertiesFalseIsKept [
	"D11: additionalProperties: false is kept as additonalPropertiesAllowed = false (sic)."

	self
		assert:
			(self importedSchema:
				 '{"type":"object","additionalProperties":false}')
				additonalPropertiesAllowed
		equals: false
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testBooleanComponentSchemaDoesNotRaise [
	"D11: a boolean schema (true) as a component value must not raise nor create a garbage schema."

	| model |
	self
		shouldnt: [
		model := self importOpenApi3: (self schemasJson: '"Anything":true') ]
		raise: Error.
	self assert: (self entitiesNamed: #Schema in: model) isEmpty
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testDeleteOperationKnowsItsHttpMethod [
	"D5: DELETE operation knows its verb (accessor #httpMethod, not modelled yet)."

	self assertOperation: 'deletePet' hasHttpMethod: 'delete'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testDeleteOperationKnowsItsPath [
	"D5: DELETE operation is linked to its path."

	self assertOperationKnowsItsPath: 'deletePet'
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

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testInlineComponentParameterHasNoSourceRef [
	"D10: a component parameter written inline must not look like an alias: its #ref is nil."

	| parameter |
	parameter := self
		             valueAtKey: 'Limit'
		             inEntries:
			             (self componentsIn:
				              (self importOpenApi3: self sharedComponentsJson))
				             parameters.
	self
		assert: parameter ref isNil
		description: 'ref should be nil, got ' , parameter ref printString
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testInlineComponentSchemaHasNoSourceRef [
	"D10: a component schema written inline (no $ref in the source) must not look like an alias: its #ref is nil."

	| schema |
	schema := self importedSchema: '{"type":"object"}'.
	self
		assert: schema ref isNil
		description: 'ref should be nil, got ' , schema ref printString
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testMalformedReferenceIsReportedAsDiagnostic [
	"D11: a malformed $ref (not a string pointer) is reported (accessor #diagnostics on the importer; not modelled yet)."

	| importer |
	importer := FamixOpenApiImporter new.
	importer modelFromJsonString: (self openApi3Json:
			 (self schemasJson: '"A":{"type":"array","items":{"$ref":42}}')).
	self assert: importer understands: #diagnostics.
	self
		assert: importer diagnostics notEmpty
		description: 'The malformed $ref should be reported'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testMediaTypeEncodingIsImported [
	"D8: media type encoding is kept (accessor #encoding on the media type; not modelled yet)."

	| mediaType |
	mediaType := (self listPetsResponseIn:
		              (self importOpenApi3: self richDocumentJson)) content
		             anyOne value.
	self assert: mediaType understands: #encoding.
	self
		assert: mediaType encoding notNil
		description: 'The encoding map should be kept'
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
	"D3: A items -> B and B items -> A must be identical to the component entries."

	| model a b |
	model := self importOpenApi3: self mutualCycleJson.
	a := self componentSchemaNamed: 'A' in: model.
	b := self componentSchemaNamed: 'B' in: model.
	self assert: a items == b description: 'A items should be B'.
	self assert: b items == a description: 'B items should be A'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testNestedPointerLeavesNoStub [
	"D12: a nested pointer must not leave a ref-only stub schema in the model."

	self assertNoStubSchemasIn: (self importOpenApi3: (self schemasJson:
				  '"Pet":{"type":"object","properties":{"id":{"type":"integer"}}},"Ids":{"type":"array","items":{"$ref":"#/components/schemas/Pet/properties/id"}}'))
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testNestedPointerResolvesToTheTargetContent [
	"D12: #/components/schemas/Pet/properties/id points inside Pet: items must expose the integer content, not a stub."

	| model items |
	model := self importOpenApi3: (self schemasJson:
			          '"Pet":{"type":"object","properties":{"id":{"type":"integer"}}},"Ids":{"type":"array","items":{"$ref":"#/components/schemas/Pet/properties/id"}}').
	items := (self componentSchemaNamed: 'Ids' in: model) items.
	self assert: items notNil description: 'items should be resolved'.
	self assert: items type equals: 'integer'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testOAuth2SchemeKeepsAuthorizationUrl [
	"D8: OAuth2 flow authorizationUrl is kept on the scheme (slot #authorizationUrl exists but OAS3 'flows' is nested)."

	| scheme |
	scheme := self
		          valueAtKey: 'OAuth'
		          inEntries:
			          (self componentsIn:
				           (self importOpenApi3: self richDocumentJson))
				          securitySchemes.
	self
		assert: scheme authorizationUrl
		equals: 'https://auth.example.com'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testOAuth2SchemeKeepsScopes [
	"D8: OAuth2 flow scopes are kept on the scheme (slot #scopes exists but OAS3 'flows' is nested)."

	| scheme |
	scheme := self
		          valueAtKey: 'OAuth'
		          inEntries:
			          (self componentsIn:
				           (self importOpenApi3: self richDocumentJson))
				          securitySchemes.
	self
		assert: scheme scopes notNil
		description: 'OAuth2 scopes should be kept'.
	self assert: scheme scopes size equals: 2
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testOperationExternalDocsAreImported [
	"D8: externalDocs of an operation is kept (slot #externalDocs exists)."

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

{ #category : 'tests - D2 shared references' }
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

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testOperationSecurityRequirementKeepsScopes [
	"D8: operation security requirement keeps its scopes (accessor #scopes on the requirement; not modelled yet)."

	| security |
	security := (self
		             operationWithId: 'listPets'
		             in: (self importOpenApi3: self richDocumentJson))
		            security.
	self assert: security size equals: 1.
	self assert: security anyOne understands: #scopes.
	self
		assert: security anyOne scopes asSet
		equals: #( 'read' 'write' ) asSet
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testOperationTagsAreLinkedToTagEntities [
	"D8: operation tags resolve to Tag entities (accessor #tags on the operation; only raw #tagReferences exist today)."

	| model operation |
	model := self importOpenApi3: self richDocumentJson.
	operation := self operationWithId: 'listPets' in: model.
	self assert: operation understands: #tags.
	self
		assert: operation tags asArray
		equals: (self entitiesNamed: #Tag in: model) asArray
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testPatchOperationKnowsItsHttpMethod [
	"D5: PATCH operation knows its verb (accessor #httpMethod, not modelled yet)."

	self assertOperation: 'updatePet' hasHttpMethod: 'patch'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testPatchOperationKnowsItsPath [
	"D5: PATCH operation is linked to its path."

	self assertOperationKnowsItsPath: 'updatePet'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testPercentEncodedPointerResolvesToComponentKeyWithSpace [
	"D12: #/components/schemas/My%20Schema resolves to the schema keyed 'My Schema'."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '"My Schema":{"type":"object"},"A":{"type":"array","items":{"$ref":"#/components/schemas/My%20Schema"}}').
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'My Schema' in: model)
		description: 'items should be the My Schema component entity'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testPostOperationKnowsItsHttpMethod [
	"D5: POST operation knows its verb (accessor #httpMethod, not modelled yet)."

	self assertOperation: 'createPet' hasHttpMethod: 'post'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testPostOperationKnowsItsPath [
	"D5: POST operation is linked to its path."

	self assertOperationKnowsItsPath: 'createPet'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyDoesNotMistakeDeclaringSchemaForItsOwnSchema [
	"D1: Property>>schema answers the declaring schema (Pet) for every property, which is wrong as a description of the property type."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'name'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self
		assert:
		property schema ~~ (self componentSchemaNamed: 'Pet' in: model)
		description:
		'Property>>schema should not be the schema that merely declares the property'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyKeepsItsFormat [
	"D1: a property must expose the format of its own inline schema (#format)."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'id'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self assert: property understands: #format.
	self assert: property format equals: 'int64'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyKeepsItsType [
	"D1: a property must expose the type of its own inline schema (#type)."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'id'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self assert: property understands: #type.
	self assert: property type equals: 'integer'
]

{ #category : 'tests - D1 property own schema' }
FamixOpenApiImporterFidelityTest >> testPropertyReferencingComponentExposesResolvedSchema [
	"D1: a property declared with a $ref must expose the referenced schema. The accessor #valueSchema does not exist yet (Property>>schema is the declaring schema, not the property value schema)."

	| model property |
	model := self importOpenApi3: self petWithOwnerJson.
	property := self
		            propertyNamed: 'owner'
		            ofSchema: (self componentSchemaNamed: 'Pet' in: model).
	self assert: property understands: #valueSchema.
	self
		assert:
		property valueSchema
		== (self componentSchemaNamed: 'Owner' in: model)
		description:
		'The owner property should reference the Owner component schema entity'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testPutOperationKnowsItsHttpMethod [
	"D5: PUT operation knows its verb (accessor #httpMethod, not modelled yet)."

	self assertOperation: 'replacePet' hasHttpMethod: 'put'
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testPutOperationKnowsItsPath [
	"D5: PUT operation is linked to its path."

	self assertOperationKnowsItsPath: 'replacePet'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testResponseHeadersAreImported [
	"D8: response headers are kept as entries of the response (slot #headers exists)."

	| headers |
	headers := (self listPetsResponseIn:
		            (self importOpenApi3: self richDocumentJson)) headers.
	self assert: headers size equals: 1.
	self assert: headers anyOne key equals: 'X-Rate-Limit'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testResponseLinksAreImported [
	"D8: response links are kept (accessor #links on the response; not modelled yet)."

	| response |
	response := self listPetsResponseIn:
		            (self importOpenApi3: self richDocumentJson).
	self assert: response understands: #links.
	self assert: response links size equals: 1
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> testSameNameParametersInDifferentLocationsAreBothKept [
	"D5: a header id and a query id parameter are distinct and both kept."

	| operation |
	operation := self
		             operationWithId: 'listPets'
		             in: (self importOpenApi3:
				              '"paths":{"/pets":{"get":{"operationId":"listPets","parameters":[{"name":"id","in":"header","schema":{"type":"string"}},{"name":"id","in":"query","schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}}}}').
	self assert: operation parameters size equals: 2.
	self
		assert: (operation parameters collect: #location) asSet
		equals: #( 'header' 'query' ) asSet
]

{ #category : 'tests - D2 shared references' }
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
			assert: each value schema == pet
			description: 'Media type ' , each key
				, ' should reference the Pet component schema' ]
]

{ #category : 'tests - D2 shared references' }
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
	"D2: two properties declared with $ref Pet both expose the very same Pet entity (accessor #valueSchema not modelled yet, see D1)."

	| model pet couple |
	model := self importOpenApi3: self sharedPetSchemaJson.
	pet := self componentSchemaNamed: 'Pet' in: model.
	couple := self componentSchemaNamed: 'Couple' in: model.
	couple properties do: [ :each |
		self assert: each understands: #valueSchema.
		self
			assert: each valueSchema == pet
			description:
			'Property ' , each name
			, ' should reference the Pet component schema' ]
]

{ #category : 'tests - count consistency' }
FamixOpenApiImporterFidelityTest >> testSchemaEntityCountEqualsComponentSchemasPlusInlineSchemas [
	"Count consistency: 3 component schemas + 1 inline schema (the limit parameter) = 4 schema entities; $ref uses must not add stubs."

	| model |
	model := self importOpenApi3: self midSizeJson.
	self assert: (self entitiesNamed: #Schema in: model) size equals: 4
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testSchemaEntryKeyIsDistinctFromTitle [
	"D9: the schema entry key stays Pet while the title is kept apart."

	| entry |
	entry := (self componentsIn: (self importOpenApi3:
			           (self schemasJson:
				            '"Pet":{"type":"object","title":"A pet"}'))) schemas
		         anyOne.
	self assert: entry key equals: 'Pet'.
	self assert: entry value title equals: 'A pet'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAdditionalPropertiesBooleanTrue [
	"D6: additionalProperties: true is kept (slot #additonalPropertiesAllowed, sic)."

	self
		assert:
			(self importedSchema:
				 '{"type":"object","additionalProperties":true}')
				additonalPropertiesAllowed
		equals: true
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAdditionalPropertiesSchema [
	"D6: additionalProperties given as a schema is kept (slot #additonalProperties, sic)."

	| schema |
	schema := self importedSchema:
		          '{"type":"object","additionalProperties":{"type":"string"}}'.
	self
		assert: schema additonalProperties notNil
		description: 'additionalProperties schema should be kept'.
	self assert: schema additonalProperties type equals: 'string'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsAllOfMembersResolved [
	"D6: allOf members that are $ref resolve to the component entities."

	| model composed |
	model := self importOpenApi3: (self schemasJson:
			          '"Base":{"type":"object"},"Extra":{"type":"object"},"Composed":{"allOf":[{"$ref":"#/components/schemas/Base"},{"$ref":"#/components/schemas/Extra"}]}').
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
	"D6: anyOf members must be kept. The slot #anyOf does not exist yet in the model."

	| schema |
	schema := self importedSchema:
		          '{"anyOf":[{"type":"string"},{"type":"integer"}]}'.
	self assert: schema understands: #anyOf.
	self assert: schema anyOf size equals: 2
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsDefault [
	"D6: default value is kept on the schema."

	self
		assert:
		(self importedSchema: '{"type":"string","default":"cat"}') default
		equals: 'cat'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsDiscriminator [
	"D6: discriminator (Swagger 2 string form) is kept on the schema."

	self
		assert: (self importedSchema:
				 '{"type":"object","discriminator":"petType","properties":{"petType":{"type":"string"}}}')
				discriminator
		equals: 'petType'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsEnum [
	"D6: enum values are kept on the schema."

	| schema |
	schema := self importedSchema:
		          '{"type":"string","enum":["cat","dog"]}'.
	self assert: schema enum isNotNil description: 'enum should be kept'.
	self assert: schema enum asArray equals: #( 'cat' 'dog' )
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMaxLength [
	"D6: maxLength is kept on the schema."

	self
		assert:
			(self importedSchema:
				 '{"type":"string","minLength":2,"maxLength":5}') maxLength
		equals: 5
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMaximum [
	"D6: maximum is kept on the schema."

	self
		assert:
			(self importedSchema: '{"type":"integer","minimum":1,"maximum":10}')
				maximum
		equals: 10
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMinLength [
	"D6: minLength is kept on the schema."

	self
		assert:
			(self importedSchema:
				 '{"type":"string","minLength":2,"maxLength":5}') minLength
		equals: 2
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsMinimum [
	"D6: minimum is kept on the schema."

	self
		assert:
			(self importedSchema: '{"type":"integer","minimum":1,"maximum":10}')
				minimum
		equals: 1
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsNot [
	"D6: the 'not' schema must be kept. The slot #not does not exist yet in the model."

	| schema |
	schema := self importedSchema: '{"not":{"type":"string"}}'.
	self assert: schema understands: #not.
	self assert: schema not type equals: 'string'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsNullable [
	"D6: nullable: true must be kept. The slot #nullable does not exist yet in the model."

	| schema |
	schema := self importedSchema: '{"type":"string","nullable":true}'.
	self assert: schema understands: #nullable.
	self assert: schema nullable equals: true
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsOneOf [
	"D6: oneOf members must be kept. The slot #oneOf does not exist yet in the model."

	| schema |
	schema := self importedSchema:
		          '{"oneOf":[{"type":"string"},{"type":"integer"}]}'.
	self assert: schema understands: #oneOf.
	self assert: schema oneOf size equals: 2
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsPattern [
	"D6: pattern is kept on the schema."

	self
		assert:
			(self importedSchema: '{"type":"string","pattern":"^[a-z]+$"}')
				pattern
		equals: '^[a-z]+$'
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaKeepsRequiredPropertiesList [
	"D6: the required list of an object schema is kept on the schema itself (accessor #required; only Property>>required exists today)."

	| schema |
	schema := self importedSchema:
		          '{"type":"object","required":["id","name"],"properties":{"id":{"type":"integer"},"name":{"type":"string"},"nick":{"type":"string"}}}'.
	self assert: schema understands: #required.
	self assert: schema required asSet equals: #( 'id' 'name' ) asSet
]

{ #category : 'tests - D6 schema attributes' }
FamixOpenApiImporterFidelityTest >> testSchemaMarksRequiredPropertiesOnProperties [
	"D6: properties listed in the required array are flagged as required."

	| schema |
	schema := self importedSchema:
		          '{"type":"object","required":["id"],"properties":{"id":{"type":"integer"},"nick":{"type":"string"}}}'.
	self
		assert: (self propertyNamed: 'id' ofSchema: schema) required
		equals: true.
	self
		assert: (self propertyNamed: 'nick' ofSchema: schema) required
		equals: false
]

{ #category : 'tests - D9 D10 naming and ref semantics' }
FamixOpenApiImporterFidelityTest >> testSchemaNameIsComponentKeyNotTitle [
	"D9: the entity name of a component schema is its component key (Pet), not its title."

	self
		assert: (self componentSchemaNamed: 'Pet' in: (self importOpenApi3:
					  (self schemasJson: '"Pet":{"type":"object","title":"A pet"}')))
				name
		equals: 'Pet'
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

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testServerVariablesAreImported [
	"D7: server variables are kept (accessor #variables on the server; not modelled yet)."

	| api |
	api := self apiIn: (self importOpenApi3: self richDocumentJson).
	self assert: api understands: #servers.
	self assert: api servers anyOne understands: #variables.
	self assert: api servers anyOne variables size equals: 1
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testServersAreImported [
	"D7: OAS3 servers are kept (accessor #servers on the api; not modelled yet)."

	| api |
	api := self apiIn: (self importOpenApi3: self richDocumentJson).
	self assert: api understands: #servers.
	self assert: api servers size equals: 1.
	self
		assert: api servers anyOne url
		equals: 'https://{env}.example.com'
]

{ #category : 'tests - D2 shared references' }
FamixOpenApiImporterFidelityTest >> testSharedParameterIsReachedFromBothOperations [
	"D2: two operations referencing the same #/components/parameters/Limit both reach the same parameter entity."

	| model shared |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          valueAtKey: 'Limit'
		          inEntries: (self componentsIn: model) parameters.
	self
		assert:
			((self operationWithId: 'opA' in: model) parameters anySatisfy: [
				 :each | each == shared ])
		description: 'opA should reach the shared Limit parameter'.
	self
		assert:
			((self operationWithId: 'opB' in: model) parameters anySatisfy: [
				 :each | each == shared ])
		description: 'opB should reach the shared Limit parameter'
]

{ #category : 'tests - D2 shared references' }
FamixOpenApiImporterFidelityTest >> testSharedParameterIsReachedFromBothPaths [
	"D2: two paths declaring the same path-level #/components/parameters/Limit both reach the same parameter entity."

	| model shared paths |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          valueAtKey: 'Limit'
		          inEntries: (self componentsIn: model) parameters.
	paths := self entitiesNamed: #Path in: model.
	self assert: paths size equals: 2.
	paths do: [ :each |
		self
			assert:
			(each parameters anySatisfy: [ :parameter | parameter == shared ])
			description:
			'Path ' , each name , ' should reach the shared Limit parameter' ]
]

{ #category : 'tests - D2 shared references' }
FamixOpenApiImporterFidelityTest >> testSharedRequestBodyIsReachedFromBothOperations [
	"D2: two operations referencing the same #/components/requestBodies/PetBody both reach the same request body entity."

	| model shared |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          valueAtKey: 'PetBody'
		          inEntries: (self componentsIn: model) requestBodies.
	self
		assert:
		(self operationWithId: 'opA' in: model) requestBody == shared
		description: 'opA should reach the shared PetBody'.
	self
		assert:
		(self operationWithId: 'opB' in: model) requestBody == shared
		description: 'opB should reach the shared PetBody'
]

{ #category : 'tests - D2 shared references' }
FamixOpenApiImporterFidelityTest >> testSharedResponseIsReachedFromBothOperations [
	"D2: two operations referencing the same #/components/responses/NotFound both reach the same response entity."

	| model shared |
	model := self importOpenApi3: self sharedComponentsJson.
	shared := self
		          valueAtKey: 'NotFound'
		          inEntries: (self componentsIn: model) responses.
	self
		assert:
			(self
				 responseOf: (self operationWithId: 'opA' in: model)
				 code: '404') == shared
		description: 'opA should reach the shared NotFound response'.
	self
		assert:
			(self
				 responseOf: (self operationWithId: 'opB' in: model)
				 code: '404') == shared
		description: 'opB should reach the shared NotFound response'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testSlashEscapedPointerResolvesToComponentKeyWithSlash [
	"D12: ~1 in a pointer stands for / : #/components/schemas/a~1b resolves to the schema keyed 'a/b'."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '"a/b":{"type":"object"},"A":{"type":"array","items":{"$ref":"#/components/schemas/a~1b"}}').
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'a/b' in: model)
		description: 'items should be the a/b component entity'
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testStringWhereSchemaIsExpectedCreatesNoEntityAndDoesNotRaise [
	"D11: a JSON string where a schema object is expected must neither raise nor create a schema entity."

	| model |
	self
		shouldnt: [
			model := self importOpenApi3: (self schemasJson:
					          '"Pet":{"type":"object","items":"string","properties":{"a":"string"}}') ]
		raise: Error.
	self assert: (self entitiesNamed: #Schema in: model) size equals: 1
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2BodyParameterRefResolvesToDefinition [
	"D4: the body parameter schema $ref #/definitions/Pet must be the definition entity."

	| model definition body |
	model := self importSwagger2: self swagger2PetJson.
	definition := self
		              valueAtKey: 'Pet'
		              inEntries: (self apiIn: model) definitions.
	body := (self operationWithId: 'addPet' in: model) parameters
		        detect: [ :each | each name = 'body' ].
	self
		assert: body schema == definition
		description:
		'The body parameter should reference the Pet definition'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefinitionLeavesNoStubSchema [
	"D4: resolving #/definitions/Pet must not leave a ref-only stub schema."

	self assertNoStubSchemasIn:
		(self importSwagger2: self swagger2PetJson)
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2DefinitionsAreImported [
	"D4: definitions are imported as entries of the api (key Pet)."

	| model definitions |
	model := self importSwagger2: self swagger2PetJson.
	definitions := (self apiIn: model) definitions.
	self assert: definitions size equals: 1.
	self assert: definitions anyOne key equals: 'Pet'.
	self assert: definitions anyOne value properties size equals: 2
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2GlobalParametersAreImported [
	"D4: top level parameters are imported as entries of the api."

	| parameters |
	parameters := (self apiIn:
		               (self importSwagger2: self swagger2PetJson))
		              parameters.
	self assert: parameters size equals: 1.
	self assert: parameters anyOne key equals: 'Trace'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2GlobalResponsesAreImportedAndReferenced [
	"D4: top level responses are imported and #/responses/GenericError resolves to the entry value."

	| model global |
	model := self importSwagger2: self swagger2PetJson.
	global := self
		          valueAtKey: 'GenericError'
		          inEntries: (self apiIn: model) responses.
	self
		assert: (self
				 responseOf: (self operationWithId: 'addPet' in: model)
				 code: 'default') == global
		description:
		'The default response should be the global GenericError response'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2InlineParameterKeepsCollectionFormat [
	"D4: inline array parameter keeps its collectionFormat."

	| model ids |
	model := self importSwagger2: self swagger2PetJson.
	ids := (self operationWithId: 'addPet' in: model) parameters detect: [
		       :each | each name = 'ids' ].
	self assert: ids collectionFormat equals: 'csv'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2InlineParameterKeepsTypeAndFormatOfItems [
	"D4: inline array parameter keeps type and items (with the items format)."

	| model ids |
	model := self importSwagger2: self swagger2PetJson.
	ids := (self operationWithId: 'addPet' in: model) parameters detect: [
		       :each | each name = 'ids' ].
	self assert: ids type equals: 'array'.
	self
		assert: ids items notNil
		description: 'The items of the parameter should be kept'.
	self assert: ids items type equals: 'integer'.
	self assert: ids items format equals: 'int64'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2ResponseSchemaRefResolvesToDefinition [
	"D4: the response schema $ref #/definitions/Pet must be the definition entity."

	| model definition response |
	model := self importSwagger2: self swagger2PetJson.
	definition := self
		              valueAtKey: 'Pet'
		              inEntries: (self apiIn: model) definitions.
	response := self
		            responseOf: (self operationWithId: 'addPet' in: model)
		            code: '200'.
	self
		assert: response schema notNil
		description: 'The response schema should be kept'.
	self
		assert: response schema == definition
		description: 'The response schema should be the Pet definition'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2SecurityDefinitionsAreImported [
	"D4: securityDefinitions are imported as entries of the api."

	| definitions |
	definitions := (self apiIn:
		                (self importSwagger2: self swagger2PetJson))
		               securityDefinitions.
	self assert: definitions size equals: 1.
	self assert: definitions anyOne key equals: 'basic'
]

{ #category : 'tests - D4 swagger 2.0' }
FamixOpenApiImporterFidelityTest >> testSwagger2VersionIsStored [
	"D4: the 'swagger: 2.0' version string must be kept on the api entity (#openapi holds the spec version)."

	| model |
	model := self importSwagger2: self swagger2PetJson.
	self assert: (self apiIn: model) openapi equals: '2.0'
]

{ #category : 'tests - D12 json pointers' }
FamixOpenApiImporterFidelityTest >> testTildeEscapedPointerResolvesToComponentKeyWithTilde [
	"D12: ~0 in a pointer stands for ~ : #/components/schemas/a~0b resolves to the schema keyed 'a~b'."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '"a~b":{"type":"object"},"A":{"type":"array","items":{"$ref":"#/components/schemas/a~0b"}}').
	self
		assert: (self componentSchemaNamed: 'A' in: model) items
			== (self componentSchemaNamed: 'a~b' in: model)
		description: 'items should be the a~b component entity'
]

{ #category : 'tests - D7 D8 missing sections' }
FamixOpenApiImporterFidelityTest >> testTopLevelSecurityRequirementIsImported [
	"D8: top-level security requirement is kept on the api (slot #security exists)."

	| security |
	security := (self apiIn: (self importOpenApi3: self richDocumentJson))
		            security.
	self assert: security size equals: 1.
	self assert: security anyOne securitySchemes size equals: 1
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testUnresolvedReferenceDoesNotCreateStubSchema [
	"D11: a dangling $ref must not leave a ref-only stub schema in the model."

	self assertNoStubSchemasIn: (self importOpenApi3: (self schemasJson:
				  '"A":{"type":"array","items":{"$ref":"#/components/schemas/Missing"}}'))
]

{ #category : 'tests - D11 robustness' }
FamixOpenApiImporterFidelityTest >> testUnresolvedReferenceIsReportedAsDiagnostic [
	"D11: a $ref to a missing target is reported (accessor #diagnostics on the importer; not modelled yet) instead of silently creating a stub."

	| importer |
	importer := FamixOpenApiImporter new.
	importer modelFromJsonString: (self openApi3Json: (self schemasJson:
				  '"A":{"type":"array","items":{"$ref":"#/components/schemas/Missing"}}')).
	self assert: importer understands: #diagnostics.
	self
		assert: importer diagnostics notEmpty
		description: 'The dangling $ref should be reported'
]

{ #category : 'helpers' }
FamixOpenApiImporterFidelityTest >> valueAtKey: aKey inEntries: aCollection [

	^ (aCollection
		   detect: [ :each | each key = aKey ]
		   ifNone: [ self fail: 'No entry with key ' , aKey printString ])
		  value
]

{ #category : 'tests - D5 operations' }
FamixOpenApiImporterFidelityTest >> verbsJson [

	^ '"paths":{"/pets":{"parameters":[{"name":"traceId","in":"header","schema":{"type":"string"}}],"post":{"operationId":"createPet","responses":{"200":{"description":"ok"}}},"put":{"operationId":"replacePet","responses":{"200":{"description":"ok"}}},"delete":{"operationId":"deletePet","responses":{"200":{"description":"ok"}}},"patch":{"operationId":"updatePet","responses":{"200":{"description":"ok"}}}}}'
]
