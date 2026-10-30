"
Tests of FamixOpenApiReferencesRule: the references of a really imported model (resolved, missing, aliased) are accepted; an unresolved Reference without target or without owner, a malformed ref and a schema with a ref that is represented nowhere are reported.
"
Class {
	#name : 'FamixOpenApiReferencesRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiReferencesRule
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testBlankRefIsReported [

	| model schema findings |
	model := self importedModel.
	schema := self componentSchemaNamed: 'Pet' in: model.
	schema ref: ''.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #referenceMalformed ).
	self assert: findings errors first entity identicalTo: schema
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testCoherentHandBuiltModelHasNoFinding [

	self assert: (self findingsOf: self coherentModel) isEmpty
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testDescriptionStatesItsLimits [

	| text |
	text := FamixOpenApiReferencesRule new description.
	self assert: (text includesSubstring: 'Limits').
	self assert: (text includesSubstring: 'existing component')
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testImportedModelHasNoFinding [

	#( true false ) do: [ :merging |
		self
			assert:
			(self findingsOf: (self importedModelMerging: merging)) isEmpty
			description: ('merging={1}' format: { merging }) ]
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testImportedModelHoldsTheKindsOfReferencesTheRuleChecks [

	| model |
	model := self importedModel.
	self assert: (model allWithType: OPReference) size equals: 3.
	self assert:
		((model allWithType: OPSchema) count: [ :each | each ref isNotNil ])
		>= 2.
	self assert: ((model allWithType: OPResponse) anySatisfy: [ :each |
			 each ref isNotNil ])
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testRefThatIsNotAStringIsReported [

	| model response findings |
	model := self importedModel.
	response := (model allWithType: OPResponse) anyOne.
	response ref: 42.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #referenceMalformed ).
	self assert: findings errors first entity identicalTo: response
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testReferenceNotOwnedByTheOpenApiIsReported [

	| model reference findings |
	model := self importedModel.
	reference := OPReference new
		             target: '#/components/schemas/Lost';
		             yourself.
	model add: reference.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #referenceMalformed.
	self assert: findings errors first entity identicalTo: reference
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testReferenceWithBlankTargetIsReported [

	| model reference findings |
	model := self importedModel.
	reference := self unresolvedReferenceTo: '   ' in: model.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #referenceMalformed.
	self assert: findings errors first entity identicalTo: reference
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testReferenceWithoutTargetIsReported [

	| model reference findings |
	model := self importedModel.
	reference := self unresolvedReferenceTo: nil in: model.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first entity identicalTo: reference
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testRuleCodeAndSeverity [

	self
		assert: FamixOpenApiReferencesRule new code
		equals: #referenceMalformed.
	self
		assert: FamixOpenApiReferencesRule new codes
		equals: #( #referenceMalformed #referenceNotRepresented ).
	self assert: FamixOpenApiReferencesRule new severity equals: #error
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self importedModel.
	self unresolvedReferenceTo: ' ' in: model.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testSchemaWithRefLinkedToItsTargetIsAccepted [

	| model alias pet |
	model := self importedModel.
	alias := self componentSchemaNamed: 'Alias' in: model.
	pet := self componentSchemaNamed: 'Pet' in: model.
	self assert: alias ref equals: '#/components/schemas/Pet'.
	self assert: (alias allOf includes: pet).
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testSchemaWithRefRepresentedByAnUnresolvedReferenceIsAccepted [

	| model dangling |
	model := self importedModel.
	dangling := self componentSchemaNamed: 'Dangling' in: model.
	self assert: dangling allOf isEmpty.
	self assert:
		((self rootOf: model) unresolvedReferences anySatisfy: [ :each |
			 each target = dangling ref ]).
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testSchemaWithRefRepresentedNowhereIsReported [

	| model schema findings |
	model := self importedModel.
	schema := (self componentSchemaNamed: 'Pet' in: model)
		          ref: '#/components/schemas/Other';
		          yourself.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #referenceNotRepresented ).
	self assert: findings errors first entity identicalTo: schema
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> testUnresolvedReferenceNoLongerMatchingItsSchemaIsReported [

	| model dangling reference findings |
	model := self importedModel.
	dangling := self componentSchemaNamed: 'Dangling' in: model.
	reference := (self rootOf: model) unresolvedReferences detect: [
		             :each | each target = dangling ref ].
	reference target: '#/components/schemas/Renamed'.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #referenceNotRepresented ).
	self assert: findings errors first entity identicalTo: dangling
]

{ #category : 'tests' }
FamixOpenApiReferencesRuleTest >> unresolvedReferenceTo: aTarget in: aModel [
	"Answer a new OPReference of the target text aTarget, owned by the root of aModel."

	| reference |
	reference := OPReference new
		             target: aTarget;
		             yourself.
	(self rootOf: aModel) addUnresolvedReference: reference.
	aModel add: reference.
	^ reference
]
