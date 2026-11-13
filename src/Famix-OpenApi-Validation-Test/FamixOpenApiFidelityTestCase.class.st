"
Helpers of the tests of the unified fidelity checker (FamixOpenApiFidelityChecker): import a document without merging, check it with the unified checker, or with the four checks one by one for the comparison. It has no test.
"
Class {
	#name : 'FamixOpenApiFidelityTestCase',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> assert: anActual equals: anExpected description: aString [
	"The comparison with a description (the actual value is added to it)"

	self
		assert: anActual = anExpected
		description: aString , ': ' , anActual printString
]

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> assertUnifiedEqualsIndividualFor: aJsonString named: aName [
	"Check by check: the same gaps in the same order, the same coverage totals, the same frequencies"

	| unified individual |
	unified := self unifiedReportOf: aJsonString.
	individual := self individualReportsOf: aJsonString.
	FamixOpenApiFidelityReport checkNames
		with: individual
		do: [ :check :each |
			self
				assert: (self signaturesOf: (unified gapsOfCheck: check))
				equals: (self signaturesOf: each gaps)
				description: aName , ' ' , check.
			self
				assert: (unified reportOfCheck: check) coverage totalCompared
				equals: each coverage totalCompared
				description: aName , ' ' , check , ' coverage'.
			self
				assert: (unified reportOfCheck: check) coverage totalLinks
				equals: each coverage totalLinks
				description: aName , ' ' , check , ' links'.
			self
				assert: (unified reportOfCheck: check) extensions countsByKind
				equals: each extensions countsByKind
				description: aName , ' ' , check , ' frequencies' ]
]

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> importerOn: aJsonString [
	"A new importer that imported the document without merging the inline schemas; the model is #model of the importer"

	^ FamixOpenApiImporter new
		  mergesInlineSchemas: false;
		  importFromString: aJsonString;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> individualReportsOf: aJsonString [
	"The FamixOpenApiGapReport of the four checks run one by one (existence, values, extensions, relations), the way they were run before the unified checker"

	| importer model inventory |
	importer := self importerOn: aJsonString.
	model := importer model.
	inventory := self inventoryOf: aJsonString.
	^ {
		  (FamixOpenApiExistenceCheck
			   checkInventory: inventory
			   model: model
			   diagnostics: importer diagnostics).
		  (FamixOpenApiValueCheck checkInventory: inventory model: model).
		  (FamixOpenApiExtensionsCheck
			   checkInventory: inventory
			   model: model
			   diagnostics: importer diagnostics).
		  (FamixOpenApiRelationCheck
			   checkInventory: inventory
			   model: model
			   diagnostics: importer diagnostics) }
]

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> signaturesOf: someGaps [
	"What identifies the gaps: kind, pointer of the source, field, entity pointer and message"

	^ someGaps collect: [ :each |
		  {
			  each kind.
			  each sourcePointer.
			  each fieldKey.
			  each message } ]
]

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> unifiedReportOf: aJsonString [
	"Import the document (1:1) and check the model with the unified checker, with the diagnostics of the import"

	^ self unifiedReportOf: aJsonString after: [ :model |  ]
]

{ #category : 'helpers' }
FamixOpenApiFidelityTestCase >> unifiedReportOf: aJsonString after: aBlock [
	"Import the document (1:1), let aBlock change the model, check it with the unified checker, with the diagnostics of the import"

	| importer model |
	importer := self importerOn: aJsonString.
	model := importer model.
	aBlock value: model.
	^ FamixOpenApiFidelityChecker new
		  checkJsonString: aJsonString
		  model: model
		  diagnostics: importer diagnostics all
]
