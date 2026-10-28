"
Entities that can be designated by a $ref (reusable objects) and keep the reference they come from.

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `ref` | `String` | nil | The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.|

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

	<ignoreForCoverage>
	<FMClass: #Referenceable super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPReferenceable >> ref [

	<FMProperty: #ref type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.'>
	^ ref
]

{ #category : 'accessing' }
OPReferenceable >> ref: anObject [
	<ignoreForCoverage>
	<generated>
	ref := anObject
]
