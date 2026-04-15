"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `containedCollections` | `OPSchema` | `schemas` | `OPContainedCollections` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `properties` | `OPSchema` | `schema` | `OPProperty` | Reference properties from Schema to Property [0..*].|
| `xml` | `OPSchema` | `schema` | `OPXMLElement` | Reference xml from Schema to XMLElement [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `additonalProperties` | `OPSchema` | `schema` | `OPSchema` | Reference additonalProperties from Schema to Schema [0..1].|
| `allOf` | `OPSchema` | `schema` | `OPSchema` | Reference allOf from Schema to Schema [0..*].|
| `declaringContext` | `OPSchema` | `schema` | `OPSchemaContainer` | Reference declaringContext from Schema to SchemaContainer [0..1].|
| `header` | `OPSchema` | `schema` | `OPHeader` | |
| `items` | `OPSchema` | `schema` | `OPSchema` | Reference items from Schema to Schema [0..1].|
| `mediaType` | `OPSchema` | `schema` | `OPMediaType` | |
| `parameter` | `OPSchema` | `schema` | `OPParameter` | |
| `response` | `OPSchema` | `schema` | `OPResponse` | |
| `schema` | `OPSchema` | `additonalProperties` | `OPSchema` | |
| `schema` | `OPSchema` | `tupleItems` | `OPSchema` | |
| `schema` | `OPSchema` | `items` | `OPSchema` | |
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `schema` | `OPSchema` | `allOf` | `OPSchema` | |
| `schemaEntry` | `OPSchema` | `value` | `OPSchemaEntry` | |
| `tupleItems` | `OPSchema` | `schema` | `OPSchema` | Reference tupleItems from Schema to Schema [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `additonalPropertiesAllowed` | `Boolean` | nil | Attribute additonalPropertiesAllowed from Schema [1]|
| `default` | `String` | nil | Attribute default from JSONSchemaSubset [1]|
| `description` | `String` | nil | Attribute description from JSONSchemaSubset [1]|
| `discriminator` | `String` | nil | Attribute discriminator from Schema [1]|
| `enum` | `Object` | nil | Attribute enum from JSONSchemaSubset [*]|
| `example` | `String` | nil | Attribute example from Schema [1]|
| `exclusiveMaximum` | `Boolean` | nil | Attribute exclusiveMaximum from JSONSchemaSubset [1]|
| `exclusiveMinimum` | `Boolean` | nil | Attribute exclusiveMinimum from JSONSchemaSubset [1]|
| `format` | `String` | nil | Attribute format from JSONSchemaSubset [1]|
| `maxItems` | `Number` | nil | Attribute maxItems from JSONSchemaSubset [1]|
| `maxLength` | `Number` | nil | Attribute maxLength from JSONSchemaSubset [1]|
| `maxProperties` | `Number` | nil | Attribute maxProperties from Schema [1]|
| `maximum` | `Number` | nil | Attribute maximum from JSONSchemaSubset [1]|
| `minItems` | `Number` | nil | Attribute minItems from JSONSchemaSubset [1]|
| `minLength` | `Number` | nil | Attribute minLength from JSONSchemaSubset [1]|
| `minProperties` | `Number` | nil | Attribute minProperties from Schema [1]|
| `minimum` | `Number` | nil | Attribute minimum from JSONSchemaSubset [1]|
| `multipleOf` | `Number` | nil | Attribute multipleOf from JSONSchemaSubset [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `pattern` | `String` | nil | Attribute pattern from JSONSchemaSubset [1]|
| `readOnly` | `Boolean` | nil | Attribute readOnly from Schema [1]|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `title` | `String` | nil | Attribute title from Schema [1]|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|

"
Class {
	#name : 'OPSchema',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPExternalDocsContainer + OPJSONSchemaSubset + OPReferenceable + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPExternalDocsContainer classTrait + OPJSONSchemaSubset classTrait + OPReferenceable classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#title => FMProperty',
		'#maxProperties => FMProperty',
		'#minProperties => FMProperty',
		'#example => FMProperty',
		'#discriminator => FMProperty',
		'#readOnly => FMProperty',
		'#additonalPropertiesAllowed => FMProperty',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #schemas',
		'#parameter => FMOne type: #OPParameter opposite: #schema',
		'#properties => FMMany type: #OPProperty opposite: #schema',
		'#allOf => FMMany type: #OPSchema opposite: #schema',
		'#schema => FMOne type: #OPSchema opposite: #allOf',
		'#items => FMOne type: #OPSchema opposite: #schema',
		'#xml => FMOne type: #OPXMLElement opposite: #schema',
		'#additonalProperties => FMOne type: #OPSchema opposite: #schema',
		'#declaringContext => FMOne type: #OPSchemaContainer opposite: #schema',
		'#tupleItems => FMMany type: #OPSchema opposite: #schema',
		'#response => FMOne type: #OPResponse opposite: #schema',
		'#header => FMOne type: #OPHeader opposite: #schema',
		'#mediaType => FMOne type: #OPMediaType opposite: #schema',
		'#schemaEntry => FMOne type: #OPSchemaEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSchema class >> annotation [

	<FMClass: #Schema super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPSchema >> addAllOf: anObject [
	<generated>
	^ self allOf add: anObject
]

{ #category : 'adding' }
OPSchema >> addProperty: anObject [
	<generated>
	^ self properties add: anObject
]

{ #category : 'adding' }
OPSchema >> addTupleItem: anObject [
	<generated>
	^ self tupleItems add: anObject
]

{ #category : 'accessing' }
OPSchema >> additonalProperties [
	"Relation named: #additonalProperties type: #OPSchema opposite: #schema"

	<generated>
	<FMComment: 'Reference additonalProperties from Schema to Schema [0..1].'>
	^ additonalProperties
]

{ #category : 'accessing' }
OPSchema >> additonalProperties: anObject [

	<generated>
	additonalProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> additonalPropertiesAllowed [

	<FMProperty: #additonalPropertiesAllowed type: #Boolean>
	<generated>
	<FMComment: 'Attribute additonalPropertiesAllowed from Schema [1]'>
	^ additonalPropertiesAllowed
]

{ #category : 'accessing' }
OPSchema >> additonalPropertiesAllowed: anObject [
	<generated>
	additonalPropertiesAllowed := anObject
]

{ #category : 'accessing' }
OPSchema >> allOf [
	"Relation named: #allOf type: #OPSchema opposite: #schema"

	<generated>
	<FMComment: 'Reference allOf from Schema to Schema [0..*].'>
	<derived>
	^ allOf
]

{ #category : 'accessing' }
OPSchema >> allOf: anObject [

	<generated>
	allOf value: anObject
]

{ #category : 'accessing' }
OPSchema >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #schemas"

	<generated>
	<container>
	^ containedCollections
]

{ #category : 'accessing' }
OPSchema >> containedCollections: anObject [

	<generated>
	containedCollections := anObject
]

{ #category : 'navigation' }
OPSchema >> containedCollectionsGroup [
	<generated>
	<navigation: 'ContainedCollections'>
	^ MooseSpecializedGroup with: self containedCollections
]

{ #category : 'accessing' }
OPSchema >> declaringContext [
	"Relation named: #declaringContext type: #OPSchemaContainer opposite: #schema"

	<generated>
	<FMComment: 'Reference declaringContext from Schema to SchemaContainer [0..1].'>
	^ declaringContext
]

{ #category : 'accessing' }
OPSchema >> declaringContext: anObject [

	<generated>
	declaringContext := anObject
]

{ #category : 'accessing' }
OPSchema >> discriminator [

	<FMProperty: #discriminator type: #String>
	<generated>
	<FMComment: 'Attribute discriminator from Schema [1]'>
	^ discriminator
]

{ #category : 'accessing' }
OPSchema >> discriminator: anObject [
	<generated>
	discriminator := anObject
]

{ #category : 'accessing' }
OPSchema >> example [

	<FMProperty: #example type: #String>
	<generated>
	<FMComment: 'Attribute example from Schema [1]'>
	^ example
]

{ #category : 'accessing' }
OPSchema >> example: anObject [
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPSchema >> header [
	"Relation named: #header type: #OPHeader opposite: #schema"

	<generated>
	<derived>
	^ header
]

{ #category : 'accessing' }
OPSchema >> header: anObject [

	<generated>
	header := anObject
]

{ #category : 'accessing' }
OPSchema >> items [
	"Relation named: #items type: #OPSchema opposite: #schema"

	<generated>
	<FMComment: 'Reference items from Schema to Schema [0..1].'>
	^ items
]

{ #category : 'accessing' }
OPSchema >> items: anObject [

	<generated>
	items := anObject
]

{ #category : 'accessing' }
OPSchema >> maxProperties [

	<FMProperty: #maxProperties type: #Number>
	<generated>
	<FMComment: 'Attribute maxProperties from Schema [1]'>
	^ maxProperties
]

{ #category : 'accessing' }
OPSchema >> maxProperties: anObject [
	<generated>
	maxProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> mediaType [
	"Relation named: #mediaType type: #OPMediaType opposite: #schema"

	<generated>
	<derived>
	^ mediaType
]

{ #category : 'accessing' }
OPSchema >> mediaType: anObject [

	<generated>
	mediaType := anObject
]

{ #category : 'accessing' }
OPSchema >> minProperties [

	<FMProperty: #minProperties type: #Number>
	<generated>
	<FMComment: 'Attribute minProperties from Schema [1]'>
	^ minProperties
]

{ #category : 'accessing' }
OPSchema >> minProperties: anObject [
	<generated>
	minProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> parameter [
	"Relation named: #parameter type: #OPParameter opposite: #schema"

	<generated>
	<derived>
	^ parameter
]

{ #category : 'accessing' }
OPSchema >> parameter: anObject [

	<generated>
	parameter := anObject
]

{ #category : 'accessing' }
OPSchema >> properties [
	"Relation named: #properties type: #OPProperty opposite: #schema"

	<generated>
	<FMComment: 'Reference properties from Schema to Property [0..*].'>
	<derived>
	^ properties
]

{ #category : 'accessing' }
OPSchema >> properties: anObject [

	<generated>
	properties value: anObject
]

{ #category : 'navigation' }
OPSchema >> propertiesGroup [
	<generated>
	<navigation: 'Properties'>
	^ MooseSpecializedGroup withAll: self properties asSet
]

{ #category : 'accessing' }
OPSchema >> readOnly [

	<FMProperty: #readOnly type: #Boolean>
	<generated>
	<FMComment: 'Attribute readOnly from Schema [1]'>
	^ readOnly
]

{ #category : 'accessing' }
OPSchema >> readOnly: anObject [
	<generated>
	readOnly := anObject
]

{ #category : 'accessing' }
OPSchema >> response [
	"Relation named: #response type: #OPResponse opposite: #schema"

	<generated>
	<derived>
	^ response
]

{ #category : 'accessing' }
OPSchema >> response: anObject [

	<generated>
	response := anObject
]

{ #category : 'accessing' }
OPSchema >> schema [
	"Relation named: #schema type: #OPSchema opposite: #allOf"

	<generated>
	^ schema
]

{ #category : 'accessing' }
OPSchema >> schema: anObject [

	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPSchema >> schemaEntry [
	"Relation named: #schemaEntry type: #OPSchemaEntry opposite: #value"

	<generated>
	<derived>
	^ schemaEntry
]

{ #category : 'accessing' }
OPSchema >> schemaEntry: anObject [

	<generated>
	schemaEntry := anObject
]

{ #category : 'accessing' }
OPSchema >> title [

	<FMProperty: #title type: #String>
	<generated>
	<FMComment: 'Attribute title from Schema [1]'>
	^ title
]

{ #category : 'accessing' }
OPSchema >> title: anObject [
	<generated>
	title := anObject
]

{ #category : 'accessing' }
OPSchema >> tupleItems [
	"Relation named: #tupleItems type: #OPSchema opposite: #schema"

	<generated>
	<FMComment: 'Reference tupleItems from Schema to Schema [0..*].'>
	<derived>
	^ tupleItems
]

{ #category : 'accessing' }
OPSchema >> tupleItems: anObject [

	<generated>
	tupleItems value: anObject
]

{ #category : 'accessing' }
OPSchema >> xml [
	"Relation named: #xml type: #OPXMLElement opposite: #schema"

	<generated>
	<FMComment: 'Reference xml from Schema to XMLElement [0..1].'>
	^ xml
]

{ #category : 'accessing' }
OPSchema >> xml: anObject [

	<generated>
	xml := anObject
]

{ #category : 'navigation' }
OPSchema >> xmlGroup [
	<generated>
	<navigation: 'Xml'>
	^ MooseSpecializedGroup with: self xml
]
