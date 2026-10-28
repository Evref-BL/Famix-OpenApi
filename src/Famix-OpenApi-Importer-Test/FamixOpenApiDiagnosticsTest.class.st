"
Tests for FamixOpenApiDiagnostic (value object) and FamixOpenApiDiagnostics (collector).
"
Class {
	#name : 'FamixOpenApiDiagnosticsTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagnostics'
	],
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> setUp [

	super setUp.
	diagnostics := FamixOpenApiDiagnostics new
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testAddStoresGivenDiagnostic [

	| d |
	d := FamixOpenApiDiagnostic
		     severity: #warning
		     code: #x
		     pointer: '#/p'
		     message: 'm'.
	diagnostics add: d.
	self assert: diagnostics size equals: 1 description: 'One diagnostic'.
	self
		assert: diagnostics all first
		equals: d
		description: 'Same diagnostic'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testAllAnswersACopy [

	diagnostics error: #a pointer: '#' message: 'm'.
	diagnostics all removeAll.
	self
		assert: diagnostics size
		equals: 1
		description: 'Mutating all does not alter the collector'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testAtPointerFiltersByPointer [

	diagnostics
		error: #a pointer: '#/x' message: 'm';
		warning: #b pointer: '#/x' message: 'm';
		warning: #c pointer: '#/y' message: 'm'.
	self
		assert: (diagnostics atPointer: '#/x') size
		equals: 2
		description: 'Two at #/x'.
	self
		assert: (diagnostics atPointer: '#/z') isEmpty
		description: 'None at unknown pointer'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testCodesContainsEveryUsedCode [

	diagnostics
		error: #a pointer: '#/1' message: 'm';
		warning: #b pointer: '#/2' message: 'm'.
	self
		assert: (diagnostics codes includes: #a)
		description: 'Contains #a'.
	self
		assert: (diagnostics codes includes: #b)
		description: 'Contains #b'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testCountOfCode [

	diagnostics
		error: #dup pointer: '#/1' message: 'm';
		error: #dup pointer: '#/2' message: 'm';
		error: #other pointer: '#/3' message: 'm'.
	self
		assert: (diagnostics countOf: #dup)
		equals: 2
		description: 'countOf: dup'.
	self
		assert: (diagnostics countOf: #none)
		equals: 0
		description: 'countOf: unknown'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testDiagnosticEqualityOnFourFields [

	| a b |
	a := FamixOpenApiDiagnostic
		     severity: #error
		     code: #c
		     pointer: '#/p'
		     message: 'm'.
	b := FamixOpenApiDiagnostic
		     severity: #error
		     code: #c
		     pointer: '#/p'
		     message: 'm'.
	self assert: a equals: b description: 'Same fields are equal'.
	self
		assert: a hash
		equals: b hash
		description: 'Equal objects have equal hash'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testDiagnosticPrintOnContainsAllFields [

	| text |
	text := (FamixOpenApiDiagnostic
		         severity: #warning
		         code: #someCode
		         pointer: '#/some/pointer'
		         message: 'some message') printString.
	#( 'warning' 'someCode' '#/some/pointer' 'some message' ) do: [ :each |
		self
			assert: (text includesSubstring: each)
			description: 'printString contains ' , each , ': ' , text ]
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testDiagnosticsDifferingInOneFieldAreNotEqual [

	| a |
	a := FamixOpenApiDiagnostic
		     severity: #error
		     code: #c
		     pointer: '#/p'
		     message: 'm'.
	self
		deny: a = (FamixOpenApiDiagnostic
				 severity: #warning
				 code: #c
				 pointer: '#/p'
				 message: 'm')
		description: 'severity differs'.
	self
		deny: a = (FamixOpenApiDiagnostic
				 severity: #error
				 code: #d
				 pointer: '#/p'
				 message: 'm')
		description: 'code differs'.
	self
		deny: a = (FamixOpenApiDiagnostic
				 severity: #error
				 code: #c
				 pointer: '#/q'
				 message: 'm')
		description: 'pointer differs'.
	self
		deny: a = (FamixOpenApiDiagnostic
				 severity: #error
				 code: #c
				 pointer: '#/p'
				 message: 'n')
		description: 'message differs'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testDoIteratesInInsertionOrder [

	| codes |
	diagnostics
		error: #first pointer: '#' message: 'm';
		warning: #second pointer: '#' message: 'm'.
	codes := OrderedCollection new.
	diagnostics do: [ :each | codes add: each code ].
	self
		assert: codes asArray
		equals: #( #first #second )
		description: 'Insertion order'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testErrorShortcutSetsSeverityCodePointerMessage [

	| d |
	diagnostics error: #badRef pointer: '#/a' message: 'broken'.
	d := diagnostics all first.
	self assert: d severity equals: #error description: 'severity'.
	self assert: d code equals: #badRef description: 'code'.
	self assert: d pointer equals: '#/a' description: 'pointer'.
	self assert: d message equals: 'broken' description: 'message'.
	self assert: d isError description: 'isError'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testHasErrorsOnlyForErrors [

	diagnostics warning: #w pointer: '#' message: 'm'.
	self
		deny: diagnostics hasErrors
		description: 'Warning is not an error'.
	diagnostics error: #e pointer: '#' message: 'm'.
	self assert: diagnostics hasErrors description: 'Error present'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testInfoShortcutSetsSeverity [

	| d |
	diagnostics info: #i pointer: '#/c' message: 'fyi'.
	d := diagnostics all first.
	self assert: d severity equals: #info description: 'severity'.
	self assert: d isInfo description: 'isInfo'.
	self deny: d isWarning description: 'not warning'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testNewCollectorIsEmpty [

	self
		assert: diagnostics isEmpty
		description: 'Fresh collector is empty'.
	self
		deny: diagnostics notEmpty
		description: 'Fresh collector is not notEmpty'.
	self assert: diagnostics size equals: 0 description: 'Size is 0'.
	self deny: diagnostics hasErrors description: 'No errors'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testResetEmptiesCollector [

	diagnostics error: #a pointer: '#' message: 'm'.
	diagnostics reset.
	self assert: diagnostics isEmpty description: 'Empty after reset'.
	self deny: diagnostics hasErrors description: 'No errors after reset'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testSeverityFilters [

	diagnostics
		error: #e1 pointer: '#/1' message: 'm';
		error: #e2 pointer: '#/2' message: 'm';
		warning: #w1 pointer: '#/3' message: 'm';
		info: #i1 pointer: '#/4' message: 'm'.
	self assert: diagnostics errors size equals: 2 description: 'errors'.
	self
		assert: diagnostics warnings size
		equals: 1
		description: 'warnings'.
	self assert: diagnostics infos size equals: 1 description: 'infos'.
	self assert: diagnostics size equals: 4 description: 'size'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testSummaryMentionsCountsAndCodes [

	| summary |
	diagnostics
		error: #brokenRef pointer: '#/1' message: 'm';
		error: #brokenRef pointer: '#/2' message: 'm';
		warning: #oddThing pointer: '#/3' message: 'm'.
	summary := diagnostics summary.
	self
		assert: (summary includesSubstring: 'brokenRef')
		description: 'Mentions code brokenRef: ' , summary.
	self
		assert: (summary includesSubstring: 'oddThing')
		description: 'Mentions code oddThing: ' , summary.
	self
		assert: (summary includesSubstring: '2')
		description: 'Mentions count 2: ' , summary.
	self
		assert: (summary includesSubstring: 'error')
		description: 'Mentions error severity: ' , summary.
	self
		assert: (summary includesSubstring: 'warning')
		description: 'Mentions warning severity: ' , summary
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testSummaryOfEmptyCollectorIsAString [

	self
		assert: diagnostics summary isString
		description: 'Summary is a String even when empty'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testWarningShortcutSetsSeverity [

	| d |
	diagnostics warning: #w pointer: '#/b' message: 'careful'.
	d := diagnostics all first.
	self assert: d severity equals: #warning description: 'severity'.
	self assert: d code equals: #w description: 'code'.
	self assert: d isWarning description: 'isWarning'.
	self deny: d isError description: 'not error'
]

{ #category : 'tests' }
FamixOpenApiDiagnosticsTest >> testWithCodeFiltersByCode [

	diagnostics
		error: #dup pointer: '#/1' message: 'm';
		warning: #dup pointer: '#/2' message: 'm';
		warning: #other pointer: '#/3' message: 'm'.
	self
		assert: (diagnostics withCode: #dup) size
		equals: 2
		description: 'Two with code dup'.
	self
		assert: (diagnostics withCode: #none) isEmpty
		description: 'None with unknown code'
]
