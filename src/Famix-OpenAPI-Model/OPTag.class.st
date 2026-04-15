"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `anApi` | `OPTag` | `tags` | `OPApi` | |

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
		'#description => FMProperty',
		'#anApi => FMOne type: #OPApi opposite: #tags'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPTag class >> annotation [

	<FMClass: #Tag super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPTag >> anApi [
	"Relation named: #anApi type: #OPApi opposite: #tags"

	<generated>
	<container>
	^ anApi
]

{ #category : 'accessing' }
OPTag >> anApi: anObject [

	<generated>
	anApi := anObject
]

{ #category : 'navigation' }
OPTag >> anApiGroup [
	<generated>
	<navigation: 'AnApi'>
	^ MooseSpecializedGroup with: self anApi
]

{ #category : 'accessing' }
OPTag >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from Tag [1]'>
	^ description
]

{ #category : 'accessing' }
OPTag >> description: anObject [
	<generated>
	description := anObject
]
