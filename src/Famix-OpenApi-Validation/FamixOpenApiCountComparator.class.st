"
Comparators #count and #explicitCount: the number of elements of an array of objects of the source (the tags and the security requirements of the document, the security requirements of an operation, the servers of a document) against the number of entities in the relation of the model that holds them (VERIFIED: duplicates are kept, one entity per element; an absent array gives 0, except for the servers, which the importer synthesises: #explicitCount compares only when the array is there). Only these relations are compared by count in V8, because their elements are objects that are never references: the relations whose elements can be $ref (parameters, allOf...) merge duplicates and drop unresolved ones, and their targets are V10. A mismatch is a #countMismatch gap, not a #valueMismatch.
"
Class {
	#name : 'FamixOpenApiCountComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiCountComparator class >> comparatorNames [

	^ #( #count )
]

{ #category : 'comparing' }
FamixOpenApiCountComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue + 1
]

{ #category : 'comparing' }
FamixOpenApiCountComparator >> expectedOf: aNode rule: aRule context: aContext [
	"The number of elements of the array, 0 when there is none"

	^ (aNode valueAt: aRule fieldKey)
		  ifNil: [ 0 ]
		  ifNotNil: [ :elements | elements size ]
]

{ #category : 'comparing' }
FamixOpenApiCountComparator >> fits: aJsonValue context: aContext [

	^ aJsonValue isArray and: [ aJsonValue allSatisfy: #isDictionary ]
]

{ #category : 'comparing' }
FamixOpenApiCountComparator >> foundFrom: aSlotValue [
	"The number of entities of the relation"

	^ aSlotValue ifNil: [ 0 ] ifNotNil: [ aSlotValue size ]
]

{ #category : 'comparing' }
FamixOpenApiCountComparator >> gapKind [
	"A different number of elements is a #countMismatch"

	^ #countMismatch
]
