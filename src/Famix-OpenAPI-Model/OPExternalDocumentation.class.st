"
A reference to external documentation (OpenAPI External Documentation Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocsContainer` | `OPExternalDocumentation` | `externalDocs` | `OPExternalDocsContainer` | The operation, schema or tag the external documentation belongs to.|
| `openApi` | `OPExternalDocumentation` | `externalDocs` | `OPOpenApi` | The document the external documentation belongs to.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the external documentation.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `url` | `String` | nil | URL of the external documentation.|

"
Class {
	#name : 'OPExternalDocumentation',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#externalDocsContainer => FMOne type: #OPExternalDocsContainer opposite: #externalDocs',
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
	<FMComment: 'Description of the external documentation.'>
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
	"Relation named: #externalDocsContainer type: #OPExternalDocsContainer opposite: #externalDocs"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The operation, schema or tag the external documentation belongs to.'>
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
	<FMComment: 'The document the external documentation belongs to.'>
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
	<FMComment: 'URL of the external documentation.'>
	^ url
]

{ #category : 'accessing' }
OPExternalDocumentation >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]
