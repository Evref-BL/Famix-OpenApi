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
| `securityScheme` | `OPRequiredSecurityScheme` | `requiredSecurityScheme` | `OPSecurityScheme` | Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].|
| `securityScopes` | `OPRequiredSecurityScheme` | `requiredSecurityScheme` | `OPSecurityScope` | Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].|


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
		'#securityScopes => FMMany type: #OPSecurityScope opposite: #requiredSecurityScheme',
		'#securityScheme => FMOne type: #OPSecurityScheme opposite: #requiredSecurityScheme'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPRequiredSecurityScheme class >> annotation [

	<FMClass: #RequiredSecurityScheme super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPRequiredSecurityScheme >> addSecurityScope: anObject [
	<generated>
	^ self securityScopes add: anObject
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityRequirement [
	"Relation named: #securityRequirement type: #OPSecurityRequirement opposite: #securitySchemes"

	<generated>
	<container>
	^ securityRequirement
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityRequirement: anObject [

	<generated>
	securityRequirement := anObject
]

{ #category : 'navigation' }
OPRequiredSecurityScheme >> securityRequirementGroup [
	<generated>
	<navigation: 'SecurityRequirement'>
	^ MooseSpecializedGroup with: self securityRequirement
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScheme [
	"Relation named: #securityScheme type: #OPSecurityScheme opposite: #requiredSecurityScheme"

	<generated>
	<FMComment: 'Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].'>
	^ securityScheme
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScheme: anObject [

	<generated>
	securityScheme := anObject
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScopes [
	"Relation named: #securityScopes type: #OPSecurityScope opposite: #requiredSecurityScheme"

	<generated>
	<FMComment: 'Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].'>
	<derived>
	^ securityScopes
]

{ #category : 'accessing' }
OPRequiredSecurityScheme >> securityScopes: anObject [

	<generated>
	securityScopes value: anObject
]
