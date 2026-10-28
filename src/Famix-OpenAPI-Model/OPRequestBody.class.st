"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentContainer` | `OPMediaTypeEntry` | Reference content from ContentContainer to MediaTypeEntry [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByOperations` | `OPRequestBody` | `requestBody` | `OPOperation` | Operations using this RequestBody [0..*].|
| `usedByRequestBodyEntries` | `OPRequestBody` | `value` | `OPRequestBodyEntry` | RequestBodyEntry entries whose value is this RequestBody [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from RequestBody [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `required` | `Boolean` | nil | Attribute required from RequestBody [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPRequestBody',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPContentContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPContentContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#required => FMProperty',
		'#usedByOperations => FMMany type: #OPOperation opposite: #requestBody',
		'#usedByRequestBodyEntries => FMMany type: #OPRequestBodyEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPRequestBody class >> annotation [

	<ignoreForCoverage>
	<FMClass: #RequestBody super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPRequestBody >> addUsedByOperation: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByOperations add: anObject
]

{ #category : 'adding' }
OPRequestBody >> addUsedByRequestBodyEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByRequestBodyEntries add: anObject
]

{ #category : 'accessing' }
OPRequestBody >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from RequestBody [1]'>
	^ description
]

{ #category : 'accessing' }
OPRequestBody >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPRequestBody >> required [

	<FMProperty: #required type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute required from RequestBody [1]'>
	^ required
]

{ #category : 'accessing' }
OPRequestBody >> required: anObject [
	<ignoreForCoverage>
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPRequestBody >> usedByOperations [
	"Relation named: #usedByOperations type: #OPOperation opposite: #requestBody"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Operations using this RequestBody [0..*].'>
	^ usedByOperations
]

{ #category : 'accessing' }
OPRequestBody >> usedByOperations: anObject [

	<ignoreForCoverage>
	<generated>
	usedByOperations value: anObject
]

{ #category : 'accessing' }
OPRequestBody >> usedByRequestBodyEntries [
	"Relation named: #usedByRequestBodyEntries type: #OPRequestBodyEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'RequestBodyEntry entries whose value is this RequestBody [0..*].'>
	^ usedByRequestBodyEntries
]

{ #category : 'accessing' }
OPRequestBody >> usedByRequestBodyEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByRequestBodyEntries value: anObject
]
