"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPRequestBody` | `directRequestBodies` | `OPComponents` | Opposite reference components from RequestBody to Components [0..1], when the object is a reusable one.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentContainer` | `OPMediaTypeEntry` | Reference content from ContentContainer to MediaTypeEntry [0..*].|
| `directContent` | `OPContentContainer` | `contentOwner` | `OPMediaType` | Reference directContent from ContentContainer to MediaType [0..*]: payload descriptions by media type (provisional name of content).|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByOperations` | `OPRequestBody` | `requestBody` | `OPOperation` | Operations using this RequestBody [0..*].|
| `usedByRequestBodyEntries` | `OPRequestBody` | `value` | `OPRequestBodyEntry` | RequestBodyEntry entries whose value is this RequestBody [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Attribute description from RequestBody [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `required` | `Boolean` | nil | Attribute required from RequestBody [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPRequestBody',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPContentContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPContentContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #directRequestBodies',
		'#description => FMProperty',
		'#required => FMProperty',
		'#usedByOperations => FMMany type: #OPOperation opposite: #requestBody',
		'#usedByRequestBodyEntries => FMMany type: #OPRequestBodyEntry opposite: #value'
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

{ #category : 'adding' }
OPRequestBody >> addUsedByRequestBodyEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByRequestBodyEntries add: anObject
]

{ #category : 'accessing' }
OPRequestBody >> components [
	"Relation named: #components type: #OPComponents opposite: #directRequestBodies"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from RequestBody to Components [0..1], when the object is a reusable one.'>
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
	<FMComment: 'Attribute description from RequestBody [1]'>
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
	<FMComment: 'Attribute required from RequestBody [1]'>
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
	<FMComment: 'Operations using this RequestBody [0..*].'>
	^ usedByOperations
]

{ #category : 'accessing' }
OPRequestBody >> usedByOperations: anObject [

	<ignoreForCoverage>
	<generated>
	usedByOperations value: anObject
]

{ #category : 'accessing' }
OPRequestBody >> usedByRequestBodyEntries [
	"Relation named: #usedByRequestBodyEntries type: #OPRequestBodyEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'RequestBodyEntry entries whose value is this RequestBody [0..*].'>
	^ usedByRequestBodyEntries
]

{ #category : 'accessing' }
OPRequestBody >> usedByRequestBodyEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByRequestBodyEntries value: anObject
]
