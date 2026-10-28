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
| `value` | `OPExampleEntry` | `usedByExampleEntries` | `OPExample` | Reference value from ExampleEntry to Example [0..1].|


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
		'#components => FMOne type: #OPComponents opposite: #examples',
		'#key => FMProperty',
		'#mediaType => FMOne type: #OPMediaType opposite: #examples',
		'#value => FMOne type: #OPExample opposite: #usedByExampleEntries'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExampleEntry class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ExampleEntry super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPExampleEntry >> components [
	"Relation named: #components type: #OPComponents opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<container>
	^ components
]

{ #category : 'accessing' }
OPExampleEntry >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPExampleEntry >> key [

	<FMProperty: #key type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute key from ExampleEntry [1]'>
	^ key
]

{ #category : 'accessing' }
OPExampleEntry >> key: anObject [
	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
OPExampleEntry >> mediaType [
	"Relation named: #mediaType type: #OPMediaType opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<container>
	^ mediaType
]

{ #category : 'accessing' }
OPExampleEntry >> mediaType: anObject [

	<ignoreForCoverage>
	<generated>
	mediaType := anObject
]

{ #category : 'accessing' }
OPExampleEntry >> value [
	"Relation named: #value type: #OPExample opposite: #usedByExampleEntries"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference value from ExampleEntry to Example [0..1].'>
	^ value
]

{ #category : 'accessing' }
OPExampleEntry >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
