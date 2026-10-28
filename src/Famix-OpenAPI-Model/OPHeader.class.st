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
| `schema` | `OPHeader` | `usedByHeaders` | `OPSchema` | Reference schema from Header to Schema [0..1].|
| `usedByHeaderEntries` | `OPHeader` | `value` | `OPHeaderEntry` | HeaderEntry entries whose value is this Header [0..*].|


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
		'#schema => FMOne type: #OPSchema opposite: #usedByHeaders',
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
