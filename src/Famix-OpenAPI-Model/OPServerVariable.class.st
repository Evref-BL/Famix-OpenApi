"
A variable substituted in the URL template of a Server (OpenAPI Server Variable Object). Its name is the variable name.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `server` | `OPServerVariable` | `variables` | `OPServer` | Opposite reference server from ServerVariable to Server [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `defaultValue` | `String` | nil | Value used when the variable is not provided [1].|
| `description` | `String` | nil | Description of the server variable [1].|
| `enumValues` | `String` | #() | Allowed values of the server variable [*] (strings).|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPServerVariable',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#defaultValue => FMProperty',
		'#description => FMProperty',
		'#enumValues => FMProperty defaultValue: #()',
		'#server => FMOne type: #OPServer opposite: #variables'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPServerVariable class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ServerVariable super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPServerVariable >> defaultValue [

	<FMProperty: #defaultValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Value used when the variable is not provided [1].'>
	^ defaultValue
]

{ #category : 'accessing' }
OPServerVariable >> defaultValue: anObject [
	<ignoreForCoverage>
	<generated>
	defaultValue := anObject
]

{ #category : 'accessing' }
OPServerVariable >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the server variable [1].'>
	^ description
]

{ #category : 'accessing' }
OPServerVariable >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPServerVariable >> enumValues [

	<FMProperty: #enumValues type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'Allowed values of the server variable [*] (strings).'>
	^ enumValues ifNil: [ enumValues := #() ]
]

{ #category : 'accessing' }
OPServerVariable >> enumValues: anObject [
	<ignoreForCoverage>
	<generated>
	enumValues := anObject
]

{ #category : 'accessing' }
OPServerVariable >> server [
	"Relation named: #server type: #OPServer opposite: #variables"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference server from ServerVariable to Server [0..1].'>
	<container>
	^ server
]

{ #category : 'accessing' }
OPServerVariable >> server: anObject [

	<ignoreForCoverage>
	<generated>
	server := anObject
]
