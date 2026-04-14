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

	<FMClass: #XMLElement super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPXMLElement >> attribute [

	<FMProperty: #attribute type: #Boolean>
	<generated>
	<FMComment: 'Attribute attribute from XMLElement [1]'>
	^ attribute
]

{ #category : 'accessing' }
OPXMLElement >> attribute: anObject [
	<generated>
	attribute := anObject
]

{ #category : 'accessing' }
OPXMLElement >> namespace [

	<FMProperty: #namespace type: #String>
	<generated>
	<FMComment: 'Attribute namespace from XMLElement [1]'>
	^ namespace
]

{ #category : 'accessing' }
OPXMLElement >> namespace: anObject [
	<generated>
	namespace := anObject
]

{ #category : 'accessing' }
OPXMLElement >> prefix [

	<FMProperty: #prefix type: #String>
	<generated>
	<FMComment: 'Attribute prefix from XMLElement [1]'>
	^ prefix
]

{ #category : 'accessing' }
OPXMLElement >> prefix: anObject [
	<generated>
	prefix := anObject
]

{ #category : 'accessing' }
OPXMLElement >> schema [
	"Relation named: #schema type: #OPSchema opposite: #xml"

	<generated>
	<container>
	<derived>
	^ schema
]

{ #category : 'accessing' }
OPXMLElement >> schema: anObject [

	<generated>
	schema := anObject
]

{ #category : 'navigation' }
OPXMLElement >> schemaGroup [
	<generated>
	<navigation: 'Schema'>
	^ MooseSpecializedGroup with: self schema
]

{ #category : 'accessing' }
OPXMLElement >> wrapped [

	<FMProperty: #wrapped type: #Boolean>
	<generated>
	<FMComment: 'Attribute wrapped from XMLElement [1]'>
	^ wrapped
]

{ #category : 'accessing' }
OPXMLElement >> wrapped: anObject [
	<generated>
	wrapped := anObject
]
