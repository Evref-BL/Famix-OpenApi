"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPTag` | `tags` | `OPApi` | Opposite reference api from Tag to API [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from Tag [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPTag',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPExternalDocsContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPExternalDocsContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #tags',
		'#description => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPTag class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Tag super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPTag >> api [
	"Relation named: #api type: #OPApi opposite: #tags"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference api from Tag to API [0..1].'>
	<container>
	^ api
]

{ #category : 'accessing' }
OPTag >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPTag >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from Tag [1]'>
	^ description
]

{ #category : 'accessing' }
OPTag >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]
