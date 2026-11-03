"
Comparator #explicitText: a string compared only when the source states it (the style of a parameter, a header or an encoding): the spec has a default for it and the check does not compare defaults.
"
Class {
	#name : 'FamixOpenApiExplicitTextComparator',
	#superclass : 'FamixOpenApiTextComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiExplicitTextComparator class >> comparatorNames [

	^ #( #explicitText )
]

{ #category : 'comparing' }
FamixOpenApiExplicitTextComparator >> applicabilityWhenAbsent [

	^ #notApplicable
]
