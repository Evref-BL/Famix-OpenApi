"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPProperty` | `properties` | `OPSchema` | Opposite reference schema from Property to Schema [0..1].|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPSchemaContainer` | `declaringContext` | `OPSchema` | |
| `valueSchema` | `OPProperty` | `usedAsPropertyValueBy` | `OPSchema` | Reference valueSchema from Property to Schema [0..1]: schema of the property value.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `enum` | `Object` | nil | Attribute enum from Property [*] (array of strings)|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `isRequired` | `Boolean` | nil | Whether the property is listed as required by its declaring schema [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `required` | `Boolean` | nil | Attribute required from Property [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

"
Class {
	#name : 'OPProperty',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSchemaContainer + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSchemaContainer classTrait + OPSourceText classTrait',
	#instVars : [
		'#enum => FMProperty',
		'#isRequired => FMProperty',
		'#required => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #properties',
		'#valueSchema => FMOne type: #OPSchema opposite: #usedAsPropertyValueBy'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPProperty class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Property super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPProperty >> enum [

	<FMProperty: #enum type: #Object>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute enum from Property [*] (array of strings)'>
	^ enum
]

{ #category : 'accessing' }
OPProperty >> enum: anObject [
	<ignoreForCoverage>
	<generated>
	enum := anObject
]

{ #category : 'accessing' }
OPProperty >> isRequired [

	<FMProperty: #isRequired type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the property is listed as required by its declaring schema [1].'>
	^ isRequired
]

{ #category : 'accessing' }
OPProperty >> isRequired: anObject [
	<ignoreForCoverage>
	<generated>
	isRequired := anObject
]

{ #category : 'accessing' }
OPProperty >> required [

	<FMProperty: #required type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute required from Property [1]'>
	^ required
]

{ #category : 'accessing' }
OPProperty >> required: anObject [
	<ignoreForCoverage>
	<generated>
	required := anObject
]

{ #category : 'accessing' }
OPProperty >> schema [
	"Relation named: #schema type: #OPSchema opposite: #properties"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference schema from Property to Schema [0..1].'>
	<container>
	^ schema
]

{ #category : 'accessing' }
OPProperty >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPProperty >> valueSchema [
	"Relation named: #valueSchema type: #OPSchema opposite: #usedAsPropertyValueBy"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference valueSchema from Property to Schema [0..1]: schema of the property value.'>
	^ valueSchema
]

{ #category : 'accessing' }
OPProperty >> valueSchema: anObject [

	<ignoreForCoverage>
	<generated>
	valueSchema := anObject
]
