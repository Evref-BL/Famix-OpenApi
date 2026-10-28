"
A tag declared by the document to group operations (OpenAPI Tag Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `openApi` | `OPTag` | `tags` | `OPOpenApi` | The document declaring the tag.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | External documentation of the entity.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the tag.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPTag',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPExternalDocsContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPExternalDocsContainer classTrait + OPSourceText classTrait',
	#instVars : [
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
OPTag >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the tag.'>
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
	<FMComment: 'The document declaring the tag.'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPTag >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]
