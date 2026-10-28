"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPRequestBodyEntry` | `requestBodies` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPRequestBodyEntry` | `usedByRequestBodyEntries` | `OPRequestBody` | Reference value from RequestBodyEntry to RequestBody [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from RequestBodyEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPRequestBodyEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #requestBodies',
		'#key => FMProperty',
		'#value => FMOne type: #OPRequestBody opposite: #usedByRequestBodyEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPRequestBodyEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #RequestBodyEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPRequestBodyEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #requestBodies"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPRequestBodyEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPRequestBodyEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from RequestBodyEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPRequestBodyEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPRequestBodyEntry >> value [
	"Relation named: #value type: #OPRequestBody opposite: #usedByRequestBodyEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from RequestBodyEntry to RequestBody [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPRequestBodyEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
