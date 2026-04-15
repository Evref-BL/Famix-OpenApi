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

	<FMClass: #ParameterContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPParameterContainer >> parameter [
	"Relation named: #parameter type: #OPParameter opposite: #declaringContext"

	<generated>
	<derived>
	^ parameter
]

{ #category : 'accessing' }
OPParameterContainer >> parameter: anObject [

	<generated>
	parameter := anObject
]
