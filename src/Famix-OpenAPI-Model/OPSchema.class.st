"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPSchema` | `directSchemas` | `OPComponents` | Opposite reference components from Schema to Components [0..1], when the object is a reusable one.|
| `containedCollections` | `OPSchema` | `schemas` | `OPContainedCollections` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `discriminatorEntity` | `OPSchema` | `schema` | `OPDiscriminator` | Reference discriminatorEntity from Schema to Discriminator [0..1].|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `externalDocumentation` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.|
| `properties` | `OPSchema` | `schema` | `OPProperty` | Reference properties from Schema to Property [0..*].|
| `xml` | `OPSchema` | `schema` | `OPXMLElement` | Reference xml from Schema to XMLElement [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `additionalProperties` | `OPSchema` | `usedAsAdditionalPropertiesBy` | `OPSchema` | Reference additionalProperties from Schema to Schema [0..1].|
| `allOf` | `OPSchema` | `usedAsAllOfBy` | `OPSchema` | Reference allOf from Schema to Schema [0..*].|
| `anyOf` | `OPSchema` | `usedAsAnyOfBy` | `OPSchema` | Reference anyOf from Schema to Schema [0..*]: alternatives of which at least one must match.|
| `declaringContext` | `OPSchema` | `schema` | `OPSchemaContainer` | Reference declaringContext from Schema to SchemaContainer [0..1].|
| `items` | `OPSchema` | `usedAsItemsBy` | `OPSchema` | Reference items from Schema to Schema [0..1].|
| `not` | `OPSchema` | `usedAsNotBy` | `OPSchema` | Reference not from Schema to Schema [0..1]: schema that must not match.|
| `oneOf` | `OPSchema` | `usedAsOneOfBy` | `OPSchema` | Reference oneOf from Schema to Schema [0..*]: alternatives of which exactly one must match.|
| `prefixItems` | `OPSchema` | `usedAsPrefixItemsBy` | `OPSchema` | Reference prefixItems from Schema to Schema [0..*]: schemas of the first array items, in order.|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `tupleItems` | `OPSchema` | `usedAsTupleItemsBy` | `OPSchema` | Reference tupleItems from Schema to Schema [0..*].|
| `usedAsAdditionalPropertiesBy` | `OPSchema` | `additionalProperties` | `OPSchema` | Schemas having this Schema as their additionalProperties [0..*].|
| `usedAsAllOfBy` | `OPSchema` | `allOf` | `OPSchema` | Schemas having this Schema in their allOf [0..*].|
| `usedAsAnyOfBy` | `OPSchema` | `anyOf` | `OPSchema` | Schemas having this Schema in their anyOf [0..*].|
| `usedAsItemsBy` | `OPSchema` | `items` | `OPSchema` | Schemas having this Schema as their items [0..*].|
| `usedAsNotBy` | `OPSchema` | `not` | `OPSchema` | Schemas having this Schema as their not [0..*].|
| `usedAsOneOfBy` | `OPSchema` | `oneOf` | `OPSchema` | Schemas having this Schema in their oneOf [0..*].|
| `usedAsPrefixItemsBy` | `OPSchema` | `prefixItems` | `OPSchema` | Schemas having this Schema in their prefixItems [0..*].|
| `usedAsPropertyValueBy` | `OPSchema` | `valueSchema` | `OPProperty` | Properties whose value schema is this Schema [0..*].|
| `usedAsTupleItemsBy` | `OPSchema` | `tupleItems` | `OPSchema` | Schemas having this Schema in their tupleItems [0..*].|
| `usedByDiscriminatorMappings` | `OPSchema` | `schema` | `OPDiscriminatorMapping` | Discriminator mappings selecting this Schema [0..*].|
| `usedByHeaders` | `OPSchema` | `schema` | `OPHeader` | Headers whose schema is this Schema [0..*].|
| `usedByMediaTypes` | `OPSchema` | `schema` | `OPMediaType` | Media types whose schema is this Schema [0..*].|
| `usedByParameters` | `OPSchema` | `schema` | `OPParameter` | Parameters whose schema is this Schema [0..*].|
| `usedByResponses` | `OPSchema` | `schema` | `OPResponse` | Responses whose schema is this Schema [0..*].|
| `usedBySchemaEntries` | `OPSchema` | `value` | `OPSchemaEntry` | SchemaEntry entries whose value is this Schema [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `additionalPropertiesAllowed` | `Boolean` | nil | Attribute additionalPropertiesAllowed from Schema [1]|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `constValue` | `String` | nil | The only allowed value of the schema (const), as JSON text [1].|
| `default` | `String` | nil | Attribute default from JSONSchemaSubset [1]|
| `defaultValue` | `String` | nil | Default value of the schema, as JSON text [1].|
| `deprecated` | `Boolean` | nil | Whether the schema is deprecated [1].|
| `description` | `String` | nil | Attribute description from JSONSchemaSubset [1]|
| `discriminator` | `String` | nil | Attribute discriminator from Schema [1]|
| `enum` | `Object` | nil | Attribute enum from JSONSchemaSubset [*]|
| `enumValues` | `String` | nil | Allowed values of the schema, as a JSON array text [1].|
| `example` | `String` | nil | Attribute example from Schema [1]|
| `exampleValue` | `String` | nil | Example value of the schema, as JSON text [1].|
| `exclusiveMaximum` | `Boolean` | nil | Attribute exclusiveMaximum from JSONSchemaSubset [1]|
| `exclusiveMinimum` | `Boolean` | nil | Attribute exclusiveMinimum from JSONSchemaSubset [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `format` | `String` | nil | Attribute format from JSONSchemaSubset [1]|
| `isNullable` | `Boolean` | nil | Whether null is an accepted value (nullable in 3.0, null among the types in 3.1) [1].|
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
| `requiredProperties` | `String` | #() | Names of the properties that are mandatory in an instance of the schema [*] (strings).|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `title` | `String` | nil | Attribute title from Schema [1]|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `types` | `String` | #() | JSON Schema types of the schema [*] (strings such as string, integer, null); several values for a 3.1 type array.|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|
| `writeOnly` | `Boolean` | nil | Whether the value is only sent to the server, never returned [1].|

"
Class {
	#name : 'OPSchema',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPExternalDocsContainer + OPJSONSchemaSubset + OPReferenceable + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPExternalDocsContainer classTrait + OPJSONSchemaSubset classTrait + OPReferenceable classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#additionalProperties => FMOne type: #OPSchema opposite: #usedAsAdditionalPropertiesBy',
		'#additionalPropertiesAllowed => FMProperty',
		'#allOf => FMMany type: #OPSchema opposite: #usedAsAllOfBy',
		'#anyOf => FMMany type: #OPSchema opposite: #usedAsAnyOfBy',
		'#components => FMOne type: #OPComponents opposite: #directSchemas',
		'#constValue => FMProperty',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #schemas',
		'#declaringContext => FMOne type: #OPSchemaContainer opposite: #schema',
		'#defaultValue => FMProperty',
		'#deprecated => FMProperty',
		'#discriminator => FMProperty',
		'#discriminatorEntity => FMOne type: #OPDiscriminator opposite: #schema',
		'#enumValues => FMProperty',
		'#example => FMProperty',
		'#exampleValue => FMProperty',
		'#isNullable => FMProperty',
		'#items => FMOne type: #OPSchema opposite: #usedAsItemsBy',
		'#maxProperties => FMProperty',
		'#minProperties => FMProperty',
		'#not => FMOne type: #OPSchema opposite: #usedAsNotBy',
		'#oneOf => FMMany type: #OPSchema opposite: #usedAsOneOfBy',
		'#prefixItems => FMMany type: #OPSchema opposite: #usedAsPrefixItemsBy',
		'#properties => FMMany type: #OPProperty opposite: #schema',
		'#readOnly => FMProperty',
		'#requiredProperties => FMProperty defaultValue: #()',
		'#title => FMProperty',
		'#tupleItems => FMMany type: #OPSchema opposite: #usedAsTupleItemsBy',
		'#types => FMProperty defaultValue: #()',
		'#usedAsAdditionalPropertiesBy => FMMany type: #OPSchema opposite: #additionalProperties',
		'#usedAsAllOfBy => FMMany type: #OPSchema opposite: #allOf',
		'#usedAsAnyOfBy => FMMany type: #OPSchema opposite: #anyOf',
		'#usedAsItemsBy => FMMany type: #OPSchema opposite: #items',
		'#usedAsNotBy => FMMany type: #OPSchema opposite: #not',
		'#usedAsOneOfBy => FMMany type: #OPSchema opposite: #oneOf',
		'#usedAsPrefixItemsBy => FMMany type: #OPSchema opposite: #prefixItems',
		'#usedAsPropertyValueBy => FMMany type: #OPProperty opposite: #valueSchema',
		'#usedAsTupleItemsBy => FMMany type: #OPSchema opposite: #tupleItems',
		'#usedByDiscriminatorMappings => FMMany type: #OPDiscriminatorMapping opposite: #schema',
		'#usedByHeaders => FMMany type: #OPHeader opposite: #schema',
		'#usedByMediaTypes => FMMany type: #OPMediaType opposite: #schema',
		'#usedByParameters => FMMany type: #OPParameter opposite: #schema',
		'#usedByResponses => FMMany type: #OPResponse opposite: #schema',
		'#usedBySchemaEntries => FMMany type: #OPSchemaEntry opposite: #value',
		'#writeOnly => FMProperty',
		'#xml => FMOne type: #OPXMLElement opposite: #schema'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSchema class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Schema super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPSchema >> addAllOf: anObject [

	<ignoreForCoverage>
	<generated>
	^ self allOf add: anObject
]

{ #category : 'adding' }
OPSchema >> addAnyOf: anObject [

	<ignoreForCoverage>
	<generated>
	^ self anyOf add: anObject
]

{ #category : 'adding' }
OPSchema >> addOneOf: anObject [

	<ignoreForCoverage>
	<generated>
	^ self oneOf add: anObject
]

{ #category : 'adding' }
OPSchema >> addPrefixItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self prefixItems add: anObject
]

{ #category : 'adding' }
OPSchema >> addProperty: anObject [

	<ignoreForCoverage>
	<generated>
	^ self properties add: anObject
]

{ #category : 'adding' }
OPSchema >> addTupleItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self tupleItems add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsAdditionalPropertiesBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsAdditionalPropertiesBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsAllOfBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsAllOfBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsAnyOfBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsAnyOfBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsItemsBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsItemsBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsNotBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsNotBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsOneOfBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsOneOfBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsPrefixItemsBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsPrefixItemsBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsPropertyValueBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsPropertyValueBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedAsTupleItemsBy: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedAsTupleItemsBy add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedByDiscriminatorMapping: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByDiscriminatorMappings add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedByHeader: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByHeaders add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedByMediaType: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByMediaTypes add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedByParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByParameters add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedByResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByResponses add: anObject
]

{ #category : 'adding' }
OPSchema >> addUsedBySchemaEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedBySchemaEntries add: anObject
]

{ #category : 'accessing' }
OPSchema >> additionalProperties [
	"Relation named: #additionalProperties type: #OPSchema opposite: #usedAsAdditionalPropertiesBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference additionalProperties from Schema to Schema [0..1].'>
	^ additionalProperties
]

{ #category : 'accessing' }
OPSchema >> additionalProperties: anObject [

	<ignoreForCoverage>
	<generated>
	additionalProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> additionalPropertiesAllowed [

	<FMProperty: #additionalPropertiesAllowed type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute additionalPropertiesAllowed from Schema [1]'>
	^ additionalPropertiesAllowed
]

{ #category : 'accessing' }
OPSchema >> additionalPropertiesAllowed: anObject [
	<ignoreForCoverage>
	<generated>
	additionalPropertiesAllowed := anObject
]

{ #category : 'accessing' }
OPSchema >> allOf [
	"Relation named: #allOf type: #OPSchema opposite: #usedAsAllOfBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference allOf from Schema to Schema [0..*].'>
	^ allOf
]

{ #category : 'accessing' }
OPSchema >> allOf: anObject [

	<ignoreForCoverage>
	<generated>
	allOf value: anObject
]

{ #category : 'accessing' }
OPSchema >> anyOf [
	"Relation named: #anyOf type: #OPSchema opposite: #usedAsAnyOfBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference anyOf from Schema to Schema [0..*]: alternatives of which at least one must match.'>
	^ anyOf
]

{ #category : 'accessing' }
OPSchema >> anyOf: anObject [

	<ignoreForCoverage>
	<generated>
	anyOf value: anObject
]

{ #category : 'accessing' }
OPSchema >> components [
	"Relation named: #components type: #OPComponents opposite: #directSchemas"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from Schema to Components [0..1], when the object is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPSchema >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPSchema >> constValue [

	<FMProperty: #constValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'The only allowed value of the schema (const), as JSON text [1].'>
	^ constValue
]

{ #category : 'accessing' }
OPSchema >> constValue: anObject [
	<ignoreForCoverage>
	<generated>
	constValue := anObject
]

{ #category : 'accessing' }
OPSchema >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #schemas"

	<ignoreForCoverage>
	<generated>
	<container>
	^ containedCollections
]

{ #category : 'accessing' }
OPSchema >> containedCollections: anObject [

	<ignoreForCoverage>
	<generated>
	containedCollections := anObject
]

{ #category : 'accessing' }
OPSchema >> declaringContext [
	"Relation named: #declaringContext type: #OPSchemaContainer opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference declaringContext from Schema to SchemaContainer [0..1].'>
	^ declaringContext
]

{ #category : 'accessing' }
OPSchema >> declaringContext: anObject [

	<ignoreForCoverage>
	<generated>
	declaringContext := anObject
]

{ #category : 'accessing' }
OPSchema >> defaultValue [

	<FMProperty: #defaultValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Default value of the schema, as JSON text [1].'>
	^ defaultValue
]

{ #category : 'accessing' }
OPSchema >> defaultValue: anObject [
	<ignoreForCoverage>
	<generated>
	defaultValue := anObject
]

{ #category : 'accessing' }
OPSchema >> deprecated [

	<FMProperty: #deprecated type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the schema is deprecated [1].'>
	^ deprecated
]

{ #category : 'accessing' }
OPSchema >> deprecated: anObject [
	<ignoreForCoverage>
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPSchema >> discriminator [

	<FMProperty: #discriminator type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute discriminator from Schema [1]'>
	^ discriminator
]

{ #category : 'accessing' }
OPSchema >> discriminator: anObject [
	<ignoreForCoverage>
	<generated>
	discriminator := anObject
]

{ #category : 'accessing' }
OPSchema >> discriminatorEntity [
	"Relation named: #discriminatorEntity type: #OPDiscriminator opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference discriminatorEntity from Schema to Discriminator [0..1].'>
	^ discriminatorEntity
]

{ #category : 'accessing' }
OPSchema >> discriminatorEntity: anObject [

	<ignoreForCoverage>
	<generated>
	discriminatorEntity := anObject
]

{ #category : 'accessing' }
OPSchema >> enumValues [

	<FMProperty: #enumValues type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Allowed values of the schema, as a JSON array text [1].'>
	^ enumValues
]

{ #category : 'accessing' }
OPSchema >> enumValues: anObject [
	<ignoreForCoverage>
	<generated>
	enumValues := anObject
]

{ #category : 'accessing' }
OPSchema >> example [

	<FMProperty: #example type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute example from Schema [1]'>
	^ example
]

{ #category : 'accessing' }
OPSchema >> example: anObject [
	<ignoreForCoverage>
	<generated>
	example := anObject
]

{ #category : 'accessing' }
OPSchema >> exampleValue [

	<FMProperty: #exampleValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Example value of the schema, as JSON text [1].'>
	^ exampleValue
]

{ #category : 'accessing' }
OPSchema >> exampleValue: anObject [
	<ignoreForCoverage>
	<generated>
	exampleValue := anObject
]

{ #category : 'accessing' }
OPSchema >> isNullable [

	<FMProperty: #isNullable type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether null is an accepted value (nullable in 3.0, null among the types in 3.1) [1].'>
	^ isNullable
]

{ #category : 'accessing' }
OPSchema >> isNullable: anObject [
	<ignoreForCoverage>
	<generated>
	isNullable := anObject
]

{ #category : 'accessing' }
OPSchema >> items [
	"Relation named: #items type: #OPSchema opposite: #usedAsItemsBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference items from Schema to Schema [0..1].'>
	^ items
]

{ #category : 'accessing' }
OPSchema >> items: anObject [

	<ignoreForCoverage>
	<generated>
	items := anObject
]

{ #category : 'accessing' }
OPSchema >> maxProperties [

	<FMProperty: #maxProperties type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute maxProperties from Schema [1]'>
	^ maxProperties
]

{ #category : 'accessing' }
OPSchema >> maxProperties: anObject [
	<ignoreForCoverage>
	<generated>
	maxProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> minProperties [

	<FMProperty: #minProperties type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute minProperties from Schema [1]'>
	^ minProperties
]

{ #category : 'accessing' }
OPSchema >> minProperties: anObject [
	<ignoreForCoverage>
	<generated>
	minProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> not [
	"Relation named: #not type: #OPSchema opposite: #usedAsNotBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference not from Schema to Schema [0..1]: schema that must not match.'>
	^ not
]

{ #category : 'accessing' }
OPSchema >> not: anObject [

	<ignoreForCoverage>
	<generated>
	not := anObject
]

{ #category : 'accessing' }
OPSchema >> oneOf [
	"Relation named: #oneOf type: #OPSchema opposite: #usedAsOneOfBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference oneOf from Schema to Schema [0..*]: alternatives of which exactly one must match.'>
	^ oneOf
]

{ #category : 'accessing' }
OPSchema >> oneOf: anObject [

	<ignoreForCoverage>
	<generated>
	oneOf value: anObject
]

{ #category : 'accessing' }
OPSchema >> prefixItems [
	"Relation named: #prefixItems type: #OPSchema opposite: #usedAsPrefixItemsBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference prefixItems from Schema to Schema [0..*]: schemas of the first array items, in order.'>
	^ prefixItems
]

{ #category : 'accessing' }
OPSchema >> prefixItems: anObject [

	<ignoreForCoverage>
	<generated>
	prefixItems value: anObject
]

{ #category : 'accessing' }
OPSchema >> properties [
	"Relation named: #properties type: #OPProperty opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference properties from Schema to Property [0..*].'>
	^ properties
]

{ #category : 'accessing' }
OPSchema >> properties: anObject [

	<ignoreForCoverage>
	<generated>
	properties value: anObject
]

{ #category : 'accessing' }
OPSchema >> readOnly [

	<FMProperty: #readOnly type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute readOnly from Schema [1]'>
	^ readOnly
]

{ #category : 'accessing' }
OPSchema >> readOnly: anObject [
	<ignoreForCoverage>
	<generated>
	readOnly := anObject
]

{ #category : 'accessing' }
OPSchema >> requiredProperties [

	<FMProperty: #requiredProperties type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'Names of the properties that are mandatory in an instance of the schema [*] (strings).'>
	^ requiredProperties ifNil: [ requiredProperties := #() ]
]

{ #category : 'accessing' }
OPSchema >> requiredProperties: anObject [
	<ignoreForCoverage>
	<generated>
	requiredProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> title [

	<FMProperty: #title type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute title from Schema [1]'>
	^ title
]

{ #category : 'accessing' }
OPSchema >> title: anObject [
	<ignoreForCoverage>
	<generated>
	title := anObject
]

{ #category : 'accessing' }
OPSchema >> tupleItems [
	"Relation named: #tupleItems type: #OPSchema opposite: #usedAsTupleItemsBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference tupleItems from Schema to Schema [0..*].'>
	^ tupleItems
]

{ #category : 'accessing' }
OPSchema >> tupleItems: anObject [

	<ignoreForCoverage>
	<generated>
	tupleItems value: anObject
]

{ #category : 'accessing' }
OPSchema >> types [

	<FMProperty: #types type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'JSON Schema types of the schema [*] (strings such as string, integer, null); several values for a 3.1 type array.'>
	^ types ifNil: [ types := #() ]
]

{ #category : 'accessing' }
OPSchema >> types: anObject [
	<ignoreForCoverage>
	<generated>
	types := anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsAdditionalPropertiesBy [
	"Relation named: #usedAsAdditionalPropertiesBy type: #OPSchema opposite: #additionalProperties"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema as their additionalProperties [0..*].'>
	^ usedAsAdditionalPropertiesBy
]

{ #category : 'accessing' }
OPSchema >> usedAsAdditionalPropertiesBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsAdditionalPropertiesBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsAllOfBy [
	"Relation named: #usedAsAllOfBy type: #OPSchema opposite: #allOf"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema in their allOf [0..*].'>
	^ usedAsAllOfBy
]

{ #category : 'accessing' }
OPSchema >> usedAsAllOfBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsAllOfBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsAnyOfBy [
	"Relation named: #usedAsAnyOfBy type: #OPSchema opposite: #anyOf"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema in their anyOf [0..*].'>
	^ usedAsAnyOfBy
]

{ #category : 'accessing' }
OPSchema >> usedAsAnyOfBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsAnyOfBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsItemsBy [
	"Relation named: #usedAsItemsBy type: #OPSchema opposite: #items"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema as their items [0..*].'>
	^ usedAsItemsBy
]

{ #category : 'accessing' }
OPSchema >> usedAsItemsBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsItemsBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsNotBy [
	"Relation named: #usedAsNotBy type: #OPSchema opposite: #not"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema as their not [0..*].'>
	^ usedAsNotBy
]

{ #category : 'accessing' }
OPSchema >> usedAsNotBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsNotBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsOneOfBy [
	"Relation named: #usedAsOneOfBy type: #OPSchema opposite: #oneOf"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema in their oneOf [0..*].'>
	^ usedAsOneOfBy
]

{ #category : 'accessing' }
OPSchema >> usedAsOneOfBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsOneOfBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsPrefixItemsBy [
	"Relation named: #usedAsPrefixItemsBy type: #OPSchema opposite: #prefixItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema in their prefixItems [0..*].'>
	^ usedAsPrefixItemsBy
]

{ #category : 'accessing' }
OPSchema >> usedAsPrefixItemsBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsPrefixItemsBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsPropertyValueBy [
	"Relation named: #usedAsPropertyValueBy type: #OPProperty opposite: #valueSchema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Properties whose value schema is this Schema [0..*].'>
	^ usedAsPropertyValueBy
]

{ #category : 'accessing' }
OPSchema >> usedAsPropertyValueBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsPropertyValueBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsTupleItemsBy [
	"Relation named: #usedAsTupleItemsBy type: #OPSchema opposite: #tupleItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this Schema in their tupleItems [0..*].'>
	^ usedAsTupleItemsBy
]

{ #category : 'accessing' }
OPSchema >> usedAsTupleItemsBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsTupleItemsBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedByDiscriminatorMappings [
	"Relation named: #usedByDiscriminatorMappings type: #OPDiscriminatorMapping opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Discriminator mappings selecting this Schema [0..*].'>
	^ usedByDiscriminatorMappings
]

{ #category : 'accessing' }
OPSchema >> usedByDiscriminatorMappings: anObject [

	<ignoreForCoverage>
	<generated>
	usedByDiscriminatorMappings value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedByHeaders [
	"Relation named: #usedByHeaders type: #OPHeader opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Headers whose schema is this Schema [0..*].'>
	^ usedByHeaders
]

{ #category : 'accessing' }
OPSchema >> usedByHeaders: anObject [

	<ignoreForCoverage>
	<generated>
	usedByHeaders value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedByMediaTypes [
	"Relation named: #usedByMediaTypes type: #OPMediaType opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Media types whose schema is this Schema [0..*].'>
	^ usedByMediaTypes
]

{ #category : 'accessing' }
OPSchema >> usedByMediaTypes: anObject [

	<ignoreForCoverage>
	<generated>
	usedByMediaTypes value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedByParameters [
	"Relation named: #usedByParameters type: #OPParameter opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Parameters whose schema is this Schema [0..*].'>
	^ usedByParameters
]

{ #category : 'accessing' }
OPSchema >> usedByParameters: anObject [

	<ignoreForCoverage>
	<generated>
	usedByParameters value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedByResponses [
	"Relation named: #usedByResponses type: #OPResponse opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Responses whose schema is this Schema [0..*].'>
	^ usedByResponses
]

{ #category : 'accessing' }
OPSchema >> usedByResponses: anObject [

	<ignoreForCoverage>
	<generated>
	usedByResponses value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedBySchemaEntries [
	"Relation named: #usedBySchemaEntries type: #OPSchemaEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'SchemaEntry entries whose value is this Schema [0..*].'>
	^ usedBySchemaEntries
]

{ #category : 'accessing' }
OPSchema >> usedBySchemaEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedBySchemaEntries value: anObject
]

{ #category : 'accessing' }
OPSchema >> writeOnly [

	<FMProperty: #writeOnly type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the value is only sent to the server, never returned [1].'>
	^ writeOnly
]

{ #category : 'accessing' }
OPSchema >> writeOnly: anObject [
	<ignoreForCoverage>
	<generated>
	writeOnly := anObject
]

{ #category : 'accessing' }
OPSchema >> xml [
	"Relation named: #xml type: #OPXMLElement opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference xml from Schema to XMLElement [0..1].'>
	^ xml
]

{ #category : 'accessing' }
OPSchema >> xml: anObject [

	<ignoreForCoverage>
	<generated>
	xml := anObject
]
