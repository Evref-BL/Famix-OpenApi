"
Comparator #number: a number of the source (maxLength, multipleOf, the bounds of OpenAPI 3.1...) stored as a number in the slot; an absent key gives nil. The numbers are compared by value, so 1 and 1.0 are the same (VERIFIED: the importer keeps integers and floats as they are). A value that is not a number is not compared.
"
Class {
	#name : 'FamixOpenApiNumberComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiNumberComparator class >> comparatorNames [

	^ #( #number )
]

{ #category : 'comparing' }
FamixOpenApiNumberComparator >> aDifferentValueFrom: anExpectedValue [

	^ (anExpectedValue ifNil: [ 0 ]) + 1
]

{ #category : 'comparing' }
FamixOpenApiNumberComparator >> fits: aJsonValue context: aContext [

	^ aJsonValue isNumber
]
