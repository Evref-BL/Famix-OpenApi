"
The description of a payload for one media type, such as application/json (OpenAPI Media Type Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contentOwner` | `OPMediaType` | `content` | `OPContentContainer` | The response, request body or parameter declaring the media type.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `encodings` | `OPMediaType` | `mediaType` | `OPEncoding` | Serialization rules of the schema properties.|
| `examples` | `OPMediaType` | `mediaType` | `OPExample` | Examples of the media type.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPMediaType` | `usedByMediaTypes` | `OPSchema` | Schema of the payload.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `mediaType` | `String` | nil | Media type (MIME type) described, for example application/json.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPMediaType',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#contentOwner => FMOne type: #OPContentContainer opposite: #content',
		'#encodings => FMMany type: #OPEncoding opposite: #mediaType',
		'#examples => FMMany type: #OPExample opposite: #mediaType',
		'#mediaType => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #usedByMediaTypes'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPMediaType class >> annotation [

	<ignoreForCoverage>
	<FMClass: #MediaType super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPMediaType >> addEncoding: anObject [

	<ignoreForCoverage>
	<generated>
	^ self encodings add: anObject
]

{ #category : 'adding' }
OPMediaType >> addExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self examples add: anObject
]

{ #category : 'accessing' }
OPMediaType >> contentOwner [
	"Relation named: #contentOwner type: #OPContentContainer opposite: #content"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The response, request body or parameter declaring the media type.'>
	<container>
	^ contentOwner
]

{ #category : 'accessing' }
OPMediaType >> contentOwner: anObject [

	<ignoreForCoverage>
	<generated>
	contentOwner := anObject
]

{ #category : 'accessing' }
OPMediaType >> encodings [
	"Relation named: #encodings type: #OPEncoding opposite: #mediaType"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Serialization rules of the schema properties.'>
	^ encodings
]

{ #category : 'accessing' }
OPMediaType >> encodings: anObject [

	<ignoreForCoverage>
	<generated>
	encodings value: anObject
]

{ #category : 'accessing' }
OPMediaType >> examples [
	"Relation named: #examples type: #OPExample opposite: #mediaType"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Examples of the media type.'>
	^ examples
]

{ #category : 'accessing' }
OPMediaType >> examples: anObject [

	<ignoreForCoverage>
	<generated>
	examples value: anObject
]

{ #category : 'accessing' }
OPMediaType >> mediaType [

	<FMProperty: #mediaType type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Media type (MIME type) described, for example application/json.'>
	^ mediaType
]

{ #category : 'accessing' }
OPMediaType >> mediaType: anObject [
	<ignoreForCoverage>
	<generated>
	mediaType := anObject
]

{ #category : 'accessing' }
OPMediaType >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByMediaTypes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schema of the payload.'>
	^ schema
]

{ #category : 'accessing' }
OPMediaType >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]
