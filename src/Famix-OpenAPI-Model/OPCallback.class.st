"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByCallbackEntries` | `OPCallback` | `value` | `OPCallbackEntry` | CallbackEntry entries whose value is this Callback [0..*].|


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
		'#usedByCallbackEntries => FMMany type: #OPCallbackEntry opposite: #value'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPCallback class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Callback super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPCallback >> addUsedByCallbackEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByCallbackEntries add: anObject
]

{ #category : 'accessing' }
OPCallback >> usedByCallbackEntries [
	"Relation named: #usedByCallbackEntries type: #OPCallbackEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'CallbackEntry entries whose value is this Callback [0..*].'>
	^ usedByCallbackEntries
]

{ #category : 'accessing' }
OPCallback >> usedByCallbackEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByCallbackEntries value: anObject
]
