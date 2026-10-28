"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocs` | Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].|
| `externalDocumentation` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.|



"
Trait {
	#name : 'OPExternalDocsContainer',
	#instVars : [
		'#externalDocs => FMOne type: #OPExternalDocs opposite: #externalDocsContainer',
		'#externalDocumentation => FMOne type: #OPExternalDocumentation opposite: #externalDocsContainer'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPExternalDocsContainer classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #ExternalDocsContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocs [
	"Relation named: #externalDocs type: #OPExternalDocs opposite: #externalDocsContainer"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].'>
	^ externalDocs
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocs: anObject [

	<ignoreForCoverage>
	<generated>
	externalDocs := anObject
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocumentation [
	"Relation named: #externalDocumentation type: #OPExternalDocumentation opposite: #externalDocsContainer"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.'>
	^ externalDocumentation
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocumentation: anObject [

	<ignoreForCoverage>
	<generated>
	externalDocumentation := anObject
]
