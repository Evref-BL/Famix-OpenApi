"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiContainmentRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiContainmentRule
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> orphanedClassesIn: aModel [

	^ ((self findingsOf: aModel) collect: [ :each | each entity class ])
		  asArray
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testAnchorPropertiesAreDerivedFromTheMetamodel [

	| names |
	names := (FamixOpenApiContainmentRule new anchorPropertiesOf:
		          OPSchema) collect: #name.
	self assert: (names includes: #components).
	self assert: (names includes: #usedByParameters).
	self assert: (names includes: #usedAsItemsBy).
	self assert: (names includes: #subSchemaOf) not.
	self deny: (names includes: #items).
	self deny: (names includes: #properties).
	self deny: (names includes: #name)
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testChildSchemaOfAnOrphanSchemaIsAnchoredButNotTheParent [

	| model parent child findings |
	model := OPModel new.
	parent := OPSchema new
		          name: 'Parent';
		          yourself.
	child := OPSchema new
		         name: 'Child';
		         yourself.
	parent items: child.
	model addAll: {
			OPOpenApi new.
			parent.
			child }.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings warnings first entity identicalTo: parent
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testCoherentModelHasNoFinding [

	self assert: (self findingsOf: self coherentModel) isEmpty
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testOrphanSchemaIsAWarning [

	| model orphan findings |
	model := self coherentModel.
	orphan := OPSchema new
		          name: 'Lost';
		          yourself.
	model add: orphan.
	findings := self findingsOf: model.
	self assert: findings size equals: 1.
	self assert: findings warnings first code equals: #orphanEntity.
	self assert: findings warnings first entity identicalTo: orphan.
	self assert: findings errors isEmpty
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testOrphansOfSeveralClassesAreAllReported [

	| model |
	model := OPModel new.
	model addAll: {
			OPOpenApi new.
			OPResponse new.
			OPOperation new.
			OPPath new.
			OPTag new.
			OPServer new }.
	self assert: (self orphanedClassesIn: model) asSet equals: {
			OPResponse.
			OPOperation.
			OPPath.
			OPTag.
			OPServer } asSet
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testPropertyIsAnchoredByItsSchema [

	| model schema property |
	model := OPModel new.
	schema := OPSchema new
		          name: 'Pet';
		          yourself.
	property := OPProperty new
		            name: 'id';
		            yourself.
	schema addProperty: property.
	model addAll: {
			OPOpenApi new.
			schema.
			property }.
	self assert: (self orphanedClassesIn: model) equals: { OPSchema }
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testRootAloneIsNotAnOrphan [

	| model |
	model := OPModel new.
	model add: OPOpenApi new.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testRuleCodeAndSeverity [

	self
		assert: FamixOpenApiContainmentRule new code
		equals: #orphanEntity.
	self
		assert: FamixOpenApiContainmentRule new severity
		equals: #warning
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self coherentModel.
	model add: (OPSchema new
			 name: 'Lost';
			 yourself).
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testSchemaReferencedByAParameterIsAnchored [

	| model schema |
	model := self coherentModel.
	schema := OPSchema new
		          name: 'Limit';
		          yourself.
	(self entityOf: OPParameter in: model) schema: schema.
	model add: schema.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testSharedParameterReferencedWithoutComponentsIsAnchored [

	| model parameter operation |
	model := OPModel new.
	parameter := OPParameter new
		             name: 'limit';
		             yourself.
	operation := OPOperation new
		             name: 'op';
		             yourself.
	operation addParameter: parameter.
	model addAll: {
			OPOpenApi new.
			parameter.
			operation }.
	self assert: (self orphanedClassesIn: model) equals: { OPOperation }
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testSubSchemaAnchorsIncludeSubSchemaOf [

	| names |
	names := (FamixOpenApiContainmentRule new anchorPropertiesOf:
		          OPSubSchema) collect: #name.
	self assert: (names includes: #subSchemaOf).
	self deny: (names includes: #subSchemas)
]

{ #category : 'tests' }
FamixOpenApiContainmentRuleTest >> testSubSchemaIsAnchoredByItsLargerSchema [

	| model larger sub |
	model := OPModel new.
	larger := OPSchema new
		          name: 'Pet';
		          yourself.
	sub := OPSubSchema new
		       name: 'PetSummary';
		       yourself.
	sub subSchemaOf: larger.
	model addAll: {
			OPOpenApi new.
			larger.
			sub }.
	self assert: (self orphanedClassesIn: model) equals: { OPSchema }
]
