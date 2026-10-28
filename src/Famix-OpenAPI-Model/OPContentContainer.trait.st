"
Entities that describe a payload through media types: Response, RequestBody and Parameter.

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `OPContentContainer` | `contentOwner` | `OPMediaType` | Payload descriptions of the entity, one per media type.|



"
Trait {
	#name : 'OPContentContainer',
	#instVars : [
		'#content => FMMany type: #OPMediaType opposite: #contentOwner'
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
	"Relation named: #content type: #OPMediaType opposite: #contentOwner"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Payload descriptions of the entity, one per media type.'>
	^ content
]

{ #category : 'accessing' }
OPContentContainer >> content: anObject [

	<ignoreForCoverage>
	<generated>
	content value: anObject
]
