"
Unit tests of the small parts of the relation check: the comparison of two lists of targets (ordered, set, count; missing, extra, order), the derivations by name, the rule (coverage key, conformance rows), the gap kinds and the coverage that records the relations compared, their links and the ones deferred.
"
Class {
	#name : 'FamixOpenApiRelationUnitTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> comparisonOf: anExpectedArray found: aFoundArray mode: aMode [

	| rule |
	rule := FamixOpenApiRelationRule
		        group: #( 'Operation' 'OPOperation' #( node ) 'Operation' )
		        row: {
				        'parameters'.
				        #parameters.
				        'OPParameter'.
				        #children.
				        #( 'parameters' ).
				        #( #v30 ).
				        #( 'parameters' ).
				        aMode }.
	^ FamixOpenApiRelationComparison new
		  rule: rule;
		  expected: anExpectedArray;
		  found: aFoundArray;
		  yourself
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testARuleReadsItsDataFromTheGroupAndTheRow [

	| rule |
	rule := FamixOpenApiRelationRules rules detect: [ :each |
		        each selector = #webhooks ].
	self assert: rule specObject equals: 'OpenAPI'.
	self assert: rule ownerClassName equals: 'OPOpenApi'.
	self assert: rule fieldKey equals: 'webhooks'.
	self assert: rule targetClassName equals: 'OPPath'.
	self assert: rule derivationName equals: #children.
	self assert: rule arguments equals: #( 'webhooks' ).
	self assert: rule versions equals: #( #v31 ).
	self assert: rule rowFields equals: #( 'webhooks' ).
	self assert: rule compareMode equals: #ordered.
	self assert: rule ownerKindName equals: #node.
	self assert: rule ownerSuffix equals: ''.
	self assert: rule targetFamily equals: OPPath.
	self assert: rule ownerClass equals: OPOpenApi.
	self assert: ('*webhooks*' match: rule printString)
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testAnEmptyCoverageHasNoDeferredRelations [

	self assert: FamixOpenApiCoverage new isEmpty.
	self assert: FamixOpenApiCoverage new markdownDeferred equals: ''.
	self assert: (FamixOpenApiCoverage new deferralReasonOf: 'k') isNil
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testAnUnknownDerivationIsAnError [

	self
		should: [
			FamixOpenApiRelationDerivation
				named: #nothing
				arguments: #(  )
				family: OPSchema ]
		raise: KeyNotFound
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testCountsOnlyLookAtTheNumberOfTargets [

	| comparison |
	self assert:
		(self comparisonOf: #( 'a' 'b' ) found: #( 'x' 'y' ) mode: #count)
			isEquivalent.
	comparison := self comparisonOf: #( 'a' ) found: #(  ) mode: #count.
	self deny: comparison isEquivalent.
	self assert: comparison gapKind equals: #countMismatch.
	self assert:
		('*designates 1 targets*holds 0*' match: comparison message)
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testEveryDerivationNameBuildsItsClassWithItsArgumentsAndFamily [

	FamixOpenApiRelationDerivation dataClassNames keysAndValuesDo: [
		:name
		:className |
		| derivation |
		derivation := FamixOpenApiRelationDerivation
			              named: name
			              arguments: #( 'x' )
			              family: OPSchema.
		self assert: derivation class name equals: className.
		self assert: derivation arguments equals: #( 'x' ).
		self assert: derivation family equals: OPSchema ]
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testOnlyTheOrderDiffers [

	| comparison |
	comparison := self
		              comparisonOf: #( 'a' 'b' )
		              found: #( 'b' 'a' )
		              mode: #ordered.
	self assert: comparison isOrderDifference.
	self assert:
		('Operation.parameters -> OPParameter (OPOperation>>parameters): order differs*'
			 match: comparison message).
	self deny:
		(self comparisonOf: #( 'a' ) found: #( 'a' ) mode: #ordered)
			isOrderDifference
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testOrderedListsAreEquivalentOnlyWhenEqual [

	self assert:
		(self comparisonOf: #( 'a' 'b' ) found: #( 'a' 'b' ) mode: #ordered)
			isEquivalent.
	self deny:
		(self comparisonOf: #( 'a' 'b' ) found: #( 'b' 'a' ) mode: #ordered)
			isEquivalent.
	self deny:
		(self comparisonOf: #( 'a' ) found: #(  ) mode: #ordered)
			isEquivalent
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testSetsIgnoreTheOrderNotTheContent [

	self assert:
		(self comparisonOf: #( 'a' 'b' ) found: #( 'b' 'a' ) mode: #set)
			isEquivalent.
	self deny:
		(self comparisonOf: #( 'a' 'b' ) found: #( 'b' ) mode: #set)
			isEquivalent.
	self deny:
		(self comparisonOf: #( 'a' ) found: #( 'a' 'a' ) mode: #set)
			isEquivalent
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheCoverageCountsTheLinksOfTheRelationsComparedAndMergesThem [

	| first second |
	first := FamixOpenApiCoverage new.
	first recordCompared: 'k'.
	first recordLinks: 3 at: 'k'.
	first recordDeferred: 'd' reason: 'why'.
	second := FamixOpenApiCoverage new.
	second recordCompared: 'k'.
	second recordLinks: 2 at: 'k'.
	second mergeWith: first.
	self assert: (second linkCountOf: 'k') equals: 5.
	self assert: second totalLinks equals: 5.
	self assert: (second deferredCountOf: 'd') equals: 1.
	self assert: (second deferralReasonOf: 'd') equals: 'why'.
	self assert: (second comparedCountOf: 'k') equals: 2
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheCoverageKeyOfARuleNamesTheVersionTheSpecObjectTheFieldTheClassAndTheRelation [

	| rule |
	rule := FamixOpenApiRelationRules rules detect: [ :each |
		        each selector = #parameters and: [
			        each ownerClassName = 'OPOperation' ] ].
	self
		assert: (rule coverageKeyIn: #v30)
		equals: 'v30 Operation.parameters -> OPOperation>>parameters'
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheCoverageRecordsTheDeferredRelationsWithTheFirstReason [

	| coverage |
	coverage := FamixOpenApiCoverage new.
	coverage recordDeferred: 'k' reason: 'first'.
	coverage recordDeferred: 'k' reason: 'second'.
	self assert: (coverage deferredCountOf: 'k') equals: 2.
	self assert: (coverage deferralReasonOf: 'k') equals: 'first'.
	self assert: coverage deferredKeys equals: #( 'k' ).
	self assert: coverage totalDeferred equals: 2.
	self deny: coverage isEmpty.
	self assert: ('*| k | 2 | first |*' match: coverage markdownDeferred)
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheGapKindsOfTheRelationCheckAreFailuresApartFromTheOnesOfV9 [

	self
		assert: FamixOpenApiGapReport relationKinds asSet
		equals: #( #relationMismatch #countMismatch ) asSet.
	self deny: (FamixOpenApiGapReport failingKinds includesAny:
			 FamixOpenApiGapReport relationKinds)
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheMarkdownSummaryOfAReportShowsTheDeferredRelations [

	| report |
	report := FamixOpenApiGapReport new.
	report coverage recordCompared: 'k'.
	report coverage recordDeferred: 'd' reason: 'why'.
	self assert:
		('*| Deferred relation | Count | Reason |*| d | 1 | why |*' match:
			 report markdownSummary)
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheMessageSaysWhatIsMissingAndWhatIsExtra [

	| comparison |
	comparison := self
		              comparisonOf: #( 'a' )
		              found: #( 'c' )
		              mode: #ordered.
	self assert:
		('*missing #(''a''), extra #(''c'')' match: comparison message)
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheMissingAndTheExtraTargetsAreCountedOnceEach [

	| comparison |
	comparison := self
		              comparisonOf: #( 'a' 'b' 'b' )
		              found: #( 'b' 'c' )
		              mode: #ordered.
	self assert: comparison missing equals: #( 'a' 'b' ).
	self assert: comparison extra equals: #( 'c' ).
	self assert: comparison gapKind equals: #relationMismatch.
	self deny: comparison isOrderDifference
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheOwnersOfAnEntityWithoutNodeAreTheDerivedRules [

	| rule components |
	rule := FamixOpenApiRelationRules rules detect: [ :each |
		        each selector = #scheme ].
	self assert: rule ownerKindName equals: #synthetic.
	self
		assert: rule syntheticRuleNames
		equals: #( #securityRequirementItem ).
	components := FamixOpenApiRelationRules rules detect: [ :each |
		              each selector = #schemas and: [
			              each versions includes: #v2 ] ].
	self assert: components ownerSuffix equals: '/components'
]

{ #category : 'tests' }
FamixOpenApiRelationUnitTest >> testTheReportSelectsTheRelationGaps [

	| report |
	report := FamixOpenApiGapReport new.
	report add: ((FamixOpenApiGap
			  kind: #relationMismatch
			  pointer: '#'
			  specObject: 'OpenAPI')
			 fieldKey: 'servers';
			 yourself).
	report add: ((FamixOpenApiGap
			  kind: #countMismatch
			  pointer: '#'
			  specObject: 'OpenAPI')
			 fieldKey: 'tags';
			 yourself).
	report add:
		((FamixOpenApiGap
			  kind: #valueMismatch
			  pointer: '#'
			  specObject: 'Info')
			 fieldKey: 'title';
			 yourself).
	self assert: report relationGaps size equals: 2.
	self assert: report relationMismatches size equals: 1
]
