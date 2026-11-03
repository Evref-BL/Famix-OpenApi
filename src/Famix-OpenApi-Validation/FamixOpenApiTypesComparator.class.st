"
Comparator #types: the `type` of a schema is a collection of strings in the slot types (VERIFIED). OpenAPI 3.0 and Swagger 2: a string gives a collection of one. OpenAPI 3.1: a string, or an array whose strings give the collection in the same order; the type ""null"" is not a type of the slot (it makes the schema nullable, see FamixOpenApiNullableComparator) and the elements that are not strings are dropped. Absent gives nil, the same as empty.
"
Class {
	#name : 'FamixOpenApiTypesComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiTypesComparator class >> comparatorNames [

	^ #( #types )
]

{ #category : 'comparing' }
FamixOpenApiTypesComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue copyWith: 'mutant'
]

{ #category : 'comparing' }
FamixOpenApiTypesComparator >> expectedOf: aNode rule: aRule context: aContext [

	^ (aNode valueAt: aRule fieldKey)
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :value |
			  value isString
				  ifTrue: [ self typesOfString: value in: aContext version ]
				  ifFalse: [ self typesOfArray: value ] ]
]

{ #category : 'comparing' }
FamixOpenApiTypesComparator >> fits: aJsonValue context: aContext [
	"A string, and in OpenAPI 3.1 an array too"

	^ aJsonValue isString or: [
		  aJsonValue isArray and: [ aContext version = #v31 ] ]
]

{ #category : 'comparing' }
FamixOpenApiTypesComparator >> foundFrom: aSlotValue [

	^ (aSlotValue ifNil: [ #(  ) ]) asArray
]

{ #category : 'comparing' }
FamixOpenApiTypesComparator >> typesOfArray: anArray [
	"The strings of the array but null"

	^ (anArray select: [ :each | each isString and: [ each ~= 'null' ] ])
		  asArray
]

{ #category : 'comparing' }
FamixOpenApiTypesComparator >> typesOfString: aString in: aVersion [
	"In OpenAPI 3.1 the type null is no type of the schema"

	^ (aVersion = #v31 and: [ aString = 'null' ])
		  ifTrue: [ #(  ) ]
		  ifFalse: [ { aString } ]
]
