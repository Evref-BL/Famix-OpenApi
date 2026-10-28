"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByLinkEntries` | `OPLink` | `value` | `OPLinkEntry` | LinkEntry entries whose value is this Link [0..*].|


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
		'#description => FMProperty',
		'#operationId => FMProperty',
		'#operationRef => FMProperty',
		'#requestBody => FMProperty',
		'#usedByLinkEntries => FMMany type: #OPLinkEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPLink class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Link super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPLink >> addUsedByLinkEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByLinkEntries add: anObject
]

{ #category : 'accessing' }
OPLink >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from Link [1]'>
	^ description
]

{ #category : 'accessing' }
OPLink >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPLink >> operationId [

	<FMProperty: #operationId type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute operationId from Link [1]'>
	^ operationId
]

{ #category : 'accessing' }
OPLink >> operationId: anObject [
	<ignoreForCoverage>
	<generated>
	operationId := anObject
]

{ #category : 'accessing' }
OPLink >> operationRef [

	<FMProperty: #operationRef type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute operationRef from Link [1]'>
	^ operationRef
]

{ #category : 'accessing' }
OPLink >> operationRef: anObject [
	<ignoreForCoverage>
	<generated>
	operationRef := anObject
]

{ #category : 'accessing' }
OPLink >> requestBody [

	<FMProperty: #requestBody type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute requestBody from Link [1]'>
	^ requestBody
]

{ #category : 'accessing' }
OPLink >> requestBody: anObject [
	<ignoreForCoverage>
	<generated>
	requestBody := anObject
]

{ #category : 'accessing' }
OPLink >> usedByLinkEntries [
	"Relation named: #usedByLinkEntries type: #OPLinkEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'LinkEntry entries whose value is this Link [0..*].'>
	^ usedByLinkEntries
]

{ #category : 'accessing' }
OPLink >> usedByLinkEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByLinkEntries value: anObject
]
