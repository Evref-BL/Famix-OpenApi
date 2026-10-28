"
A server hosting the API (OpenAPI Server Object), declared at document, path item or operation level.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `link` | `OPServer` | `server` | `OPLink` | Opposite reference link from Server to Link [0..1], when the server is declared by a link.|
| `openApi` | `OPServer` | `servers` | `OPOpenApi` | Opposite reference openApi from Server to OpenApi [0..1], when the server is declared at document level.|
| `operation` | `OPServer` | `servers` | `OPOperation` | Opposite reference operation from Server to Operation [0..1], when the server is declared by an operation.|
| `path` | `OPServer` | `servers` | `OPPath` | Opposite reference path from Server to Path [0..1], when the server is declared by a path item.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `variables` | `OPServer` | `server` | `OPServerVariable` | Reference variables from Server to ServerVariable [0..*]: substitutions of the URL template.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Description of the server [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `url` | `String` | nil | URL template of the server [1].|

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
	<FMComment: 'Description of the server [1].'>
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
	<FMComment: 'Opposite reference link from Server to Link [0..1], when the server is declared by a link.'>
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
	<FMComment: 'Opposite reference openApi from Server to OpenApi [0..1], when the server is declared at document level.'>
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
	<FMComment: 'Opposite reference operation from Server to Operation [0..1], when the server is declared by an operation.'>
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
	<FMComment: 'Opposite reference path from Server to Path [0..1], when the server is declared by a path item.'>
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
	<FMComment: 'URL template of the server [1].'>
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
	<FMComment: 'Reference variables from Server to ServerVariable [0..*]: substitutions of the URL template.'>
	^ variables
]

{ #category : 'accessing' }
OPServer >> variables: anObject [

	<ignoreForCoverage>
	<generated>
	variables value: anObject
]
