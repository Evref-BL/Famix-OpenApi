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
| `paramters` | `OPContainedCollections` | `containedCollections` | `OPParameter` | Reference paramters from ContainedCollections to Parameter [0..*].|
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
		'#paramters => FMMany type: #OPParameter opposite: #containedCollections',
		'#schemas => FMMany type: #OPSchema opposite: #containedCollections',
		'#responses => FMMany type: #OPResponse opposite: #containedCollections',
		'#api => FMOne type: #OPApi opposite: #containedCollections'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPContainedCollections class >> annotation [

	<FMClass: #ContainedCollections super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPContainedCollections >> addParamter: anObject [
	<generated>
	^ self paramters add: anObject
]

{ #category : 'adding' }
OPContainedCollections >> addResponse: anObject [
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPContainedCollections >> addSchema: anObject [
	<generated>
	^ self schemas add: anObject
]

{ #category : 'accessing' }
OPContainedCollections >> api [
	"Relation named: #api type: #OPApi opposite: #containedCollections"

	<generated>
	<container>
	<derived>
	^ api
]

{ #category : 'accessing' }
OPContainedCollections >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPContainedCollections >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPContainedCollections >> paramters [
	"Relation named: #paramters type: #OPParameter opposite: #containedCollections"

	<generated>
	<FMComment: 'Reference paramters from ContainedCollections to Parameter [0..*].'>
	<derived>
	^ paramters
]

{ #category : 'accessing' }
OPContainedCollections >> paramters: anObject [

	<generated>
	paramters value: anObject
]

{ #category : 'navigation' }
OPContainedCollections >> paramtersGroup [
	<generated>
	<navigation: 'Paramters'>
	^ MooseSpecializedGroup withAll: self paramters asSet
]

{ #category : 'accessing' }
OPContainedCollections >> responses [
	"Relation named: #responses type: #OPResponse opposite: #containedCollections"

	<generated>
	<FMComment: 'Reference responses from ContainedCollections to Response [0..*].'>
	<derived>
	^ responses
]

{ #category : 'accessing' }
OPContainedCollections >> responses: anObject [

	<generated>
	responses value: anObject
]

{ #category : 'navigation' }
OPContainedCollections >> responsesGroup [
	<generated>
	<navigation: 'Responses'>
	^ MooseSpecializedGroup withAll: self responses asSet
]

{ #category : 'accessing' }
OPContainedCollections >> schemas [
	"Relation named: #schemas type: #OPSchema opposite: #containedCollections"

	<generated>
	<FMComment: 'Reference schemas from ContainedCollections to Schema [0..*].'>
	<derived>
	^ schemas
]

{ #category : 'accessing' }
OPContainedCollections >> schemas: anObject [

	<generated>
	schemas value: anObject
]

{ #category : 'navigation' }
OPContainedCollections >> schemasGroup [
	<generated>
	<navigation: 'Schemas'>
	^ MooseSpecializedGroup withAll: self schemas asSet
]
