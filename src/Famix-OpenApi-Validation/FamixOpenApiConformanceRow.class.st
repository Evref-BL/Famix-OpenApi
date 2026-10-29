"
I am one result of the conformance check: one field of one spec object in one version (#v30, #v31 or #v2), with its LEVEL from the field table, its status and where the metamodel carries it. Status is #modelledSlot (a scalar slot carries the field), #modelledRelation (a relation carries it), #implicit (the structure or a conversion carries it), #notModelled (the metamodel has nothing for it) or #notApplicable. targetClassName and targetSelector name the OP class and the slot or relation (nil when not modelled); note explains the decision.
"
Class {
	#name : 'FamixOpenApiConformanceRow',
	#superclass : 'Object',
	#instVars : [
		'specObject',
		'fieldName',
		'version',
		'level',
		'status',
		'targetClassName',
		'targetSelector',
		'note'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiConformanceRow class >> for: aSpecField in: aVersion [
	"A row about aSpecField in aVersion, to be completed with beStatus:class:selector:note:"

	^ self new
		  specObject: aSpecField specObject;
		  fieldName: aSpecField name;
		  version: aVersion;
		  level: aSpecField level;
		  yourself
]

{ #category : 'updating' }
FamixOpenApiConformanceRow >> beStatus: aStatus class: aClassName selector: aSelector note: aString [

	status := aStatus.
	targetClassName := aClassName.
	targetSelector := aSelector.
	note := aString
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> cellTexts [
	"The texts of the row in the columns object, field, level, status, OP target and note"

	^ {
		  specObject.
		  fieldName.
		  level.
		  status.
		  self target.
		  note } collect: [ :each | each asString ]
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> fieldName [

	^ fieldName
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> fieldName: aString [

	fieldName := aString
]

{ #category : 'testing' }
FamixOpenApiConformanceRow >> isModelled [
	"True when the metamodel carries the field, whatever the way"

	^ #( #modelledSlot #modelledRelation #implicit ) includes: status
]

{ #category : 'testing' }
FamixOpenApiConformanceRow >> isNotModelled [

	^ status = #notModelled
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> level [

	^ level
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> level: aSymbol [

	level := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> note [

	^ note
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> note: aString [

	note := aString
]

{ #category : 'printing' }
FamixOpenApiConformanceRow >> printOn: aStream [

	aStream
		nextPutAll: specObject;
		nextPut: $.;
		nextPutAll: fieldName;
		nextPut: $@;
		nextPutAll: version;
		nextPutAll: ' ';
		nextPutAll: status
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> specObject [

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> specObject: aString [

	specObject := aString
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> status [

	^ status
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> status: aSymbol [

	status := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> summaryKey [
	"Key of the row in the summary of the report: version, level and status"

	^ {
		  version.
		  level.
		  status }
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> target [
	"Answer the OP class and selector as text, for example OPInfo>>title, or an empty string"

	^ targetSelector
		  ifNil: [ '' ]
		  ifNotNil: [ targetClassName , '>>' , targetSelector ]
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> targetClassName [

	^ targetClassName
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> targetSelector [

	^ targetSelector
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> targetSelector: aSymbolOrNil [

	targetSelector := aSymbolOrNil
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> version [

	^ version
]

{ #category : 'accessing' }
FamixOpenApiConformanceRow >> version: aSymbol [

	version := aSymbol
]
