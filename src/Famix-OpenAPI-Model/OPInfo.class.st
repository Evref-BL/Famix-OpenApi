"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPInfo` | `info` | `OPApi` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contact` | `OPInfo` | `info` | `OPContact` | Reference contact from Info to Contact [0..1].|
| `license` | `OPInfo` | `info` | `OPLicense` | Reference license from Info to License [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from Info [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `termsOfService` | `String` | nil | Attribute termsOfService from Info [1]|
| `title` | `String` | nil | Attribute title from Info [1]|
| `version` | `String` | nil | Attribute version from Info [1]|

"
Class {
	#name : 'OPInfo',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#title => FMProperty',
		'#description => FMProperty',
		'#termsOfService => FMProperty',
		'#version => FMProperty',
		'#api => FMOne type: #OPApi opposite: #info',
		'#contact => FMOne type: #OPContact opposite: #info',
		'#license => FMOne type: #OPLicense opposite: #info'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPInfo class >> annotation [

	<FMClass: #Info super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPInfo >> api [
	"Relation named: #api type: #OPApi opposite: #info"

	<generated>
	<container>
	<derived>
	^ api
]

{ #category : 'accessing' }
OPInfo >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPInfo >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPInfo >> contact [
	"Relation named: #contact type: #OPContact opposite: #info"

	<generated>
	<FMComment: 'Reference contact from Info to Contact [0..1].'>
	^ contact
]

{ #category : 'accessing' }
OPInfo >> contact: anObject [

	<generated>
	contact := anObject
]

{ #category : 'navigation' }
OPInfo >> contactGroup [
	<generated>
	<navigation: 'Contact'>
	^ MooseSpecializedGroup with: self contact
]

{ #category : 'accessing' }
OPInfo >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from Info [1]'>
	^ description
]

{ #category : 'accessing' }
OPInfo >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPInfo >> license [
	"Relation named: #license type: #OPLicense opposite: #info"

	<generated>
	<FMComment: 'Reference license from Info to License [0..1].'>
	^ license
]

{ #category : 'accessing' }
OPInfo >> license: anObject [

	<generated>
	license := anObject
]

{ #category : 'navigation' }
OPInfo >> licenseGroup [
	<generated>
	<navigation: 'License'>
	^ MooseSpecializedGroup with: self license
]

{ #category : 'accessing' }
OPInfo >> termsOfService [

	<FMProperty: #termsOfService type: #String>
	<generated>
	<FMComment: 'Attribute termsOfService from Info [1]'>
	^ termsOfService
]

{ #category : 'accessing' }
OPInfo >> termsOfService: anObject [
	<generated>
	termsOfService := anObject
]

{ #category : 'accessing' }
OPInfo >> title [

	<FMProperty: #title type: #String>
	<generated>
	<FMComment: 'Attribute title from Info [1]'>
	^ title
]

{ #category : 'accessing' }
OPInfo >> title: anObject [
	<generated>
	title := anObject
]

{ #category : 'accessing' }
OPInfo >> version [

	<FMProperty: #version type: #String>
	<generated>
	<FMComment: 'Attribute version from Info [1]'>
	^ version
]

{ #category : 'accessing' }
OPInfo >> version: anObject [
	<generated>
	version := anObject
]
