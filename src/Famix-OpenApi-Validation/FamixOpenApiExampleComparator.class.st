"
Comparator #example: the scalar `example` of a parameter or of a media type (OpenAPI 3) is an OPExample at <node>/example whose value slot holds the JSON text of the example (VERIFIED). Compared only when the source has the key (otherwise there is no example entity).
"
Class {
	#name : 'FamixOpenApiExampleComparator',
	#superclass : 'FamixOpenApiJsonTextComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiExampleComparator class >> comparatorNames [

	^ #( #example )
]

{ #category : 'comparing' }
FamixOpenApiExampleComparator >> applicabilityWhenAbsent [

	^ #notApplicable
]

{ #category : 'comparing' }
FamixOpenApiExampleComparator >> entriesOf: aNode rule: aRule context: aContext [
	"The example entity is at the pointer of the node followed by /example"

	^ { ('/example'
	   -> (self expectedOf: aNode rule: aRule context: aContext)) }
]
