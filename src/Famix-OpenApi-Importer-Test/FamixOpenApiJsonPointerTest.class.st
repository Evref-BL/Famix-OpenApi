"
Tests for FamixOpenApiJsonPointer: reference tokenization, encoding and resolution in a parsed JSON tree.
"
Class {
	#name : 'FamixOpenApiJsonPointerTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'helpers' }
FamixOpenApiJsonPointerTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'helpers' }
FamixOpenApiJsonPointerTest >> assertNotFound: aCollection [

	self
		assert: (self resolve: aCollection)
		equals: FamixOpenApiJsonPointer notFound
		description:
		'Tokens ' , aCollection printString , ' should not resolve'
]

{ #category : 'helpers' }
FamixOpenApiJsonPointerTest >> resolve: aCollection [

	^ FamixOpenApiJsonPointer
		  resolveTokens: aCollection
		  in: self sampleTree
]

{ #category : 'helpers' }
FamixOpenApiJsonPointerTest >> sampleTree [

	^ Dictionary new
		  at: 'a' put: (Dictionary new
				   at: 'b' put: 42;
				   yourself);
		  at: 'list' put: (OrderedCollection
			   with: 'zero'
			   with: (Dictionary new
					    at: 'k' put: 'v';
					    yourself)
			   with: 'two');
		  at: 'arr' put: #( 'x' 'y' );
		  at: '/slash' put: 'slashValue';
		  at: '~tilde' put: 'tildeValue';
		  at: '' put: 'emptyKeyValue';
		  at: 'str' put: 'text';
		  at: 'nothing' put: nil;
		  yourself
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testDescendingIntoNilIsNotFound [

	self assertNotFound: #( 'nothing' 'x' )
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testDescendingIntoStringIsNotFound [

	self assertNotFound: #( 'str' '0' ).
	self assertNotFound: #( 'str' 'x' )
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testEmptyStringGivesNoTokens [

	self
		assert: (self tokens: '')
		equals: #(  )
		description: 'An empty reference is the document root'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testEmptyTokenInMiddleIsKept [

	self
		assert: (self tokens: '#/a//b')
		equals: #( 'a' '' 'b' )
		description: 'Empty token is kept'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testEncodeTokenEscapesSlash [

	self
		assert: (FamixOpenApiJsonPointer encodeToken: 'a/b')
		equals: 'a~1b'
		description: '/ becomes ~1'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testEncodeTokenEscapesTilde [

	self
		assert: (FamixOpenApiJsonPointer encodeToken: 'a~b')
		equals: 'a~0b'
		description: '~ becomes ~0'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testEncodeTokenEscapesTildeBeforeSlash [
	"~ must be encoded first, otherwise the ~ introduced by ~1 would be encoded again."

	self
		assert: (FamixOpenApiJsonPointer encodeToken: '~/')
		equals: '~0~1'
		description: '~/ encodes to ~0~1'.
	self
		assert: (FamixOpenApiJsonPointer encodeToken: '~1')
		equals: '~01'
		description: 'literal ~1 encodes to ~01'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testEncodeTokenLeavesPlainTokenUntouched [

	self
		assert: (FamixOpenApiJsonPointer encodeToken: 'plain')
		equals: 'plain'
		description: 'Nothing to escape'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testExternalReferenceAnswersNil [

	self
		assert: (self tokens: 'other.json#/a') isNil
		description: 'A non-local reference has no tokens'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testHashAloneGivesNoTokens [

	self
		assert: (self tokens: '#')
		equals: #(  )
		description: '# is the document root'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testIndexOutOfRangeIsNotFound [

	self assertNotFound: #( 'list' '3' ).
	self assertNotFound: #( 'arr' '2' )
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testIsLocalReferenceFalseForExternal [

	self
		deny: (FamixOpenApiJsonPointer isLocalReference: 'other.json#/a')
		description: 'File reference is not local'.
	self
		deny: (FamixOpenApiJsonPointer isLocalReference: '/a')
		description: 'Does not start with #'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testIsLocalReferenceFalseForNilAndNonStrings [

	self
		deny: (FamixOpenApiJsonPointer isLocalReference: nil)
		description: 'nil'.
	self
		deny: (FamixOpenApiJsonPointer isLocalReference: 42)
		description: 'number'.
	self
		deny: (FamixOpenApiJsonPointer isLocalReference: #( 1 ))
		description: 'array'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testIsLocalReferenceTrueForHash [

	self
		assert: (FamixOpenApiJsonPointer isLocalReference: '#/a/b')
		description: 'Starts with #'.
	self
		assert: (FamixOpenApiJsonPointer isLocalReference: '#')
		description: '# alone is local'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testMissingKeyIsNotFound [

	self assertNotFound: #( 'missing' )
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testMissingNestedKeyIsNotFound [

	self assertNotFound: #( 'a' 'zzz' )
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testNegativeIndexIsNotFound [

	self assertNotFound: #( 'list' '-1' )
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testNestedPointer [

	self
		assert: (self tokens: '#/components/schemas/A/properties/b')
		equals: #( 'components' 'schemas' 'A' 'properties' 'b' )
		description: 'Nested pointer keeps every step in order'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testNonNumericIndexIsNotFound [

	self assertNotFound: #( 'list' 'abc' )
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testNotFoundMarkerIsUnique [

	self
		assert:
		FamixOpenApiJsonPointer notFound == FamixOpenApiJsonPointer notFound
		description: 'Same marker each time'.
	self
		deny: FamixOpenApiJsonPointer notFound isNil
		description: 'Marker is not nil'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testNumericTokensStayStrings [

	self
		assert: (self tokens: '#/arr/0/1')
		equals: #( 'arr' '0' '1' )
		description: 'Index tokens are decimal strings'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testPercentDecodesBraces [

	self
		assert: (self tokens: '#/paths/~1pets~1%7BpetId%7D')
		equals: #( 'paths' '/pets/{petId}' )
		description: '%7B and %7D are braces, ~1 are slashes'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testPercentDecodesSpace [

	self
		assert: (self tokens: '#/components/schemas/My%20Schema')
		equals: #( 'components' 'schemas' 'My Schema' )
		description: '%20 is a space'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testPercentDecodingHappensBeforeTildeDecoding [
	"RFC order: split on /, percent-decode, then ~1 -> / and ~0 -> ~. %7E is a tilde, so %7E1 becomes ~1 and then a slash, inside one token."

	self
		assert: (self tokens: '#/a%7E1b')
		equals: #( 'a/b' )
		description: '%7E1 -> ~1 -> / (percent-decoding first)'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPercentInTokenIsReDecodedLimitation [
	"Known limitation: pointerFromTokens: does not percent-encode, so a literal % sequence in a token is decoded again by tokensFromReference:."

	self
		assert:
		(self tokens:
			 (FamixOpenApiJsonPointer pointerFromTokens: #( '%41' )))
		equals: #( 'A' )
		description: 'Literal %41 is re-decoded as A (no round trip with %)'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testPercentPercentDecodesToSinglePercent [

	self
		assert: (self tokens: '#/a%25b')
		equals: #( 'a%b' )
		description: '%25 is a percent sign'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testPercentTwoFStaysInsideToken [
	"Splitting on / happens before percent-decoding, so %2F does not split the token."

	self
		assert: (self tokens: '#/a%2Fb/c')
		equals: #( 'a/b' 'c' )
		description: '%2F stays inside its token'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerAppendingEncodesToken [

	self
		assert:
		(FamixOpenApiJsonPointer pointer: '#/paths' appending: '/pets')
		equals: '#/paths/~1pets'
		description: 'Appended token is encoded'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerAppendingInteger [

	self
		assert: (FamixOpenApiJsonPointer pointer: '#/a' appending: 3)
		equals: '#/a/3'
		description: 'Integer token appended in decimal'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerAppendingString [

	self
		assert: (FamixOpenApiJsonPointer pointer: '#/a' appending: 'b')
		equals: '#/a/b'
		description: 'String token appended'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerAppendingToRoot [

	self
		assert: (FamixOpenApiJsonPointer pointer: '#' appending: 'paths')
		equals: '#/paths'
		description: 'Appending to the root pointer'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerFromEmptyTokensIsHash [

	self
		assert: (FamixOpenApiJsonPointer pointerFromTokens: #(  ))
		equals: '#'
		description: 'Root pointer'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerFromTokens [

	self
		assert: (FamixOpenApiJsonPointer pointerFromTokens:
				 #( 'components' 'schemas' 'A' ))
		equals: '#/components/schemas/A'
		description: 'Tokens joined by /'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerFromTokensEncodesSlashes [

	self
		assert: (FamixOpenApiJsonPointer pointerFromTokens:
				 #( 'paths' '/pets/{petId}' ))
		equals: '#/paths/~1pets~1{petId}'
		description:
		'Slashes inside tokens are ~1 (braces are not percent-encoded)'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testPointerFromTokensKeepsEmptyToken [

	self
		assert: (FamixOpenApiJsonPointer pointerFromTokens: #( 'a' '' ))
		equals: '#/a/'
		description: 'Empty token gives trailing slash'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testPointerWithoutHashIsAccepted [

	self
		assert: (self tokens: '/a/b')
		equals: #( 'a' 'b' )
		description: 'A bare pointer is accepted'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveArrayIndex [

	self
		assert: (self resolve: #( 'arr' '1' ))
		equals: 'y'
		description: 'Works on Array too'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveDictionaryKeys [

	self
		assert: (self resolve: #( 'a' 'b' ))
		equals: 42
		description: 'Nested dictionary keys'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveEmptyStringKey [

	self
		assert: (self resolve: #( '' ))
		equals: 'emptyKeyValue'
		description: 'Empty key'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveEmptyTokensGivesRoot [

	| tree |
	tree := self sampleTree.
	self
		assert:
		(FamixOpenApiJsonPointer resolveTokens: #(  ) in: tree) == tree
		description: 'No token answers the root node'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveExistingNilValueIsNotNotFound [

	self
		assert: (self resolve: #( 'nothing' )) isNil
		description: 'A present key holding nil answers nil, not the marker'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveExternalReferenceIsNotFound [
	"Assumption: an external reference (no tokens) cannot be resolved locally and answers the marker."

	self
		assert: (FamixOpenApiJsonPointer
				 resolveReference: 'other.json#/a'
				 in: self sampleTree)
		equals: FamixOpenApiJsonPointer notFound
		description: 'External reference is not resolvable'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveKeyWithSlash [

	self
		assert: (self resolve: #( '/slash' ))
		equals: 'slashValue'
		description: 'Key containing /'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveKeyWithTilde [

	self
		assert: (self resolve: #( '~tilde' ))
		equals: 'tildeValue'
		description: 'Key containing ~'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveNeverRaises [

	self
		shouldnt: [ self resolve: #( 'list' 'abc' 'a' '99' '' ) ]
		raise: Error
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveOrderedCollectionIndex [

	self
		assert: (self resolve: #( 'list' '0' ))
		equals: 'zero'
		description: 'Index is 0-based'.
	self
		assert: (self resolve: #( 'list' '1' 'k' ))
		equals: 'v'
		description: 'Descend through array element'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveReferenceDecodesEscapes [

	self
		assert: (FamixOpenApiJsonPointer
				 resolveReference: '#/~1slash'
				 in: self sampleTree)
		equals: 'slashValue'
		description: '~1 decoded before lookup'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveReferenceMissingIsNotFound [

	self
		assert: (FamixOpenApiJsonPointer
				 resolveReference: '#/nope'
				 in: self sampleTree)
		equals: FamixOpenApiJsonPointer notFound
		description: 'Missing target'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testResolveReferenceWithHash [

	self
		assert:
		(FamixOpenApiJsonPointer
			 resolveReference: '#/a/b'
			 in: self sampleTree)
		equals: 42
		description: 'Reference resolved in tree'
]

{ #category : 'tests-encoding' }
FamixOpenApiJsonPointerTest >> testRoundTripOnTrickyTokens [
	"Tokens without % survive pointerFromTokens: then tokensFromReference:. % is excluded, see testPercentInTokenIsReDecodedLimitation."

	#( #( 'a/b' ) #( 'a~b' ) #( '~1' ) #( '~0' ) #( '~01' ) #( '~/~' )
	   #( 'a b' ) #( '{x}' ) #( '/pets/{petId}' 'get' )
	   #( 'a' '' 'b' ) #( '' ) #( '~' '/' '~~' '//' )
	   #( 'a' 'b' 'c' ) ) do: [ :tokens |
		self
			assert:
			(self tokens: (FamixOpenApiJsonPointer pointerFromTokens: tokens))
			equals: tokens
			description: 'Round trip of ' , tokens printString ]
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testSimpleLocalReference [

	self
		assert: (self tokens: '#/a/b')
		equals: #( 'a' 'b' )
		description: 'Fragment pointer splits on /'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testSingleToken [

	self
		assert: (self tokens: '#/paths')
		equals: #( 'paths' )
		description: 'One token'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testTildeOneDecodesToSlash [

	self
		assert: (self tokens: '#/a~1b')
		equals: #( 'a/b' )
		description: '~1 is an escaped slash'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testTildeOneThenTildeZero [

	self
		assert: (self tokens: '#/~1~0')
		equals: #( '/~' )
		description: '~1~0 decodes to /~'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testTildeZeroDecodesToTilde [

	self
		assert: (self tokens: '#/a~0b')
		equals: #( 'a~b' )
		description: '~0 is an escaped tilde'
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testTildeZeroOneDecodesToTildeOneNotSlash [
	"RFC 6901 order pitfall: ~1 must be decoded before ~0, so ~01 is the two characters ~1, not a slash."

	self
		assert: (self tokens: '#/~01')
		equals: #( '~1' )
		description: '~01 must decode to ~1, not /'
]

{ #category : 'tests-resolution' }
FamixOpenApiJsonPointerTest >> testTokenOnNumberIsNotFound [

	self assertNotFound: #( 'a' 'b' 'c' )
]

{ #category : 'tests-tokens' }
FamixOpenApiJsonPointerTest >> testTrailingSlashGivesTrailingEmptyToken [

	self
		assert: (self tokens: '#/a/')
		equals: #( 'a' '' )
		description: 'Trailing slash gives empty last token'
]

{ #category : 'helpers' }
FamixOpenApiJsonPointerTest >> tokens: aString [

	^ FamixOpenApiJsonPointer tokensFromReference: aString
]
