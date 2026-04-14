"
Generated from openapi2.ecore

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|

"
Trait {
	#name : 'OPReferenceable',
	#instVars : [
		'#ref => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPReferenceable classSide >> annotation [

	<FMClass: #Referenceable super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPReferenceable >> ref [

	<FMProperty: #ref type: #String>
	<generated>
	<FMComment: 'Attribute ref from Reference Object [1]'>
	^ ref
]

{ #category : 'accessing' }
OPReferenceable >> ref: anObject [
	<generated>
	ref := anObject
]
