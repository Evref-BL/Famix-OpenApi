"
An example value (OpenAPI Example Object), inline or reusable. A reusable example may be shared by several parameters and media types.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPExample` | `examples` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByMediaTypes` | `OPExample` | `examples` | `OPMediaType` | Media types using this example.|
| `usedByParameters` | `OPExample` | `examples` | `OPParameter` | Parameters using this example.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `externalValue` | `String` | nil | URL of a document holding the example value.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `summary` | `String` | nil | Short description of the example.|
| `value` | `String` | nil | Value of the example, as JSON text.|

"
Class {
	#name : 'OPExample',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #examples',
		'#externalValue => FMProperty',
		'#summary => FMProperty',
		'#usedByMediaTypes => FMMany type: #OPMediaType opposite: #examples',
		'#usedByParameters => FMMany type: #OPParameter opposite: #examples',
		'#value => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExample class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Example super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPExample >> addUsedByMediaType: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByMediaTypes add: anObject
]

{ #category : 'adding' }
OPExample >> addUsedByParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByParameters add: anObject
]

{ #category : 'accessing' }
OPExample >> components [
	"Relation named: #components type: #OPComponents opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPExample >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPExample >> externalValue [

	<FMProperty: #externalValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL of a document holding the example value.'>
	^ externalValue
]

{ #category : 'accessing' }
OPExample >> externalValue: anObject [
	<ignoreForCoverage>
	<generated>
	externalValue := anObject
]

{ #category : 'accessing' }
OPExample >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Short description of the example.'>
	^ summary
]

{ #category : 'accessing' }
OPExample >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPExample >> usedByMediaTypes [
	"Relation named: #usedByMediaTypes type: #OPMediaType opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Media types using this example.'>
	^ usedByMediaTypes
]

{ #category : 'accessing' }
OPExample >> usedByMediaTypes: anObject [

	<ignoreForCoverage>
	<generated>
	usedByMediaTypes value: anObject
]

{ #category : 'accessing' }
OPExample >> usedByParameters [
	"Relation named: #usedByParameters type: #OPParameter opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Parameters using this example.'>
	^ usedByParameters
]

{ #category : 'accessing' }
OPExample >> usedByParameters: anObject [

	<ignoreForCoverage>
	<generated>
	usedByParameters value: anObject
]

{ #category : 'accessing' }
OPExample >> value [

	<FMProperty: #value type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Value of the example, as JSON text.'>
	^ value
]

{ #category : 'accessing' }
OPExample >> value: anObject [
	<ignoreForCoverage>
	<generated>
	value := anObject
]
