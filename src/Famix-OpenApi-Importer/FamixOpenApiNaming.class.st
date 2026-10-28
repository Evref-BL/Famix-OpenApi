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
