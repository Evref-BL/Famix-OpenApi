"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|



"
Trait {
	#name : 'OPExternalDocsContainer',
	#instVars : [
		'#externalDocs => FMOne type: #OPExternalDocs opposite: #externalDocsContainer'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPExternalDocsContainer classSide >> annotation [

	<FMClass: #ExternalDocsContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocs [
	"Relation named: #externalDocs type: #OPExternalDocs opposite: #externalDocsContainer"

	<generated>
	<FMComment: 'Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].'>
	^ externalDocs
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocs: anObject [

	<generated>
	externalDocs := anObject
]

{ #category : 'navigation' }
OPExternalDocsContainer >> externalDocsGroup [
	<generated>
	<navigation: 'ExternalDocs'>
	^ MooseSpecializedGroup with: self externalDocs
]
