"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contentContainer` | `OPMediaTypeEntry` | `content` | `OPContentContainer` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPMediaTypeEntry` | `usedByMediaTypeEntries` | `OPMediaType` | Reference value from MediaTypeEntry to MediaType [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from MediaTypeEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPMediaTypeEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#contentContainer => FMOne type: #OPContentContainer opposite: #content',
		'#key => FMProperty',
		'#value => FMOne type: #OPMediaType opposite: #usedByMediaTypeEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPMediaTypeEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #MediaTypeEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPMediaTypeEntry >> contentContainer [
	"Relation named: #contentContainer type: #OPContentContainer opposite: #content"

	<ignoreForCoverage>
	<generated>
	<container>
	^ contentContainer
]

{ #category : 'accessing' }
OPMediaTypeEntry >> contentContainer: anObject [

	<ignoreForCoverage>
	<generated>
	contentContainer := anObject
]

{ #category : 'accessing' }
OPMediaTypeEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from MediaTypeEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPMediaTypeEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPMediaTypeEntry >> value [
	"Relation named: #value type: #OPMediaType opposite: #usedByMediaTypeEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from MediaTypeEntry to MediaType [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPMediaTypeEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
