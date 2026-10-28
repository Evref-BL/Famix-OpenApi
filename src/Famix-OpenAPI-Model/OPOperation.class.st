"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `path` | `OPOperation` | `operations` | `OPPath` | Opposite reference path from Operation to Path [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbacks` | `OPOperation` | `operation` | `OPCallbackEntry` | Reference callbacks from Operation to CallbackEntry [0..*].|
| `directCallbacks` | `OPOperation` | `operation` | `OPCallback` | Reference directCallbacks from Operation to Callback [0..*]: callbacks the operation may trigger (provisional name of callbacks).|
| `directResponses` | `OPOperation` | `operation` | `OPResponse` | Reference directResponses from Operation to Response [0..*]: responses by status code (provisional name of responses).|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `externalDocumentation` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.|
| `responses` | `OPOperation` | `operation` | `OPResponseEntry` | Reference responses from Operation to ResponseEntry [1..*].|
| `security` | `OPSecurityContainer` | `securityContainer` | `OPSecurityRequirement` | Reference security from SecurityContainer to SecurityRequirement [0..*].|
| `securityRequirements` | `OPOperation` | `operation` | `OPSecurityRequirement` | Reference securityRequirements from Operation to SecurityRequirement [0..*]: security of the operation, overriding the document one.|
| `servers` | `OPOperation` | `operation` | `OPServer` | Reference servers from Operation to Server [0..*]: servers overriding the ones of the path item for this operation.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |
| `parameters` | `OPOperation` | `usedByOperations` | `OPParameter` | Reference parameters from Operation to Parameter [0..*]. A parameter may be shared by several operations.|
| `requestBody` | `OPOperation` | `usedByOperations` | `OPRequestBody` | Reference requestBody from Operation to RequestBody [0..1]. A request body may be shared by several operations.|
| `response` | `OPResponseContainer` | `declaringContext` | `OPResponse` | |
| `usedByLinks` | `OPOperation` | `operation` | `OPLink` | Links targeting this Operation [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `consumes` | `Object` | nil | Attribute consumes from Operation [*]|
| `deprecated` | `Boolean` | nil | Attribute deprecated from Operation [1]|
| `description` | `String` | nil | Attribute description from Operation [1]|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `httpMethod` | `String` | nil | Attribute httpMethod from Operation [1]: lowercase HTTP verb (get, put, post, delete, options, head, patch, trace).|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `operationId` | `String` | nil | Attribute operationId from Operation [1]|
| `produces` | `Object` | nil | Attribute produces from Operation [*]|
| `schemes` | `Object` | nil | Attribute schemes from Operation [*]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `summary` | `String` | nil | Attribute summary from Operation [1]|
| `tagNames` | `String` | #() | Names of the tags of the operation as written in the source [*] (strings). Use #tags to get the Tag entities.|
| `tagReferences` | `Object` | nil | Attribute tagReferences from Operation [*]|

"
Class {
	#name : 'OPOperation',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPExternalDocsContainer + OPParameterContainer + OPResponseContainer + OPSecurityContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPExternalDocsContainer classTrait + OPParameterContainer classTrait + OPResponseContainer classTrait + OPSecurityContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#callbacks => FMMany type: #OPCallbackEntry opposite: #operation',
		'#consumes => FMProperty',
		'#deprecated => FMProperty',
		'#description => FMProperty',
		'#directCallbacks => FMMany type: #OPCallback opposite: #operation',
		'#directResponses => FMMany type: #OPResponse opposite: #operation',
		'#httpMethod => FMProperty',
		'#operationId => FMProperty',
		'#parameters => FMMany type: #OPParameter opposite: #usedByOperations',
		'#path => FMOne type: #OPPath opposite: #operations',
		'#produces => FMProperty',
		'#requestBody => FMOne type: #OPRequestBody opposite: #usedByOperations',
		'#responses => FMMany type: #OPResponseEntry opposite: #operation',
		'#schemes => FMProperty',
		'#securityRequirements => FMMany type: #OPSecurityRequirement opposite: #operation',
		'#servers => FMMany type: #OPServer opposite: #operation',
		'#summary => FMProperty',
		'#tagNames => FMProperty defaultValue: #()',
		'#tagReferences => FMProperty',
		'#usedByLinks => FMMany type: #OPLink opposite: #operation'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPOperation class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Operation super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPOperation >> addCallback: anObject [

	<ignoreForCoverage>
	<generated>
	^ self callbacks add: anObject
]

{ #category : 'adding' }
OPOperation >> addDirectCallback: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directCallbacks add: anObject
]

{ #category : 'adding' }
OPOperation >> addDirectResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directResponses add: anObject
]

{ #category : 'adding' }
OPOperation >> addParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPOperation >> addResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPOperation >> addSecurityRequirement: anObject [

	<ignoreForCoverage>
	<generated>
	^ self securityRequirements add: anObject
]

{ #category : 'adding' }
OPOperation >> addServer: anObject [

	<ignoreForCoverage>
	<generated>
	^ self servers add: anObject
]

{ #category : 'adding' }
OPOperation >> addUsedByLink: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByLinks add: anObject
]

{ #category : 'accessing' }
OPOperation >> callbacks [
	"Relation named: #callbacks type: #OPCallbackEntry opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference callbacks from Operation to CallbackEntry [0..*].'>
	^ callbacks
]

{ #category : 'accessing' }
OPOperation >> callbacks: anObject [

	<ignoreForCoverage>
	<generated>
	callbacks value: anObject
]

{ #category : 'accessing' }
OPOperation >> consumes [

	<FMProperty: #consumes type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute consumes from Operation [*]'>
	^ consumes
]

{ #category : 'accessing' }
OPOperation >> consumes: anObject [
	<ignoreForCoverage>
	<generated>
	consumes := anObject
]

{ #category : 'accessing' }
OPOperation >> deprecated [

	<FMProperty: #deprecated type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute deprecated from Operation [1]'>
	^ deprecated
]

{ #category : 'accessing' }
OPOperation >> deprecated: anObject [
	<ignoreForCoverage>
	<generated>
	deprecated := anObject
]

{ #category : 'accessing' }
OPOperation >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute description from Operation [1]'>
	^ description
]

{ #category : 'accessing' }
OPOperation >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPOperation >> directCallbacks [
	"Relation named: #directCallbacks type: #OPCallback opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directCallbacks from Operation to Callback [0..*]: callbacks the operation may trigger (provisional name of callbacks).'>
	^ directCallbacks
]

{ #category : 'accessing' }
OPOperation >> directCallbacks: anObject [

	<ignoreForCoverage>
	<generated>
	directCallbacks value: anObject
]

{ #category : 'accessing' }
OPOperation >> directResponses [
	"Relation named: #directResponses type: #OPResponse opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directResponses from Operation to Response [0..*]: responses by status code (provisional name of responses).'>
	^ directResponses
]

{ #category : 'accessing' }
OPOperation >> directResponses: anObject [

	<ignoreForCoverage>
	<generated>
	directResponses value: anObject
]

{ #category : 'accessing' }
OPOperation >> httpMethod [

	<FMProperty: #httpMethod type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute httpMethod from Operation [1]: lowercase HTTP verb (get, put, post, delete, options, head, patch, trace).'>
	^ httpMethod
]

{ #category : 'accessing' }
OPOperation >> httpMethod: anObject [
	<ignoreForCoverage>
	<generated>
	httpMethod := anObject
]

{ #category : 'accessing' }
OPOperation >> operationId [

	<FMProperty: #operationId type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute operationId from Operation [1]'>
	^ operationId
]

{ #category : 'accessing' }
OPOperation >> operationId: anObject [
	<ignoreForCoverage>
	<generated>
	operationId := anObject
]

{ #category : 'accessing' }
OPOperation >> parameters [
	"Relation named: #parameters type: #OPParameter opposite: #usedByOperations"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference parameters from Operation to Parameter [0..*]. A parameter may be shared by several operations.'>
	^ parameters
]

{ #category : 'accessing' }
OPOperation >> parameters: anObject [

	<ignoreForCoverage>
	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPOperation >> path [
	"Relation named: #path type: #OPPath opposite: #operations"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference path from Operation to Path [0..1].'>
	<container>
	^ path
]

{ #category : 'accessing' }
OPOperation >> path: anObject [

	<ignoreForCoverage>
	<generated>
	path := anObject
]

{ #category : 'accessing' }
OPOperation >> produces [

	<FMProperty: #produces type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute produces from Operation [*]'>
	^ produces
]

{ #category : 'accessing' }
OPOperation >> produces: anObject [
	<ignoreForCoverage>
	<generated>
	produces := anObject
]

{ #category : 'accessing' }
OPOperation >> requestBody [
	"Relation named: #requestBody type: #OPRequestBody opposite: #usedByOperations"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference requestBody from Operation to RequestBody [0..1]. A request body may be shared by several operations.'>
	^ requestBody
]

{ #category : 'accessing' }
OPOperation >> requestBody: anObject [

	<ignoreForCoverage>
	<generated>
	requestBody := anObject
]

{ #category : 'accessing' }
OPOperation >> responses [
	"Relation named: #responses type: #OPResponseEntry opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference responses from Operation to ResponseEntry [1..*].'>
	^ responses
]

{ #category : 'accessing' }
OPOperation >> responses: anObject [

	<ignoreForCoverage>
	<generated>
	responses value: anObject
]

{ #category : 'accessing' }
OPOperation >> schemes [

	<FMProperty: #schemes type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute schemes from Operation [*]'>
	^ schemes
]

{ #category : 'accessing' }
OPOperation >> schemes: anObject [
	<ignoreForCoverage>
	<generated>
	schemes := anObject
]

{ #category : 'accessing' }
OPOperation >> securityRequirements [
	"Relation named: #securityRequirements type: #OPSecurityRequirement opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securityRequirements from Operation to SecurityRequirement [0..*]: security of the operation, overriding the document one.'>
	^ securityRequirements
]

{ #category : 'accessing' }
OPOperation >> securityRequirements: anObject [

	<ignoreForCoverage>
	<generated>
	securityRequirements value: anObject
]

{ #category : 'accessing' }
OPOperation >> servers [
	"Relation named: #servers type: #OPServer opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference servers from Operation to Server [0..*]: servers overriding the ones of the path item for this operation.'>
	^ servers
]

{ #category : 'accessing' }
OPOperation >> servers: anObject [

	<ignoreForCoverage>
	<generated>
	servers value: anObject
]

{ #category : 'accessing' }
OPOperation >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute summary from Operation [1]'>
	^ summary
]

{ #category : 'accessing' }
OPOperation >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPOperation >> tagNames [

	<FMProperty: #tagNames type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'Names of the tags of the operation as written in the source [*] (strings). Use #tags to get the Tag entities.'>
	^ tagNames ifNil: [ tagNames := #() ]
]

{ #category : 'accessing' }
OPOperation >> tagNames: anObject [
	<ignoreForCoverage>
	<generated>
	tagNames := anObject
]

{ #category : 'accessing' }
OPOperation >> tagReferences [

	<FMProperty: #tagReferences type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute tagReferences from Operation [*]'>
	^ tagReferences
]

{ #category : 'accessing' }
OPOperation >> tagReferences: anObject [
	<ignoreForCoverage>
	<generated>
	tagReferences := anObject
]

{ #category : 'accessing' }
OPOperation >> usedByLinks [
	"Relation named: #usedByLinks type: #OPLink opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Links targeting this Operation [0..*].'>
	^ usedByLinks
]

{ #category : 'accessing' }
OPOperation >> usedByLinks: anObject [

	<ignoreForCoverage>
	<generated>
	usedByLinks value: anObject
]
