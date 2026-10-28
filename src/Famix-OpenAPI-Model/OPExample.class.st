"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `response` | `OPExample` | `examples` | `OPResponse` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByExampleEntries` | `OPExample` | `value` | `OPExampleEntry` | ExampleEntry entries whose value is this Example [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `mimeType` | `String` | nil | Attribute mimeType from Example [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `value` | `String` | nil | Attribute value from Example [1]|

"
Class {
	#name : 'OPExample',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#mimeType => FMProperty',
		'#response => FMOne type: #OPResponse opposite: #examples',
		'#usedByExampleEntries => FMMany type: #OPExampleEntry opposite: #value',
		'#value => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExample class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Example super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPExample >> addUsedByExampleEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByExampleEntries add: anObject
]

{ #category : 'accessing' }
OPExample >> mimeType [

	<FMProperty: #mimeType type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute mimeType from Example [1]'>
	^ mimeType
]

{ #category : 'accessing' }
OPExample >> mimeType: anObject [
	<ignoreForCoverage>
	<generated>
	mimeType := anObject
]

{ #category : 'accessing' }
OPExample >> response [
	"Relation named: #response type: #OPResponse opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<container>
	^ response
]

{ #category : 'accessing' }
OPExample >> response: anObject [

	<ignoreForCoverage>
	<generated>
	response := anObject
]

{ #category : 'accessing' }
OPExample >> usedByExampleEntries [
	"Relation named: #usedByExampleEntries type: #OPExampleEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'ExampleEntry entries whose value is this Example [0..*].'>
	^ usedByExampleEntries
]

{ #category : 'accessing' }
OPExample >> usedByExampleEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByExampleEntries value: anObject
]

{ #category : 'accessing' }
OPExample >> value [

	<FMProperty: #value type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute value from Example [1]'>
	^ value
]

{ #category : 'accessing' }
OPExample >> value: anObject [
	<ignoreForCoverage>
	<generated>
	value := anObject
]
