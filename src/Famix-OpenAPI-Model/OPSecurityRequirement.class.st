"
An alternative of the security of an API or of an operation (OpenAPI Security Requirement Object). All its items must be satisfied together (logical AND); the requirements of the same list are alternatives (logical OR).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `openApi` | `OPSecurityRequirement` | `securityRequirements` | `OPOpenApi` | The document declaring the requirement as its default security.|
| `operation` | `OPSecurityRequirement` | `securityRequirements` | `OPOperation` | The operation declaring the requirement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPSecurityRequirement` | `requirement` | `OPSecurityRequirementItem` | Schemes that must all be satisfied together (logical AND).|


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
	#name : 'OPSecurityRequirement',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#items => FMMany type: #OPSecurityRequirementItem opposite: #requirement',
		'#openApi => FMOne type: #OPOpenApi opposite: #securityRequirements',
		'#operation => FMOne type: #OPOperation opposite: #securityRequirements'
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
OPSecurityRequirement >> addItem: anObject [

	<ignoreForCoverage>
	<generated>
	^ self items add: anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> items [
	"Relation named: #items type: #OPSecurityRequirementItem opposite: #requirement"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Schemes that must all be satisfied together (logical AND).'>
	^ items
]

{ #category : 'accessing' }
OPSecurityRequirement >> items: anObject [

	<ignoreForCoverage>
	<generated>
	items value: anObject
]

{ #category : 'accessing' }
OPSecurityRequirement >> openApi [
	"Relation named: #openApi type: #OPOpenApi opposite: #securityRequirements"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The document declaring the requirement as its default security.'>
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
	<FMComment: 'The operation declaring the requirement.'>
	<container>
	^ operation
]

{ #category : 'accessing' }
OPSecurityRequirement >> operation: anObject [

	<ignoreForCoverage>
	<generated>
	operation := anObject
]
