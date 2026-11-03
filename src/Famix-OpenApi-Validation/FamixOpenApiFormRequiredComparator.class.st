"
Comparator #formRequired: the formData parameters of a Swagger 2 operation without body parameter make a request body at <operation>/requestBody that is required when one of the parameters is required (VERIFIED: true when one is required, false otherwise). Compared only for an operation that has formData parameters (see FamixOpenApiValueCheck>>formRequiredOf:).
"
Class {
	#name : 'FamixOpenApiFormRequiredComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiFormRequiredComparator class >> comparatorNames [

	^ #( #formRequired )
]

{ #category : 'comparing' }
FamixOpenApiFormRequiredComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue not
]

{ #category : 'comparing' }
FamixOpenApiFormRequiredComparator >> applicabilityOf: aNode rule: aRule context: aContext [

	^ (aContext formRequiredOf: aNode)
		  ifNil: [ #notApplicable ]
		  ifNotNil: [ #compare ]
]

{ #category : 'comparing' }
FamixOpenApiFormRequiredComparator >> entriesOf: aNode rule: aRule context: aContext [
	"The form request body is at <operation>/requestBody"

	^ { ('/requestBody'
	   -> (self expectedOf: aNode rule: aRule context: aContext)) }
]

{ #category : 'comparing' }
FamixOpenApiFormRequiredComparator >> expectedOf: aNode rule: aRule context: aContext [

	^ aContext formRequiredOf: aNode
]

{ #category : 'comparing' }
FamixOpenApiFormRequiredComparator >> foundFrom: aSlotValue [

	^ self isTrue: aSlotValue
]
