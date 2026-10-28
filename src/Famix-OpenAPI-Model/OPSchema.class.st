"
A JSON Schema (OpenAPI Schema Object) describing a value: its types, constraints, properties and composition (allOf, oneOf, anyOf, not).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPSchema` | `schemas` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `discriminator` | `OPSchema` | `schema` | `OPDiscriminator` | Discriminator selecting the matching alternative of the schema.|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | External documentation of the entity.|
| `properties` | `OPSchema` | `schema` | `OPProperty` | Named properties of an object schema.|
| `xml` | `OPSchema` | `schema` | `OPXmlElement` | XML representation of the schema.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `additionalProperties` | `OPSchema` | `usedAsAdditionalPropertiesBy` | `OPSchema` | Schema of the additional properties of an object.|
| `allOf` | `OPSchema` | `usedAsAllOfBy` | `OPSchema` | Schemas that must all match.|
| `anyOf` | `OPSchema` | `usedAsAnyOfBy` | `OPSchema` | Alternatives of which at least one must match.|
| `items` | `OPSchema` | `usedAsItemsBy` | `OPSchema` | Schema of the items of an array.|
| `not` | `OPSchema` | `usedAsNotBy` | `OPSchema` | Schema that must not match.|
| `oneOf` | `OPSchema` | `usedAsOneOfBy` | `OPSchema` | Alternatives of which exactly one must match.|
| `prefixItems` | `OPSchema` | `usedAsPrefixItemsBy` | `OPSchema` | Schemas of the first items of an array, in order (tuple validation).|
| `subSchemas` | `OPSchema` | `subSchemaOf` | `OPSubSchema` | SubSchemas created by the importer as strict subsets of this schema.|
| `usedAsAdditionalPropertiesBy` | `OPSchema` | `additionalProperties` | `OPSchema` | Schemas having this schema as their additionalProperties.|
| `usedAsAllOfBy` | `OPSchema` | `allOf` | `OPSchema` | Schemas having this schema in their allOf.|
| `usedAsAnyOfBy` | `OPSchema` | `anyOf` | `OPSchema` | Schemas having this schema in their anyOf.|
| `usedAsItemsBy` | `OPSchema` | `items` | `OPSchema` | Schemas having this schema as their items.|
| `usedAsNotBy` | `OPSchema` | `not` | `OPSchema` | Schemas having this schema as their not.|
| `usedAsOneOfBy` | `OPSchema` | `oneOf` | `OPSchema` | Schemas having this schema in their oneOf.|
| `usedAsPrefixItemsBy` | `OPSchema` | `prefixItems` | `OPSchema` | Schemas having this schema in their prefixItems.|
| `usedAsPropertyValueBy` | `OPSchema` | `valueSchema` | `OPProperty` | Properties whose value schema is this schema.|
| `usedByDiscriminatorMappings` | `OPSchema` | `schema` | `OPDiscriminatorMapping` | Discriminator mappings selecting this schema.|
| `usedByHeaders` | `OPSchema` | `schema` | `OPHeader` | Headers whose schema is this schema.|
| `usedByMediaTypes` | `OPSchema` | `schema` | `OPMediaType` | Media types whose schema is this schema.|
| `usedByParameters` | `OPSchema` | `schema` | `OPParameter` | Parameters whose schema is this schema.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `additionalPropertiesAllowed` | `Boolean` | nil | Whether additional properties are allowed when additionalProperties is a boolean in the source.|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `constValue` | `String` | nil | The only allowed value of the schema (const), as JSON text.|
| `defaultValue` | `String` | nil | Default value of the schema, as JSON text.|
| `deprecated` | `Boolean` | nil | Whether the schema is deprecated.|
| `description` | `String` | nil | Description of the schema.|
| `enumValues` | `String` | nil | Allowed values of the schema, as a JSON array text.|
| `exampleValue` | `String` | nil | Example value of the schema, as JSON text.|
| `exclusiveMaximum` | `Number` | nil | Exclusive upper bound of a number (OpenAPI 3.1 form).|
| `exclusiveMinimum` | `Number` | nil | Exclusive lower bound of a number (OpenAPI 3.1 form).|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `format` | `String` | nil | Format of the values, such as int32, int64 or date-time.|
| `isNullable` | `Boolean` | nil | Whether null is an accepted value (nullable in 3.0, null among the types in 3.1).|
| `maxItems` | `Number` | nil | Maximum number of items of an array.|
| `maxLength` | `Number` | nil | Maximum length of a string.|
| `maxProperties` | `Number` | nil | Maximum number of properties of an object.|
| `maximum` | `Number` | nil | Inclusive upper bound of a number.|
| `mergedPointers` | `String` | #() | canonicalPointers of identical inline schemas that the importer merged into this entity; the entity's own canonicalPointer is the first occurrence.|
| `minItems` | `Number` | nil | Minimum number of items of an array.|
| `minLength` | `Number` | nil | Minimum length of a string.|
| `minProperties` | `Number` | nil | Minimum number of properties of an object.|
| `minimum` | `Number` | nil | Inclusive lower bound of a number.|
| `multipleOf` | `Number` | nil | A number is valid when it is a multiple of this value.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `pattern` | `String` | nil | Regular expression a string must match.|
| `readOnly` | `Boolean` | nil | Whether the value is only returned by the server, never sent to it.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `requiredProperties` | `String` | #() | Names of the properties that are mandatory in an instance of the schema.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `title` | `String` | nil | Title of the schema.|
| `types` | `String` | #() | JSON Schema types of the schema, such as string, integer or null; several values for a 3.1 type array.|
| `uniqueItems` | `Boolean` | nil | Whether the items of an array must be distinct.|
| `writeOnly` | `Boolean` | nil | Whether the value is only sent to the server, never returned.|

"
Class {
	#name : 'OPSchema',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPExternalDocsContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPExternalDocsContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#additionalProperties => FMOne type: #OPSchema opposite: #usedAsAdditionalPropertiesBy',
		'#additionalPropertiesAllowed => FMProperty',
		'#allOf => FMMany type: #OPSchema opposite: #usedAsAllOfBy',
		'#anyOf => FMMany type: #OPSchema opposite: #usedAsAnyOfBy',
		'#components => FMOne type: #OPComponents opposite: #schemas',
		'#constValue => FMProperty',
		'#defaultValue => FMProperty',
		'#deprecated => FMProperty',
		'#description => FMProperty',
		'#discriminator => FMOne type: #OPDiscriminator opposite: #schema',
		'#enumValues => FMProperty',
		'#exampleValue => FMProperty',
		'#exclusiveMaximum => FMProperty',
		'#exclusiveMinimum => FMProperty',
		'#format => FMProperty',
		'#isNullable => FMProperty',
		'#items => FMOne type: #OPSchema opposite: #usedAsItemsBy',
		'#maxItems => FMProperty',
		'#maxLength => FMProperty',
		'#maxProperties => FMProperty',
		'#maximum => FMProperty',
		'#mergedPointers => FMProperty defaultValue: #()',
		'#minItems => FMProperty',
		'#minLength => FMProperty',
		'#minProperties => FMProperty',
		'#minimum => FMProperty',
		'#multipleOf => FMProperty',
		'#not => FMOne type: #OPSchema opposite: #usedAsNotBy',
		'#oneOf => FMMany type: #OPSchema opposite: #usedAsOneOfBy',
		'#pattern => FMProperty',
		'#prefixItems => FMMany type: #OPSchema opposite: #usedAsPrefixItemsBy',
		'#properties => FMMany type: #OPProperty opposite: #schema',
		'#readOnly => FMProperty',
		'#requiredProperties => FMProperty defaultValue: #()',
		'#subSchemas => FMMany type: #OPSubSchema opposite: #subSchemaOf',
		'#title => FMProperty',
		'#types => FMProperty defaultValue: #()',
		'#uniqueItems => FMProperty',
		'#usedAsAdditionalPropertiesBy => FMMany type: #OPSchema opposite: #additionalProperties',
		'#usedAsAllOfBy => FMMany type: #OPSchema opposite: #allOf',
		'#usedAsAnyOfBy => FMMany type: #OPSchema opposite: #anyOf',
		'#usedAsItemsBy => FMMany type: #OPSchema opposite: #items',
		'#usedAsNotBy => FMMany type: #OPSchema opposite: #not',
		'#usedAsOneOfBy => FMMany type: #OPSchema opposite: #oneOf',
		'#usedAsPrefixItemsBy => FMMany type: #OPSchema opposite: #prefixItems',
		'#usedAsPropertyValueBy => FMMany type: #OPProperty opposite: #valueSchema',
		'#usedByDiscriminatorMappings => FMMany type: #OPDiscriminatorMapping opposite: #schema',
		'#usedByHeaders => FMMany type: #OPHeader opposite: #schema',
		'#usedByMediaTypes => FMMany type: #OPMediaType opposite: #schema',
		'#usedByParameters => FMMany type: #OPParameter opposite: #schema',
		'#writeOnly => FMProperty',
		'#xml => FMOne type: #OPXmlElement opposite: #schema'
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
OPSchema >> addSubSchema: anObject [

	<ignoreForCoverage>
	<generated>
	^ self subSchemas add: anObject
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

{ #category : 'accessing' }
OPSchema >> additionalProperties [
	"Relation named: #additionalProperties type: #OPSchema opposite: #usedAsAdditionalPropertiesBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schema of the additional properties of an object.'>
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
	<FMComment: 'Whether additional properties are allowed when additionalProperties is a boolean in the source.'>
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
	<FMComment: 'Schemas that must all match.'>
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
	<FMComment: 'Alternatives of which at least one must match.'>
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
	"Relation named: #components type: #OPComponents opposite: #schemas"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
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
	<FMComment: 'The only allowed value of the schema (const), as JSON text.'>
	^ constValue
]

{ #category : 'accessing' }
OPSchema >> constValue: anObject [
	<ignoreForCoverage>
	<generated>
	constValue := anObject
]

{ #category : 'accessing' }
OPSchema >> defaultValue [

	<FMProperty: #defaultValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Default value of the schema, as JSON text.'>
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
	<FMComment: 'Whether the schema is deprecated.'>
	^ deprecated
]

{ #category : 'accessing' }
OPSchema >> deprecated: anObject [
	<ignoreForCoverage>
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPSchema >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the schema.'>
	^ description
]

{ #category : 'accessing' }
OPSchema >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSchema >> discriminator [
	"Relation named: #discriminator type: #OPDiscriminator opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Discriminator selecting the matching alternative of the schema.'>
	^ discriminator
]

{ #category : 'accessing' }
OPSchema >> discriminator: anObject [

	<ignoreForCoverage>
	<generated>
	discriminator := anObject
]

{ #category : 'accessing' }
OPSchema >> enumValues [

	<FMProperty: #enumValues type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Allowed values of the schema, as a JSON array text.'>
	^ enumValues
]

{ #category : 'accessing' }
OPSchema >> enumValues: anObject [
	<ignoreForCoverage>
	<generated>
	enumValues := anObject
]

{ #category : 'accessing' }
OPSchema >> exampleValue [

	<FMProperty: #exampleValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Example value of the schema, as JSON text.'>
	^ exampleValue
]

{ #category : 'accessing' }
OPSchema >> exampleValue: anObject [
	<ignoreForCoverage>
	<generated>
	exampleValue := anObject
]

{ #category : 'accessing' }
OPSchema >> exclusiveMaximum [

	<FMProperty: #exclusiveMaximum type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Exclusive upper bound of a number (OpenAPI 3.1 form).'>
	^ exclusiveMaximum
]

{ #category : 'accessing' }
OPSchema >> exclusiveMaximum: anObject [
	<ignoreForCoverage>
	<generated>
	exclusiveMaximum := anObject
]

{ #category : 'accessing' }
OPSchema >> exclusiveMinimum [

	<FMProperty: #exclusiveMinimum type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Exclusive lower bound of a number (OpenAPI 3.1 form).'>
	^ exclusiveMinimum
]

{ #category : 'accessing' }
OPSchema >> exclusiveMinimum: anObject [
	<ignoreForCoverage>
	<generated>
	exclusiveMinimum := anObject
]

{ #category : 'accessing' }
OPSchema >> format [

	<FMProperty: #format type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Format of the values, such as int32, int64 or date-time.'>
	^ format
]

{ #category : 'accessing' }
OPSchema >> format: anObject [
	<ignoreForCoverage>
	<generated>
	format := anObject
]

{ #category : 'accessing' }
OPSchema >> isNullable [

	<FMProperty: #isNullable type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether null is an accepted value (nullable in 3.0, null among the types in 3.1).'>
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
	<FMComment: 'Schema of the items of an array.'>
	^ items
]

{ #category : 'accessing' }
OPSchema >> items: anObject [

	<ignoreForCoverage>
	<generated>
	items := anObject
]

{ #category : 'accessing' }
OPSchema >> maxItems [

	<FMProperty: #maxItems type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Maximum number of items of an array.'>
	^ maxItems
]

{ #category : 'accessing' }
OPSchema >> maxItems: anObject [
	<ignoreForCoverage>
	<generated>
	maxItems := anObject
]

{ #category : 'accessing' }
OPSchema >> maxLength [

	<FMProperty: #maxLength type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Maximum length of a string.'>
	^ maxLength
]

{ #category : 'accessing' }
OPSchema >> maxLength: anObject [
	<ignoreForCoverage>
	<generated>
	maxLength := anObject
]

{ #category : 'accessing' }
OPSchema >> maxProperties [

	<FMProperty: #maxProperties type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Maximum number of properties of an object.'>
	^ maxProperties
]

{ #category : 'accessing' }
OPSchema >> maxProperties: anObject [
	<ignoreForCoverage>
	<generated>
	maxProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> maximum [

	<FMProperty: #maximum type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Inclusive upper bound of a number.'>
	^ maximum
]

{ #category : 'accessing' }
OPSchema >> maximum: anObject [
	<ignoreForCoverage>
	<generated>
	maximum := anObject
]

{ #category : 'accessing' }
OPSchema >> mergedPointers [

	<FMProperty: #mergedPointers type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'canonicalPointers of identical inline schemas that the importer merged into this entity; the entity''s own canonicalPointer is the first occurrence.'>
	^ mergedPointers ifNil: [ mergedPointers := #() ]
]

{ #category : 'accessing' }
OPSchema >> mergedPointers: anObject [
	<ignoreForCoverage>
	<generated>
	mergedPointers := anObject
]

{ #category : 'accessing' }
OPSchema >> minItems [

	<FMProperty: #minItems type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Minimum number of items of an array.'>
	^ minItems
]

{ #category : 'accessing' }
OPSchema >> minItems: anObject [
	<ignoreForCoverage>
	<generated>
	minItems := anObject
]

{ #category : 'accessing' }
OPSchema >> minLength [

	<FMProperty: #minLength type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Minimum length of a string.'>
	^ minLength
]

{ #category : 'accessing' }
OPSchema >> minLength: anObject [
	<ignoreForCoverage>
	<generated>
	minLength := anObject
]

{ #category : 'accessing' }
OPSchema >> minProperties [

	<FMProperty: #minProperties type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Minimum number of properties of an object.'>
	^ minProperties
]

{ #category : 'accessing' }
OPSchema >> minProperties: anObject [
	<ignoreForCoverage>
	<generated>
	minProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> minimum [

	<FMProperty: #minimum type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Inclusive lower bound of a number.'>
	^ minimum
]

{ #category : 'accessing' }
OPSchema >> minimum: anObject [
	<ignoreForCoverage>
	<generated>
	minimum := anObject
]

{ #category : 'accessing' }
OPSchema >> multipleOf [

	<FMProperty: #multipleOf type: #Number>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'A number is valid when it is a multiple of this value.'>
	^ multipleOf
]

{ #category : 'accessing' }
OPSchema >> multipleOf: anObject [
	<ignoreForCoverage>
	<generated>
	multipleOf := anObject
]

{ #category : 'accessing' }
OPSchema >> not [
	"Relation named: #not type: #OPSchema opposite: #usedAsNotBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schema that must not match.'>
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
	<FMComment: 'Alternatives of which exactly one must match.'>
	^ oneOf
]

{ #category : 'accessing' }
OPSchema >> oneOf: anObject [

	<ignoreForCoverage>
	<generated>
	oneOf value: anObject
]

{ #category : 'accessing' }
OPSchema >> pattern [

	<FMProperty: #pattern type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Regular expression a string must match.'>
	^ pattern
]

{ #category : 'accessing' }
OPSchema >> pattern: anObject [
	<ignoreForCoverage>
	<generated>
	pattern := anObject
]

{ #category : 'accessing' }
OPSchema >> prefixItems [
	"Relation named: #prefixItems type: #OPSchema opposite: #usedAsPrefixItemsBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas of the first items of an array, in order (tuple validation).'>
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
	<FMComment: 'Named properties of an object schema.'>
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
	<FMComment: 'Whether the value is only returned by the server, never sent to it.'>
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
	<FMComment: 'Names of the properties that are mandatory in an instance of the schema.'>
	^ requiredProperties ifNil: [ requiredProperties := #() ]
]

{ #category : 'accessing' }
OPSchema >> requiredProperties: anObject [
	<ignoreForCoverage>
	<generated>
	requiredProperties := anObject
]

{ #category : 'accessing' }
OPSchema >> subSchemas [
	"Relation named: #subSchemas type: #OPSubSchema opposite: #subSchemaOf"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'SubSchemas created by the importer as strict subsets of this schema.'>
	^ subSchemas
]

{ #category : 'accessing' }
OPSchema >> subSchemas: anObject [

	<ignoreForCoverage>
	<generated>
	subSchemas value: anObject
]

{ #category : 'accessing' }
OPSchema >> title [

	<FMProperty: #title type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Title of the schema.'>
	^ title
]

{ #category : 'accessing' }
OPSchema >> title: anObject [
	<ignoreForCoverage>
	<generated>
	title := anObject
]

{ #category : 'accessing' }
OPSchema >> types [

	<FMProperty: #types type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'JSON Schema types of the schema, such as string, integer or null; several values for a 3.1 type array.'>
	^ types ifNil: [ types := #() ]
]

{ #category : 'accessing' }
OPSchema >> types: anObject [
	<ignoreForCoverage>
	<generated>
	types := anObject
]

{ #category : 'accessing' }
OPSchema >> uniqueItems [

	<FMProperty: #uniqueItems type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the items of an array must be distinct.'>
	^ uniqueItems
]

{ #category : 'accessing' }
OPSchema >> uniqueItems: anObject [
	<ignoreForCoverage>
	<generated>
	uniqueItems := anObject
]

{ #category : 'accessing' }
OPSchema >> usedAsAdditionalPropertiesBy [
	"Relation named: #usedAsAdditionalPropertiesBy type: #OPSchema opposite: #additionalProperties"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemas having this schema as their additionalProperties.'>
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
	<FMComment: 'Schemas having this schema in their allOf.'>
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
	<FMComment: 'Schemas having this schema in their anyOf.'>
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
	<FMComment: 'Schemas having this schema as their items.'>
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
	<FMComment: 'Schemas having this schema as their not.'>
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
	<FMComment: 'Schemas having this schema in their oneOf.'>
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
	<FMComment: 'Schemas having this schema in their prefixItems.'>
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
	<FMComment: 'Properties whose value schema is this schema.'>
	^ usedAsPropertyValueBy
]

{ #category : 'accessing' }
OPSchema >> usedAsPropertyValueBy: anObject [

	<ignoreForCoverage>
	<generated>
	usedAsPropertyValueBy value: anObject
]

{ #category : 'accessing' }
OPSchema >> usedByDiscriminatorMappings [
	"Relation named: #usedByDiscriminatorMappings type: #OPDiscriminatorMapping opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Discriminator mappings selecting this schema.'>
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
	<FMComment: 'Headers whose schema is this schema.'>
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
	<FMComment: 'Media types whose schema is this schema.'>
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
	<FMComment: 'Parameters whose schema is this schema.'>
	^ usedByParameters
]

{ #category : 'accessing' }
OPSchema >> usedByParameters: anObject [

	<ignoreForCoverage>
	<generated>
	usedByParameters value: anObject
]

{ #category : 'accessing' }
OPSchema >> writeOnly [

	<FMProperty: #writeOnly type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the value is only sent to the server, never returned.'>
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
	"Relation named: #xml type: #OPXmlElement opposite: #schema"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'XML representation of the schema.'>
	^ xml
]

{ #category : 'accessing' }
OPSchema >> xml: anObject [

	<ignoreForCoverage>
	<generated>
	xml := anObject
]
