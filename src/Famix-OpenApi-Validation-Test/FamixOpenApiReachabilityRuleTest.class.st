"
Tests of FamixOpenApiReachabilityRule: imported and hand-built coherent models have no unreachable entity; a Path detached from the root together with its operations and a schema attached to a detached parent are reported, although the one-hop FamixOpenApiContainmentRule does not see them; back-pointers do not count as reachability.
"
Class {
	#name : 'FamixOpenApiReachabilityRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> entitiesOf: aFindings [

	^ (aFindings collect: #entity) asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> findingsOf: aModel [

	^ self validate: aModel with: FamixOpenApiReachabilityRule
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testBackPointerAloneDoesNotMakeAnEntityReachable [

	| model schema parameter findings |
	model := OPModel new.
	schema := OPSchema new
		          name: 'Limit';
		          yourself.
	parameter := OPParameter new
		             name: 'limit';
		             yourself.
	parameter schema: schema.
	model addAll: {
			OPOpenApi new.
			schema.
			parameter }.
	self assert: schema usedByParameters size equals: 1.
	findings := self findingsOf: model.
	self assert: (self entitiesOf: findings) equals: {
			schema.
			parameter } asIdentitySet.
	self
		assert: (self entitiesOf:
				 (self validate: model with: FamixOpenApiContainmentRule))
		equals: { parameter } asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testCoherentHandBuiltModelHasNoFinding [

	self assert: (self findingsOf: self coherentModel) isEmpty
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testDescriptionStatesItsLimitsAndTheBackPointers [

	| text |
	text := FamixOpenApiReachabilityRule new description.
	self assert: (text includesSubstring: 'Limits').
	self assert: (text includesSubstring: 'usedBy')
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testDetachedSubtreeIsNotSeenByTheContainmentRule [

	| model path operation orphans |
	model := self importedModel.
	path := self detachPetPathFrom: model.
	operation := path operations anyOne.
	orphans := self entitiesOf:
		           (self validate: model with: FamixOpenApiContainmentRule).
	self assert: (orphans includes: path).
	self deny: (orphans includes: operation)
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testEveryRootReachesItsOwnEntities [

	| model first second info |
	model := OPModel new.
	first := OPOpenApi new.
	second := OPOpenApi new.
	info := OPInfo new
		        name: 'info';
		        yourself.
	second info: info.
	model addAll: {
			first.
			second.
			info }.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testForwardPropertiesExcludeContainersAndBackPointers [

	| names |
	names := (FamixOpenApiReachabilityRule new forwardPropertiesOf:
		          OPSchema) collect: #name.
	self assert: (names includes: #items).
	self assert: (names includes: #allOf).
	self assert: (names includes: #properties).
	self deny: (names includes: #components).
	self deny: (names includes: #usedByParameters).
	self deny: (names includes: #usedAsItemsBy)
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testImportedModelHasNoFinding [

	#( true false ) do: [ :merging |
		self
			assert:
			(self findingsOf: (self importedModelMerging: merging)) isEmpty
			description: ('merging={1}' format: { merging }) ]
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testRuleCodeAndSeverity [

	self
		assert: FamixOpenApiReachabilityRule new code
		equals: #unreachableEntity.
	self
		assert: FamixOpenApiReachabilityRule new severity
		equals: #warning
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testRuleDoesNotModifyTheModel [

	| model before |
	model := self importedModel.
	self detachPetPathFrom: model.
	before := self snapshotOf: model.
	self findingsOf: model.
	self assert: (self snapshotOf: model) equals: before
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testSchemaAttachedToADetachedParentIsReported [

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
	self assert: (self entitiesOf: findings) equals: {
			parent.
			child } asIdentitySet
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testSharedParameterWithoutComponentsIsReachedThroughItsOperation [

	| model parameter operation path root |
	model := OPModel new.
	root := OPOpenApi new.
	path := OPPath new
		        name: '/p';
		        yourself.
	operation := OPOperation new
		             name: 'op';
		             yourself.
	parameter := OPParameter new
		             name: 'limit';
		             yourself.
	root addPath: path.
	path addOperation: operation.
	operation addParameter: parameter.
	model addAll: {
			root.
			path.
			operation.
			parameter }.
	self assert: (self findingsOf: model) isEmpty
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testSubtreeDetachedFromTheRootIsReported [
	"The V4 tester case the one-hop containment rule misses: a path detached from the root together with its operations."

	| model path operation findings reported |
	model := self importedModel.
	path := self detachPetPathFrom: model.
	operation := path operations anyOne.
	findings := self findingsOf: model.
	reported := self entitiesOf: findings.
	self assert: (reported includes: path).
	self assert: (reported includes: operation).
	self assert: (findings warnings allSatisfy: [ :each |
			 each code = #unreachableEntity ]).
	self assert: findings errors isEmpty
]

{ #category : 'tests' }
FamixOpenApiReachabilityRuleTest >> testWithoutRootNothingIsChecked [

	| model |
	model := OPModel new.
	model add: OPSchema new.
	self assert: (self findingsOf: model) isEmpty
]
