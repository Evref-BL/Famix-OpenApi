"
One row of the comparator table of the value check (FamixOpenApiValueRules): a field of a spec object of the source document, the OP class and the slot of the model that carries it, the name of the comparator that says how the source value is normalised and compared with the slot (FamixOpenApiValueComparator class>>named:) and the versions (#v30 #v31 #v2) the row is for. fieldKey is the key of the source object, or a pseudo key for a value taken from elsewhere: '{key}' for the key of the node in its parent (the status code of a response, the verb of an operation).
"
Class {
	#name : 'FamixOpenApiValueRule',
	#superclass : 'Object',
	#instVars : [
		'specObject',
		'fieldKey',
		'targetClassName',
		'selector',
		'comparatorName',
		'versions',
		'comparator'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiValueRule class >> specObject: aSpecObjectName className: aClassName row: anArray [
	"A rule from a row of the table: the field key, the selector of the slot, the name of the comparator and, optionally, the versions it is for (all of them when omitted)"

	^ self new
		  specObject: aSpecObjectName;
		  targetClassName: aClassName;
		  fieldKey: anArray first;
		  selector: (anArray at: 2);
		  comparatorName: (anArray at: 3);
		  versions: (anArray at: 4 ifAbsent: [ nil ]);
		  yourself
]

{ #category : 'testing' }
FamixOpenApiValueRule >> appliesTo: aVersion [
	"True when the rule is for the version aVersion (#v30, #v31 or #v2)"

	^ versions isNil or: [ versions includes: aVersion ]
]

{ #category : 'comparing' }
FamixOpenApiValueRule >> comparator [
	"The comparator that normalises and compares the values of the rule"

	^ comparator ifNil: [ comparator := FamixOpenApiValueComparator named: comparatorName ]
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> comparatorName [
	"The name of the comparator, see FamixOpenApiValueComparator class>>named:"

	^ comparatorName
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> comparatorName: aSymbol [

	comparatorName := aSymbol
]

{ #category : 'comparing' }
FamixOpenApiValueRule >> coverageKeyIn: aVersion [
	"The key of the coverage table: version, spec object, field and slot (a field may be carried by two classes)"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: aVersion;
			  space;
			  nextPutAll: specObject;
			  nextPut: $.;
			  nextPutAll: fieldKey;
			  nextPutAll: ' -> ';
			  nextPutAll: targetClassName;
			  nextPutAll: '>>';
			  nextPutAll: selector ]
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> fieldKey [
	"The key of the source field, or a pseudo key such as {key}"

	^ fieldKey
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> fieldKey: aString [

	fieldKey := aString
]

{ #category : 'testing' }
FamixOpenApiValueRule >> isAbout: aSpecObjectName in: aVersion [

	^ specObject = aSpecObjectName and: [ self appliesTo: aVersion ]
]

{ #category : 'printing' }
FamixOpenApiValueRule >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: specObject asString;
		nextPut: $.;
		nextPutAll: fieldKey asString;
		nextPutAll: ' -> ';
		nextPutAll: targetClassName asString;
		nextPutAll: '>>';
		nextPutAll: selector asString;
		nextPut: $)
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> selector [
	"The selector of the slot of the OP class"

	^ selector
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> selector: aSymbol [

	selector := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> specObject [
	"The name of the spec object of the source node"

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> specObject: aString [

	specObject := aString
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> targetClassName [
	"The name of the OP class that carries the slot"

	^ targetClassName
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> targetClassName: aString [

	targetClassName := aString
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> versions [
	"The versions the rule is for, nil for all of them"

	^ versions
]

{ #category : 'accessing' }
FamixOpenApiValueRule >> versions: anArrayOrNil [

	versions := anArrayOrNil
]
