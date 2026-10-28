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
| `schema` | `OPMediaType` | `usedByMediaTypes` | `OPSchema` | Reference schema from MediaType to Schema [0..1].|
| `usedByMediaTypeEntries` | `OPMediaType` | `value` | `OPMediaTypeEntry` | MediaTypeEntry entries whose value is this MediaType [0..*].|


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
		'#examples => FMMany type: #OPExampleEntry opposite: #mediaType',
		'#schema => FMOne type: #OPSchema opposite: #usedByMediaTypes',
		'#usedByMediaTypeEntries => FMMany type: #OPMediaTypeEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPMediaType class >> annotation [

	<ignoreForCoverage>
	<FMClass: #MediaType super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPMediaType >> addExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self examples add: anObject
]

{ #category : 'adding' }
OPMediaType >> addUsedByMediaTypeEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByMediaTypeEntries add: anObject
]

{ #category : 'accessing' }
OPMediaType >> example [

	<FMProperty: #example type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute example from MediaType [1]'>
	^ example
]

{ #category : 'accessing' }
OPMediaType >> example: anObject [
	<ignoreForCoverage>
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPMediaType >> examples [
	"Relation named: #examples type: #OPExampleEntry opposite: #mediaType"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference examples from MediaType to ExampleEntry [0..*].'>
	^ examples
]

{ #category : 'accessing' }
OPMediaType >> examples: anObject [

	<ignoreForCoverage>
	<generated>
	examples value: anObject
]

{ #category : 'accessing' }
OPMediaType >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByMediaTypes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference schema from MediaType to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPMediaType >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPMediaType >> usedByMediaTypeEntries [
	"Relation named: #usedByMediaTypeEntries type: #OPMediaTypeEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'MediaTypeEntry entries whose value is this MediaType [0..*].'>
	^ usedByMediaTypeEntries
]

{ #category : 'accessing' }
OPMediaType >> usedByMediaTypeEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByMediaTypeEntries value: anObject
]
