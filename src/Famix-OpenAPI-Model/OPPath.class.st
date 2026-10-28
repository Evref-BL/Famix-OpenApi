"
A path item (OpenAPI Path Item Object): the operations available on one relative path, declared in the paths, in the webhooks, in a callback or among the reusable path items. A path item may be shared by several callbacks.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPPath` | `pathItems` | `OPComponents` | The components owning the object, when it is a reusable one.|
| `openApi` | `OPPath` | `paths` | `OPOpenApi` | The document declaring the path item in its paths.|
| `webhookOf` | `OPPath` | `webhooks` | `OPOpenApi` | The document declaring the path item in its webhooks.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operations` | `OPPath` | `path` | `OPOperation` | Operations of the path item, one per HTTP method.|
| `servers` | `OPPath` | `path` | `OPServer` | Servers overriding the ones of the document for this path item.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameters` | `OPPath` | `usedByPaths` | `OPParameter` | Parameters shared by all the operations of the path item. A parameter may be shared by several paths.|
| `usedByCallbacks` | `OPPath` | `pathItems` | `OPCallback` | Callbacks using this path item.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of the path item.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|
| `relativePath` | `String` | nil | Relative path of the path item, for example /pets/{petId}.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `summary` | `String` | nil | Short summary of the path item.|

"
Class {
	#name : 'OPPath',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #pathItems',
		'#description => FMProperty',
		'#openApi => FMOne type: #OPOpenApi opposite: #paths',
		'#operations => FMMany type: #OPOperation opposite: #path',
		'#parameters => FMMany type: #OPParameter opposite: #usedByPaths',
		'#relativePath => FMProperty',
		'#servers => FMMany type: #OPServer opposite: #path',
		'#summary => FMProperty',
		'#usedByCallbacks => FMMany type: #OPCallback opposite: #pathItems',
		'#webhookOf => FMOne type: #OPOpenApi opposite: #webhooks'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPPath class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Path super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPPath >> addOperation: anObject [

	<ignoreForCoverage>
	<generated>
	^ self operations add: anObject
]

{ #category : 'adding' }
OPPath >> addParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPPath >> addServer: anObject [

	<ignoreForCoverage>
	<generated>
	^ self servers add: anObject
]

{ #category : 'adding' }
OPPath >> addUsedByCallback: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByCallbacks add: anObject
]

{ #category : 'accessing' }
OPPath >> components [
	"Relation named: #components type: #OPComponents opposite: #pathItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components owning the object, when it is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPPath >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPPath >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of the path item.'>
	^ description
]

{ #category : 'accessing' }
OPPath >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPPath >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #paths"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The document declaring the path item in its paths.'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPPath >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPPath >> operations [
	"Relation named: #operations type: #OPOperation opposite: #path"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Operations of the path item, one per HTTP method.'>
	^ operations
]

{ #category : 'accessing' }
OPPath >> operations: anObject [

	<ignoreForCoverage>
	<generated>
	operations value: anObject
]

{ #category : 'accessing' }
OPPath >> parameters [
	"Relation named: #parameters type: #OPParameter opposite: #usedByPaths"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Parameters shared by all the operations of the path item. A parameter may be shared by several paths.'>
	^ parameters
]

{ #category : 'accessing' }
OPPath >> parameters: anObject [

	<ignoreForCoverage>
	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPPath >> relativePath [

	<FMProperty: #relativePath type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Relative path of the path item, for example /pets/{petId}.'>
	^ relativePath
]

{ #category : 'accessing' }
OPPath >> relativePath: anObject [
	<ignoreForCoverage>
	<generated>
	relativePath := anObject
]

{ #category : 'accessing' }
OPPath >> servers [
	"Relation named: #servers type: #OPServer opposite: #path"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Servers overriding the ones of the document for this path item.'>
	^ servers
]

{ #category : 'accessing' }
OPPath >> servers: anObject [

	<ignoreForCoverage>
	<generated>
	servers value: anObject
]

{ #category : 'accessing' }
OPPath >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Short summary of the path item.'>
	^ summary
]

{ #category : 'accessing' }
OPPath >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPPath >> usedByCallbacks [
	"Relation named: #usedByCallbacks type: #OPCallback opposite: #pathItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Callbacks using this path item.'>
	^ usedByCallbacks
]

{ #category : 'accessing' }
OPPath >> usedByCallbacks: anObject [

	<ignoreForCoverage>
	<generated>
	usedByCallbacks value: anObject
]

{ #category : 'accessing' }
OPPath >> webhookOf [
	"Relation named: #webhookOf type: #OPOpenApi opposite: #webhooks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The document declaring the path item in its webhooks.'>
	<container>
	^ webhookOf
]

{ #category : 'accessing' }
OPPath >> webhookOf: anObject [

	<ignoreForCoverage>
	<generated>
	webhookOf := anObject
]
