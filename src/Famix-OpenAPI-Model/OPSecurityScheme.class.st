"
A security scheme usable by the API (OpenAPI Security Scheme Object): apiKey, http, oauth2, openIdConnect or mutualTLS.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPSecurityScheme` | `securitySchemes` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `flows` | `OPSecurityScheme` | `securityScheme` | `OPOAuthFlow` | OAuth2 flows supported by the scheme.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedBySecurityRequirementItems` | `OPSecurityScheme` | `scheme` | `OPSecurityRequirementItem` | Requirement items that require this security scheme.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `bearerFormat` | `String` | nil | Hint on the format of the bearer token.|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the security scheme.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `inLocation` | `String` | nil | Location of an apiKey credential: query, header or cookie (the in field).|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `openIdConnectUrl` | `String` | nil | URL of the OpenID Connect discovery document.|
| `parameterName` | `String` | nil | Name of the header, query or cookie parameter carrying an apiKey credential (the name field).|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `scheme` | `String` | nil | Name of the HTTP authorization scheme, such as basic or bearer.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `type` | `String` | nil | Type of the scheme: apiKey, http, oauth2, openIdConnect or mutualTLS.|

"
Class {
	#name : 'OPSecurityScheme',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#bearerFormat => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #securitySchemes',
		'#description => FMProperty',
		'#flows => FMMany type: #OPOAuthFlow opposite: #securityScheme',
		'#inLocation => FMProperty',
		'#openIdConnectUrl => FMProperty',
		'#parameterName => FMProperty',
		'#scheme => FMProperty',
		'#type => FMProperty',
		'#usedBySecurityRequirementItems => FMMany type: #OPSecurityRequirementItem opposite: #scheme'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityScheme class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecurityScheme super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPSecurityScheme >> addFlow: anObject [

	<ignoreForCoverage>
	<generated>
	^ self flows add: anObject
]

{ #category : 'adding' }
OPSecurityScheme >> addUsedBySecurityRequirementItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedBySecurityRequirementItems add: anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> bearerFormat [

	<FMProperty: #bearerFormat type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Hint on the format of the bearer token.'>
	^ bearerFormat
]

{ #category : 'accessing' }
OPSecurityScheme >> bearerFormat: anObject [
	<ignoreForCoverage>
	<generated>
	bearerFormat := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> components [
	"Relation named: #components type: #OPComponents opposite: #securitySchemes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPSecurityScheme >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the security scheme.'>
	^ description
]

{ #category : 'accessing' }
OPSecurityScheme >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> flows [
	"Relation named: #flows type: #OPOAuthFlow opposite: #securityScheme"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'OAuth2 flows supported by the scheme.'>
	^ flows
]

{ #category : 'accessing' }
OPSecurityScheme >> flows: anObject [

	<ignoreForCoverage>
	<generated>
	flows value: anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> inLocation [

	<FMProperty: #inLocation type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Location of an apiKey credential: query, header or cookie (the in field).'>
	^ inLocation
]

{ #category : 'accessing' }
OPSecurityScheme >> inLocation: anObject [
	<ignoreForCoverage>
	<generated>
	inLocation := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> openIdConnectUrl [

	<FMProperty: #openIdConnectUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL of the OpenID Connect discovery document.'>
	^ openIdConnectUrl
]

{ #category : 'accessing' }
OPSecurityScheme >> openIdConnectUrl: anObject [
	<ignoreForCoverage>
	<generated>
	openIdConnectUrl := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> parameterName [

	<FMProperty: #parameterName type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Name of the header, query or cookie parameter carrying an apiKey credential (the name field).'>
	^ parameterName
]

{ #category : 'accessing' }
OPSecurityScheme >> parameterName: anObject [
	<ignoreForCoverage>
	<generated>
	parameterName := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> scheme [

	<FMProperty: #scheme type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Name of the HTTP authorization scheme, such as basic or bearer.'>
	^ scheme
]

{ #category : 'accessing' }
OPSecurityScheme >> scheme: anObject [
	<ignoreForCoverage>
	<generated>
	scheme := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> type [

	<FMProperty: #type type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Type of the scheme: apiKey, http, oauth2, openIdConnect or mutualTLS.'>
	^ type
]

{ #category : 'accessing' }
OPSecurityScheme >> type: anObject [
	<ignoreForCoverage>
	<generated>
	type := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> usedBySecurityRequirementItems [
	"Relation named: #usedBySecurityRequirementItems type: #OPSecurityRequirementItem opposite: #scheme"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Requirement items that require this security scheme.'>
	^ usedBySecurityRequirementItems
]

{ #category : 'accessing' }
OPSecurityScheme >> usedBySecurityRequirementItems: anObject [

	<ignoreForCoverage>
	<generated>
	usedBySecurityRequirementItems value: anObject
]
