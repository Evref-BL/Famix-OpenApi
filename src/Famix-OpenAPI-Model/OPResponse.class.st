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
| `schema` | `OPResponse` | `usedByResponses` | `OPSchema` | Reference schema from Response to Schema [0..1].|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `usedByResponseDefinitionEntries` | `OPResponse` | `value` | `OPResponseDefinitionEntry` | ResponseDefinitionEntry entries whose value is this Response [0..*].|
| `usedByResponseEntries` | `OPResponse` | `value` | `OPResponseEntry` | ResponseEntry entries whose value is this Response [0..*].|


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
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #responses',
		'#declaringContext => FMOne type: #OPResponseContainer opposite: #response',
		'#description => FMProperty',
		'#examples => FMMany type: #OPExample opposite: #response',
		'#headers => FMMany type: #OPHeader opposite: #response',
		'#schema => FMOne type: #OPSchema opposite: #usedByResponses',
		'#usedByResponseDefinitionEntries => FMMany type: #OPResponseDefinitionEntry opposite: #value',
		'#usedByResponseEntries => FMMany type: #OPResponseEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPResponse class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Response super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPResponse >> addExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self examples add: anObject
]

{ #category : 'adding' }
OPResponse >> addHeader: anObject [

	<ignoreForCoverage>
	<generated>
	^ self headers add: anObject
]

{ #category : 'adding' }
OPResponse >> addUsedByResponseDefinitionEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByResponseDefinitionEntries add: anObject
]

{ #category : 'adding' }
OPResponse >> addUsedByResponseEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByResponseEntries add: anObject
]

{ #category : 'accessing' }
OPResponse >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #responses"

	<ignoreForCoverage>
	<generated>
	<container>
	^ containedCollections
]

{ #category : 'accessing' }
OPResponse >> containedCollections: anObject [

	<ignoreForCoverage>
	<generated>
	containedCollections := anObject
]

{ #category : 'accessing' }
OPResponse >> declaringContext [
	"Relation named: #declaringContext type: #OPResponseContainer opposite: #response"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference declaringContext from Response to ResponseContainer [0..1].'>
	^ declaringContext
]

{ #category : 'accessing' }
OPResponse >> declaringContext: anObject [

	<ignoreForCoverage>
	<generated>
	declaringContext := anObject
]

{ #category : 'accessing' }
OPResponse >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from Response [1]'>
	^ description
]

{ #category : 'accessing' }
OPResponse >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPResponse >> examples [
	"Relation named: #examples type: #OPExample opposite: #response"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference examples from Response to Example [0..*].'>
	^ examples
]

{ #category : 'accessing' }
OPResponse >> examples: anObject [

	<ignoreForCoverage>
	<generated>
	examples value: anObject
]

{ #category : 'accessing' }
OPResponse >> headers [
	"Relation named: #headers type: #OPHeader opposite: #response"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference headers from Response to Header [0..*].'>
	^ headers
]

{ #category : 'accessing' }
OPResponse >> headers: anObject [

	<ignoreForCoverage>
	<generated>
	headers value: anObject
]

{ #category : 'accessing' }
OPResponse >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByResponses"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference schema from Response to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPResponse >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPResponse >> usedByResponseDefinitionEntries [
	"Relation named: #usedByResponseDefinitionEntries type: #OPResponseDefinitionEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'ResponseDefinitionEntry entries whose value is this Response [0..*].'>
	^ usedByResponseDefinitionEntries
]

{ #category : 'accessing' }
OPResponse >> usedByResponseDefinitionEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByResponseDefinitionEntries value: anObject
]

{ #category : 'accessing' }
OPResponse >> usedByResponseEntries [
	"Relation named: #usedByResponseEntries type: #OPResponseEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'ResponseEntry entries whose value is this Response [0..*].'>
	^ usedByResponseEntries
]

{ #category : 'accessing' }
OPResponse >> usedByResponseEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByResponseEntries value: anObject
]
