"
I am the collection of FamixOpenApiDiagnostic owned by an importer. I am not part of the metamodel. I offer shortcuts to record errors, warnings and infos, and queries by severity, code and pointer.
"
Class {
	#name : 'FamixOpenApiDiagnostics',
	#superclass : 'Object',
	#instVars : [
		'diagnostics'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'adding' }
FamixOpenApiDiagnostics >> add: aDiagnostic [
	"Record aDiagnostic and answer it."

	^ diagnostics add: aDiagnostic
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> all [
	"Answer a copy of the recorded diagnostics, in recording order."

	^ diagnostics copy
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> atPointer: aString [
	"Answer the diagnostics concerning the node at aString."

	^ diagnostics select: [ :each | each pointer = aString ]
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> codes [
	"Answer the Set of the codes present."

	^ (diagnostics collect: #code) asSet
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> countOf: aCode [
	"Answer how many diagnostics have the code aCode."

	^ (self withCode: aCode) size
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> do: aBlock [
	"Evaluate aBlock on each diagnostic, in recording order."

	diagnostics do: aBlock
]

{ #category : 'adding' }
FamixOpenApiDiagnostics >> error: aCode pointer: aPointer message: aMessage [
	"Record and answer an error identified by the Symbol aCode."

	^ self add: (FamixOpenApiDiagnostic
			   severity: #error
			   code: aCode
			   pointer: aPointer
			   message: aMessage)
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> errors [
	"Answer the diagnostics of severity error."

	^ diagnostics select: #isError
]

{ #category : 'testing' }
FamixOpenApiDiagnostics >> hasErrors [
	"Answer whether some recorded diagnostic is an error."

	^ diagnostics anySatisfy: #isError
]

{ #category : 'adding' }
FamixOpenApiDiagnostics >> info: aCode pointer: aPointer message: aMessage [
	"Record and answer an information identified by the Symbol aCode."

	^ self add: (FamixOpenApiDiagnostic
			   severity: #info
			   code: aCode
			   pointer: aPointer
			   message: aMessage)
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> infos [
	"Answer the diagnostics of severity info."

	^ diagnostics select: #isInfo
]

{ #category : 'initialization' }
FamixOpenApiDiagnostics >> initialize [

	super initialize.
	diagnostics := OrderedCollection new
]

{ #category : 'testing' }
FamixOpenApiDiagnostics >> isEmpty [
	"Answer whether no diagnostic is recorded."

	^ diagnostics isEmpty
]

{ #category : 'testing' }
FamixOpenApiDiagnostics >> notEmpty [
	"Answer whether some diagnostic is recorded."

	^ diagnostics notEmpty
]

{ #category : 'printing' }
FamixOpenApiDiagnostics >> printOn: aStream [
	"Print the receiver with its size."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self size;
		nextPut: $)
]

{ #category : 'adding' }
FamixOpenApiDiagnostics >> reset [
	"Forget all recorded diagnostics."

	diagnostics removeAll
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> size [
	"Answer the number of recorded diagnostics."

	^ diagnostics size
]

{ #category : 'printing' }
FamixOpenApiDiagnostics >> summary [
	"Answer a short multi-line String with the counts per severity and per code."

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
		  self codes asSortedCollection do: [ :code |
			  stream
				  cr;
				  nextPutAll: code asString;
				  nextPutAll: ': ';
				  print: (self countOf: code) ] ]
]

{ #category : 'adding' }
FamixOpenApiDiagnostics >> warning: aCode pointer: aPointer message: aMessage [
	"Record and answer a warning identified by the Symbol aCode."

	^ self add: (FamixOpenApiDiagnostic
			   severity: #warning
			   code: aCode
			   pointer: aPointer
			   message: aMessage)
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> warnings [
	"Answer the diagnostics of severity warning."

	^ diagnostics select: #isWarning
]

{ #category : 'accessing' }
FamixOpenApiDiagnostics >> withCode: aSymbol [
	"Answer the diagnostics whose code is aSymbol."

	^ diagnostics select: [ :each | each code = aSymbol ]
]
