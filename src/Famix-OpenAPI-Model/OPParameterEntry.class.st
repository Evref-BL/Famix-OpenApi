"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPParameterEntry` | `parameters` | `OPApi` | |
| `components` | `OPParameterEntry` | `parameters` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |
| `value` | `OPParameterEntry` | `parameterEntry` | `OPParameter` | Reference value from ParameterEntry to Parameter [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from ParameterEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPParameterEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPParameterContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPParameterContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#api => FMOne type: #OPApi opposite: #parameters',
		'#components => FMOne type: #OPComponents opposite: #parameters',
		'#value => FMOne type: #OPParameter opposite: #parameterEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPParameterEntry class >> annotation [

	<FMClass: #ParameterEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPParameterEntry >> api [
	"Relation named: #api type: #OPApi opposite: #parameters"

	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPParameterEntry >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPParameterEntry >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPParameterEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #parameters"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPParameterEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPParameterEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPParameterEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from ParameterEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPParameterEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPParameterEntry >> value [
	"Relation named: #value type: #OPParameter opposite: #parameterEntry"

	<generated>
	<FMComment: 'Reference value from ParameterEntry to Parameter [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPParameterEntry >> value: anObject [

	<generated>
	value := anObject
]
