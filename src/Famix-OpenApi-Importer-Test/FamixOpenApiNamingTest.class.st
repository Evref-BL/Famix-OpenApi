"
Tests for FamixOpenApiNaming synthesized operation names.
"
Class {
	#name : 'FamixOpenApiNamingTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'tests' }
FamixOpenApiNamingTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> nameFor: aVerb path: aPath [

	^ FamixOpenApiNaming synthesizedOperationNameFor: aVerb path: aPath
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testDashIsNotKeptAsIs [
	"Assumption: non-alphanumerics are removed or underscored, so the result has no dash; only check that and the absence of double underscore."

	| name |
	name := self nameFor: 'get' path: '/pet-owners'.
	self deny: (name includes: $-) description: 'No dash in ' , name.
	self
		deny: (name includesSubstring: '__')
		description: 'No double underscore in ' , name.
	self
		assert: (name beginsWith: 'get_pet')
		description: 'Starts with get_pet: ' , name
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testDotIsNotKeptAsIs [

	| name |
	name := self nameFor: 'get' path: '/files.json'.
	self deny: (name includes: $.) description: 'No dot in ' , name.
	self
		deny: (name includesSubstring: '__')
		description: 'No double underscore in ' , name
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNestedPathSegmentsJoinedByUnderscore [

	self
		assert:
		(self nameFor: 'delete' path: '/owners/{ownerId}/pets/{petId}')
		equals: 'delete_owners_ownerId_pets_petId'
		description: 'Segments joined by _'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNeverContainsDoubleUnderscore [

	#( '/a//b' '/a/{b}/' '/{a}/{b}' '/a-b.c' ) do: [ :path |
		| name |
		name := self nameFor: 'put' path: path.
		self
			deny: (name includesSubstring: '__')
			description: 'No double underscore for ' , path , ': ' , name ]
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testPathParameterBracesAreRemoved [

	self
		assert: (self nameFor: 'get' path: '/pets/{petId}')
		equals: 'get_pets_petId'
		description: 'Spec example'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testSameInputGivesSameName [

	self
		assert: (self nameFor: 'get' path: '/pets/{petId}')
		equals: (self nameFor: 'get' path: '/pets/{petId}')
		description: 'Deterministic'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testSimplePath [

	self
		assert: (self nameFor: 'get' path: '/pets')
		equals: 'get_pets'
		description: 'Single segment'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testTrailingSlashDoesNotAddTrailingUnderscore [
	"Assumption: no double underscore, and a trailing slash adds no empty segment."

	self
		assert: (self nameFor: 'get' path: '/pets/')
		equals: 'get_pets'
		description: 'Trailing slash ignored'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testUppercaseVerbIsLowercased [
	"Assumption: the verb is lowercased (spec says 'lowercase verb')."

	self
		assert: (self nameFor: 'GET' path: '/pets')
		equals: 'get_pets'
		description: 'Verb lowercased'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testVerbIsPrefix [

	self
		assert: (self nameFor: 'post' path: '/pets')
		equals: 'post_pets'
		description: 'Verb prefix'
]
