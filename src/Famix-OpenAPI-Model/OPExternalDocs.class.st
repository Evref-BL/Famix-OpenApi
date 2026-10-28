"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocsContainer` | `OPExternalDocs` | `externalDocs` | `OPExternalDocsContainer` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | Attribute description from ExternalDocs [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `url` | `String` | nil | Attribute url from ExternalDocs [1]|

"
Class {
	#name : 'OPExternalDocs',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#url => FMProperty',
		'#externalDocsContainer => FMOne type: #OPExternalDocsContainer opposite: #externalDocs'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExternalDocs class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ExternalDocs super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPExternalDocs >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from ExternalDocs [1]'>
	^ description
]

{ #category : 'accessing' }
OPExternalDocs >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPExternalDocs >> externalDocsContainer [
	"Relation named: #externalDocsContainer type: #OPExternalDocsContainer opposite: #externalDocs"

	<ignoreForCoverage>
	<generated>
	<container>
	^ externalDocsContainer
]

{ #category : 'accessing' }
OPExternalDocs >> externalDocsContainer: anObject [

	<ignoreForCoverage>
	<generated>
	externalDocsContainer := anObject
]

{ #category : 'accessing' }
OPExternalDocs >> url [

	<FMProperty: #url type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute url from ExternalDocs [1]'>
	^ url
]

{ #category : 'accessing' }
OPExternalDocs >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]
