"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPSecuritySchemeEntry` | `securityDefinitions` | `OPApi` | |
| `components` | `OPSecuritySchemeEntry` | `securitySchemes` | `OPComponents` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPSecuritySchemeEntry` | `securitySchemeEntry` | `OPSecurityScheme` | Reference value from SecuritySchemeEntry to SecurityScheme [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from SecuritySchemeEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPSecuritySchemeEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#api => FMOne type: #OPApi opposite: #securityDefinitions',
		'#components => FMOne type: #OPComponents opposite: #securitySchemes',
		'#value => FMOne type: #OPSecurityScheme opposite: #securitySchemeEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecuritySchemeEntry class >> annotation [

	<FMClass: #SecuritySchemeEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> api [
	"Relation named: #api type: #OPApi opposite: #securityDefinitions"

	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPSecuritySchemeEntry >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #securitySchemes"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPSecuritySchemeEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from SecuritySchemeEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> value [
	"Relation named: #value type: #OPSecurityScheme opposite: #securitySchemeEntry"

	<generated>
	<FMComment: 'Reference value from SecuritySchemeEntry to SecurityScheme [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> value: anObject [

	<generated>
	value := anObject
]

{ #category : 'navigation' }
OPSecuritySchemeEntry >> valueGroup [
	<generated>
	<navigation: 'Value'>
	^ MooseSpecializedGroup with: self value
]
