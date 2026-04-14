"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operation` | `OPResponseEntry` | `responses` | `OPOperation` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPResponseEntry` | `responseEntry` | `OPResponse` | Reference value from ResponseEntry to Response [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from ResponseEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPResponseEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#operation => FMOne type: #OPOperation opposite: #responses',
		'#value => FMOne type: #OPResponse opposite: #responseEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPResponseEntry class >> annotation [

	<FMClass: #ResponseEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPResponseEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from ResponseEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPResponseEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPResponseEntry >> operation [
	"Relation named: #operation type: #OPOperation opposite: #responses"

	<generated>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPResponseEntry >> operation: anObject [

	<generated>
	operation := anObject
]

{ #category : 'navigation' }
OPResponseEntry >> operationGroup [
	<generated>
	<navigation: 'Operation'>
	^ MooseSpecializedGroup with: self operation
]

{ #category : 'accessing' }
OPResponseEntry >> value [
	"Relation named: #value type: #OPResponse opposite: #responseEntry"

	<generated>
	<FMComment: 'Reference value from ResponseEntry to Response [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPResponseEntry >> value: anObject [

	<generated>
	value := anObject
]
