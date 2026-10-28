"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPSecuritySchemeEntry` | `securityDefinitions` | `OPApi` | |
| `components` | `OPSecuritySchemeEntry` | `securitySchemes` | `OPComponents` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPSecuritySchemeEntry` | `usedBySecuritySchemeEntries` | `OPSecurityScheme` | Reference value from SecuritySchemeEntry to SecurityScheme [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from SecuritySchemeEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPSecuritySchemeEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #securityDefinitions',
		'#components => FMOne type: #OPComponents opposite: #securitySchemes',
		'#key => FMProperty',
		'#value => FMOne type: #OPSecurityScheme opposite: #usedBySecuritySchemeEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecuritySchemeEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecuritySchemeEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> api [
	"Relation named: #api type: #OPApi opposite: #securityDefinitions"

	<ignoreForCoverage>
	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #securitySchemes"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from SecuritySchemeEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> value [
	"Relation named: #value type: #OPSecurityScheme opposite: #usedBySecuritySchemeEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from SecuritySchemeEntry to SecurityScheme [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPSecuritySchemeEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
