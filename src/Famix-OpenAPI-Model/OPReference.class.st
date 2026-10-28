"
Placeholder for a $ref that cannot be resolved to an entity of the model, for instance a reference to an external document (OpenAPI Reference Object).

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Description overriding the one of the referenced object [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `summary` | `String` | nil | Summary overriding the one of the referenced object [1].|
| `target` | `String` | nil | The $ref URI that could not be resolved [1].|

"
Class {
	#name : 'OPReference',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#summary => FMProperty',
		'#target => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPReference class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Reference super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPReference >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description overriding the one of the referenced object [1].'>
	^ description
]

{ #category : 'accessing' }
OPReference >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPReference >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Summary overriding the one of the referenced object [1].'>
	^ summary
]

{ #category : 'accessing' }
OPReference >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPReference >> target [

	<FMProperty: #target type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'The $ref URI that could not be resolved [1].'>
	^ target
]

{ #category : 'accessing' }
OPReference >> target: anObject [
	<ignoreForCoverage>
	<generated>
	target := anObject
]
