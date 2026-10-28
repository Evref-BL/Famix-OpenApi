"
A link from a response to an operation that can be followed with values of the response (OpenAPI Link Object). A reusable link may be shared by several responses.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPLink` | `links` | `OPComponents` | The components owning the object, when it is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `server` | `OPLink` | `link` | `OPServer` | Server used by the linked operation.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operation` | `OPLink` | `usedByLinks` | `OPOperation` | The linked operation (operationId or operationRef resolved).|
| `usedByResponses` | `OPLink` | `links` | `OPResponse` | Responses using this link.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the link.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `operationId` | `String` | nil | operationId of the linked operation.|
| `operationRef` | `String` | nil | URI reference of the linked operation (operationRef field).|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `requestBody` | `String` | nil | Expression or literal used as request body of the linked operation.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPLink',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #links',
		'#description => FMProperty',
		'#operation => FMOne type: #OPOperation opposite: #usedByLinks',
		'#operationId => FMProperty',
		'#operationRef => FMProperty',
		'#requestBody => FMProperty',
		'#server => FMOne type: #OPServer opposite: #link',
		'#usedByResponses => FMMany type: #OPResponse opposite: #links'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPLink class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Link super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPLink >> addUsedByResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByResponses add: anObject
]

{ #category : 'accessing' }
OPLink >> components [
	"Relation named: #components type: #OPComponents opposite: #links"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPLink >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPLink >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the link.'>
	^ description
]

{ #category : 'accessing' }
OPLink >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPLink >> operation [
	"Relation named: #operation type: #OPOperation opposite: #usedByLinks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The linked operation (operationId or operationRef resolved).'>
	^ operation
]

{ #category : 'accessing' }
OPLink >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPLink >> operationId [

	<FMProperty: #operationId type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'operationId of the linked operation.'>
	^ operationId
]

{ #category : 'accessing' }
OPLink >> operationId: anObject [
	<ignoreForCoverage>
	<generated>
	operationId := anObject
]

{ #category : 'accessing' }
OPLink >> operationRef [

	<FMProperty: #operationRef type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URI reference of the linked operation (operationRef field).'>
	^ operationRef
]

{ #category : 'accessing' }
OPLink >> operationRef: anObject [
	<ignoreForCoverage>
	<generated>
	operationRef := anObject
]

{ #category : 'accessing' }
OPLink >> requestBody [

	<FMProperty: #requestBody type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Expression or literal used as request body of the linked operation.'>
	^ requestBody
]

{ #category : 'accessing' }
OPLink >> requestBody: anObject [
	<ignoreForCoverage>
	<generated>
	requestBody := anObject
]

{ #category : 'accessing' }
OPLink >> server [
	"Relation named: #server type: #OPServer opposite: #link"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Server used by the linked operation.'>
	^ server
]

{ #category : 'accessing' }
OPLink >> server: anObject [

	<ignoreForCoverage>
	<generated>
	server := anObject
]

{ #category : 'accessing' }
OPLink >> usedByResponses [
	"Relation named: #usedByResponses type: #OPResponse opposite: #links"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Responses using this link.'>
	^ usedByResponses
]

{ #category : 'accessing' }
OPLink >> usedByResponses: anObject [

	<ignoreForCoverage>
	<generated>
	usedByResponses value: anObject
]
