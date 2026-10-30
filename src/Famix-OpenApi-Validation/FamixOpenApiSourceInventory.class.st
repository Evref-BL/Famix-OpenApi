"
I am the inventory of the nodes of a source OpenAPI/Swagger document, as found by FamixOpenApiSourceWalker, indexed by pointer, by spec object and by parent. Wrong-shape nodes are kept by pointer and in wrongShapeNodes but are not counted in countOf: / nodesOf:. A document of an unknown version has the version #unknownVersion and no node. API: version, countOf:, nodesOf:, nodeAt:, nodeAt:ifAbsent:, childrenOf:, pointers, unknownKeys, wrongShapeNodes, pathCount, operationCountOf:, componentSchemaCount, summary, markdownSummary.
"
Class {
	#name : 'FamixOpenApiSourceInventory',
	#superclass : 'Object',
	#instVars : [
		'version',
		'nodes',
		'nodesByObject',
		'childrenByParent'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiSourceInventory class >> version: aVersionSymbol [

	^ self new
		  version: aVersionSymbol;
		  yourself
]

{ #category : 'adding' }
FamixOpenApiSourceInventory >> add: aNode [
	"Index aNode by pointer, by parent and (unless it is wrongShape) by spec object"

	nodes at: aNode pointer put: aNode.
	aNode parentPointer ifNotNil: [ :parent |
		self addNode: aNode to: childrenByParent under: parent ].
	aNode isWrongShape ifFalse: [
		self addNode: aNode to: nodesByObject under: aNode specObject ]
]

{ #category : 'private' }
FamixOpenApiSourceInventory >> addNode: aNode to: anIndex under: aKey [
	"anIndex is a Dictionary key -> OrderedCollection of nodes"

	(anIndex at: aKey ifAbsentPut: [ OrderedCollection new ]) add: aNode
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> allNodes [

	^ nodes values
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> childrenOf: aPointer [
	"The nodes whose parent pointer is aPointer, in document order, wrong-shape nodes included"

	^ (childrenByParent at: aPointer ifAbsent: [ ^ #(  ) ]) asArray
]

{ #category : 'counting' }
FamixOpenApiSourceInventory >> componentSchemaCount [
	"The entries of components.schemas (3.x) or of definitions (Swagger 2)"

	^ (self childrenOf: self componentSchemasPointer) size
]

{ #category : 'private' }
FamixOpenApiSourceInventory >> componentSchemasPointer [

	^ version = #v2
		  ifTrue: [ '#/definitions' ]
		  ifFalse: [ '#/components/schemas' ]
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> countOf: aSpecObjectName [
	"The number of nodes of the spec object, the wrong-shape nodes excluded"

	^ (nodesByObject at: aSpecObjectName ifAbsent: [ ^ 0 ]) size
]

{ #category : 'counting' }
FamixOpenApiSourceInventory >> counts [
	"A Dictionary spec object name -> count, for the objects that have nodes, in the order of the field table"

	| counts |
	counts := OrderedDictionary new.
	self isUnknownVersion ifTrue: [ ^ counts ].
	(FamixOpenApiSpecFieldTable objectNamesIn: version) do: [ :name |
		(self countOf: name) > 0 ifTrue: [
			counts at: name put: (self countOf: name) ] ].
	^ counts
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> extensionKeys [
	"The pointers of the extension (x-*) keys, in document order"

	^ self keyPointersOf: [ :node | node extensionKeys ]
]

{ #category : 'private' }
FamixOpenApiSourceInventory >> hasObjectAt: aPointer [

	^ nodes
		  at: aPointer
		  ifPresent: [ :node | node isWrongShape not ]
		  ifAbsent: [ false ]
]

{ #category : 'testing' }
FamixOpenApiSourceInventory >> includesPointer: aPointer [

	^ nodes includesKey: aPointer
]

{ #category : 'initialization' }
FamixOpenApiSourceInventory >> initialize [

	super initialize.
	nodes := OrderedDictionary new.
	nodesByObject := Dictionary new.
	childrenByParent := Dictionary new
]

{ #category : 'testing' }
FamixOpenApiSourceInventory >> isUnknownVersion [

	^ version = #unknownVersion
]

{ #category : 'private' }
FamixOpenApiSourceInventory >> keyPointersOf: aKeysBlock [

	^ Array streamContents: [ :stream |
		  nodes do: [ :node |
			  (aKeysBlock value: node) do: [ :key |
				  stream nextPut:
					  (FamixOpenApiSourceNode pointerOf: node pointer child: key) ] ] ]
]

{ #category : 'reporting' }
FamixOpenApiSourceInventory >> markdownSummary [
	"A Markdown table of the counts per spec object, then the unknown keys and the wrong shapes. Lines end with LF"

	^ String streamContents: [ :stream |
		  self writeMarkdownHeaderOn: stream.
		  self counts keysAndValuesDo: [ :name :count |
			  stream
				  nextPutAll: '| ';
				  nextPutAll: name;
				  nextPutAll: ' | ';
				  print: count;
				  nextPutAll: ' |';
				  lf ].
		  self
			  writeMarkdownList: self unknownKeys
			  title: 'Unknown keys'
			  on: stream.
		  self
			  writeMarkdownList: (self wrongShapeNodes collect: #pointer)
			  title: 'Wrong shapes'
			  on: stream ]
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> nodeAt: aPointer [
	"Answer the node at aPointer; raises KeyNotFound when there is none (see includesPointer:)"

	^ nodes at: aPointer
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> nodeAt: aPointer ifAbsent: aBlock [

	^ nodes at: aPointer ifAbsent: aBlock
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> nodesOf: aSpecObjectName [
	"The nodes of the spec object in document order, the wrong-shape nodes excluded"

	^ (nodesByObject at: aSpecObjectName ifAbsent: [ ^ #(  ) ]) asArray
]

{ #category : 'counting' }
FamixOpenApiSourceInventory >> operationCountOf: aVerb [
	"The path items of paths that hold an object (a Reference included) for the verb aVerb"

	^ (self childrenOf: '#/paths') count: [ :path |
		  self hasObjectAt:
			  (FamixOpenApiSourceNode pointerOf: path pointer child: aVerb) ]
]

{ #category : 'counting' }
FamixOpenApiSourceInventory >> pathCount [
	"The entries of paths (extensions excluded)"

	^ (self childrenOf: '#/paths') size
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> pointers [
	"The pointers of every node (wrong-shape nodes included) in document order"

	^ nodes keys
]

{ #category : 'reporting' }
FamixOpenApiSourceInventory >> summary [
	"A short plain text: version, totals and the count per spec object"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: 'version: ';
			  print: version;
			  lf;
			  nextPutAll: 'nodes: ';
			  print: nodes size;
			  lf;
			  nextPutAll: 'unknown keys: ';
			  print: self unknownKeys size;
			  lf;
			  nextPutAll: 'extension keys: ';
			  print: self extensionKeys size;
			  lf;
			  nextPutAll: 'wrong shapes: ';
			  print: self wrongShapeNodes size;
			  lf.
		  self counts keysAndValuesDo: [ :name :count |
			  stream
				  nextPutAll: name;
				  nextPutAll: ': ';
				  print: count;
				  lf ] ]
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> unknownKeys [
	"The pointers of the unknown keys (the pointer of the node followed by the escaped key), in document order"

	^ self keyPointersOf: [ :node | node unknownKeys ]
]

{ #category : 'accessing' }
FamixOpenApiSourceInventory >> version [
	"#v30, #v31, #v2 or #unknownVersion"

	^ version
]

{ #category : 'accessing' }
FamixOpenApiSourceInventory >> version: aVersionSymbol [

	version := aVersionSymbol
]

{ #category : 'reporting' }
FamixOpenApiSourceInventory >> writeMarkdownHeaderOn: aStream [

	aStream
		nextPutAll: 'Version: ';
		print: version;
		lf;
		lf;
		nextPutAll: '| Spec object | Nodes |';
		lf;
		nextPutAll: '|---|---|';
		lf
]

{ #category : 'reporting' }
FamixOpenApiSourceInventory >> writeMarkdownList: aCollection title: aString on: aStream [

	aCollection isEmpty ifTrue: [ ^ self ].
	aStream
		lf;
		nextPutAll: aString;
		nextPutAll: ' (';
		print: aCollection size;
		nextPutAll: '):';
		lf;
		lf.
	aCollection do: [ :each |
		aStream
			nextPutAll: '- `';
			nextPutAll: each;
			nextPut: $`;
			lf ]
]

{ #category : 'querying' }
FamixOpenApiSourceInventory >> wrongShapeNodes [

	^ nodes values select: [ :each | each isWrongShape ]
]
