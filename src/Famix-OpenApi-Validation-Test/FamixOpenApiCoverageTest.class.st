"
Tests of FamixOpenApiCoverage, the table of what a value check compared: the counts per key, the totals, the merge of the tables of several files and the Markdown table with LF endings.
"
Class {
	#name : 'FamixOpenApiCoverageTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiCoverageTest >> coverage [
	"Two values compared for a, one of them not a default and one mismatch; one wrong type for b; one value without entity for c"

	^ FamixOpenApiCoverage new
		  recordCompared: 'a';
		  recordCompared: 'a';
		  recordInformative: 'a';
		  recordMismatch: 'a';
		  recordWrongType: 'b';
		  recordWithoutEntity: 'c';
		  yourself
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testACoverageThatOnlyIgnoredSiblingsIsNotEmpty [
	"Empty means that the check met nothing: no value compared, no wrong type, no field without entity, no ignored sibling (a mismatch is a value compared)"

	| coverage |
	coverage := FamixOpenApiCoverage new.
	self assert: coverage isEmpty.
	coverage recordIgnoredSibling: 'title'.
	self deny: coverage isEmpty
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testANewCoverageIsEmptyAndACoverageWithCountsIsNot [

	self assert: FamixOpenApiCoverage new isEmpty.
	self deny: self coverage isEmpty
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testIgnoredSiblingsAreCountedPerKeyAndMerged [

	| coverage total |
	coverage := FamixOpenApiCoverage new.
	coverage
		recordIgnoredSibling: 'title';
		recordIgnoredSibling: 'title';
		recordIgnoredSibling: 'x-a'.
	self assert: (coverage ignoredSiblingCountOf: 'title') equals: 2.
	self assert: (coverage ignoredSiblingCountOf: 'x-a') equals: 1.
	self assert: (coverage ignoredSiblingCountOf: 'other') equals: 0.
	self assert: coverage totalIgnoredSiblings equals: 3.
	self assert: coverage ignoredSiblingKeys equals: #( 'title' 'x-a' ).
	total := FamixOpenApiCoverage new.
	total mergeWith: coverage.
	total mergeWith: coverage.
	self assert: (total ignoredSiblingCountOf: 'title') equals: 4.
	self assert: total totalIgnoredSiblings equals: 6
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testMergingAddsTheCounts [

	| total |
	total := FamixOpenApiCoverage new.
	total mergeWith: self coverage.
	total mergeWith: self coverage.
	self assert: (total comparedCountOf: 'a') equals: 4.
	self assert: (total informativeCountOf: 'a') equals: 2.
	self assert: (total mismatchCountOf: 'a') equals: 2.
	self assert: (total wrongTypeCountOf: 'b') equals: 2.
	self assert: (total withoutEntityCountOf: 'c') equals: 2
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testTheCountsAreKeptPerKey [

	| coverage |
	coverage := self coverage.
	self assert: (coverage comparedCountOf: 'a') equals: 2.
	self assert: (coverage informativeCountOf: 'a') equals: 1.
	self assert: (coverage mismatchCountOf: 'a') equals: 1.
	self assert: (coverage wrongTypeCountOf: 'b') equals: 1.
	self assert: (coverage withoutEntityCountOf: 'c') equals: 1.
	self assert: (coverage comparedCountOf: 'b') equals: 0
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testTheKeysAreTheOnesWithACountSorted [

	self assert: self coverage sortedKeys equals: #( 'a' 'b' 'c' ).
	self assert: self coverage comparedKeys equals: #( 'a' )
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testTheMarkdownOfTheIgnoredSiblingsHasOneRowPerKeyAndLineFeeds [

	| markdown lf |
	lf := String with: Character lf.
	self
		assert: FamixOpenApiCoverage new markdownIgnoredSiblings
		equals: ''.
	markdown := (FamixOpenApiCoverage new
		             recordIgnoredSibling: 'title';
		             recordIgnoredSibling: 'title';
		             yourself) markdownIgnoredSiblings.
	self
		assert: markdown
		equals:
			'| Ignored sibling of $ref | Count |' , lf , '|---|---|' , lf
			, '| title | 2 |' , lf.
	self deny: (markdown includes: Character cr)
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testTheMarkdownTableHasOneRowPerKeyAndLineFeeds [

	| markdown |
	markdown := self coverage markdownTable.
	self assert: markdown lines size equals: 5.
	self assert:
		(markdown includesSubstring: '| a | 2 | 1 | 1 | 0 | 0 |').
	self assert:
		(markdown includesSubstring: '| b | 0 | 0 | 0 | 1 | 0 |').
	self assert:
		(markdown includesSubstring: '| c | 0 | 0 | 0 | 0 | 1 |').
	self deny: (markdown includes: Character cr)
]

{ #category : 'tests' }
FamixOpenApiCoverageTest >> testTheTotals [

	self assert: self coverage totalCompared equals: 2.
	self assert: self coverage totalInformative equals: 1.
	self assert: self coverage totalMismatched equals: 1
]
