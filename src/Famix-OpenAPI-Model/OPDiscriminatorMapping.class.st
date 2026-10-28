"
One entry of the mapping of a Discriminator: a discriminating value (its name) bound to the schema it selects.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `discriminator` | `OPDiscriminatorMapping` | `mapping` | `OPDiscriminator` | Opposite reference discriminator from DiscriminatorMapping to Discriminator [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPDiscriminatorMapping` | `usedByDiscriminatorMappings` | `OPSchema` | Reference schema from DiscriminatorMapping to Schema [0..1]: the selected schema.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `value` | `String` | nil | Name or reference of the schema selected by the discriminating value, as written in the source [1].|

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
	<FMComment: 'Opposite reference discriminator from DiscriminatorMapping to Discriminator [0..1].'>
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
	<FMComment: 'Reference schema from DiscriminatorMapping to Schema [0..1]: the selected schema.'>
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
	<FMComment: 'Name or reference of the schema selected by the discriminating value, as written in the source [1].'>
	^ value
]

{ #category : 'accessing' }
OPDiscriminatorMapping >> value: anObject [
	<ignoreForCoverage>
	<generated>
	value := anObject
]
