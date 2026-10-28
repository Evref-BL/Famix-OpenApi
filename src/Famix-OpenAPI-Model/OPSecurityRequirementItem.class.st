"
One security scheme required by a SecurityRequirement, with the names of the scopes needed from it.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `requirement` | `OPSecurityRequirementItem` | `items` | `OPSecurityRequirement` | The requirement the item belongs to.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `scheme` | `OPSecurityRequirementItem` | `usedBySecurityRequirementItems` | `OPSecurityScheme` | The security scheme required by the item.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `scopeNames` | `String` | #() | Names of the scopes required from the security scheme (empty when the scheme has no scopes).|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPSecurityRequirementItem',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#requirement => FMOne type: #OPSecurityRequirement opposite: #items',
		'#scheme => FMOne type: #OPSecurityScheme opposite: #usedBySecurityRequirementItems',
		'#scopeNames => FMProperty defaultValue: #()'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityRequirementItem class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecurityRequirementItem super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPSecurityRequirementItem >> requirement [
	"Relation named: #requirement type: #OPSecurityRequirement opposite: #items"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The requirement the item belongs to.'>
	<container>
	^ requirement
]

{ #category : 'accessing' }
OPSecurityRequirementItem >> requirement: anObject [

	<ignoreForCoverage>
	<generated>
	requirement := anObject
]

{ #category : 'accessing' }
OPSecurityRequirementItem >> scheme [
	"Relation named: #scheme type: #OPSecurityScheme opposite: #usedBySecurityRequirementItems"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The security scheme required by the item.'>
	^ scheme
]

{ #category : 'accessing' }
OPSecurityRequirementItem >> scheme: anObject [

	<ignoreForCoverage>
	<generated>
	scheme := anObject
]

{ #category : 'accessing' }
OPSecurityRequirementItem >> scopeNames [

	<FMProperty: #scopeNames type: #String defaultValue: #()>
	<ignoreForCoverage>
	<generated>
	<multivalued>
	<FMComment: 'Names of the scopes required from the security scheme (empty when the scheme has no scopes).'>
	^ scopeNames ifNil: [ scopeNames := #() ]
]

{ #category : 'accessing' }
OPSecurityRequirementItem >> scopeNames: anObject [
	<ignoreForCoverage>
	<generated>
	scopeNames := anObject
]
