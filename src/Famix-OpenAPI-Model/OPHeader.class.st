"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `response` | `OPHeader` | `headers` | `OPResponse` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPArrayContainer` | `arrayContainer` | `OPItemsDefinition` | Reference items from ArrayContainer to ItemsDefinition [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `headerEntry` | `OPHeader` | `value` | `OPHeaderEntry` | |
| `schema` | `OPHeader` | `header` | `OPSchema` | Reference schema from Header to Schema [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `collectionFormat` | `String` | nil | Attribute collectionFormat from ArrayContainer [1]|
| `default` | `String` | nil | Attribute default from JSONSchemaSubset [1]|
| `description` | `String` | nil | Attribute description from JSONSchemaSubset [1]|
| `enum` | `Object` | nil | Attribute enum from JSONSchemaSubset [*]|
| `exclusiveMaximum` | `Boolean` | nil | Attribute exclusiveMaximum from JSONSchemaSubset [1]|
| `exclusiveMinimum` | `Boolean` | nil | Attribute exclusiveMinimum from JSONSchemaSubset [1]|
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
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|

"
Class {
	#name : 'OPHeader',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPArrayContainer + OPJSONSchemaSubset + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPArrayContainer classTrait + OPJSONSchemaSubset classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#response => FMOne type: #OPResponse opposite: #headers',
		'#schema => FMOne type: #OPSchema opposite: #header',
		'#headerEntry => FMOne type: #OPHeaderEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPHeader class >> annotation [

	<FMClass: #Header super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPHeader >> headerEntry [
	"Relation named: #headerEntry type: #OPHeaderEntry opposite: #value"

	<generated>
	<derived>
	^ headerEntry
]

{ #category : 'accessing' }
OPHeader >> headerEntry: anObject [

	<generated>
	headerEntry := anObject
]

{ #category : 'accessing' }
OPHeader >> response [
	"Relation named: #response type: #OPResponse opposite: #headers"

	<generated>
	<container>
	^ response
]

{ #category : 'accessing' }
OPHeader >> response: anObject [

	<generated>
	response := anObject
]

{ #category : 'navigation' }
OPHeader >> responseGroup [
	<generated>
	<navigation: 'Response'>
	^ MooseSpecializedGroup with: self response
]

{ #category : 'accessing' }
OPHeader >> schema [
	"Relation named: #schema type: #OPSchema opposite: #header"

	<generated>
	<FMComment: 'Reference schema from Header to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPHeader >> schema: anObject [

	<generated>
	schema := anObject
]
