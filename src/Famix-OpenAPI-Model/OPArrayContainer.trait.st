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

	<FMClass: #ArrayContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPArrayContainer >> collectionFormat [

	<FMProperty: #collectionFormat type: #String>
	<generated>
	<FMComment: 'Attribute collectionFormat from ArrayContainer [1]'>
	^ collectionFormat
]

{ #category : 'accessing' }
OPArrayContainer >> collectionFormat: anObject [
	<generated>
	collectionFormat := anObject
]

{ #category : 'accessing' }
OPArrayContainer >> items [
	"Relation named: #items type: #OPItemsDefinition opposite: #arrayContainer"

	<generated>
	<FMComment: 'Reference items from ArrayContainer to ItemsDefinition [0..1].'>
	^ items
]

{ #category : 'accessing' }
OPArrayContainer >> items: anObject [

	<generated>
	items := anObject
]

{ #category : 'navigation' }
OPArrayContainer >> itemsGroup [
	<generated>
	<navigation: 'Items'>
	^ MooseSpecializedGroup with: self items
]
