"
I am a class-side helper computing names for OpenAPI entities, for instance the synthesized name of an operation that declares no operationId.
"
Class {
	#name : 'FamixOpenApiNaming',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'structural names' }
FamixOpenApiNaming class >> baseShapeNameOf: aSchema depth: anInteger visited: aSet [
	"Answer the name of the shape of aSchema without its nullability: array, object, enum, const or scalar, or an empty String when it has none."

	(self isArray: aSchema) ifTrue: [
		^ self nameOfArray: aSchema depth: anInteger visited: aSet ].
	(self isObject: aSchema) ifTrue: [
		^ self nameOfObject: aSchema depth: anInteger visited: aSet ].
	(self isBlankText: aSchema enumValues) ifFalse: [
		^ self nameOfEnum: aSchema ].
	(aSchema types isEmpty and: [
		 (self isBlankText: aSchema constValue) not ]) ifTrue: [
		^ 'const ' , aSchema constValue ].
	^ self nameOfScalar: aSchema
]

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

{ #category : 'structural names' }
FamixOpenApiNaming class >> compositionNameOf: aSchema depth: anInteger visited: aSet [
	"Answer the name of aSchema built from its oneOf, anyOf, allOf or not (in this order of priority), or an empty String when it has none."

	aSchema oneOf ifNotEmpty: [ :members |
		^ self
			  membersNameOf: members
			  depth: anInteger
			  visited: aSet
			  separator: ' | ' ].
	aSchema anyOf ifNotEmpty: [ :members |
		^ 'anyOf(' , (self
			   membersNameOf: members
			   depth: anInteger
			   visited: aSet
			   separator: ', ') , ')' ].
	aSchema allOf ifNotEmpty: [ :members |
		^ 'allOf(' , (self
			   membersNameOf: members
			   depth: anInteger
			   visited: aSet
			   separator: ', ') , ')' ].
	aSchema not ifNotNil: [ :excluded |
		^ 'not '
		  , (self memberNameOf: excluded depth: anInteger visited: aSet) ].
	^ ''
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> ellipsis [
	"Answer the one-character String that stands for an omitted part of a name (Unicode U+2026)."

	^ String with: (Character value: 16r2026)
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> enumValuesOf: aSchema [
	"Answer the values of the enum of aSchema, read from its JSON array text. A text that is not a JSON array is answered as the only value."

	| parsed |
	parsed := [ NeoJSONReader fromString: aSchema enumValues ]
		          on: NeoJSONParseError
		          do: [ :error | aSchema enumValues ].
	^ parsed isArray
		  ifTrue: [ parsed ]
		  ifFalse: [ { parsed } ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> hasOwnName: aSchema [
	"Answer whether aSchema has a name of its own that is not blank. A schema owned by components always has one, and so does any other named schema: this is how the targets of a $ref are rendered."

	^ aSchema name isNotNil and: [ aSchema name trimmed isNotEmpty ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> isArray: aSchema [
	"Answer whether aSchema is declared as an array or has items or prefixItems."

	^ (aSchema types includes: 'array') or: [
		  aSchema items isNotNil or: [ aSchema prefixItems isNotEmpty ] ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> isBlankText: aStringOrNil [
	"Answer whether aStringOrNil is nil or contains nothing but separators."

	^ aStringOrNil isNil or: [ aStringOrNil trimmed isEmpty ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> isObject: aSchema [
	"Answer whether aSchema is declared as an object or has properties or additionalProperties."

	^ (aSchema types includes: 'object') or: [
		  aSchema properties isNotEmpty or: [
			  aSchema additionalProperties isNotNil ] ]
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

{ #category : 'structural names' }
FamixOpenApiNaming class >> maxListedEnumValues [
	"Answer the maximal number of enum values listed in a structural name."

	^ 3
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> maxListedProperties [
	"Answer the maximal number of property names listed in a structural name."

	^ 4
]

{ #category : 'limiting' }
FamixOpenApiNaming class >> maxNameLength [
	"Answer the maximum number of characters of a name given to an entity at import time."

	^ 80
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> maxStructuralDepth [
	"Answer the number of levels of nested schemas that are rendered in a structural name; deeper ones are rendered as an ellipsis."

	^ 3
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> memberNameOf: aSchema depth: anInteger visited: aSet [
	"Answer the name of aSchema nested one level below the schema rendered at depth anInteger, already cut to the maximal length of a name."

	^ self limited:
		  (self structuralNameOf: aSchema depth: anInteger + 1 visited: aSet)
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> membersNameOf: aCollection depth: anInteger visited: aSet separator: aString [
	"Answer the names of the members of aCollection joined by aString. The members after the first ones that already exceed the maximal length of a name are not rendered."

	^ String streamContents: [ :stream |
		  aCollection do: [ :each |
			  stream position > self maxNameLength ifFalse: [
				  stream isEmpty ifFalse: [ stream nextPutAll: aString ].
				  stream nextPutAll:
					  (self memberNameOf: each depth: anInteger visited: aSet) ] ] ]
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

{ #category : 'structural names' }
FamixOpenApiNaming class >> nameOfArray: aSchema depth: anInteger visited: aSet [
	"Answer 'tuple [A, B]' for an array with prefixItems, 'array of X' for an array with items and 'array' otherwise."

	aSchema prefixItems ifNotEmpty: [ :tuple |
		^ 'tuple [' , (self
			   membersNameOf: tuple
			   depth: anInteger
			   visited: aSet
			   separator: ', ') , ']' ].
	^ aSchema items ifNil: [ 'array' ] ifNotNil: [ :items |
		  'array of '
		  , (self memberNameOf: items depth: anInteger visited: aSet) ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> nameOfEnum: aSchema [
	"Answer '<types> enum {a, b, c}' where at most #maxListedEnumValues values are listed, followed by an ellipsis when there are more."

	| values listed |
	values := self enumValuesOf: aSchema.
	listed := (values first: (values size min: self maxListedEnumValues))
		          collect: [ :each |
		          self limited: (self textOfEnumValue: each) ].
	^ String streamContents: [ :stream |
		  aSchema types isEmpty ifFalse: [
			  stream
				  nextPutAll: (self typesNameOf: aSchema);
				  space ].
		  stream nextPutAll: 'enum {'.
		  stream nextPutAll: (', ' join: listed).
		  values size > listed size ifTrue: [
			  stream
				  nextPutAll: ', ';
				  nextPutAll: self ellipsis ].
		  stream nextPut: $} ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> nameOfObject: aSchema depth: anInteger visited: aSet [
	"Answer 'object {a, b}' for an object with properties, 'map of X' for an object whose additionalProperties is a schema and 'object' otherwise."

	aSchema properties ifNotEmpty: [ :properties |
		^ self nameOfPropertiesNamed:
			  (properties collect: [ :each | each name ]) ].
	^ aSchema additionalProperties
		  ifNil: [ 'object' ]
		  ifNotNil: [ :values |
			  'map of '
			  , (self memberNameOf: values depth: anInteger visited: aSet) ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> nameOfPropertiesNamed: aCollectionOfStrings [
	"Answer 'object {a, b, c, d, …}' where the names are sorted and at most #maxListedProperties are listed."

	| names listed |
	names := self sortedStrings: aCollectionOfStrings.
	listed := names first: (names size min: self maxListedProperties).
	^ String streamContents: [ :stream |
		  stream nextPutAll: 'object {'.
		  stream nextPutAll: (', ' join: listed).
		  names size > listed size ifTrue: [
			  stream
				  nextPutAll: ', ';
				  nextPutAll: self ellipsis ].
		  stream nextPut: $} ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> nameOfScalar: aSchema [
	"Answer the types of aSchema followed by its format when it has one, for example 'integer int32'. A schema with neither answers an empty String."

	^ String streamContents: [ :stream |
		  stream nextPutAll: (self typesNameOf: aSchema).
		  (self isBlankText: aSchema format) ifFalse: [
			  stream isEmpty ifFalse: [ stream space ].
			  stream nextPutAll: aSchema format trimmed ] ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> referenceNameOf: aSchema [
	"Answer the last segment of the $ref of aSchema, for a reference that was not resolved, or an empty String when it has none."

	^ (self isBlankText: aSchema ref)
		  ifTrue: [ '' ]
		  ifFalse: [
		  (aSchema ref substrings: '/') ifEmpty: [ '' ] ifNotEmpty: #last ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> shapeNameOf: aSchema depth: anInteger visited: aSet [
	"Answer the name of aSchema built from its types, structure, enum and const, followed by its nullability, or an empty String when it has no shape."

	| base |
	base := self baseShapeNameOf: aSchema depth: anInteger visited: aSet.
	(aSchema isNullable ifNil: [ false ]) ifFalse: [ ^ base ].
	base isEmpty ifTrue: [ ^ 'null' ].
	^ aSchema types size > 1
		  ifTrue: [ base , '/null' ]
		  ifFalse: [ base , '?' ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> sortedStrings: aCollectionOfStrings [
	"Answer the strings sorted with a case-sensitive comparison, so that the order does not depend on the order of aCollectionOfStrings ('a' and 'A' are different and ordered)."

	^ aCollectionOfStrings asArray sorted: [ :a :b |
		  a caseSensitiveLessOrEqual: b ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> structuralNameOf: aSchema [
	"Answer a short String describing the shape of aSchema (for example 'array of Pet' or 'object {caption, file}'), used to name inline schemas, which are merged by content. The model is never modified; a nil aSchema, an empty schema and a boolean schema answer 'any'. Cycles and deep nestings end with an ellipsis."

	^ self limited:
		  (self structuralNameOf: aSchema depth: 0 visited: IdentitySet new)
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> structuralNameOf: aSchema depth: anInteger visited: aSet [
	"Answer the unlimited structural name of aSchema, rendered anInteger levels below the schema being named. aSet holds the schemas being rendered on the current path."

	| rendered |
	aSchema ifNil: [ ^ 'any' ].
	(self hasOwnName: aSchema) ifTrue: [ ^ aSchema name trimmed ].
	(anInteger >= self maxStructuralDepth or: [ aSet includes: aSchema ])
		ifTrue: [ ^ self ellipsis ].
	aSet add: aSchema.
	rendered := self
		            compositionNameOf: aSchema
		            depth: anInteger
		            visited: aSet.
	rendered isEmpty ifTrue: [
		rendered := self shapeNameOf: aSchema depth: anInteger visited: aSet ].
	aSet remove: aSchema.
	rendered isEmpty ifTrue: [ rendered := self referenceNameOf: aSchema ].
	^ rendered isEmpty
		  ifTrue: [ 'any' ]
		  ifFalse: [ rendered ]
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

{ #category : 'structural names' }
FamixOpenApiNaming class >> textOfEnumValue: anObject [
	"Answer the text of one enum value: a string as it is, null for nil and the printed form of any other value."

	anObject ifNil: [ ^ 'null' ].
	^ anObject isString
		  ifTrue: [ anObject ]
		  ifFalse: [ anObject printString ]
]

{ #category : 'structural names' }
FamixOpenApiNaming class >> typesNameOf: aSchema [
	"Answer the types of aSchema sorted and joined by '/'."

	^ '/' join: (self sortedStrings: aSchema types)
]
