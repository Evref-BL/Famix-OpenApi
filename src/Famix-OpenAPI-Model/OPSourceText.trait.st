"
Generated from openapi2.ecore

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|

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
	<FMComment: 'Attribute sourceText from original JSON node [1]'>
	^ sourceText
]

{ #category : 'accessing' }
OPSourceText >> sourceText: anObject [
	<ignoreForCoverage>
	<generated>
	sourceText := anObject
]
