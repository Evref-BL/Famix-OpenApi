"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `info` | `OPContact` | `contact` | `OPInfo` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `email` | `String` | nil | Attribute email from Contact [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `url` | `String` | nil | Attribute url from Contact [1]|

"
Class {
	#name : 'OPContact',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#url => FMProperty',
		'#email => FMProperty',
		'#info => FMOne type: #OPInfo opposite: #contact'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPContact class >> annotation [

	<FMClass: #Contact super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPContact >> email [

	<FMProperty: #email type: #String>
	<generated>
	<FMComment: 'Attribute email from Contact [1]'>
	^ email
]

{ #category : 'accessing' }
OPContact >> email: anObject [
	<generated>
	email := anObject
]

{ #category : 'accessing' }
OPContact >> info [
	"Relation named: #info type: #OPInfo opposite: #contact"

	<generated>
	<container>
	<derived>
	^ info
]

{ #category : 'accessing' }
OPContact >> info: anObject [

	<generated>
	info := anObject
]

{ #category : 'navigation' }
OPContact >> infoGroup [
	<generated>
	<navigation: 'Info'>
	^ MooseSpecializedGroup with: self info
]

{ #category : 'accessing' }
OPContact >> url [

	<FMProperty: #url type: #String>
	<generated>
	<FMComment: 'Attribute url from Contact [1]'>
	^ url
]

{ #category : 'accessing' }
OPContact >> url: anObject [
	<generated>
	url := anObject
]
