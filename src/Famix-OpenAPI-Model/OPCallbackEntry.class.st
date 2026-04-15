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
| `value` | `OPCallbackEntry` | `callbackEntry` | `OPCallback` | Reference value from CallbackEntry to Callback [0..1].|


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
		'#key => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #callbacks',
		'#operation => FMOne type: #OPOperation opposite: #callbacks',
		'#value => FMOne type: #OPCallback opposite: #callbackEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPCallbackEntry class >> annotation [

	<FMClass: #CallbackEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPCallbackEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #callbacks"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPCallbackEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPCallbackEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPCallbackEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from CallbackEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPCallbackEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPCallbackEntry >> operation [
	"Relation named: #operation type: #OPOperation opposite: #callbacks"

	<generated>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPCallbackEntry >> operation: anObject [

	<generated>
	operation := anObject
]

{ #category : 'navigation' }
OPCallbackEntry >> operationGroup [
	<generated>
	<navigation: 'Operation'>
	^ MooseSpecializedGroup with: self operation
]

{ #category : 'accessing' }
OPCallbackEntry >> value [
	"Relation named: #value type: #OPCallback opposite: #callbackEntry"

	<generated>
	<FMComment: 'Reference value from CallbackEntry to Callback [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPCallbackEntry >> value: anObject [

	<generated>
	value := anObject
]
