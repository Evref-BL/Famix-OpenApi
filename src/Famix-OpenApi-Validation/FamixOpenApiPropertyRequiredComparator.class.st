"
Comparator #propertyRequired: the entry of the properties of a schema is an OPProperty whose slot isRequired is true when the name of the property is in the `required` array of the schema that holds it, false otherwise (VERIFIED); the schema itself keeps the whole array in requiredProperties (compared by #stringList). Compared for the entries of the properties only.
"
Class {
	#name : 'FamixOpenApiPropertyRequiredComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiPropertyRequiredComparator class >> comparatorNames [

	^ #( #propertyRequired )
]

{ #category : 'comparing' }
FamixOpenApiPropertyRequiredComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue not
]

{ #category : 'comparing' }
FamixOpenApiPropertyRequiredComparator >> applicabilityOf: aNode rule: aRule context: aContext [

	^ (aContext fieldOf: aNode) = 'properties'
		  ifTrue: [ #compare ]
		  ifFalse: [ #notApplicable ]
]

{ #category : 'comparing' }
FamixOpenApiPropertyRequiredComparator >> expectedOf: aNode rule: aRule context: aContext [
	"The name of the property is in the required array of the schema that holds it"

	| required |
	required := (aContext ownerOf: aNode) valueAt: 'required'.
	^ required isArray and: [ required includes: aNode key ]
]

{ #category : 'comparing' }
FamixOpenApiPropertyRequiredComparator >> foundFrom: aSlotValue [

	^ self isTrue: aSlotValue
]
