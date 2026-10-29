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
FamixOpenApiNamingTest >> testLimitedCollapsesNewlinesAndTabs [

	self
		assert: (FamixOpenApiNaming limited: 'a
		b		c')
		equals: 'a b c'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedCollapsesRunsOfWhitespaceAndControlCharacters [

	self
		assert: (FamixOpenApiNaming limited: (String withAll: {
						  $a.
						  Character space.
						  Character space.
						  Character tab.
						  Character cr.
						  Character lf.
						  (Character value: 0).
						  $b }))
		equals: 'a b'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedCountsUnicodeAsOneCharacter [

	| result |
	result := FamixOpenApiNaming limited: (String
			           new: FamixOpenApiNaming maxNameLength
			           withAll: (Character value: 233)).
	self assert: result size equals: FamixOpenApiNaming maxNameLength.
	self assert: result last equals: (Character value: 233)
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedKeepsATextOfExactlyMaxNameLength [

	| text |
	text := String new: FamixOpenApiNaming maxNameLength withAll: $x.
	self assert: (FamixOpenApiNaming limited: text) equals: text
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedKeepsUnicode [

	self
		assert: (FamixOpenApiNaming limited:
				 'Caf' , (String with: (Character value: 233)) , ' '
				 , (String with: (Character value: 16r4E2D)))
		equals: 'Caf' , (String with: (Character value: 233)) , ' '
			, (String with: (Character value: 16r4E2D))
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedNeverLeavesASpaceBeforeTheEllipsis [

	| result |
	result := FamixOpenApiNaming limited:
		          (String
			           new: FamixOpenApiNaming maxNameLength - 2
			           withAll: $x) , ' yyyy'.
	self assert: result size <= FamixOpenApiNaming maxNameLength.
	self assert: result last equals: (Character value: 16r2026).
	self deny: (result at: result size - 1) isSeparator
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedOfBlankStringIsEmpty [

	self
		assert:
		(FamixOpenApiNaming limited: '  ' , (String with: Character tab))
		equals: ''
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedOfEmptyStringIsEmpty [

	self assert: (FamixOpenApiNaming limited: '') equals: ''
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedOfNilIsEmptyString [

	self assert: (FamixOpenApiNaming limited: nil) equals: ''
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedTrimsTheEnds [

	self
		assert: (FamixOpenApiNaming limited: (String withAll: {
						  Character lf.
						  Character space.
						  $a.
						  Character tab }))
		equals: 'a'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedTruncatesOneCharacterOverMaxNameLength [

	| result |
	result := FamixOpenApiNaming limited:
		          (String
			           new: FamixOpenApiNaming maxNameLength + 1
			           withAll: $x).
	self assert: result size equals: FamixOpenApiNaming maxNameLength.
	self assert: result last equals: (Character value: 16r2026).
	self
		assert: result allButLast
		equals:
		(String new: FamixOpenApiNaming maxNameLength - 1 withAll: $x)
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNameFromAnyAnswersTheFallbackWhenNoCandidate [

	self
		assert: (FamixOpenApiNaming nameFromAny: { nil. '' } fallback: 'fb')
		equals: 'fb'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNameFromAnyAnswersTheFirstNonBlankCandidate [

	self
		assert: (FamixOpenApiNaming
				 nameFromAny: { nil. '  '. 'b'. 'c' }
				 fallback: 'fb')
		equals: 'b'
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
