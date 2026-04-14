"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `arrayContainer` | `OPItemsDefinition` | `items` | `OPArrayContainer` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPArrayContainer` | `arrayContainer` | `OPItemsDefinition` | Reference items from ArrayContainer to ItemsDefinition [0..1].|


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
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|

"
Class {
	#name : 'OPItemsDefinition',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPArrayContainer + OPJSONSchemaSubset + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPArrayContainer classTrait + OPJSONSchemaSubset classTrait + OPSourceText classTrait',
	#instVars : [
		'#arrayContainer => FMOne type: #OPArrayContainer opposite: #items'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPItemsDefinition class >> annotation [

	<FMClass: #ItemsDefinition super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPItemsDefinition >> arrayContainer [
	"Relation named: #arrayContainer type: #OPArrayContainer opposite: #items"

	<generated>
	<container>
	<derived>
	^ arrayContainer
]

{ #category : 'accessing' }
OPItemsDefinition >> arrayContainer: anObject [

	<generated>
	arrayContainer := anObject
]

{ #category : 'navigation' }
OPItemsDefinition >> arrayContainerGroup [
	<generated>
	<navigation: 'ArrayContainer'>
	^ MooseSpecializedGroup with: self arrayContainer
]
