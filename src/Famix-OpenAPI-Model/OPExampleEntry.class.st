"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPExampleEntry` | `examples` | `OPComponents` | |
| `mediaType` | `OPExampleEntry` | `examples` | `OPMediaType` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `OPExampleEntry` | `exampleEntry` | `OPExample` | Reference value from ExampleEntry to Example [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `key` | `String` | nil | Attribute key from ExampleEntry [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPExampleEntry',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#key => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #examples',
		'#mediaType => FMOne type: #OPMediaType opposite: #examples',
		'#value => FMOne type: #OPExample opposite: #exampleEntry'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExampleEntry class >> annotation [

	<FMClass: #ExampleEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPExampleEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #examples"

	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPExampleEntry >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPExampleEntry >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPExampleEntry >> key [

	<FMProperty: #key type: #String>
	<generated>
	<FMComment: 'Attribute key from ExampleEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPExampleEntry >> key: anObject [
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPExampleEntry >> mediaType [
	"Relation named: #mediaType type: #OPMediaType opposite: #examples"

	<generated>
	<container>
	^ mediaType
]

{ #category : 'accessing' }
OPExampleEntry >> mediaType: anObject [

	<generated>
	mediaType := anObject
]

{ #category : 'navigation' }
OPExampleEntry >> mediaTypeGroup [
	<generated>
	<navigation: 'MediaType'>
	^ MooseSpecializedGroup with: self mediaType
]

{ #category : 'accessing' }
OPExampleEntry >> value [
	"Relation named: #value type: #OPExample opposite: #exampleEntry"

	<generated>
	<FMComment: 'Reference value from ExampleEntry to Example [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPExampleEntry >> value: anObject [

	<generated>
	value := anObject
]
