"
A parameter of an operation or of a path item (OpenAPI Parameter Object), located in the path, the query, a header or a cookie. It may be shared by several operations.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPParameter` | `parameters` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentOwner` | `OPMediaType` | Payload descriptions of the entity, one per media type.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `examples` | `OPParameter` | `usedByParameters` | `OPExample` | Examples of the parameter value. An example may be shared by several parameters.|
| `schema` | `OPParameter` | `usedByParameters` | `OPSchema` | Schema of the parameter value.|
| `usedByOperations` | `OPParameter` | `parameters` | `OPOperation` | Operations using this parameter.|
| `usedByPaths` | `OPParameter` | `parameters` | `OPPath` | Path items using this parameter.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `allowEmptyValue` | `Boolean` | nil | Whether a query parameter may be sent with an empty value.|
| `allowReserved` | `Boolean` | nil | Whether reserved characters are left unescaped in the value.|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `deprecated` | `Boolean` | nil | Whether the parameter is deprecated.|
| `description` | `String` | nil | Description of the parameter.|
| `explode` | `Boolean` | nil | Whether array and object values generate separate parameters.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `location` | `String` | nil | Where the parameter is located: path, query, header or cookie (the in field).|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `required` | `Boolean` | nil | Whether the parameter is mandatory.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `style` | `String` | nil | Serialization style of the parameter value.|

"
Class {
	#name : 'OPParameter',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPContentContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPContentContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#allowEmptyValue => FMProperty',
		'#allowReserved => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #parameters',
		'#deprecated => FMProperty',
		'#description => FMProperty',
		'#examples => FMMany type: #OPExample opposite: #usedByParameters',
		'#explode => FMProperty',
		'#location => FMProperty',
		'#required => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #usedByParameters',
		'#style => FMProperty',
		'#usedByOperations => FMMany type: #OPOperation opposite: #parameters',
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
OPParameter >> addExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self examples add: anObject
]

{ #category : 'adding' }
OPParameter >> addUsedByOperation: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByOperations add: anObject
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
	<FMComment: 'Whether a query parameter may be sent with an empty value.'>
	^ allowEmptyValue
]

{ #category : 'accessing' }
OPParameter >> allowEmptyValue: anObject [
	<ignoreForCoverage>
	<generated>
	allowEmptyValue := anObject
]

{ #category : 'accessing' }
OPParameter >> allowReserved [

	<FMProperty: #allowReserved type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether reserved characters are left unescaped in the value.'>
	^ allowReserved
]

{ #category : 'accessing' }
OPParameter >> allowReserved: anObject [
	<ignoreForCoverage>
	<generated>
	allowReserved := anObject
]

{ #category : 'accessing' }
OPParameter >> components [
	"Relation named: #components type: #OPComponents opposite: #parameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPParameter >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPParameter >> deprecated [

	<FMProperty: #deprecated type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the parameter is deprecated.'>
	^ deprecated
]

{ #category : 'accessing' }
OPParameter >> deprecated: anObject [
	<ignoreForCoverage>
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPParameter >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the parameter.'>
	^ description
]

{ #category : 'accessing' }
OPParameter >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPParameter >> examples [
	"Relation named: #examples type: #OPExample opposite: #usedByParameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Examples of the parameter value. An example may be shared by several parameters.'>
	^ examples
]

{ #category : 'accessing' }
OPParameter >> examples: anObject [

	<ignoreForCoverage>
	<generated>
	examples value: anObject
]

{ #category : 'accessing' }
OPParameter >> explode [

	<FMProperty: #explode type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether array and object values generate separate parameters.'>
	^ explode
]

{ #category : 'accessing' }
OPParameter >> explode: anObject [
	<ignoreForCoverage>
	<generated>
	explode := anObject
]

{ #category : 'accessing' }
OPParameter >> location [

	<FMProperty: #location type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Where the parameter is located: path, query, header or cookie (the in field).'>
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
	<FMComment: 'Whether the parameter is mandatory.'>
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
	<FMComment: 'Schema of the parameter value.'>
	^ schema
]

{ #category : 'accessing' }
OPParameter >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPParameter >> style [

	<FMProperty: #style type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Serialization style of the parameter value.'>
	^ style
]

{ #category : 'accessing' }
OPParameter >> style: anObject [
	<ignoreForCoverage>
	<generated>
	style := anObject
]

{ #category : 'accessing' }
OPParameter >> usedByOperations [
	"Relation named: #usedByOperations type: #OPOperation opposite: #parameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Operations using this parameter.'>
	^ usedByOperations
]

{ #category : 'accessing' }
OPParameter >> usedByOperations: anObject [

	<ignoreForCoverage>
	<generated>
	usedByOperations value: anObject
]

{ #category : 'accessing' }
OPParameter >> usedByPaths [
	"Relation named: #usedByPaths type: #OPPath opposite: #parameters"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Path items using this parameter.'>
	^ usedByPaths
]

{ #category : 'accessing' }
OPParameter >> usedByPaths: anObject [

	<ignoreForCoverage>
	<generated>
	usedByPaths value: anObject
]
