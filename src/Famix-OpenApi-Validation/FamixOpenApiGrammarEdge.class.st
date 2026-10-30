"
I am one edge of FamixOpenApiSpecGrammar: the shape of the child held by one field of one spec object (for example Operation.requestBody holds an object of spec object RequestBody, Components.schemas a map of Schema). My kind is one of #scalar (no descent), #object, #map (keys are names), #array (all with a target spec object), #arrayOfScalars, #mapOfScalars, #mapOfAny, #mapOfArrays (checked for their JSON type only), #any (free JSON, no descent), #reference (a $ref-like field, no descent) or #unknown (the null edge of a key the grammar does not know). I am patterned when my name is a pattern such as '/{path}' or '{HTTP status code}': I then describe each key of the object that I match.
"
Class {
	#name : 'FamixOpenApiGrammarEdge',
	#superclass : 'Object',
	#instVars : [
		'specObject',
		'name',
		'kind',
		'target',
		'versions'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiGrammarEdge class >> extensionOf: aSpecObjectName versions: aVersionCollection [
	"The #any edge of the x-* keys of aSpecObjectName"

	^ self
		  fromRow: {
				  'x-*'.
				  #any.
				  nil.
				  aVersionCollection }
		  specObject: aSpecObjectName
]

{ #category : 'instance creation' }
FamixOpenApiGrammarEdge class >> fromRow: aRow specObject: aSpecObjectName [

	^ self basicNew
		  initializeFromRow: aRow specObject: aSpecObjectName;
		  yourself
]

{ #category : 'instance creation' }
FamixOpenApiGrammarEdge class >> unknown [
	"The null edge of a key that the grammar does not know"

	^ self fromRow: #( '?' #unknown nil #(  ) ) specObject: '?'
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> appliesIn: aVersionSymbol [

	^ versions includes: aVersionSymbol
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> descends [
	"True when the walker has to look at the child of this edge (a spec object, or a map or array that is checked)"

	^ self isObjectEdge or: [ self isContainerEdge ]
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> expectsArray [
	"True for the kind that is checked to be a JSON array without descending into it"

	^ kind = #arrayOfScalars
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> expectsDictionary [
	"True for the kinds that are checked to be a JSON object without descending into them"

	^ #( #mapOfScalars #mapOfAny #mapOfArrays ) includes: kind
]

{ #category : 'initialization' }
FamixOpenApiGrammarEdge >> initializeFromRow: aRow specObject: aSpecObjectName [
	"aRow is #(field kind target versions)"

	specObject := aSpecObjectName.
	name := aRow first.
	kind := aRow second.
	target := aRow third.
	versions := aRow fourth
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isArrayOfObjects [

	^ kind = #array
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isContainerEdge [
	"True when the child is a map or an array whose JSON type is checked (and whose entries are spec objects for #map and #array)"

	^ self isMapOfObjects or: [
		  self isArrayOfObjects or: [
			  self expectsDictionary or: [ self expectsArray ] ] ]
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isExtension [

	^ name = 'x-*'
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isMapOfObjects [

	^ kind = #map
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isObjectEdge [

	^ kind = #object
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isPatterned [
	"A patterned field names a pattern ('/{path}', '{expression}') instead of one fixed key"

	^ (name beginsWith: '{') or: [ name beginsWith: '/' ]
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isScalar [

	^ kind = #scalar
]

{ #category : 'private' }
FamixOpenApiGrammarEdge >> isStatusCode: aKey [
	"An HTTP status code (200) or a range (2XX)"

	| rest |
	aKey size = 3 ifFalse: [ ^ false ].
	(aKey first between: $1 and: $5) ifFalse: [ ^ false ].
	rest := aKey allButFirst.
	^ rest = 'XX' or: [ rest allSatisfy: #isDigit ]
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> isUnknown [

	^ kind = #unknown
]

{ #category : 'accessing' }
FamixOpenApiGrammarEdge >> kind [

	^ kind
]

{ #category : 'testing' }
FamixOpenApiGrammarEdge >> matchesKey: aKey [
	"Whether the patterned edge describes the key aKey of its object"

	(name beginsWith: '/') ifTrue: [ ^ aKey beginsWith: '/' ].
	name = '{HTTP status code}' ifTrue: [ ^ self isStatusCode: aKey ].
	^ true
]

{ #category : 'accessing' }
FamixOpenApiGrammarEdge >> name [

	^ name
]

{ #category : 'printing' }
FamixOpenApiGrammarEdge >> printOn: aStream [

	aStream
		nextPutAll: specObject asString;
		nextPut: $.;
		nextPutAll: name asString;
		nextPutAll: ' -> ';
		print: kind.
	target ifNotNil: [ :targetName |
		aStream
			space;
			nextPutAll: targetName ]
]

{ #category : 'accessing' }
FamixOpenApiGrammarEdge >> specObject [

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiGrammarEdge >> target [
	"The name of the spec object of the child (or of its elements), or nil when the kind has no target"

	^ target
]

{ #category : 'accessing' }
FamixOpenApiGrammarEdge >> versions [

	^ versions
]
