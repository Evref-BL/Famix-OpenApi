"
I am one node of a source OpenAPI/Swagger JSON document, found by FamixOpenApiSourceWalker. I know my JSON pointer ('#/paths/~1pets/get'), the name of my spec object ('Operation'; 'Reference' for a node holding a $ref; the EXPECTED spec object when I am wrongShape), the pointer of my parent, the version of the document, my raw JSON value, my key (a name or an array index; nil for the root), the keys that the grammar does not know and my extension (x-*) keys.
"
Class {
	#name : 'FamixOpenApiSourceNode',
	#superclass : 'Object',
	#instVars : [
		'pointer',
		'specObject',
		'parentPointer',
		'version',
		'value',
		'key',
		'isWrongShape',
		'unknownKeys',
		'extensionKeys'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'pointers' }
FamixOpenApiSourceNode class >> escapeToken: aToken [
	"The order matters: ~ first, then /"

	^ (aToken asString copyReplaceAll: '~' with: '~0')
		  copyReplaceAll: '/'
		  with: '~1'
]

{ #category : 'pointers' }
FamixOpenApiSourceNode class >> pointerOf: aParentPointer child: aToken [
	"Answer the JSON pointer (RFC 6901) of the child aToken (a name or an index) of aParentPointer: '~' is written '~0' then '/' is written '~1' in a name"

	^ aParentPointer , '/' , (self escapeToken: aToken)
]

{ #category : 'pointers' }
FamixOpenApiSourceNode class >> rootPointer [

	^ '#'
]

{ #category : 'operations' }
FamixOpenApiSourceNode >> addExtensionKey: aKey [

	extensionKeys add: aKey
]

{ #category : 'operations' }
FamixOpenApiSourceNode >> addUnknownKey: aKey [

	unknownKeys add: aKey
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> extensionKeys [
	"The x-* keys of my object"

	^ extensionKeys
]

{ #category : 'initialization' }
FamixOpenApiSourceNode >> initialize [

	super initialize.
	isWrongShape := false.
	unknownKeys := OrderedCollection new.
	extensionKeys := OrderedCollection new
]

{ #category : 'testing' }
FamixOpenApiSourceNode >> isReference [

	^ specObject = 'Reference'
]

{ #category : 'testing' }
FamixOpenApiSourceNode >> isWrongShape [
	"True when the JSON type of my value does not fit the grammar"

	^ isWrongShape
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> key [
	"The key of the node in its parent: a name, or an Integer index (0-based) in an array; nil for the root"

	^ key
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> key: aNameOrIndex [

	key := aNameOrIndex
]

{ #category : 'operations' }
FamixOpenApiSourceNode >> markWrongShape [

	isWrongShape := true
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> parentPointer [
	"The pointer of the parent node, or of the container holding the node (nil for the root)"

	^ parentPointer
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> parentPointer: aString [

	parentPointer := aString
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> pointer [
	"The JSON pointer of the node, for example '#/paths/~1pets/get'"

	^ pointer
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> pointer: aString [

	pointer := aString
]

{ #category : 'printing' }
FamixOpenApiSourceNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: specObject asString;
		space;
		nextPutAll: pointer asString;
		nextPut: $)
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> specObject [
	"The name of the spec object (the expected one when the node is wrongShape)"

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> specObject: aString [

	specObject := aString
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> unknownKeys [
	"The keys of my object that are neither in the field table nor extensions"

	^ unknownKeys
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> value [
	"The raw JSON value of the node"

	^ value
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> value: aJsonValue [

	value := aJsonValue
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> version [

	^ version
]

{ #category : 'accessing' }
FamixOpenApiSourceNode >> version: aSymbol [

	version := aSymbol
]
