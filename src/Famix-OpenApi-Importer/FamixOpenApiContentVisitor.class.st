Class {
	#name : 'FamixOpenApiContentVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> encodingNamed: aKey from: aNode at: aPointer [
	"Answer the Encoding of the property aKey described by aNode, with its headers (shared when they are references)."

	| encoding |
	encoding := self newEntity: OPEncoding named: aKey pointer: aPointer.
	encoding
		propertyName: aKey;
		contentType: (self stringAt: 'contentType' in: aNode at: aPointer);
		style: (self stringAt: 'style' in: aNode at: aPointer);
		explode: (self booleanAt: 'explode' in: aNode at: aPointer);
		allowReserved:
			(self booleanAt: 'allowReserved' in: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known:
					 #( 'contentType' 'headers' 'style' 'explode' 'allowReserved' )
				 at: aPointer).
	self
		entriesAt: 'headers'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			(self responseVisitor headerNamed: key from: node at: pointer)
				ifNotNil: [ :header |
					(encoding headers includes: header) ifFalse: [
						encoding addHeader: header ] ] ].
	context recordSourceTextOf: encoding from: aNode category: #inline.
	^ encoding
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> exampleNamed: aKey from: aNode at: aPointer [
	"Answer the Example aKey: the shared target when aNode is a reference (nil when it cannot be resolved), a new Example otherwise."

	| example |
	(self isReferenceNode: aNode) ifTrue: [
		^ self sharedTargetOf: aNode at: aPointer expecting: OPExample ].
	example := self newEntity: OPExample named: aKey pointer: aPointer.
	self fillExample: example from: aNode at: aPointer.
	^ example
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> fillContentOf: anOwner from: aNode at: aPointer [
	"Add to anOwner (a Parameter, a RequestBody or a Response) the MediaTypes of the content object of aNode."

	self
		entriesAt: 'content'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			anOwner addContent:
				(self mediaTypeNamed: key from: node at: pointer) ]
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> fillEncodingsOf: aMediaType from: aNode at: aPointer [
	"Add to aMediaType the Encodings of the encoding object of aNode."

	self
		entriesAt: 'encoding'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			aMediaType addEncoding:
				(self encodingNamed: key from: node at: pointer) ]
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> fillExample: anExample from: aNode at: aPointer [
	"Fill anExample, created empty, from aNode. Its description has no slot: it goes to the extensions."

	anExample
		summary: (self stringAt: 'summary' in: aNode at: aPointer);
		externalValue:
			(self stringAt: 'externalValue' in: aNode at: aPointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known: #( 'summary' 'value' 'externalValue' )
				 extra: #(  )
				 unmodelled: #( 'description' )
				 at: aPointer).
	(aNode includesKey: 'value') ifTrue: [
		anExample value: (context jsonTextOf: (aNode at: 'value')) ].
	context
		recordSourceTextOf: anExample
		from: aNode
		category: (self sourceCategoryOf: anExample)
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> fillExamplesOf: anOwner from: aNode at: aPointer [
	"Add to anOwner (a Parameter or a MediaType) the Example of the example key of aNode, named 'example', and the Examples of its examples object (shared when they are references)."

	(aNode includesKey: 'example') ifTrue: [
		anOwner addExample: (self singularExampleFrom: aNode at: aPointer) ].
	self
		entriesAt: 'examples'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			(self exampleNamed: key from: node at: pointer) ifNotNil: [
				:example |
				(anOwner examples includes: example) ifFalse: [
					anOwner addExample: example ] ] ]
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> fillRequestBody: aBody from: aNode at: aPointer [
	"Fill aBody, created empty, from aNode."

	aBody
		description: (self stringAt: 'description' in: aNode at: aPointer);
		required: (self booleanAt: 'required' in: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'description' 'content' 'required' )
				 at: aPointer).
	self fillContentOf: aBody from: aNode at: aPointer.
	context
		recordSourceTextOf: aBody
		from: aNode
		category: (self sourceCategoryOf: aBody)
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> fillSwagger2ContentOf: anOwner from: aNode mediaTypes: aList at: aPointer [
	"Add to anOwner (a Response) one MediaType per media type of aList, all sharing the schema of aNode, read once. Does nothing when aNode has no schema."

	| schema |
	(aNode at: 'schema' ifAbsent: [ nil ]) ifNil: [ ^ self ].
	schema := self schemaIn: aNode at: aPointer.
	schema ifNil: [ ^ self ].
	aList do: [ :each |
		anOwner addContent:
			((self newEntity: OPMediaType named: each pointer: (self
						   pointer: (self pointer: aPointer appending: 'content')
						   appending: each))
				 mediaType: each;
				 schema: schema;
				 yourself) ]
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> mediaTypeNamed: aKey from: aNode at: aPointer [
	"Answer the MediaType aKey described by aNode, with its schema, examples and encodings."

	| mediaType |
	mediaType := self
		             newEntity: OPMediaType
		             named: aKey
		             pointer: aPointer.
	mediaType
		mediaType: aKey;
		schema: (self schemaIn: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'schema' 'example' 'examples' 'encoding' )
				 at: aPointer).
	self fillExamplesOf: mediaType from: aNode at: aPointer.
	self fillEncodingsOf: mediaType from: aNode at: aPointer.
	context recordSourceTextOf: mediaType from: aNode category: #inline.
	^ mediaType
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> requestBodyIn: aNode at: aPointer [
	"Answer the RequestBody described by aNode, the value of the requestBody key of an operation located at the parent of aPointer: the shared target when it is a reference (nil when it cannot be resolved), a new RequestBody otherwise."

	| body |
	(self isReferenceNode: aNode) ifTrue: [
		^ self sharedTargetOf: aNode at: aPointer expecting: OPRequestBody ].
	body := self newEntity: OPRequestBody named: nil pointer: aPointer.
	self fillRequestBody: body from: aNode at: aPointer.
	^ body
]

{ #category : 'visiting' }
FamixOpenApiContentVisitor >> singularExampleFrom: aNode at: aPointer [
	"Answer the Example named 'example' whose value is the JSON text of the example key of aNode."

	| example value |
	value := aNode at: 'example'.
	example := self
		           newEntity: OPExample
		           named: 'example'
		           pointer: (self pointer: aPointer appending: 'example').
	example value: (context jsonTextOf: value).
	context recordSourceTextOf: example from: value category: #inline.
	^ example
]
