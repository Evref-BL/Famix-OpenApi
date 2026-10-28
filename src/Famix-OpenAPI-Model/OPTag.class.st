"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPTag` | `tags` | `OPApi` | Opposite reference api from Tag to API [0..1].|
| `openApi` | `OPTag` | `tags` | `OPOpenApi` | Opposite reference openApi from Tag to OpenApi [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `externalDocumentation` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Attribute description from Tag [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPTag',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPExternalDocsContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPExternalDocsContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #tags',
		'#description => FMProperty',
		'#openApi => FMOne type: #OPOpenApi opposite: #tags'
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

{ #category : 'accessing' }
OPTag >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #tags"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference openApi from Tag to OpenApi [0..1].'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPTag >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]
