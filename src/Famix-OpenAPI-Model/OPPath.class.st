"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPPath` | `paths` | `OPApi` | Opposite reference api from Path to API [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operations` | `OPPath` | `path` | `OPOperation` | Reference operations from Path to Operation [0..*]: one operation per HTTP method.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |
| `parameters` | `OPPath` | `usedByPaths` | `OPParameter` | Reference parameters from Path to Parameter [0..*]. A parameter may be shared by several paths.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from Path [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `relativePath` | `String` | nil | Attribute relativePath from Path [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `summary` | `String` | nil | Attribute summary from Path [1]|

"
Class {
	#name : 'OPPath',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPParameterContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPParameterContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #paths',
		'#description => FMProperty',
		'#operations => FMMany type: #OPOperation opposite: #path',
		'#parameters => FMMany type: #OPParameter opposite: #usedByPaths',
		'#relativePath => FMProperty',
		'#summary => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPPath class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Path super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPPath >> addOperation: anObject [

	<ignoreForCoverage>
	<generated>
	^ self operations add: anObject
]

{ #category : 'adding' }
OPPath >> addParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self parameters add: anObject
]

{ #category : 'accessing' }
OPPath >> api [
	"Relation named: #api type: #OPApi opposite: #paths"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference api from Path to API [0..1].'>
	<container>
	^ api
]

{ #category : 'accessing' }
OPPath >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPPath >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from Path [1]'>
	^ description
]

{ #category : 'accessing' }
OPPath >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPPath >> operations [
	"Relation named: #operations type: #OPOperation opposite: #path"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference operations from Path to Operation [0..*]: one operation per HTTP method.'>
	^ operations
]

{ #category : 'accessing' }
OPPath >> operations: anObject [

	<ignoreForCoverage>
	<generated>
	operations value: anObject
]

{ #category : 'accessing' }
OPPath >> parameters [
	"Relation named: #parameters type: #OPParameter opposite: #usedByPaths"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference parameters from Path to Parameter [0..*]. A parameter may be shared by several paths.'>
	^ parameters
]

{ #category : 'accessing' }
OPPath >> parameters: anObject [

	<ignoreForCoverage>
	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPPath >> relativePath [

	<FMProperty: #relativePath type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute relativePath from Path [1]'>
	^ relativePath
]

{ #category : 'accessing' }
OPPath >> relativePath: anObject [
	<ignoreForCoverage>
	<generated>
	relativePath := anObject
]

{ #category : 'accessing' }
OPPath >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute summary from Path [1]'>
	^ summary
]

{ #category : 'accessing' }
OPPath >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]
