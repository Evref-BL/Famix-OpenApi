"
I am the abstract superclass of the visitors that read one part of an OpenAPI document into the model. I know the import context shared by all the visitors and offer short helpers on it (version, diagnostics, entity creation, pointers, external documentation). My subclasses implement one area each: document root, schemas and, in the next steps, paths, operations, parameters, responses, and so on.
"
Class {
	#name : 'FamixOpenApiNodeVisitor',
	#superclass : 'Object',
	#instVars : [
		'context'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'instance creation' }
FamixOpenApiNodeVisitor class >> on: anImportContext [
	"Answer a visitor working on anImportContext."

	^ self basicNew
		  setContext: anImportContext;
		  initialize;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> booleanAt: aKey in: aNode at: aPointer [

	^ context booleanAt: aKey in: aNode pointer: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> contentVisitor [

	^ FamixOpenApiContentVisitor on: context
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> context [

	^ context
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> diagnostics [

	^ context diagnostics
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> dictionaryAt: aKey in: aNode at: aPointer [

	^ context dictionaryAt: aKey in: aNode pointer: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> elementsAt: aKey in: aNode at: aPointer do: aBlock [
	"Evaluate the two arguments block aBlock with the object node and the pointer of each element of the array under aKey of aNode. Each element is a unit of work; an element that is not an object is reported."

	| list base |
	list := self listAt: aKey in: aNode at: aPointer.
	list ifNil: [ ^ self ].
	base := self pointer: aPointer appending: aKey.
	list withIndexDo: [ :node :position |
		| pointer |
		pointer := self pointer: base appending: position - 1.
		node isDictionary
			ifTrue: [
			self guard: [ aBlock value: node value: pointer ] at: pointer ]
			ifFalse: [
			context wrongNodeAt: pointer expecting: 'an object' found: node ] ]
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> entriesAt: aKey in: aNode at: aPointer do: aBlock [
	"Evaluate the three arguments block aBlock with the key, the object node and the pointer of each entry of the object under aKey of aNode. Each entry is a unit of work (an error is a diagnostic); an entry that is not an object is reported."

	self
		entriesAt: aKey
		in: aNode
		at: aPointer
		skippingExtensions: false
		do: aBlock
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> entriesAt: aKey in: aNode at: aPointer skippingExtensions: aBoolean do: aBlock [

	| map base |
	map := self dictionaryAt: aKey in: aNode at: aPointer.
	map ifNil: [ ^ self ].
	base := self pointer: aPointer appending: aKey.
	map keysAndValuesDo: [ :key :value |
		| pointer |
		(aBoolean and: [ self specVersion isExtensionKey: key ]) ifFalse: [
			pointer := self pointer: base appending: key.
			value isDictionary
				ifTrue: [
					self
						guard: [ aBlock value: key value: value value: pointer ]
						at: pointer ]
				ifFalse: [
				context wrongNodeAt: pointer expecting: 'an object' found: value ] ] ]
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> extensionsOf: aNode known: aKnownKeys at: aPointer [
	"Answer the extensions text of aNode (x- keys and unknown keys, the latter reported), or nil."

	^ context
		  extensionsTextOf: aNode
		  known: aKnownKeys
		  extra: #(  )
		  unmodelled: #(  )
		  at: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> externalDocsIn: aNode at: aPointer [
	"Answer the ExternalDocumentation described under the externalDocs key of aNode (located at aPointer), or nil. It is named after its url, else its description, else 'externalDocs'."

	| node pointer docs |
	node := self dictionaryAt: 'externalDocs' in: aNode at: aPointer.
	node ifNil: [ ^ nil ].
	pointer := self pointer: aPointer appending: 'externalDocs'.
	docs := self
		        newEntity: OPExternalDocumentation
		        named: nil
		        pointer: pointer.
	docs
		description: (self stringAt: 'description' in: node at: pointer);
		url: (self stringAt: 'url' in: node at: pointer);
		extensions:
			(self
				 extensionsOf: node
				 known: #( 'description' 'url' )
				 at: pointer).
	docs name: (FamixOpenApiNaming
			 nameFromAny: {
					 docs url.
					 docs description }
			 fallback: 'externalDocs').
	context recordSourceTextOf: docs from: node category: #inline.
	^ docs
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> fillServersOf: anOwner from: aNode at: aPointer [
	"Add to anOwner (a Path or an Operation) the Servers listed under the servers key of aNode."

	self
		elementsAt: 'servers'
		in: aNode
		at: aPointer
		do: [ :node :pointer |
			anOwner addServer: (self serverFrom: node at: pointer) ]
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> fixedEntriesAt: aKey in: aNode at: aPointer do: aBlock [
	"Same as #entriesAt:in:at:do: for an object whose x- keys are extensions of the object itself (the paths, the responses, the callbacks): they are not entries."

	self
		entriesAt: aKey
		in: aNode
		at: aPointer
		skippingExtensions: true
		do: aBlock
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> guard: aBlock at: aPointer [

	^ context guard: aBlock at: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> hasMediaTypeListAt: aKey in: aNode [
	"Answer whether aNode is an object holding a non-empty list at aKey."

	^ aNode isDictionary and: [
		  | value |
		  value := aNode at: aKey ifAbsent: [ nil ].
		  (context isList: value) and: [ value isNotEmpty ] ]
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> index [

	^ context index
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> isReferenceNode: aNode [
	"Answer whether aNode is an object with a $ref string."

	^ aNode isDictionary and: [
		  (aNode at: '$ref' ifAbsent: [ nil ]) isString ]
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> json [

	^ context json
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> listAt: aKey in: aNode at: aPointer [

	^ context listAt: aKey in: aNode pointer: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> mediaTypesFor: aKey in: anOperationNode [
	"Answer the media types (Swagger 2 produces or consumes, named by aKey) that apply to anOperationNode: its own list, else the root list, else #('*/*'). An empty or non-list value falls back to the next level. anOperationNode is nil for the global objects, which have no operation."

	^ (Array with: anOperationNode with: self json)
		  detect: [ :node | self hasMediaTypeListAt: aKey in: node ]
		  ifFound: [ :node | (node at: aKey) asArray ]
		  ifNone: [ #( '*/*' ) ]
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> model [

	^ context model
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> newEntity: aClass named: aName pointer: aPointer [
	"Create and register an entity of aClass at aPointer."

	^ context newEntity: aClass named: aName pointer: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> numberAt: aKey in: aNode at: aPointer [

	^ context numberAt: aKey in: aNode pointer: aPointer
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> openApi [

	^ context openApi
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> parameterVisitor [

	^ FamixOpenApiParameterVisitor on: context
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> pathVisitor [

	^ FamixOpenApiPathVisitor on: context
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> pointer: aPointer appending: aToken [

	^ FamixOpenApiJsonPointer pointer: aPointer appending: aToken
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> pointer: aPointer appending: aToken appending: anotherToken [

	^ self
		  pointer: (self pointer: aPointer appending: aToken)
		  appending: anotherToken
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> referencedNodeFor: aRefString at: aPointer [
	"Answer the JSON object designated by the local reference aRefString written at aPointer (the references met on the way are followed), or nil after reporting an unresolvedReference warning (and attaching an unresolved Reference to the document) or a refCycle error."

	| current visited node |
	current := aRefString.
	visited := Set new.
	[
	node := FamixOpenApiJsonPointer
		        resolveReference: current
		        in: self json.
	node == FamixOpenApiJsonPointer notFound ifTrue: [
		^ self reportUnresolvedReference: aRefString at: aPointer ].
	self isReferenceNode: node ] whileTrue: [
		(visited includes: current) ifTrue: [
			self diagnostics
				error: #refCycle
				pointer: aPointer
				message: 'Reference cycle through ' , current printString.
			^ nil ].
		visited add: current.
		current := node at: '$ref' ].
	node isDictionary ifFalse: [
		context wrongNodeAt: aPointer expecting: 'an object' found: node.
		^ nil ].
	^ node
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> reportUnresolvedReference: aRefString at: aPointer [

	self diagnostics
		warning: #unresolvedReference
		pointer: aPointer
		message: 'Unresolved reference ' , aRefString printString.
	context recordUnresolvedReference: aRefString at: aPointer.
	^ nil
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> responseVisitor [

	^ FamixOpenApiResponseVisitor on: context
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> schemaFrom: aNode at: aPointer [
	"Answer the Schema described by aNode located at aPointer (see FamixOpenApiSchemaVisitor), or nil."

	^ (FamixOpenApiSchemaVisitor on: context)
		  schemaFrom: aNode
		  at: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> schemaIn: aNode at: aPointer [
	"Answer the Schema under the schema key of aNode (located at aPointer), or nil when there is none."

	| node |
	node := aNode at: 'schema' ifAbsent: [ ^ nil ].
	node ifNil: [ ^ nil ].
	^ self
		  schemaFrom: node
		  at: (self pointer: aPointer appending: 'schema')
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> securityVisitor [

	^ FamixOpenApiSecurityVisitor on: context
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> serverFrom: aNode at: aPointer [
	"Answer the Server described by aNode with its variables. It is named after its url, or 'server' when it has none."

	| server variables |
	server := self newEntity: OPServer named: nil pointer: aPointer.
	server
		url: (self stringAt: 'url' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'url' 'description' 'variables' )
				 at: aPointer).
	server name:
		(FamixOpenApiNaming nameFromAny: { server url } fallback: 'server').
	context recordSourceTextOf: server from: aNode category: #inline.
	variables := self dictionaryAt: 'variables' in: aNode at: aPointer.
	variables ifNotNil: [
		variables keysAndValuesDo: [ :key :node |
			| pointer |
			pointer := self
				           pointer: aPointer
				           appending: 'variables'
				           appending: key.
			node isDictionary
				ifTrue: [
					server addVariable:
						(self serverVariableNamed: key from: node at: pointer) ]
				ifFalse: [
				context wrongNodeAt: pointer expecting: 'an object' found: node ] ] ].
	^ server
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> serverVariableNamed: aName from: aNode at: aPointer [
	"Answer the ServerVariable aName described by aNode."

	| variable values |
	variable := self
		            newEntity: OPServerVariable
		            named: aName
		            pointer: aPointer.
	values := self listAt: 'enum' in: aNode at: aPointer.
	variable
		defaultValue: (self stringAt: 'default' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		enumValues: ((values ifNil: [ #(  ) ]) select: #isString) asArray;
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'default' 'description' 'enum' )
				 at: aPointer).
	context recordSourceTextOf: variable from: aNode category: #inline.
	^ variable
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> setContext: anImportContext [

	context := anImportContext
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> sharedTargetOf: aReferenceNode at: aPointer expecting: aClass [
	"Answer the entity designated by the $ref of aReferenceNode written at aPointer, or nil (the problem is reported)."

	^ context
		  resolveReference: (aReferenceNode at: '$ref')
		  at: aPointer
		  expecting: aClass
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> sourceCategoryOf: anEntity [
	"Answer the source text category of anEntity, a kind of entity that can be a reusable component: #component when it is one, #inline otherwise."

	^ anEntity components isNil
		  ifTrue: [ #inline ]
		  ifFalse: [ #component ]
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> specVersion [

	^ context specVersion
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> stringAt: aKey in: aNode at: aPointer [

	^ context stringAt: aKey in: aNode pointer: aPointer
]
