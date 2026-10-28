"
The reusable objects of the document (OpenAPI Components Object): schemas, responses, parameters, request bodies, headers, examples, links, callbacks, security schemes and path items. Each reusable object is owned by the components and shared by reference.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `openApi` | `OPComponents` | `components` | `OPOpenApi` | The document the components belong to.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `callbacks` | `OPComponents` | `components` | `OPCallback` | The reusable callbacks of the document, owned by the components and shared by reference.|
| `examples` | `OPComponents` | `components` | `OPExample` | The reusable examples of the document, owned by the components and shared by reference.|
| `headers` | `OPComponents` | `components` | `OPHeader` | The reusable headers of the document, owned by the components and shared by reference.|
| `links` | `OPComponents` | `components` | `OPLink` | The reusable links of the document, owned by the components and shared by reference.|
| `parameters` | `OPComponents` | `components` | `OPParameter` | The reusable parameters of the document, owned by the components and shared by reference.|
| `pathItems` | `OPComponents` | `components` | `OPPath` | The reusable path items of the document, owned by the components and shared by reference.|
| `requestBodies` | `OPComponents` | `components` | `OPRequestBody` | The reusable request bodies of the document, owned by the components and shared by reference.|
| `responses` | `OPComponents` | `components` | `OPResponse` | The reusable responses of the document, owned by the components and shared by reference.|
| `schemas` | `OPComponents` | `components` | `OPSchema` | The reusable schemas of the document, owned by the components and shared by reference.|
| `securitySchemes` | `OPComponents` | `components` | `OPSecurityScheme` | The reusable security schemes of the document, owned by the components and shared by reference.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPComponents',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#callbacks => FMMany type: #OPCallback opposite: #components',
		'#examples => FMMany type: #OPExample opposite: #components',
		'#headers => FMMany type: #OPHeader opposite: #components',
		'#links => FMMany type: #OPLink opposite: #components',
		'#openApi => FMOne type: #OPOpenApi opposite: #components',
		'#parameters => FMMany type: #OPParameter opposite: #components',
		'#pathItems => FMMany type: #OPPath opposite: #components',
		'#requestBodies => FMMany type: #OPRequestBody opposite: #components',
		'#responses => FMMany type: #OPResponse opposite: #components',
		'#schemas => FMMany type: #OPSchema opposite: #components',
		'#securitySchemes => FMMany type: #OPSecurityScheme opposite: #components'
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
OPComponents >> callbacks [
	"Relation named: #callbacks type: #OPCallback opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable callbacks of the document, owned by the components and shared by reference.'>
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
	"Relation named: #examples type: #OPExample opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable examples of the document, owned by the components and shared by reference.'>
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
	"Relation named: #headers type: #OPHeader opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable headers of the document, owned by the components and shared by reference.'>
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
	"Relation named: #links type: #OPLink opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable links of the document, owned by the components and shared by reference.'>
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
	<FMComment: 'The document the components belong to.'>
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
	"Relation named: #parameters type: #OPParameter opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable parameters of the document, owned by the components and shared by reference.'>
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
	<FMComment: 'The reusable path items of the document, owned by the components and shared by reference.'>
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
	"Relation named: #requestBodies type: #OPRequestBody opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable request bodies of the document, owned by the components and shared by reference.'>
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
	"Relation named: #responses type: #OPResponse opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable responses of the document, owned by the components and shared by reference.'>
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
	"Relation named: #schemas type: #OPSchema opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable schemas of the document, owned by the components and shared by reference.'>
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
	"Relation named: #securitySchemes type: #OPSecurityScheme opposite: #components"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The reusable security schemes of the document, owned by the components and shared by reference.'>
	^ securitySchemes
]

{ #category : 'accessing' }
OPComponents >> securitySchemes: anObject [

	<ignoreForCoverage>
	<generated>
	securitySchemes value: anObject
]
