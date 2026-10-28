"
A reference to external documentation (OpenAPI External Documentation Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocsContainer` | `OPExternalDocumentation` | `externalDocumentation` | `OPExternalDocsContainer` | Opposite reference externalDocsContainer from ExternalDocumentation to ExternalDocsContainer [0..1]: the operation, schema or tag that declares the documentation.|
| `openApi` | `OPExternalDocumentation` | `externalDocs` | `OPOpenApi` | Opposite reference openApi from ExternalDocumentation to OpenApi [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Description of the external documentation [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `url` | `String` | nil | URL of the external documentation [1].|

"
Class {
	#name : 'OPExternalDocumentation',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#externalDocsContainer => FMOne type: #OPExternalDocsContainer opposite: #externalDocumentation',
		'#openApi => FMOne type: #OPOpenApi opposite: #externalDocs',
		'#url => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExternalDocumentation class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ExternalDocumentation super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPExternalDocumentation >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the external documentation [1].'>
	^ description
]

{ #category : 'accessing' }
OPExternalDocumentation >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPExternalDocumentation >> externalDocsContainer [
	"Relation named: #externalDocsContainer type: #OPExternalDocsContainer opposite: #externalDocumentation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference externalDocsContainer from ExternalDocumentation to ExternalDocsContainer [0..1]: the operation, schema or tag that declares the documentation.'>
	<container>
	^ externalDocsContainer
]

{ #category : 'accessing' }
OPExternalDocumentation >> externalDocsContainer: anObject [

	<ignoreForCoverage>
	<generated>
	externalDocsContainer := anObject
]

{ #category : 'accessing' }
OPExternalDocumentation >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #externalDocs"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference openApi from ExternalDocumentation to OpenApi [0..1].'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPExternalDocumentation >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPExternalDocumentation >> url [

	<FMProperty: #url type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL of the external documentation [1].'>
	^ url
]

{ #category : 'accessing' }
OPExternalDocumentation >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]
