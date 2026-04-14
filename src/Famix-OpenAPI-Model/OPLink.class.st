"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `linkEntry` | `OPLink` | `value` | `OPLinkEntry` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from Link [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `operationId` | `String` | nil | Attribute operationId from Link [1]|
| `operationRef` | `String` | nil | Attribute operationRef from Link [1]|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `requestBody` | `String` | nil | Attribute requestBody from Link [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPLink',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#operationRef => FMProperty',
		'#operationId => FMProperty',
		'#requestBody => FMProperty',
		'#description => FMProperty',
		'#linkEntry => FMOne type: #OPLinkEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPLink class >> annotation [

	<FMClass: #Link super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPLink >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from Link [1]'>
	^ description
]

{ #category : 'accessing' }
OPLink >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPLink >> linkEntry [
	"Relation named: #linkEntry type: #OPLinkEntry opposite: #value"

	<generated>
	<derived>
	^ linkEntry
]

{ #category : 'accessing' }
OPLink >> linkEntry: anObject [

	<generated>
	linkEntry := anObject
]

{ #category : 'accessing' }
OPLink >> operationId [

	<FMProperty: #operationId type: #String>
	<generated>
	<FMComment: 'Attribute operationId from Link [1]'>
	^ operationId
]

{ #category : 'accessing' }
OPLink >> operationId: anObject [
	<generated>
	operationId := anObject
]

{ #category : 'accessing' }
OPLink >> operationRef [

	<FMProperty: #operationRef type: #String>
	<generated>
	<FMComment: 'Attribute operationRef from Link [1]'>
	^ operationRef
]

{ #category : 'accessing' }
OPLink >> operationRef: anObject [
	<generated>
	operationRef := anObject
]

{ #category : 'accessing' }
OPLink >> requestBody [

	<FMProperty: #requestBody type: #String>
	<generated>
	<FMComment: 'Attribute requestBody from Link [1]'>
	^ requestBody
]

{ #category : 'accessing' }
OPLink >> requestBody: anObject [
	<generated>
	requestBody := anObject
]
