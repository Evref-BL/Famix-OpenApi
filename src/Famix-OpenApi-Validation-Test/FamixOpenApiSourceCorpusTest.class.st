"
I cross-check FamixOpenApiSourceWalker on the external corpus of real specification files (skipped when the folder is absent): the walker counts of paths, operations per verb and component schemas must equal the raw counting helpers of FamixOpenApiCorpusTest, which use the same definitions, and the walker raises nothing on any file nor on the parsed values of bad inputs.
"
Class {
	#name : 'FamixOpenApiSourceCorpusTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiSourceCorpusTest >> corpusHelper [
	"The importer test that owns the raw counting helpers and the corpus folder"

	^ FamixOpenApiCorpusTest new
]

{ #category : 'helpers' }
FamixOpenApiSourceCorpusTest >> differencesOf: aBlock [
	"aBlock is given a raw document and its inventory and answers #(rawValue walkerValue). Answer a description of every spec file for which they differ"

	^ Array streamContents: [ :stream |
		  self rawSpecDocuments do: [ :each |
			  | pair |
			  pair := aBlock
				          value: each value
				          value: (FamixOpenApiSourceWalker new walk: each value).
			  pair first = pair second ifFalse: [
				  stream nextPut: ('<1s>: raw <2p> vs walker <3p>'
						   expandMacrosWith: each key
						   with: pair first
						   with: pair second) ] ] ]
]

{ #category : 'helpers' }
FamixOpenApiSourceCorpusTest >> operationNodesUnderPathsIn: anInventory [
	"The Operation nodes whose parent is an entry of paths (callbacks below an operation hold more of them)"

	| pathPointers |
	pathPointers := ((anInventory childrenOf: '#/paths') collect:
		                 #pointer) asSet.
	^ (anInventory nodesOf: 'Operation') count: [ :node |
		  pathPointers includes: node parentPointer ]
]

{ #category : 'helpers' }
FamixOpenApiSourceCorpusTest >> rawSpecDocuments [
	"Associations file name -> raw document (Dictionary parsed by NeoJSON) of the corpus files that are API descriptions. Skips the running test when the corpus folder is absent"

	| helper |
	helper := self corpusHelper.
	^ (helper corpusFiles collect: [ :file |
		   file basename -> (helper rawDocumentOf: file) ]) select: [ :each |
		  helper isSpecDocument: each value ]
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testComponentSchemaCountMatchesTheRawCount [

	self
		assert: (self differencesOf: [ :raw :inventory |
				 {
					 (self corpusHelper rawSchemaCountOf: raw).
					 inventory componentSchemaCount } ])
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testEveryInventoryPointerIsUniqueAndStartsAtTheRoot [

	self rawSpecDocuments do: [ :each |
		| pointers |
		pointers := (FamixOpenApiSourceWalker new walk: each value) pointers.
		self assert: pointers asSet size equals: pointers size.
		self assert: pointers first equals: '#'.
		self assert:
			(pointers allSatisfy: [ :pointer | pointer beginsWith: '#' ]) ]
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testEverySpecFileHasAKnownVersion [

	self
		assert: (self differencesOf: [ :raw :inventory |
				 {
					 ((self corpusHelper isSwagger2: raw)
						  ifTrue: [ #v2 ]
						  ifFalse: [ inventory version ]).
					 inventory version } ])
		equals: #(  ).
	self assert: (self rawSpecDocuments noneSatisfy: [ :each |
			 (FamixOpenApiSourceWalker new walk: each value) isUnknownVersion ])
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testOperationCountPerVerbMatchesTheRawCount [

	self corpusHelper rawVerbs do: [ :verb |
		self
			assert: (self differencesOf: [ :raw :inventory |
					 {
						 (self corpusHelper rawOperationCountOf: raw verb: verb).
						 (inventory operationCountOf: verb) } ])
			equals: #(  ) ]
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testOperationNodesMatchTheRawCountOfAllVerbs [
	"The Operation nodes under paths (not webhooks or callbacks) are the verbs holding an object"

	self
		assert: (self differencesOf: [ :raw :inventory |
				 {
					 (self corpusHelper rawVerbs inject: 0 into: [ :sum :verb |
						  sum + (self corpusHelper rawOperationCountOf: raw verb: verb) ]).
					 (self operationNodesUnderPathsIn: inventory) } ])
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testPathCountMatchesTheRawCount [

	self
		assert: (self differencesOf: [ :raw :inventory |
				 {
					 (self corpusHelper rawPathItemsOf: raw) size.
					 inventory pathCount } ])
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testWalkerRaisesNothingOnAnyCorpusFile [

	| helper |
	helper := self corpusHelper.
	helper corpusFiles do: [ :file |
		self
			shouldnt: [
			FamixOpenApiSourceWalker new walk: (helper rawDocumentOf: file) ]
			raise: Error
			description: file basename ]
]

{ #category : 'tests' }
FamixOpenApiSourceCorpusTest >> testWalkerRaisesNothingOnTheParsedValuesOfBadInputs [
	"Only parsed values reach the walker: the empty string and the truncated strings are errors of the caller (the parser)"

	#( '[]' '{}' '{"openapi":3}' '{"openapi":"3.0.0"}'
	   '{"swagger":"2.0"}' '{"openapi":"3.0.0","paths":[]}'
	   '"text"' '12' 'null' 'true' '[{"openapi":"3.0.0"}]' ) do: [ :text |
		self
			shouldnt: [
			FamixOpenApiSourceWalker new walk: (NeoJSONReader fromString: text) ]
			raise: Error
			description: text ]
]
