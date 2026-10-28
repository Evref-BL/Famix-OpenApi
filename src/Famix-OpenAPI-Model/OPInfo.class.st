"
Metadata of the API: title, version, description, terms of service, contact and license (OpenAPI Info Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `openApi` | `OPInfo` | `info` | `OPOpenApi` | The document the Info describes.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contact` | `OPInfo` | `info` | `OPContact` | Contact of the API.|
| `license` | `OPInfo` | `info` | `OPLicense` | License of the API.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the API.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `termsOfService` | `String` | nil | URL of the terms of service of the API.|
| `title` | `String` | nil | Title of the API.|
| `version` | `String` | nil | Version of the API (not the one of the specification).|

"
Class {
	#name : 'OPInfo',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
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
OPInfo >> contact [
	"Relation named: #contact type: #OPContact opposite: #info"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Contact of the API.'>
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
	<FMComment: 'Description of the API.'>
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
	<FMComment: 'License of the API.'>
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
	<FMComment: 'The document the Info describes.'>
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
	<FMComment: 'URL of the terms of service of the API.'>
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
	<FMComment: 'Title of the API.'>
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
	<FMComment: 'Version of the API (not the one of the specification).'>
	^ version
]

{ #category : 'accessing' }
OPInfo >> version: anObject [
	<ignoreForCoverage>
	<generated>
	version := anObject
]
