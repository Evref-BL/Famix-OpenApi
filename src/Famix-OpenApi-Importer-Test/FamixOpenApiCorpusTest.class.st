"
Imports every *.json file of the external corpus folder (outside the repository, never committed: see SOURCES.txt there) and checks the model against counts computed independently from the raw JSON with NeoJSON. One test method per kind of assertion, each iterating over the files and naming the failing files. All the tests are skipped when the corpus folder is absent.
"
Class {
	#name : 'FamixOpenApiCorpusTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> assertNoFailuresIn: aCollection description: aString [

	self
		assert: aCollection isEmpty
		description: aString , ': ' , (', ' join: aCollection)
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> corpusDirectory [
	"The folder holding the external spec files (outside the repository)."

	^ '/Users/nicolas.hlad/Documents/Pharo/images/openapi-vibe/test-corpus/'
		  asFileReference
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> corpusFiles [
	"Answer the *.json files of the corpus, sorted by name; skip the running test when the corpus folder is absent."

	| directory |
	directory := self corpusDirectory.
	directory exists ifFalse: [
		self skip: 'Missing corpus folder ' , directory fullName ].
	^ (directory files select: [ :each | each extension = 'json' ])
		  sorted: [ :a :b | a basename <= b basename ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> failingFilesAmong: aFileCollection that: aBlock [
	"Answer the names of the files (with a reason when aBlock answers a String) for which aBlock answers false or a String. aBlock receives the file, its importer and its raw document; files that are not specs or whose import raised are not given to aBlock."

	^ aFileCollection
		  collect: [ :file |
			  | importer raw verdict |
			  raw := self rawDocumentOf: file.
			  importer := self importFile: file.
			  ((self isSpecDocument: raw) and: [
				   importer isKindOf: FamixOpenApiImporter ])
				  ifTrue: [
					  verdict := aBlock value: file value: importer value: raw.
					  verdict == true ifFalse: [
						  file basename , ' ' , verdict asString ] ]
				  ifFalse: [ nil ] ]
		  thenSelect: [ :each | each isNotNil ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> importFile: aFile [
	"Import aFile with a fresh importer. Answer the importer, or the raised exception when the import raised."

	| importer |
	importer := FamixOpenApiImporter new.
	^ [
	  importer importFromString: aFile contents.
	  importer ]
		  on: Error
		  do: [ :error | error ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> isSpecDocument: aRawDocument [
	"A file is an API description when it is a JSON object with a swagger or openapi key."

	^ aRawDocument isDictionary and: [
		  (aRawDocument includesKey: 'swagger') or: [
			  aRawDocument includesKey: 'openapi' ] ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> isSwagger2: aRawDocument [

	^ aRawDocument isDictionary and: [
		  aRawDocument includesKey: 'swagger' ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> modelOperationCountOf: anImporter verb: aVerb [

	^ anImporter openApi operations count: [ :each |
		  each httpMethod asLowercase = aVerb ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> modelSchemaCountOf: anImporter [

	^ anImporter openApi components
		  ifNil: [ 0 ]
		  ifNotNil: [ :components | components schemas size ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> rawDocumentOf: aFile [
	"Answer the Smalltalk value of the JSON text of aFile, read with NeoJSON independently of the importer, or nil when it is not JSON."

	^ [ NeoJSONReader fromString: aFile contents ]
		  on: Error
		  do: [ :error | nil ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> rawOperationCountOf: aRawDocument verb: aVerb [
	"Count the path items of the raw document that declare an operation (an object) for aVerb."

	^ (self rawPathItemsOf: aRawDocument) count: [ :item |
		  item isDictionary and: [
			  (item at: aVerb ifAbsent: [ nil ]) isDictionary ] ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> rawPathItemsOf: aRawDocument [
	"Answer the path items of the raw document: the entries of paths whose key is not an extension."

	| paths |
	paths := aRawDocument at: 'paths' ifAbsent: [ Dictionary new ].
	paths isDictionary ifFalse: [ ^ Dictionary new ].
	^ paths associations
		  select: [ :each | (each key beginsWith: 'x-') not ]
		  thenCollect: [ :each | each value ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> rawSchemaCountOf: aRawDocument [
	"The number of component schemas: components.schemas (3.x) or definitions (Swagger 2)."

	| schemas |
	schemas := (self isSwagger2: aRawDocument)
		           ifTrue: [
		           aRawDocument at: 'definitions' ifAbsent: [ nil ] ]
		           ifFalse: [
			           (aRawDocument
				            at: 'components'
				            ifAbsent: [ Dictionary new ])
				           at: 'schemas'
				           ifAbsent: [ nil ] ].
	^ schemas isDictionary
		  ifTrue: [ schemas size ]
		  ifFalse: [ 0 ]
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> rawVerbs [

	^ #( 'get' 'put' 'post' 'delete' 'options' 'head' 'patch' 'trace' )
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> specFiles: aBoolean [
	"Answer the corpus files that are Swagger 2 descriptions (aBoolean true) or OpenAPI 3 descriptions (false)."

	^ self corpusFiles select: [ :file |
		  | raw |
		  raw := self rawDocumentOf: file.
		  (self isSpecDocument: raw) and: [
			  (self isSwagger2: raw) = aBoolean ] ]
]

{ #category : 'tests' }
FamixOpenApiCorpusTest >> testComponentSchemaCountMatchesRawCount [
	"components.schemas (OpenAPI 3) or definitions (Swagger 2): one component schema entity per raw entry."

	| failures |
	failures := self
		            failingFilesAmong: self corpusFiles
		            that: [ :file :importer :raw |
			            | expected actual |
			            expected := self rawSchemaCountOf: raw.
			            actual := self modelSchemaCountOf: importer.
			            expected = actual
				            ifTrue: [ true ]
				            ifFalse: [
				            'raw ' , expected printString , ' vs model '
				            , actual printString ] ].
	self
		assertNoFailuresIn: failures
		description: 'Files whose component schema count differs'
]

{ #category : 'tests' }
FamixOpenApiCorpusTest >> testEveryFileImportsWithoutRaising [
	"The importer never raises, whatever the file contains."

	| failures |
	failures := self corpusFiles
		            collect: [ :file |
			            | outcome |
			            outcome := self importFile: file.
			            (outcome isKindOf: FamixOpenApiImporter)
				            ifTrue: [ nil ]
				            ifFalse: [
					            file basename , ' raised ' , outcome class name
					            , ': ' , outcome messageText asString ] ]
		            thenSelect: [ :each | each isNotNil ].
	self
		assertNoFailuresIn: failures
		description: 'Files whose import raised'
]

{ #category : 'tests' }
FamixOpenApiCorpusTest >> testEveryImportHasNoErrorDiagnostics [
	"The diagnostics of an import never hold an error severity item (warnings and infos are accepted); the errors are listed in the failure message."

	| failures |
	failures := self
		            failingFilesAmong: self corpusFiles
		            that: [ :file :importer :raw |
			            importer diagnostics errors isEmpty
				            ifTrue: [ true ]
				            ifFalse: [
					            String streamContents: [ :stream |
						            stream nextPutAll: 'errors: '.
						            importer diagnostics errors
							            do: [ :each | stream print: each ]
							            separatedBy: [ stream nextPutAll: ' ; ' ] ] ] ].
	self
		assertNoFailuresIn: failures
		description: 'Files with error diagnostics'
]

{ #category : 'tests' }
FamixOpenApiCorpusTest >> testEverySpecFileHasADocumentModel [
	"Every file that is an API description yields an OpenApi entity."

	| failures |
	failures := self
		            failingFilesAmong: self corpusFiles
		            that: [ :file :importer :raw |
		            importer openApi isNotNil ].
	self
		assertNoFailuresIn: failures
		description: 'Files without a document model'
]

{ #category : 'tests' }
FamixOpenApiCorpusTest >> testNoEntityIsUnnamedExceptTheOptionalOnesWithAndWithoutMerging [
	"N6 sweep on every corpus file, merging the inline schemas or not: an entity without a name is only an OPContact, OPLicense, OPTag or OPXmlElement (naturally optional names). The failure message lists, per file, the classes that still have nil or blank names."

	| offenders |
	offenders := OrderedCollection new.
	self corpusFiles do: [ :file |
		#( true false ) do: [ :merging |
			| classNames |
			classNames := self
				              unexpectedlyUnnamedClassNamesOf: file
				              merging: merging.
			classNames isEmpty ifFalse: [
				offenders add: (String streamContents: [ :stream |
						 stream
							 nextPutAll: file basename;
							 nextPutAll: ' merging=';
							 print: merging;
							 space;
							 print: classNames ]) ] ] ].
	self
		assertNoFailuresIn: offenders
		description: 'Files with unnamed entities'
]

{ #category : 'tests (step B)' }
FamixOpenApiCorpusTest >> testOperationCountPerVerbMatchesRawCountForOpenApi3 [
	"For every verb, the number of Operation entities equals the number of path items declaring that verb."

	| failures |
	failures := self
		            failingFilesAmong: (self specFiles: false)
		            that: [ :file :importer :raw |
		            self verbMismatchOf: importer raw: raw ].
	self
		assertNoFailuresIn: failures
		description: 'Files whose operation counts differ'
]

{ #category : 'tests (step C)' }
FamixOpenApiCorpusTest >> testOperationCountPerVerbMatchesRawCountForSwagger2 [
	"Swagger 2: for every verb, the number of Operation entities equals the number of path items declaring it."

	| failures |
	failures := self
		            failingFilesAmong: (self specFiles: true)
		            that: [ :file :importer :raw |
		            self verbMismatchOf: importer raw: raw ].
	self
		assertNoFailuresIn: failures
		description: 'Swagger 2 files whose operation counts differ'
]

{ #category : 'tests (step B)' }
FamixOpenApiCorpusTest >> testPathCountMatchesRawCountForOpenApi3 [
	"One Path entity per raw entry of paths (extensions excluded)."

	| failures |
	failures := self
		            failingFilesAmong: (self specFiles: false)
		            that: [ :file :importer :raw |
			            | expected actual |
			            expected := (self rawPathItemsOf: raw) size.
			            actual := importer openApi paths size.
			            expected = actual
				            ifTrue: [ true ]
				            ifFalse: [
				            'raw ' , expected printString , ' vs model '
				            , actual printString ] ].
	self
		assertNoFailuresIn: failures
		description: 'Files whose path count differs'
]

{ #category : 'tests (step C)' }
FamixOpenApiCorpusTest >> testPathCountMatchesRawCountForSwagger2 [
	"Swagger 2: one Path entity per raw entry of paths."

	| failures |
	failures := self
		            failingFilesAmong: (self specFiles: true)
		            that: [ :file :importer :raw |
			            | expected actual |
			            expected := (self rawPathItemsOf: raw) size.
			            actual := importer openApi paths size.
			            expected = actual
				            ifTrue: [ true ]
				            ifFalse: [
				            'raw ' , expected printString , ' vs model '
				            , actual printString ] ].
	self
		assertNoFailuresIn: failures
		description: 'Swagger 2 files whose path count differs'
]

{ #category : 'tests (step B)' }
FamixOpenApiCorpusTest >> testWebhookCountMatchesRawCountForOpenApi3 [
	"One webhook Path entity per raw entry of webhooks."

	| failures |
	failures := self
		            failingFilesAmong: (self specFiles: false)
		            that: [ :file :importer :raw |
			            | webhooks expected actual |
			            webhooks := raw
				                        at: 'webhooks'
				                        ifAbsent: [ Dictionary new ].
			            expected := webhooks isDictionary
				                        ifTrue: [
				                        (webhooks keys reject: [ :key |
					                         key beginsWith: 'x-' ]) size ]
				                        ifFalse: [ 0 ].
			            actual := importer openApi webhooks size.
			            expected = actual
				            ifTrue: [ true ]
				            ifFalse: [
				            'raw ' , expected printString , ' vs model '
				            , actual printString ] ].
	self
		assertNoFailuresIn: failures
		description: 'Files whose webhook count differs'
]

{ #category : 'corpus' }
FamixOpenApiCorpusTest >> unexpectedlyUnnamedClassNamesOf: aFile merging: aBoolean [
	"Answer the sorted names of the classes of the entities of aFile, imported with or without merging of the inline schemas, that have a nil or blank name although their name is not naturally optional."

	| model |
	model := FamixOpenApiImporter new
		         mergesInlineSchemas: aBoolean;
		         importFromString: aFile contents.
	^ ((model allModelEntities select: [ :each |
		    each name isNil or: [ each name asString trimBoth isEmpty ] ])
		   collect: [ :each | each class name ]
		   as: Set) asArray sorted reject: [ :each |
		  #( #OPContact #OPLicense #OPTag #OPXmlElement ) includes: each ]
]

{ #category : 'tests' }
FamixOpenApiCorpusTest >> verbMismatchOf: anImporter raw: aRawDocument [
	"Answer true when every verb has as many operations in the model as in the raw document, else a description of the differences."

	| differences |
	differences := self rawVerbs
		               collect: [ :verb |
			               | expected actual |
			               expected := self
				                           rawOperationCountOf: aRawDocument
				                           verb: verb.
			               actual := self
				                         modelOperationCountOf: anImporter
				                         verb: verb.
			               expected = actual ifFalse: [
				               verb , ' raw ' , expected printString
				               , ' vs model ' , actual printString ] ]
		               thenSelect: [ :each | each isNotNil ].
	^ differences isEmpty
		  ifTrue: [ true ]
		  ifFalse: [ ', ' join: differences ]
]
