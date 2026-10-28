"
One OAuth2 flow of a security scheme (OpenAPI OAuth Flow Object): implicit, password, clientCredentials or authorizationCode.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securityScheme` | `OPOAuthFlow` | `flows` | `OPSecurityScheme` | The security scheme declaring the flow.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `scopes` | `OPOAuthFlow` | `oauthFlow` | `OPSecurityScope` | Scopes offered by the flow, with their description.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `authorizationUrl` | `String` | nil | Authorization URL of the flow.|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `flowType` | `String` | nil | Kind of flow: implicit, password, clientCredentials or authorizationCode.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `refreshUrl` | `String` | nil | URL used to obtain refresh tokens.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `tokenUrl` | `String` | nil | Token URL of the flow.|

"
Class {
	#name : 'OPOAuthFlow',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#authorizationUrl => FMProperty',
		'#flowType => FMProperty',
		'#refreshUrl => FMProperty',
		'#scopes => FMMany type: #OPSecurityScope opposite: #oauthFlow',
		'#securityScheme => FMOne type: #OPSecurityScheme opposite: #flows',
		'#tokenUrl => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPOAuthFlow class >> annotation [

	<ignoreForCoverage>
	<FMClass: #OAuthFlow super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPOAuthFlow >> addScope: anObject [

	<ignoreForCoverage>
	<generated>
	^ self scopes add: anObject
]

{ #category : 'accessing' }
OPOAuthFlow >> authorizationUrl [

	<FMProperty: #authorizationUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Authorization URL of the flow.'>
	^ authorizationUrl
]

{ #category : 'accessing' }
OPOAuthFlow >> authorizationUrl: anObject [
	<ignoreForCoverage>
	<generated>
	authorizationUrl := anObject
]

{ #category : 'accessing' }
OPOAuthFlow >> flowType [

	<FMProperty: #flowType type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Kind of flow: implicit, password, clientCredentials or authorizationCode.'>
	^ flowType
]

{ #category : 'accessing' }
OPOAuthFlow >> flowType: anObject [
	<ignoreForCoverage>
	<generated>
	flowType := anObject
]

{ #category : 'accessing' }
OPOAuthFlow >> refreshUrl [

	<FMProperty: #refreshUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL used to obtain refresh tokens.'>
	^ refreshUrl
]

{ #category : 'accessing' }
OPOAuthFlow >> refreshUrl: anObject [
	<ignoreForCoverage>
	<generated>
	refreshUrl := anObject
]

{ #category : 'accessing' }
OPOAuthFlow >> scopes [
	"Relation named: #scopes type: #OPSecurityScope opposite: #oauthFlow"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Scopes offered by the flow, with their description.'>
	^ scopes
]

{ #category : 'accessing' }
OPOAuthFlow >> scopes: anObject [

	<ignoreForCoverage>
	<generated>
	scopes value: anObject
]

{ #category : 'accessing' }
OPOAuthFlow >> securityScheme [
	"Relation named: #securityScheme type: #OPSecurityScheme opposite: #flows"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The security scheme declaring the flow.'>
	<container>
	^ securityScheme
]

{ #category : 'accessing' }
OPOAuthFlow >> securityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	securityScheme := anObject
]

{ #category : 'accessing' }
OPOAuthFlow >> tokenUrl [

	<FMProperty: #tokenUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Token URL of the flow.'>
	^ tokenUrl
]

{ #category : 'accessing' }
OPOAuthFlow >> tokenUrl: anObject [
	<ignoreForCoverage>
	<generated>
	tokenUrl := anObject
]
