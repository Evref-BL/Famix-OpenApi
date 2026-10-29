"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiFindingsTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiFindingsTest >> findingSeverity: aSeverity code: aCode entity: anEntity [

	^ FamixOpenApiFinding
		  severity: aSeverity
		  code: aCode
		  entity: anEntity
		  message: 'message of ' , aCode
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> mixedFindings [
	"Answer findings: an error and a warning on a schema pointing at #/s, an info and another error without entity."

	| findings schema |
	schema := OPSchema new.
	schema canonicalPointer: '#/s'.
	findings := FamixOpenApiFindings new.
	findings add: (self findingSeverity: #error code: #a entity: schema).
	findings add:
		(self findingSeverity: #warning code: #b entity: schema).
	findings add: (self findingSeverity: #info code: #a entity: nil).
	findings add: (self findingSeverity: #error code: #a entity: nil).
	^ findings
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testAddAll [

	| findings |
	findings := FamixOpenApiFindings new.
	findings addAll: self mixedFindings all.
	self assert: findings size equals: 4
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testAddKeepsTheFindingsInOrder [

	| findings first second |
	findings := FamixOpenApiFindings new.
	first := self findingSeverity: #error code: #a entity: nil.
	second := self findingSeverity: #info code: #b entity: nil.
	findings add: first.
	findings add: second.
	self assert: findings size equals: 2.
	self assert: findings all first identicalTo: first.
	self assert: findings all last identicalTo: second
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testAllAnswersACopy [

	| findings |
	findings := self mixedFindings.
	findings all removeAll.
	self assert: findings size equals: 4
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testAtPointer [

	| findings |
	findings := self mixedFindings.
	self assert: (findings atPointer: '#/s') size equals: 2.
	self assert: (findings atPointer: '') size equals: 2
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testDoEvaluatesTheBlockInRecordingOrder [

	| codes |
	codes := Array streamContents: [ :stream |
		         self mixedFindings do: [ :each | stream nextPut: each code ] ].
	self assert: codes equals: #( #a #b #a #a )
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testEnumeration [

	| findings |
	findings := self mixedFindings.
	self
		assert: (findings collect: #code) asArray
		equals: #( #a #b #a #a ).
	self assert: (findings count: #isError) equals: 2.
	self assert: (findings select: #isWarning) first code equals: #b.
	self
		assert: (findings detect: #isInfo ifNone: [ nil ]) code
		equals: #a.
	self
		assert:
		(findings detect: [ :each | each code = #zzz ] ifNone: [ #none ])
		equals: #none
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testForEntity [

	| findings entity |
	findings := self mixedFindings.
	entity := findings all first entity.
	self assert: (findings forEntity: entity) size equals: 2.
	self assert: (findings forEntity: OPSchema new) isEmpty
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testMarkdownEscapesPipes [

	| findings |
	findings := FamixOpenApiFindings new.
	findings add: (FamixOpenApiFinding
			 severity: #info
			 code: #c
			 entity: nil
			 message: 'a|b').
	self assert: (findings markdownSummary includesSubstring: 'a\|b')
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testMarkdownSummaryOfNoFinding [

	self
		assert: FamixOpenApiFindings new markdownSummary
		equals: (String streamContents: [ :stream |
				 stream
					 nextPutAll: '# Validation findings';
					 lf;
					 lf;
					 nextPutAll: '- errors: 0';
					 lf;
					 nextPutAll: '- warnings: 0';
					 lf;
					 nextPutAll: '- infos: 0';
					 lf;
					 lf;
					 nextPutAll: 'No finding.';
					 lf ])
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testMarkdownSummaryUsesLineFeedsOnly [

	| markdown |
	markdown := self mixedFindings markdownSummary.
	self deny: (markdown includes: Character cr).
	self assert: (markdown includesSubstring: '- errors: 2').
	self assert:
		(markdown includesSubstring:
			 '| Severity | Code | Pointer | Message |').
	self assert:
		(markdown includesSubstring: '| warning | b | #/s | message of b |').
	self assert: (markdown occurrencesOf: Character lf) > 8
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testNewIsEmpty [

	| findings |
	findings := FamixOpenApiFindings new.
	self assert: findings isEmpty.
	self deny: findings notEmpty.
	self deny: findings hasErrors.
	self deny: findings hasWarnings.
	self assert: findings size equals: 0
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testPrintOnShowsTheSize [

	self
		assert: self mixedFindings printString
		equals: 'a FamixOpenApiFindings(4)'
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testSeverityQueries [

	| findings |
	findings := self mixedFindings.
	self assert: findings errors size equals: 2.
	self assert: findings warnings size equals: 1.
	self assert: findings infos size equals: 1.
	self assert: findings hasErrors.
	self assert: findings hasWarnings
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testSummaryCountsPerSeverityAndCode [

	self
		assert: self mixedFindings summary
		equals:
			'errors: 2' , String cr , 'warnings: 1' , String cr , 'infos: 1'
			, String cr , 'a (error): 2' , String cr , 'a (info): 1'
			, String cr , 'b (warning): 1'
]

{ #category : 'tests' }
FamixOpenApiFindingsTest >> testWithCodeAndCountOf [

	| findings |
	findings := self mixedFindings.
	self assert: (findings withCode: #a) size equals: 3.
	self assert: (findings countOf: #b) equals: 1.
	self assert: (findings withCode: #zzz) isEmpty.
	self assert: findings codes equals: #( #a #b ) asSet
]
