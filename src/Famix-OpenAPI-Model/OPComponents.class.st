"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `api` | `OPComponents` | `components` | `OPApi` | Opposite reference api from Components to API [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbacks` | `OPComponents` | `components` | `OPCallbackEntry` | Reference callbacks from Components to CallbackEntry [0..*].|
| `examples` | `OPComponents` | `components` | `OPExampleEntry` | Reference examples from Components to ExampleEntry [0..*].|
| `headers` | `OPComponents` | `components` | `OPHeaderEntry` | Reference headers from Components to HeaderEntry [0..*].|
| `links` | `OPComponents` | `components` | `OPLinkEntry` | Reference links from Components to LinkEntry [0..*].|
| `parameters` | `OPComponents` | `components` | `OPParameterEntry` | Reference parameters from Components to ParameterEntry [0..*].|
| `requestBodies` | `OPComponents` | `components` | `OPRequestBodyEntry` | Reference requestBodies from Components to RequestBodyEntry [0..*].|
| `responses` | `OPComponents` | `components` | `OPResponseDefinitionEntry` | Reference responses from Components to ResponseDefinitionEntry [0..*].|
| `schemas` | `OPComponents` | `components` | `OPSchemaEntry` | Reference schemas from Components to SchemaEntry [0..*].|
| `securitySchemes` | `OPComponents` | `components` | `OPSecuritySchemeEntry` | Reference securitySchemes from Components to SecuritySchemeEntry [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPComponents',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#api => FMOne type: #OPApi opposite: #components',
		'#schemas => FMMany type: #OPSchemaEntry opposite: #components',
		'#responses => FMMany type: #OPResponseDefinitionEntry opposite: #components',
		'#parameters => FMMany type: #OPParameterEntry opposite: #components',
		'#securitySchemes => FMMany type: #OPSecuritySchemeEntry opposite: #components',
		'#requestBodies => FMMany type: #OPRequestBodyEntry opposite: #components',
		'#headers => FMMany type: #OPHeaderEntry opposite: #components',
		'#examples => FMMany type: #OPExampleEntry opposite: #components',
		'#links => FMMany type: #OPLinkEntry opposite: #components',
		'#callbacks => FMMany type: #OPCallbackEntry opposite: #components'
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
