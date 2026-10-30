"
An entity that the importer should have built for a document without a node of its own at its pointer: its canonical pointer, the name of its OP class, the name of the synthetic rule that derives it (see FamixOpenApiSyntheticExpectations class>>dataRules) and the pointer of the source node it is derived from. A value object made by the derivations of the synthetic entities and compared with the model by FamixOpenApiExistenceCheck. #family is the class directly below OPEntity (the check compares them family by family, as it does for the nodes).
"
Class {
	#name : 'FamixOpenApiExpectedEntity',
	#superclass : 'Object',
	#instVars : [
		'pointer',
		'ruleName',
		'originPointer',
		'targetClassName'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiExpectedEntity class >> pointer: aPointer className: aClassName rule: aRuleName origin: anOriginPointer [

	^ self new
		  pointer: aPointer;
		  targetClassName: aClassName;
		  ruleName: aRuleName;
		  originPointer: anOriginPointer;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> family [
	"The class directly below OPEntity that the expected class belongs to"

	^ FamixOpenApiPointerLookup familyOfClass:
		  (Smalltalk at: targetClassName asSymbol)
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> originPointer [
	"The pointer of the source node the entity is derived from"

	^ originPointer
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> originPointer: aString [

	originPointer := aString
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> pointer [

	^ pointer
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> pointer: aString [

	pointer := aString
]

{ #category : 'printing' }
FamixOpenApiExpectedEntity >> printOn: aStream [

	aStream
		nextPutAll: targetClassName asString;
		nextPutAll: ' at ';
		nextPutAll: pointer asString;
		nextPutAll: ' (';
		nextPutAll: ruleName asString;
		nextPut: $)
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> ruleName [

	^ ruleName
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> ruleName: aSymbol [

	ruleName := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> targetClassName [
	"The name of the OP class the importer should build (a String)"

	^ targetClassName
]

{ #category : 'accessing' }
FamixOpenApiExpectedEntity >> targetClassName: aString [

	targetClassName := aString
]
