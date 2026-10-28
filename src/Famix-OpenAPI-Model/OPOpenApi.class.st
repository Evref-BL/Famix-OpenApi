"
An OpenAPI description document (OpenAPI Object), root of the canonical 3.1 shape. Swagger 2.0 and OpenAPI 3.0.x documents are normalised to this shape by the importer.

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPOpenApi` | `openApi` | `OPComponents` | Reference components from OpenApi to Components [0..1]: reusable objects of the API.|
| `externalDocs` | `OPOpenApi` | `openApi` | `OPExternalDocumentation` | Reference externalDocs from OpenApi to ExternalDocumentation [0..1].|
| `info` | `OPOpenApi` | `openApi` | `OPInfo` | Reference info from OpenApi to Info [0..1]: metadata of the API.|
| `paths` | `OPOpenApi` | `openApi` | `OPPath` | Reference paths from OpenApi to Path [0..*]: the path items of the API.|
| `securityRequirements` | `OPOpenApi` | `openApi` | `OPSecurityRequirement` | Reference securityRequirements from OpenApi to SecurityRequirement [0..*]: security applied to every operation by default.|
| `servers` | `OPOpenApi` | `openApi` | `OPServer` | Reference servers from OpenApi to Server [0..*]: servers hosting the API.|
| `tags` | `OPOpenApi` | `openApi` | `OPTag` | Reference tags from OpenApi to Tag [0..*]: tags declared by the document.|
| `webhooks` | `OPOpenApi` | `webhookOf` | `OPPath` | Reference webhooks from OpenApi to Path [0..*]: path items describing the requests the API may send (OpenAPI 3.1 webhooks).|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `jsonSchemaDialect` | `String` | nil | URI of the JSON Schema dialect used by the schemas of the document (jsonSchemaDialect field) [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `openapiVersion` | `String` | nil | Value of the openapi field of the canonical document [1].|
| `selfUrl` | `String` | nil | URI under which the document is available ($self field) [1].|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `sourceVersion` | `String` | nil | Version of the specification as read from the source document: 2.0, 3.0.x or 3.1.x [1].|

"
Class {
	#name : 'OPOpenApi',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #openApi',
		'#externalDocs => FMOne type: #OPExternalDocumentation opposite: #openApi',
		'#info => FMOne type: #OPInfo opposite: #openApi',
		'#jsonSchemaDialect => FMProperty',
		'#openapiVersion => FMProperty',
		'#paths => FMMany type: #OPPath opposite: #openApi',
		'#securityRequirements => FMMany type: #OPSecurityRequirement opposite: #openApi',
		'#selfUrl => FMProperty',
		'#servers => FMMany type: #OPServer opposite: #openApi',
		'#sourceVersion => FMProperty',
		'#tags => FMMany type: #OPTag opposite: #openApi',
		'#webhooks => FMMany type: #OPPath opposite: #webhookOf'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPOpenApi class >> annotation [

	<ignoreForCoverage>
	<FMClass: #OpenApi super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPOpenApi >> addPath: anObject [

	<ignoreForCoverage>
	<generated>
	^ self paths add: anObject
]

{ #category : 'adding' }
OPOpenApi >> addSecurityRequirement: anObject [

	<ignoreForCoverage>
	<generated>
	^ self securityRequirements add: anObject
]

{ #category : 'adding' }
OPOpenApi >> addServer: anObject [

	<ignoreForCoverage>
	<generated>
	^ self servers add: anObject
]

{ #category : 'adding' }
OPOpenApi >> addTag: anObject [

	<ignoreForCoverage>
	<generated>
	^ self tags add: anObject
]

{ #category : 'adding' }
OPOpenApi >> addWebhook: anObject [

	<ignoreForCoverage>
	<generated>
	^ self webhooks add: anObject
]

{ #category : 'accessing' }
OPOpenApi >> components [
	"Relation named: #components type: #OPComponents opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference components from OpenApi to Components [0..1]: reusable objects of the API.'>
	^ components
]

{ #category : 'accessing' }
OPOpenApi >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPOpenApi >> externalDocs [
	"Relation named: #externalDocs type: #OPExternalDocumentation opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference externalDocs from OpenApi to ExternalDocumentation [0..1].'>
	^ externalDocs
]

{ #category : 'accessing' }
OPOpenApi >> externalDocs: anObject [

	<ignoreForCoverage>
	<generated>
	externalDocs := anObject
]

{ #category : 'accessing' }
OPOpenApi >> info [
	"Relation named: #info type: #OPInfo opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference info from OpenApi to Info [0..1]: metadata of the API.'>
	^ info
]

{ #category : 'accessing' }
OPOpenApi >> info: anObject [

	<ignoreForCoverage>
	<generated>
	info := anObject
]

{ #category : 'accessing' }
OPOpenApi >> jsonSchemaDialect [

	<FMProperty: #jsonSchemaDialect type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URI of the JSON Schema dialect used by the schemas of the document (jsonSchemaDialect field) [1].'>
	^ jsonSchemaDialect
]

{ #category : 'accessing' }
OPOpenApi >> jsonSchemaDialect: anObject [
	<ignoreForCoverage>
	<generated>
	jsonSchemaDialect := anObject
]

{ #category : 'accessing' }
OPOpenApi >> openapiVersion [

	<FMProperty: #openapiVersion type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Value of the openapi field of the canonical document [1].'>
	^ openapiVersion
]

{ #category : 'accessing' }
OPOpenApi >> openapiVersion: anObject [
	<ignoreForCoverage>
	<generated>
	openapiVersion := anObject
]

{ #category : 'accessing' }
OPOpenApi >> paths [
	"Relation named: #paths type: #OPPath opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference paths from OpenApi to Path [0..*]: the path items of the API.'>
	^ paths
]

{ #category : 'accessing' }
OPOpenApi >> paths: anObject [

	<ignoreForCoverage>
	<generated>
	paths value: anObject
]

{ #category : 'accessing' }
OPOpenApi >> securityRequirements [
	"Relation named: #securityRequirements type: #OPSecurityRequirement opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securityRequirements from OpenApi to SecurityRequirement [0..*]: security applied to every operation by default.'>
	^ securityRequirements
]

{ #category : 'accessing' }
OPOpenApi >> securityRequirements: anObject [

	<ignoreForCoverage>
	<generated>
	securityRequirements value: anObject
]

{ #category : 'accessing' }
OPOpenApi >> selfUrl [

	<FMProperty: #selfUrl type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URI under which the document is available ($self field) [1].'>
	^ selfUrl
]

{ #category : 'accessing' }
OPOpenApi >> selfUrl: anObject [
	<ignoreForCoverage>
	<generated>
	selfUrl := anObject
]

{ #category : 'accessing' }
OPOpenApi >> servers [
	"Relation named: #servers type: #OPServer opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference servers from OpenApi to Server [0..*]: servers hosting the API.'>
	^ servers
]

{ #category : 'accessing' }
OPOpenApi >> servers: anObject [

	<ignoreForCoverage>
	<generated>
	servers value: anObject
]

{ #category : 'accessing' }
OPOpenApi >> sourceVersion [

	<FMProperty: #sourceVersion type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Version of the specification as read from the source document: 2.0, 3.0.x or 3.1.x [1].'>
	^ sourceVersion
]

{ #category : 'accessing' }
OPOpenApi >> sourceVersion: anObject [
	<ignoreForCoverage>
	<generated>
	sourceVersion := anObject
]

{ #category : 'accessing' }
OPOpenApi >> tags [
	"Relation named: #tags type: #OPTag opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference tags from OpenApi to Tag [0..*]: tags declared by the document.'>
	^ tags
]

{ #category : 'accessing' }
OPOpenApi >> tags: anObject [

	<ignoreForCoverage>
	<generated>
	tags value: anObject
]

{ #category : 'accessing' }
OPOpenApi >> webhooks [
	"Relation named: #webhooks type: #OPPath opposite: #webhookOf"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference webhooks from OpenApi to Path [0..*]: path items describing the requests the API may send (OpenAPI 3.1 webhooks).'>
	^ webhooks
]

{ #category : 'accessing' }
OPOpenApi >> webhooks: anObject [

	<ignoreForCoverage>
	<generated>
	webhooks value: anObject
]
