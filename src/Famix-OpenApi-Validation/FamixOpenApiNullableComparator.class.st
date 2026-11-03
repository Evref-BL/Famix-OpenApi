"
Comparators #nullable30 and #nullable31: the slot isNullable of a schema. In OpenAPI 3.0 it is the keyword `nullable` (true; absent and false give false: VERIFIED); in OpenAPI 3.1 it is true when the type is ""null"" or an array that holds ""null"", and the keyword nullable is ignored (VERIFIED: nullable true with type string gives false in 3.1). The expected value is false for an absent key.
"
Class {
	#name : 'FamixOpenApiNullableComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiNullableComparator class >> comparatorNames [

	^ #( #nullable30 #nullable31 )
]

{ #category : 'comparing' }
FamixOpenApiNullableComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue not
]

{ #category : 'comparing' }
FamixOpenApiNullableComparator >> expectedOf: aNode rule: aRule context: aContext [

	| value |
	value := aNode valueAt: aRule fieldKey.
	name = #nullable30 ifTrue: [ ^ self isTrue: value ].
	^ value = 'null' or: [ value isArray and: [ value includes: 'null' ] ]
]

{ #category : 'comparing' }
FamixOpenApiNullableComparator >> fits: aJsonValue context: aContext [

	^ name = #nullable30
		  ifTrue: [ self isBoolean: aJsonValue ]
		  ifFalse: [ aJsonValue isString or: [ aJsonValue isArray ] ]
]

{ #category : 'comparing' }
FamixOpenApiNullableComparator >> foundFrom: aSlotValue [

	^ self isTrue: aSlotValue
]
