"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `containedCollections` | `OPParameter` | `paramters` | `OPContainedCollections` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPArrayContainer` | `arrayContainer` | `OPItemsDefinition` | Reference items from ArrayContainer to ItemsDefinition [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `declaringContext` | `OPParameter` | `parameter` | `OPParameterContainer` | Reference declaringContext from Parameter to ParameterContainer [0..1].|
| `operation` | `OPParameter` | `parameters` | `OPOperation` | |
| `parameterEntry` | `OPParameter` | `value` | `OPParameterEntry` | |
| `path` | `OPParameter` | `parameters` | `OPPath` | |
| `schema` | `OPParameter` | `parameter` | `OPSchema` | Reference schema from Parameter to Schema [0..1].|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `allowEmplyValue` | `Boolean` | nil | Attribute allowEmplyValue from Parameter [1]|
| `collectionFormat` | `String` | nil | Attribute collectionFormat from ArrayContainer [1]|
| `default` | `String` | nil | Attribute default from JSONSchemaSubset [1]|
| `description` | `String` | nil | Attribute description from JSONSchemaSubset [1]|
| `enum` | `Object` | nil | Attribute enum from JSONSchemaSubset [*]|
| `example` | `String` | nil | Attribute example from Parameter [1]|
| `exclusiveMaximum` | `Boolean` | nil | Attribute exclusiveMaximum from JSONSchemaSubset [1]|
| `exclusiveMinimum` | `Boolean` | nil | Attribute exclusiveMinimum from JSONSchemaSubset [1]|
| `format` | `String` | nil | Attribute format from JSONSchemaSubset [1]|
| `location` | `String` | nil | Attribute location from Parameter [1]|
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
| `required` | `Boolean` | nil | Attribute required from Parameter [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|

"
Class {
	#name : 'OPParameter',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPArrayContainer + OPJSONSchemaSubset + OPReferenceable + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPArrayContainer classTrait + OPJSONSchemaSubset classTrait + OPReferenceable classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#location => FMProperty',
		'#required => FMProperty',
		'#allowEmplyValue => FMProperty',
		'#example => FMProperty',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #paramters',
		'#path => FMOne type: #OPPath opposite: #parameters',
		'#operation => FMOne type: #OPOperation opposite: #parameters',
		'#declaringContext => FMOne type: #OPParameterContainer opposite: #parameter',
		'#schema => FMOne type: #OPSchema opposite: #parameter',
		'#parameterEntry => FMOne type: #OPParameterEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPParameter class >> annotation [

	<FMClass: #Parameter super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPParameter >> allowEmplyValue [

	<FMProperty: #allowEmplyValue type: #Boolean>
	<generated>
	<FMComment: 'Attribute allowEmplyValue from Parameter [1]'>
	^ allowEmplyValue
]

{ #category : 'accessing' }
OPParameter >> allowEmplyValue: anObject [
	<generated>
	allowEmplyValue := anObject
]

{ #category : 'accessing' }
OPParameter >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #paramters"

	<generated>
	<container>
	^ containedCollections
]

{ #category : 'accessing' }
OPParameter >> containedCollections: anObject [

	<generated>
	containedCollections := anObject
]

{ #category : 'navigation' }
OPParameter >> containedCollectionsGroup [
	<generated>
	<navigation: 'ContainedCollections'>
	^ MooseSpecializedGroup with: self containedCollections
]

{ #category : 'accessing' }
OPParameter >> declaringContext [
	"Relation named: #declaringContext type: #OPParameterContainer opposite: #parameter"

	<generated>
	<FMComment: 'Reference declaringContext from Parameter to ParameterContainer [0..1].'>
	^ declaringContext
]

{ #category : 'accessing' }
OPParameter >> declaringContext: anObject [

	<generated>
	declaringContext := anObject
]

{ #category : 'accessing' }
OPParameter >> example [

	<FMProperty: #example type: #String>
	<generated>
	<FMComment: 'Attribute example from Parameter [1]'>
	^ example
]

{ #category : 'accessing' }
OPParameter >> example: anObject [
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPParameter >> location [

	<FMProperty: #location type: #String>
	<generated>
	<FMComment: 'Attribute location from Parameter [1]'>
	^ location
]

{ #category : 'accessing' }
OPParameter >> location: anObject [
	<generated>
	location := anObject
]

{ #category : 'accessing' }
OPParameter >> operation [
	"Relation named: #operation type: #OPOperation opposite: #parameters"

	<generated>
	^ operation
]

{ #category : 'accessing' }
OPParameter >> operation: anObject [

	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPParameter >> parameterEntry [
	"Relation named: #parameterEntry type: #OPParameterEntry opposite: #value"

	<generated>
	<derived>
	^ parameterEntry
]

{ #category : 'accessing' }
OPParameter >> parameterEntry: anObject [

	<generated>
	parameterEntry := anObject
]

{ #category : 'accessing' }
OPParameter >> path [
	"Relation named: #path type: #OPPath opposite: #parameters"

	<generated>
	^ path
]

{ #category : 'accessing' }
OPParameter >> path: anObject [

	<generated>
	path := anObject
]

{ #category : 'accessing' }
OPParameter >> required [

	<FMProperty: #required type: #Boolean>
	<generated>
	<FMComment: 'Attribute required from Parameter [1]'>
	^ required
]

{ #category : 'accessing' }
OPParameter >> required: anObject [
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPParameter >> schema [
	"Relation named: #schema type: #OPSchema opposite: #parameter"

	<generated>
	<FMComment: 'Reference schema from Parameter to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPParameter >> schema: anObject [

	<generated>
	schema := anObject
]
