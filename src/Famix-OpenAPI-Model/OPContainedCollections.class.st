"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPContainedCollections` | `containedCollections` | `OPApi` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameters` | `OPContainedCollections` | `containedCollections` | `OPParameter` | Reference parameters from ContainedCollections to Parameter [0..*].|
| `responses` | `OPContainedCollections` | `containedCollections` | `OPResponse` | Reference responses from ContainedCollections to Response [0..*].|
| `schemas` | `OPContainedCollections` | `containedCollections` | `OPSchema` | Reference schemas from ContainedCollections to Schema [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPContainedCollections',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #containedCollections',
		'#parameters => FMMany type: #OPParameter opposite: #containedCollections',
		'#responses => FMMany type: #OPResponse opposite: #containedCollections',
		'#schemas => FMMany type: #OPSchema opposite: #containedCollections'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPContainedCollections class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ContainedCollections super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPContainedCollections >> addParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPContainedCollections >> addResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPContainedCollections >> addSchema: anObject [

	<ignoreForCoverage>
	<generated>
	^ self schemas add: anObject
]

{ #category : 'accessing' }
OPContainedCollections >> api [
	"Relation named: #api type: #OPApi opposite: #containedCollections"

	<ignoreForCoverage>
	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPContainedCollections >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPContainedCollections >> parameters [
	"Relation named: #parameters type: #OPParameter opposite: #containedCollections"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference parameters from ContainedCollections to Parameter [0..*].'>
	^ parameters
]

{ #category : 'accessing' }
OPContainedCollections >> parameters: anObject [

	<ignoreForCoverage>
	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPContainedCollections >> responses [
	"Relation named: #responses type: #OPResponse opposite: #containedCollections"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference responses from ContainedCollections to Response [0..*].'>
	^ responses
]

{ #category : 'accessing' }
OPContainedCollections >> responses: anObject [

	<ignoreForCoverage>
	<generated>
	responses value: anObject
]

{ #category : 'accessing' }
OPContainedCollections >> schemas [
	"Relation named: #schemas type: #OPSchema opposite: #containedCollections"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference schemas from ContainedCollections to Schema [0..*].'>
	^ schemas
]

{ #category : 'accessing' }
OPContainedCollections >> schemas: anObject [

	<ignoreForCoverage>
	<generated>
	schemas value: anObject
]
