"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `response` | `OPResponseContainer` | `declaringContext` | `OPResponse` | |



"
Trait {
	#name : 'OPResponseContainer',
	#instVars : [
		'#response => FMOne type: #OPResponse opposite: #declaringContext'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPResponseContainer classSide >> annotation [

	<FMClass: #ResponseContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPResponseContainer >> response [
	"Relation named: #response type: #OPResponse opposite: #declaringContext"

	<generated>
	<derived>
	^ response
]

{ #category : 'accessing' }
OPResponseContainer >> response: anObject [

	<generated>
	response := anObject
]
