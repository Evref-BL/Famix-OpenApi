"
Comparators #inclusiveMaximum, #exclusiveMaximum, #inclusiveMinimum and #exclusiveMinimum, for OpenAPI 3.0 and Swagger 2 where exclusiveMaximum and exclusiveMinimum are booleans next to maximum and minimum. The importer moves the bound (VERIFIED): with the boolean true, the number is in the slot exclusiveMaximum (exclusiveMinimum) and the slot maximum (minimum) is nil; with false or without the boolean, the number is in maximum (minimum) and the exclusive slot is nil; the boolean alone gives nothing. OpenAPI 3.1 has numbers for both keys, compared by FamixOpenApiNumberComparator. A bound that is not a number or a boolean that is not a boolean is not compared.
"
Class {
	#name : 'FamixOpenApiBoundComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiBoundComparator class >> comparatorNames [

	^ self dataBounds collect: #first
]

{ #category : 'data' }
FamixOpenApiBoundComparator class >> dataBounds [
	"Rows: name, key of the number, key of the boolean, true when the slot is the exclusive one (it holds the number when the boolean is true)"

	^ #( #( #inclusiveMaximum 'maximum' 'exclusiveMaximum'
	        false )
	     #( #exclusiveMaximum 'maximum' 'exclusiveMaximum'
	        true )
	     #( #inclusiveMinimum 'minimum' 'exclusiveMinimum'
	        false )
	     #( #exclusiveMinimum 'minimum' 'exclusiveMinimum'
	        true ) )
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> aDifferentValueFrom: anExpectedValue [

	^ (anExpectedValue ifNil: [ 0 ]) + 1
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> applicabilityOf: aNode rule: aRule context: aContext [
	"The number and the boolean must have their type when they are there"

	| number flag |
	number := aNode valueAt: self numberKey.
	flag := aNode valueAt: self flagKey.
	((aNode includesKey: self numberKey) and: [ number isNumber not ])
		ifTrue: [ ^ #wrongType ].
	^ ((aNode includesKey: self flagKey) and: [
		   (self isBoolean: flag) not ])
		  ifTrue: [ #wrongType ]
		  ifFalse: [ #compare ]
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> dataRow [

	^ self class dataBounds detect: [ :each | each first = name ]
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> expectedOf: aNode rule: aRule context: aContext [
	"The number goes to the exclusive slot when the boolean is true, to the inclusive one otherwise"

	| flagged |
	flagged := self isTrue: (aNode valueAt: self flagKey).
	^ flagged = self isExclusive
		  ifTrue: [ aNode valueAt: self numberKey ]
		  ifFalse: [ nil ]
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> flagKey [

	^ self dataRow at: 3
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> isExclusive [

	^ self dataRow at: 4
]

{ #category : 'comparing' }
FamixOpenApiBoundComparator >> numberKey [

	^ self dataRow at: 2
]
