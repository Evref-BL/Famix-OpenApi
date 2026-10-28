"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPSecurityScheme` | `directSecuritySchemes` | `OPComponents` | Opposite reference components from SecurityScheme to Components [0..1], when the object is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `flows` | `OPSecurityScheme` | `securityScheme` | `OPOAuthFlow` | Reference flows from SecurityScheme to OAuthFlow [0..*]: OAuth2 flows supported by the scheme.|
| `scopes` | `OPSecurityScheme` | `securityScheme` | `OPSecurityScope` | Reference scopes from SecurityScheme to SecurityScope [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByRequiredSecuritySchemes` | `OPSecurityScheme` | `securityScheme` | `OPRequiredSecurityScheme` | Required security schemes using this SecurityScheme [0..*].|
| `usedBySecuritySchemeEntries` | `OPSecurityScheme` | `value` | `OPSecuritySchemeEntry` | SecuritySchemeEntry entries whose value is this SecurityScheme [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `authorizationUrl` | `String` | nil | Attribute authorizationUrl from SecurityScheme [1]|
| `bearerFormat` | `String` | nil | Attribute bearerFormat from SecurityScheme [1]|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Attribute description from SecurityScheme [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `flow` | `String` | nil | Attribute flow from SecurityScheme [1]|
| `inLocation` | `String` | nil | Location of an apiKey credential: query, header or cookie (the in field) [1].|
| `location` | `String` | nil | Attribute location from SecurityScheme [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `openIdConnectUrl` | `String` | nil | Attribute openIdConnectUrl from SecurityScheme [1]|
| `parameterName` | `String` | nil | Name of the header, query or cookie parameter carrying an apiKey credential (the name field) [1].|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `scheme` | `String` | nil | Attribute scheme from SecurityScheme [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `tokenUrl` | `String` | nil | Attribute tokenUrl from SecurityScheme [1]|
| `type` | `String` | nil | Attribute type from SecurityScheme [1]|

"
Class {
	#name : 'OPSecurityScheme',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#authorizationUrl => FMProperty',
		'#bearerFormat => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #directSecuritySchemes',
		'#description => FMProperty',
		'#flow => FMProperty',
		'#flows => FMMany type: #OPOAuthFlow opposite: #securityScheme',
		'#inLocation => FMProperty',
		'#location => FMProperty',
		'#openIdConnectUrl => FMProperty',
		'#parameterName => FMProperty',
		'#scheme => FMProperty',
		'#scopes => FMMany type: #OPSecurityScope opposite: #securityScheme',
		'#tokenUrl => FMProperty',
		'#type => FMProperty',
		'#usedByRequiredSecuritySchemes => FMMany type: #OPRequiredSecurityScheme opposite: #securityScheme',
		'#usedBySecuritySchemeEntries => FMMany type: #OPSecuritySchemeEntry opposite: #value'
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
OPSecurityScheme >> addScope: anObject [

	<ignoreForCoverage>
	<generated>
	^ self scopes add: anObject
]

{ #category : 'adding' }
OPSecurityScheme >> addUsedByRequiredSecurityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByRequiredSecuritySchemes add: anObject
]

{ #category : 'adding' }
OPSecurityScheme >> addUsedBySecuritySchemeEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedBySecuritySchemeEntries add: anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> authorizationUrl [

	<FMProperty: #authorizationUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute authorizationUrl from SecurityScheme [1]'>
	^ authorizationUrl
]

{ #category : 'accessing' }
OPSecurityScheme >> authorizationUrl: anObject [
	<ignoreForCoverage>
	<generated>
	authorizationUrl := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> bearerFormat [

	<FMProperty: #bearerFormat type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute bearerFormat from SecurityScheme [1]'>
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
	"Relation named: #components type: #OPComponents opposite: #directSecuritySchemes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from SecurityScheme to Components [0..1], when the object is a reusable one.'>
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
	<FMComment: 'Attribute description from SecurityScheme [1]'>
	^ description
]

{ #category : 'accessing' }
OPSecurityScheme >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> flow [

	<FMProperty: #flow type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute flow from SecurityScheme [1]'>
	^ flow
]

{ #category : 'accessing' }
OPSecurityScheme >> flow: anObject [
	<ignoreForCoverage>
	<generated>
	flow := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> flows [
	"Relation named: #flows type: #OPOAuthFlow opposite: #securityScheme"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference flows from SecurityScheme to OAuthFlow [0..*]: OAuth2 flows supported by the scheme.'>
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
	<FMComment: 'Location of an apiKey credential: query, header or cookie (the in field) [1].'>
	^ inLocation
]

{ #category : 'accessing' }
OPSecurityScheme >> inLocation: anObject [
	<ignoreForCoverage>
	<generated>
	inLocation := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> location [

	<FMProperty: #location type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute location from SecurityScheme [1]'>
	^ location
]

{ #category : 'accessing' }
OPSecurityScheme >> location: anObject [
	<ignoreForCoverage>
	<generated>
	location := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> openIdConnectUrl [

	<FMProperty: #openIdConnectUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute openIdConnectUrl from SecurityScheme [1]'>
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
	<FMComment: 'Name of the header, query or cookie parameter carrying an apiKey credential (the name field) [1].'>
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
	<FMComment: 'Attribute scheme from SecurityScheme [1]'>
	^ scheme
]

{ #category : 'accessing' }
OPSecurityScheme >> scheme: anObject [
	<ignoreForCoverage>
	<generated>
	scheme := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> scopes [
	"Relation named: #scopes type: #OPSecurityScope opposite: #securityScheme"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference scopes from SecurityScheme to SecurityScope [0..*].'>
	^ scopes
]

{ #category : 'accessing' }
OPSecurityScheme >> scopes: anObject [

	<ignoreForCoverage>
	<generated>
	scopes value: anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> tokenUrl [

	<FMProperty: #tokenUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute tokenUrl from SecurityScheme [1]'>
	^ tokenUrl
]

{ #category : 'accessing' }
OPSecurityScheme >> tokenUrl: anObject [
	<ignoreForCoverage>
	<generated>
	tokenUrl := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> type [

	<FMProperty: #type type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute type from SecurityScheme [1]'>
	^ type
]

{ #category : 'accessing' }
OPSecurityScheme >> type: anObject [
	<ignoreForCoverage>
	<generated>
	type := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> usedByRequiredSecuritySchemes [
	"Relation named: #usedByRequiredSecuritySchemes type: #OPRequiredSecurityScheme opposite: #securityScheme"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Required security schemes using this SecurityScheme [0..*].'>
	^ usedByRequiredSecuritySchemes
]

{ #category : 'accessing' }
OPSecurityScheme >> usedByRequiredSecuritySchemes: anObject [

	<ignoreForCoverage>
	<generated>
	usedByRequiredSecuritySchemes value: anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> usedBySecuritySchemeEntries [
	"Relation named: #usedBySecuritySchemeEntries type: #OPSecuritySchemeEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'SecuritySchemeEntry entries whose value is this SecurityScheme [0..*].'>
	^ usedBySecuritySchemeEntries
]

{ #category : 'accessing' }
OPSecurityScheme >> usedBySecuritySchemeEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedBySecuritySchemeEntries value: anObject
]
