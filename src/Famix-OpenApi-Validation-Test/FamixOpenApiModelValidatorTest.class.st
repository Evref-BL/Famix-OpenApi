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
FamixOpenApiModelValidatorTest >> addBlankReferenceTo: aModel [

	| reference |
	reference := OPReference new
		             target: ' ';
		             canonicalPointer: '#/blank';
		             yourself.
	(self rootOf: aModel) addUnresolvedReference: reference.
	aModel add: reference
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> addOrphanSchemaTo: aModel [

	aModel add: (OPSchema new
			 name: 'Lost';
			 canonicalPointer: '#/lost';
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> breakItemsInverseIn: aModel [

	| pet |
	pet := self componentSchemaNamed: 'Pet' in: aModel.
	pet usedAsItemsBy unsafeRemove: pet usedAsItemsBy anyOne
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> duplicatePathPointerIn: aModel [

	| paths |
	paths := (aModel allWithType: OPPath) asArray.
	paths last canonicalPointer: paths first canonicalPointer
]

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> mutationScenarios [
	"Answer an Array of associations: the code a mutation of the imported model must produce -> a block that applies it to the model. The first cases are those of the V4 validator (names, orphan, roots), the others are detected by the V5 rules (the detached subtree was undetected before)."

	^ {
		  (#unnamedEntity
		   -> [ :model |
		   (self componentSchemaNamed: 'Pet' in: model) name: nil ]).
		  (#orphanEntity -> [ :model | self addOrphanSchemaTo: model ]).
		  (#rootCount -> [ :model | model add: OPOpenApi new ]).
		  (#inverseMismatch -> [ :model | self breakItemsInverseIn: model ]).
		  (#referenceMalformed
		   -> [ :model | self addBlankReferenceTo: model ]).
		  (#pointerMissing
		   -> [ :model |
		   (model allWithType: OPPath) anyOne canonicalPointer: nil ]).
		  (#pointerDuplicated
		   -> [ :model | self duplicatePathPointerIn: model ]).
		  (#subSchemaDetached
		   -> [ :model |
		   (model allWithType: OPSubSchema) anyOne subSchemaOf: nil ]).
		  (#unreachableEntity -> [ :model | self detachPetPathFrom: model ]) }
]

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
FamixOpenApiModelValidatorTest >> testDetachedSubtreeIsReportedByReachabilityBeyondTheOrphanPath [

	| model findings |
	model := self importedModel.
	self detachPetPathFrom: model.
	findings := FamixOpenApiModelValidator new validate: model.
	self assert: findings errors isEmpty.
	self
		assert: findings codes
		equals: #( #orphanEntity #unreachableEntity ) asSet.
	self assert: (findings countOf: #orphanEntity) equals: 1.
	self assert: (findings countOf: #unreachableEntity) > 1
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
FamixOpenApiModelValidatorTest >> testEveryMutationScenarioIsDetectedByItsRule [

	self mutationScenarios do: [ :each |
		| model findings |
		model := self importedModel.
		each value value: model.
		findings := FamixOpenApiModelValidator new validate: model.
		self
			assert: (findings countOf: each key) >= 1
			description: ('Undetected mutation: {1}' format: { each key }).
		self deny: (findings countOf: #ruleFailed) > 0 ]
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
FamixOpenApiModelValidatorTest >> testMutationOnAnImportedModelIsAlsoDetectedWithoutMerging [

	| model findings |
	model := self importedModelMerging: false.
	self detachPetPathFrom: model.
	findings := FamixOpenApiModelValidator new validate: model.
	self assert: (findings countOf: #unreachableEntity) >= 2
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

{ #category : 'tests' }
FamixOpenApiModelValidatorTest >> testValidationWithAllRulesDoesNotModifyAnImportedModel [

	#( true false ) do: [ :merging |
		| model before |
		model := self importedModelMerging: merging.
		self detachPetPathFrom: model.
		before := self snapshotOf: model.
		FamixOpenApiModelValidator new validate: model.
		self assert: (self snapshotOf: model) equals: before ]
]
