"
Serialization rules applied to one property of a media type schema (OpenAPI Encoding Object).

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mediaType` | `OPEncoding` | `encodings` | `OPMediaType` | Opposite reference mediaType from Encoding to MediaType [0..1].|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `headers` | `OPEncoding` | `encoding` | `OPHeader` | Reference headers from Encoding to Header [0..*]: headers sent with the encoded part.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `allowReserved` | `Boolean` | nil | Whether reserved characters are left unescaped [1].|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `contentType` | `String` | nil | Content type(s) accepted for the property [1].|
| `explode` | `Boolean` | nil | Whether array and object values generate separate parameters [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `propertyName` | `String` | nil | Name of the media type schema property this encoding applies to [1].|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `style` | `String` | nil | Serialization style of the property [1].|

"
Class {
	#name : 'OPEncoding',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#allowReserved => FMProperty',
		'#contentType => FMProperty',
		'#explode => FMProperty',
		'#headers => FMMany type: #OPHeader opposite: #encoding',
		'#mediaType => FMOne type: #OPMediaType opposite: #encodings',
		'#propertyName => FMProperty',
		'#style => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPEncoding class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Encoding super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPEncoding >> addHeader: anObject [

	<ignoreForCoverage>
	<generated>
	^ self headers add: anObject
]

{ #category : 'accessing' }
OPEncoding >> allowReserved [

	<FMProperty: #allowReserved type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether reserved characters are left unescaped [1].'>
	^ allowReserved
]

{ #category : 'accessing' }
OPEncoding >> allowReserved: anObject [
	<ignoreForCoverage>
	<generated>
	allowReserved := anObject
]

{ #category : 'accessing' }
OPEncoding >> contentType [

	<FMProperty: #contentType type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Content type(s) accepted for the property [1].'>
	^ contentType
]

{ #category : 'accessing' }
OPEncoding >> contentType: anObject [
	<ignoreForCoverage>
	<generated>
	contentType := anObject
]

{ #category : 'accessing' }
OPEncoding >> explode [

	<FMProperty: #explode type: #Boolean>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Whether array and object values generate separate parameters [1].'>
	^ explode
]

{ #category : 'accessing' }
OPEncoding >> explode: anObject [
	<ignoreForCoverage>
	<generated>
	explode := anObject
]

{ #category : 'accessing' }
OPEncoding >> headers [
	"Relation named: #headers type: #OPHeader opposite: #encoding"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference headers from Encoding to Header [0..*]: headers sent with the encoded part.'>
	^ headers
]

{ #category : 'accessing' }
OPEncoding >> headers: anObject [

	<ignoreForCoverage>
	<generated>
	headers value: anObject
]

{ #category : 'accessing' }
OPEncoding >> mediaType [
	"Relation named: #mediaType type: #OPMediaType opposite: #encodings"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference mediaType from Encoding to MediaType [0..1].'>
	<container>
	^ mediaType
]

{ #category : 'accessing' }
OPEncoding >> mediaType: anObject [

	<ignoreForCoverage>
	<generated>
	mediaType := anObject
]

{ #category : 'accessing' }
OPEncoding >> propertyName [

	<FMProperty: #propertyName type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Name of the media type schema property this encoding applies to [1].'>
	^ propertyName
]

{ #category : 'accessing' }
OPEncoding >> propertyName: anObject [
	<ignoreForCoverage>
	<generated>
	propertyName := anObject
]

{ #category : 'accessing' }
OPEncoding >> style [

	<FMProperty: #style type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Serialization style of the property [1].'>
	^ style
]

{ #category : 'accessing' }
OPEncoding >> style: anObject [
	<ignoreForCoverage>
	<generated>
	style := anObject
]
