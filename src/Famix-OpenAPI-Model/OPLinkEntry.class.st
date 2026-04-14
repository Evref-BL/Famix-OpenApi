"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPLinkEntry` | `links` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPLinkEntry` | `linkEntry` | `OPLink` | Reference value from LinkEntry to Link [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from LinkEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPLinkEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #links',
		'#value => FMOne type: #OPLink opposite: #linkEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPLinkEntry class >> annotation [

	<FMClass: #LinkEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPLinkEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #links"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPLinkEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPLinkEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPLinkEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from LinkEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPLinkEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPLinkEntry >> value [
	"Relation named: #value type: #OPLink opposite: #linkEntry"

	<generated>
	<FMComment: 'Reference value from LinkEntry to Link [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPLinkEntry >> value: anObject [

	<generated>
	value := anObject
]
