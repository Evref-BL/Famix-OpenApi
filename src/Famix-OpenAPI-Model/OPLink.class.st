"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPLink` | `directLinks` | `OPComponents` | Opposite reference components from Link to Components [0..1], when the object is a reusable one.|
| `response` | `OPLink` | `links` | `OPResponse` | Opposite reference response from Link to Response [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `server` | `OPLink` | `link` | `OPServer` | Reference server from Link to Server [0..1]: server used by the linked operation.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operation` | `OPLink` | `usedByLinks` | `OPOperation` | Reference operation from Link to Operation [0..1]: the linked operation (operationId or operationRef resolved).|
| `usedByLinkEntries` | `OPLink` | `value` | `OPLinkEntry` | LinkEntry entries whose value is this Link [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Attribute description from Link [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `operationId` | `String` | nil | Attribute operationId from Link [1]|
| `operationRef` | `String` | nil | Attribute operationRef from Link [1]|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `requestBody` | `String` | nil | Attribute requestBody from Link [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPLink',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #directLinks',
		'#description => FMProperty',
		'#operation => FMOne type: #OPOperation opposite: #usedByLinks',
		'#operationId => FMProperty',
		'#operationRef => FMProperty',
		'#requestBody => FMProperty',
		'#response => FMOne type: #OPResponse opposite: #links',
		'#server => FMOne type: #OPServer opposite: #link',
		'#usedByLinkEntries => FMMany type: #OPLinkEntry opposite: #value'
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
OPLink >> addUsedByLinkEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByLinkEntries add: anObject
]

{ #category : 'accessing' }
OPLink >> components [
	"Relation named: #components type: #OPComponents opposite: #directLinks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from Link to Components [0..1], when the object is a reusable one.'>
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
	<FMComment: 'Attribute description from Link [1]'>
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
	<FMComment: 'Reference operation from Link to Operation [0..1]: the linked operation (operationId or operationRef resolved).'>
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
	<FMComment: 'Attribute operationId from Link [1]'>
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
	<FMComment: 'Attribute operationRef from Link [1]'>
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
	<FMComment: 'Attribute requestBody from Link [1]'>
	^ requestBody
]

{ #category : 'accessing' }
OPLink >> requestBody: anObject [
	<ignoreForCoverage>
	<generated>
	requestBody := anObject
]

{ #category : 'accessing' }
OPLink >> response [
	"Relation named: #response type: #OPResponse opposite: #links"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference response from Link to Response [0..1].'>
	<container>
	^ response
]

{ #category : 'accessing' }
OPLink >> response: anObject [

	<ignoreForCoverage>
	<generated>
	response := anObject
]

{ #category : 'accessing' }
OPLink >> server [
	"Relation named: #server type: #OPServer opposite: #link"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference server from Link to Server [0..1]: server used by the linked operation.'>
	^ server
]

{ #category : 'accessing' }
OPLink >> server: anObject [

	<ignoreForCoverage>
	<generated>
	server := anObject
]

{ #category : 'accessing' }
OPLink >> usedByLinkEntries [
	"Relation named: #usedByLinkEntries type: #OPLinkEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'LinkEntry entries whose value is this Link [0..*].'>
	^ usedByLinkEntries
]

{ #category : 'accessing' }
OPLink >> usedByLinkEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByLinkEntries value: anObject
]
