"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPInfo` | `info` | `OPApi` | |
| `openApi` | `OPInfo` | `info` | `OPOpenApi` | Opposite reference openApi from Info to OpenApi [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contact` | `OPInfo` | `info` | `OPContact` | Reference contact from Info to Contact [0..1].|
| `license` | `OPInfo` | `info` | `OPLicense` | Reference license from Info to License [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Attribute description from Info [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `termsOfService` | `String` | nil | Attribute termsOfService from Info [1]|
| `title` | `String` | nil | Attribute title from Info [1]|
| `version` | `String` | nil | Attribute version from Info [1]|

"
Class {
	#name : 'OPInfo',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #info',
		'#contact => FMOne type: #OPContact opposite: #info',
		'#description => FMProperty',
		'#license => FMOne type: #OPLicense opposite: #info',
		'#openApi => FMOne type: #OPOpenApi opposite: #info',
		'#termsOfService => FMProperty',
		'#title => FMProperty',
		'#version => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPInfo class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Info super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPInfo >> api [
	"Relation named: #api type: #OPApi opposite: #info"

	<ignoreForCoverage>
	<generated>
	<container>
	^ api
]

{ #category : 'accessing' }
OPInfo >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPInfo >> contact [
	"Relation named: #contact type: #OPContact opposite: #info"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference contact from Info to Contact [0..1].'>
	^ contact
]

{ #category : 'accessing' }
OPInfo >> contact: anObject [

	<ignoreForCoverage>
	<generated>
	contact := anObject
]

{ #category : 'accessing' }
OPInfo >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from Info [1]'>
	^ description
]

{ #category : 'accessing' }
OPInfo >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPInfo >> license [
	"Relation named: #license type: #OPLicense opposite: #info"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference license from Info to License [0..1].'>
	^ license
]

{ #category : 'accessing' }
OPInfo >> license: anObject [

	<ignoreForCoverage>
	<generated>
	license := anObject
]

{ #category : 'accessing' }
OPInfo >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #info"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference openApi from Info to OpenApi [0..1].'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPInfo >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPInfo >> termsOfService [

	<FMProperty: #termsOfService type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute termsOfService from Info [1]'>
	^ termsOfService
]

{ #category : 'accessing' }
OPInfo >> termsOfService: anObject [
	<ignoreForCoverage>
	<generated>
	termsOfService := anObject
]

{ #category : 'accessing' }
OPInfo >> title [

	<FMProperty: #title type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute title from Info [1]'>
	^ title
]

{ #category : 'accessing' }
OPInfo >> title: anObject [
	<ignoreForCoverage>
	<generated>
	title := anObject
]

{ #category : 'accessing' }
OPInfo >> version [

	<FMProperty: #version type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute version from Info [1]'>
	^ version
]

{ #category : 'accessing' }
OPInfo >> version: anObject [
	<ignoreForCoverage>
	<generated>
	version := anObject
]
