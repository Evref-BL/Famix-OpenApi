"
Keeps the text of the JSON node an entity was built from, for traceability.

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Trait {
	#name : 'OPSourceText',
	#instVars : [
		'#sourceText => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPSourceText classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #SourceText super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPSourceText >> sourceText [

	<FMProperty: #sourceText type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Text of the JSON node the entity was built from.'>
	^ sourceText
]

{ #category : 'accessing' }
OPSourceText >> sourceText: anObject [
	<ignoreForCoverage>
	<generated>
	sourceText := anObject
]
