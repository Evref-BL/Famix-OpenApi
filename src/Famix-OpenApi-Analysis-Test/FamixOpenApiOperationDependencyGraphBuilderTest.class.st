Class {
	#name : 'FamixOpenApiOperationDependencyGraphBuilderTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Analysis-Test',
	#package : 'Famix-OpenApi-Analysis-Test'
}

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> generatedClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
		at: generatedClassName
		ifAbsent: [ self fail: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> dependencyGraphFixtureJson [
	^ '{"openapi":"3.0.4","info":{"title":"Dependency API","version":"1.0.0"},"paths":{"/users":{"get":{"operationId":"listUsers","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"$ref":"#/components/schemas/UserPayload"}}}}}}},"/activate":{"post":{"operationId":"activateUser","parameters":[{"name":"id","in":"query","required":true,"schema":{"type":"string"}}],"requestBody":{"required":true,"content":{"application/json":{"schema":{"$ref":"#/components/schemas/ActivationRequest"}}}},"responses":{"200":{"description":"ok"}}}},"/archive":{"post":{"operationId":"archiveUser","parameters":[{"name":"token","in":"query","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}}}},"components":{"schemas":{"UserPayload":{"type":"object","properties":{"id":{"type":"string"},"name":{"type":"string"}}},"ActivationRequest":{"type":"object","required":["name"],"properties":{"name":{"type":"string"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> normalizerFixtureJson [
	^ '{"openapi":"3.0.4","info":{"title":"Normalizer API","version":"1.0.0"},"paths":{"/profiles":{"get":{"operationId":"listProfiles","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"$ref":"#/components/schemas/ProfilePayload"}}}}}}},"/sync":{"post":{"operationId":"syncProfile","parameters":[{"name":"UserId","in":"query","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}}}},"components":{"schemas":{"ProfilePayload":{"type":"object","properties":{"user_id":{"type":"string"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> mediaTypesFixtureJson [
	^ '{"openapi":"3.0.4","info":{"title":"Media Types API","version":"1.0.0"},"paths":{"/items":{"get":{"operationId":"listItems","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"type":"object","properties":{"id":{"type":"string"}}}},"text/plain":{"example":"ok"}}}}},"post":{"operationId":"createItem","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","required":["name"],"properties":{"name":{"type":"string"}}}},"application/xml":{}}},"responses":{"201":{"description":"created"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> pathParametersFixtureJson [
	^ '{"openapi":"3.0.4","info":{"title":"Path Parameters API","version":"1.0.0"},"paths":{"/pets/{id}":{"parameters":[{"name":"id","in":"path","required":true,"schema":{"type":"string"}}],"get":{"operationId":"getPet","responses":{"200":{"description":"ok"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> pathParameterDependencyFixtureJson [
	^ '{"openapi":"3.0.4","info":{"title":"Path Dependency API","version":"1.0.0"},"paths":{"/users":{"get":{"operationId":"listUsers","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"type":"object","properties":{"id":{"type":"string"}}}}}}}}},"/pets/{id}":{"parameters":[{"name":"id","in":"path","required":true,"schema":{"type":"string"}}],"get":{"operationId":"getPetById","responses":{"200":{"description":"ok"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> nonSuccessfulResponseFixtureJson [
	^ '{"openapi":"3.0.4","info":{"title":"Non Successful Response API","version":"1.0.0"},"paths":{"/users":{"get":{"operationId":"listUsersError","responses":{"400":{"description":"bad request","content":{"application/json":{"schema":{"type":"object","properties":{"id":{"type":"string"}}}}}}}}},"/activate":{"post":{"operationId":"activateUser","parameters":[{"name":"id","in":"query","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}}}}}'
]

{ #category : 'private' }
FamixOpenApiOperationDependencyGraphBuilderTest >> operationWithId: anOperationId inModel: aModel [
	| operationClass |
	operationClass := self generatedClassNamed: #Operation.
	^ (aModel allWithType: operationClass)
		detect: [ :each |
			(each respondsTo: #operationId)
				and: [ each operationId = anOperationId ] ]
		ifNone: [ self fail: 'Missing operation with operationId: ', anOperationId ]
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testBuildGraphCreatesExpectedDirectedEdge [
	| builder graph model source target |
	model := FamixOpenApiImporter new modelFromJsonString: self dependencyGraphFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.
	graph := builder buildFromModel: model.
	source := self operationWithId: 'listUsers' inModel: model.
	target := self operationWithId: 'activateUser' inModel: model.

	self assert: ((graph at: source) includes: target)
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testBuildGraphDoesNotCreateEdgeWhenRequiredInputIsMissing [
	| builder graph missingTarget model source |
	model := FamixOpenApiImporter new modelFromJsonString: self dependencyGraphFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.
	graph := builder buildFromModel: model.
	source := self operationWithId: 'listUsers' inModel: model.
	missingTarget := self operationWithId: 'archiveUser' inModel: model.

	self deny: ((graph at: source) includes: missingTarget)
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testNameNormalizerCanBeCustomized [
	| builder graph model source target |
	model := FamixOpenApiImporter new modelFromJsonString: self normalizerFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.
	source := self operationWithId: 'listProfiles' inModel: model.
	target := self operationWithId: 'syncProfile' inModel: model.

	graph := builder buildFromModel: model.
	self deny: ((graph at: source) includes: target).

	builder
		nameNormalizer: [ :rawName |
			(rawName asString asLowercase copyReplaceAll: '_' with: '') ].
	graph := builder buildFromModel: model.
	self assert: ((graph at: source) includes: target)
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testMediaTypesWithSchemaInModelReturnsOnlyMediaTypesHavingSchema [
	| allMediaTypes builder mediaTypeClass mediaTypesWithSchema model |
	model := FamixOpenApiImporter new modelFromJsonString: self mediaTypesFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.

	mediaTypeClass := self generatedClassNamed: #MediaType.
	allMediaTypes := model allWithType: mediaTypeClass.
	mediaTypesWithSchema := builder mediaTypesWithSchemaInModel: model.

	self assert: allMediaTypes size equals: 4.
	self assert: mediaTypesWithSchema size equals: 2.
	self assert: (mediaTypesWithSchema allSatisfy: [ :each |
		(each respondsTo: #schema)
			and: [ each schema notNil ] ])
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testOperationParametersInModelReturnsAllOperationParameters [
	| builder model parameterNames parameters |
	model := FamixOpenApiImporter new modelFromJsonString: self dependencyGraphFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.

	parameters := builder operationParametersInModel: model.
	parameterNames := (parameters collect: [ :each |
		(each respondsTo: #name)
			ifTrue: [ each name ]
			ifFalse: [ nil ] ]) asSet.

	self assert: parameters size equals: 2.
	self assert: parameterNames equals: (Set with: 'id' with: 'token')
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testOperationParametersInModelIncludesPathLevelParameters [
	| builder model parameterNames parameters |
	model := FamixOpenApiImporter new modelFromJsonString: self pathParametersFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.

	parameters := builder operationParametersInModel: model.
	parameterNames := (parameters collect: [ :each |
		(each respondsTo: #name)
			ifTrue: [ each name ]
			ifFalse: [ nil ] ]) asSet.

	self assert: parameters size equals: 1.
	self assert: parameterNames equals: (Set with: 'id')
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testBuildGraphCreatesDependencyUsingRequiredPathParameter [
	| builder graph model source target |
	model := FamixOpenApiImporter new modelFromJsonString: self pathParameterDependencyFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.
	graph := builder buildFromModel: model.
	source := self operationWithId: 'listUsers' inModel: model.
	target := self operationWithId: 'getPetById' inModel: model.

	self assert: ((graph at: source) includes: target)
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderTest >> testBuildGraphIgnoresNonSuccessfulResponsesWhenMatchingParameters [
	| builder graph model source target |
	model := FamixOpenApiImporter new modelFromJsonString: self nonSuccessfulResponseFixtureJson.
	builder := FamixOpenApiOperationDependencyGraphBuilder new.
	graph := builder buildFromModel: model.
	source := self operationWithId: 'listUsersError' inModel: model.
	target := self operationWithId: 'activateUser' inModel: model.

	self deny: ((graph at: source) includes: target)
]
