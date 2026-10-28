"
Entities that may point to external documentation: Operation, Schema and Tag.

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `externalDocs` | `OPExternalDocsContainer` | `externalDocsContainer` | `OPExternalDocumentation` | External documentation of the entity.|



"
Trait {
	#name : 'OPExternalDocsContainer',
	#instVars : [
		'#externalDocs => FMOne type: #OPExternalDocumentation opposite: #externalDocsContainer'
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
	"Relation named: #externalDocs type: #OPExternalDocumentation opposite: #externalDocsContainer"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'External documentation of the entity.'>
	^ externalDocs
]

{ #category : 'accessing' }
OPExternalDocsContainer >> externalDocs: anObject [

	<ignoreForCoverage>
	<generated>
	externalDocs := anObject
]
