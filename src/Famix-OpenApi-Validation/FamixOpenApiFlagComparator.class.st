"
Comparator #flag: a boolean of the source (deprecated, required, readOnly, uniqueItems...) whose spec default is false. An absent key and false are the same expected value, and a slot that holds nil or false is the same found value (VERIFIED on the importer: an absent key gives nil, an explicit false gives false, true gives true). A value that is not a boolean is not compared (the importer reports it and does not store it).
"
Class {
	#name : 'FamixOpenApiFlagComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiFlagComparator class >> comparatorNames [

	^ #( #flag )
]

{ #category : 'comparing' }
FamixOpenApiFlagComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue not
]

{ #category : 'comparing' }
FamixOpenApiFlagComparator >> expectedOf: aNode rule: aRule context: aContext [
	"An absent key is false, the spec default"

	^ self isTrue: (aNode valueAt: aRule fieldKey)
]

{ #category : 'comparing' }
FamixOpenApiFlagComparator >> fits: aJsonValue context: aContext [

	^ self isBoolean: aJsonValue
]

{ #category : 'comparing' }
FamixOpenApiFlagComparator >> foundFrom: aSlotValue [
	"nil is false"

	^ self isTrue: aSlotValue
]
