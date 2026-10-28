"
A scope offered by an OAuth2 flow, with its description. Scopes exist only under OAuthFlow.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `oauthFlow` | `OPSecurityScope` | `scopes` | `OPOAuthFlow` | The flow offering the scope.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.|
| `description` | `String` | nil | Description of what the scope grants.|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sourceText` | `String` | nil | Text of the JSON node the entity was built from.|

"
Class {
	#name : 'OPSecurityScope',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPSourceText classTrait',
	#instVars : [
		'#description => FMProperty',
		'#oauthFlow => FMOne type: #OPOAuthFlow opposite: #scopes'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPSecurityScope class >> annotation [

	<ignoreForCoverage>
	<FMClass: #SecurityScope super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'accessing' }
OPSecurityScope >> description [

	<FMProperty: #description type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Description of what the scope grants.'>
	^ description
]

{ #category : 'accessing' }
OPSecurityScope >> description: anObject [
	<ignoreForCoverage>
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPSecurityScope >> oauthFlow [
	"Relation named: #oauthFlow type: #OPOAuthFlow opposite: #scopes"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The flow offering the scope.'>
	<container>
	^ oauthFlow
]

{ #category : 'accessing' }
OPSecurityScope >> oauthFlow: anObject [

	<ignoreForCoverage>
	<generated>
	oauthFlow := anObject
]
