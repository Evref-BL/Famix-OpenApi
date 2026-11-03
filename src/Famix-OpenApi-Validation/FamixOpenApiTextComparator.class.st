"
Comparator #text: a string of the source (title, description, url, operationId...) is stored verbatim in the slot, an absent key gives nil (VERIFIED on the importer: no default is invented, a null or a value of another JSON type is not stored and is reported by the importer as #wrongNodeType: such a field is not compared). The string is compared exactly, unicode included.
"
Class {
	#name : 'FamixOpenApiTextComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiTextComparator class >> comparatorNames [

	^ #( #text )
]

{ #category : 'comparing' }
FamixOpenApiTextComparator >> aDifferentValueFrom: anExpectedValue [

	^ (anExpectedValue ifNil: [ '' ]) , '~'
]

{ #category : 'comparing' }
FamixOpenApiTextComparator >> fits: aJsonValue context: aContext [

	^ aJsonValue isString
]
