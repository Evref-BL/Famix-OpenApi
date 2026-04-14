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
| `info` | `OPApi` | `api` | `OPInfo` | Reference info from API to Info [0..1].|
| `parameters` | `OPApi` | `api` | `OPParameterEntry` | Reference parameters from API to ParameterEntry [0..*].|
| `paths` | `OPApi` | `api` | `OPPath` | Reference paths from API to Path [0..*].|
| `responses` | `OPApi` | `api` | `OPResponseDefinitionEntry` | Reference responses from API to ResponseDefinitionEntry [0..*].|
| `security` | `OPSecurityContainer` | `securityContainer` | `OPSecurityRequirement` | Reference security from SecurityContainer to SecurityRequirement [0..*].|
| `securityDefinitions` | `OPApi` | `api` | `OPSecuritySchemeEntry` | Reference securityDefinitions from API to SecuritySchemeEntry [0..*].|
| `tags` | `OPApi` | `anApi` | `OPTag` | Reference tags from API to Tag [0..*].|


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
		'#openapi => FMProperty',
		'#host => FMProperty',
		'#basePath => FMProperty',
		'#schemes => FMProperty',
		'#consumes => FMProperty',
		'#produces => FMProperty',
		'#info => FMOne type: #OPInfo opposite: #api',
		'#paths => FMMany type: #OPPath opposite: #api',
		'#components => FMOne type: #OPComponents opposite: #api',
		'#definitions => FMMany type: #OPSchemaEntry opposite: #api',
		'#responses => FMMany type: #OPResponseDefinitionEntry opposite: #api',
		'#securityDefinitions => FMMany type: #OPSecuritySchemeEntry opposite: #api',
		'#tags => FMMany type: #OPTag opposite: #anApi',
		'#parameters => FMMany type: #OPParameterEntry opposite: #api',
		'#containedCollections => FMOne type: #OPContainedCollections opposite: #api'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPApi class >> annotation [

	<FMClass: #Api super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPApi >> addDefinition: anObject [
	<generated>
	^ self definitions add: anObject
]

{ #category : 'adding' }
OPApi >> addParameter: anObject [
	<generated>
	^ self parameters add: anObject
]

{ #category : 'adding' }
OPApi >> addPath: anObject [
	<generated>
	^ self paths add: anObject
]

{ #category : 'adding' }
OPApi >> addResponse: anObject [
	<generated>
	^ self responses add: anObject
]

{ #category : 'adding' }
OPApi >> addSecurityDefinition: anObject [
	<generated>
	^ self securityDefinitions add: anObject
]

{ #category : 'adding' }
OPApi >> addTag: anObject [
	<generated>
	^ self tags add: anObject
]

{ #category : 'accessing' }
OPApi >> basePath [

	<FMProperty: #basePath type: #String>
	<generated>
	<FMComment: 'Attribute basePath from API [1]'>
	^ basePath
]

{ #category : 'accessing' }
OPApi >> basePath: anObject [
	<generated>
	basePath := anObject
]

{ #category : 'accessing' }
OPApi >> components [
	"Relation named: #components type: #OPComponents opposite: #api"

	<generated>
	<FMComment: 'Reference components from API to Components [0..1].'>
	^ components
]

{ #category : 'accessing' }
OPApi >> components: anObject [

	<generated>
	components := anObject
]

{ #category : 'navigation' }
OPApi >> componentsGroup [
	<generated>
	<navigation: 'Components'>
	^ MooseSpecializedGroup with: self components
]

{ #category : 'accessing' }
OPApi >> consumes [

	<FMProperty: #consumes type: #Object>
	<generated>
	<FMComment: 'Attribute consumes from API [*]'>
	^ consumes
]

{ #category : 'accessing' }
OPApi >> consumes: anObject [
	<generated>
	consumes := anObject
]

{ #category : 'accessing' }
OPApi >> containedCollections [
	"Relation named: #containedCollections type: #OPContainedCollections opposite: #api"

	<generated>
	<FMComment: 'Reference containedCollections from API to ContainedCollections [0..1].'>
	^ containedCollections
]

{ #category : 'accessing' }
OPApi >> containedCollections: anObject [

	<generated>
	containedCollections := anObject
]

{ #category : 'navigation' }
OPApi >> containedCollectionsGroup [
	<generated>
	<navigation: 'ContainedCollections'>
	^ MooseSpecializedGroup with: self containedCollections
]

{ #category : 'accessing' }
OPApi >> definitions [
	"Relation named: #definitions type: #OPSchemaEntry opposite: #api"

	<generated>
	<FMComment: 'Reference definitions from API to SchemaEntry [0..*].'>
	<derived>
	^ definitions
]

{ #category : 'accessing' }
OPApi >> definitions: anObject [

	<generated>
	definitions value: anObject
]

{ #category : 'navigation' }
OPApi >> definitionsGroup [
	<generated>
	<navigation: 'Definitions'>
	^ MooseSpecializedGroup withAll: self definitions asSet
]

{ #category : 'accessing' }
OPApi >> host [

	<FMProperty: #host type: #String>
	<generated>
	<FMComment: 'Attribute host from API [1]'>
	^ host
]

{ #category : 'accessing' }
OPApi >> host: anObject [
	<generated>
	host := anObject
]

{ #category : 'accessing' }
OPApi >> info [
	"Relation named: #info type: #OPInfo opposite: #api"

	<generated>
	<FMComment: 'Reference info from API to Info [0..1].'>
	^ info
]

{ #category : 'accessing' }
OPApi >> info: anObject [

	<generated>
	info := anObject
]

{ #category : 'navigation' }
OPApi >> infoGroup [
	<generated>
	<navigation: 'Info'>
	^ MooseSpecializedGroup with: self info
]

{ #category : 'accessing' }
OPApi >> openapi [

	<FMProperty: #openapi type: #String>
	<generated>
	<FMComment: 'Attribute openapi from API [1]'>
	^ openapi
]

{ #category : 'accessing' }
OPApi >> openapi: anObject [
	<generated>
	openapi := anObject
]

{ #category : 'accessing' }
OPApi >> parameters [
	"Relation named: #parameters type: #OPParameterEntry opposite: #api"

	<generated>
	<FMComment: 'Reference parameters from API to ParameterEntry [0..*].'>
	<derived>
	^ parameters
]

{ #category : 'accessing' }
OPApi >> parameters: anObject [

	<generated>
	parameters value: anObject
]

{ #category : 'navigation' }
OPApi >> parametersGroup [
	<generated>
	<navigation: 'Parameters'>
	^ MooseSpecializedGroup withAll: self parameters asSet
]

{ #category : 'accessing' }
OPApi >> paths [
	"Relation named: #paths type: #OPPath opposite: #api"

	<generated>
	<FMComment: 'Reference paths from API to Path [0..*].'>
	<derived>
	^ paths
]

{ #category : 'accessing' }
OPApi >> paths: anObject [

	<generated>
	paths value: anObject
]

{ #category : 'navigation' }
OPApi >> pathsGroup [
	<generated>
	<navigation: 'Paths'>
	^ MooseSpecializedGroup withAll: self paths asSet
]

{ #category : 'accessing' }
OPApi >> produces [

	<FMProperty: #produces type: #Object>
	<generated>
	<FMComment: 'Attribute produces from API [*]'>
	^ produces
]

{ #category : 'accessing' }
OPApi >> produces: anObject [
	<generated>
	produces := anObject
]

{ #category : 'accessing' }
OPApi >> responses [
	"Relation named: #responses type: #OPResponseDefinitionEntry opposite: #api"

	<generated>
	<FMComment: 'Reference responses from API to ResponseDefinitionEntry [0..*].'>
	<derived>
	^ responses
]

{ #category : 'accessing' }
OPApi >> responses: anObject [

	<generated>
	responses value: anObject
]

{ #category : 'navigation' }
OPApi >> responsesGroup [
	<generated>
	<navigation: 'Responses'>
	^ MooseSpecializedGroup withAll: self responses asSet
]

{ #category : 'accessing' }
OPApi >> schemes [

	<FMProperty: #schemes type: #Object>
	<generated>
	<FMComment: 'Attribute schemes from API [*]'>
	^ schemes
]

{ #category : 'accessing' }
OPApi >> schemes: anObject [
	<generated>
	schemes := anObject
]

{ #category : 'accessing' }
OPApi >> securityDefinitions [
	"Relation named: #securityDefinitions type: #OPSecuritySchemeEntry opposite: #api"

	<generated>
	<FMComment: 'Reference securityDefinitions from API to SecuritySchemeEntry [0..*].'>
	<derived>
	^ securityDefinitions
]

{ #category : 'accessing' }
OPApi >> securityDefinitions: anObject [

	<generated>
	securityDefinitions value: anObject
]

{ #category : 'navigation' }
OPApi >> securityDefinitionsGroup [
	<generated>
	<navigation: 'SecurityDefinitions'>
	^ MooseSpecializedGroup withAll: self securityDefinitions asSet
]

{ #category : 'accessing' }
OPApi >> tags [
	"Relation named: #tags type: #OPTag opposite: #anApi"

	<generated>
	<FMComment: 'Reference tags from API to Tag [0..*].'>
	<derived>
	^ tags
]

{ #category : 'accessing' }
OPApi >> tags: anObject [

	<generated>
	tags value: anObject
]

{ #category : 'navigation' }
OPApi >> tagsGroup [
	<generated>
	<navigation: 'Tags'>
	^ MooseSpecializedGroup withAll: self tags asSet
]
