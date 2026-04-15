"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPHeaderEntry` | `headers` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPHeaderEntry` | `headerEntry` | `OPHeader` | Reference value from HeaderEntry to Header [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from HeaderEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPHeaderEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #headers',
		'#value => FMOne type: #OPHeader opposite: #headerEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPHeaderEntry class >> annotation [

	<FMClass: #HeaderEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPHeaderEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #headers"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPHeaderEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPHeaderEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPHeaderEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from HeaderEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPHeaderEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPHeaderEntry >> value [
	"Relation named: #value type: #OPHeader opposite: #headerEntry"

	<generated>
	<FMComment: 'Reference value from HeaderEntry to Header [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPHeaderEntry >> value: anObject [

	<generated>
	value := anObject
]
