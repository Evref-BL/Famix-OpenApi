"
Hint used to select, among oneOf/anyOf/allOf alternatives, the schema matching a payload (OpenAPI Discriminator Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPDiscriminator` | `discriminatorEntity` | `OPSchema` | Opposite reference schema from Discriminator to Schema [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mapping` | `OPDiscriminator` | `discriminator` | `OPDiscriminatorMapping` | Reference mapping from Discriminator to DiscriminatorMapping [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `propertyName` | `String` | nil | Name of the property whose value discriminates the schemas [1].|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPDiscriminator',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#mapping => FMMany type: #OPDiscriminatorMapping opposite: #discriminator',
		'#propertyName => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #discriminatorEntity'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPDiscriminator class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Discriminator super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPDiscriminator >> addMapping: anObject [

	<ignoreForCoverage>
	<generated>
	^ self mapping add: anObject
]

{ #category : 'accessing' }
OPDiscriminator >> mapping [
	"Relation named: #mapping type: #OPDiscriminatorMapping opposite: #discriminator"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference mapping from Discriminator to DiscriminatorMapping [0..*].'>
	^ mapping
]

{ #category : 'accessing' }
OPDiscriminator >> mapping: anObject [

	<ignoreForCoverage>
	<generated>
	mapping value: anObject
]

{ #category : 'accessing' }
OPDiscriminator >> propertyName [

	<FMProperty: #propertyName type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Name of the property whose value discriminates the schemas [1].'>
	^ propertyName
]

{ #category : 'accessing' }
OPDiscriminator >> propertyName: anObject [
	<ignoreForCoverage>
	<generated>
	propertyName := anObject
]

{ #category : 'accessing' }
OPDiscriminator >> schema [
	"Relation named: #schema type: #OPSchema opposite: #discriminatorEntity"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference schema from Discriminator to Schema [0..1].'>
	<container>
	^ schema
]

{ #category : 'accessing' }
OPDiscriminator >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]
