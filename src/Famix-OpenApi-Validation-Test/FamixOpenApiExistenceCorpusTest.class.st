"
The existence check over the 20 files of the external test corpus (the folder is outside the repository: the tests are skipped, like the ones of FamixOpenApiCorpusTest, when it is absent), each file imported with mergesInlineSchemas false. IMPORTANT: the importer is NOT changed by the steps that wrote this test. The expected result is the FROZEN set of #frozenGaps (every gap of the corpus, as file, pointer, kind, spec object): a gap that appears or disappears fails the test, so that a real importer finding is never lost or hidden. It is empty: the 20 files are faithful at level 1, the entities without node being EXACTLY the derived ones (V7b: FamixOpenApiSyntheticExpectations; V7 only accepted them by pattern). #frozenDerivedCounts freezes the number of entities each derivation expects over the corpus (the V7 counts, 0 for the rules the corpus never exercises), #frozenSyntheticCounts the number the check found, #frozenCloneSites the $ref response and path item sites that are cloned. The mutation tests run the sweeps of the check tests on real imported models.
"
Class {
	#name : 'FamixOpenApiExistenceCorpusTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiExistenceCorpusTest >> corpusHelper [
	"The importer test that owns the raw reading helpers and the corpus folder"

	^ FamixOpenApiCorpusTest new
]

{ #category : 'data' }
FamixOpenApiExistenceCorpusTest >> frozenCloneSites [
	"Rows: file name, number of $ref response or path item use sites that the importer clones. Only giphy has some (40 $ref responses, whose targets hold nothing below the site: a description)"

	^ #( #( 'apisguru-giphy.com.json' 40 ) )
]

{ #category : 'data' }
FamixOpenApiExistenceCorpusTest >> frozenDerivedCounts [
	"Rows: synthetic rule, number of entities of the whole corpus that the derivation expects (V7b: exact, the V7 counts of the rules that accepted entities, and 0 for the rules that the corpus never exercises: the clones of giphy hold nothing below their sites, no Swagger 2 discriminator, no mapping, no wrong-shape discriminator)"

	^ #( #( #swagger2ParameterSchema 401 )
	     #( #swagger2MediaType 168 ) #( #securityRequirementItem
	        87 ) #( #synthesizedServer 14 ) #( #swagger2FormDataRequestBody
	        14 ) #( #securityScope 13 ) #( #swagger2Components
	        6 ) #( #scalarExample 4 ) #( #cloneSubtree 0 )
	     #( #discriminatorMappingEntry 0 )
	     #( #swagger2Discriminator 0 ) #( #wrongShapeDiscriminator
	        0 ) )
]

{ #category : 'data' }
FamixOpenApiExistenceCorpusTest >> frozenGaps [
	"Rows: file name, pointer, kind, spec object. Empty: the importer builds, at level 1, everything the 20 files of the corpus describe and nothing else but the documented synthetic entities. The importer was not changed to get there"

	^ #(  )
]

{ #category : 'data' }
FamixOpenApiExistenceCorpusTest >> frozenSyntheticCounts [
	"Rows: synthetic rule, number of entities of the whole corpus that the rule accepts (the expected synthetic set, asserted exactly)"

	^ #( #( #swagger2ParameterSchema 401 )
	     #( #swagger2MediaType 168 ) #( #securityRequirementItem
	        87 ) #( #synthesizedServer 14 ) #( #swagger2FormDataRequestBody
	        14 ) #( #securityScope 13 ) #( #swagger2Components
	        6 ) #( #scalarExample 4 ) )
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> mutationFileNames [
	"One file per version: a Swagger 2, an OpenAPI 3.0 and an OpenAPI 3.1 document"

	^ #( 'petstore-swagger2.json' 'petstore-openapi3.json'
	     'oai-learn-v3.1-tictactoe.json' )
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> mutationFiles [

	^ self specFiles select: [ :each |
		  self mutationFileNames includes: each basename ]
]

{ #category : 'helpers' }
FamixOpenApiExistenceCorpusTest >> reportOfFile: aFile [
	"The report of the check of aFile imported without merging, with the diagnostics of the import"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: aFile contents.
	^ (FamixOpenApiExistenceCheck new
		   file: aFile basename;
		   yourself)
		  checkInventory: (self inventoryOf: aFile contents)
		  model: model
		  diagnostics: importer diagnostics
]

{ #category : 'helpers' }
FamixOpenApiExistenceCorpusTest >> reports [
	"Associations file name -> report, for every spec file of the corpus"

	^ self specFiles collect: [ :file |
		  file basename -> (self reportOfFile: file) ]
]

{ #category : 'helpers' }
FamixOpenApiExistenceCorpusTest >> specFiles [
	"The corpus files that are API descriptions. Skips the running test when the corpus folder is absent"

	| helper |
	helper := self corpusHelper.
	^ helper corpusFiles select: [ :file |
		  helper isSpecDocument: (helper rawDocumentOf: file) ]
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> testAnyDerivedEntityOfARealModelIsRequiredOnceAndOfItsClass [

	self mutationFiles do: [ :each |
		self assertDerivedSweepsIn: each contents named: each basename ]
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testCloneSitesOfTheCorpusAreTheFrozenOnes [

	| actual |
	actual := Array streamContents: [ :stream |
		          self specFiles do: [ :file |
			          | count |
			          count := (FamixOpenApiCloneExpansion on:
				                    (self inventoryOf: file contents))
				                   cloneSitePointers size.
			          count > 0 ifTrue: [
				          stream nextPut: {
						          file basename.
						          count } ] ] ].
	self assert: actual equals: self frozenCloneSites
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testCorpusGapsAreExactlyTheFrozenOnes [

	| actual |
	actual := Array streamContents: [ :stream |
		          self reports do: [ :each |
			          each value gaps do: [ :gap |
				          stream nextPut: {
						          each key.
						          gap sourcePointer.
						          gap kind.
						          gap specObject } ] ] ].
	self assert: actual asSet equals: self frozenGaps asSet.
	self assert: actual size equals: self frozenGaps size
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testCorpusHasTheTwentyFilesAndTheCheckLooksAtThem [

	| reports nodes |
	reports := self reports.
	self assert: reports size equals: 20.
	nodes := reports
		         inject: 0
		         into: [ :sum :each |
		         sum + each value nodeCountsBySpecObject values sum ].
	self assert: nodes > 3000
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testDerivedEntitiesOfTheCorpusAreExactlyTheFrozenCounts [
	"The derivation (no model, no importer) gives, over the 20 files, the V7 counts of each rule and 0 for the ones the corpus does not exercise"

	| totals |
	totals := Bag new.
	self reports do: [ :each |
		each value derivedCountsByRule keysAndValuesDo: [ :rule :count |
			totals add: rule withOccurrences: count ] ].
	self
		assert: (self frozenDerivedCounts collect: [ :row |
				 row first -> (totals occurrencesOf: row first) ])
		equals:
		(self frozenDerivedCounts collect: [ :row | row first -> row second ]).
	self assert: totals asSet equals: (self frozenDerivedCounts
			 reject: [ :row | row second = 0 ]
			 thenCollect: #first) asSet
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testEveryDerivedEntityOfTheCorpusIsInTheModel [
	"Per file and per rule, what the derivation expects is what the check found (the rest would be a gap)"

	self reports do: [ :each |
		self
			assert: each value derivedCountsByRule
			equals: each value syntheticCountsByRule ]
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testEveryExpectedEntityIsFoundInEveryFile [

	self reports do: [ :each |
		self
			assert: each value expectedCountsBySpecObject
			equals: each value foundCountsBySpecObject ]
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> testMergedImportOfARealFileIsAPreconditionFinding [

	| file model report |
	file := self specFiles detect: [ :each |
		        each basename = 'petstore-openapi3.json' ].
	model := self modelOf: file contents merging: true.
	report := self reportOf: model for: file contents.
	self
		assert: (report gaps collect: #kind) asArray
		equals: #( #preconditionMerged )
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> testMovingAnyEntityOfARealModelIsDetected [

	self mutationFiles do: [ :each |
		self assertMovesAreDetectedIn: each contents named: each basename ]
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> testRemovingAnyEntityOfARealModelIsDetected [

	self mutationFiles do: [ :each |
		self assertRemovalsAreDetectedIn: each contents named: each basename ]
]

{ #category : 'tests - mutations' }
FamixOpenApiExistenceCorpusTest >> testStrayEntityAtAnyNodeOfARealDocumentIsDetected [

	self mutationFiles do: [ :each |
		self assertStraysAreDetectedIn: each contents named: each basename ]
]

{ #category : 'tests' }
FamixOpenApiExistenceCorpusTest >> testSyntheticEntitiesOfTheCorpusAreExactlyTheFrozenSet [

	| totals |
	totals := Bag new.
	self reports do: [ :each |
		each value syntheticCountsByRule keysAndValuesDo: [ :rule :count |
			totals add: rule withOccurrences: count ] ].
	self
		assert:
		(totals asSet collect: [ :rule |
			 rule -> (totals occurrencesOf: rule) ])
		equals:
			(self frozenSyntheticCounts collect: [ :row |
				 row first -> row second ]) asSet
]
