"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiValidationRuleTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testAbstractRuleHasNoDefaultCodeDescriptionOrSeverity [

	self should: [ FamixOpenApiValidationRule new code ] raise: Error.
	self
		should: [ FamixOpenApiValidationRule new description ]
		raise: Error.
	self should: [ FamixOpenApiValidationRule new severity ] raise: Error
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testAbstractRuleIsExcluded [

	self assert: FamixOpenApiValidationRule isAbstract.
	self deny: FamixOpenApiOneRootRule isAbstract.
	self deny:
		(FamixOpenApiValidationRule allRules anySatisfy: [ :each |
			 each class == FamixOpenApiValidationRule ])
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testAllRulesAnswersOneInstanceOfEachConcreteRule [

	| classes |
	classes := FamixOpenApiValidationRule allRules collect: #class.
	self assert: classes size equals: 8.
	self assert: classes asSet size equals: classes size.
	self assert: classes asArray equals: {
			FamixOpenApiCanonicalPointersRule.
			FamixOpenApiContainmentRule.
			FamixOpenApiInverseRelationsRule.
			FamixOpenApiNamedEntitiesRule.
			FamixOpenApiOneRootRule.
			FamixOpenApiReachabilityRule.
			FamixOpenApiReferencesRule.
			FamixOpenApiSubSchemaRule }
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testCodesDefaultToTheCode [

	self
		assert: FamixOpenApiOneRootRule new codes
		equals: { FamixOpenApiOneRootRule new code }
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testEveryCodeOfEveryRuleIsDistinct [

	| codes |
	codes := FamixOpenApiValidationRule allRules flatCollect: #codes.
	self assert: codes asSet size equals: codes size.
	FamixOpenApiValidationRule allRules do: [ :each |
		self assert: (each codes includes: each code) ]
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testEveryRuleDescribesItself [

	FamixOpenApiValidationRule allRules do: [ :each |
		self assert: each code isSymbol.
		self deny: each description isEmpty.
		self assert: (#( #error #warning #info ) includes: each severity) ]
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testOrderIsDeterministicAndSortedByClassName [

	| names |
	names := FamixOpenApiValidationRule allRules collect: [ :each |
		         each class name ].
	self assert: names equals: names sorted.
	self
		assert: (FamixOpenApiValidationRule allRules collect: #class)
		equals: (FamixOpenApiValidationRule allRules collect: #class)
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testPerEntityHookDoesNothingByDefault [

	| findings |
	findings := FamixOpenApiFindings new.
	FamixOpenApiValidationRule new check: OPSchema new into: findings.
	self assert: findings isEmpty
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testRuleCodesAreDistinct [

	| codes |
	codes := FamixOpenApiValidationRule allRules collect: #code.
	self assert: codes asSet size equals: codes size
]

{ #category : 'tests' }
FamixOpenApiValidationRuleTest >> testTemporaryRuleIsRegisteredWhileItExists [

	| class |
	class := self
		         installTemporaryRuleNamed: #FamixOpenApiTempRegisteredRule
		         source: 'code ^ #temp'.
	self assert:
		((FamixOpenApiValidationRule allRules collect: #class) includes:
			 class).
	self
		assert: (FamixOpenApiValidationRule allRules collect: [ :each |
				 each class name ])
		equals: (FamixOpenApiValidationRule allRules collect: [ :each |
				 each class name ]) sorted
]
