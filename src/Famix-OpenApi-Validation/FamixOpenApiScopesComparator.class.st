"
Comparator #scopes: the scopes of an OAuth flow (OpenAPI 3) or of an oauth2 security scheme (Swagger 2) are a map name -> description. The importer builds one OPSecurityScope per entry at <node>/scopes/<name>, whose slot description holds the description (VERIFIED). One expected value per entry whose description is a string, compared with the slot of the entity of that entry; the name of the scope is the key of the entry.
"
Class {
	#name : 'FamixOpenApiScopesComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiScopesComparator class >> comparatorNames [

	^ #( #scopes )
]

{ #category : 'comparing' }
FamixOpenApiScopesComparator >> aDifferentValueFrom: anExpectedValue [

	^ (anExpectedValue ifNil: [ '' ]) , '~'
]

{ #category : 'comparing' }
FamixOpenApiScopesComparator >> applicabilityWhenAbsent [

	^ #notApplicable
]

{ #category : 'comparing' }
FamixOpenApiScopesComparator >> entriesOf: aNode rule: aRule context: aContext [
	"One entry per scope whose description is a string: the entity is at <node>/scopes/<name>"

	^ (aNode valueAt: aRule fieldKey) associations
		  select: [ :each | each value isString ]
		  thenCollect: [ :each |
		  (self suffixOfScope: each key) -> each value ]
]

{ #category : 'comparing' }
FamixOpenApiScopesComparator >> fits: aJsonValue context: aContext [

	^ aJsonValue isDictionary
]

{ #category : 'comparing' }
FamixOpenApiScopesComparator >> suffixOfScope: aName [

	^ '/scopes/' , (FamixOpenApiSourceNode escapeToken: aName)
]
