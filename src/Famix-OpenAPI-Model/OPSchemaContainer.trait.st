"
Generated from openapi2.ecore

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |



"
Trait {
	#name : 'OPSchemaContainer',
	#instVars : [
		'#schema => FMOne type: #OPSchema opposite: #declaringContext'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPSchemaContainer classSide >> annotation [

	<FMClass: #SchemaContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPSchemaContainer >> schema [
	"Relation named: #schema type: #OPSchema opposite: #declaringContext"

	<generated>
	<derived>
	^ schema
]

{ #category : 'accessing' }
OPSchemaContainer >> schema: anObject [

	<generated>
	schema := anObject
]
