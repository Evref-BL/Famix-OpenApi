"
An OpenAPI description document (OpenAPI Object), root of the model. Swagger 2.0 and OpenAPI 3.0.x documents are normalised by the importer to the OpenAPI 3.1 shape described by this model.

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPOpenApi` | `openApi` | `OPComponents` | Reusable objects of the API.|
| `externalDocs` | `OPOpenApi` | `openApi` | `OPExternalDocumentation` | External documentation of the API as a whole.|
| `info` | `OPOpenApi` | `openApi` | `OPInfo` | Metadata of the API.|
| `paths` | `OPOpenApi` | `openApi` | `OPPath` | Path items of the API.|
| `securityRequirements` | `OPOpenApi` | `openApi` | `OPSecurityRequirement` | Security requirements applied to every operation by default, as alternatives.|
| `servers` | `OPOpenApi` | `openApi` | `OPServer` | Servers hosting the API.|
| `tags` | `OPOpenApi` | `openApi` | `OPTag` | Tags declared by the document.|
| `unresolvedReferences` | `OPOpenApi` | `openApi` | `OPReference` | References that could not be resolved to an entity of the model, for example references to external documents.|
| `webhooks` | `OPOpenApi` | `webhookOf` | `OPPath` | Path items describing the requests the API may send (OpenAPI 3.1 webhooks).|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `jsonSchemaDialect` | `String` | nil | URI of the JSON Schema dialect used by the schemas of the document (jsonSchemaDialect field).|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `openapiVersion` | `String` | nil | Value of the openapi field of the canonical document.|
| `selfUrl` | `String` | nil | URI under which the document is available ($self field).|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `sourceVersion` | `String` | nil | Version of the specification of the source document: 2.0, 3.0.x or 3.1.x.|

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
		'#unresolvedReferences => FMMany type: #OPReference opposite: #openApi',
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
OPOpenApi >> addUnresolvedReference: anObject [

	<ignoreForCoverage>
	<generated>
	^ self unresolvedReferences add: anObject
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
	<FMComment: 'Reusable objects of the API.'>
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
	<FMComment: 'External documentation of the API as a whole.'>
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
	<FMComment: 'Metadata of the API.'>
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
	<FMComment: 'URI of the JSON Schema dialect used by the schemas of the document (jsonSchemaDialect field).'>
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
	<FMComment: 'Value of the openapi field of the canonical document.'>
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
	<FMComment: 'Path items of the API.'>
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
	<FMComment: 'Security requirements applied to every operation by default, as alternatives.'>
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
	<FMComment: 'URI under which the document is available ($self field).'>
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
	<FMComment: 'Servers hosting the API.'>
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
	<FMComment: 'Version of the specification of the source document: 2.0, 3.0.x or 3.1.x.'>
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
	<FMComment: 'Tags declared by the document.'>
	^ tags
]

{ #category : 'accessing' }
OPOpenApi >> tags: anObject [

	<ignoreForCoverage>
	<generated>
	tags value: anObject
]

{ #category : 'accessing' }
OPOpenApi >> unresolvedReferences [
	"Relation named: #unresolvedReferences type: #OPReference opposite: #openApi"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'References that could not be resolved to an entity of the model, for example references to external documents.'>
	^ unresolvedReferences
]

{ #category : 'accessing' }
OPOpenApi >> unresolvedReferences: anObject [

	<ignoreForCoverage>
	<generated>
	unresolvedReferences value: anObject
]

{ #category : 'accessing' }
OPOpenApi >> webhooks [
	"Relation named: #webhooks type: #OPPath opposite: #webhookOf"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Path items describing the requests the API may send (OpenAPI 3.1 webhooks).'>
	^ webhooks
]

{ #category : 'accessing' }
OPOpenApi >> webhooks: anObject [

	<ignoreForCoverage>
	<generated>
	webhooks value: anObject
]
