"
A Schema that is a strict subset of a larger Schema (same property names with equivalent value schemas). Created by the importer, it does not exist as such in the source document; subSchemaOf points to the larger Schema.

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `subSchemaOf` | `OPSubSchema` | `subSchemas` | `OPSchema` | The larger Schema of which the receiver is a strict subset (same property names, with equivalent value schemas).|



"
Class {
	#name : 'OPSubSchema',
	#superclass : 'OPSchema',
	#instVars : [
		'#subSchemaOf => FMOne type: #OPSchema opposite: #subSchemas'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSubSchema class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SubSchema super: #OPSchema>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPSubSchema >> subSchemaOf [
	"Relation named: #subSchemaOf type: #OPSchema opposite: #subSchemas"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The larger Schema of which the receiver is a strict subset (same property names, with equivalent value schemas).'>
	^ subSchemaOf
]

{ #category : 'accessing' }
OPSubSchema >> subSchemaOf: anObject [

	<ignoreForCoverage>
	<generated>
	subSchemaOf := anObject
]
