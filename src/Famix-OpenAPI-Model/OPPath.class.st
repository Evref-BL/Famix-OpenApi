"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPPath` | `paths` | `OPApi` | Opposite reference api from Path to API [0..1].|
| `callback` | `OPPath` | `pathItems` | `OPCallback` | Opposite reference callback from Path to Callback [0..1], when the path item is declared by a callback.|
| `components` | `OPPath` | `pathItems` | `OPComponents` | Opposite reference components from Path to Components [0..1], when the path item is a reusable one.|
| `openApi` | `OPPath` | `paths` | `OPOpenApi` | Opposite reference openApi from Path to OpenApi [0..1], when the path item is declared in paths.|
| `webhookOf` | `OPPath` | `webhooks` | `OPOpenApi` | Opposite reference webhookOf from Path to OpenApi [0..1], when the path item is declared in webhooks.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operations` | `OPPath` | `path` | `OPOperation` | Reference operations from Path to Operation [0..*]: one operation per HTTP method.|
| `servers` | `OPPath` | `path` | `OPServer` | Reference servers from Path to Server [0..*]: servers overriding the document ones for this path item.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |
| `parameters` | `OPPath` | `usedByPaths` | `OPParameter` | Reference parameters from Path to Parameter [0..*]. A parameter may be shared by several paths.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `description` | `String` | nil | Attribute description from Path [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `relativePath` | `String` | nil | Attribute relativePath from Path [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `summary` | `String` | nil | Attribute summary from Path [1]|

"
Class {
	#name : 'OPPath',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPParameterContainer + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPParameterContainer classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #paths',
		'#callback => FMOne type: #OPCallback opposite: #pathItems',
		'#components => FMOne type: #OPComponents opposite: #pathItems',
		'#description => FMProperty',
		'#openApi => FMOne type: #OPOpenApi opposite: #paths',
		'#operations => FMMany type: #OPOperation opposite: #path',
		'#parameters => FMMany type: #OPParameter opposite: #usedByPaths',
		'#relativePath => FMProperty',
		'#servers => FMMany type: #OPServer opposite: #path',
		'#summary => FMProperty',
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

{ #category : 'accessing' }
OPPath >> api [
	"Relation named: #api type: #OPApi opposite: #paths"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference api from Path to API [0..1].'>
	<container>
	^ api
]

{ #category : 'accessing' }
OPPath >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPPath >> callback [
	"Relation named: #callback type: #OPCallback opposite: #pathItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference callback from Path to Callback [0..1], when the path item is declared by a callback.'>
	<container>
	^ callback
]

{ #category : 'accessing' }
OPPath >> callback: anObject [

	<ignoreForCoverage>
	<generated>
	callback := anObject
]

{ #category : 'accessing' }
OPPath >> components [
	"Relation named: #components type: #OPComponents opposite: #pathItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from Path to Components [0..1], when the path item is a reusable one.'>
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
	<FMComment: 'Attribute description from Path [1]'>
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
	<FMComment: 'Opposite reference openApi from Path to OpenApi [0..1], when the path item is declared in paths.'>
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
	<FMComment: 'Reference operations from Path to Operation [0..*]: one operation per HTTP method.'>
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
	<FMComment: 'Reference parameters from Path to Parameter [0..*]. A parameter may be shared by several paths.'>
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
	<FMComment: 'Attribute relativePath from Path [1]'>
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
	<FMComment: 'Reference servers from Path to Server [0..*]: servers overriding the document ones for this path item.'>
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
	<FMComment: 'Attribute summary from Path [1]'>
	^ summary
]

{ #category : 'accessing' }
OPPath >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPPath >> webhookOf [
	"Relation named: #webhookOf type: #OPOpenApi opposite: #webhooks"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference webhookOf from Path to OpenApi [0..1], when the path item is declared in webhooks.'>
	<container>
	^ webhookOf
]

{ #category : 'accessing' }
OPPath >> webhookOf: anObject [

	<ignoreForCoverage>
	<generated>
	webhookOf := anObject
]
