"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiOneRootRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiOneRootRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiOneRootRule
]

{ #category : 'tests' }
FamixOpenApiOneRootRuleTest >> testNoRootIsAnError [

	| findings |
	findings := self findingsOf: OPModel new.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #rootCount.
	self assert: findings errors first entity isNil.
	self assert:
		(findings errors first message includesSubstring: 'no OPOpenApi')
]

{ #category : 'tests' }
FamixOpenApiOneRootRuleTest >> testOneRootIsCoherent [

	self assert: (self findingsOf: self coherentModel) isEmpty
]

{ #category : 'tests' }
FamixOpenApiOneRootRuleTest >> testRuleCodeAndSeverity [

	self assert: FamixOpenApiOneRootRule new code equals: #rootCount.
	self assert: FamixOpenApiOneRootRule new severity equals: #error
]

{ #category : 'tests' }
FamixOpenApiOneRootRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self coherentModel.
	model add: OPOpenApi new.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiOneRootRuleTest >> testSeveralRootsAreReportedOnePerRoot [

	| model findings |
	model := self coherentModel.
	model add: OPOpenApi new.
	findings := self findingsOf: model.
	self assert: findings size equals: 2.
	self
		assert: (findings collect: [ :each | each entity class ]) asSet
		equals: { OPOpenApi } asSet.
	self assert:
		(findings errors first message includesSubstring: '2 OPOpenApi')
]
