"
Tests of FamixOpenApiExpectedEntity, the value object of the derivations of the entities without node, and of the small API that carries its rule to the gaps and to the report (FamixOpenApiGap>>ruleName, FamixOpenApiGapReport>>recordDerived:).
"
Class {
	#name : 'FamixOpenApiExpectedEntityTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiExpectedEntityTest >> testAGapKnowsTheRuleThatExpectsItsEntity [

	| gap |
	gap := FamixOpenApiGap
		       kind: #missingEntity
		       pointer: '#/a'
		       specObject: nil.
	self assert: gap ruleName isNil.
	gap ruleName: #scalarExample.
	self assert: gap ruleName equals: #scalarExample
]

{ #category : 'tests' }
FamixOpenApiExpectedEntityTest >> testAnExpectedEntityKnowsItsPointerClassRuleAndOrigin [

	| expected |
	expected := FamixOpenApiExpectedEntity
		            pointer: '#/a/b'
		            className: 'OPSchema'
		            rule: #swagger2ParameterSchema
		            origin: '#/a'.
	self assert: expected pointer equals: '#/a/b'.
	self assert: expected targetClassName equals: 'OPSchema'.
	self assert: expected ruleName equals: #swagger2ParameterSchema.
	self assert: expected originPointer equals: '#/a'.
	self assert: expected family equals: OPSchema
]

{ #category : 'tests' }
FamixOpenApiExpectedEntityTest >> testAnExpectedEntityPrintsItsClassPointerAndRule [

	self
		assert: (FamixOpenApiExpectedEntity
				 pointer: '#/a'
				 className: 'OPComponents'
				 rule: #swagger2Components
				 origin: '#') printString
		equals: 'OPComponents at #/a (swagger2Components)'
]

{ #category : 'tests' }
FamixOpenApiExpectedEntityTest >> testTheFamilyIsTheClassDirectlyBelowTheEntity [

	self
		assert: (FamixOpenApiExpectedEntity
				 pointer: '#/a'
				 className: 'OPMediaType'
				 rule: #swagger2MediaType
				 origin: '#') family
		equals: OPMediaType
]

{ #category : 'tests' }
FamixOpenApiExpectedEntityTest >> testTheReportCountsTheDerivedEntitiesByRule [

	| report |
	report := FamixOpenApiGapReport new.
	report
		recordDerived: #securityScope;
		recordDerived: #scalarExample;
		recordDerived: #securityScope.
	self
		assert: report derivedCountsByRule
		equals: (OrderedDictionary new
				 at: #scalarExample put: 1;
				 at: #securityScope put: 2;
				 yourself).
	self assert: FamixOpenApiGapReport new derivedCountsByRule isEmpty
]
