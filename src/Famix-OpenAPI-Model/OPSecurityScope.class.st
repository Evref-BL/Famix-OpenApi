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
| `usedByRequiredSecuritySchemes` | `OPSecurityScope` | `securityScopes` | `OPRequiredSecurityScheme` | Required security schemes using this SecurityScope [0..*].|


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
		'#usedByRequiredSecuritySchemes => FMMany type: #OPRequiredSecurityScheme opposite: #securityScopes'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityScope class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecurityScope super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPSecurityScope >> addUsedByRequiredSecurityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByRequiredSecuritySchemes add: anObject
]

{ #category : 'accessing' }
OPSecurityScope >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from SecurityScope [1]'>
	^ description
]

{ #category : 'accessing' }
OPSecurityScope >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSecurityScope >> securityScheme [
	"Relation named: #securityScheme type: #OPSecurityScheme opposite: #scopes"

	<ignoreForCoverage>
	<generated>
	<container>
	^ securityScheme
]

{ #category : 'accessing' }
OPSecurityScope >> securityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	securityScheme := anObject
]

{ #category : 'accessing' }
OPSecurityScope >> usedByRequiredSecuritySchemes [
	"Relation named: #usedByRequiredSecuritySchemes type: #OPRequiredSecurityScheme opposite: #securityScopes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Required security schemes using this SecurityScope [0..*].'>
	^ usedByRequiredSecuritySchemes
]

{ #category : 'accessing' }
OPSecurityScope >> usedByRequiredSecuritySchemes: anObject [

	<ignoreForCoverage>
	<generated>
	usedByRequiredSecuritySchemes value: anObject
]
