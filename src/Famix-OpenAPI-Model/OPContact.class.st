"
Contact information of the API (OpenAPI Contact Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `info` | `OPContact` | `contact` | `OPInfo` | The Info declaring the contact.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `email` | `String` | nil | Email address of the contact.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `url` | `String` | nil | URL of the contact page.|

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
	<FMComment: 'Email address of the contact.'>
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
	<FMComment: 'The Info declaring the contact.'>
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
	<FMComment: 'URL of the contact page.'>
	^ url
]

{ #category : 'accessing' }
OPContact >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]
