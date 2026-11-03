"
Comparators #key and #pathKey: a slot that holds the KEY of the node in its parent, verbatim and unescaped (VERIFIED): the verb of an operation (httpMethod), the status code or default of a response (statusCode), the media type of a content entry (mediaType), the name of the property of an encoding (propertyName), the type of an OAuth flow (flowType), and, for #pathKey, the path or the expression of a path item (relativePath: the entries of paths, of webhooks and of callbacks, but not the path items of the components). The pseudo field is written {key} in the rows.
"
Class {
	#name : 'FamixOpenApiKeyComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiKeyComparator class >> comparatorNames [

	^ #( #key #pathKey #statusKey )
]

{ #category : 'comparing' }
FamixOpenApiKeyComparator >> aDifferentValueFrom: anExpectedValue [

	^ anExpectedValue asString , '~'
]

{ #category : 'comparing' }
FamixOpenApiKeyComparator >> applicabilityOf: aNode rule: aRule context: aContext [
	"A path item of the components has no path, a response of the components has no status code"

	^ (self isKeyOfAnEntry: aNode in: aContext)
		  ifTrue: [ #compare ]
		  ifFalse: [ #notApplicable ]
]

{ #category : 'comparing' }
FamixOpenApiKeyComparator >> expectedOf: aNode rule: aRule context: aContext [

	^ aNode key
]

{ #category : 'comparing' }
FamixOpenApiKeyComparator >> isKeyOfAnEntry: aNode in: aContext [

	name = #pathKey ifTrue: [ ^ (aContext isComponentEntry: aNode) not ].
	name = #statusKey ifTrue: [
		^ #( 'default' '{HTTP status code}' ) includes:
			  (aContext fieldOf: aNode) ].
	^ true
]
