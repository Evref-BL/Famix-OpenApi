"
The two values a FamixOpenApiGap is about: what the source says should be in the model (expected) and what the model holds instead (found). Either one may be nil, as in a gap about a missing or an extra entity. FamixOpenApiGap keeps them together so that it stays small; it answers them through its own #expected and #found.
"
Class {
	#name : 'FamixOpenApiGapValues',
	#superclass : 'Object',
	#instVars : [
		'expected',
		'found'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiGapValues >> expected [
	"What the source says should be in the model"

	^ expected
]

{ #category : 'accessing' }
FamixOpenApiGapValues >> expected: anObject [

	expected := anObject
]

{ #category : 'accessing' }
FamixOpenApiGapValues >> found [
	"What the model holds instead"

	^ found
]

{ #category : 'accessing' }
FamixOpenApiGapValues >> found: anObject [

	found := anObject
]
