"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securityScheme` | `OPSecurityScope` | `scopes` | `OPSecurityScheme` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `requiredSecurityScheme` | `OPSecurityScope` | `securityScopes` | `OPRequiredSecurityScheme` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from SecurityScope [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPSecurityScope',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#securityScheme => FMOne type: #OPSecurityScheme opposite: #scopes',
		'#requiredSecurityScheme => FMOne type: #OPRequiredSecurityScheme opposite: #securityScopes'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityScope class >> annotation [

	<FMClass: #SecurityScope super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPSecurityScope >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from SecurityScope [1]'>
	^ description
]

{ #category : 'accessing' }
OPSecurityScope >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSecurityScope >> requiredSecurityScheme [
	"Relation named: #requiredSecurityScheme type: #OPRequiredSecurityScheme opposite: #securityScopes"

	<generated>
	^ requiredSecurityScheme
]

{ #category : 'accessing' }
OPSecurityScope >> requiredSecurityScheme: anObject [

	<generated>
	requiredSecurityScheme := anObject
]

{ #category : 'accessing' }
OPSecurityScope >> securityScheme [
	"Relation named: #securityScheme type: #OPSecurityScheme opposite: #scopes"

	<generated>
	<container>
	^ securityScheme
]

{ #category : 'accessing' }
OPSecurityScope >> securityScheme: anObject [

	<generated>
	securityScheme := anObject
]

{ #category : 'navigation' }
OPSecurityScope >> securitySchemeGroup [
	<generated>
	<navigation: 'SecurityScheme'>
	^ MooseSpecializedGroup with: self securityScheme
]
