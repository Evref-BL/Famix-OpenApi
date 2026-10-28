"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPCallback` | `directCallbacks` | `OPComponents` | Opposite reference components from Callback to Components [0..1], when the object is a reusable one.|
| `operation` | `OPCallback` | `directCallbacks` | `OPOperation` | Opposite reference operation from Callback to Operation [0..1], when the callback is declared inline by an operation.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `pathItems` | `OPCallback` | `callback` | `OPPath` | Reference pathItems from Callback to Path [0..*]: path items describing the requests sent to the callback URL expressions.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByCallbackEntries` | `OPCallback` | `value` | `OPCallbackEntry` | CallbackEntry entries whose value is this Callback [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPCallback',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #directCallbacks',
		'#operation => FMOne type: #OPOperation opposite: #directCallbacks',
		'#pathItems => FMMany type: #OPPath opposite: #callback',
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
OPCallback >> addPathItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self pathItems add: anObject
]

{ #category : 'adding' }
OPCallback >> addUsedByCallbackEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByCallbackEntries add: anObject
]

{ #category : 'accessing' }
OPCallback >> components [
	"Relation named: #components type: #OPComponents opposite: #directCallbacks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from Callback to Components [0..1], when the object is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPCallback >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPCallback >> operation [
	"Relation named: #operation type: #OPOperation opposite: #directCallbacks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference operation from Callback to Operation [0..1], when the callback is declared inline by an operation.'>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPCallback >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPCallback >> pathItems [
	"Relation named: #pathItems type: #OPPath opposite: #callback"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference pathItems from Callback to Path [0..*]: path items describing the requests sent to the callback URL expressions.'>
	^ pathItems
]

{ #category : 'accessing' }
OPCallback >> pathItems: anObject [

	<ignoreForCoverage>
	<generated>
	pathItems value: anObject
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
