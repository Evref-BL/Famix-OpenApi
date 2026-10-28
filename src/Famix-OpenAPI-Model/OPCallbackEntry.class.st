"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPCallbackEntry` | `callbacks` | `OPComponents` | |
| `operation` | `OPCallbackEntry` | `callbacks` | `OPOperation` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPCallbackEntry` | `usedByCallbackEntries` | `OPCallback` | Reference value from CallbackEntry to Callback [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from CallbackEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPCallbackEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #callbacks',
		'#key => FMProperty',
		'#operation => FMOne type: #OPOperation opposite: #callbacks',
		'#value => FMOne type: #OPCallback opposite: #usedByCallbackEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPCallbackEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #CallbackEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPCallbackEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #callbacks"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPCallbackEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPCallbackEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from CallbackEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPCallbackEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPCallbackEntry >> operation [
	"Relation named: #operation type: #OPOperation opposite: #callbacks"

	<ignoreForCoverage>
	<generated>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPCallbackEntry >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPCallbackEntry >> value [
	"Relation named: #value type: #OPCallback opposite: #usedByCallbackEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from CallbackEntry to Callback [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPCallbackEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
