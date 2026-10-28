"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPApi` | `api` | `OPComponents` | Reference components from API to Components [0..1].|
| `containedCollections` | `OPApi` | `api` | `OPContainedCollections` | Reference containedCollections from API to ContainedCollections [0..1].|
| `definitions` | `OPApi` | `api` | `OPSchemaEntry` | Reference definitions from API to SchemaEntry [0..*].|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `externalDocumentation` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.|
| `info` | `OPApi` | `api` | `OPInfo` | Reference info from API to Info [0..1].|
| `parameters` | `OPApi` | `api` | `OPParameterEntry` | Reference parameters from API to ParameterEntry [0..*].|
| `paths` | `OPApi` | `api` | `OPPath` | Reference paths from API to Path [0..*].|
| `responses` | `OPApi` | `api` | `OPResponseDefinitionEntry` | Reference responses from API to ResponseDefinitionEntry [0..*].|
| `security` | `OPSecurityContainer` | `securityContainer` | `OPSecurityRequirement` | Reference security from SecurityContainer to SecurityRequirement [0..*].|
| `securityDefinitions` | `OPApi` | `api` | `OPSecuritySchemeEntry` | Reference securityDefinitions from API to SecuritySchemeEntry [0..*].|
| `tags` | `OPApi` | `api` | `OPTag` | Reference tags from API to Tag [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `basePath` | `String` | nil | Attribute basePath from API [1]|
| `consumes` | `Object` | nil | Attribute consumes from API [*]|
| `host` | `String` | nil | Attribute host from API [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `openapi` | `String` | nil | Attribute openapi from API [1]|
| `produces` | `Object` | nil | Attribute produces from API [*]|
| `schemes` | `Object` | nil | Attribute schemes from API [*]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPApi',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPExternalDocsContainer + OPSecurityContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPExternalDocsContainer classTrait + OPSecurityContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#basePath => FMProperty',
		'#components => FMOne type: #OPComponents opposite: #api',
		'#consumes => FMProperty',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #api',
		'#definitions => FMMany type: #OPSchemaEntry opposite: #api',
		'#host => FMProperty',
		'#info => FMOne type: #OPInfo opposite: #api',
		'#openapi => FMProperty',
		'#parameters => FMMany type: #OPParameterEntry opposite: #api',
		'#paths => FMMany type: #OPPath opposite: #api',
		'#produces => FMProperty',
		'#responses => FMMany type: #OPResponseDefinitionEntry opposite: #api',
		'#schemes => FMProperty',
		'#securityDefinitions => FMMany type: #OPSecuritySchemeEntry opposite: #api',
		'#tags => FMMany type: #OPTag opposite: #api'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPApi class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Api super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPApi >> addDefinition: anObject [

	<ignoreForCoverage>
	<generated>
	^ self definitions add: anObject
]

{ #category : 'adding' }
OPApi >> addParameter: anObject [

	<ignoreForCoverage>
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPApi >> addPath: anObject [

	<ignoreForCoverage>
	<generated>
	^ self paths add: anObject
]

{ #category : 'adding' }
OPApi >> addResponse: anObject [

	<ignoreForCoverage>
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPApi >> addSecurityDefinition: anObject [

	<ignoreForCoverage>
	<generated>
	^ self securityDefinitions add: anObject
]

{ #category : 'adding' }
OPApi >> addTag: anObject [

	<ignoreForCoverage>
	<generated>
	^ self tags add: anObject
]

{ #category : 'accessing' }
OPApi >> basePath [

	<FMProperty: #basePath type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute basePath from API [1]'>
	^ basePath
]

{ #category : 'accessing' }
OPApi >> basePath: anObject [
	<ignoreForCoverage>
	<generated>
	basePath := anObject
]

{ #category : 'accessing' }
OPApi >> components [
	"Relation named: #components type: #OPComponents opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference components from API to Components [0..1].'>
	^ components
]

{ #category : 'accessing' }
OPApi >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPApi >> consumes [

	<FMProperty: #consumes type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute consumes from API [*]'>
	^ consumes
]

{ #category : 'accessing' }
OPApi >> consumes: anObject [
	<ignoreForCoverage>
	<generated>
	consumes := anObject
]

{ #category : 'accessing' }
OPApi >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference containedCollections from API to ContainedCollections [0..1].'>
	^ containedCollections
]

{ #category : 'accessing' }
OPApi >> containedCollections: anObject [

	<ignoreForCoverage>
	<generated>
	containedCollections := anObject
]

{ #category : 'accessing' }
OPApi >> definitions [
	"Relation named: #definitions type: #OPSchemaEntry opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference definitions from API to SchemaEntry [0..*].'>
	^ definitions
]

{ #category : 'accessing' }
OPApi >> definitions: anObject [

	<ignoreForCoverage>
	<generated>
	definitions value: anObject
]

{ #category : 'accessing' }
OPApi >> host [

	<FMProperty: #host type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute host from API [1]'>
	^ host
]

{ #category : 'accessing' }
OPApi >> host: anObject [
	<ignoreForCoverage>
	<generated>
	host := anObject
]

{ #category : 'accessing' }
OPApi >> info [
	"Relation named: #info type: #OPInfo opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference info from API to Info [0..1].'>
	^ info
]

{ #category : 'accessing' }
OPApi >> info: anObject [

	<ignoreForCoverage>
	<generated>
	info := anObject
]

{ #category : 'accessing' }
OPApi >> openapi [

	<FMProperty: #openapi type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute openapi from API [1]'>
	^ openapi
]

{ #category : 'accessing' }
OPApi >> openapi: anObject [
	<ignoreForCoverage>
	<generated>
	openapi := anObject
]

{ #category : 'accessing' }
OPApi >> parameters [
	"Relation named: #parameters type: #OPParameterEntry opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference parameters from API to ParameterEntry [0..*].'>
	^ parameters
]

{ #category : 'accessing' }
OPApi >> parameters: anObject [

	<ignoreForCoverage>
	<generated>
	parameters value: anObject
]

{ #category : 'accessing' }
OPApi >> paths [
	"Relation named: #paths type: #OPPath opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference paths from API to Path [0..*].'>
	^ paths
]

{ #category : 'accessing' }
OPApi >> paths: anObject [

	<ignoreForCoverage>
	<generated>
	paths value: anObject
]

{ #category : 'accessing' }
OPApi >> produces [

	<FMProperty: #produces type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute produces from API [*]'>
	^ produces
]

{ #category : 'accessing' }
OPApi >> produces: anObject [
	<ignoreForCoverage>
	<generated>
	produces := anObject
]

{ #category : 'accessing' }
OPApi >> responses [
	"Relation named: #responses type: #OPResponseDefinitionEntry opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference responses from API to ResponseDefinitionEntry [0..*].'>
	^ responses
]

{ #category : 'accessing' }
OPApi >> responses: anObject [

	<ignoreForCoverage>
	<generated>
	responses value: anObject
]

{ #category : 'accessing' }
OPApi >> schemes [

	<FMProperty: #schemes type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute schemes from API [*]'>
	^ schemes
]

{ #category : 'accessing' }
OPApi >> schemes: anObject [
	<ignoreForCoverage>
	<generated>
	schemes := anObject
]

{ #category : 'accessing' }
OPApi >> securityDefinitions [
	"Relation named: #securityDefinitions type: #OPSecuritySchemeEntry opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securityDefinitions from API to SecuritySchemeEntry [0..*].'>
	^ securityDefinitions
]

{ #category : 'accessing' }
OPApi >> securityDefinitions: anObject [

	<ignoreForCoverage>
	<generated>
	securityDefinitions value: anObject
]

{ #category : 'accessing' }
OPApi >> tags [
	"Relation named: #tags type: #OPTag opposite: #api"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference tags from API to Tag [0..*].'>
	^ tags
]

{ #category : 'accessing' }
OPApi >> tags: anObject [

	<ignoreForCoverage>
	<generated>
	tags value: anObject
]
