"
I test FamixOpenApiMetamodelConformance and FamixOpenApiConformanceReport: spot checks on known facts of the metamodel, the report API, the Markdown output, the purity of the check, and a regression test that FREEZES the counts per version, level and status and the structural fields that are not modelled. The frozen data must be updated after a change of the metamodel or of the mapping; that is expected.
"
Class {
	#name : 'FamixOpenApiConformanceReportTest',
	#superclass : 'TestCase',
	#instVars : [
		'report'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - frozen regression' }
FamixOpenApiConformanceReportTest >> frozenStructuralNotModelledIn: aVersion [
	"Sorted Object.field of the structural fields not modelled. Updating them is EXPECTED after a change of the metamodel, of the mapping or of the field table."

	aVersion = #v30 ifTrue: [ ^ #('Header.allowEmptyValue' 'Header.allowReserved' 'Header.content' 'Link.parameters') ].
	aVersion = #v31 ifTrue: [ ^ #('Header.allowEmptyValue' 'Header.allowReserved' 'Header.content' 'Link.parameters' 'Schema.$anchor' 'Schema.$defs' 'Schema.$dynamicAnchor' 'Schema.$dynamicRef' 'Schema.$id' 'Schema.contains' 'Schema.dependentRequired' 'Schema.dependentSchemas' 'Schema.else' 'Schema.if' 'Schema.maxContains' 'Schema.minContains' 'Schema.patternProperties' 'Schema.propertyNames' 'Schema.then' 'Schema.unevaluatedItems' 'Schema.unevaluatedProperties') ].
	^ #('Header.collectionFormat' 'Header.default' 'Header.enum' 'Header.exclusiveMaximum' 'Header.exclusiveMinimum' 'Header.format' 'Header.items' 'Header.maxItems' 'Header.maxLength' 'Header.maximum' 'Header.minItems' 'Header.minLength' 'Header.minimum' 'Header.multipleOf' 'Header.pattern' 'Header.type' 'Header.uniqueItems' 'Items.collectionFormat' 'Operation.schemes')
]

{ #category : 'tests - frozen regression' }
FamixOpenApiConformanceReportTest >> frozenSummary [
	"Rows #(version level status count) as produced by the check. Updating them is EXPECTED after a change of the metamodel (Famix-OpenAPI-Model), of the mapping or of the field table."

	^ #( #( v2 metadata implicit 18 )
		 #( v2 structural implicit 46 )
		 #( v2 structural modelledRelation 14 )
		 #( v2 structural modelledSlot 44 )
		 #( v2 structural notModelled 19 )
		 #( v2 useful modelledRelation 9 )
		 #( v2 useful modelledSlot 30 )
		 #( v2 useful notModelled 2 )
		 #( v30 metadata implicit 27 )
		 #( v30 structural implicit 18 )
		 #( v30 structural modelledRelation 43 )
		 #( v30 structural modelledSlot 53 )
		 #( v30 structural notModelled 4 )
		 #( v30 useful implicit 2 )
		 #( v30 useful modelledRelation 12 )
		 #( v30 useful modelledSlot 43 )
		 #( v30 useful notModelled 3 )
		 #( v31 metadata implicit 28 )
		 #( v31 metadata modelledSlot 1 )
		 #( v31 metadata notModelled 6 )
		 #( v31 structural implicit 18 )
		 #( v31 structural modelledRelation 46 )
		 #( v31 structural modelledSlot 54 )
		 #( v31 structural notModelled 21 )
		 #( v31 useful implicit 2 )
		 #( v31 useful modelledRelation 12 )
		 #( v31 useful modelledSlot 45 )
		 #( v31 useful notModelled 6 )
		 )
]

{ #category : 'running' }
FamixOpenApiConformanceReportTest >> rowAt: anObjectName field: aFieldName in: aVersion [

	^ report rows detect: [ :each |
		  each specObject = anObjectName and: [
			  each fieldName = aFieldName and: [ each version = aVersion ] ] ]
]

{ #category : 'running' }
FamixOpenApiConformanceReportTest >> setUp [

	super setUp.
	report := FamixOpenApiMetamodelConformance check
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testCanonicalPointerAndSourceTextAreModelOnly [

	| keys |
	keys := report modelOnlyRows collect: [ :each | each key ].
	self assert: (keys includes: 'OPCanonicalNode>>canonicalPointer').
	self assert: (keys includes: 'OPSourceText>>sourceText')
]

{ #category : 'tests - markdown and purity' }
FamixOpenApiConformanceReportTest >> testCheckDoesNotMutateTheFieldTable [

	| before after |
	before := FamixOpenApiSpecFieldTable allFields collect: [ :each |
		          each printString ].
	FamixOpenApiMetamodelConformance check markdownSummary.
	after := FamixOpenApiSpecFieldTable allFields collect: [ :each |
		         each printString ].
	self assert: after equals: before
]

{ #category : 'tests - markdown and purity' }
FamixOpenApiConformanceReportTest >> testCheckIsRepeatable [

	| again |
	again := FamixOpenApiMetamodelConformance check.
	self assert: again summary equals: report summary.
	self assert: again markdownSummary equals: report markdownSummary
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testExampleOfParameterAndMediaTypeIsImplicit [
	"Converted to an OPExample named example in the examples relation (verified by import)."

	#( #v30 #v31 ) do: [ :version |
		#( 'Parameter' 'MediaType' ) do: [ :object |
			self assert: (self rowAt: object field: 'example' in: version) status equals: #implicit ] ]
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testExtensionsAreImplicit [

	self
		assert: (self rowAt: 'Schema' field: 'x-*' in: #v31) status
		equals: #implicit.
	self
		assert: (self rowAt: 'Schema' field: 'x-*' in: #v31) target
		equals: 'OPSchema>>extensions'
]

{ #category : 'tests - frozen regression' }
FamixOpenApiConformanceReportTest >> testFrozenStructuralNotModelled [
	"Structural fields not modelled, per version. Update after a change of the metamodel: that is expected."

	#( #v30 #v31 #v2 ) do: [ :version |
		| actual |
		actual := (report notModelledIn: version)
			          select: [ :each | each level = #structural ]
			          thenCollect: [ :each |
				          '{1}.{2}' format: {
						          each specObject.
						          each fieldName } ].
		self
			assert: actual sorted asArray
			equals: (self frozenStructuralNotModelledIn: version) ]
]

{ #category : 'tests - frozen regression' }
FamixOpenApiConformanceReportTest >> testFrozenSummary [
	"Counts per version, level and status. Update after a change of the metamodel: that is expected."

	| actual expected |
	expected := Dictionary new.
	self frozenSummary do: [ :each |
		expected
			at: {
					each first.
					each second.
					each third }
			put: each fourth ].
	actual := report summary.
	self assert: actual equals: expected
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testHeaderKeywordsAreNotModelledInSwagger2 [
	"Importer fidelity gap: a Swagger 2 header keyword is not converted to a schema (verified by import). The same keyword of a Parameter is carried by an inline schema."

	self assert: (self rowAt: 'Header' field: 'type' in: #v2) status equals: #notModelled.
	self assert: (self rowAt: 'Header' field: 'collectionFormat' in: #v2) status equals: #notModelled.
	self assert: (self rowAt: 'Header' field: 'description' in: #v2) status equals: #modelledSlot.
	self assert: (self rowAt: 'Parameter' field: 'type' in: #v2) status equals: #implicit
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testInfoSummaryIsNotModelled [
	"Found by running the check: OPInfo has no summary slot."

	self
		assert: (self rowAt: 'Info' field: 'summary' in: #v31) status
		equals: #notModelled
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testInfoTitleIsModelledSlot [

	| row |
	row := self rowAt: 'Info' field: 'title' in: #v30.
	self assert: row status equals: #modelledSlot.
	self assert: row target equals: 'OPInfo>>title'
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testLicenseIdentifierIsNotModelled [
	"Found by running the check: OPLicense has no identifier slot."

	self
		assert: (self rowAt: 'License' field: 'identifier' in: #v31) status
		equals: #notModelled
]

{ #category : 'tests - markdown and purity' }
FamixOpenApiConformanceReportTest >> testMarkdownHasOneTablePerVersionAndTheModelOnlySection [

	| markdown |
	markdown := report markdownSummary.
	#( 'OpenAPI 3.0.3' 'OpenAPI 3.1.x' 'Swagger 2.0' '## Model-only slots'
	   '| object | field | level | status | OP target | note |' ) do: [
		:each |
		self assert: (markdown includesSubstring: each) description: each ]
]

{ #category : 'tests - markdown and purity' }
FamixOpenApiConformanceReportTest >> testMarkdownMentionsKnownRows [

	| markdown |
	markdown := report markdownSummary.
	self assert: (markdown includesSubstring:
			 '| Info | summary | useful | notModelled |').
	self assert: (markdown includesSubstring:
			 '| Parameter | in | structural | modelledSlot | OPParameter>>location |')
]

{ #category : 'tests - markdown and purity' }
FamixOpenApiConformanceReportTest >> testMarkdownUsesLfOnly [

	| markdown |
	markdown := report markdownSummary.
	self deny: (markdown includes: Character cr).
	self assert: (markdown includes: Character lf)
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testModelOnlyRowsHaveAReasonOrAreUnexplained [

	report modelOnlyRows do: [ :each |
		each status = #modelOnly
			ifTrue: [ self deny: each reason isEmpty ]
			ifFalse: [ self assert: each status equals: #unexplained ] ]
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testModelledRowsAreConfirmedByTheMetamodel [

	| introspector |
	introspector := FamixOpenApiMetamodelIntrospector new.
	report rows select: [ :each | each isModelled ] thenDo: [ :each |
		self
			assert: (introspector
					 isModelled: each targetSelector
					 in: (introspector classNamed: each targetClassName))
			description: each printString ]
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testNameAndExtensionsAreCoveredBySpecFields [

	| keys |
	keys := report modelOnlyRows collect: [ :each | each key ].
	self deny: (keys includes: 'OPCanonicalNode>>extensions').
	self deny: (keys includes: 'FamixTNamedEntity>>name')
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testNoUnexplainedModelOnlySlot [
	"Every slot of the metamodel that matches no spec field has a known reason."

	self assert: report unexplainedModelOnlyRows isEmpty
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testNotModelledInVersion [

	(report notModelledIn: #v2) do: [ :each |
		self assert: each version equals: #v2.
		self assert: each isNotModelled ].
	self assert: ((report notModelledIn: #v31) anySatisfy: [ :each |
			 each fieldName = 'summary' and: [ each specObject = 'Info' ] ])
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testNotModelledNoteSaysWhereTheValueSurvives [
	self
		assert: (self rowAt: 'Info' field: 'summary' in: #v31) note
		equals: 'OPInfo has no summary; kept as extensions JSON text (verified by import)'
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testNotModelledRowsHaveNoTarget [

	(report rowsWithStatus: #notModelled) do: [ :each |
		self assert: each targetSelector isNil.
		self deny: each note isEmpty ]
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testObjectWithoutOPClassIsNotModelled [

	| row field |
	field := FamixOpenApiSpecField
		         fromRow: #( 'title' scalar #( v31 ) useful false '' )
		         specObject: 'NoSuchObject'.
	row := FamixOpenApiMetamodelConformance new rowFor: field in: #v31.
	self assert: row status equals: #notModelled.
	self assert: row note equals: 'no OP class'
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testOneRowPerFieldAndVersion [

	| expected |
	expected := FamixOpenApiSpecFieldTable versions
		            inject: 0
		            into: [ :sum :version |
			            sum
			            + (FamixOpenApiSpecFieldTable fieldsIn: version) size ].
	self assert: report rows size equals: expected
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testParameterInIsModelledViaLocation [

	#( #v30 #v31 #v2 ) do: [ :version |
		| row |
		row := self rowAt: 'Parameter' field: 'in' in: version.
		self assert: row status equals: #modelledSlot.
		self assert: row target equals: 'OPParameter>>location' ]
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testPatternedKeysAreImplicit [

	self
		assert: (self rowAt: 'Paths' field: '/{path}' in: #v30) target
		equals: 'OPPath>>relativePath'.
	self
		assert:
		(self rowAt: 'Responses' field: '{HTTP status code}' in: #v2) target
		equals: 'OPResponse>>statusCode'
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testRowsAtLevelWithStatus [

	(report rowsAt: #structural withStatus: #notModelled) do: [ :each |
		self assert: each level equals: #structural.
		self assert: each status equals: #notModelled ]
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testRowsWithStatusSelectsOnlyThatStatus [

	(report rowsWithStatus: #implicit) do: [ :each |
		self assert: each status equals: #implicit ].
	self assert: (report rowsWithStatus: #implicit) isNotEmpty
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testSchemaExclusiveMinimumIsModelledInBothOpenApiVersions [

	#( #v30 #v31 ) do: [ :version |
		self
			assert:
			(self rowAt: 'Schema' field: 'exclusiveMinimum' in: version) status
			equals: #modelledSlot ]
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testSchemaItemsIsModelledRelation [

	| row |
	row := self rowAt: 'Schema' field: 'items' in: #v31.
	self assert: row status equals: #modelledRelation.
	self assert: row targetSelector equals: #items
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testSchemaRequiredIsCarriedByRequiredProperties [

	self
		assert: (self rowAt: 'Schema' field: 'required' in: #v30) target
		equals: 'OPSchema>>requiredProperties'
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testSchemaTypeIsCarriedByTypes [

	self
		assert: (self rowAt: 'Schema' field: 'type' in: #v31) target
		equals: 'OPSchema>>types'
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testStatusMatchesTheKindOfTheSlot [

	| introspector |
	introspector := FamixOpenApiMetamodelIntrospector new.
	(report rowsWithStatus: #modelledRelation) do: [ :each |
		self
			assert: (introspector
					 kindOf: each targetSelector
					 in: (introspector classNamed: each targetClassName))
			equals: #relation ].
	(report rowsWithStatus: #modelledSlot) do: [ :each |
		self
			assert: (introspector
					 kindOf: each targetSelector
					 in: (introspector classNamed: each targetClassName))
			equals: #slot ]
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testSummaryCountsEveryRow [

	self
		assert:
		(report summary values inject: 0 into: [ :sum :each | sum + each ])
		equals: report rows size
]

{ #category : 'tests - spot checks' }
FamixOpenApiConformanceReportTest >> testSwagger2FlowIsCarriedByOAuthFlow [

	self
		assert: (self rowAt: 'SecurityScheme' field: 'flow' in: #v2) target
		equals: 'OPOAuthFlow>>flowType'
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testUncoveredStructuralHoldsOnlyStructuralNotModelled [

	report uncoveredStructural do: [ :each |
		self assert: each level equals: #structural.
		self assert: each status equals: #notModelled ].
	self
		assert: report uncoveredStructural size
		equals: (#( #v30 #v31 #v2 ) inject: 0 into: [ :sum :each |
				 sum
				 + (report countAt: each level: #structural status: #notModelled) ])
]

{ #category : 'tests - api' }
FamixOpenApiConformanceReportTest >> testUnmappedFieldIsNotModelledNotAnError [

	| row field |
	field := FamixOpenApiSpecField
		         fromRow: #( 'noSuchField' scalar #( v31 ) useful false
		            '' )
		         specObject: 'Info'.
	row := FamixOpenApiMetamodelConformance new rowFor: field in: #v31.
	self assert: row status equals: #notModelled
]
