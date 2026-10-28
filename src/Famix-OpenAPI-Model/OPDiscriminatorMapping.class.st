"
One entry of the mapping of a Discriminator: a discriminating value (its name) bound to the Schema it selects.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `discriminator` | `OPDiscriminatorMapping` | `mapping` | `OPDiscriminator` | The discriminator declaring the mapping.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPDiscriminatorMapping` | `usedByDiscriminatorMappings` | `OPSchema` | The schema selected by the discriminating value.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `value` | `String` | nil | Name or reference of the schema selected by the discriminating value, as written in the source.|

"
Class {
	#name : 'OPDiscriminatorMapping',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#discriminator => FMOne type: #OPDiscriminator opposite: #mapping',
		'#schema => FMOne type: #OPSchema opposite: #usedByDiscriminatorMappings',
		'#value => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPDiscriminatorMapping class >> annotation [

	<ignoreForCoverage>
	<FMClass: #DiscriminatorMapping super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> discriminator [
	"Relation named: #discriminator type: #OPDiscriminator opposite: #mapping"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The discriminator declaring the mapping.'>
	<container>
	^ discriminator
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> discriminator: anObject [

	<ignoreForCoverage>
	<generated>
	discriminator := anObject
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> schema [
	"Relation named: #schema type: #OPSchema opposite: #usedByDiscriminatorMappings"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The schema selected by the discriminating value.'>
	^ schema
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> value [

	<FMProperty: #value type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Name or reference of the schema selected by the discriminating value, as written in the source.'>
	^ value
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> value: anObject [
	<ignoreForCoverage>
	<generated>
	value := anObject
]
