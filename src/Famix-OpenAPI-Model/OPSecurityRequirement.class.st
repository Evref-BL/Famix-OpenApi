"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `openApi` | `OPSecurityRequirement` | `securityRequirements` | `OPOpenApi` | Opposite reference openApi from SecurityRequirement to OpenApi [0..1].|
| `operation` | `OPSecurityRequirement` | `securityRequirements` | `OPOperation` | Opposite reference operation from SecurityRequirement to Operation [0..1].|
| `securityContainer` | `OPSecurityRequirement` | `security` | `OPSecurityContainer` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securitySchemes` | `OPSecurityRequirement` | `securityRequirement` | `OPRequiredSecurityScheme` | Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].|


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
	#name : 'OPSecurityRequirement',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#openApi => FMOne type: #OPOpenApi opposite: #securityRequirements',
		'#operation => FMOne type: #OPOperation opposite: #securityRequirements',
		'#securityContainer => FMOne type: #OPSecurityContainer opposite: #security',
		'#securitySchemes => FMMany type: #OPRequiredSecurityScheme opposite: #securityRequirement'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityRequirement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecurityRequirement super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPSecurityRequirement >> addSecurityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	^ self securitySchemes add: anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #securityRequirements"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference openApi from SecurityRequirement to OpenApi [0..1].'>
	<container>
	^ openApi
]

{ #category : 'accessing' }
OPSecurityRequirement >> openApi: anObject [

	<ignoreForCoverage>
	<generated>
	openApi := anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> operation [
	"Relation named: #operation type: #OPOperation opposite: #securityRequirements"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference operation from SecurityRequirement to Operation [0..1].'>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPSecurityRequirement >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> securityContainer [
	"Relation named: #securityContainer type: #OPSecurityContainer opposite: #security"

	<ignoreForCoverage>
	<generated>
	<container>
	^ securityContainer
]

{ #category : 'accessing' }
OPSecurityRequirement >> securityContainer: anObject [

	<ignoreForCoverage>
	<generated>
	securityContainer := anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> securitySchemes [
	"Relation named: #securitySchemes type: #OPRequiredSecurityScheme opposite: #securityRequirement"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].'>
	^ securitySchemes
]

{ #category : 'accessing' }
OPSecurityRequirement >> securitySchemes: anObject [

	<ignoreForCoverage>
	<generated>
	securitySchemes value: anObject
]
