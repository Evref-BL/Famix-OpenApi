"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPSchemaEntry` | `definitions` | `OPApi` | |
| `components` | `OPSchemaEntry` | `schemas` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `value` | `OPSchemaEntry` | `schemaEntry` | `OPSchema` | Reference value from SchemaEntry to Schema [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from SchemaEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPSchemaEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#api => FMOne type: #OPApi opposite: #definitions',
		'#components => FMOne type: #OPComponents opposite: #schemas',
		'#value => FMOne type: #OPSchema opposite: #schemaEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSchemaEntry class >> annotation [

	<FMClass: #SchemaEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPSchemaEntry >> api [
	"Relation named: #api type: #OPApi opposite: #definitions"

	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPSchemaEntry >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPSchemaEntry >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPSchemaEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #schemas"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPSchemaEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPSchemaEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPSchemaEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from SchemaEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPSchemaEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPSchemaEntry >> value [
	"Relation named: #value type: #OPSchema opposite: #schemaEntry"

	<generated>
	<FMComment: 'Reference value from SchemaEntry to Schema [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPSchemaEntry >> value: anObject [

	<generated>
	value := anObject
]
