"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPHeader` | `directHeaders` | `OPComponents` | Opposite reference components from Header to Components [0..1], when the object is a reusable one.|
| `encoding` | `OPHeader` | `headers` | `OPEncoding` | Opposite reference encoding from Header to Encoding [0..1].|
| `response` | `OPHeader` | `headers` | `OPResponse` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPArrayContainer` | `arrayContainer` | `OPItemsDefinition` | Reference items from ArrayContainer to ItemsDefinition [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPHeader` | `usedByHeaders` | `OPSchema` | Reference schema from Header to Schema [0..1].|
| `usedByHeaderEntries` | `OPHeader` | `value` | `OPHeaderEntry` | HeaderEntry entries whose value is this Header [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `collectionFormat` | `String` | nil | Attribute collectionFormat from ArrayContainer [1]|
| `default` | `String` | nil | Attribute default from JSONSchemaSubset [1]|
| `deprecated` | `Boolean` | nil | Whether the header is deprecated [1].|
| `description` | `String` | nil | Attribute description from JSONSchemaSubset [1]|
| `enum` | `Object` | nil | Attribute enum from JSONSchemaSubset [*]|
| `exclusiveMaximum` | `Boolean` | nil | Attribute exclusiveMaximum from JSONSchemaSubset [1]|
| `exclusiveMinimum` | `Boolean` | nil | Attribute exclusiveMinimum from JSONSchemaSubset [1]|
| `explode` | `Boolean` | nil | Whether array and object values are exploded [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `format` | `String` | nil | Attribute format from JSONSchemaSubset [1]|
| `maxItems` | `Number` | nil | Attribute maxItems from JSONSchemaSubset [1]|
| `maxLength` | `Number` | nil | Attribute maxLength from JSONSchemaSubset [1]|
| `maximum` | `Number` | nil | Attribute maximum from JSONSchemaSubset [1]|
| `minItems` | `Number` | nil | Attribute minItems from JSONSchemaSubset [1]|
| `minLength` | `Number` | nil | Attribute minLength from JSONSchemaSubset [1]|
| `minimum` | `Number` | nil | Attribute minimum from JSONSchemaSubset [1]|
| `multipleOf` | `Number` | nil | Attribute multipleOf from JSONSchemaSubset [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `pattern` | `String` | nil | Attribute pattern from JSONSchemaSubset [1]|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `required` | `Boolean` | nil | Whether the header is mandatory [1].|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `style` | `String` | nil | Serialization style of the header value [1].|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|

"
Class {
	#name : 'OPHeader',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPArrayContainer + OPCanonicalNode + OPJSONSchemaSubset + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPArrayContainer classTrait + OPCanonicalNode classTrait + OPJSONSchemaSubset classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #directHeaders',
		'#deprecated => FMProperty',
		'#encoding => FMOne type: #OPEncoding opposite: #headers',
		'#explode => FMProperty',
		'#required => FMProperty',
		'#response => FMOne type: #OPResponse opposite: #headers',
		'#schema => FMOne type: #OPSchema opposite: #usedByHeaders',
		'#style => FMProperty',
		'#usedByHeaderEntries => FMMany type: #OPHeaderEntry opposite: #value'
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
OPHeader >> addUsedByHeaderEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByHeaderEntries add: anObject
]

{ #category : 'accessing' }
OPHeader >> components [
	"Relation named: #components type: #OPComponents opposite: #directHeaders"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from Header to Components [0..1], when the object is a reusable one.'>
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
	<FMComment: 'Whether the header is deprecated [1].'>
	^ deprecated
]

{ #category : 'accessing' }
OPHeader >> deprecated: anObject [
	<ignoreForCoverage>
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPHeader >> encoding [
	"Relation named: #encoding type: #OPEncoding opposite: #headers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference encoding from Header to Encoding [0..1].'>
	<container>
	^ encoding
]

{ #category : 'accessing' }
OPHeader >> encoding: anObject [

	<ignoreForCoverage>
	<generated>
	encoding := anObject
]

{ #category : 'accessing' }
OPHeader >> explode [

	<FMProperty: #explode type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether array and object values are exploded [1].'>
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
	<FMComment: 'Whether the header is mandatory [1].'>
	^ required
]

{ #category : 'accessing' }
OPHeader >> required: anObject [
	<ignoreForCoverage>
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPHeader >> response [
	"Relation named: #response type: #OPResponse opposite: #headers"

	<ignoreForCoverage>
	<generated>
	<container>
	^ response
]

{ #category : 'accessing' }
OPHeader >> response: anObject [

	<ignoreForCoverage>
	<generated>
	response := anObject
]

{ #category : 'accessing' }
OPHeader >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByHeaders"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference schema from Header to Schema [0..1].'>
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
	<FMComment: 'Serialization style of the header value [1].'>
	^ style
]

{ #category : 'accessing' }
OPHeader >> style: anObject [
	<ignoreForCoverage>
	<generated>
	style := anObject
]

{ #category : 'accessing' }
OPHeader >> usedByHeaderEntries [
	"Relation named: #usedByHeaderEntries type: #OPHeaderEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'HeaderEntry entries whose value is this Header [0..*].'>
	^ usedByHeaderEntries
]

{ #category : 'accessing' }
OPHeader >> usedByHeaderEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByHeaderEntries value: anObject
]
