"
Proves that the status of a conformance row is computed from the metamodel, whatever the notes of the mapping data say.
"
Class {
	#name : 'FamixOpenApiConformanceComputedStatusTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiConformanceComputedStatusTest >> reportClaiming: aSelector in: aClassName [
	"Answer the report of a metamodel that would have gained the slot aSelector in the class aClassName."

	| stub |
	stub := FamixOpenApiStubIntrospector new
		        claimSlot: aSelector in: aClassName;
		        yourself.
	^ (FamixOpenApiMetamodelConformance introspector: stub) check
]

{ #category : 'helpers' }
FamixOpenApiConformanceComputedStatusTest >> rowIn: aReport object: anObjectName field: aFieldName version: aVersion [

	^ aReport rows detect: [ :each |
		  each specObject = anObjectName and: [
			  each fieldName = aFieldName and: [ each version = aVersion ] ] ]
]

{ #category : 'tests' }
FamixOpenApiConformanceComputedStatusTest >> testHeaderKeywordBecomesModelledWhenTheMetamodelGainsIt [

	| report |
	report := self reportClaiming: #maxLength in: #OPHeader.
	self
		assert: (self
				 rowIn: report
				 object: 'Header'
				 field: 'maxLength'
				 version: #v2) status
		equals: #modelledSlot.
	self
		assert: (self
				 rowIn: report
				 object: 'Header'
				 field: 'maxLength'
				 version: #v2) note
		equals: ''.
	self
		assert: (self
				 rowIn: report
				 object: 'Header'
				 field: 'minLength'
				 version: #v2) status
		equals: #notModelled
]

{ #category : 'tests' }
FamixOpenApiConformanceComputedStatusTest >> testHeaderKeywordsHaveNoMappingEntryThatDecidesTheStatus [

	| row |
	row := self
		       rowIn: FamixOpenApiMetamodelConformance check
		       object: 'Header'
		       field: 'type'
		       version: #v2.
	self assert: row status equals: #notModelled.
	self assert: (row note includesSubstring: 'OPHeader has no type; ').
	self assert: (row note includesSubstring: 'extensions JSON text')
]

{ #category : 'tests' }
FamixOpenApiConformanceComputedStatusTest >> testInfoSummaryBecomesModelledWhenTheMetamodelGainsIt [

	| row |
	row := self
		       rowIn: (self reportClaiming: #summary in: #OPInfo)
		       object: 'Info'
		       field: 'summary'
		       version: #v31.
	self assert: row status equals: #modelledSlot.
	self assert: row targetClassName equals: 'OPInfo'.
	self assert: row targetSelector equals: #summary.
	self assert: row note equals: ''
]

{ #category : 'tests' }
FamixOpenApiConformanceComputedStatusTest >> testNoMappingEntryAssertsAStatus [

	| asserting |
	asserting := FamixOpenApiFieldMapping allEntries select: [ :each |
		             each value mode = #notModelled ].
	self assert: asserting isEmpty
]

{ #category : 'tests' }
FamixOpenApiConformanceComputedStatusTest >> testRealMetamodelStillLacksInfoSummary [

	| row |
	row := self
		       rowIn: FamixOpenApiMetamodelConformance check
		       object: 'Info'
		       field: 'summary'
		       version: #v31.
	self assert: row status equals: #notModelled.
	self
		assert: row note
		equals:
		'OPInfo has no summary; kept as extensions JSON text (verified by import)'
]
