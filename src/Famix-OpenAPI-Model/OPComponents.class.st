"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPComponents` | `components` | `OPApi` | Opposite reference api from Components to API [0..1].|
| `openApi` | `OPComponents` | `components` | `OPOpenApi` | Opposite reference openApi from Components to OpenApi [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbacks` | `OPComponents` | `components` | `OPCallbackEntry` | Reference callbacks from Components to CallbackEntry [0..*].|
| `directCallbacks` | `OPComponents` | `components` | `OPCallback` | Reference directCallbacks from Components to Callback [0..*]: reusable callbacks (provisional name of callbacks).|
| `directExamples` | `OPComponents` | `components` | `OPExample` | Reference directExamples from Components to Example [0..*]: reusable examples (provisional name of examples).|
| `directHeaders` | `OPComponents` | `components` | `OPHeader` | Reference directHeaders from Components to Header [0..*]: reusable headers (provisional name of headers).|
| `directLinks` | `OPComponents` | `components` | `OPLink` | Reference directLinks from Components to Link [0..*]: reusable links (provisional name of links).|
| `directParameters` | `OPComponents` | `components` | `OPParameter` | Reference directParameters from Components to Parameter [0..*]: reusable parameters (provisional name of parameters).|
| `directRequestBodies` | `OPComponents` | `components` | `OPRequestBody` | Reference directRequestBodies from Components to RequestBody [0..*]: reusable request bodies (provisional name of requestBodies).|
| `directResponses` | `OPComponents` | `components` | `OPResponse` | Reference directResponses from Components to Response [0..*]: reusable responses (provisional name of responses).|
| `directSchemas` | `OPComponents` | `components` | `OPSchema` | Reference directSchemas from Components to Schema [0..*]: reusable schemas (provisional name of schemas).|
| `directSecuritySchemes` | `OPComponents` | `components` | `OPSecurityScheme` | Reference directSecuritySchemes from Components to SecurityScheme [0..*]: reusable security schemes (provisional name of securitySchemes).|
| `examples` | `OPComponents` | `components` | `OPExampleEntry` | Reference examples from Components to ExampleEntry [0..*].|
| `headers` | `OPComponents` | `components` | `OPHeaderEntry` | Reference headers from Components to HeaderEntry [0..*].|
| `links` | `OPComponents` | `components` | `OPLinkEntry` | Reference links from Components to LinkEntry [0..*].|
| `parameters` | `OPComponents` | `components` | `OPParameterEntry` | Reference parameters from Components to ParameterEntry [0..*].|
| `pathItems` | `OPComponents` | `components` | `OPPath` | Reference pathItems from Components to Path [0..*]: reusable path items.|
| `requestBodies` | `OPComponents` | `components` | `OPRequestBodyEntry` | Reference requestBodies from Components to RequestBodyEntry [0..*].|
| `responses` | `OPComponents` | `components` | `OPResponseDefinitionEntry` | Reference responses from Components to ResponseDefinitionEntry [0..*].|
| `schemas` | `OPComponents` | `components` | `OPSchemaEntry` | Reference schemas from Components to SchemaEntry [0..*].|
| `securitySchemes` | `OPComponents` | `components` | `OPSecuritySchemeEntry` | Reference securitySchemes from Components to SecuritySchemeEntry [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPComponents',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #components',
		'#callbacks => FMMany type: #OPCallbackEntry opposite: #components',
		'#directCallbacks => FMMany type: #OPCallback opposite: #components',
		'#directExamples => FMMany type: #OPExample opposite: #components',
		'#directHeaders => FMMany type: #OPHeader opposite: #components',
		'#directLinks => FMMany type: #OPLink opposite: #components',
		'#directParameters => FMMany type: #OPParameter opposite: #components',
		'#directRequestBodies => FMMany type: #OPRequestBody opposite: #components',
		'#directResponses => FMMany type: #OPResponse opposite: #components',
		'#directSchemas => FMMany type: #OPSchema opposite: #components',
		'#directSecuritySchemes => FMMany type: #OPSecurityScheme opposite: #components',
		'#examples => FMMany type: #OPExampleEntry opposite: #components',
		'#headers => FMMany type: #OPHeaderEntry opposite: #components',
		'#links => FMMany type: #OPLinkEntry opposite: #components',
		'#openApi => FMOne type: #OPOpenApi opposite: #components',
		'#parameters => FMMany type: #OPParameterEntry opposite: #components',
		'#pathItems => FMMany type: #OPPath opposite: #components',
		'#requestBodies => FMMany type: #OPRequestBodyEntry opposite: #components',
		'#responses => FMMany type: #OPResponseDefinitionEntry opposite: #components',
		'#schemas => FMMany type: #OPSchemaEntry opposite: #components',
		'#securitySchemes => FMMany type: #OPSecuritySchemeEntry opposite: #components'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPComponents class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Components super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPComponents >> addCallback: anObject [

	<ignoreForCoverage>
	<generated>
	^ self callbacks add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectCallback: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directCallbacks add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directExamples add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectHeader: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directHeaders add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectLink: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directLinks add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directParameters add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectRequestBody: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directRequestBodies add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directResponses add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectSchema: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directSchemas add: anObject
]

{ #category : 'adding' }
OPComponents >> addDirectSecurityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	^ self directSecuritySchemes add: anObject
]

{ #category : 'adding' }
OPComponents >> addExample: anObject [

	<ignoreForCoverage>
	<generated>
	^ self examples add: anObject
]

{ #category : 'adding' }
OPComponents >> addHeader: anObject [

	<ignoreForCoverage>
	<generated>
	^ self headers add: anObject
]

{ #category : 'adding' }
OPComponents >> addLink: anObject [

	<ignoreForCoverage>
	<generated>
	^ self links add: anObject
]

{ #category : 'adding' }
OPComponents >> addParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPComponents >> addPathItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self pathItems add: anObject
]

{ #category : 'adding' }
OPComponents >> addRequestBody: anObject [

	<ignoreForCoverage>
	<generated>
	^ self requestBodies add: anObject
]

{ #category : 'adding' }
OPComponents >> addResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPComponents >> addSchema: anObject [

	<ignoreForCoverage>
	<generated>
	^ self schemas add: anObject
]

{ #category : 'adding' }
OPComponents >> addSecurityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	^ self securitySchemes add: anObject
]

{ #category : 'accessing' }
OPComponents >> api [
	"Relation named: #api type: #OPApi opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference api from Components to API [0..1].'>
	<container>
	^ api
]

{ #category : 'accessing' }
OPComponents >> api: anObject [

	<ignoreForCoverage>
	<generated>
	api := anObject
]

{ #category : 'accessing' }
OPComponents >> callbacks [
	"Relation named: #callbacks type: #OPCallbackEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference callbacks from Components to CallbackEntry [0..*].'>
	^ callbacks
]

{ #category : 'accessing' }
OPComponents >> callbacks: anObject [

	<ignoreForCoverage>
	<generated>
	callbacks value: anObject
]

{ #category : 'accessing' }
OPComponents >> directCallbacks [
	"Relation named: #directCallbacks type: #OPCallback opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directCallbacks from Components to Callback [0..*]: reusable callbacks (provisional name of callbacks).'>
	^ directCallbacks
]

{ #category : 'accessing' }
OPComponents >> directCallbacks: anObject [

	<ignoreForCoverage>
	<generated>
	directCallbacks value: anObject
]

{ #category : 'accessing' }
OPComponents >> directExamples [
	"Relation named: #directExamples type: #OPExample opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directExamples from Components to Example [0..*]: reusable examples (provisional name of examples).'>
	^ directExamples
]

{ #category : 'accessing' }
OPComponents >> directExamples: anObject [

	<ignoreForCoverage>
	<generated>
	directExamples value: anObject
]

{ #category : 'accessing' }
OPComponents >> directHeaders [
	"Relation named: #directHeaders type: #OPHeader opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directHeaders from Components to Header [0..*]: reusable headers (provisional name of headers).'>
	^ directHeaders
]

{ #category : 'accessing' }
OPComponents >> directHeaders: anObject [

	<ignoreForCoverage>
	<generated>
	directHeaders value: anObject
]

{ #category : 'accessing' }
OPComponents >> directLinks [
	"Relation named: #directLinks type: #OPLink opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directLinks from Components to Link [0..*]: reusable links (provisional name of links).'>
	^ directLinks
]

{ #category : 'accessing' }
OPComponents >> directLinks: anObject [

	<ignoreForCoverage>
	<generated>
	directLinks value: anObject
]

{ #category : 'accessing' }
OPComponents >> directParameters [
	"Relation named: #directParameters type: #OPParameter opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directParameters from Components to Parameter [0..*]: reusable parameters (provisional name of parameters).'>
	^ directParameters
]

{ #category : 'accessing' }
OPComponents >> directParameters: anObject [

	<ignoreForCoverage>
	<generated>
	directParameters value: anObject
]

{ #category : 'accessing' }
OPComponents >> directRequestBodies [
	"Relation named: #directRequestBodies type: #OPRequestBody opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directRequestBodies from Components to RequestBody [0..*]: reusable request bodies (provisional name of requestBodies).'>
	^ directRequestBodies
]

{ #category : 'accessing' }
OPComponents >> directRequestBodies: anObject [

	<ignoreForCoverage>
	<generated>
	directRequestBodies value: anObject
]

{ #category : 'accessing' }
OPComponents >> directResponses [
	"Relation named: #directResponses type: #OPResponse opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directResponses from Components to Response [0..*]: reusable responses (provisional name of responses).'>
	^ directResponses
]

{ #category : 'accessing' }
OPComponents >> directResponses: anObject [

	<ignoreForCoverage>
	<generated>
	directResponses value: anObject
]

{ #category : 'accessing' }
OPComponents >> directSchemas [
	"Relation named: #directSchemas type: #OPSchema opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directSchemas from Components to Schema [0..*]: reusable schemas (provisional name of schemas).'>
	^ directSchemas
]

{ #category : 'accessing' }
OPComponents >> directSchemas: anObject [

	<ignoreForCoverage>
	<generated>
	directSchemas value: anObject
]

{ #category : 'accessing' }
OPComponents >> directSecuritySchemes [
	"Relation named: #directSecuritySchemes type: #OPSecurityScheme opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference directSecuritySchemes from Components to SecurityScheme [0..*]: reusable security schemes (provisional name of securitySchemes).'>
	^ directSecuritySchemes
]

{ #category : 'accessing' }
OPComponents >> directSecuritySchemes: anObject [

	<ignoreForCoverage>
	<generated>
	directSecuritySchemes value: anObject
]

{ #category : 'accessing' }
OPComponents >> examples [
	"Relation named: #examples type: #OPExampleEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference examples from Components to ExampleEntry [0..*].'>
	^ examples
]

{ #category : 'accessing' }
OPComponents >> examples: anObject [

	<ignoreForCoverage>
	<generated>
	examples value: anObject
]

{ #category : 'accessing' }
OPComponents >> headers [
	"Relation named: #headers type: #OPHeaderEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference headers from Components to HeaderEntry [0..*].'>
	^ headers
]

{ #category : 'accessing' }
OPComponents >> headers: anObject [

	<ignoreForCoverage>
	<generated>
	headers value: anObject
]

{ #category : 'accessing' }
OPComponents >> links [
	"Relation named: #links type: #OPLinkEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference links from Components to LinkEntry [0..*].'>
	^ links
]

{ #category : 'accessing' }
OPComponents >> links: anObject [

	<ignoreForCoverage>
	<generated>
	links value: anObject
]

{ #category : 'accessing' }
OPComponents >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference openApi from Components to OpenApi [0..1].'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPComponents >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPComponents >> parameters [
	"Relation named: #parameters type: #OPParameterEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference parameters from Components to ParameterEntry [0..*].'>
	^ parameters
]

{ #category : 'accessing' }
OPComponents >> parameters: anObject [

	<ignoreForCoverage>
	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPComponents >> pathItems [
	"Relation named: #pathItems type: #OPPath opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference pathItems from Components to Path [0..*]: reusable path items.'>
	^ pathItems
]

{ #category : 'accessing' }
OPComponents >> pathItems: anObject [

	<ignoreForCoverage>
	<generated>
	pathItems value: anObject
]

{ #category : 'accessing' }
OPComponents >> requestBodies [
	"Relation named: #requestBodies type: #OPRequestBodyEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference requestBodies from Components to RequestBodyEntry [0..*].'>
	^ requestBodies
]

{ #category : 'accessing' }
OPComponents >> requestBodies: anObject [

	<ignoreForCoverage>
	<generated>
	requestBodies value: anObject
]

{ #category : 'accessing' }
OPComponents >> responses [
	"Relation named: #responses type: #OPResponseDefinitionEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference responses from Components to ResponseDefinitionEntry [0..*].'>
	^ responses
]

{ #category : 'accessing' }
OPComponents >> responses: anObject [

	<ignoreForCoverage>
	<generated>
	responses value: anObject
]

{ #category : 'accessing' }
OPComponents >> schemas [
	"Relation named: #schemas type: #OPSchemaEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference schemas from Components to SchemaEntry [0..*].'>
	^ schemas
]

{ #category : 'accessing' }
OPComponents >> schemas: anObject [

	<ignoreForCoverage>
	<generated>
	schemas value: anObject
]

{ #category : 'accessing' }
OPComponents >> securitySchemes [
	"Relation named: #securitySchemes type: #OPSecuritySchemeEntry opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securitySchemes from Components to SecuritySchemeEntry [0..*].'>
	^ securitySchemes
]

{ #category : 'accessing' }
OPComponents >> securitySchemes: anObject [

	<ignoreForCoverage>
	<generated>
	securitySchemes value: anObject
]
