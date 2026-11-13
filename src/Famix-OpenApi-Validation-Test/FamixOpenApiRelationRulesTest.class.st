"
The table of the relation check (FamixOpenApiRelationRules) as data: every rule names a class that has the relation, a class for the targets, a known derivation and valid versions; every relation of the conformance report and every row that V8 and V9 deferred as relation or implicit structure is carried by a rule (or has a reason); the keys of the coverage are unique.
"
Class {
	#name : 'FamixOpenApiRelationRulesTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> conformanceRows [

	^ FamixOpenApiMetamodelConformance check rows
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> rules [

	^ FamixOpenApiRelationRules rules
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testAFieldCarriedUnderAnotherSpecObjectIsFound [
	"Items.items and Parameter.items are the items of the schema that Swagger 2 makes of a typed parameter"

	#( 'Items' 'Parameter' ) do: [ :spec |
		| row |
		row := self conformanceRows detect: [ :each |
			       each version = #v2 and: [
				       each specObject = spec and: [ each fieldName = 'items' ] ] ].
		self assert: (FamixOpenApiRelationRules isComparedRow: row) ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testEveryRelationRowOfTheConformanceIsCarriedByARule [

	self conformanceRows
		select: [ :each | each status = #modelledRelation ]
		thenDo: [ :each |
			self
				assert: (FamixOpenApiRelationRules isComparedRow: each)
				description: each printString ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testEveryRowThatTheValueCheckSentToTheRelationCheckIsCarriedOrHasAReason [

	| sent |
	sent := self conformanceRows select: [ :each |
		        (FamixOpenApiValueRules reasonNotComparedFor: each)
			        ifNil: [ false ]
			        ifNotNil: [ :reason |
			        FamixOpenApiRelationRules isRelationReason: reason ] ].
	self assert: sent size > 100.
	sent do: [ :each |
		| reason |
		reason := FamixOpenApiRelationRules reasonNotComparedFor: each.
		self
			assert: (reason isNil or: [ reason ~= 'no rule yet' ])
			description: each printString ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testEveryRuleHasAKnownDerivationValidVersionsAndCompareMode [

	self rules do: [ :each |
		self
			assert:
				(FamixOpenApiRelationDerivation dataClassNames includesKey:
					 each derivationName)
			description: each printString.
		self
			assert: each derivation class name
			equals:
			(FamixOpenApiRelationDerivation dataClassNames at:
				 each derivationName).
		self assert: (each versions allSatisfy: [ :version |
				 #( #v30 #v31 #v2 ) includes: version ]).
		self assert: each versions isNotEmpty.
		self assert: (#( #ordered #set #count ) includes: each compareMode) ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testEveryRuleNamesAClassThatHasTheRelation [

	self rules do: [ :each |
		self
			assert: (each ownerClass canUnderstand: each selector)
			description: each printString ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testEveryRuleNamesTheClassOfItsTargets [

	self rules do: [ :each |
		self
			assert:
			(Smalltalk globals includesKey: each targetClassName asSymbol)
			description: each printString.
		self assert: each targetFamily superclass equals: OPEntity ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testRulesForAVersionAreTheOnesThatApplyToIt [

	#( #v30 #v31 #v2 ) do: [ :version |
		(FamixOpenApiRelationRules rulesFor: version) do: [ :each |
			self assert: (each appliesTo: version) ].
		self assert: (FamixOpenApiRelationRules rulesFor: version) size > 20 ].
	self assert:
		((FamixOpenApiRelationRules rulesFor: #v30) noneSatisfy: [ :each |
			 each selector = #webhooks ]).
	self assert:
		((FamixOpenApiRelationRules rulesFor: #v31) anySatisfy: [ :each |
			 each selector = #webhooks ])
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testTheCoverageKeysAreUniquePerVersion [

	#( #v30 #v31 #v2 ) do: [ :version |
		| keys |
		keys := (FamixOpenApiRelationRules rulesFor: version) collect: [
			        :each | each coverageKeyIn: version ].
		self assert: keys asSet size equals: keys size ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testTheOwnersComeFromTheKnownKinds [

	self rules do: [ :each |
		self
			assert:
			(#( #node #property #synthetic ) includes: each ownerKindName)
			description: each printString ]
]

{ #category : 'tests' }
FamixOpenApiRelationRulesTest >> testTheRowsThatAreNotRelationsAreLeftToTheirCheck [

	| rows |
	rows := self conformanceRows.
	self
		assert: (FamixOpenApiRelationRules reasonNotComparedFor:
				 (rows detect: [ :each |
					  each status = #modelledSlot and: [ each fieldName = 'title' ] ]))
		equals: 'compared by the value check (V8)'.
	self
		assert: (FamixOpenApiRelationRules reasonNotComparedFor:
				 (rows detect: [ :each | each fieldName = 'x-*' ]))
		equals: 'extension (V9)'
]
