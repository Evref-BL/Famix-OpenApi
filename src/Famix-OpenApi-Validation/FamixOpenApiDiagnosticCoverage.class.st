"
What the diagnostics of an import say about the source document, indexed by pointer, for the extensions check (V9). I am built from any collection of objects that answer #code and #pointer (the diagnostics of the importer, but the package does not reference the importer) or from nil, which means that no diagnostics were given (#isDecidable is then false: whether a diagnostic covers a key cannot be known).
The class side holds, as data, what each code of the importer covers (#dataRows: code, ROLE, level of the pointer, note). The roles: #keyKept (the key is kept in the extensions: it excuses nothing, a key that is missing from the extensions stays lost), #siblingsIgnored (the keys beside a $ref, pointer of the node), #nodeDropped (the whole node is ignored, pointer of the node), #childrenDropped (the formData parameters of an operation, pointer of the operation), #valueRejected (the value of a key has the wrong JSON type, pointer of the key), #other (about something else than keys). Only the roles of #excusingRoles can make a lost key #ignoredByDiagnostic. All of it was VERIFIED by import experiments (see the test class FamixOpenApiDiagnosticCoverageTest).
"
Class {
	#name : 'FamixOpenApiDiagnosticCoverage',
	#superclass : 'Object',
	#instVars : [
		'byPointer',
		'decidable'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiDiagnosticCoverage class >> dataRows [
	"Rows: diagnostic code, role, what its pointer designates, note. VERIFIED by import experiments on 3.0, 3.1 and Swagger 2 documents (see FamixOpenApiDiagnosticCoverageTest)"

	^ #( #( #unmodelledKeyword #keyKept 'key' 'A key the metamodel has no slot for: the importer says it keeps it in the extensions. The pointer is the one of the key. It excuses nothing: a key that is not in the extensions stays lost' )
	     #( #unknownKeyword #keyKept 'key' 'A key that is not in the specification of the version: the importer says it keeps it in the extensions. The pointer is the one of the key. It excuses nothing' )
	     #( #refSiblingsIgnored #siblingsIgnored 'node' 'The keys beside the $ref of a schema (3.0 and Swagger 2), of a path item that resolves (3.0), and of an ALIAS in the components of a parameter, request body, response, header, link or example (3.0 and 3.1, together with componentAlias): the pointer is the one of the node, the message lists the keys. Nothing is said for the USE sites (a parameter, request body, response, header or link with a $ref and siblings inside an operation, 3.0 and 3.1: the siblings are lost without a diagnostic) nor for a path item that does not resolve' )
	     #( #extraBodyParameter #nodeDropped 'node' 'A body parameter of Swagger 2 that is not the first of its operation: the importer drops it. The pointer is the one of the parameter' )
	     #( #conflictingBodyAndFormData #childrenDropped 'operation'
	        'An operation of Swagger 2 with body and formData parameters: the importer drops the formData parameters (only them: the other parameters of the operation are kept, the path-level body and formData parameters are lost without a diagnostic). The pointer is the one of the operation' )
	     #( #wrongNodeType #valueRejected 'key' 'The value of a key has a JSON type that does not fit the field: the importer does not store it. The pointer is the one of the key. Not said for every field (a text for maximum or nullable is dropped without a diagnostic)' )
	     #( #discriminatorUnresolved #other 'node' 'About the mapping of a discriminator, not about keys' )
	     #( #componentAlias #other 'node' 'About an alias in the components (it comes with refSiblingsIgnored when the alias has siblings), not about keys itself' )
	     #( #unresolvedReference #other 'node' 'About the target of a $ref, it does not say what happens to the keys beside it' )
	     #( #securitySchemeUnresolved #other 'node' 'About a security requirement, not about keys' )
	     #( #operationIdMissing #other 'node' 'About the name of an operation, not about keys' )
	     #( #operationIdDuplicate #other 'node' 'About the name of an operation, not about keys' ) )
]

{ #category : 'accessing' }
FamixOpenApiDiagnosticCoverage class >> excusingRoles [
	"The roles of the diagnostics that tell what happens to a key that is not in the extensions"

	^ #( #siblingsIgnored #nodeDropped #childrenDropped #valueRejected )
]

{ #category : 'reporting' }
FamixOpenApiDiagnosticCoverage class >> markdownMapping [
	"A Markdown table: what each code of the importer covers. Lines end with LF"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll:
				  '| Code | Role | Pointer | Excuses a lost key | Note |';
			  lf;
			  nextPutAll: '|---|---|---|---|---|';
			  lf.
		  self dataRows do: [ :each |
			  stream
				  nextPutAll: '| ';
				  nextPutAll: each first;
				  nextPutAll: ' | ';
				  nextPutAll: each second;
				  nextPutAll: ' | ';
				  nextPutAll: each third;
				  nextPutAll: ' | ';
				  nextPutAll: ((self excusingRoles includes: each second)
						   ifTrue: [ 'yes' ]
						   ifFalse: [ 'no' ]);
				  nextPutAll: ' | ';
				  nextPutAll: each fourth;
				  nextPutAll: ' |';
				  lf ] ]
]

{ #category : 'instance creation' }
FamixOpenApiDiagnosticCoverage class >> on: aDiagnosticsOrNil [
	"The index of the diagnostics (objects that answer #code and #pointer); nil means that there are none to look at"

	^ self new
		  index: aDiagnosticsOrNil;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiDiagnosticCoverage class >> roleOf: aCode [
	"The role of the diagnostics of the code, #other for a code that is not in the data"

	^ self dataRows
		  detect: [ :each | each first = aCode ]
		  ifFound: [ :row | row second ]
		  ifNone: [ #other ]
]

{ #category : 'accessing' }
FamixOpenApiDiagnosticCoverage >> codesAt: aPointer role: aRole [
	"The codes of the diagnostics at the pointer whose role is aRole (an empty collection for none, or when no diagnostics were given)"

	^ (byPointer at: aPointer ifAbsent: [ #(  ) ]) select: [ :each |
		  (self class roleOf: each) = aRole ]
]

{ #category : 'accessing' }
FamixOpenApiDiagnosticCoverage >> index: aDiagnosticsOrNil [
	"Index the diagnostics by pointer: a pointer -> the collection of the codes said there"

	byPointer := Dictionary new.
	decidable := aDiagnosticsOrNil isNotNil.
	aDiagnosticsOrNil ifNil: [ ^ self ].
	aDiagnosticsOrNil do: [ :each |
		(byPointer at: each pointer ifAbsentPut: [ OrderedCollection new ])
			add: each code ]
]

{ #category : 'testing' }
FamixOpenApiDiagnosticCoverage >> isDecidable [
	"False when no diagnostics were given: whether a diagnostic covers a key cannot be known"

	^ decidable
]
