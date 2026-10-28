"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `items` | `OPArrayContainer` | `arrayContainer` | `OPItemsDefinition` | Reference items from ArrayContainer to ItemsDefinition [0..1].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `collectionFormat` | `String` | nil | Attribute collectionFormat from ArrayContainer [1]|

"
Trait {
	#name : 'OPArrayContainer',
	#instVars : [
		'#collectionFormat => FMProperty',
		'#items => FMOne type: #OPItemsDefinition opposite: #arrayContainer'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPArrayContainer classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #ArrayContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPArrayContainer >> collectionFormat [

	<FMProperty: #collectionFormat type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute collectionFormat from ArrayContainer [1]'>
	^ collectionFormat
]

{ #category : 'accessing' }
OPArrayContainer >> collectionFormat: anObject [
	<ignoreForCoverage>
	<generated>
	collectionFormat := anObject
]

{ #category : 'accessing' }
OPArrayContainer >> items [
	"Relation named: #items type: #OPItemsDefinition opposite: #arrayContainer"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference items from ArrayContainer to ItemsDefinition [0..1].'>
	^ items
]

{ #category : 'accessing' }
OPArrayContainer >> items: anObject [

	<ignoreForCoverage>
	<generated>
	items := anObject
]
