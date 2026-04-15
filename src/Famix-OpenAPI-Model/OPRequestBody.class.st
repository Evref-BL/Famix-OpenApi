"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operation` | `OPRequestBody` | `requestBody` | `OPOperation` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentContainer` | `OPMediaTypeEntry` | Reference content from ContentContainer to MediaTypeEntry [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `requestBodyEntry` | `OPRequestBody` | `value` | `OPRequestBodyEntry` | |


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
		'#operation => FMOne type: #OPOperation opposite: #requestBody',
		'#requestBodyEntry => FMOne type: #OPRequestBodyEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPRequestBody class >> annotation [

	<FMClass: #RequestBody super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPRequestBody >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from RequestBody [1]'>
	^ description
]

{ #category : 'accessing' }
OPRequestBody >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPRequestBody >> operation [
	"Relation named: #operation type: #OPOperation opposite: #requestBody"

	<generated>
	<container>
	<derived>
	^ operation
]

{ #category : 'accessing' }
OPRequestBody >> operation: anObject [

	<generated>
	operation := anObject
]

{ #category : 'navigation' }
OPRequestBody >> operationGroup [
	<generated>
	<navigation: 'Operation'>
	^ MooseSpecializedGroup with: self operation
]

{ #category : 'accessing' }
OPRequestBody >> requestBodyEntry [
	"Relation named: #requestBodyEntry type: #OPRequestBodyEntry opposite: #value"

	<generated>
	<derived>
	^ requestBodyEntry
]

{ #category : 'accessing' }
OPRequestBody >> requestBodyEntry: anObject [

	<generated>
	requestBodyEntry := anObject
]

{ #category : 'accessing' }
OPRequestBody >> required [

	<FMProperty: #required type: #Boolean>
	<generated>
	<FMComment: 'Attribute required from RequestBody [1]'>
	^ required
]

{ #category : 'accessing' }
OPRequestBody >> required: anObject [
	<generated>
	required := anObject
]
