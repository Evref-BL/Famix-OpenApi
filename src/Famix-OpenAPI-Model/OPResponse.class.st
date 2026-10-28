"
A response of an operation for one status code (OpenAPI Response Object). A reusable response referenced by several operations is copied for each of them: each copy owns its status code and operation and keeps the reference to the original.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPResponse` | `responses` | `OPComponents` | The components owning the object, when it is a reusable one.|
| `operation` | `OPResponse` | `responses` | `OPOperation` | The operation owning the response.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentOwner` | `OPMediaType` | Payload descriptions of the entity, one per media type.|
| `headers` | `OPResponse` | `response` | `OPHeader` | Headers of the response.|
| `links` | `OPResponse` | `response` | `OPLink` | Operations that can be followed from the response.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the response.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `statusCode` | `String` | nil | HTTP status code of the response, a range or default: 200, 2XX or default.|

"
Class {
	#name : 'OPResponse',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPContentContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPContentContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #responses',
		'#description => FMProperty',
		'#headers => FMMany type: #OPHeader opposite: #response',
		'#links => FMMany type: #OPLink opposite: #response',
		'#operation => FMOne type: #OPOperation opposite: #responses',
		'#statusCode => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPResponse class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Response super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPResponse >> addHeader: anObject [

	<ignoreForCoverage>
	<generated>
	^ self headers add: anObject
]

{ #category : 'adding' }
OPResponse >> addLink: anObject [

	<ignoreForCoverage>
	<generated>
	^ self links add: anObject
]

{ #category : 'accessing' }
OPResponse >> components [
	"Relation named: #components type: #OPComponents opposite: #responses"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPResponse >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPResponse >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the response.'>
	^ description
]

{ #category : 'accessing' }
OPResponse >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPResponse >> headers [
	"Relation named: #headers type: #OPHeader opposite: #response"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Headers of the response.'>
	^ headers
]

{ #category : 'accessing' }
OPResponse >> headers: anObject [

	<ignoreForCoverage>
	<generated>
	headers value: anObject
]

{ #category : 'accessing' }
OPResponse >> links [
	"Relation named: #links type: #OPLink opposite: #response"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Operations that can be followed from the response.'>
	^ links
]

{ #category : 'accessing' }
OPResponse >> links: anObject [

	<ignoreForCoverage>
	<generated>
	links value: anObject
]

{ #category : 'accessing' }
OPResponse >> operation [
	"Relation named: #operation type: #OPOperation opposite: #responses"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The operation owning the response.'>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPResponse >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPResponse >> statusCode [

	<FMProperty: #statusCode type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'HTTP status code of the response, a range or default: 200, 2XX or default.'>
	^ statusCode
]

{ #category : 'accessing' }
OPResponse >> statusCode: anObject [
	<ignoreForCoverage>
	<generated>
	statusCode := anObject
]
