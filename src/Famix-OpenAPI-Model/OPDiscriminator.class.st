"
Hint used to select, among oneOf/anyOf/allOf alternatives, the schema matching a payload (OpenAPI Discriminator Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPDiscriminator` | `discriminator` | `OPSchema` | The schema declaring the discriminator.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mapping` | `OPDiscriminator` | `discriminator` | `OPDiscriminatorMapping` | Explicit bindings of discriminating values to schemas.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `propertyName` | `String` | nil | Name of the property whose value discriminates the schemas.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPDiscriminator',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#mapping => FMMany type: #OPDiscriminatorMapping opposite: #discriminator',
		'#propertyName => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #discriminator'
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
	<FMComment: 'Explicit bindings of discriminating values to schemas.'>
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
	<FMComment: 'Name of the property whose value discriminates the schemas.'>
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
	"Relation named: #schema type: #OPSchema opposite: #discriminator"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The schema declaring the discriminator.'>
	<container>
	^ schema
]

{ #category : 'accessing' }
OPDiscriminator >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]
