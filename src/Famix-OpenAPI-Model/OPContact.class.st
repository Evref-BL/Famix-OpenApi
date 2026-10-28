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
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `email` | `String` | nil | Attribute email from Contact [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `url` | `String` | nil | Attribute url from Contact [1]|

"
Class {
	#name : 'OPContact',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#email => FMProperty',
		'#info => FMOne type: #OPInfo opposite: #contact',
		'#url => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPContact class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Contact super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPContact >> email [

	<FMProperty: #email type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute email from Contact [1]'>
	^ email
]

{ #category : 'accessing' }
OPContact >> email: anObject [
	<ignoreForCoverage>
	<generated>
	email := anObject
]

{ #category : 'accessing' }
OPContact >> info [
	"Relation named: #info type: #OPInfo opposite: #contact"

	<ignoreForCoverage>
	<generated>
	<container>
	^ info
]

{ #category : 'accessing' }
OPContact >> info: anObject [

	<ignoreForCoverage>
	<generated>
	info := anObject
]

{ #category : 'accessing' }
OPContact >> url [

	<FMProperty: #url type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute url from Contact [1]'>
	^ url
]

{ #category : 'accessing' }
OPContact >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]
