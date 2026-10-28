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

	<ignoreForCoverage>
	<FMClass: #ContentContainer super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPContentContainer >> addContent: anObject [

	<ignoreForCoverage>
	<generated>
	^ self content add: anObject
]

{ #category : 'accessing' }
OPContentContainer >> content [
	"Relation named: #content type: #OPMediaTypeEntry opposite: #contentContainer"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Reference content from ContentContainer to MediaTypeEntry [0..*].'>
	^ content
]

{ #category : 'accessing' }
OPContentContainer >> content: anObject [

	<ignoreForCoverage>
	<generated>
	content value: anObject
]
