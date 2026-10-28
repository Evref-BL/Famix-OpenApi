"
XML representation of a Schema (OpenAPI XML Object): element name, namespace, prefix, attribute or wrapped array. Its name is the XML element name.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `schema` | `OPXmlElement` | `xml` | `OPSchema` | The schema declaring the XML element.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `attribute` | `Boolean` | nil | Whether the property is an XML attribute rather than an element.|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `namespace` | `String` | nil | URI of the XML namespace.|
| `prefix` | `String` | nil | Prefix of the XML namespace.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|
| `wrapped` | `Boolean` | nil | Whether the items of an array are wrapped in an enclosing element.|

"
Class {
	#name : 'OPXmlElement',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#attribute => FMProperty',
		'#namespace => FMProperty',
		'#prefix => FMProperty',
		'#schema => FMOne type: #OPSchema opposite: #xml',
		'#wrapped => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPXmlElement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #XmlElement super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPXmlElement >> attribute [

	<FMProperty: #attribute type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the property is an XML attribute rather than an element.'>
	^ attribute
]

{ #category : 'accessing' }
OPXmlElement >> attribute: anObject [
	<ignoreForCoverage>
	<generated>
	attribute := anObject
]

{ #category : 'accessing' }
OPXmlElement >> namespace [

	<FMProperty: #namespace type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URI of the XML namespace.'>
	^ namespace
]

{ #category : 'accessing' }
OPXmlElement >> namespace: anObject [
	<ignoreForCoverage>
	<generated>
	namespace := anObject
]

{ #category : 'accessing' }
OPXmlElement >> prefix [

	<FMProperty: #prefix type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Prefix of the XML namespace.'>
	^ prefix
]

{ #category : 'accessing' }
OPXmlElement >> prefix: anObject [
	<ignoreForCoverage>
	<generated>
	prefix := anObject
]

{ #category : 'accessing' }
OPXmlElement >> schema [
	"Relation named: #schema type: #OPSchema opposite: #xml"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The schema declaring the XML element.'>
	<container>
	^ schema
]

{ #category : 'accessing' }
OPXmlElement >> schema: anObject [

	<ignoreForCoverage>
	<generated>
	schema := anObject
]

{ #category : 'accessing' }
OPXmlElement >> wrapped [

	<FMProperty: #wrapped type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether the items of an array are wrapped in an enclosing element.'>
	^ wrapped
]

{ #category : 'accessing' }
OPXmlElement >> wrapped: anObject [
	<ignoreForCoverage>
	<generated>
	wrapped := anObject
]
