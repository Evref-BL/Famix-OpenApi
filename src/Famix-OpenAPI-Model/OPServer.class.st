"
A server hosting the API (OpenAPI Server Object), declared at document, path item, operation or link level.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `link` | `OPServer` | `server` | `OPLink` | The link declaring the server.|
| `openApi` | `OPServer` | `servers` | `OPOpenApi` | The document declaring the server, when it is declared at document level.|
| `operation` | `OPServer` | `servers` | `OPOperation` | The operation declaring the server.|
| `path` | `OPServer` | `servers` | `OPPath` | The path item declaring the server.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `variables` | `OPServer` | `server` | `OPServerVariable` | Variables substituted in the URL template of the server.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the server.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `url` | `String` | nil | URL template of the server.|

"
Class {
	#name : 'OPServer',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#link => FMOne type: #OPLink opposite: #server',
		'#openApi => FMOne type: #OPOpenApi opposite: #servers',
		'#operation => FMOne type: #OPOperation opposite: #servers',
		'#path => FMOne type: #OPPath opposite: #servers',
		'#url => FMProperty',
		'#variables => FMMany type: #OPServerVariable opposite: #server'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPServer class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Server super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPServer >> addVariable: anObject [

	<ignoreForCoverage>
	<generated>
	^ self variables add: anObject
]

{ #category : 'accessing' }
OPServer >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the server.'>
	^ description
]

{ #category : 'accessing' }
OPServer >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPServer >> link [
	"Relation named: #link type: #OPLink opposite: #server"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The link declaring the server.'>
	<container>
	^ link
]

{ #category : 'accessing' }
OPServer >> link: anObject [

	<ignoreForCoverage>
	<generated>
	link := anObject
]

{ #category : 'accessing' }
OPServer >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #servers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The document declaring the server, when it is declared at document level.'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPServer >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPServer >> operation [
	"Relation named: #operation type: #OPOperation opposite: #servers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The operation declaring the server.'>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPServer >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPServer >> path [
	"Relation named: #path type: #OPPath opposite: #servers"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The path item declaring the server.'>
	<container>
	^ path
]

{ #category : 'accessing' }
OPServer >> path: anObject [

	<ignoreForCoverage>
	<generated>
	path := anObject
]

{ #category : 'accessing' }
OPServer >> url [

	<FMProperty: #url type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL template of the server.'>
	^ url
]

{ #category : 'accessing' }
OPServer >> url: anObject [
	<ignoreForCoverage>
	<generated>
	url := anObject
]

{ #category : 'accessing' }
OPServer >> variables [
	"Relation named: #variables type: #OPServerVariable opposite: #server"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Variables substituted in the URL template of the server.'>
	^ variables
]

{ #category : 'accessing' }
OPServer >> variables: anObject [

	<ignoreForCoverage>
	<generated>
	variables value: anObject
]
