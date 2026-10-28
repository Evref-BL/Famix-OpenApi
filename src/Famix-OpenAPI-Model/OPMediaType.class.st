"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contentOwner` | `OPMediaType` | `directContent` | `OPContentContainer` | Opposite reference contentOwner from MediaType to ContentContainer [0..1]: the response, request body or parameter that declares the media type.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `directExamples` | `OPMediaType` | `mediaType` | `OPExample` | Reference directExamples from MediaType to Example [0..*]: examples of the media type (provisional name of examples).|
| `encodings` | `OPMediaType` | `mediaType` | `OPEncoding` | Reference encodings from MediaType to Encoding [0..*]: serialization rules of the schema properties.|
| `examples` | `OPMediaType` | `mediaType` | `OPExampleEntry` | Reference examples from MediaType to ExampleEntry [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPMediaType` | `usedByMediaTypes` | `OPSchema` | Reference schema from MediaType to Schema [0..1].|
| `usedByMediaTypeEntries` | `OPMediaType` | `value` | `OPMediaTypeEntry` | MediaTypeEntry entries whose value is this MediaType [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `example` | `Object` | nil | Attribute example from MediaType [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `mediaType` | `String` | nil | Media type (MIME type) described, for example application/json [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPMediaType',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#contentOwner => FMOne type: #OPContentContainer opposite: #directContent',
		'#directExamples => FMMany type: #OPExample opposite: #mediaType',
		'#encodings => FMMany type: #OPEncoding opposite: #mediaType',
		'#example => FMProperty',
		'#examples => FMMany type: #OPExampleEntry opposite: #mediaType',
		'#mediaType => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #usedByMediaTypes',
		'#usedByMediaTypeEntries => FMMany type: #OPMediaTypeEntry opposite: #value'
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
OPMediaType >> addDirectExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directExamples add: anObject
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

{ #category : 'adding' }
OPMediaType >> addUsedByMediaTypeEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByMediaTypeEntries add: anObject
]

{ #category : 'accessing' }
OPMediaType >> contentOwner [
	"Relation named: #contentOwner type: #OPContentContainer opposite: #directContent"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference contentOwner from MediaType to ContentContainer [0..1]: the response, request body or parameter that declares the media type.'>
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
OPMediaType >> directExamples [
	"Relation named: #directExamples type: #OPExample opposite: #mediaType"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directExamples from MediaType to Example [0..*]: examples of the media type (provisional name of examples).'>
	^ directExamples
]

{ #category : 'accessing' }
OPMediaType >> directExamples: anObject [

	<ignoreForCoverage>
	<generated>
	directExamples value: anObject
]

{ #category : 'accessing' }
OPMediaType >> encodings [
	"Relation named: #encodings type: #OPEncoding opposite: #mediaType"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference encodings from MediaType to Encoding [0..*]: serialization rules of the schema properties.'>
	^ encodings
]

{ #category : 'accessing' }
OPMediaType >> encodings: anObject [

	<ignoreForCoverage>
	<generated>
	encodings value: anObject
]

{ #category : 'accessing' }
OPMediaType >> example [

	<FMProperty: #example type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute example from MediaType [1]'>
	^ example
]

{ #category : 'accessing' }
OPMediaType >> example: anObject [
	<ignoreForCoverage>
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPMediaType >> examples [
	"Relation named: #examples type: #OPExampleEntry opposite: #mediaType"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference examples from MediaType to ExampleEntry [0..*].'>
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
	<FMComment: 'Media type (MIME type) described, for example application/json [1].'>
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
	<FMComment: 'Reference schema from MediaType to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPMediaType >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPMediaType >> usedByMediaTypeEntries [
	"Relation named: #usedByMediaTypeEntries type: #OPMediaTypeEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'MediaTypeEntry entries whose value is this MediaType [0..*].'>
	^ usedByMediaTypeEntries
]

{ #category : 'accessing' }
OPMediaType >> usedByMediaTypeEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByMediaTypeEntries value: anObject
]
