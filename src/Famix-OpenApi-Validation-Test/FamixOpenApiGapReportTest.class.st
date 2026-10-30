"
Tests of FamixOpenApiGap (the value object) and FamixOpenApiGapReport (the collection, its counts and its summaries).
"
Class {
	#name : 'FamixOpenApiGapReportTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures' }
FamixOpenApiGapReportTest >> gapOfKind: aKind at: aPointer spec: aSpecObjectName [

	^ (FamixOpenApiGap
		   kind: aKind
		   pointer: aPointer
		   specObject: aSpecObjectName)
		  message: 'm';
		  yourself
]

{ #category : 'fixtures' }
FamixOpenApiGapReportTest >> sampleReport [

	| report |
	report := FamixOpenApiGapReport new.
	report add: (self gapOfKind: #missingEntity at: '#/a' spec: 'Info').
	report add: (self gapOfKind: #missingEntity at: '#/b' spec: 'Info').
	report add: (self gapOfKind: #extraEntity at: '#/c' spec: nil).
	report add: (self gapOfKind: #wrongClass at: '#/d' spec: 'Schema').
	report recordNode: 'Info' expected: 1 found: 0.
	report recordNode: 'Info' expected: 1 found: 1.
	report recordNode: 'Paths' expected: 0 found: 0.
	report recordSynthetic: #synthesizedServer.
	^ report
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testCountsByKindAreSortedByKind [

	| counts |
	counts := self sampleReport countsByKind.
	self
		assert: counts keys
		equals: #( #extraEntity #missingEntity #wrongClass ).
	self assert: (counts at: #missingEntity) equals: 2.
	self assert: (counts at: #extraEntity) equals: 1
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testCountsBySpecObjectCountsTheGapsWithoutNodeUnderADash [

	| counts |
	counts := self sampleReport countsBySpecObject.
	self assert: (counts at: 'Info') equals: 2.
	self assert: (counts at: 'Schema') equals: 1.
	self assert: (counts at: '-') equals: 1
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testEmptyReport [

	| report |
	report := FamixOpenApiGapReport new.
	self assert: report isEmpty.
	self assert: report gaps isEmpty.
	self assert: report countsByKind isEmpty.
	self assert: report size equals: 0
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testFileOfTheReportIsStampedOnTheGapsWithoutOne [

	| report own |
	report := FamixOpenApiGapReport new
		          file: 'a.json';
		          yourself.
	report add: (self gapOfKind: #missingEntity at: '#/a' spec: 'Info').
	own := (self gapOfKind: #missingEntity at: '#/b' spec: 'Info')
		       file: 'b.json';
		       yourself.
	report add: own.
	self assert: report gaps first file equals: 'a.json'.
	self assert: report gaps last file equals: 'b.json'
]

{ #category : 'tests - gap' }
FamixOpenApiGapReportTest >> testGapKeepsItsFields [

	| entity gap |
	entity := OPInfo new.
	gap := (FamixOpenApiGap
		        kind: #wrongClass
		        pointer: '#/info'
		        specObject: 'Info')
		       entity: entity;
		       fieldKey: 'title';
		       expected: 'OPInfo';
		       found: 'OPTag';
		       message: 'm';
		       file: 'f.json';
		       yourself.
	self assert: gap kind equals: #wrongClass.
	self assert: gap sourcePointer equals: '#/info'.
	self assert: gap specObject equals: 'Info'.
	self assert: gap entity identicalTo: entity.
	self assert: gap fieldKey equals: 'title'.
	self assert: gap expected equals: 'OPInfo'.
	self assert: gap found equals: 'OPTag'.
	self assert: gap message equals: 'm'.
	self assert: gap file equals: 'f.json'
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testGapsOfKindSelectsTheKind [

	| report |
	report := self sampleReport.
	self deny: report isEmpty.
	self assert: report size equals: 4.
	self assert: (report gapsOfKind: #missingEntity) size equals: 2.
	self
		assert: ((report gapsOfKind: #extraEntity) collect: #sourcePointer)
		equals: #( '#/c' ) asOrderedCollection.
	self assert: (report gapsOfKind: #lost) isEmpty
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testMarkdownSummaryHasTablesAndGapListWithLfOnly [

	| markdown |
	markdown := self sampleReport markdownSummary.
	self assert: (markdown includesSubstring: '| Kind | Gaps |').
	self assert: (markdown includesSubstring: '| missingEntity | 2 |').
	self assert: (markdown includesSubstring: '| Info | 2 | 2 | 1 |').
	self assert: (markdown includesSubstring: 'Gaps (4):').
	self assert:
		(markdown includesSubstring: '- `#/a` missingEntity Info: m').
	self assert: (markdown includes: Character lf).
	self deny: (markdown includes: Character cr)
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testMarkdownSummaryOfAnEmptyReportHasNoGapList [

	| markdown |
	markdown := FamixOpenApiGapReport new markdownSummary.
	self deny: (markdown includesSubstring: 'Gaps (')
]

{ #category : 'tests - gap' }
FamixOpenApiGapReportTest >> testNewGapHasNoEntityNoFieldAndNoFile [

	| gap |
	gap := self gapOfKind: #missingEntity at: '#/a' spec: 'Info'.
	self assert: gap entity isNil.
	self assert: gap fieldKey isNil.
	self assert: gap file isNil.
	self assert: (gap printString includesSubstring: '#/a')
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testStatisticsPerSpecObject [

	| report |
	report := self sampleReport.
	self assert: (report nodeCountsBySpecObject at: 'Info') equals: 2.
	self assert: (report expectedCountsBySpecObject at: 'Info') equals: 2.
	self assert: (report foundCountsBySpecObject at: 'Info') equals: 1.
	self assert: (report nodeCountsBySpecObject at: 'Paths') equals: 1.
	self
		assert: (report expectedCountsBySpecObject at: 'Paths')
		equals: 0.
	self
		assert: (report syntheticCountsByRule at: #synthesizedServer)
		equals: 1
]

{ #category : 'tests - report' }
FamixOpenApiGapReportTest >> testSummaryIsPlainTextWithLfLines [

	| summary |
	summary := self sampleReport summary.
	self assert: (summary includesSubstring: 'gaps: 4').
	self assert: (summary includesSubstring: 'missingEntity: 2').
	self assert: (summary includesSubstring:
			 'Info: nodes 2, entities expected 2, found 1').
	self deny: (summary includes: Character cr)
]
