"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPResponseDefinitionEntry` | `responses` | `OPApi` | |
| `components` | `OPResponseDefinitionEntry` | `responses` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `response` | `OPResponseContainer` | `declaringContext` | `OPResponse` | |
| `value` | `OPResponseDefinitionEntry` | `responseDefinitionEntry` | `OPResponse` | Reference value from ResponseDefinitionEntry to Response [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from ResponseDefinitionEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPResponseDefinitionEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPResponseContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPResponseContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#api => FMOne type: #OPApi opposite: #responses',
		'#components => FMOne type: #OPComponents opposite: #responses',
		'#value => FMOne type: #OPResponse opposite: #responseDefinitionEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPResponseDefinitionEntry class >> annotation [

	<FMClass: #ResponseDefinitionEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> api [
	"Relation named: #api type: #OPApi opposite: #responses"

	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPResponseDefinitionEntry >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #responses"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPResponseDefinitionEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from ResponseDefinitionEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> value [
	"Relation named: #value type: #OPResponse opposite: #responseDefinitionEntry"

	<generated>
	<FMComment: 'Reference value from ResponseDefinitionEntry to Response [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> value: anObject [

	<generated>
	value := anObject
]
