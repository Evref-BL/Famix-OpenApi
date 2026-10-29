"
A finding of the model coherence validator: one violation of an invariant that the importer must guarantee on an imported OPModel. It holds a severity (#error, #warning or #info), a stable code Symbol, the OP entity concerned (nil for a model-wide finding), the canonical pointer of that entity ('' when unknown) and a human readable message. It is a value object (equal when all its parts are equal) and is unrelated to the importer's FamixOpenApiDiagnostic: the validator never reads importer diagnostics.
"
Class {
	#name : 'FamixOpenApiFinding',
	#superclass : 'Object',
	#instVars : [
		'severity',
		'code',
		'entity',
		'pointer',
		'message'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiFinding class >> severity: aSeverity code: aCode entity: anEntity message: aString [
	"Answer a finding of severity #error, #warning or #info about anEntity (nil for the whole model)."

	^ self basicNew
		  setSeverity: aSeverity
		  code: aCode
		  entity: anEntity
		  message: aString;
		  yourself
]

{ #category : 'comparing' }
FamixOpenApiFinding >> = anObject [
	"Two findings are equal when their severity, code, entity, pointer and message are equal."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ severity = anObject severity and: [
		  code = anObject code and: [
			  entity == anObject entity and: [
				  pointer = anObject pointer and: [ message = anObject message ] ] ] ]
]

{ #category : 'accessing' }
FamixOpenApiFinding >> code [
	"Answer the stable Symbol identifying the kind of finding."

	^ code
]

{ #category : 'accessing' }
FamixOpenApiFinding >> entity [
	"Answer the OP entity concerned, or nil for a model-wide finding."

	^ entity
]

{ #category : 'comparing' }
FamixOpenApiFinding >> hash [
	"Answer a hash consistent with #=."

	^ ((severity hash bitXor: code hash) bitXor: entity identityHash)
		  bitXor: (pointer hash bitXor: message hash)
]

{ #category : 'testing' }
FamixOpenApiFinding >> isError [
	"Answer whether the receiver is an error."

	^ severity = #error
]

{ #category : 'testing' }
FamixOpenApiFinding >> isInfo [
	"Answer whether the receiver is an information."

	^ severity = #info
]

{ #category : 'testing' }
FamixOpenApiFinding >> isWarning [
	"Answer whether the receiver is a warning."

	^ severity = #warning
]

{ #category : 'accessing' }
FamixOpenApiFinding >> message [
	"Answer the human readable description."

	^ message
]

{ #category : 'accessing' }
FamixOpenApiFinding >> pointer [
	"Answer the canonical pointer of the entity concerned, or an empty String."

	^ pointer
]

{ #category : 'private' }
FamixOpenApiFinding >> pointerOf: anEntity [
	"Answer the canonical pointer of anEntity, or an empty String when there is none."

	^ anEntity
		  ifNil: [ '' ]
		  ifNotNil: [ anEntity canonicalPointer ifNil: [ '' ] ]
]

{ #category : 'printing' }
FamixOpenApiFinding >> printOn: aStream [
	"Print like 'error unnamedEntity at #/components/schemas/Pet: message'."

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
FamixOpenApiFinding >> setSeverity: aSeverity code: aCode entity: anEntity message: aString [

	severity := aSeverity.
	code := aCode.
	entity := anEntity.
	pointer := self pointerOf: anEntity.
	message := aString
]

{ #category : 'accessing' }
FamixOpenApiFinding >> severity [
	"Answer #error, #warning or #info."

	^ severity
]
