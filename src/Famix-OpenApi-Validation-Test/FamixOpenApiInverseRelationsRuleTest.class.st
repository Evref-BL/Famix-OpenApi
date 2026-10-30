"
Tests of FamixOpenApiInverseRelationsRule: no finding on hand-built and imported coherent models, one finding for each kind of relation (1-1, 1-n, n-n) whose opposite side is broken by writing a slot directly, in both directions.
"
Class {
	#name : 'FamixOpenApiInverseRelationsRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiInverseRelationsRule
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testBackLinkWithoutForwardLinkIsReportedOnTheTarget [

	| model pet stranger findings |
	model := self importedModel.
	pet := self componentSchemaNamed: 'Pet' in: model.
	stranger := OPSchema new
		            name: 'Stranger';
		            yourself.
	pet usedAsItemsBy unsafeAdd: stranger.
	model add: stranger.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first entity identicalTo: pet
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testBrokenManyToManyIsReported [

	| model pet newPet findings |
	model := self importedModel.
	pet := self componentSchemaNamed: 'Pet' in: model.
	newPet := self componentSchemaNamed: 'NewPet' in: model.
	self assert: (newPet allOf includes: pet).
	pet usedAsAllOfBy unsafeRemove: newPet.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first entity identicalTo: newPet
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testBrokenManyToOneSlotWrittenDirectlyIsReported [

	| model pet findings |
	model := self importedModel.
	pet := self componentSchemaNamed: 'Pet' in: model.
	self writeSlot: #components of: pet value: nil.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self
		assert: findings errors first entity
		identicalTo: (self rootOf: model) components
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testBrokenOneToManyIsReportedOnTheHolder [

	| model pet holder findings |
	model := self importedModel.
	pet := self componentSchemaNamed: 'Pet' in: model.
	holder := pet usedAsItemsBy anyOne.
	pet usedAsItemsBy unsafeRemove: holder.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #inverseMismatch.
	self assert: findings errors first entity identicalTo: holder
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testBrokenOneToOneIsReported [

	| model root info findings |
	model := self importedModel.
	root := self rootOf: model.
	info := root info.
	self writeSlot: #openApi of: info value: nil.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first entity identicalTo: root
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testCoherentHandBuiltModelHasNoFinding [

	self assert: (self findingsOf: self coherentModel) isEmpty
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testDescriptionStatesItsLimits [

	| text |
	text := FamixOpenApiInverseRelationsRule new description.
	self assert: (text includesSubstring: 'opposite').
	self assert: (text includesSubstring: 'Limits')
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testImportedModelHasNoFinding [

	#( true false ) do: [ :merging |
		self
			assert:
			(self findingsOf: (self importedModelMerging: merging)) isEmpty
			description: ('merging={1}' format: { merging }) ]
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testPropertiesAreDerivedFromTheMetamodel [

	| names |
	names := (FamixOpenApiInverseRelationsRule new propertiesOf: OPSchema)
		         collect: #name.
	self assert: (names includes: #items).
	self assert: (names includes: #allOf).
	self assert: (names includes: #usedByParameters).
	self assert: (names includes: #components).
	self deny: (names includes: #name).
	self deny: (names includes: #ref)
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testRuleCodeAndSeverity [

	self
		assert: FamixOpenApiInverseRelationsRule new code
		equals: #inverseMismatch.
	self
		assert: FamixOpenApiInverseRelationsRule new severity
		equals: #error
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testRuleDoesNotModifyTheModel [

	| model pet before |
	model := self importedModel.
	pet := self componentSchemaNamed: 'Pet' in: model.
	pet usedAsItemsBy unsafeRemove: pet usedAsItemsBy anyOne.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiInverseRelationsRuleTest >> testSlotWrittenWithAnotherOwnerIsReported [

	| model info other findings |
	model := self importedModel.
	info := (self rootOf: model) info.
	other := OPOpenApi new
		         name: 'Other';
		         yourself.
	model add: other.
	self writeSlot: #openApi of: info value: other.
	findings := self findingsOf: model.
	self assert: findings size equals: 2
]
