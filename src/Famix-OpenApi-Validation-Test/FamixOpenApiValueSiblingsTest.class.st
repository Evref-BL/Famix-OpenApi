"
The keys beside the $ref of a schema in the value check: OpenAPI 3.0 and Swagger 2 (the spec ignores them, and the importer, except for the description of an alias, an entry of the components that is only a $ref) are not expectations and are counted as ignored siblings; OpenAPI 3.1 compares them all. Every keyword a schema can have is tried, in every place of a schema, with a change of the source that must make no gap (the description of an alias excepted).
"
Class {
	#name : 'FamixOpenApiValueSiblingsTest',
	#superclass : 'FamixOpenApiValueTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'asserting' }
FamixOpenApiValueSiblingsTest >> assertSiblings: aKind key: aKey sourceChangeGives: aNumber [
	"The real import of the schemas that are a $ref with the keyword beside the $ref has no gap; the same document written in the source with another value of the keyword (the model is not changed) gives the number of gaps"

	| real changed gaps |
	real := self
		        documentSiblings: aKind
		        fragment:
		        (self siblingFragmentOf: aKind keys: { aKey } variant: 1).
	changed := self
		           documentSiblings: aKind
		           fragment:
		           (self siblingFragmentOf: aKind keys: { aKey } variant: 2).
	self assertFaithfulValues: real.
	gaps := (self valueCheckOf: changed model: (self modelOf: real))
		        report gaps.
	self
		assert: gaps size = aNumber
		description: aKind , ' ' , aKey , ' ' , gaps printString
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheDescriptionBesideTheRefOfAnAliasIsStillExpected [
	"The importer reads it for an alias of the components, contrary to the spec (knownImporterGaps): a change of the source is one gap, for the alias only"

	#( #v30 #v2 ) do: [ :kind |
		self assertSiblings: kind key: 'description' sourceChangeGives: 1 ]
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheDescriptionOfAnAliasIsExpectedAndTheOtherKeysBesideItsRefAreNot [

	#( #v30 #v2 ) do: [ :kind |
		| json pointer |
		json := self documentSiblings: kind fragment: (self
				         siblingFragmentOf: kind
				         keys: #( 'description' 'title' 'readOnly' )
				         variant: 1).
		pointer := kind = #v2
			           ifTrue: [ '#/definitions/A' ]
			           ifFalse: [ '#/components/schemas/A' ].
		self
			assert: (self
					 expectedAt: pointer
					 field: 'description'
					 class: 'OPSchema'
					 in: json)
			equals: 'D1'.
		self
			assert: (self
					 expectedAt: pointer
					 field: 'title'
					 class: 'OPSchema'
					 in: json)
			equals: nil.
		self
			assert: (self
					 expectedAt: pointer
					 field: 'readOnly'
					 class: 'OPSchema'
					 in: json)
			equals: false ]
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheKeysBesideTheRefAreCountedAsIgnoredSiblingsOnlyInOpenApi30AndSwagger2 [
	"9 schemas that are a $ref in the document of OpenAPI 3.0, 7 in the one of Swagger 2; the description of the alias is read, not ignored"

	| keys coverage |
	keys := #( 'description' 'title' 'x-a' ).
	#( #v30 #v2 ) with: #( 9 7 ) do: [ :kind :count |
		coverage := self coverageOf: (self
				             documentSiblings: kind
				             fragment:
				             (self siblingFragmentOf: kind keys: keys variant: 1)).
		self assert: (coverage ignoredSiblingCountOf: 'title') equals: count.
		self assert: (coverage ignoredSiblingCountOf: 'x-a') equals: count.
		self
			assert: (coverage ignoredSiblingCountOf: 'description')
			equals: count - 1.
		self assert: (coverage ignoredSiblingCountOf: '$ref') equals: 0.
		self assert: coverage totalIgnoredSiblings equals: count * 3 - 1 ].
	coverage := self coverageOf: (self
			             documentSiblings: #v31
			             fragment:
			             (self siblingFragmentOf: #v31 keys: keys variant: 1)).
	self assert: coverage totalIgnoredSiblings equals: 0
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheKeysBesideTheRefOfASchemaAreNotExpectedInOpenApi30AndSwagger2 [
	"VERIFIED by import: the importer ignores them, as the spec requires: a keyword changed in the source makes no gap, for every keyword, in every place of a schema (alias, property, items, allOf, media type, parameter, body, response)"

	#( #v30 #v2 ) do: [ :kind |
		(self siblingKeysOf: kind) do: [ :each |
			each = 'description' ifFalse: [
				self assertSiblings: kind key: each sourceChangeGives: 0 ] ] ]
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheKeysBesideTheRefOfASchemaThatOpenApi31DoesNotCompareMakeNoGap [

	#( 'nullable' 'properties' 'items' 'additionalProperties'
	   'allOf' 'oneOf' 'not' 'discriminator' 'xml' 'externalDocs'
	   'x-a' ) do: [ :each |
		self assertSiblings: #v31 key: each sourceChangeGives: 0 ]
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheSchemasThatAreOnlyARefHaveAllTheirKeysBesideItComparedInOpenApi31 [
	"VERIFIED: OpenAPI 3.1 reads the siblings: a schema of its own whose allOf holds the target, in the 9 places. A keyword changed in the source is a gap in each of them (the keywords the importer does not read in 3.1 are in the other test)"

	#( 'description' 'title' 'readOnly' 'writeOnly' 'deprecated'
	   'uniqueItems' 'example' 'default' 'enum' 'type' 'format' 'minimum'
	   'maximum' 'multipleOf' 'minLength' 'maxLength' 'pattern' 'minItems'
	   'maxItems' 'minProperties' 'maxProperties' 'required' ) do: [
		:each | self assertSiblings: #v31 key: each sourceChangeGives: 9 ]
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheSiblingsOfAPathItemThatDoesNotResolveAreExpectedInOpenApi31 [
	"VERIFIED by import: the spec makes the summary and the description beside the $ref fields of the path item, the importer gives nil when the $ref does not resolve (knownImporterGaps): the two values are reported"

	| gaps |
	gaps := (self valueReportOf:
		         '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{"/a":{"$ref":"#/paths/~1none","summary":"sib","description":"sd"}}}')
		        gaps.
	self assert: gaps size equals: 2.
	self
		assert: (gaps collect: #fieldKey) asArray
		equals: #( 'summary' 'description' ).
	self
		assert: (gaps collect: #expected) asArray
		equals: #( 'sib' 'sd' )
]

{ #category : 'tests' }
FamixOpenApiValueSiblingsTest >> testTheSiblingsOfAPathItemThatDoesNotResolveAreIgnoredInOpenApi30 [
	"VERIFIED by import: the summary and the description beside the $ref of a path item that does not resolve are nil in the model (the spec ignores them in 3.0), they are counted as ignored siblings"

	| json coverage |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/a":{"$ref":"#/paths/~1none","summary":"sib","description":"sd"}}}'.
	self assertFaithfulValues: json.
	coverage := self coverageOf: json.
	self assert: (coverage ignoredSiblingCountOf: 'summary') equals: 1.
	self
		assert: (coverage ignoredSiblingCountOf: 'description')
		equals: 1
]
