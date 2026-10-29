"
I am one result of the reverse conformance check: a slot or relation of the metamodel (a FamixOpenApiModelSlot) that corresponds to no spec field. Status is #modelOnly when the reason is known (importer-internal, derived, inverse relation...) and #unexplained when nothing explains it. reason says why.
"
Class {
	#name : 'FamixOpenApiModelOnlyRow',
	#superclass : 'Object',
	#instVars : [
		'slot',
		'status',
		'reason'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiModelOnlyRow class >> slot: aModelSlot reason: aReasonOrNil [
	"A known reason makes a #modelOnly row, no reason an #unexplained one."

	^ self new
		  slot: aModelSlot;
		  status:
			  (aReasonOrNil ifNil: [ #unexplained ] ifNotNil: [ #modelOnly ]);
		  reason: (aReasonOrNil ifNil: [ '' ]);
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> key [

	^ slot key
]

{ #category : 'printing' }
FamixOpenApiModelOnlyRow >> printOn: aStream [

	aStream
		nextPutAll: self key;
		nextPutAll: ' ';
		nextPutAll: status
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> reason [

	^ reason
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> reason: aString [

	reason := aString
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> slot [

	^ slot
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> slot: aModelSlot [

	slot := aModelSlot
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> status [
	"#modelOnly when the reason is known, #unexplained otherwise"

	^ status
]

{ #category : 'accessing' }
FamixOpenApiModelOnlyRow >> status: aSymbol [

	status := aSymbol
]
