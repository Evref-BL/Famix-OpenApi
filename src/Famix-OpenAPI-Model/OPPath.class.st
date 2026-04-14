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
| `get` | `OPPath` | `path` | `OPOperation` | Reference get from Path to Operation [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `delete` | `OPPath` | `path` | `OPOperation` | Reference delete from Path to Operation [0..1].|
| `head` | `OPPath` | `path` | `OPOperation` | Reference head from Path to Operation [0..1].|
| `options` | `OPPath` | `path` | `OPOperation` | Reference options from Path to Operation [0..1].|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |
| `parameters` | `OPPath` | `path` | `OPParameter` | Reference parameters from Path to Parameter [0..*].|
| `patch` | `OPPath` | `path` | `OPOperation` | Reference patch from Path to Operation [0..1].|
| `post` | `OPPath` | `path` | `OPOperation` | Reference post from Path to Operation [0..1].|
| `put` | `OPPath` | `path` | `OPOperation` | Reference put from Path to Operation [0..1].|
| `trace` | `OPPath` | `path` | `OPOperation` | Reference trace from Path to Operation [0..1].|


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
		'#relativePath => FMProperty',
		'#summary => FMProperty',
		'#description => FMProperty',
		'#api => FMOne type: #OPApi opposite: #paths',
		'#get => FMOne type: #OPOperation opposite: #path',
		'#put => FMOne type: #OPOperation opposite: #path',
		'#post => FMOne type: #OPOperation opposite: #path',
		'#delete => FMOne type: #OPOperation opposite: #path',
		'#options => FMOne type: #OPOperation opposite: #path',
		'#head => FMOne type: #OPOperation opposite: #path',
		'#patch => FMOne type: #OPOperation opposite: #path',
		'#trace => FMOne type: #OPOperation opposite: #path',
		'#parameters => FMMany type: #OPParameter opposite: #path'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPPath class >> annotation [

	<FMClass: #Path super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPPath >> addParameter: anObject [
	<generated>
	^ self parameters add: anObject
]

{ #category : 'accessing' }
OPPath >> api [
	"Relation named: #api type: #OPApi opposite: #paths"

	<generated>
	<FMComment: 'Opposite reference api from Path to API [0..1].'>
	<container>
	^ api
]

{ #category : 'accessing' }
OPPath >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPPath >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPPath >> delete [
	"Relation named: #delete type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference delete from Path to Operation [0..1].'>
	^ delete
]

{ #category : 'accessing' }
OPPath >> delete: anObject [

	<generated>
	delete := anObject
]

{ #category : 'navigation' }
OPPath >> deleteGroup [
	<generated>
	<navigation: 'Delete'>
	^ MooseSpecializedGroup with: self delete
]

{ #category : 'accessing' }
OPPath >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from Path [1]'>
	^ description
]

{ #category : 'accessing' }
OPPath >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPPath >> get [
	"Relation named: #get type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference get from Path to Operation [0..1].'>
	^ get
]

{ #category : 'accessing' }
OPPath >> get: anObject [

	<generated>
	get := anObject
]

{ #category : 'navigation' }
OPPath >> getGroup [
	<generated>
	<navigation: 'Get'>
	^ MooseSpecializedGroup with: self get
]

{ #category : 'accessing' }
OPPath >> head [
	"Relation named: #head type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference head from Path to Operation [0..1].'>
	^ head
]

{ #category : 'accessing' }
OPPath >> head: anObject [

	<generated>
	head := anObject
]

{ #category : 'navigation' }
OPPath >> headGroup [
	<generated>
	<navigation: 'Head'>
	^ MooseSpecializedGroup with: self head
]

{ #category : 'accessing' }
OPPath >> options [
	"Relation named: #options type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference options from Path to Operation [0..1].'>
	^ options
]

{ #category : 'accessing' }
OPPath >> options: anObject [

	<generated>
	options := anObject
]

{ #category : 'navigation' }
OPPath >> optionsGroup [
	<generated>
	<navigation: 'Options'>
	^ MooseSpecializedGroup with: self options
]

{ #category : 'accessing' }
OPPath >> parameters [
	"Relation named: #parameters type: #OPParameter opposite: #path"

	<generated>
	<FMComment: 'Reference parameters from Path to Parameter [0..*].'>
	<derived>
	^ parameters
]

{ #category : 'accessing' }
OPPath >> parameters: anObject [

	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPPath >> patch [
	"Relation named: #patch type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference patch from Path to Operation [0..1].'>
	^ patch
]

{ #category : 'accessing' }
OPPath >> patch: anObject [

	<generated>
	patch := anObject
]

{ #category : 'navigation' }
OPPath >> patchGroup [
	<generated>
	<navigation: 'Patch'>
	^ MooseSpecializedGroup with: self patch
]

{ #category : 'accessing' }
OPPath >> post [
	"Relation named: #post type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference post from Path to Operation [0..1].'>
	^ post
]

{ #category : 'accessing' }
OPPath >> post: anObject [

	<generated>
	post := anObject
]

{ #category : 'navigation' }
OPPath >> postGroup [
	<generated>
	<navigation: 'Post'>
	^ MooseSpecializedGroup with: self post
]

{ #category : 'accessing' }
OPPath >> put [
	"Relation named: #put type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference put from Path to Operation [0..1].'>
	^ put
]

{ #category : 'accessing' }
OPPath >> put: anObject [

	<generated>
	put := anObject
]

{ #category : 'navigation' }
OPPath >> putGroup [
	<generated>
	<navigation: 'Put'>
	^ MooseSpecializedGroup with: self put
]

{ #category : 'accessing' }
OPPath >> relativePath [

	<FMProperty: #relativePath type: #String>
	<generated>
	<FMComment: 'Attribute relativePath from Path [1]'>
	^ relativePath
]

{ #category : 'accessing' }
OPPath >> relativePath: anObject [
	<generated>
	relativePath := anObject
]

{ #category : 'accessing' }
OPPath >> summary [

	<FMProperty: #summary type: #String>
	<generated>
	<FMComment: 'Attribute summary from Path [1]'>
	^ summary
]

{ #category : 'accessing' }
OPPath >> summary: anObject [
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPPath >> trace [
	"Relation named: #trace type: #OPOperation opposite: #path"

	<generated>
	<FMComment: 'Reference trace from Path to Operation [0..1].'>
	^ trace
]

{ #category : 'accessing' }
OPPath >> trace: anObject [

	<generated>
	trace := anObject
]

{ #category : 'navigation' }
OPPath >> traceGroup [
	<generated>
	<navigation: 'Trace'>
	^ MooseSpecializedGroup with: self trace
]
