"
Comparator #explicitCount: a count compared only when the source has the array (the servers: an OpenAPI 3 document without servers gets one synthesised server, see FamixOpenApiSynthesizedServers).
"
Class {
	#name : 'FamixOpenApiExplicitCountComparator',
	#superclass : 'FamixOpenApiCountComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiExplicitCountComparator class >> comparatorNames [

	^ #( #explicitCount )
]

{ #category : 'comparing' }
FamixOpenApiExplicitCountComparator >> applicabilityWhenAbsent [

	^ #notApplicable
]
