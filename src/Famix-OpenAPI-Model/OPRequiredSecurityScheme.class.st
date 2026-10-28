"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securityRequirement` | `OPRequiredSecurityScheme` | `securitySchemes` | `OPSecurityRequirement` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `securityScheme` | `OPRequiredSecurityScheme` | `usedByRequiredSecuritySchemes` | `OPSecurityScheme` | Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].|
| `securityScopes` | `OPRequiredSecurityScheme` | `usedByRequiredSecuritySchemes` | `OPSecurityScope` | Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPRequiredSecurityScheme',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPSourceText classTrait',
	#instVars : [
		'#securityRequirement => FMOne type: #OPSecurityRequirement opposite: #securitySchemes',
		'#securityScheme => FMOne type: #OPSecurityScheme opposite: #usedByRequiredSecuritySchemes',
		'#securityScopes => FMMany type: #OPSecurityScope opposite: #usedByRequiredSecuritySchemes'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPRequiredSecurityScheme class >> annotation [

	<ignoreForCoverage>
	<FMClass: #RequiredSecurityScheme super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPRequiredSecurityScheme >> addSecurityScope: anObject [

	<ignoreForCoverage>
	<generated>
	^ self securityScopes add: anObject
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityRequirement [
	"Relation named: #securityRequirement type: #OPSecurityRequirement opposite: #securitySchemes"

	<ignoreForCoverage>
	<generated>
	<container>
	^ securityRequirement
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityRequirement: anObject [

	<ignoreForCoverage>
	<generated>
	securityRequirement := anObject
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScheme [
	"Relation named: #securityScheme type: #OPSecurityScheme opposite: #usedByRequiredSecuritySchemes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].'>
	^ securityScheme
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScheme: anObject [

	<ignoreForCoverage>
	<generated>
	securityScheme := anObject
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScopes [
	"Relation named: #securityScopes type: #OPSecurityScope opposite: #usedByRequiredSecuritySchemes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].'>
	^ securityScopes
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScopes: anObject [

	<ignoreForCoverage>
	<generated>
	securityScopes value: anObject
]
