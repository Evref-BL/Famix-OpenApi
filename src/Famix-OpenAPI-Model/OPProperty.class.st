"
A named property of an object Schema. It binds a name to the Schema of the value and tells whether the property is required.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPProperty` | `properties` | `OPSchema` | The schema declaring the property.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `valueSchema` | `OPProperty` | `usedAsPropertyValueBy` | `OPSchema` | Schema of the property value.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `isRequired` | `Boolean` | nil | Whether the property is listed as required by its declaring schema.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPProperty',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#isRequired => FMProperty',
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
OPProperty >> isRequired [

	<FMProperty: #isRequired type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the property is listed as required by its declaring schema.'>
	^ isRequired
]

{ #category : 'accessing' }
OPProperty >> isRequired: anObject [
	<ignoreForCoverage>
	<generated>
	isRequired := anObject
]

{ #category : 'accessing' }
OPProperty >> schema [
	"Relation named: #schema type: #OPSchema opposite: #properties"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The schema declaring the property.'>
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
	<FMComment: 'Schema of the property value.'>
	^ valueSchema
]

{ #category : 'accessing' }
OPProperty >> valueSchema: anObject [

	<ignoreForCoverage>
	<generated>
	valueSchema := anObject
]
