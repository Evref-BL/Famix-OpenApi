"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securitySchemeEntry` | `OPSecurityScheme` | `value` | `OPSecuritySchemeEntry` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `scopes` | `OPSecurityScheme` | `securityScheme` | `OPSecurityScope` | Reference scopes from SecurityScheme to SecurityScope [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `requiredSecurityScheme` | `OPSecurityScheme` | `securityScheme` | `OPRequiredSecurityScheme` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `authorizationUrl` | `String` | nil | Attribute authorizationUrl from SecurityScheme [1]|
| `bearerFormat` | `String` | nil | Attribute bearerFormat from SecurityScheme [1]|
| `description` | `String` | nil | Attribute description from SecurityScheme [1]|
| `flow` | `String` | nil | Attribute flow from SecurityScheme [1]|
| `location` | `String` | nil | Attribute location from SecurityScheme [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `openIdConnectUrl` | `String` | nil | Attribute openIdConnectUrl from SecurityScheme [1]|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `scheme` | `String` | nil | Attribute scheme from SecurityScheme [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `tokenUrl` | `String` | nil | Attribute tokenUrl from SecurityScheme [1]|
| `type` | `String` | nil | Attribute type from SecurityScheme [1]|

"
Class {
	#name : 'OPSecurityScheme',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#type => FMProperty',
		'#description => FMProperty',
		'#location => FMProperty',
		'#scheme => FMProperty',
		'#bearerFormat => FMProperty',
		'#openIdConnectUrl => FMProperty',
		'#flow => FMProperty',
		'#authorizationUrl => FMProperty',
		'#tokenUrl => FMProperty',
		'#scopes => FMMany type: #OPSecurityScope opposite: #securityScheme',
		'#securitySchemeEntry => FMOne type: #OPSecuritySchemeEntry opposite: #value',
		'#requiredSecurityScheme => FMOne type: #OPRequiredSecurityScheme opposite: #securityScheme'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityScheme class >> annotation [

	<FMClass: #SecurityScheme super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPSecurityScheme >> addScope: anObject [
	<generated>
	^ self scopes add: anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> authorizationUrl [

	<FMProperty: #authorizationUrl type: #String>
	<generated>
	<FMComment: 'Attribute authorizationUrl from SecurityScheme [1]'>
	^ authorizationUrl
]

{ #category : 'accessing' }
OPSecurityScheme >> authorizationUrl: anObject [
	<generated>
	authorizationUrl := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> bearerFormat [

	<FMProperty: #bearerFormat type: #String>
	<generated>
	<FMComment: 'Attribute bearerFormat from SecurityScheme [1]'>
	^ bearerFormat
]

{ #category : 'accessing' }
OPSecurityScheme >> bearerFormat: anObject [
	<generated>
	bearerFormat := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from SecurityScheme [1]'>
	^ description
]

{ #category : 'accessing' }
OPSecurityScheme >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> flow [

	<FMProperty: #flow type: #String>
	<generated>
	<FMComment: 'Attribute flow from SecurityScheme [1]'>
	^ flow
]

{ #category : 'accessing' }
OPSecurityScheme >> flow: anObject [
	<generated>
	flow := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> location [

	<FMProperty: #location type: #String>
	<generated>
	<FMComment: 'Attribute location from SecurityScheme [1]'>
	^ location
]

{ #category : 'accessing' }
OPSecurityScheme >> location: anObject [
	<generated>
	location := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> openIdConnectUrl [

	<FMProperty: #openIdConnectUrl type: #String>
	<generated>
	<FMComment: 'Attribute openIdConnectUrl from SecurityScheme [1]'>
	^ openIdConnectUrl
]

{ #category : 'accessing' }
OPSecurityScheme >> openIdConnectUrl: anObject [
	<generated>
	openIdConnectUrl := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> requiredSecurityScheme [
	"Relation named: #requiredSecurityScheme type: #OPRequiredSecurityScheme opposite: #securityScheme"

	<generated>
	<derived>
	^ requiredSecurityScheme
]

{ #category : 'accessing' }
OPSecurityScheme >> requiredSecurityScheme: anObject [

	<generated>
	requiredSecurityScheme := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> scheme [

	<FMProperty: #scheme type: #String>
	<generated>
	<FMComment: 'Attribute scheme from SecurityScheme [1]'>
	^ scheme
]

{ #category : 'accessing' }
OPSecurityScheme >> scheme: anObject [
	<generated>
	scheme := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> scopes [
	"Relation named: #scopes type: #OPSecurityScope opposite: #securityScheme"

	<generated>
	<FMComment: 'Reference scopes from SecurityScheme to SecurityScope [0..*].'>
	<derived>
	^ scopes
]

{ #category : 'accessing' }
OPSecurityScheme >> scopes: anObject [

	<generated>
	scopes value: anObject
]

{ #category : 'navigation' }
OPSecurityScheme >> scopesGroup [
	<generated>
	<navigation: 'Scopes'>
	^ MooseSpecializedGroup withAll: self scopes asSet
]

{ #category : 'accessing' }
OPSecurityScheme >> securitySchemeEntry [
	"Relation named: #securitySchemeEntry type: #OPSecuritySchemeEntry opposite: #value"

	<generated>
	<container>
	<derived>
	^ securitySchemeEntry
]

{ #category : 'accessing' }
OPSecurityScheme >> securitySchemeEntry: anObject [

	<generated>
	securitySchemeEntry := anObject
]

{ #category : 'navigation' }
OPSecurityScheme >> securitySchemeEntryGroup [
	<generated>
	<navigation: 'SecuritySchemeEntry'>
	^ MooseSpecializedGroup with: self securitySchemeEntry
]

{ #category : 'accessing' }
OPSecurityScheme >> tokenUrl [

	<FMProperty: #tokenUrl type: #String>
	<generated>
	<FMComment: 'Attribute tokenUrl from SecurityScheme [1]'>
	^ tokenUrl
]

{ #category : 'accessing' }
OPSecurityScheme >> tokenUrl: anObject [
	<generated>
	tokenUrl := anObject
]

{ #category : 'accessing' }
OPSecurityScheme >> type [

	<FMProperty: #type type: #String>
	<generated>
	<FMComment: 'Attribute type from SecurityScheme [1]'>
	^ type
]

{ #category : 'accessing' }
OPSecurityScheme >> type: anObject [
	<generated>
	type := anObject
]
