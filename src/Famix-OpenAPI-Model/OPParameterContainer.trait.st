"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parameter` | `OPParameterContainer` | `declaringContext` | `OPParameter` | |



"
Trait {
	#name : 'OPParameterContainer',
	#instVars : [
		'#parameter => FMOne type: #OPParameter opposite: #declaringContext'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPParameterContainer classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #ParameterContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPParameterContainer >> parameter [
	"Relation named: #parameter type: #OPParameter opposite: #declaringContext"

	<ignoreForCoverage>
	<generated>
	^ parameter
]

{ #category : 'accessing' }
OPParameterContainer >> parameter: anObject [

	<ignoreForCoverage>
	<generated>
	parameter := anObject
]
