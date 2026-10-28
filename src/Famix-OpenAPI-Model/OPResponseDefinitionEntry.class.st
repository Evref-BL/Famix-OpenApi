"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPResponseDefinitionEntry` | `responses` | `OPApi` | |
| `components` | `OPResponseDefinitionEntry` | `responses` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `response` | `OPResponseContainer` | `declaringContext` | `OPResponse` | |
| `value` | `OPResponseDefinitionEntry` | `usedByResponseDefinitionEntries` | `OPResponse` | Reference value from ResponseDefinitionEntry to Response [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from ResponseDefinitionEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPResponseDefinitionEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPResponseContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPResponseContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #responses',
		'#components => FMOne type: #OPComponents opposite: #responses',
		'#key => FMProperty',
		'#value => FMOne type: #OPResponse opposite: #usedByResponseDefinitionEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPResponseDefinitionEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ResponseDefinitionEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> api [
	"Relation named: #api type: #OPApi opposite: #responses"

	<ignoreForCoverage>
	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #responses"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from ResponseDefinitionEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> value [
	"Relation named: #value type: #OPResponse opposite: #usedByResponseDefinitionEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from ResponseDefinitionEntry to Response [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPResponseDefinitionEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
