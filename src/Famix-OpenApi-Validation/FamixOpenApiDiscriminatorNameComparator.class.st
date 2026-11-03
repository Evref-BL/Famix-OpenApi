"
Comparator #discriminatorName: the discriminator of a Swagger 2 schema is a string, not an object; the importer builds an OPDiscriminator at <schema>/discriminator whose propertyName is that string (VERIFIED). Compared only when the key is a string.
"
Class {
	#name : 'FamixOpenApiDiscriminatorNameComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiDiscriminatorNameComparator class >> comparatorNames [

	^ #( #discriminatorName )
]

{ #category : 'comparing' }
FamixOpenApiDiscriminatorNameComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue , '~'
]

{ #category : 'comparing' }
FamixOpenApiDiscriminatorNameComparator >> applicabilityOf: aNode rule: aRule context: aContext [
	"Only a string is a discriminator of Swagger 2 (an object is the one of OpenAPI 3)"

	^ (aNode valueAt: aRule fieldKey) isString
		  ifTrue: [ #compare ]
		  ifFalse: [ #notApplicable ]
]

{ #category : 'comparing' }
FamixOpenApiDiscriminatorNameComparator >> entriesOf: aNode rule: aRule context: aContext [
	"The discriminator entity is at <schema>/discriminator"

	^ { ('/discriminator'
	   -> (self expectedOf: aNode rule: aRule context: aContext)) }
]
