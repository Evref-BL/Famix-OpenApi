"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiNamedEntitiesRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiNamedEntitiesRule
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testBlankNameIsAnError [

	| model findings |
	model := self coherentModel.
	(self entityOf: OPOperation in: model) name: '   '.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first entity class equals: OPOperation
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testCoherentModelHasNoFinding [

	self assert: (self findingsOf: self coherentModel) isEmpty
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testDescriptionCodeAndSeverity [

	self
		assert: FamixOpenApiNamedEntitiesRule new code
		equals: #unnamedEntity.
	self
		assert: FamixOpenApiNamedEntitiesRule new severity
		equals: #error
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testEveryUnnamedEntityIsReported [

	| model |
	model := self coherentModel.
	model allModelEntities do: [ :each | each name: nil ].
	self
		assert: (self findingsOf: model) size
		equals:
			(model allModelEntities reject: [ :each | each isKindOf: OPContact ])
				size
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testNamelessClassesAreTheOptionalOnes [

	self
		assert: FamixOpenApiNamedEntitiesRule namelessClassNames asSet
		equals: #( #OPContact #OPLicense #OPTag #OPXmlElement ) asSet
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testNaturallyNamelessClassesAreAccepted [

	| model |
	model := OPModel new.
	model addAll: {
			OPContact new.
			OPLicense new.
			OPTag new.
			OPXmlElement new }.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testNilNameIsAnError [

	| model schema findings |
	model := self coherentModel.
	schema := self entityOf: OPSchema in: model.
	schema name: nil.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings errors first code equals: #unnamedEntity.
	self assert: findings errors first entity identicalTo: schema
]

{ #category : 'tests' }
FamixOpenApiNamedEntitiesRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self coherentModel.
	(self entityOf: OPSchema in: model) name: nil.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]
