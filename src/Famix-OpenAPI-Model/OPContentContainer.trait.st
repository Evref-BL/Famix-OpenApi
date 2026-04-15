"
Generated from openapi2.ecore

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentContainer` | `OPMediaTypeEntry` | Reference content from ContentContainer to MediaTypeEntry [0..*].|



"
Trait {
	#name : 'OPContentContainer',
	#instVars : [
		'#content => FMMany type: #OPMediaTypeEntry opposite: #contentContainer'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPContentContainer classSide >> annotation [

	<FMClass: #ContentContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
OPContentContainer >> addContent: anObject [
	<generated>
	^ self content add: anObject
]

{ #category : 'accessing' }
OPContentContainer >> content [
	"Relation named: #content type: #OPMediaTypeEntry opposite: #contentContainer"

	<generated>
	<FMComment: 'Reference content from ContentContainer to MediaTypeEntry [0..*].'>
	<derived>
	^ content
]

{ #category : 'accessing' }
OPContentContainer >> content: anObject [

	<generated>
	content value: anObject
]

{ #category : 'navigation' }
OPContentContainer >> contentGroup [
	<generated>
	<navigation: 'Content'>
	^ MooseSpecializedGroup withAll: self content asSet
]
