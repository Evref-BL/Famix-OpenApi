"
Comparator #explicitFlag: a boolean compared only when the source states it (explode and allowReserved of a parameter, a header or an encoding), as the spec default of explode depends on the style and the check does not compare defaults.
"
Class {
	#name : 'FamixOpenApiExplicitFlagComparator',
	#superclass : 'FamixOpenApiFlagComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiExplicitFlagComparator class >> comparatorNames [

	^ #( #explicitFlag )
]

{ #category : 'comparing' }
FamixOpenApiExplicitFlagComparator >> applicabilityWhenAbsent [

	^ #notApplicable
]
