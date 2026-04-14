"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `path` | `OPOperation` | `get` | `OPPath` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbacks` | `OPOperation` | `operation` | `OPCallbackEntry` | Reference callbacks from Operation to CallbackEntry [0..*].|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `requestBody` | `OPOperation` | `operation` | `OPRequestBody` | Reference requestBody from Operation to RequestBody [0..1].|
| `responses` | `OPOperation` | `operation` | `OPResponseEntry` | Reference responses from Operation to ResponseEntry [1..*].|
| `security` | `OPSecurityContainer` | `securityContainer` | `OPSecurityRequirement` | Reference security from SecurityContainer to SecurityRequirement [0..*].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |
| `parameters` | `OPOperation` | `operation` | `OPParameter` | Reference parameters from Operation to Parameter [0..*].|
| `path` | `OPOperation` | `put` | `OPPath` | |
| `path` | `OPOperation` | `options` | `OPPath` | |
| `path` | `OPOperation` | `trace` | `OPPath` | |
| `path` | `OPOperation` | `patch` | `OPPath` | |
| `path` | `OPOperation` | `delete` | `OPPath` | |
| `path` | `OPOperation` | `post` | `OPPath` | |
| `path` | `OPOperation` | `head` | `OPPath` | |
| `response` | `OPResponseContainer` | `declaringContext` | `OPResponse` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `consumes` | `Object` | nil | Attribute consumes from Operation [*]|
| `deprecated` | `Boolean` | nil | Attribute deprecated from Operation [1]|
| `description` | `String` | nil | Attribute description from Operation [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `operationId` | `String` | nil | Attribute operationId from Operation [1]|
| `produces` | `Object` | nil | Attribute produces from Operation [*]|
| `schemes` | `Object` | nil | Attribute schemes from Operation [*]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `summary` | `String` | nil | Attribute summary from Operation [1]|
| `tagReferences` | `Object` | nil | Attribute tagReferences from Operation [*]|

"
Class {
	#name : 'OPOperation',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPExternalDocsContainer + OPParameterContainer + OPResponseContainer + OPSecurityContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPExternalDocsContainer classTrait + OPParameterContainer classTrait + OPResponseContainer classTrait + OPSecurityContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#tagReferences => FMProperty',
		'#summary => FMProperty',
		'#description => FMProperty',
		'#operationId => FMProperty',
		'#consumes => FMProperty',
		'#produces => FMProperty',
		'#schemes => FMProperty',
		'#deprecated => FMProperty',
		'#path => FMOne type: #OPPath opposite: #get',
		'#responses => FMMany type: #OPResponseEntry opposite: #operation',
		'#parameters => FMMany type: #OPParameter opposite: #operation',
		'#requestBody => FMOne type: #OPRequestBody opposite: #operation',
		'#callbacks => FMMany type: #OPCallbackEntry opposite: #operation'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPOperation class >> annotation [

	<FMClass: #Operation super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPOperation >> addCallback: anObject [
	<generated>
	^ self callbacks add: anObject
]

{ #category : 'adding' }
OPOperation >> addParameter: anObject [
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPOperation >> addResponse: anObject [
	<generated>
	^ self responses add: anObject
]

{ #category : 'accessing' }
OPOperation >> callbacks [
	"Relation named: #callbacks type: #OPCallbackEntry opposite: #operation"

	<generated>
	<FMComment: 'Reference callbacks from Operation to CallbackEntry [0..*].'>
	<derived>
	^ callbacks
]

{ #category : 'accessing' }
OPOperation >> callbacks: anObject [

	<generated>
	callbacks value: anObject
]

{ #category : 'navigation' }
OPOperation >> callbacksGroup [
	<generated>
	<navigation: 'Callbacks'>
	^ MooseSpecializedGroup withAll: self callbacks asSet
]

{ #category : 'accessing' }
OPOperation >> consumes [

	<FMProperty: #consumes type: #Object>
	<generated>
	<FMComment: 'Attribute consumes from Operation [*]'>
	^ consumes
]

{ #category : 'accessing' }
OPOperation >> consumes: anObject [
	<generated>
	consumes := anObject
]

{ #category : 'accessing' }
OPOperation >> deprecated [

	<FMProperty: #deprecated type: #Boolean>
	<generated>
	<FMComment: 'Attribute deprecated from Operation [1]'>
	^ deprecated
]

{ #category : 'accessing' }
OPOperation >> deprecated: anObject [
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPOperation >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from Operation [1]'>
	^ description
]

{ #category : 'accessing' }
OPOperation >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPOperation >> operationId [

	<FMProperty: #operationId type: #String>
	<generated>
	<FMComment: 'Attribute operationId from Operation [1]'>
	^ operationId
]

{ #category : 'accessing' }
OPOperation >> operationId: anObject [
	<generated>
	operationId := anObject
]

{ #category : 'accessing' }
OPOperation >> parameters [
	"Relation named: #parameters type: #OPParameter opposite: #operation"

	<generated>
	<FMComment: 'Reference parameters from Operation to Parameter [0..*].'>
	<derived>
	^ parameters
]

{ #category : 'accessing' }
OPOperation >> parameters: anObject [

	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPOperation >> path [
	"Relation named: #path type: #OPPath opposite: #get"

	<generated>
	<container>
	<derived>
	^ path
]

{ #category : 'accessing' }
OPOperation >> path: anObject [

	<generated>
	path := anObject
]

{ #category : 'navigation' }
OPOperation >> pathGroup [
	<generated>
	<navigation: 'Path'>
	^ MooseSpecializedGroup with: self path
]

{ #category : 'accessing' }
OPOperation >> produces [

	<FMProperty: #produces type: #Object>
	<generated>
	<FMComment: 'Attribute produces from Operation [*]'>
	^ produces
]

{ #category : 'accessing' }
OPOperation >> produces: anObject [
	<generated>
	produces := anObject
]

{ #category : 'accessing' }
OPOperation >> requestBody [
	"Relation named: #requestBody type: #OPRequestBody opposite: #operation"

	<generated>
	<FMComment: 'Reference requestBody from Operation to RequestBody [0..1].'>
	^ requestBody
]

{ #category : 'accessing' }
OPOperation >> requestBody: anObject [

	<generated>
	requestBody := anObject
]

{ #category : 'navigation' }
OPOperation >> requestBodyGroup [
	<generated>
	<navigation: 'RequestBody'>
	^ MooseSpecializedGroup with: self requestBody
]

{ #category : 'accessing' }
OPOperation >> responses [
	"Relation named: #responses type: #OPResponseEntry opposite: #operation"

	<generated>
	<FMComment: 'Reference responses from Operation to ResponseEntry [1..*].'>
	<derived>
	^ responses
]

{ #category : 'accessing' }
OPOperation >> responses: anObject [

	<generated>
	responses value: anObject
]

{ #category : 'navigation' }
OPOperation >> responsesGroup [
	<generated>
	<navigation: 'Responses'>
	^ MooseSpecializedGroup withAll: self responses asSet
]

{ #category : 'accessing' }
OPOperation >> schemes [

	<FMProperty: #schemes type: #Object>
	<generated>
	<FMComment: 'Attribute schemes from Operation [*]'>
	^ schemes
]

{ #category : 'accessing' }
OPOperation >> schemes: anObject [
	<generated>
	schemes := anObject
]

{ #category : 'accessing' }
OPOperation >> summary [

	<FMProperty: #summary type: #String>
	<generated>
	<FMComment: 'Attribute summary from Operation [1]'>
	^ summary
]

{ #category : 'accessing' }
OPOperation >> summary: anObject [
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPOperation >> tagReferences [

	<FMProperty: #tagReferences type: #Object>
	<generated>
	<FMComment: 'Attribute tagReferences from Operation [*]'>
	^ tagReferences
]

{ #category : 'accessing' }
OPOperation >> tagReferences: anObject [
	<generated>
	tagReferences := anObject
]
