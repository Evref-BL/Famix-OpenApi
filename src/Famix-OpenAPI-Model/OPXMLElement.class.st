"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPXMLElement` | `xml` | `OPSchema` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `attribute` | `Boolean` | nil | Attribute attribute from XMLElement [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `namespace` | `String` | nil | Attribute namespace from XMLElement [1]|
| `prefix` | `String` | nil | Attribute prefix from XMLElement [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `wrapped` | `Boolean` | nil | Attribute wrapped from XMLElement [1]|

"
Class {
	#name : 'OPXMLElement',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#namespace => FMProperty',
		'#prefix => FMProperty',
		'#attribute => FMProperty',
		'#wrapped => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #xml'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPXMLElement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #XMLElement super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPXMLElement >> attribute [

	<FMProperty: #attribute type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute attribute from XMLElement [1]'>
	^ attribute
]

{ #category : 'accessing' }
OPXMLElement >> attribute: anObject [
	<ignoreForCoverage>
	<generated>
	attribute := anObject
]

{ #category : 'accessing' }
OPXMLElement >> namespace [

	<FMProperty: #namespace type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute namespace from XMLElement [1]'>
	^ namespace
]

{ #category : 'accessing' }
OPXMLElement >> namespace: anObject [
	<ignoreForCoverage>
	<generated>
	namespace := anObject
]

{ #category : 'accessing' }
OPXMLElement >> prefix [

	<FMProperty: #prefix type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute prefix from XMLElement [1]'>
	^ prefix
]

{ #category : 'accessing' }
OPXMLElement >> prefix: anObject [
	<ignoreForCoverage>
	<generated>
	prefix := anObject
]

{ #category : 'accessing' }
OPXMLElement >> schema [
	"Relation named: #schema type: #OPSchema opposite: #xml"

	<ignoreForCoverage>
	<generated>
	<container>
	^ schema
]

{ #category : 'accessing' }
OPXMLElement >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPXMLElement >> wrapped [

	<FMProperty: #wrapped type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute wrapped from XMLElement [1]'>
	^ wrapped
]

{ #category : 'accessing' }
OPXMLElement >> wrapped: anObject [
	<ignoreForCoverage>
	<generated>
	wrapped := anObject
]
