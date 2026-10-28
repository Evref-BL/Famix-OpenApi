"
Requests an operation may send to a URL given at runtime (OpenAPI Callback Object), described by path items.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPCallback` | `callbacks` | `OPComponents` | The components owning the object, when it is a reusable one.|
| `operation` | `OPCallback` | `callbacks` | `OPOperation` | The operation owning the callback, when it is declared inline.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `pathItems` | `OPCallback` | `callback` | `OPPath` | Path items describing the requests sent to the callback URL expressions.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPCallback',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #callbacks',
		'#operation => FMOne type: #OPOperation opposite: #callbacks',
		'#pathItems => FMMany type: #OPPath opposite: #callback'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPCallback class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Callback super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPCallback >> addPathItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self pathItems add: anObject
]

{ #category : 'accessing' }
OPCallback >> components [
	"Relation named: #components type: #OPComponents opposite: #callbacks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPCallback >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPCallback >> operation [
	"Relation named: #operation type: #OPOperation opposite: #callbacks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The operation owning the callback, when it is declared inline.'>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPCallback >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPCallback >> pathItems [
	"Relation named: #pathItems type: #OPPath opposite: #callback"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Path items describing the requests sent to the callback URL expressions.'>
	^ pathItems
]

{ #category : 'accessing' }
OPCallback >> pathItems: anObject [

	<ignoreForCoverage>
	<generated>
	pathItems value: anObject
]
