"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securityContainer` | `OPSecurityRequirement` | `security` | `OPSecurityContainer` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securitySchemes` | `OPSecurityRequirement` | `securityRequirement` | `OPRequiredSecurityScheme` | Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPSecurityRequirement',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#securitySchemes => FMMany type: #OPRequiredSecurityScheme opposite: #securityRequirement',
		'#securityContainer => FMOne type: #OPSecurityContainer opposite: #security'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityRequirement class >> annotation [

	<FMClass: #SecurityRequirement super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPSecurityRequirement >> addSecurityScheme: anObject [
	<generated>
	^ self securitySchemes add: anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> securityContainer [
	"Relation named: #securityContainer type: #OPSecurityContainer opposite: #security"

	<generated>
	<container>
	^ securityContainer
]

{ #category : 'accessing' }
OPSecurityRequirement >> securityContainer: anObject [

	<generated>
	securityContainer := anObject
]

{ #category : 'navigation' }
OPSecurityRequirement >> securityContainerGroup [
	<generated>
	<navigation: 'SecurityContainer'>
	^ MooseSpecializedGroup with: self securityContainer
]

{ #category : 'accessing' }
OPSecurityRequirement >> securitySchemes [
	"Relation named: #securitySchemes type: #OPRequiredSecurityScheme opposite: #securityRequirement"

	<generated>
	<FMComment: 'Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].'>
	<derived>
	^ securitySchemes
]

{ #category : 'accessing' }
OPSecurityRequirement >> securitySchemes: anObject [

	<generated>
	securitySchemes value: anObject
]

{ #category : 'navigation' }
OPSecurityRequirement >> securitySchemesGroup [
	<generated>
	<navigation: 'SecuritySchemes'>
	^ MooseSpecializedGroup withAll: self securitySchemes asSet
]
