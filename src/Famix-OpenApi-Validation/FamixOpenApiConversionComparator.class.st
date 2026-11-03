"
Comparators of the Swagger 2 values that the importer converts, each one VERIFIED by import experiments (see #dataConversions: name, source key, source value -> value of the slot, and whether the other values are kept as they are): #securityTypeV2 (a basic security scheme has the type http, the others keep theirs), #basicSchemeV2 (and the scheme basic), #flowTypeV2 (the flow of an oauth2 scheme: accessCode is authorizationCode, application is clientCredentials, implicit and password stay), #collectionStyle and #collectionExplode (the collectionFormat of a typed parameter: csv gives style form and explode false, multi gives form and true, ssv spaceDelimited and false, pipes pipeDelimited and false, tsv and any other value give nothing). An absent key gives nil. The values are compared exactly (no equivalence of nil and false).
"
Class {
	#name : 'FamixOpenApiConversionComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiConversionComparator class >> comparatorNames [

	^ self dataConversions collect: #first
]

{ #category : 'data' }
FamixOpenApiConversionComparator class >> dataConversions [
	"Rows: name, source value -> value of the slot (pairs), true when the other source values are kept as they are in the slot"

	^ {
		  #( #securityTypeV2 #( 'basic' 'http' ) true ).
		  #( #basicSchemeV2 #( 'basic' 'basic' ) false ).
		  #( #flowTypeV2 #( 'accessCode' 'authorizationCode'
		        'application' 'clientCredentials' 'implicit' 'implicit'
		        'password' 'password' )
		     false ).
		  #( #collectionStyle #( 'csv' 'form' 'multi' 'form' 'ssv' 'spaceDelimited'
		        'pipes' 'pipeDelimited' )
		     false ).
		  #( #collectionExplode #( 'csv' false 'multi' true 'ssv' false
		        'pipes' false )
		     false ) }
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> aDifferentValueFrom: anExpectedValue [

	^ 'mutant'
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> convert: aSourceValue [
	"The value of the slot for a string of the source"

	| pairs |
	pairs := self pairs.
	1 to: pairs size by: 2 do: [ :index |
		(pairs at: index) = aSourceValue ifTrue: [ ^ pairs at: index + 1 ] ].
	^ self keepsOtherValues
		  ifTrue: [ aSourceValue ]
		  ifFalse: [ nil ]
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> dataRow [

	^ self class dataConversions detect: [ :each | each first = name ]
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> expectedOf: aNode rule: aRule context: aContext [

	^ (aNode valueAt: aRule fieldKey) ifNotNil: [ :value |
		  self convert: value ]
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> fits: aJsonValue context: aContext [

	^ aJsonValue isString
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> keepsOtherValues [

	^ self dataRow at: 3
]

{ #category : 'comparing' }
FamixOpenApiConversionComparator >> pairs [
	"Source value and value of the slot, one after the other"

	^ self dataRow at: 2
]
