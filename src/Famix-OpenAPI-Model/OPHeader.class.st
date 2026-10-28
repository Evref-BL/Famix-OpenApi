"
A header of a response or of an encoding (OpenAPI Header Object). A reusable header may be shared by several responses and encodings.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPHeader` | `headers` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPHeader` | `usedByHeaders` | `OPSchema` | Schema of the header value.|
| `usedByEncodings` | `OPHeader` | `headers` | `OPEncoding` | Encodings using this header.|
| `usedByResponses` | `OPHeader` | `headers` | `OPResponse` | Responses using this header.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `deprecated` | `Boolean` | nil | Whether the header is deprecated.|
| `description` | `String` | nil | Description of the header.|
| `explode` | `Boolean` | nil | Whether array and object values are exploded.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `required` | `Boolean` | nil | Whether the header is mandatory.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `style` | `String` | nil | Serialization style of the header value.|

"
Class {
	#name : 'OPHeader',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #headers',
		'#deprecated => FMProperty',
		'#description => FMProperty',
		'#explode => FMProperty',
		'#required => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #usedByHeaders',
		'#style => FMProperty',
		'#usedByEncodings => FMMany type: #OPEncoding opposite: #headers',
		'#usedByResponses => FMMany type: #OPResponse opposite: #headers'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPHeader class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Header super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPHeader >> addUsedByEncoding: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByEncodings add: anObject
]

{ #category : 'adding' }
OPHeader >> addUsedByResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByResponses add: anObject
]

{ #category : 'accessing' }
OPHeader >> components [
	"Relation named: #components type: #OPComponents opposite: #headers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPHeader >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPHeader >> deprecated [

	<FMProperty: #deprecated type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the header is deprecated.'>
	^ deprecated
]

{ #category : 'accessing' }
OPHeader >> deprecated: anObject [
	<ignoreForCoverage>
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPHeader >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the header.'>
	^ description
]

{ #category : 'accessing' }
OPHeader >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPHeader >> explode [

	<FMProperty: #explode type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether array and object values are exploded.'>
	^ explode
]

{ #category : 'accessing' }
OPHeader >> explode: anObject [
	<ignoreForCoverage>
	<generated>
	explode := anObject
]

{ #category : 'accessing' }
OPHeader >> required [

	<FMProperty: #required type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the header is mandatory.'>
	^ required
]

{ #category : 'accessing' }
OPHeader >> required: anObject [
	<ignoreForCoverage>
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPHeader >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByHeaders"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schema of the header value.'>
	^ schema
]

{ #category : 'accessing' }
OPHeader >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPHeader >> style [

	<FMProperty: #style type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Serialization style of the header value.'>
	^ style
]

{ #category : 'accessing' }
OPHeader >> style: anObject [
	<ignoreForCoverage>
	<generated>
	style := anObject
]

{ #category : 'accessing' }
OPHeader >> usedByEncodings [
	"Relation named: #usedByEncodings type: #OPEncoding opposite: #headers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Encodings using this header.'>
	^ usedByEncodings
]

{ #category : 'accessing' }
OPHeader >> usedByEncodings: anObject [

	<ignoreForCoverage>
	<generated>
	usedByEncodings value: anObject
]

{ #category : 'accessing' }
OPHeader >> usedByResponses [
	"Relation named: #usedByResponses type: #OPResponse opposite: #headers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Responses using this header.'>
	^ usedByResponses
]

{ #category : 'accessing' }
OPHeader >> usedByResponses: anObject [

	<ignoreForCoverage>
	<generated>
	usedByResponses value: anObject
]
