"
A $ref that cannot be resolved to an entity of the model, for instance a reference to an external document (OpenAPI Reference Object). It is owned by the root OpenApi.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `openApi` | `OPReference` | `unresolvedReferences` | `OPOpenApi` | The document in which the unresolved reference appears.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description overriding the one of the referenced object.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `summary` | `String` | nil | Summary overriding the one of the referenced object.|
| `target` | `String` | nil | The $ref URI that could not be resolved.|

"
Class {
	#name : 'OPReference',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#openApi => FMOne type: #OPOpenApi opposite: #unresolvedReferences',
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
	<FMComment: 'Description overriding the one of the referenced object.'>
	^ description
]

{ #category : 'accessing' }
OPReference >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPReference >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #unresolvedReferences"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The document in which the unresolved reference appears.'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPReference >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPReference >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Summary overriding the one of the referenced object.'>
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
	<FMComment: 'The $ref URI that could not be resolved.'>
	^ target
]

{ #category : 'accessing' }
OPReference >> target: anObject [
	<ignoreForCoverage>
	<generated>
	target := anObject
]
