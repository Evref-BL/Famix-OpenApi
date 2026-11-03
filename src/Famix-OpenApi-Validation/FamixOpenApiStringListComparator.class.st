"
Comparator #stringList: an array of strings of the source (the tags of an operation, the enum of a server variable, the required properties of a schema) stored as a collection of strings in the slot, in the same order and with the same duplicates (VERIFIED: required [""b"",""a"",""b""] gives #('b' 'a' 'b'); an absent key gives nil, the same as an empty list). An array that holds something else than strings is not compared.
"
Class {
	#name : 'FamixOpenApiStringListComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiStringListComparator class >> comparatorNames [

	^ #( #stringList )
]

{ #category : 'comparing' }
FamixOpenApiStringListComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue copyWith: 'mutant'
]

{ #category : 'comparing' }
FamixOpenApiStringListComparator >> expectedOf: aNode rule: aRule context: aContext [

	^ (aNode valueAt: aRule fieldKey) ifNil: [ #(  ) ]
]

{ #category : 'comparing' }
FamixOpenApiStringListComparator >> fits: aJsonValue context: aContext [

	^ aJsonValue isArray and: [ aJsonValue allSatisfy: #isString ]
]

{ #category : 'comparing' }
FamixOpenApiStringListComparator >> foundFrom: aSlotValue [

	^ (aSlotValue ifNil: [ #(  ) ]) asArray
]
