"
Tests of FamixOpenApiCanonicalPointersRule: imported models (OpenAPI 3.1 merged or not, Swagger 2 with its synthetic server and request body) are accepted; a missing, blank, duplicated or conflicting merged pointer is reported, and the pointers legitimately shared between entities of different families are not.
"
Class {
	#name : 'FamixOpenApiCanonicalPointersRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiCanonicalPointersRule
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> mergedSchemaIn: aModel [
	"Answer a schema of aModel that absorbed another one (its mergedPointers are not empty)."

	^ (aModel allWithType: OPSchema) detect: [ :each |
		  each mergedPointers isNotEmpty ]
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> swagger2Document [
	"A Swagger 2 document with a host and a basePath (a synthetic server) and a body parameter (a synthetic request body)."

	^ '{"swagger":"2.0","info":{"title":"Petstore","version":"1.0"},"host":"pets.example.com","basePath":"/v1","schemes":["https"],"paths":{"/pets":{"post":{"operationId":"addPet","consumes":["application/json"],"parameters":[{"name":"body","in":"body","required":true,"schema":{"type":"object","properties":{"id":{"type":"integer"}}}}],"responses":{"201":{"description":"created"}}}}}}'
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testBlankPointerIsReported [

	| model server findings |
	model := self importedModel.
	server := (model allWithType: OPServer) anyOne.
	server canonicalPointer: '  '.
	findings := self findingsOf: model.
	self assert: (self codesOf: findings) equals: #( #pointerMissing )
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testDescriptionStatesItsLimits [

	| text |
	text := FamixOpenApiCanonicalPointersRule new description.
	self assert: (text includesSubstring: 'Limits').
	self assert: (text includesSubstring: 'family')
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testDuplicatedPointerIsReportedOnBothEntities [

	| model paths findings |
	model := self importedModel.
	paths := (model allWithType: OPPath) asArray.
	self assert: paths size equals: 2.
	paths last canonicalPointer: paths first canonicalPointer.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #pointerDuplicated #pointerDuplicated ).
	self
		assert: (findings errors collect: #entity) asIdentitySet
		equals: paths asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testImportedModelHasNoFinding [

	#( true false ) do: [ :merging |
		self
			assert:
			(self findingsOf: (self importedModelMerging: merging)) isEmpty
			description: ('merging={1}' format: { merging }) ]
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testMergedPointerEqualToAPropertyPointerIsAccepted [
	"A Property and a Schema are of different families: a property may have the pointer of a merged schema."

	| model schema property |
	model := self importedModel.
	schema := self mergedSchemaIn: model.
	property := OPProperty new
		            name: 'lost';
		            canonicalPointer: '#/lost/properties/lost';
		            yourself.
	model add: property.
	schema mergedPointers:
		(schema mergedPointers copyWith: property canonicalPointer).
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testMergedPointerEqualToAnotherSchemaPointerIsAConflict [

	| model schema other findings |
	model := self importedModel.
	schema := self mergedSchemaIn: model.
	other := self componentSchemaNamed: 'Dangling' in: model.
	schema mergedPointers:
		(schema mergedPointers copyWith: other canonicalPointer).
	findings := self findingsOf: model.
	self assert: (self codesOf: findings) equals: #( #pointerConflict ).
	self assert: findings errors first entity identicalTo: schema
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testMergedPointerEqualToTheOwnPointerIsAConflict [

	| model schema findings |
	model := self importedModel.
	schema := self mergedSchemaIn: model.
	schema mergedPointers:
		(schema mergedPointers copyWith: schema canonicalPointer).
	findings := self findingsOf: model.
	self assert: (self codesOf: findings) equals: #( #pointerConflict ).
	self assert: findings errors first entity identicalTo: schema
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testMergedPointerKeptByTwoSchemasIsAConflictOnBoth [

	| model schema other findings |
	model := self importedModel.
	schema := self mergedSchemaIn: model.
	other := self componentSchemaNamed: 'Dangling' in: model.
	other mergedPointers: { schema mergedPointers first }.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #pointerConflict #pointerConflict ).
	self
		assert: (findings errors collect: #entity) asIdentitySet
		equals: {
				schema.
				other } asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testMissingPointerIsReported [

	| model path findings |
	model := self importedModel.
	path := (model allWithType: OPPath) anyOne.
	path canonicalPointer: nil.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #pointerMissing.
	self assert: findings errors first entity identicalTo: path
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testNoClassIsPointerless [

	self assert:
		FamixOpenApiCanonicalPointersRule new pointerlessClassNames isEmpty
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testPointersSharedBetweenFamiliesAreAccepted [

	| model property |
	model := self importedModel.
	property := (model allWithType: OPProperty) anyOne.
	self assert: ((model allWithType: OPSchema) anySatisfy: [ :each |
			 each canonicalPointer = property canonicalPointer ]).
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testRuleCodeAndSeverity [

	self
		assert: FamixOpenApiCanonicalPointersRule new code
		equals: #pointerMissing.
	self
		assert: FamixOpenApiCanonicalPointersRule new codes
		equals: #( #pointerMissing #pointerDuplicated #pointerConflict ).
	self
		assert: FamixOpenApiCanonicalPointersRule new severity
		equals: #error
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self importedModel.
	(model allWithType: OPPath) anyOne canonicalPointer: nil.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testSchemaAndSubSchemaShareAFamily [

	| model sub schema findings |
	model := self importedModel.
	sub := (model allWithType: OPSubSchema) anyOne.
	schema := sub subSchemaOf.
	sub canonicalPointer: schema canonicalPointer.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #pointerDuplicated #pointerDuplicated )
]

{ #category : 'tests' }
FamixOpenApiCanonicalPointersRuleTest >> testSwagger2SyntheticEntitiesCarryAPointer [

	| model server body |
	model := FamixOpenApiImporter new importFromString:
		         self swagger2Document.
	server := (model allWithType: OPServer) anyOne.
	body := (model allWithType: OPRequestBody) anyOne.
	self assert: server canonicalPointer equals: '#/servers/0'.
	self assert: body canonicalPointer isNotEmpty.
	self assert: (self findingsOf: model) isEmpty
]
