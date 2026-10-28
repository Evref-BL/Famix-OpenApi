"
I am a class-side utility for JSON Pointers (RFC 6901) and for the URI fragment form used by OpenAPI '$ref' values (for example '#/components/schemas/Pet%20Dog'). I split a reference into decoded tokens, encode tokens back into a pointer, and walk a parsed NeoJSON tree. Resolution never raises: a missing step answers the unique marker returned by #notFound.
"
Class {
	#name : 'FamixOpenApiJsonPointer',
	#superclass : 'Object',
	#classInstVars : [
		'notFound'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'resolving' }
FamixOpenApiJsonPointer class >> childOf: aJsonNode at: aToken [
	"Answer the child of aJsonNode named by aToken, or the notFound marker when there is none (scalars have no children)."

	aJsonNode isDictionary ifTrue: [
		^ aJsonNode at: aToken ifAbsent: [ self notFound ] ].
	(aJsonNode isCollection and: [ aJsonNode isString not ]) ifFalse: [
		^ self notFound ].
	^ (self indexFromToken: aToken)
		  ifNil: [ self notFound ]
		  ifNotNil: [ :index |
			  index <= aJsonNode size
				  ifTrue: [ aJsonNode asOrderedCollection at: index ]
				  ifFalse: [ self notFound ] ]
]

{ #category : 'encoding' }
FamixOpenApiJsonPointer class >> encodeToken: aString [
	"Answer aString escaped as a JSON pointer token: '~' becomes '~0' then '/' becomes '~1' (the order matters)."

	^ (aString asString copyReplaceAll: '~' with: '~0')
		  copyReplaceAll: '/'
		  with: '~1'
]

{ #category : 'resolving' }
FamixOpenApiJsonPointer class >> indexFromToken: aToken [
	"Answer the 1-based index denoted by the 0-based decimal array token aToken, or nil when aToken is not a plain decimal number."

	(aToken isString and: [
		 aToken notEmpty and: [ aToken allSatisfy: #isDigit ] ]) ifFalse: [
		^ nil ].
	^ aToken asInteger + 1
]

{ #category : 'tokens' }
FamixOpenApiJsonPointer class >> isLocalReference: aString [
	"Answer true when aString is a reference to the current document, that is a String starting with '#'."

	^ aString isString and: [ aString beginsWith: '#' ]
]

{ #category : 'resolving' }
FamixOpenApiJsonPointer class >> notFound [
	"Answer the unique marker answered by the resolve messages when a step of a pointer is missing. It is an object distinct from any JSON value, nil included (a JSON null resolves to nil)."

	^ notFound ifNil: [ notFound := Object new ]
]

{ #category : 'tokens' }
FamixOpenApiJsonPointer class >> percentDecode: aString [
	"Answer aString with its %XX sequences decoded (UTF-8). A malformed sequence leaves aString unchanged."

	(aString includes: $%) ifFalse: [ ^ aString ].
	^ [ ZnPercentEncoder new decode: aString ]
		  on: Error
		  do: [ :error | aString ]
]

{ #category : 'encoding' }
FamixOpenApiJsonPointer class >> pointer: aPointer appending: aToken [
	"Answer aPointer extended with aToken (a String or an Integer)."

	^ aPointer , '/' , (self encodeToken: aToken)
]

{ #category : 'encoding' }
FamixOpenApiJsonPointer class >> pointerFromTokens: aCollection [
	"Answer the pointer ('#' followed by '/' and the encoded token for each token) of aCollection. No percent-encoding is added."

	^ String streamContents: [ :stream |
		  stream nextPut: $#.
		  aCollection do: [ :token |
			  stream
				  nextPut: $/;
				  nextPutAll: (self encodeToken: token) ] ]
]

{ #category : 'resolving' }
FamixOpenApiJsonPointer class >> resolveReference: aString in: aJsonNode [
	"Answer the node designated by the local reference aString in aJsonNode, or #notFound when the reference is not local or a step is missing."

	| tokens |
	tokens := self tokensFromReference: aString.
	tokens ifNil: [ ^ self notFound ].
	^ self resolveTokens: tokens in: aJsonNode
]

{ #category : 'resolving' }
FamixOpenApiJsonPointer class >> resolveTokens: aCollection in: aJsonNode [
	"Walk aJsonNode (parsed NeoJSON: Dictionary for objects, SequenceableCollection for arrays whose tokens are 0-based decimal indices) along the tokens of aCollection. Answer the reached node, or #notFound when a step is missing."

	| node |
	node := aJsonNode.
	aCollection do: [ :token |
		node := self childOf: node at: token.
		node == self notFound ifTrue: [ ^ node ] ].
	^ node
]

{ #category : 'tokens' }
FamixOpenApiJsonPointer class >> splitPointerBody: aString [
	"Answer an Array of the raw tokens of aString (a pointer without its leading '/'), keeping empty tokens."

	| tokens current |
	tokens := OrderedCollection new.
	current := WriteStream on: String new.
	aString do: [ :each |
		each = $/
			ifTrue: [
				tokens add: current contents.
				current := WriteStream on: String new ]
			ifFalse: [ current nextPut: each ] ].
	tokens add: current contents.
	^ tokens asArray
]

{ #category : 'tokens' }
FamixOpenApiJsonPointer class >> tokensFromReference: aString [
	"Answer an Array of decoded String tokens for the local reference aString ('#', '', '#/a/b' or '/a/b'). Answer nil when aString is not a local JSON pointer (for example an external reference). In a URI fragment (starting with #) each token is percent-decoded after splitting on '/'; then '~1' becomes '/' and '~0' becomes '~'."

	| isFragment pointer |
	aString isString ifFalse: [ ^ nil ].
	isFragment := aString beginsWith: '#'.
	pointer := isFragment
		           ifTrue: [ aString allButFirst ]
		           ifFalse: [ aString ].
	pointer isEmpty ifTrue: [ ^ #(  ) ].
	(pointer beginsWith: '/') ifFalse: [ ^ nil ].
	^ (self splitPointerBody: pointer allButFirst) collect: [ :rawToken |
		  self unescapeToken: (isFragment
				   ifTrue: [ self percentDecode: rawToken ]
				   ifFalse: [ rawToken ]) ]
]

{ #category : 'tokens' }
FamixOpenApiJsonPointer class >> unescapeToken: aString [
	"Answer aString with '~1' replaced by '/' then '~0' by '~' (RFC 6901 order)."

	^ (aString copyReplaceAll: '~1' with: '/')
		  copyReplaceAll: '~0'
		  with: '~'
]
