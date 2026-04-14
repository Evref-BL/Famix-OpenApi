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
| `exampleEntry` | `OPExample` | `value` | `OPExampleEntry` | |


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
		'#value => FMProperty',
		'#response => FMOne type: #OPResponse opposite: #examples',
		'#exampleEntry => FMOne type: #OPExampleEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExample class >> annotation [

	<FMClass: #Example super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPExample >> exampleEntry [
	"Relation named: #exampleEntry type: #OPExampleEntry opposite: #value"

	<generated>
	<derived>
	^ exampleEntry
]

{ #category : 'accessing' }
OPExample >> exampleEntry: anObject [

	<generated>
	exampleEntry := anObject
]

{ #category : 'accessing' }
OPExample >> mimeType [

	<FMProperty: #mimeType type: #String>
	<generated>
	<FMComment: 'Attribute mimeType from Example [1]'>
	^ mimeType
]

{ #category : 'accessing' }
OPExample >> mimeType: anObject [
	<generated>
	mimeType := anObject
]

{ #category : 'accessing' }
OPExample >> response [
	"Relation named: #response type: #OPResponse opposite: #examples"

	<generated>
	<container>
	^ response
]

{ #category : 'accessing' }
OPExample >> response: anObject [

	<generated>
	response := anObject
]

{ #category : 'navigation' }
OPExample >> responseGroup [
	<generated>
	<navigation: 'Response'>
	^ MooseSpecializedGroup with: self response
]

{ #category : 'accessing' }
OPExample >> value [

	<FMProperty: #value type: #String>
	<generated>
	<FMComment: 'Attribute value from Example [1]'>
	^ value
]

{ #category : 'accessing' }
OPExample >> value: anObject [
	<generated>
	value := anObject
]
