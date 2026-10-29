"
I am one field of one object of an API specification (OpenAPI 3.0.3, OpenAPI 3.1.x or Swagger 2.0), as listed in FamixOpenApiSpecFieldTable.
I know the name of the spec object I belong to (e.g. 'Schema'), my own name (e.g. 'exclusiveMinimum'), the versions where I exist (a subset of #v30 #v31 #v2), my kind (#scalar #object #map #array #reference #any), my LEVEL (#structural #useful #metadata), whether I am required in the strictest case and an optional note describing version differences or conditions.
LEVEL is a proposal to be reviewed by the user.
"
Class {
	#name : 'FamixOpenApiSpecField',
	#superclass : 'Object',
	#instVars : [
		'specObject',
		'name',
		'versions',
		'kind',
		'level',
		'isRequired',
		'note'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiSpecField class >> fromRow: aRow specObject: aString [
	"aRow is #(name kind versions level required note)"

	^ self new
		  specObject: aString;
		  name: (aRow at: 1);
		  kind: (aRow at: 2);
		  versions: (aRow at: 3);
		  level: (aRow at: 4);
		  isRequired: (aRow at: 5);
		  note: (aRow at: 6);
		  yourself
]

{ #category : 'instance creation' }
FamixOpenApiSpecField class >> validKinds [

	^ #( scalar object map array reference any )
]

{ #category : 'instance creation' }
FamixOpenApiSpecField class >> validLevels [

	^ #( structural useful metadata )
]

{ #category : 'testing' }
FamixOpenApiSpecField >> appliesIn: aVersionSymbol [

	^ versions includes: aVersionSymbol
]

{ #category : 'testing' }
FamixOpenApiSpecField >> hasValidKind [

	^ self class validKinds includes: kind
]

{ #category : 'testing' }
FamixOpenApiSpecField >> hasValidLevel [

	^ self class validLevels includes: level
]

{ #category : 'testing' }
FamixOpenApiSpecField >> hasValidVersions [

	^ versions isNotEmpty and: [
		  versions allSatisfy: [ :each |
			  FamixOpenApiSpecFieldTable versions includes: each ] ]
]

{ #category : 'initialization' }
FamixOpenApiSpecField >> initialize [

	super initialize.
	isRequired := false.
	note := ''
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> isRequired [

	^ isRequired
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> isRequired: aBoolean [

	isRequired := aBoolean
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> kind [

	^ kind
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> kind: aSymbol [

	kind := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> level [

	^ level
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> level: aSymbol [

	level := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> name [

	^ name
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> name: aString [

	name := aString
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> note [

	^ note
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> note: aString [

	note := aString
]

{ #category : 'printing' }
FamixOpenApiSpecField >> printOn: aStream [

	aStream
		nextPutAll: specObject asString;
		nextPut: $.;
		nextPutAll: name asString;
		nextPutAll: ' ';
		print: versions;
		nextPutAll: ' ';
		print: level
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> specObject [

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> specObject: aString [

	specObject := aString
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> versions [

	^ versions
]

{ #category : 'accessing' }
FamixOpenApiSpecField >> versions: anArray [

	versions := anArray
]
