"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbackEntry` | `OPCallback` | `value` | `OPCallbackEntry` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPCallback',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#callbackEntry => FMOne type: #OPCallbackEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPCallback class >> annotation [

	<FMClass: #Callback super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPCallback >> callbackEntry [
	"Relation named: #callbackEntry type: #OPCallbackEntry opposite: #value"

	<generated>
	<derived>
	^ callbackEntry
]

{ #category : 'accessing' }
OPCallback >> callbackEntry: anObject [

	<generated>
	callbackEntry := anObject
]
