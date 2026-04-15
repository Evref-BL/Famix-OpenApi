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
