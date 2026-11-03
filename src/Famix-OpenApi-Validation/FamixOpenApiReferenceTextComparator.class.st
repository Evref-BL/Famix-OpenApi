"
Comparator #referenceText: the slot ref of an entity holds the text of the $ref at its place (VERIFIED: the clone of a $ref response or path item at its use site, an alias schema in the components, a schema with a $ref in OpenAPI 3.1, a path item of Swagger 2), nil when there is none. The text is the one of the node when it is a reference, or the one of the site that the clone expansion replaced by its target (FamixOpenApiCloneExpansion).
"
Class {
	#name : 'FamixOpenApiReferenceTextComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiReferenceTextComparator class >> comparatorNames [

	^ #( #referenceText )
]

{ #category : 'comparing' }
FamixOpenApiReferenceTextComparator >> aDifferentValueFrom: anExpectedValue [

	^ (anExpectedValue ifNil: [ '' ]) , '~'
]

{ #category : 'comparing' }
FamixOpenApiReferenceTextComparator >> applicabilityOf: aNode rule: aRule context: aContext [

	^ #compare
]

{ #category : 'comparing' }
FamixOpenApiReferenceTextComparator >> expectedOf: aNode rule: aRule context: aContext [

	^ aContext referenceTextOf: aNode
]
