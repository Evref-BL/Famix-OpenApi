"
Common part of the entities of the canonical OpenAPI 3.1 shape: the JSON pointer of the entity in the canonical document and its specification extensions (x-* keys).

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|

"
Trait {
	#name : 'OPCanonicalNode',
	#instVars : [
		'#canonicalPointer => FMProperty',
		'#extensions => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPCanonicalNode classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #CanonicalNode super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPCanonicalNode >> canonicalPointer [

	<FMProperty: #canonicalPointer type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].'>
	^ canonicalPointer
]

{ #category : 'accessing' }
OPCanonicalNode >> canonicalPointer: anObject [
	<ignoreForCoverage>
	<generated>
	canonicalPointer := anObject
]

{ #category : 'accessing' }
OPCanonicalNode >> extensions [

	<FMProperty: #extensions type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Specification extensions (x-* keys) of the source node, as a JSON object text [1].'>
	^ extensions
]

{ #category : 'accessing' }
OPCanonicalNode >> extensions: anObject [
	<ignoreForCoverage>
	<generated>
	extensions := anObject
]
