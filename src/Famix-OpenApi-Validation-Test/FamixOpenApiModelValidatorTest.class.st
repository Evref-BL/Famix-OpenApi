"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiModelValidatorTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testAllRulesRunByDefault [

	| model findings |
	model := self coherentModel.
	(self entityOf: OPSchema in: model) name: nil.
	model add: OPOpenApi new.
	findings := FamixOpenApiModelValidator new validate: model.
	self assert: (findings countOf: #unnamedEntity) >= 1.
	self assert: (findings countOf: #rootCount) equals: 2
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testCoherentModelHasNoFinding [

	self assert:
		(FamixOpenApiModelValidator new validate: self coherentModel)
			isEmpty
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testEmptyModelHasOnlyTheRootCountError [

	| findings |
	findings := FamixOpenApiModelValidator new validate: OPModel new.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #rootCount
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testEmptyRuleSubsetAnswersNoFinding [

	self assert:
		(FamixOpenApiModelValidator new validate: OPModel new rules: #(  ))
			isEmpty
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testFailingRuleIsReportedAndDoesNotAbortTheRun [

	| failing findings |
	failing := self
		           installTemporaryRuleNamed: #FamixOpenApiTempFailingRule
		           source: 'checkModel: aModel into: aFindings
	self error: ''boom'''.
	findings := FamixOpenApiModelValidator new
		            validate: OPModel new
		            rules: {
				            failing.
				            FamixOpenApiOneRootRule }.
	self assert: (findings countOf: #ruleFailed) equals: 1.
	self assert: (findings countOf: #rootCount) equals: 1.
	self assert: findings errors first severity equals: #error.
	self assert: (findings errors first message includesSubstring:
			 'FamixOpenApiTempFailingRule').
	self assert:
		(findings errors first message includesSubstring: 'boom')
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testFailingRuleRegisteredInTheRegistryIsReportedByValidate [

	| findings |
	self
		installTemporaryRuleNamed: #FamixOpenApiTempRegisteredFailingRule
		source: 'checkModel: aModel into: aFindings
	self error: ''registered boom'''.
	findings := FamixOpenApiModelValidator new validate:
		            self coherentModel.
	self assert: (findings countOf: #ruleFailed) equals: 1.
	self assert:
		((findings withCode: #ruleFailed) first message includesSubstring:
			 'FamixOpenApiTempRegisteredFailingRule')
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testSubsetRunsOnlyTheGivenRules [

	| model findings |
	model := self coherentModel.
	(self entityOf: OPSchema in: model) name: nil.
	findings := FamixOpenApiModelValidator new
		            validate: model
		            rules: { FamixOpenApiOneRootRule }.
	self assert: findings isEmpty.
	findings := FamixOpenApiModelValidator new
		            validate: model
		            rules: { FamixOpenApiNamedEntitiesRule }.
	self assert: findings codes equals: #( #unnamedEntity ) asSet
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testValidationDoesNotModifyTheModel [

	| model before |
	model := self coherentModel.
	(self entityOf: OPSchema in: model) name: nil.
	model add: OPOpenApi new.
	before := self snapshotOf: model.
	FamixOpenApiModelValidator new validate: model.
	self assert: (self snapshotOf: model) equals: before
]
