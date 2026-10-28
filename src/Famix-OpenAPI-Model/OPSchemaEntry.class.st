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
| `value` | `OPSchemaEntry` | `usedBySchemaEntries` | `OPSchema` | Reference value from SchemaEntry to Schema [0..1].|


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
		'#api => FMOne type: #OPApi opposite: #definitions',
		'#components => FMOne type: #OPComponents opposite: #schemas',
		'#key => FMProperty',
		'#value => FMOne type: #OPSchema opposite: #usedBySchemaEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSchemaEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SchemaEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPSchemaEntry >> api [
	"Relation named: #api type: #OPApi opposite: #definitions"

	<ignoreForCoverage>
	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPSchemaEntry >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPSchemaEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #schemas"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPSchemaEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPSchemaEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from SchemaEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPSchemaEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPSchemaEntry >> value [
	"Relation named: #value type: #OPSchema opposite: #usedBySchemaEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from SchemaEntry to Schema [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPSchemaEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
