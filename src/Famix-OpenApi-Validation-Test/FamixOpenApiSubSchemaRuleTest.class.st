"
Tests of FamixOpenApiSubSchemaRule: the sub-schemas of an imported model (inline schemas merged) are accepted; a detached sub-schema, one not listed by its larger schema and loops of subSchemaOf are reported.
"
Class {
	#name : 'FamixOpenApiSubSchemaRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiSubSchemaRule
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> subSchemaNamed: aName [

	^ OPSubSchema new
		  name: aName;
		  yourself
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testChainOfSubSchemasWithoutLoopIsAccepted [

	| model schema middle leaf |
	model := OPModel new.
	schema := OPSchema new
		          name: 'Pet';
		          yourself.
	middle := self subSchemaNamed: 'Middle'.
	leaf := self subSchemaNamed: 'Leaf'.
	middle subSchemaOf: schema.
	leaf subSchemaOf: middle.
	model addAll: {
			OPOpenApi new.
			schema.
			middle.
			leaf }.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testCycleThroughTwoSubSchemasIsReportedOnBoth [

	| model a b findings |
	model := OPModel new.
	a := self subSchemaNamed: 'A'.
	b := self subSchemaNamed: 'B'.
	a subSchemaOf: b.
	b subSchemaOf: a.
	model addAll: {
			OPOpenApi new.
			a.
			b }.
	findings := self findingsOf: model.
	self
		assert: (self codesOf: findings)
		equals: #( #subSchemaCycle #subSchemaCycle ).
	self
		assert: (findings errors collect: #entity) asIdentitySet
		equals: {
				a.
				b } asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testDescriptionStatesItsLimits [

	| text |
	text := FamixOpenApiSubSchemaRule new description.
	self assert: (text includesSubstring: 'Limits').
	self assert: (text includesSubstring: 'subset')
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testDetachedSubSchemaIsReported [

	| model sub findings |
	model := self importedModel.
	sub := (model allWithType: OPSubSchema) anyOne.
	sub subSchemaOf: nil.
	findings := self findingsOf: model.
	self assert: (self codesOf: findings) equals: #( #subSchemaDetached ).
	self assert: findings errors first entity identicalTo: sub
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testImportedModelHasSubSchemasAndNoFinding [

	self assert:
		((self importedModelMerging: true) allWithType: OPSubSchema)
			isNotEmpty.
	#( true false ) do: [ :merging |
		self
			assert:
			(self findingsOf: (self importedModelMerging: merging)) isEmpty
			description: ('merging={1}' format: { merging }) ]
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testPlainSchemasAreIgnored [

	| model |
	model := OPModel new.
	model addAll: {
			OPOpenApi new.
			OPSchema new }.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testRuleCodeAndSeverity [

	self
		assert: FamixOpenApiSubSchemaRule new code
		equals: #subSchemaDetached.
	self
		assert: FamixOpenApiSubSchemaRule new codes
		equals: #( #subSchemaDetached #subSchemaCycle ).
	self assert: FamixOpenApiSubSchemaRule new severity equals: #error
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self importedModel.
	(model allWithType: OPSubSchema) anyOne subSchemaOf: nil.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testSubSchemaLeadingToACycleIsNotOnTheCycle [

	| model a b c findings |
	model := OPModel new.
	a := self subSchemaNamed: 'A'.
	b := self subSchemaNamed: 'B'.
	c := self subSchemaNamed: 'C'.
	b subSchemaOf: c.
	c subSchemaOf: b.
	a subSchemaOf: b.
	model addAll: {
			OPOpenApi new.
			a.
			b.
			c }.
	findings := self findingsOf: model.
	self
		assert: (findings errors collect: #entity) asIdentitySet
		equals: {
				b.
				c } asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testSubSchemaNotListedByItsLargerSchemaIsReported [

	| model sub findings |
	model := self importedModel.
	sub := (model allWithType: OPSubSchema) anyOne.
	sub subSchemaOf subSchemas unsafeRemove: sub.
	findings := self findingsOf: model.
	self assert: (self codesOf: findings) equals: #( #subSchemaDetached ).
	self assert: findings errors first entity identicalTo: sub
]

{ #category : 'tests' }
FamixOpenApiSubSchemaRuleTest >> testSubSchemaOfItselfIsACycle [

	| model sub findings |
	model := OPModel new.
	sub := self subSchemaNamed: 'Loop'.
	sub subSchemaOf: sub.
	model addAll: {
			OPOpenApi new.
			sub }.
	findings := self findingsOf: model.
	self assert: (self codesOf: findings) equals: #( #subSchemaCycle ).
	self assert: findings errors first entity identicalTo: sub
]
