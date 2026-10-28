"
An HTTP operation of a path item (OpenAPI Operation Object): one verb on one path, with its parameters, request body, responses, callbacks and security.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `path` | `OPOperation` | `operations` | `OPPath` | The path item declaring the operation.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbacks` | `OPOperation` | `operation` | `OPCallback` | Callbacks the operation may trigger.|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | External documentation of the entity.|
| `responses` | `OPOperation` | `operation` | `OPResponse` | Responses of the operation, one per status code.|
| `securityRequirements` | `OPOperation` | `operation` | `OPSecurityRequirement` | Security requirements of the operation, as alternatives; they replace the ones of the document. See #effectiveSecurity.|
| `servers` | `OPOperation` | `operation` | `OPServer` | Servers overriding the ones of the path item for this operation.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameters` | `OPOperation` | `usedByOperations` | `OPParameter` | Parameters of the operation. A parameter may be shared by several operations.|
| `requestBody` | `OPOperation` | `usedByOperations` | `OPRequestBody` | Request body accepted by the operation. A request body may be shared by several operations.|
| `usedByLinks` | `OPOperation` | `operation` | `OPLink` | Links targeting this operation.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `deprecated` | `Boolean` | nil | Whether the operation is deprecated.|
| `description` | `String` | nil | Description of the operation.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `httpMethod` | `String` | nil | Lowercase HTTP verb of the operation: get, put, post, delete, options, head, patch or trace.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `operationId` | `String` | nil | Unique identifier of the operation in the document.|
| `securityDisabled` | `Boolean` | false | True when the operation explicitly disables the security of the document (security: [] in the source); false otherwise. See #effectiveSecurity.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `summary` | `String` | nil | Short summary of the operation.|
| `tagNames` | `String` | #() | Names of the tags of the operation as written in the source. Use #tags to get the Tag entities.|

"
Class {
	#name : 'OPOperation',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPExternalDocsContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPExternalDocsContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#callbacks => FMMany type: #OPCallback opposite: #operation',
		'#deprecated => FMProperty',
		'#description => FMProperty',
		'#httpMethod => FMProperty',
		'#operationId => FMProperty',
		'#parameters => FMMany type: #OPParameter opposite: #usedByOperations',
		'#path => FMOne type: #OPPath opposite: #operations',
		'#requestBody => FMOne type: #OPRequestBody opposite: #usedByOperations',
		'#responses => FMMany type: #OPResponse opposite: #operation',
		'#securityDisabled => FMProperty defaultValue: false',
		'#securityRequirements => FMMany type: #OPSecurityRequirement opposite: #operation',
		'#servers => FMMany type: #OPServer opposite: #operation',
		'#summary => FMProperty',
		'#tagNames => FMProperty defaultValue: #()',
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
	"Relation named: #callbacks type: #OPCallback opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Callbacks the operation may trigger.'>
	^ callbacks
]

{ #category : 'accessing' }
OPOperation >> callbacks: anObject [

	<ignoreForCoverage>
	<generated>
	callbacks value: anObject
]

{ #category : 'accessing' }
OPOperation >> deprecated [

	<FMProperty: #deprecated type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the operation is deprecated.'>
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
	<FMComment: 'Description of the operation.'>
	^ description
]

{ #category : 'accessing' }
OPOperation >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPOperation >> httpMethod [

	<FMProperty: #httpMethod type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Lowercase HTTP verb of the operation: get, put, post, delete, options, head, patch or trace.'>
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
	<FMComment: 'Unique identifier of the operation in the document.'>
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
	<FMComment: 'Parameters of the operation. A parameter may be shared by several operations.'>
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
	<FMComment: 'The path item declaring the operation.'>
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
OPOperation >> requestBody [
	"Relation named: #requestBody type: #OPRequestBody opposite: #usedByOperations"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Request body accepted by the operation. A request body may be shared by several operations.'>
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
	"Relation named: #responses type: #OPResponse opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Responses of the operation, one per status code.'>
	^ responses
]

{ #category : 'accessing' }
OPOperation >> responses: anObject [

	<ignoreForCoverage>
	<generated>
	responses value: anObject
]

{ #category : 'accessing' }
OPOperation >> securityDisabled [

	<FMProperty: #securityDisabled type: #Boolean defaultValue: false>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'True when the operation explicitly disables the security of the document (security: [] in the source); false otherwise. See #effectiveSecurity.'>
	^ securityDisabled ifNil: [ securityDisabled := false ]
]

{ #category : 'accessing' }
OPOperation >> securityDisabled: anObject [
	<ignoreForCoverage>
	<generated>
	securityDisabled := anObject
]

{ #category : 'accessing' }
OPOperation >> securityRequirements [
	"Relation named: #securityRequirements type: #OPSecurityRequirement opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Security requirements of the operation, as alternatives; they replace the ones of the document. See #effectiveSecurity.'>
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
	<FMComment: 'Servers overriding the ones of the path item for this operation.'>
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
	<FMComment: 'Short summary of the operation.'>
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
	<FMComment: 'Names of the tags of the operation as written in the source. Use #tags to get the Tag entities.'>
	^ tagNames ifNil: [ tagNames := #() ]
]

{ #category : 'accessing' }
OPOperation >> tagNames: anObject [
	<ignoreForCoverage>
	<generated>
	tagNames := anObject
]

{ #category : 'accessing' }
OPOperation >> usedByLinks [
	"Relation named: #usedByLinks type: #OPLink opposite: #operation"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Links targeting this operation.'>
	^ usedByLinks
]

{ #category : 'accessing' }
OPOperation >> usedByLinks: anObject [

	<ignoreForCoverage>
	<generated>
	usedByLinks value: anObject
]
