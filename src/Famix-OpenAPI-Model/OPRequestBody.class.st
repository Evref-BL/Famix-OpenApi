"
The payload an operation accepts (OpenAPI Request Body Object), described by media types. It may be shared by several operations.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPRequestBody` | `requestBodies` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentOwner` | `OPMediaType` | Payload descriptions of the entity, one per media type.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByOperations` | `OPRequestBody` | `requestBody` | `OPOperation` | Operations using this request body.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the request body.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `required` | `Boolean` | nil | Whether the request body is mandatory.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPRequestBody',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPContentContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPContentContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #requestBodies',
		'#description => FMProperty',
		'#required => FMProperty',
		'#usedByOperations => FMMany type: #OPOperation opposite: #requestBody'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPRequestBody class >> annotation [

	<ignoreForCoverage>
	<FMClass: #RequestBody super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPRequestBody >> addUsedByOperation: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByOperations add: anObject
]

{ #category : 'accessing' }
OPRequestBody >> components [
	"Relation named: #components type: #OPComponents opposite: #requestBodies"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPRequestBody >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPRequestBody >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the request body.'>
	^ description
]

{ #category : 'accessing' }
OPRequestBody >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPRequestBody >> required [

	<FMProperty: #required type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the request body is mandatory.'>
	^ required
]

{ #category : 'accessing' }
OPRequestBody >> required: anObject [
	<ignoreForCoverage>
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPRequestBody >> usedByOperations [
	"Relation named: #usedByOperations type: #OPOperation opposite: #requestBody"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Operations using this request body.'>
	^ usedByOperations
]

{ #category : 'accessing' }
OPRequestBody >> usedByOperations: anObject [

	<ignoreForCoverage>
	<generated>
	usedByOperations value: anObject
]
