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
| `value` | `OPMediaTypeEntry` | `mediaTypeEntry` | `OPMediaType` | Reference value from MediaTypeEntry to MediaType [0..1].|


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
		'#key => FMProperty',
		'#contentContainer => FMOne type: #OPContentContainer opposite: #content',
		'#value => FMOne type: #OPMediaType opposite: #mediaTypeEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPMediaTypeEntry class >> annotation [

	<FMClass: #MediaTypeEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPMediaTypeEntry >> contentContainer [
	"Relation named: #contentContainer type: #OPContentContainer opposite: #content"

	<generated>
	<container>
	^ contentContainer
]

{ #category : 'accessing' }
OPMediaTypeEntry >> contentContainer: anObject [

	<generated>
	contentContainer := anObject
]

{ #category : 'navigation' }
OPMediaTypeEntry >> contentContainerGroup [
	<generated>
	<navigation: 'ContentContainer'>
	^ MooseSpecializedGroup with: self contentContainer
]

{ #category : 'accessing' }
OPMediaTypeEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from MediaTypeEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPMediaTypeEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPMediaTypeEntry >> value [
	"Relation named: #value type: #OPMediaType opposite: #mediaTypeEntry"

	<generated>
	<FMComment: 'Reference value from MediaTypeEntry to MediaType [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPMediaTypeEntry >> value: anObject [

	<generated>
	value := anObject
]
