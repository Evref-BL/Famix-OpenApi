"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `containedCollections` | `OPParameter` | `parameters` | `OPContainedCollections` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPArrayContainer` | `arrayContainer` | `OPItemsDefinition` | Reference items from ArrayContainer to ItemsDefinition [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `declaringContext` | `OPParameter` | `parameter` | `OPParameterContainer` | Reference declaringContext from Parameter to ParameterContainer [0..1].|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `schema` | `OPParameter` | `usedByParameters` | `OPSchema` | Reference schema from Parameter to Schema [0..1].|
| `usedByOperations` | `OPParameter` | `parameters` | `OPOperation` | Operations using this Parameter [0..*].|
| `usedByParameterEntries` | `OPParameter` | `value` | `OPParameterEntry` | ParameterEntry entries whose value is this Parameter [0..*].|
| `usedByPaths` | `OPParameter` | `parameters` | `OPPath` | Paths using this Parameter [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `allowEmptyValue` | `Boolean` | nil | Attribute allowEmptyValue from Parameter [1]|
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
		'#allowEmptyValue => FMProperty',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #parameters',
		'#declaringContext => FMOne type: #OPParameterContainer opposite: #parameter',
		'#example => FMProperty',
		'#location => FMProperty',
		'#required => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #usedByParameters',
		'#usedByOperations => FMMany type: #OPOperation opposite: #parameters',
		'#usedByParameterEntries => FMMany type: #OPParameterEntry opposite: #value',
		'#usedByPaths => FMMany type: #OPPath opposite: #parameters'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPParameter class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Parameter super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPParameter >> addUsedByOperation: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByOperations add: anObject
]

{ #category : 'adding' }
OPParameter >> addUsedByParameterEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByParameterEntries add: anObject
]

{ #category : 'adding' }
OPParameter >> addUsedByPath: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByPaths add: anObject
]

{ #category : 'accessing' }
OPParameter >> allowEmptyValue [

	<FMProperty: #allowEmptyValue type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute allowEmptyValue from Parameter [1]'>
	^ allowEmptyValue
]

{ #category : 'accessing' }
OPParameter >> allowEmptyValue: anObject [
	<ignoreForCoverage>
	<generated>
	allowEmptyValue := anObject
]

{ #category : 'accessing' }
OPParameter >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #parameters"

	<ignoreForCoverage>
	<generated>
	<container>
	^ containedCollections
]

{ #category : 'accessing' }
OPParameter >> containedCollections: anObject [

	<ignoreForCoverage>
	<generated>
	containedCollections := anObject
]

{ #category : 'accessing' }
OPParameter >> declaringContext [
	"Relation named: #declaringContext type: #OPParameterContainer opposite: #parameter"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference declaringContext from Parameter to ParameterContainer [0..1].'>
	^ declaringContext
]

{ #category : 'accessing' }
OPParameter >> declaringContext: anObject [

	<ignoreForCoverage>
	<generated>
	declaringContext := anObject
]

{ #category : 'accessing' }
OPParameter >> example [

	<FMProperty: #example type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute example from Parameter [1]'>
	^ example
]

{ #category : 'accessing' }
OPParameter >> example: anObject [
	<ignoreForCoverage>
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPParameter >> location [

	<FMProperty: #location type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute location from Parameter [1]'>
	^ location
]

{ #category : 'accessing' }
OPParameter >> location: anObject [
	<ignoreForCoverage>
	<generated>
	location := anObject
]

{ #category : 'accessing' }
OPParameter >> required [

	<FMProperty: #required type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute required from Parameter [1]'>
	^ required
]

{ #category : 'accessing' }
OPParameter >> required: anObject [
	<ignoreForCoverage>
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPParameter >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByParameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference schema from Parameter to Schema [0..1].'>
	^ schema
]

{ #category : 'accessing' }
OPParameter >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPParameter >> usedByOperations [
	"Relation named: #usedByOperations type: #OPOperation opposite: #parameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Operations using this Parameter [0..*].'>
	^ usedByOperations
]

{ #category : 'accessing' }
OPParameter >> usedByOperations: anObject [

	<ignoreForCoverage>
	<generated>
	usedByOperations value: anObject
]

{ #category : 'accessing' }
OPParameter >> usedByParameterEntries [
	"Relation named: #usedByParameterEntries type: #OPParameterEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'ParameterEntry entries whose value is this Parameter [0..*].'>
	^ usedByParameterEntries
]

{ #category : 'accessing' }
OPParameter >> usedByParameterEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByParameterEntries value: anObject
]

{ #category : 'accessing' }
OPParameter >> usedByPaths [
	"Relation named: #usedByPaths type: #OPPath opposite: #parameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Paths using this Parameter [0..*].'>
	^ usedByPaths
]

{ #category : 'accessing' }
OPParameter >> usedByPaths: anObject [

	<ignoreForCoverage>
	<generated>
	usedByPaths value: anObject
]
