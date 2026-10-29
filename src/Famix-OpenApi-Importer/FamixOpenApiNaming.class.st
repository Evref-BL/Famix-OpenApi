"
I am a class-side helper computing names for OpenAPI entities, for instance the synthesized name of an operation that declares no operationId.
"
Class {
	#name : 'FamixOpenApiNaming',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'operations' }
FamixOpenApiNaming class >> collapseSeparatorsIn: aString [
	"Answer aString where each run of '_' is reduced to one '_' and the trailing '_' is removed."

	| result |
	result := String streamContents: [ :stream |
		          aString do: [ :each |
			          (each = $_ and: [
				           stream position > 0 and: [ stream contents last = $_ ] ])
				          ifFalse: [ stream nextPut: each ] ] ].
	^ (result endsWith: '_')
		  ifTrue: [ result allButLast ]
		  ifFalse: [ result ]
]

{ #category : 'limiting' }
FamixOpenApiNaming class >> limited: aString [
	"Answer aString usable as an entity name: each run of whitespace or control characters (newlines and tabs included) becomes one space, the ends are trimmed, and a text longer than #maxNameLength is cut so that the result is at most #maxNameLength characters long and ends with the ellipsis character (Unicode U+2026, one character). Other characters, Unicode included, are kept. A nil aString answers an empty string."

	| normalised |
	aString ifNil: [ ^ '' ].
	normalised := ' ' join: (aString asString collect: [ :each |
			               (each isSeparator or: [
				                each asInteger < 32 or: [ each asInteger = 127 ] ])
				               ifTrue: [ Character space ]
				               ifFalse: [ each ] ]) substrings.
	normalised size <= self maxNameLength ifTrue: [ ^ normalised ].
	^ (normalised first: self maxNameLength - 1) trimRight
	  , (String with: (Character value: 16r2026))
]

{ #category : 'limiting' }
FamixOpenApiNaming class >> maxNameLength [
	"Answer the maximum number of characters of a name given to an entity at import time."

	^ 80
]

{ #category : 'limiting' }
FamixOpenApiNaming class >> nameFromAny: aCollectionOfStrings fallback: aString [
	"Answer the limited form of the first element of aCollectionOfStrings that is neither nil nor blank, or aString when there is none."

	aCollectionOfStrings do: [ :each |
		| candidate |
		candidate := self limited: each.
		candidate isEmpty ifFalse: [ ^ candidate ] ].
	^ aString
]

{ #category : 'operations' }
FamixOpenApiNaming class >> synthesizedOperationNameFor: aVerbString path: aPathString [
	"Answer a name for an operation without operationId: the lowercase verb followed by the path segments, joined by '_' (for example 'get' and '/pets/{petId}' give 'get_pets_petId'). Characters that are not letters or digits become '_' and never produce a double or a trailing '_'."

	^ self collapseSeparatorsIn: (String streamContents: [ :stream |
			   stream
				   nextPutAll: aVerbString asLowercase;
				   nextPut: $_.
			   aPathString do: [ :each |
				   stream nextPut: (each isAlphaNumeric
						    ifTrue: [ each ]
						    ifFalse: [ $_ ]) ] ])
]
