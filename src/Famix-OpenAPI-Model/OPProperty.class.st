"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPProperty` | `properties` | `OPSchema` | Opposite reference schema from Property to Schema [0..1].|
| `valueSchema` | `OPProperty` | `-` | `OPSchema` | Reference valueSchema from Property to Schema [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `enum` | `Object` | nil | Attribute enum from Property [*] (array of strings)|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `required` | `Boolean` | nil | Attribute required from Property [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPProperty',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#enum => FMProperty',
		'#required => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #properties',
		'#valueSchema => FMOne type: #OPSchema'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPProperty class >> annotation [

	<FMClass: #Property super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPProperty >> enum [

	<FMProperty: #enum type: #Object>
	<generated>
	<FMComment: 'Attribute enum from Property [*] (array of strings)'>
	^ enum
]

{ #category : 'accessing' }
OPProperty >> enum: anObject [
	<generated>
	enum := anObject
]

{ #category : 'accessing' }
OPProperty >> required [

	<FMProperty: #required type: #Boolean>
	<generated>
	<FMComment: 'Attribute required from Property [1]'>
	^ required
]

{ #category : 'accessing' }
OPProperty >> required: anObject [
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPProperty >> schema [
	"Relation named: #schema type: #OPSchema opposite: #properties"

	<generated>
	<FMComment: 'Opposite reference schema from Property to Schema [0..1].'>
	<container>
	^ schema
]

{ #category : 'accessing' }
OPProperty >> schema: anObject [

	<generated>
	schema := anObject
]

{ #category : 'navigation' }
OPProperty >> schemaGroup [
	<generated>
	<navigation: 'Schema'>
	^ MooseSpecializedGroup with: self schema
]

{ #category : 'accessing' }
OPProperty >> valueSchema [
	"Relation named: #valueSchema type: #OPSchema opposite: #none"

	<generated>
	<FMComment: 'Reference valueSchema from Property to Schema [0..1].'>
	^ valueSchema
]

{ #category : 'accessing' }
OPProperty >> valueSchema: anObject [

	<generated>
	valueSchema := anObject
]

{ #category : 'navigation' }
OPProperty >> valueSchemaGroup [
	<generated>
	<navigation: 'ValueSchema'>
	^ MooseSpecializedGroup with: self valueSchema
]
