"
I test the query and reporting protocol of FamixOpenApiSourceInventory (counts, nodes by pointer, summary and markdownSummary) on a small hand-written document.
"
Class {
	#name : 'FamixOpenApiSourceInventoryTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiSourceInventoryTest >> inventory [

	^ FamixOpenApiSourceWalker new walkString:
		  '{"openapi":"3.0.0","info":{"title":"t","bad":1},"paths":{"/a":{"get":{"responses":{"200":{"description":"d"}}},"x-k":1},"/b":7}}'
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testCountsAndNodes [

	| inventory |
	inventory := self inventory.
	self assert: inventory version equals: #v30.
	self deny: inventory isUnknownVersion.
	self assert: (inventory countOf: 'Operation') equals: 1.
	self assert: (inventory countOf: 'NoSuchObject') equals: 0.
	self assert: (inventory nodesOf: 'NoSuchObject') isEmpty.
	self
		assert: ((inventory nodesOf: 'Response') collect: #pointer)
		equals: #( '#/paths/~1a/get/responses/200' ).
	self assert: (inventory nodeAt: '#/info') specObject equals: 'Info'.
	self assert: (inventory nodeAt: '#/info') parentPointer equals: '#'.
	self assert: (inventory nodeAt: '#/info') key equals: 'info'.
	self assert: (inventory nodeAt: '#/info') version equals: #v30.
	self assert: (inventory nodeAt: '#') parentPointer isNil.
	self
		assert:
		(inventory nodeAt: '#/paths/~1a/get/responses/200') parentPointer
		equals: '#/paths/~1a/get/responses'.
	self
		assert: (inventory nodeAt: '#/info') value
		equals: (OrderedDictionary new
				 at: 'title' put: 't';
				 at: 'bad' put: 1;
				 yourself)
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testMarkdownSummaryUsesLineFeeds [

	| markdown |
	markdown := self inventory markdownSummary.
	self deny: (markdown includes: Character cr).
	self assert: (markdown includes: Character lf).
	self assert: (markdown includesSubstring: '| Operation | 1 |').
	self assert: (markdown includesSubstring: 'Unknown keys (1):').
	self assert: (markdown includesSubstring: '- `#/info/bad`').
	self assert: (markdown includesSubstring: 'Wrong shapes (1):')
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testNodeAtAnUnknownPointer [

	| inventory |
	inventory := self inventory.
	self should: [ inventory nodeAt: '#/nope' ] raise: KeyNotFound.
	self assert: (inventory nodeAt: '#/nope' ifAbsent: [ 0 ]) equals: 0.
	self deny: (inventory includesPointer: '#/nope').
	self assert: (inventory childrenOf: '#/nope') isEmpty
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testPathAndOperationCounts [

	| inventory |
	inventory := self inventory.
	self assert: inventory pathCount equals: 2.
	self assert: (inventory operationCountOf: 'get') equals: 1.
	self assert: (inventory operationCountOf: 'post') equals: 0.
	self assert: inventory componentSchemaCount equals: 0
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testSummary [

	self assert: self inventory summary equals: (self textOfLines:
			 #( 'version: #v30' 'nodes: 8' 'unknown keys: 1' 'extension keys: 1'
			    'wrong shapes: 1' 'OpenAPI: 1' 'Info: 1' 'Paths: 1' 'PathItem: 1'
			    'Operation: 1' 'Responses: 1' 'Response: 1' ))
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testSummaryOfAnUnknownVersion [

	| inventory |
	inventory := FamixOpenApiSourceWalker new walkString: '{}'.
	self assert: inventory summary equals: (self textOfLines:
			 #( 'version: #unknownVersion' 'nodes: 0' 'unknown keys: 0'
			    'extension keys: 0' 'wrong shapes: 0' ))
]

{ #category : 'tests' }
FamixOpenApiSourceInventoryTest >> testUnknownAndWrongShapeLists [

	| inventory |
	inventory := self inventory.
	self assert: inventory unknownKeys equals: #( '#/info/bad' ).
	self assert: inventory extensionKeys equals: #( '#/paths/~1a/x-k' ).
	self
		assert: (inventory wrongShapeNodes collect: #pointer)
		equals: #( '#/paths/~1b' )
]

{ #category : 'helpers' }
FamixOpenApiSourceInventoryTest >> textOfLines: aCollection [
	"The lines of aCollection, each ended by a line feed"

	^ String streamContents: [ :stream |
		  aCollection do: [ :line |
			  stream
				  nextPutAll: line;
				  lf ] ]
]
