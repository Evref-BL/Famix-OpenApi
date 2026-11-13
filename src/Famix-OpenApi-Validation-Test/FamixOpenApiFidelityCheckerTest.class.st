"
Tests of FamixOpenApiFidelityChecker: faithful imports of each version, one model mutation per check (the gap is attributed to the right check), the subset of checks, the preconditions (one gap, four checks skipped), a text that is not JSON, the shared expansion (counted), and the equality of its result with the four checks run one by one over every fixture of the series.
"
Class {
	#name : 'FamixOpenApiFidelityCheckerTest',
	#superclass : 'FamixOpenApiFidelityTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> assertOnePreconditionGap: aKind in: aReport [
	"One gap in the whole report, of the precondition, and no check ran"

	self assert: aReport gaps size equals: 1.
	self assert: aReport gaps first kind equals: aKind.
	self assert: (aReport gapsOfCheck: #preconditions) size equals: 1.
	self assert: aReport checksRun isEmpty.
	self
		assert: aReport checksSkipped asArray
		equals: FamixOpenApiFidelityChecker allChecks.
	self deny: aReport isFaithful
]

{ #category : 'tests - mutations' }
FamixOpenApiFidelityCheckerTest >> assertOnly: aCheckName hasGapsIn: aReport [
	"The report is not faithful and the failing gaps are all the ones of the check"

	self deny: aReport isFaithful.
	self assert: (aReport failingGapsOfCheck: aCheckName) isNotEmpty.
	(FamixOpenApiFidelityReport checkNames copyWithout: aCheckName) do: [
		:other |
		self
			assert: (aReport failingGapsOfCheck: other)
			equals: #(  )
			description: other ]
]

{ #category : 'tests - sharing' }
FamixOpenApiFidelityCheckerTest >> countCreationsDuring: aBlock [
	"An Array: how many FamixOpenApiSyntheticExpectations (the expansion of the inventory) and FamixOpenApiPointerLookup (the index of the model) aBlock created. The counting links are removed at the end"

	| expansions lookups expansionLink lookupLink |
	expansions := 0.
	lookups := 0.
	expansionLink := MetaLink new
		                 metaObject: [ expansions := expansions + 1 ];
		                 selector: #value;
		                 control: #before;
		                 yourself.
	lookupLink := MetaLink new
		              metaObject: [ lookups := lookups + 1 ];
		              selector: #value;
		              control: #before;
		              yourself.
	(FamixOpenApiSyntheticExpectations class >> #on:) ast link:
		expansionLink.
	(FamixOpenApiPointerLookup class >> #onModel:) ast link: lookupLink.
	[ aBlock value ] ensure: [
		expansionLink uninstall.
		lookupLink uninstall ].
	^ {
		  expansions.
		  lookups }
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> documentSelectorsOf: aTestCase [

	^ aTestCase class allSelectors select: [ :each |
		  (each beginsWith: 'document') and: [ each numArgs = 0 ] ]
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> faithfulDocuments [
	"Associations version -> JSON text of a document whose import every check finds faithful (VERIFIED: no failing gap)"

	^ {
		  (#v30 -> self documentOpenApi30).
		  (#v31 -> FamixOpenApiRelationTestCase new documentStructure31).
		  (#v2 -> self documentSwagger2) }
]

{ #category : 'helpers' }
FamixOpenApiFidelityCheckerTest >> fixtureDocuments [
	"Associations selector -> JSON text of every document of the fixtures of the four checks (those that are JSON)"

	^ {
		  FamixOpenApiExistenceTestCase new.
		  FamixOpenApiValueTestCase new.
		  FamixOpenApiExtensionsTestCase new.
		  FamixOpenApiRelationTestCase new.
		  FamixOpenApiRelationSwagger2Test new } flatCollect: [ :case |
		  (self documentSelectorsOf: case)
			  collect: [ :selector | selector -> (case perform: selector) ]
			  thenSelect: [ :each | self isJson: each value ] ]
]

{ #category : 'helpers' }
FamixOpenApiFidelityCheckerTest >> isJson: aString [

	^ [
	  NeoJSONReader fromString: aString.
	  true ]
		  on: Error
		  do: [ :error | false ]
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testACheckerCanBeUsedForSeveralDocuments [
	"Nothing of the first document stays in the checker"

	| checker first second |
	checker := FamixOpenApiFidelityChecker new.
	first := self importerOn: self documentOpenApi30.
	second := self importerOn: self documentSwagger2.
	self assert: (checker
			 checkJsonString: self documentOpenApi30
			 model: first model
			 diagnostics: first diagnostics all) isFaithful.
	self assert: (checker
			 checkJsonString: self documentSwagger2
			 model: second model
			 diagnostics: second diagnostics all) isFaithful.
	self deny: (checker
			 checkJsonString: self documentSwagger2
			 model: first model
			 diagnostics: first diagnostics all) isFaithful
]

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> testADocumentOfAnUnknownVersionIsOnePreconditionGapAndTheFourChecksAreSkipped [

	| model report |
	model := self modelOf: self documentOpenApi30.
	report := FamixOpenApiFidelityChecker new
		          checkJsonString: '{"info":{"title":"t"}}'
		          model: model
		          diagnostics: nil.
	self assertOnePreconditionGap: #preconditionVersion in: report.
	self assert: report version equals: #unknownVersion
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> testAFaithfulImportIsFaithfulInEveryVersion [

	self faithfulDocuments do: [ :each |
		| report |
		report := self unifiedReportOf: each value.
		self assert: report isFaithful description: each key.
		self assert: report failingGaps isEmpty.
		self assert: report unclassifiedGaps isEmpty.
		self assert: report version equals: each key.
		self
			assert: report checksRun
			equals: FamixOpenApiFidelityChecker allChecks.
		self assert: report checksSkipped isEmpty ]
]

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> testAJsonValueThatIsNotADocumentIsAnUnknownVersionNotAnError [

	| model |
	model := self modelOf: self documentOpenApi30.
	{
		nil.
		42.
		'text'.
		#( 1 2 ).
		Dictionary new.
		OrderedDictionary new } do: [ :each |
		self
			assertOnePreconditionGap: #preconditionVersion
			in: (FamixOpenApiFidelityChecker new
					 checkJson: each
					 model: model
					 diagnostics: nil) ]
]

{ #category : 'tests - mutations' }
FamixOpenApiFidelityCheckerTest >> testAKeyTakenOutOfTheExtensionsIsALostGap [

	| report |
	report := self
		          unifiedReportOf:
		          FamixOpenApiExtensionsTestCase new documentExtensions30
		          after: [ :model |
			          | root object |
			          root := model allModelEntities detect: [ :each |
				                  each class == OPOpenApi ].
			          object := NeoJSONReader fromString: root extensions.
			          object removeKey: 'x-root'.
			          root extensions: (NeoJSONWriter toString: object) ].
	self assertOnly: #extensions hasGapsIn: report.
	self
		assert: (report gapsOfCheck: #extensions) first kind
		equals: #lost.
	self
		assert: (report gapsOfCheck: #extensions) first fieldKey
		equals: 'x-root'
]

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> testAMergedImportIsOnePreconditionGapAndTheFourChecksAreSkipped [

	| doc model report |
	doc := FamixOpenApiValidatorTestCase new richDocument.
	model := self modelOf: doc merging: true.
	report := FamixOpenApiFidelityChecker new
		          checkJsonString: doc
		          model: model
		          diagnostics: nil.
	self assertOnePreconditionGap: #preconditionMerged in: report.
	self assert: (report gaps first message includesSubstring:
			 'mergesInlineSchemas = true').
	self assert:
		(report gaps first message includesSubstring: 'fidelity checks').
	self assert: (report gaps first message includesSubstring: '#/')
]

{ #category : 'tests - mutations' }
FamixOpenApiFidelityCheckerTest >> testARelatedEntityTakenOutIsARelationGap [

	| report |
	report := self
		          unifiedReportOf:
		          FamixOpenApiRelationTestCase new documentStructure30
		          after: [ :model |
			          (self entity: OPOperation at: '#/paths/~1p/get' in: model)
				          parameters remove:
				          (self
					           entity: OPParameter
					           at: '#/components/parameters/P'
					           in: model) ].
	self assertOnly: #relations hasGapsIn: report.
	self
		assert: (report gapsOfCheck: #relations) first kind
		equals: #relationMismatch.
	self
		assert: (report gapsOfCheck: #relations) first fieldKey
		equals: 'parameters'
]

{ #category : 'tests - mutations' }
FamixOpenApiFidelityCheckerTest >> testASlotChangedInTheModelIsAValueGap [

	| report |
	report := self
		          unifiedReportOf: self documentOpenApi30
		          after: [ :model |
			          (self entity: OPInfo at: '#/info' in: model) title:
				          'another' ].
	self assertOnly: #values hasGapsIn: report.
	self assert: (report gapsOfCheck: #values) size equals: 1.
	self
		assert: (report gapsOfCheck: #values) first kind
		equals: #valueMismatch.
	self
		assert: (report gapsOfCheck: #values) first fieldKey
		equals: 'title'
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testASubsetOfChecksRunsOnlyThoseAndListsTheOthersAsSkipped [

	| importer model report |
	importer := self importerOn: self documentOpenApi30.
	model := importer model.
	(self entity: OPInfo at: '#/info' in: model) title: 'another'.
	report := FamixOpenApiFidelityChecker new
		          checks: #( #existence #relations );
		          checkJsonString: self documentOpenApi30
		          model: model
		          diagnostics: importer diagnostics all.
	self assert: report checksRun equals: #( #existence #relations ).
	self
		assert: report checksSkipped asArray
		equals: #( #values #extensions ).
	self assert: report isFaithful.
	report := FamixOpenApiFidelityChecker new
		          checks: #( #values );
		          checkJsonString: self documentOpenApi30
		          model: model
		          diagnostics: importer diagnostics all.
	self assert: report checksRun equals: #( #values ).
	self deny: report isFaithful.
	self assert: report frequencies isEmpty
]

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> testATextThatIsNotJsonIsOneInvalidJsonGapAndNoException [

	| model |
	model := self modelOf: self documentOpenApi30.
	#( '' '{' '{"openapi":' '[1,' 'not json' '{"a" 1}' '\' ) do: [ :each |
		| report |
		report := FamixOpenApiFidelityChecker new
			          checkJsonString: each
			          model: model
			          diagnostics: nil.
		self
			assert: report gaps size
			equals: 1
			description: each printString.
		self assert: report gaps first kind equals: #invalidJson.
		self assert: report gaps first sourcePointer equals: '#'.
		self assert: (report gapsOfCheck: #document) size equals: 1.
		self assert: report checksRun isEmpty.
		self deny: report isFaithful ]
]

{ #category : 'tests - mutations' }
FamixOpenApiFidelityCheckerTest >> testAnEntityTakenOutOfTheModelIsAnExistenceGap [

	| report |
	report := self
		          unifiedReportOf: self documentOpenApi30
		          after: [ :model |
			          self
				          remove: OPExample
				          at: '#/components/examples/E'
				          from: model ].
	self deny: report isFaithful.
	self assert: (report failingGapsOfCheck: #existence) isNotEmpty.
	self assert:
		((report failingGapsOfCheck: #existence) anySatisfy: [ :each |
			 each kind = #missingEntity and: [
				 each sourcePointer = '#/components/examples/E' ] ]).
	self assert: (report failingGapsOfCheck: #values) isEmpty
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testAnUnknownCheckIsRefused [

	self
		should: [
		FamixOpenApiFidelityChecker new checks: #( #existence #names ) ]
		raise: Error
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testByDefaultTheFourChecksRun [

	self
		assert: FamixOpenApiFidelityChecker allChecks
		equals: #( #existence #values #extensions #relations )
]

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> testSomethingThatIsNotATextIsInvalidJsonToo [

	| report |
	report := FamixOpenApiFidelityChecker new
		          checkJsonString: nil
		          model: (self modelOf: self documentOpenApi30)
		          diagnostics: nil.
	self assert: report gaps first kind equals: #invalidJson
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testTheClassSideEntryPointsAreTheInstanceOnes [

	| importer model parsed first |
	importer := self importerOn: self documentOpenApi30.
	model := importer model.
	parsed := (NeoJSONReader on: self documentOpenApi30 readStream)
		          mapClass: OrderedDictionary;
		          next.
	first := FamixOpenApiFidelityChecker
		         checkJsonString: self documentOpenApi30
		         model: model
		         diagnostics: importer diagnostics all.
	self assert: first isFaithful.
	self
		assert: (self signaturesOf: first gaps)
		equals: (self signaturesOf: (FamixOpenApiFidelityChecker
					  checkJson: parsed
					  model: model
					  diagnostics: importer diagnostics all) gaps).
	self assert: (FamixOpenApiValidation
			 checkFidelityOfJsonString: self documentOpenApi30
			 model: model
			 diagnostics: importer diagnostics all) isFaithful
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> testTheCoverageHoldsTheValuesAndTheRelations [

	| report coverage |
	report := self unifiedReportOf: self documentOpenApi30.
	coverage := report coverage.
	self assert: report valuesCoverage totalCompared > 100.
	self assert: report relationsCoverage totalCompared > 50.
	self
		assert: coverage totalCompared
		equals: report valuesCoverage totalCompared
			+ report relationsCoverage totalCompared.
	self
		assert: coverage totalLinks
		equals: report relationsCoverage totalLinks.
	self deny: report frequencies isEmpty
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testTheDiagnosticsAreAcceptedAsTheCollectionOrAsItsAll [

	| importer model first second |
	importer := self importerOn: self documentSwagger2.
	model := importer model.
	first := FamixOpenApiFidelityChecker new
		         checkJsonString: self documentSwagger2
		         model: model
		         diagnostics: importer diagnostics.
	second := FamixOpenApiFidelityChecker new
		          checkJsonString: self documentSwagger2
		          model: model
		          diagnostics: importer diagnostics all.
	self
		assert: (self signaturesOf: first gaps)
		equals: (self signaturesOf: second gaps)
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> testTheFixturesGiveTheSameGapsAsTheFourChecksOneByOne [
	"Every document of the fixtures of the four checks, faithful or not: the unified checker finds what the four entry points find, in the same order"

	| documents |
	documents := self fixtureDocuments.
	self assert: documents size > 100.
	documents do: [ :each |
		self assertUnifiedEqualsIndividualFor: each value named: each key ]
]

{ #category : 'tests - sharing' }
FamixOpenApiFidelityCheckerTest >> testTheFourChecksShareOneExpansionOfTheInventoryAndOneIndexOfTheModel [
	"VERIFIED by counting: the four checks one by one expand the inventory and index the model 4 times each, the unified checker once"

	| importer model inventory individual unified |
	importer := self importerOn: self documentOpenApi30.
	model := importer model.
	inventory := self inventoryOf: self documentOpenApi30.
	unified := self countCreationsDuring: [
		           FamixOpenApiFidelityChecker new
			           checkInventory: inventory
			           model: model
			           diagnostics: importer diagnostics all ].
	individual := self countCreationsDuring: [
		              FamixOpenApiExistenceCheck
			              checkInventory: inventory
			              model: model
			              diagnostics: importer diagnostics.
		              FamixOpenApiValueCheck
			              checkInventory: inventory
			              model: model.
		              FamixOpenApiExtensionsCheck
			              checkInventory: inventory
			              model: model
			              diagnostics: importer diagnostics.
		              FamixOpenApiRelationCheck
			              checkInventory: inventory
			              model: model
			              diagnostics: importer diagnostics ].
	self assert: unified equals: #( 1 1 ).
	self assert: individual equals: #( 4 4 )
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> testTheFrequenciesAreTheOnesOfTheExtensionsCheck [

	| report |
	report := self unifiedReportOf:
		          FamixOpenApiExtensionsTestCase new documentExtensions30.
	self assert: report isFaithful.
	self assert:
		(report frequencies countsByKind at: #onlyInExtensions) > 10.
	self
		assert: report frequencies countsByKind
		equals: (report reportOfCheck: #extensions) extensions countsByKind
]

{ #category : 'tests - mutations' }
FamixOpenApiFidelityCheckerTest >> testTheGapsAreStampedWithTheFile [

	| importer report |
	importer := self importerOn: self documentOpenApi30.
	importer model remove: (self
			 entity: OPExample
			 at: '#/components/examples/E'
			 in: importer model).
	report := FamixOpenApiFidelityChecker new
		          file: 'spec.json';
		          checkJsonString: self documentOpenApi30
		          model: importer model
		          diagnostics: importer diagnostics all.
	self
		assert: report files
		equals: (OrderedCollection with: 'spec.json').
	self assert:
		(report gaps allSatisfy: [ :each | each file = 'spec.json' ]).
	self assert: report gaps isNotEmpty
]

{ #category : 'tests - preconditions' }
FamixOpenApiFidelityCheckerTest >> testTheLabelIsStampedOnThePreconditionGap [

	| report |
	report := FamixOpenApiFidelityChecker new
		          file: 'empty.json';
		          checkJsonString: '{}'
		          model: (self modelOf: '{}')
		          diagnostics: nil.
	self assert: report gaps first kind equals: #preconditionVersion.
	self assert: report gaps first file equals: 'empty.json'
]

{ #category : 'tests - faithful' }
FamixOpenApiFidelityCheckerTest >> testTheReportKnowsTheSizeOfTheSourceAndOfTheModel [

	| report importer |
	importer := self importerOn: self documentSwagger2.
	report := self unifiedReportOf: self documentSwagger2.
	self assert: report documents equals: 1.
	self
		assert: report nodeCount
		equals: (self inventoryOf: self documentSwagger2) pointers size.
	self
		assert: report entityCount
		equals: importer model allModelEntities size.
	self assert: report nodeCount > 50
]

{ #category : 'tests - options' }
FamixOpenApiFidelityCheckerTest >> testWithoutDiagnosticsTheKeysThatNothingCoversAreNotDecidable [
	"VERIFIED: with the diagnostics, 3 keys are ignored by a diagnostic and 4 values are dropped silently; without them the 7 keys are not decidable (informational)"

	| doc importer report |
	doc := FamixOpenApiExtensionsTestCase new documentWrongTypes30.
	importer := self importerOn: doc.
	report := FamixOpenApiFidelityChecker new
		          checkJsonString: doc
		          model: importer model
		          diagnostics: nil.
	self
		assert: (report countsByCheckAndKind at: #extensions)
		equals: (OrderedDictionary new
				 at: #notDecidable put: 7;
				 yourself).
	self assert: report isFaithful.
	self
		assert: (report informationalGaps collect: #kind as: Set)
		equals: #( #notDecidable ) asSet
]
