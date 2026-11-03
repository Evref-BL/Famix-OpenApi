"
Tests of FamixOpenApiDiagnosticCoverage (V9): the index by pointer, the roles of the codes (data with notes) and, by import experiments with the REAL importer, the pointer that each relevant diagnostic carries (the key, the node or the operation).
"
Class {
	#name : 'FamixOpenApiDiagnosticCoverageTest',
	#superclass : 'FamixOpenApiExtensionsTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiDiagnosticCoverageTest >> pointersOf: aCode in: aJsonString [
	"The pointers of the diagnostics of the code that the real importer gives for the document, sorted"

	| pointers |
	pointers := OrderedCollection new.
	(self importedOf: aJsonString) last do: [ :each |
		each code = aCode ifTrue: [ pointers add: each pointer ] ].
	^ pointers sorted asArray
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testDroppedParametersDiagnosticsPointers [
	"VERIFIED by import: extraBodyParameter has the pointer of the parameter, conflictingBodyAndFormData the one of the operation"

	self
		assert:
		(self
			 pointersOf: #extraBodyParameter
			 in: self documentBodiesSwagger2)
		equals: #( '#/paths/~1p/post/parameters/1' ).
	self
		assert: (self
				 pointersOf: #conflictingBodyAndFormData
				 in: self documentBodiesSwagger2)
		equals: #( '#/paths/~1p/post' )
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testEveryCodeSeenHasARoleAndTheOthersAreNotAboutKeys [

	| roles |
	roles := FamixOpenApiDiagnosticCoverage dataRows
		         collect: #second
		         as: Set.
	self
		assert: roles
		equals: #( #keyKept #siblingsIgnored #nodeDropped #childrenDropped
			   #valueRejected #other ) asSet.
	#( #unmodelledKeyword #unknownKeyword #refSiblingsIgnored
	   #extraBodyParameter #conflictingBodyAndFormData
	   #wrongNodeType #discriminatorUnresolved #componentAlias
	   #unresolvedReference #securitySchemeUnresolved ) do: [ :each |
		self
			assert:
				(FamixOpenApiDiagnosticCoverage dataRows anySatisfy: [ :row |
					 row first = each ])
			description: each ].
	self
		assert:
		(FamixOpenApiDiagnosticCoverage roleOf: #unresolvedReference)
		equals: #other.
	self
		assert: (FamixOpenApiDiagnosticCoverage roleOf: #neverSeen)
		equals: #other.
	self
		assert:
		(FamixOpenApiDiagnosticCoverage excusingRoles includes: #keyKept)
		equals: false
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testIndexByPointerAndRole [
	"Any objects that answer #code and #pointer; nil is not decidable"

	| coverage |
	coverage := FamixOpenApiDiagnosticCoverage on: {
			            (FamixOpenApiStubDiagnostic
				             code: #refSiblingsIgnored
				             pointer: '#/a').
			            (FamixOpenApiStubDiagnostic
				             code: #unknownKeyword
				             pointer: '#/a/k').
			            (FamixOpenApiStubDiagnostic
				             code: #unresolvedReference
				             pointer: '#/a') }.
	self assert: coverage isDecidable.
	self
		assert: (coverage codesAt: '#/a' role: #siblingsIgnored) asArray
		equals: #( #refSiblingsIgnored ).
	self assert: (coverage codesAt: '#/a' role: #nodeDropped) isEmpty.
	self
		assert: (coverage codesAt: '#/a/k' role: #keyKept) asArray
		equals: #( #unknownKeyword ).
	self assert: (coverage codesAt: '#/b' role: #keyKept) isEmpty.
	coverage := FamixOpenApiDiagnosticCoverage on: nil.
	self deny: coverage isDecidable.
	self assert: (coverage codesAt: '#/a' role: #siblingsIgnored) isEmpty.
	self assert: (FamixOpenApiDiagnosticCoverage on: #(  )) isDecidable
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testKeywordDiagnosticsHaveTheKeyPointer [
	"VERIFIED by import: unmodelledKeyword and unknownKeyword carry the pointer of the KEY (node pointer, key)"

	self
		assert:
			(self pointersOf: #unmodelledKeyword in: self documentExtensions31)
				first
		equals: '#/components/examples/e/description'.
	self
		assert:
		(self pointersOf: #unknownKeyword in: self documentExtensions30)
		equals: #( '#/zzz' ).
	self
		assert: (self
				 pointersOf: #unmodelledKeyword
				 in: self documentExtensionsSwagger2)
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testMarkdownMappingHasOneRowPerCodeAndLfLineEnds [

	| text |
	text := FamixOpenApiDiagnosticCoverage markdownMapping.
	self deny: (text includes: Character cr).
	self
		assert: text lines size
		equals: FamixOpenApiDiagnosticCoverage dataRows size + 2.
	self assert: (text includesSubstring:
			 '| refSiblingsIgnored | siblingsIgnored | node | yes |').
	self assert:
		(text includesSubstring:
			 '| unmodelledKeyword | keyKept | key | no |')
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testRefSiblingsIgnoredHasTheNodePointer [
	"VERIFIED by import: the pointer of refSiblingsIgnored is the one of the NODE (a schema, a path item that resolves), and nothing is said for a parameter, a response, a header, a link, a request body or a path item that does not resolve"

	self
		assert:
		(self pointersOf: #refSiblingsIgnored in: self documentSiblings30)
		equals: #( '#/components/schemas/O/properties/p'
			   '#/components/schemas/S' '#/paths/~1q' ).
	self
		assert:
		(self pointersOf: #refSiblingsIgnored in: self documentSiblings31)
		equals: #(  ).
	self
		assert: (self
				 pointersOf: #refSiblingsIgnored
				 in: self documentSiblingsSwagger2)
		equals:
		#( '#/definitions/A' '#/paths/~1p/get/responses/200/schema' )
]

{ #category : 'tests' }
FamixOpenApiDiagnosticCoverageTest >> testWrongNodeTypeHasTheKeyPointerAndIsNotSaidForEveryField [
	"VERIFIED by import: wrongNodeType carries the pointer of the key; maximum, minimum and nullable of a schema are dropped without one"

	self
		assert:
		(self pointersOf: #wrongNodeType in: self documentWrongTypes30)
		equals:
		#( '#/components/schemas/S/format' '#/info/title' '#/paths/~1p/get/deprecated' )
]
