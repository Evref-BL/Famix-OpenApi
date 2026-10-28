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
| `value` | `OPHeaderEntry` | `usedByHeaderEntries` | `OPHeader` | Reference value from HeaderEntry to Header [0..1].|


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
		'#components => FMOne type: #OPComponents opposite: #headers',
		'#key => FMProperty',
		'#value => FMOne type: #OPHeader opposite: #usedByHeaderEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPHeaderEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #HeaderEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPHeaderEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #headers"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPHeaderEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPHeaderEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from HeaderEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPHeaderEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPHeaderEntry >> value [
	"Relation named: #value type: #OPHeader opposite: #usedByHeaderEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from HeaderEntry to Header [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPHeaderEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
