"
The ordered collection of FamixOpenApiFinding answered by a model validation run. Its protocol mirrors the importer's FamixOpenApiDiagnostics (add:, errors, warnings, infos, withCode:, atPointer:, summary, ...) without depending on it, and adds queries by entity and a Markdown rendering. A finding set is plain data: it never touches the validated model.
"
Class {
	#name : 'FamixOpenApiFindings',
	#superclass : 'Object',
	#instVars : [
		'findings'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'adding' }
FamixOpenApiFindings >> add: aFinding [
	"Record aFinding and answer it."

	findings add: aFinding.
	^ aFinding
]

{ #category : 'adding' }
FamixOpenApiFindings >> addAll: aCollectionOfFindings [
	"Record each finding of aCollectionOfFindings, in order."

	findings addAll: aCollectionOfFindings
]

{ #category : 'enumerating' }
FamixOpenApiFindings >> all [
	"Answer a copy of the recorded findings, in recording order."

	^ findings copy
]

{ #category : 'querying' }
FamixOpenApiFindings >> atPointer: aString [
	"Answer the findings concerning the node at aString."

	^ findings select: [ :each | each pointer = aString ]
]

{ #category : 'querying' }
FamixOpenApiFindings >> codes [
	"Answer the Set of the codes present."

	^ (findings collect: #code) asSet
]

{ #category : 'enumerating' }
FamixOpenApiFindings >> collect: aBlock [
	"Answer an OrderedCollection of the results of aBlock on each finding."

	^ findings collect: aBlock
]

{ #category : 'enumerating' }
FamixOpenApiFindings >> count: aBlock [
	"Answer how many findings satisfy aBlock."

	^ findings count: aBlock
]

{ #category : 'querying' }
FamixOpenApiFindings >> countOf: aCode [
	"Answer how many findings have the code aCode."

	^ (self withCode: aCode) size
]

{ #category : 'printing' }
FamixOpenApiFindings >> countsByCodeAndSeverity [
	"Answer a sorted Array of Associations 'code (severity)' -> number of findings."

	| counts |
	counts := Dictionary new.
	findings do: [ :each |
		counts
			at: (self labelOf: each)
			put: (counts at: (self labelOf: each) ifAbsent: [ 0 ]) + 1 ].
	^ counts associations sorted: [ :a :b | a key <= b key ]
]

{ #category : 'enumerating' }
FamixOpenApiFindings >> detect: aBlock ifNone: noneBlock [
	"Answer the first finding satisfying aBlock, or the value of noneBlock."

	^ findings detect: aBlock ifNone: noneBlock
]

{ #category : 'enumerating' }
FamixOpenApiFindings >> do: aBlock [
	"Evaluate aBlock on each finding, in recording order."

	findings do: aBlock
]

{ #category : 'querying' }
FamixOpenApiFindings >> errors [
	"Answer the findings of severity error."

	^ findings select: #isError
]

{ #category : 'querying' }
FamixOpenApiFindings >> forEntity: anEntity [
	"Answer the findings concerning anEntity itself."

	^ findings select: [ :each | each entity == anEntity ]
]

{ #category : 'querying' }
FamixOpenApiFindings >> hasErrors [
	"Answer whether some recorded finding is an error."

	^ findings anySatisfy: #isError
]

{ #category : 'querying' }
FamixOpenApiFindings >> hasWarnings [
	"Answer whether some recorded finding is a warning."

	^ findings anySatisfy: #isWarning
]

{ #category : 'querying' }
FamixOpenApiFindings >> infos [
	"Answer the findings of severity info."

	^ findings select: #isInfo
]

{ #category : 'initialization' }
FamixOpenApiFindings >> initialize [

	super initialize.
	findings := OrderedCollection new
]

{ #category : 'querying' }
FamixOpenApiFindings >> isEmpty [
	"Answer whether no finding is recorded."

	^ findings isEmpty
]

{ #category : 'printing' }
FamixOpenApiFindings >> labelOf: aFinding [

	^ aFinding code asString , ' (' , aFinding severity asString , ')'
]

{ #category : 'printing' }
FamixOpenApiFindings >> markdownSummary [
	"Answer a Markdown String (LF line endings) with the counts and one table row per finding."

	^ String streamContents: [ :stream |
		  self writeMarkdownCountsOn: stream.
		  findings isEmpty
			  ifTrue: [
				  stream
					  nextPutAll: 'No finding.';
					  lf ]
			  ifFalse: [ self writeMarkdownTableOn: stream ] ]
]

{ #category : 'querying' }
FamixOpenApiFindings >> notEmpty [
	"Answer whether some finding is recorded."

	^ findings notEmpty
]

{ #category : 'printing' }
FamixOpenApiFindings >> printOn: aStream [
	"Print the receiver with its size."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self size;
		nextPut: $)
]

{ #category : 'enumerating' }
FamixOpenApiFindings >> select: aBlock [
	"Answer an OrderedCollection of the findings satisfying aBlock."

	^ findings select: aBlock
]

{ #category : 'accessing' }
FamixOpenApiFindings >> size [
	"Answer the number of recorded findings."

	^ findings size
]

{ #category : 'printing' }
FamixOpenApiFindings >> summary [
	"Answer a short multi-line String with the counts per severity and per code with its severity."

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: 'errors: ';
			  print: self errors size;
			  cr;
			  nextPutAll: 'warnings: ';
			  print: self warnings size;
			  cr;
			  nextPutAll: 'infos: ';
			  print: self infos size.
		  self countsByCodeAndSeverity do: [ :each |
			  stream
				  cr;
				  nextPutAll: each key;
				  nextPutAll: ': ';
				  print: each value ] ]
]

{ #category : 'querying' }
FamixOpenApiFindings >> warnings [
	"Answer the findings of severity warning."

	^ findings select: #isWarning
]

{ #category : 'querying' }
FamixOpenApiFindings >> withCode: aSymbol [
	"Answer the findings whose code is aSymbol."

	^ findings select: [ :each | each code = aSymbol ]
]

{ #category : 'printing' }
FamixOpenApiFindings >> writeMarkdownCountsOn: aStream [

	aStream
		nextPutAll: '# Validation findings';
		lf;
		lf.
	#( 'errors' 'warnings' 'infos' )
		with: {
				self errors size.
				self warnings size.
				self infos size }
		do: [ :label :count |
			aStream
				nextPutAll: '- ';
				nextPutAll: label;
				nextPutAll: ': ';
				print: count;
				lf ].
	aStream lf
]

{ #category : 'printing' }
FamixOpenApiFindings >> writeMarkdownRowOf: aFinding on: aStream [

	| cells |
	cells := {
		         aFinding severity asString.
		         aFinding code asString.
		         aFinding pointer.
		         aFinding message }.
	aStream nextPutAll: '|'.
	cells do: [ :cell |
		aStream
			nextPut: Character space;
			nextPutAll: (cell asString copyReplaceAll: '|' with: '\|');
			nextPutAll: ' |' ].
	aStream lf
]

{ #category : 'printing' }
FamixOpenApiFindings >> writeMarkdownTableOn: aStream [

	aStream
		nextPutAll: '| Severity | Code | Pointer | Message |';
		lf;
		nextPutAll: '|---|---|---|---|';
		lf.
	findings do: [ :each | self writeMarkdownRowOf: each on: aStream ]
]
