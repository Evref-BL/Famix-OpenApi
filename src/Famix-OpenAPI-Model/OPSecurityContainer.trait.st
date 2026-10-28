"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `security` | `OPSecurityContainer` | `securityContainer` | `OPSecurityRequirement` | Reference security from SecurityContainer to SecurityRequirement [0..*].|



"
Trait {
	#name : 'OPSecurityContainer',
	#instVars : [
		'#security => FMMany type: #OPSecurityRequirement opposite: #securityContainer'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPSecurityContainer classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecurityContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPSecurityContainer >> addSecurity: anObject [

	<ignoreForCoverage>
	<generated>
	^ self security add: anObject
]

{ #category : 'accessing' }
OPSecurityContainer >> security [
	"Relation named: #security type: #OPSecurityRequirement opposite: #securityContainer"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference security from SecurityContainer to SecurityRequirement [0..*].'>
	^ security
]

{ #category : 'accessing' }
OPSecurityContainer >> security: anObject [

	<ignoreForCoverage>
	<generated>
	security value: anObject
]
