"
I walk a parsed source OpenAPI/Swagger JSON document (Dictionary or OrderedDictionary for objects, Array for arrays, as NeoJSON produces them) along FamixOpenApiSpecGrammar and answer a FamixOpenApiSourceInventory. I detect the version from the root keys, record a node per spec object, record a node holding a $ref as a Reference (and do not follow it), record extension and unknown keys on their node, and flag a node whose JSON type does not fit the grammar as wrongShape without descending into it. I never raise on a parsed value. The walk is iterative (an explicit work list, document order), so deep or wide documents do not use the call stack. A boolean is accepted wherever a Schema is expected. No model is involved.
"
Class {
	#name : 'FamixOpenApiSourceWalker',
	#superclass : 'Object',
	#instVars : [
		'version',
		'inventory',
		'pending',
		'children'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> classify: aNode [
	"A value that is not an object (a boolean for a Schema excepted) is wrongShape; an object holding $ref is a Reference"

	aNode isWrongShape ifTrue: [ ^ self ].
	(self isBooleanSchema: aNode) ifTrue: [ ^ self ].
	aNode value isDictionary ifFalse: [ ^ aNode markWrongShape ].
	(aNode value includesKey: '$ref') ifTrue: [
		aNode specObject: 'Reference' ]
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> collectContainerEdge: anEdge node: aContainerNode [
	"aContainerNode holds the value of a map or array field: check its JSON type, then schedule its entries"

	| value |
	value := aContainerNode value.
	(anEdge isMapOfObjects or: [ anEdge expectsDictionary ]) ifTrue: [
		value isDictionary ifFalse: [
			^ self collectWrongShape: aContainerNode ] ].
	(anEdge isArrayOfObjects or: [ anEdge expectsArray ]) ifTrue: [
		value isArray ifFalse: [ ^ self collectWrongShape: aContainerNode ] ].
	anEdge isMapOfObjects ifTrue: [
		self collectEntriesOfMap: aContainerNode as: anEdge target ].
	anEdge isArrayOfObjects ifTrue: [
		self collectElementsOfArray: aContainerNode as: anEdge target ]
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> collectEdge: anEdge key: aKey value: aJsonValue of: aNode [
	"Schedule the children implied by the kind of anEdge; a value of another JSON type is a wrong-shape node"

	| node |
	anEdge descends ifFalse: [ ^ self ].
	node := self
		        nodeSpec: (anEdge target ifNil: [ 'Value' ])
		        parent: aNode pointer
		        key: aKey
		        value: aJsonValue.
	inventory noteEdge: anEdge at: node pointer.
	anEdge isObjectEdge
		ifTrue: [ children add: node ]
		ifFalse: [ self collectContainerEdge: anEdge node: node ]
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> collectElementsOfArray: aContainerNode as: aSpecObjectName [

	aContainerNode value withIndexDo: [ :element :index |
		children add: (self
				 noteEntry: (self
						  nodeSpec: aSpecObjectName
						  parent: aContainerNode pointer
						  key: index - 1
						  value: element)
				 of: aContainerNode) ]
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> collectEntriesOfMap: aContainerNode as: aSpecObjectName [

	aContainerNode value keysAndValuesDo: [ :key :entry |
		children add: (self
				 noteEntry: (self
						  nodeSpec: aSpecObjectName
						  parent: aContainerNode pointer
						  key: key asString
						  value: entry)
				 of: aContainerNode) ]
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> collectKey: aKey value: aJsonValue of: aNode [
	"Classify the key of the object aNode through the grammar: unknown, extension or a field to descend"

	| edge |
	edge := FamixOpenApiSpecGrammar
		        edgeForKey: aKey
		        in: aNode specObject
		        version: version.
	edge isUnknown ifTrue: [ ^ aNode addUnknownKey: aKey ].
	edge isExtension ifTrue: [ ^ aNode addExtensionKey: aKey ].
	self
		collectEdge: edge
		key: aKey
		value: aJsonValue
		of: aNode
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> collectWrongShape: aNode [

	aNode markWrongShape.
	children add: aNode
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> hasChildren: aNode [
	"Only an object that is neither wrongShape nor a Reference is descended into"

	^ aNode isWrongShape not and: [
		  aNode isReference not and: [ aNode value isDictionary ] ]
]

{ #category : 'version' }
FamixOpenApiSourceWalker >> is: aVersionString releaseOf: aMinorString [
	"True for aMinorString itself ('3.1') or for a patch release of it ('3.1.0', '3.1.1-rc1'): the text after the dot must start with a digit, so that '3.10.0' is not a 3.1"

	| prefix |
	aVersionString = aMinorString ifTrue: [ ^ true ].
	prefix := aMinorString , '.'.
	^ (aVersionString beginsWith: prefix) and: [
		  aVersionString size > prefix size and: [
			  (aVersionString at: prefix size + 1) isDigit ] ]
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> isBooleanSchema: aNode [
	"A boolean is a valid Schema (true accepts everything, false nothing)"

	^ aNode specObject = 'Schema' and: [
		  #( true false ) includes: aNode value ]
]

{ #category : 'private - nodes' }
FamixOpenApiSourceWalker >> nodeSpec: aSpecObjectName parent: aParentPointer key: aKey value: aJsonValue [

	^ FamixOpenApiSourceNode new
		  pointer:
			  (FamixOpenApiSourceNode pointerOf: aParentPointer child: aKey);
		  specObject: aSpecObjectName;
		  parentPointer: aParentPointer;
		  version: version;
		  key: aKey;
		  value: aJsonValue;
		  yourself
]

{ #category : 'private - nodes' }
FamixOpenApiSourceWalker >> noteEntry: anEntryNode of: aContainerNode [
	"An entry of a map or an array was led to by the edge of its container. Answer the entry"

	inventory
		noteEdge: (inventory edgeAt: aContainerNode pointer)
		at: anEntryNode pointer.
	^ anEntryNode
]

{ #category : 'private - nodes' }
FamixOpenApiSourceWalker >> rootNodeOf: aJsonObject [

	^ FamixOpenApiSourceNode new
		  pointer: FamixOpenApiSourceNode rootPointer;
		  specObject: (FamixOpenApiSpecGrammar rootObjectNameIn: version);
		  version: version;
		  value: aJsonObject;
		  yourself
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> scheduleChildrenOf: aNode [
	"Push the children of aNode on the work list so that they are visited in document order"

	children := OrderedCollection new.
	aNode value keysAndValuesDo: [ :key :child |
		self collectKey: key asString value: child of: aNode ].
	children reverseDo: [ :each | pending addLast: each ]
]

{ #category : 'version' }
FamixOpenApiSourceWalker >> versionOf: aJsonObject [
	"#v2 for swagger '2.0', #v30 for an openapi starting with 3.0, #v31 for 3.1, else #unknownVersion"

	aJsonObject isDictionary ifFalse: [ ^ #unknownVersion ].
	(aJsonObject at: 'swagger' ifAbsent: [ '' ]) = '2.0' ifTrue: [ ^ #v2 ].
	^ self versionOfOpenApi: (aJsonObject at: 'openapi' ifAbsent: [ '' ])
]

{ #category : 'version' }
FamixOpenApiSourceWalker >> versionOfOpenApi: aValue [

	aValue isString ifFalse: [ ^ #unknownVersion ].
	(self is: aValue releaseOf: '3.0') ifTrue: [ ^ #v30 ].
	(self is: aValue releaseOf: '3.1') ifTrue: [ ^ #v31 ].
	^ #unknownVersion
]

{ #category : 'private - visiting' }
FamixOpenApiSourceWalker >> visit: aNode [
	"Record aNode, then schedule its children when it is an object of the grammar"

	self classify: aNode.
	inventory add: aNode.
	(self hasChildren: aNode) ifTrue: [ self scheduleChildrenOf: aNode ]
]

{ #category : 'walking' }
FamixOpenApiSourceWalker >> walk: aJsonObject [
	"Answer the FamixOpenApiSourceInventory of aJsonObject (parsed JSON). Never raises: a document whose version is not recognised gives the version #unknownVersion and no node"

	version := self versionOf: aJsonObject.
	inventory := FamixOpenApiSourceInventory version: version.
	version = #unknownVersion ifTrue: [ ^ inventory ].
	pending := OrderedCollection with: (self rootNodeOf: aJsonObject).
	[ pending isEmpty ] whileFalse: [ self visit: pending removeLast ].
	^ inventory
]

{ #category : 'walking' }
FamixOpenApiSourceWalker >> walkRoot: aNode into: anInventory edge: anEdgeOrNil [
	"Add to anInventory the node aNode (the root of a subtree: its pointer, spec object and value are set) and the nodes below it, read the way a document is. anEdgeOrNil is the grammar edge that leads to aNode, nil when it is not known. Used to expand an inventory (clones, synthesized schemas), never for a document"

	version := anInventory version.
	inventory := anInventory.
	anEdgeOrNil ifNotNil: [ :edge |
		inventory noteEdge: edge at: aNode pointer ].
	pending := OrderedCollection with: aNode.
	[ pending isEmpty ] whileFalse: [ self visit: pending removeLast ]
]

{ #category : 'walking' }
FamixOpenApiSourceWalker >> walkString: aJsonString [
	"Parse aJsonString like the importer does (objects keep the order of their keys) and walk it. A malformed string raises the NeoJSON error: it is the caller's error"

	^ self walk: ((NeoJSONReader on: aJsonString readStream)
			   mapClass: OrderedDictionary;
			   next)
]
