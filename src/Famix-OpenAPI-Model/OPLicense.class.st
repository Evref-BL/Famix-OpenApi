"
License of the API (OpenAPI License Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `info` | `OPLicense` | `license` | `OPInfo` | The Info declaring the license.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `url` | `String` | nil | URL of the license text.|

"
Class {
	#name : 'OPLicense',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#info => FMOne type: #OPInfo opposite: #license',
		'#url => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPLicense class >> annotation [

	<ignoreForCoverage>
	<FMClass: #License super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPLicense >> info [
	"Relation named: #info type: #OPInfo opposite: #license"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The Info declaring the license.'>
	<container>
	^ info
]

{ #category : 'accessing' }
OPLicense >> info: anObject [

	<ignoreForCoverage>
	<generated>
	info := anObject
]

{ #category : 'accessing' }
OPLicense >> url [

	<FMProperty: #url type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL of the license text.'>
	^ url
]

{ #category : 'accessing' }
OPLicense >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]
