"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `info` | `OPLicense` | `license` | `OPInfo` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `url` | `String` | nil | Attribute url from License [1]|

"
Class {
	#name : 'OPLicense',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#url => FMProperty',
		'#info => FMOne type: #OPInfo opposite: #license'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPLicense class >> annotation [

	<FMClass: #License super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPLicense >> info [
	"Relation named: #info type: #OPInfo opposite: #license"

	<generated>
	<container>
	<derived>
	^ info
]

{ #category : 'accessing' }
OPLicense >> info: anObject [

	<generated>
	info := anObject
]

{ #category : 'navigation' }
OPLicense >> infoGroup [
	<generated>
	<navigation: 'Info'>
	^ MooseSpecializedGroup with: self info
]

{ #category : 'accessing' }
OPLicense >> url [

	<FMProperty: #url type: #String>
	<generated>
	<FMComment: 'Attribute url from License [1]'>
	^ url
]

{ #category : 'accessing' }
OPLicense >> url: anObject [
	<generated>
	url := anObject
]
