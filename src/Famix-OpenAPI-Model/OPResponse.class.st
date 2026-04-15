"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `containedCollections` | `OPResponse` | `responses` | `OPContainedCollections` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentContainer` | `OPMediaTypeEntry` | Reference content from ContentContainer to MediaTypeEntry [0..*].|
| `examples` | `OPResponse` | `response` | `OPExample` | Reference examples from Response to Example [0..*].|
| `headers` | `OPResponse` | `response` | `OPHeader` | Reference headers from Response to Header [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `declaringContext` | `OPResponse` | `response` | `OPResponseContainer` | Reference declaringContext from Response to ResponseContainer [0..1].|
| `responseDefinitionEntry` | `OPResponse` | `value` | `OPResponseDefinitionEntry` | |
| `responseEntry` | `OPResponse` | `value` | `OPResponseEntry` | |
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `schema` | `OPResponse` | `response` | `OPSchema` | Reference schema from Response to Schema [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from Response [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPResponse',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPContentContainer + OPReferenceable + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPContentContainer classTrait + OPReferenceable classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #responses',
		'#headers => FMMany type: #OPHeader opposite: #response',
		'#examples => FMMany type: #OPExample opposite: #response',
		'#declaringContext => FMOne type: #OPResponseContainer opposite: #response',
		'#schema => FMOne type: #OPSchema opposite: #response',
		'#responseEntry => FMOne type: #OPResponseEntry opposite: #value',
		'#responseDefinitionEntry => FMOne type: #OPResponseDefinitionEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPResponse class >> annotation [

	<FMClass: #Response super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPResponse >> addExample: anObject [
	<generated>
	^ self examples add: anObject
]

{ #category : 'adding' }
OPResponse >> addHeader: anObject [
	<generated>
	^ self headers add: anObject
]

{ #category : 'accessing' }
OPResponse >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #responses"

	<generated>
	<container>
	^ containedCollections
]

{ #category : 'accessing' }
OPResponse >> containedCollections: anObject [

	<generated>
	containedCollections := anObject
]

{ #category : 'navigation' }
OPResponse >> containedCollectionsGroup [
	<generated>
	<navigation: 'ContainedCollections'>
	^ MooseSpecializedGroup with: self containedCollections
]

{ #category : 'accessing' }
OPResponse >> declaringContext [
	"Relation named: #declaringContext type: #OPResponseContainer opposite: #response"

	<generated>
	<FMComment: 'Reference declaringContext from Response to ResponseContainer [0..1].'>
	^ declaringContext
]

{ #category : 'accessing' }
OPResponse >> declaringContext: anObject [

	<generated>
	declaringContext := anObject
]

{ #category : 'accessing' }
OPResponse >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from Response [1]'>
	^ description
]

{ #category : 'accessing' }
OPResponse >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPResponse >> examples [
	"Relation named: #examples type: #OPExample opposite: #response"

	<generated>
	<FMComment: 'Reference examples from Response to Example [0..*].'>
	<derived>
	^ examples
]

{ #category : 'accessing' }
OPResponse >> examples: anObject [

	<generated>
	examples value: anObject
]

{ #category : 'navigation' }
OPResponse >> examplesGroup [
	<generated>
	<navigation: 'Examples'>
	^ MooseSpecializedGroup withAll: self examples asSet
]

{ #category : 'accessing' }
OPResponse >> headers [
	"Relation named: #headers type: #OPHeader opposite: #response"

	<generated>
	<FMComment: 'Reference headers from Response to Header [0..*].'>
	<derived>
	^ headers
]

{ #category : 'accessing' }
OPResponse >> headers: anObject [

	<generated>
	headers value: anObject
]

{ #category : 'navigation' }
OPResponse >> headersGroup [
	<generated>
	<navigation: 'Headers'>
	^ MooseSpecializedGroup withAll: self headers asSet
]

{ #category : 'accessing' }
OPResponse >> responseDefinitionEntry [
	"Relation named: #responseDefinitionEntry type: #OPResponseDefinitionEntry opposite: #value"

	<generated>
	<derived>
	^ responseDefinitionEntry
]

{ #category : 'accessing' }
OPResponse >> responseDefinitionEntry: anObject [

	<generated>
	responseDefinitionEntry := anObject
]

{ #category : 'accessing' }
OPResponse >> responseEntry [
	"Relation named: #responseEntry type: #OPResponseEntry opposite: #value"

	<generated>
	<derived>
	^ responseEntry
]

{ #category : 'accessing' }
OPResponse >> responseEntry: anObject [

	<generated>
	responseEntry := anObject
]

{ #category : 'accessing' }
OPResponse >> schema [
	"Relation named: #schema type: #OPSchema opposite: #response"

	<generated>
	<FMComment: 'Reference schema from Response to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPResponse >> schema: anObject [

	<generated>
	schema := anObject
]
