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

	<FMClass: #Components super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPComponents >> addCallback: anObject [
	<generated>
	^ self callbacks add: anObject
]

{ #category : 'adding' }
OPComponents >> addExample: anObject [
	<generated>
	^ self examples add: anObject
]

{ #category : 'adding' }
OPComponents >> addHeader: anObject [
	<generated>
	^ self headers add: anObject
]

{ #category : 'adding' }
OPComponents >> addLink: anObject [
	<generated>
	^ self links add: anObject
]

{ #category : 'adding' }
OPComponents >> addParameter: anObject [
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPComponents >> addRequestBody: anObject [
	<generated>
	^ self requestBodies add: anObject
]

{ #category : 'adding' }
OPComponents >> addResponse: anObject [
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPComponents >> addSchema: anObject [
	<generated>
	^ self schemas add: anObject
]

{ #category : 'adding' }
OPComponents >> addSecurityScheme: anObject [
	<generated>
	^ self securitySchemes add: anObject
]

{ #category : 'accessing' }
OPComponents >> api [
	"Relation named: #api type: #OPApi opposite: #components"

	<generated>
	<FMComment: 'Opposite reference api from Components to API [0..1].'>
	<container>
	<derived>
	^ api
]

{ #category : 'accessing' }
OPComponents >> api: anObject [

	<generated>
	api := anObject
]

{ #category : 'navigation' }
OPComponents >> apiGroup [
	<generated>
	<navigation: 'Api'>
	^ MooseSpecializedGroup with: self api
]

{ #category : 'accessing' }
OPComponents >> callbacks [
	"Relation named: #callbacks type: #OPCallbackEntry opposite: #components"

	<generated>
	<FMComment: 'Reference callbacks from Components to CallbackEntry [0..*].'>
	<derived>
	^ callbacks
]

{ #category : 'accessing' }
OPComponents >> callbacks: anObject [

	<generated>
	callbacks value: anObject
]

{ #category : 'navigation' }
OPComponents >> callbacksGroup [
	<generated>
	<navigation: 'Callbacks'>
	^ MooseSpecializedGroup withAll: self callbacks asSet
]

{ #category : 'accessing' }
OPComponents >> examples [
	"Relation named: #examples type: #OPExampleEntry opposite: #components"

	<generated>
	<FMComment: 'Reference examples from Components to ExampleEntry [0..*].'>
	<derived>
	^ examples
]

{ #category : 'accessing' }
OPComponents >> examples: anObject [

	<generated>
	examples value: anObject
]

{ #category : 'navigation' }
OPComponents >> examplesGroup [
	<generated>
	<navigation: 'Examples'>
	^ MooseSpecializedGroup withAll: self examples asSet
]

{ #category : 'accessing' }
OPComponents >> headers [
	"Relation named: #headers type: #OPHeaderEntry opposite: #components"

	<generated>
	<FMComment: 'Reference headers from Components to HeaderEntry [0..*].'>
	<derived>
	^ headers
]

{ #category : 'accessing' }
OPComponents >> headers: anObject [

	<generated>
	headers value: anObject
]

{ #category : 'navigation' }
OPComponents >> headersGroup [
	<generated>
	<navigation: 'Headers'>
	^ MooseSpecializedGroup withAll: self headers asSet
]

{ #category : 'accessing' }
OPComponents >> links [
	"Relation named: #links type: #OPLinkEntry opposite: #components"

	<generated>
	<FMComment: 'Reference links from Components to LinkEntry [0..*].'>
	<derived>
	^ links
]

{ #category : 'accessing' }
OPComponents >> links: anObject [

	<generated>
	links value: anObject
]

{ #category : 'navigation' }
OPComponents >> linksGroup [
	<generated>
	<navigation: 'Links'>
	^ MooseSpecializedGroup withAll: self links asSet
]

{ #category : 'accessing' }
OPComponents >> parameters [
	"Relation named: #parameters type: #OPParameterEntry opposite: #components"

	<generated>
	<FMComment: 'Reference parameters from Components to ParameterEntry [0..*].'>
	<derived>
	^ parameters
]

{ #category : 'accessing' }
OPComponents >> parameters: anObject [

	<generated>
	parameters value: anObject
]

{ #category : 'navigation' }
OPComponents >> parametersGroup [
	<generated>
	<navigation: 'Parameters'>
	^ MooseSpecializedGroup withAll: self parameters asSet
]

{ #category : 'accessing' }
OPComponents >> requestBodies [
	"Relation named: #requestBodies type: #OPRequestBodyEntry opposite: #components"

	<generated>
	<FMComment: 'Reference requestBodies from Components to RequestBodyEntry [0..*].'>
	<derived>
	^ requestBodies
]

{ #category : 'accessing' }
OPComponents >> requestBodies: anObject [

	<generated>
	requestBodies value: anObject
]

{ #category : 'navigation' }
OPComponents >> requestBodiesGroup [
	<generated>
	<navigation: 'RequestBodies'>
	^ MooseSpecializedGroup withAll: self requestBodies asSet
]

{ #category : 'accessing' }
OPComponents >> responses [
	"Relation named: #responses type: #OPResponseDefinitionEntry opposite: #components"

	<generated>
	<FMComment: 'Reference responses from Components to ResponseDefinitionEntry [0..*].'>
	<derived>
	^ responses
]

{ #category : 'accessing' }
OPComponents >> responses: anObject [

	<generated>
	responses value: anObject
]

{ #category : 'navigation' }
OPComponents >> responsesGroup [
	<generated>
	<navigation: 'Responses'>
	^ MooseSpecializedGroup withAll: self responses asSet
]

{ #category : 'accessing' }
OPComponents >> schemas [
	"Relation named: #schemas type: #OPSchemaEntry opposite: #components"

	<generated>
	<FMComment: 'Reference schemas from Components to SchemaEntry [0..*].'>
	<derived>
	^ schemas
]

{ #category : 'accessing' }
OPComponents >> schemas: anObject [

	<generated>
	schemas value: anObject
]

{ #category : 'navigation' }
OPComponents >> schemasGroup [
	<generated>
	<navigation: 'Schemas'>
	^ MooseSpecializedGroup withAll: self schemas asSet
]

{ #category : 'accessing' }
OPComponents >> securitySchemes [
	"Relation named: #securitySchemes type: #OPSecuritySchemeEntry opposite: #components"

	<generated>
	<FMComment: 'Reference securitySchemes from Components to SecuritySchemeEntry [0..*].'>
	<derived>
	^ securitySchemes
]

{ #category : 'accessing' }
OPComponents >> securitySchemes: anObject [

	<generated>
	securitySchemes value: anObject
]

{ #category : 'navigation' }
OPComponents >> securitySchemesGroup [
	<generated>
	<navigation: 'SecuritySchemes'>
	^ MooseSpecializedGroup withAll: self securitySchemes asSet
]
