Class {
	#name : 'FamixOpenApiResponseVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillHeader: aHeader from: aNode at: aPointer [
	"Fill aHeader, created with its name, from aNode. The keys that the model has no slot for (content, example, examples, allowEmptyValue, allowReserved) go to the extensions."

	aHeader
		description: (self stringAt: 'description' in: aNode at: aPointer);
		required: (self booleanAt: 'required' in: aNode at: aPointer);
		deprecated: (self booleanAt: 'deprecated' in: aNode at: aPointer);
		style: (self stringAt: 'style' in: aNode at: aPointer);
		explode: (self booleanAt: 'explode' in: aNode at: aPointer);
		schema: (self schemaIn: aNode at: aPointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known:
					 #( 'description' 'required' 'deprecated' 'style' 'explode'
					    'schema' )
				 extra: #(  )
				 unmodelled:
					 #( 'content' 'example' 'examples' 'allowEmptyValue'
					    'allowReserved' )
				 at: aPointer).
	context
		recordSourceTextOf: aHeader
		from: aNode
		category: (self sourceCategoryOf: aHeader)
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillHeadersOf: aResponse from: aNode at: aPointer [
	"Add to aResponse the Headers of the headers object of aNode (shared when they are references)."

	self
		entriesAt: 'headers'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			(self headerNamed: key from: node at: pointer) ifNotNil: [ :header |
				(aResponse headers includes: header) ifFalse: [
					aResponse addHeader: header ] ] ]
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillLink: aLink from: aNode at: aPointer [
	"Fill aLink, created with its name, from aNode. The operation is resolved at the end of the import. Its parameters map goes to the extensions."

	aLink
		operationId: (self stringAt: 'operationId' in: aNode at: aPointer);
		operationRef: (self stringAt: 'operationRef' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known:
					 #( 'operationId' 'operationRef' 'requestBody' 'description'
					    'server' )
				 extra: #( 'parameters' )
				 unmodelled: #(  )
				 at: aPointer).
	(aNode includesKey: 'requestBody') ifTrue: [
		aLink requestBody: (context jsonTextOf: (aNode at: 'requestBody')) ].
	(self dictionaryAt: 'server' in: aNode at: aPointer) ifNotNil: [
		:node |
		aLink server: (self
				 serverFrom: node
				 at: (self pointer: aPointer appending: 'server')) ].
	context
		recordSourceTextOf: aLink
		from: aNode
		category: (self sourceCategoryOf: aLink)
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillLinksOf: aResponse from: aNode at: aPointer [
	"Add to aResponse the Links of the links object of aNode (shared when they are references)."

	self
		entriesAt: 'links'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			(self linkNamed: key from: node at: pointer) ifNotNil: [ :link |
				(aResponse links includes: link) ifFalse: [
					aResponse addLink: link ] ] ]
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillResponse: aResponse from: aNode at: aPointer [
	"Fill aResponse, created empty, from aNode. It has no operation: a Swagger 2 schema takes the root produces as media types."

	self
		fillResponse: aResponse
		from: aNode
		at: aPointer
		mediaTypes: (self mediaTypesFor: 'produces' in: nil)
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillResponse: aResponse from: aNode at: aPointer mediaTypes: aList [
	"Fill aResponse, created empty, from aNode: description, headers, content, links and extensions. aList holds the media types of a Swagger 2 schema."

	aResponse
		description: (self stringAt: 'description' in: aNode at: aPointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known: (self specVersion isSwagger2
						  ifTrue: [
							  #( 'description' 'headers' 'content' 'links' 'schema' ) ]
						  ifFalse: [ #( 'description' 'headers' 'content' 'links' ) ])
				 extra: self swagger2ExtensionKeys
				 unmodelled: #(  )
				 at: aPointer).
	self fillHeadersOf: aResponse from: aNode at: aPointer.
	self contentVisitor fillContentOf: aResponse from: aNode at: aPointer.
	self specVersion isSwagger2 ifTrue: [
		self contentVisitor
			fillSwagger2ContentOf: aResponse
			from: aNode
			mediaTypes: aList
			at: aPointer ].
	self fillLinksOf: aResponse from: aNode at: aPointer.
	context
		recordSourceTextOf: aResponse
		from: aNode
		category: (self sourceCategoryOf: aResponse)
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> fillResponsesOf: anOperation from: aNode at: aPointer [
	"Add to anOperation one Response per entry of the responses object of aNode (the status code is the key). A response that is a reference is cloned at its position. The Swagger 2 media types come from the produces of aNode, else of the root."

	| mediaTypes |
	mediaTypes := self mediaTypesFor: 'produces' in: aNode.
	self
		fixedEntriesAt: 'responses'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			(self
				 responseIn: node
				 at: pointer
				 statusCode: key
				 mediaTypes: mediaTypes) ifNotNil: [ :response |
				anOperation addResponse: response ] ]
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> headerNamed: aKey from: aNode at: aPointer [
	"Answer the Header aKey: the shared target when aNode is a reference (nil when it cannot be resolved), a new Header otherwise."

	| header |
	(self isReferenceNode: aNode) ifTrue: [
		^ self sharedTargetOf: aNode at: aPointer expecting: OPHeader ].
	header := self newEntity: OPHeader named: aKey pointer: aPointer.
	self fillHeader: header from: aNode at: aPointer.
	^ header
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> linkNamed: aKey from: aNode at: aPointer [
	"Answer the Link aKey: the shared target when aNode is a reference (nil when it cannot be resolved), a new Link otherwise."

	| link |
	(self isReferenceNode: aNode) ifTrue: [
		^ self sharedTargetOf: aNode at: aPointer expecting: OPLink ].
	link := self newEntity: OPLink named: aKey pointer: aPointer.
	self fillLink: link from: aNode at: aPointer.
	^ link
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> newResponseAt: aPointer statusCode: aCode [

	^ (self newEntity: OPResponse named: aCode pointer: aPointer)
		  statusCode: aCode;
		  yourself
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> responseIn: aNode at: aPointer statusCode: aCode [
	"Answer a new Response of status aCode at aPointer, with the root produces as Swagger 2 media types."

	^ self
		  responseIn: aNode
		  at: aPointer
		  statusCode: aCode
		  mediaTypes: (self mediaTypesFor: 'produces' in: nil)
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> responseIn: aNode at: aPointer statusCode: aCode mediaTypes: aList [
	"Answer a new Response of status aCode at aPointer: described by aNode, or, when aNode is a reference, a copy of the referenced node read at aPointer (it keeps the raw reference in its ref). aList holds the Swagger 2 media types. Nil when the reference cannot be resolved."

	| response ref target |
	(self isReferenceNode: aNode) ifFalse: [
		response := self newResponseAt: aPointer statusCode: aCode.
		self
			fillResponse: response
			from: aNode
			at: aPointer
			mediaTypes: aList.
		^ response ].
	ref := aNode at: '$ref'.
	target := self referencedNodeFor: ref at: aPointer.
	target ifNil: [ ^ nil ].
	response := self newResponseAt: aPointer statusCode: aCode.
	response ref: ref.
	self
		fillResponse: response
		from: target
		at: aPointer
		mediaTypes: aList.
	^ response
]

{ #category : 'visiting' }
FamixOpenApiResponseVisitor >> swagger2ExtensionKeys [
	"Answer the keys that only Swagger 2 responses have and that are kept in the extensions."

	^ self specVersion isSwagger2
		  ifTrue: [ #( 'examples' ) ]
		  ifFalse: [ #(  ) ]
]
