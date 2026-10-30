"
A difference between a source OpenAPI/Swagger document and the model imported from it: a value object shared by the fidelity checks. It says WHERE (sourcePointer, the spec object of the source node, the model entity when there is one, fieldKey for the checks on a field, the file when the document comes from a file), WHAT (kind, a Symbol) and the expected and found values with a message. The ruleName is the synthetic rule that expects an entity without source node (existence check, V7b), nil for the other gaps.
Kinds used by the existence check (V7): #missingEntity (a source node, or a derivation, expects an entity that is not there), #wrongClass (the entity is of another class than the one expected), #extraEntity (an entity that no node and no derivation expects, or an entity of a family the node should not give), #unexpectedMultiple (more entities of a family at a pointer than expected), #preconditionMerged (the model was imported with the inline schemas merged), #preconditionVersion (the version of the document is unknown), #referenceNotResolved (an unresolved $ref has neither an OPReference at its site nor a diagnostic), #countMismatch and #valueMismatch (the number, the pointers and the urls of the synthesised servers; #countMismatch and #valueMismatch are also the kinds of the value checks of the next steps).
Kinds reserved for the next steps: #lost #onlyInExtensions #ignoredByDiagnostic.
"
Class {
	#name : 'FamixOpenApiGap',
	#superclass : 'Object',
	#instVars : [
		'sourcePointer',
		'entity',
		'specObject',
		'fieldKey',
		'kind',
		'expected',
		'found',
		'message',
		'file',
		'ruleName'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiGap class >> kind: aSymbol pointer: aPointer specObject: aSpecObjectName [
	"A gap of the kind aSymbol at the source pointer, for a source node of the spec object (nil for an entity without source node)"

	^ self new
		  kind: aSymbol;
		  sourcePointer: aPointer;
		  specObject: aSpecObjectName;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiGap >> entity [
	"The model entity concerned, nil when there is none"

	^ entity
]

{ #category : 'accessing' }
FamixOpenApiGap >> entity: anEntity [

	entity := anEntity
]

{ #category : 'accessing' }
FamixOpenApiGap >> expected [
	"What the source says should be in the model"

	^ expected
]

{ #category : 'accessing' }
FamixOpenApiGap >> expected: anObject [

	expected := anObject
]

{ #category : 'accessing' }
FamixOpenApiGap >> fieldKey [
	"The field the gap is about; nil for the existence checks"

	^ fieldKey
]

{ #category : 'accessing' }
FamixOpenApiGap >> fieldKey: aString [

	fieldKey := aString
]

{ #category : 'accessing' }
FamixOpenApiGap >> file [
	"The name of the source file, nil when the document does not come from a file"

	^ file
]

{ #category : 'accessing' }
FamixOpenApiGap >> file: aString [

	file := aString
]

{ #category : 'accessing' }
FamixOpenApiGap >> found [
	"What the model holds instead"

	^ found
]

{ #category : 'accessing' }
FamixOpenApiGap >> found: anObject [

	found := anObject
]

{ #category : 'accessing' }
FamixOpenApiGap >> kind [
	"A Symbol, see the class comment"

	^ kind
]

{ #category : 'accessing' }
FamixOpenApiGap >> kind: aSymbol [

	kind := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiGap >> message [

	^ message
]

{ #category : 'accessing' }
FamixOpenApiGap >> message: aString [

	message := aString
]

{ #category : 'printing' }
FamixOpenApiGap >> printOn: aStream [

	aStream
		nextPutAll: kind asString;
		space;
		nextPutAll: sourcePointer asString;
		nextPutAll: ' (';
		nextPutAll: specObject asString;
		nextPutAll: '): expected ';
		print: expected;
		nextPutAll: ', found ';
		print: found
]

{ #category : 'accessing' }
FamixOpenApiGap >> ruleName [
	"The name of the synthetic rule that derives the expected entity this gap is about, nil for a gap about a node of the document"

	^ ruleName
]

{ #category : 'accessing' }
FamixOpenApiGap >> ruleName: aSymbol [

	ruleName := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiGap >> sourcePointer [
	"The JSON pointer of the source node, or the canonical pointer of an entity that has no source node"

	^ sourcePointer
]

{ #category : 'accessing' }
FamixOpenApiGap >> sourcePointer: aPointer [

	sourcePointer := aPointer
]

{ #category : 'accessing' }
FamixOpenApiGap >> specObject [
	"The name of the spec object of the source node, nil for an entity without source node"

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiGap >> specObject: aString [

	specObject := aString
]
