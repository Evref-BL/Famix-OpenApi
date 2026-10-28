"
I am an immutable-style value object describing one finding of an import. I hold a severity (#error, #warning or #info), a stable code Symbol (for example #unresolvedReference, #refCycle, #operationIdDuplicate, #wrongNodeType, #unknownKeyword, #unmodelledKeyword, #importError), the JSON pointer of the concerned node and a human readable message. I am not part of the metamodel.
"
Class {
	#name : 'FamixOpenApiDiagnostic',
	#superclass : 'Object',
	#instVars : [
		'severity',
		'code',
		'pointer',
		'message'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'instance creation' }
FamixOpenApiDiagnostic class >> severity: aSeverity code: aCode pointer: aPointer message: aMessage [
	"Answer a new diagnostic of severity aSeverity (#error, #warning or #info) identified by the stable Symbol aCode, concerning the node at aPointer."

	^ self new
		  setSeverity: aSeverity
		  code: aCode
		  pointer: aPointer
		  message: aMessage
]

{ #category : 'comparing' }
FamixOpenApiDiagnostic >> = anObject [
	"Two diagnostics are equal when their severity, code, pointer and message are equal."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ severity = anObject severity and: [
		  code = anObject code and: [
			  pointer = anObject pointer and: [ message = anObject message ] ] ]
]

{ #category : 'accessing' }
FamixOpenApiDiagnostic >> code [
	"Answer the stable Symbol identifying the kind of finding."

	^ code
]

{ #category : 'comparing' }
FamixOpenApiDiagnostic >> hash [
	"Answer a hash consistent with #=."

	^ (severity hash bitXor: code hash) bitXor:
		  (pointer hash bitXor: message hash)
]

{ #category : 'testing' }
FamixOpenApiDiagnostic >> isError [
	"Answer whether the receiver is an error."

	^ severity = #error
]

{ #category : 'testing' }
FamixOpenApiDiagnostic >> isInfo [
	"Answer whether the receiver is an information."

	^ severity = #info
]

{ #category : 'testing' }
FamixOpenApiDiagnostic >> isWarning [
	"Answer whether the receiver is a warning."

	^ severity = #warning
]

{ #category : 'accessing' }
FamixOpenApiDiagnostic >> message [
	"Answer the human readable description."

	^ message
]

{ #category : 'accessing' }
FamixOpenApiDiagnostic >> pointer [
	"Answer the String JSON pointer of the node concerned."

	^ pointer
]

{ #category : 'printing' }
FamixOpenApiDiagnostic >> printOn: aStream [
	"Print like 'warning unresolvedReference at #/paths/~1pets: message'."

	aStream
		nextPutAll: severity asString;
		space;
		nextPutAll: code asString;
		nextPutAll: ' at ';
		nextPutAll: pointer asString;
		nextPutAll: ': ';
		nextPutAll: message asString
]

{ #category : 'initialization' }
FamixOpenApiDiagnostic >> setSeverity: aSeverity code: aCode pointer: aPointer message: aMessage [

	severity := aSeverity.
	code := aCode.
	pointer := aPointer.
	message := aMessage
]

{ #category : 'accessing' }
FamixOpenApiDiagnostic >> severity [
	"Answer #error, #warning or #info."

	^ severity
]
