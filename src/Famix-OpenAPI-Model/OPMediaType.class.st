"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `examples` | `OPMediaType` | `mediaType` | `OPExampleEntry` | Reference examples from MediaType to ExampleEntry [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mediaTypeEntry` | `OPMediaType` | `value` | `OPMediaTypeEntry` | |
| `schema` | `OPMediaType` | `mediaType` | `OPSchema` | Reference schema from MediaType to Schema [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `example` | `Object` | nil | Attribute example from MediaType [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPMediaType',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#example => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #mediaType',
		'#examples => FMMany type: #OPExampleEntry opposite: #mediaType',
		'#mediaTypeEntry => FMOne type: #OPMediaTypeEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPMediaType class >> annotation [

	<FMClass: #MediaType super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPMediaType >> addExample: anObject [
	<generated>
	^ self examples add: anObject
]

{ #category : 'accessing' }
OPMediaType >> example [

	<FMProperty: #example type: #Object>
	<generated>
	<FMComment: 'Attribute example from MediaType [1]'>
	^ example
]

{ #category : 'accessing' }
OPMediaType >> example: anObject [
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPMediaType >> examples [
	"Relation named: #examples type: #OPExampleEntry opposite: #mediaType"

	<generated>
	<FMComment: 'Reference examples from MediaType to ExampleEntry [0..*].'>
	<derived>
	^ examples
]

{ #category : 'accessing' }
OPMediaType >> examples: anObject [

	<generated>
	examples value: anObject
]

{ #category : 'navigation' }
OPMediaType >> examplesGroup [
	<generated>
	<navigation: 'Examples'>
	^ MooseSpecializedGroup withAll: self examples asSet
]

{ #category : 'accessing' }
OPMediaType >> mediaTypeEntry [
	"Relation named: #mediaTypeEntry type: #OPMediaTypeEntry opposite: #value"

	<generated>
	<derived>
	^ mediaTypeEntry
]

{ #category : 'accessing' }
OPMediaType >> mediaTypeEntry: anObject [

	<generated>
	mediaTypeEntry := anObject
]

{ #category : 'accessing' }
OPMediaType >> schema [
	"Relation named: #schema type: #OPSchema opposite: #mediaType"

	<generated>
	<FMComment: 'Reference schema from MediaType to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPMediaType >> schema: anObject [

	<generated>
	schema := anObject
]
