"
V10, tier 1 (the containers): the relations of the root, the components, the path items, the operations, the responses, the parameters and the media types against the source, with what each derivation designates VERIFIED by import (shared and cloned $ref, aliases, duplicates, unresolved and cyclic references, order of the source).
"
Class {
	#name : 'FamixOpenApiRelationStructureTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testACallbackPathItemThatIsAReferenceIsSharedWhenItsTargetIsRegisteredBeforeAndACloneAfter31 [
	"VERIFIED: /z is read before the callback, so the callback holds its entity; /b comes after, the callback holds a clone at its site"

	self assertRelationFaithful: self documentCallbacks31.
	self
		assertExpectedAt: '#/paths/~1a/get/callbacks/c1'
		selector: #pathItems
		in: self documentCallbacks31
		is: #( '#/paths/~1z' ).
	self
		assertExpectedAt: '#/paths/~1a/get/callbacks/c2'
		selector: #pathItems
		in: self documentCallbacks31
		is: #( '#/paths/~1a/get/callbacks/c2/{$y}' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testACallbackThatIsAReferenceIsSharedAndAnInlineOneHoldsItsPathItems31 [

	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #callbacks
		in: self documentStructure31
		is: #( '#/components/callbacks/CB' '#/paths/~1p/get/callbacks/cb2' ).
	self
		assertExpectedAt: '#/paths/~1p/get/callbacks/cb2'
		selector: #pathItems
		in: self documentStructure31
		is: #( '#/paths/~1p/get/callbacks/cb2/{$request.body#~1u}' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testALinkToAnOperationIdOfTwoOperationsDesignatesTheFirstOneOfTheDocument30 [
	"VERIFIED: the importer holds the first operation of the document (the one of /z, listed before the one of /a)"

	self assertRelationFaithful: self documentDuplicateOperationIds30.
	self
		assertExpectedAt: '#/paths/~1m/get/responses/200/links/l'
		selector: #operation
		in: self documentDuplicateOperationIds30
		is: #( '#/paths/~1z/get' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testAMediaTypeHoldsItsEncodingsAndTheEncodingItsHeaders30 [

	self
		assertExpectedAt: '#/paths/~1p/get/responses/201/content/a~1b'
		selector: #encodings
		in: self documentUnresolved30
		is: #( '#/paths/~1p/get/responses/201/content/a~1b/encoding/f' ).
	self
		assertExpectedAt:
		'#/paths/~1p/get/responses/201/content/a~1b/encoding/f'
		selector: #headers
		in: self documentUnresolved30
		is:
		#( '#/paths/~1p/get/responses/201/content/a~1b/encoding/f/headers/X' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testAPathItemReferenceIsACloneWithItsOwnOperations30 [

	self
		assertExpectedAt: '#'
		selector: #paths
		in: self documentStructure30
		is: #( '#/paths/~1p' '#/paths/~1q' ).
	self
		assertExpectedAt: '#/paths/~1q'
		selector: #operations
		in: self documentStructure30
		is: #( '#/paths/~1q/get' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testAReferenceToAValueThatIsNotAnObjectKeepsNoOPReferenceWhenADiagnosticSaysWhy [
	"VERIFIED: a response that is a $ref to a number gives the diagnostic wrongNodeType and no OPReference; the relation check accepts it as the existence check does, and only when the diagnostics are given"

	| json |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"responses":{"200":{"$ref":"#/components/responses/R"}}}}},"components":{"responses":{"R":7}}}'.
	self assert: (self relationReportFor: json) gaps isEmpty.
	self
		assert: (self relationGapsOf: json after: [ :model |  ])
		equals: #( 'relationMismatch # $ref' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testARequestBodyReferenceHoldsTheSharedRequestBody30 [

	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #requestBody
		in: self documentStructure30
		is: #( '#/components/requestBodies/B' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testAResponseReferenceIsACloneAtItsSiteAndHoldsTheClonedHeaders30 [
	"VERIFIED: a $ref response is an OPResponse at the site, whose children are read again below it"

	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #responses
		in: self documentStructure30
		is:
		#( '#/paths/~1p/get/responses/200' '#/paths/~1p/get/responses/404' ).
	self
		assertExpectedAt: '#/paths/~1p/get/responses/200'
		selector: #headers
		in: self documentStructure30
		is: #( '#/paths/~1p/get/responses/200/headers/h' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testASharedHeaderAndASharedExampleAreHeldOnceAtTheirComponent30 [
	"VERIFIED: h and h2 designate the same header, held once; the encoding holds it too"

	self
		assertExpectedAt: '#/paths/~1p/get/responses/200'
		selector: #headers
		in: self documentSharedKinds30
		is: #( '#/components/headers/H' ).
	self
		assertExpectedAt: '#/paths/~1p/get/responses/200/content/a~1b'
		selector: #examples
		in: self documentSharedKinds30
		is:
		#( '#/components/examples/E' '#/paths/~1p/get/responses/200/content/a~1b/examples/f' ).
	self
		assertExpectedAt:
		'#/paths/~1p/get/responses/200/content/a~1b/encoding/x'
		selector: #headers
		in: self documentSharedKinds30
		is: #( '#/components/headers/H' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testASharedParameterListedTwiceIsHeldOnceAndAnAliasGivesItsTarget30 [
	"VERIFIED: the relations are sets that keep the first occurrence; an alias of a parameter in the components has no entity, the target at the end of the chain is held"

	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #parameters
		in: self documentRefs30
		is: #( '#/components/parameters/P' '#/components/parameters/Q' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testAnOperationHoldsItsOwnParametersAndTheSharedOnesAtTheComponent30 [

	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #parameters
		in: self documentStructure30
		is: #( '#/components/parameters/P' '#/paths/~1p/get/parameters/1'
			   '#/paths/~1p/get/parameters/2' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testAnUnresolvedOrCyclicReferenceHoldsNoTarget30 [
	"VERIFIED: an OPReference at the site, nothing in the relation"

	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #parameters
		in: self documentUnresolved30
		is: #( '#/paths/~1p/get/parameters/1' ).
	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #responses
		in: self documentUnresolved30
		is: #( '#/paths/~1p/get/responses/201' ).
	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #requestBody
		in: self documentUnresolved30
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheComponentsHoldTheirSectionsInTheOrderOfTheSource30 [

	self
		assertExpectedAt: '#/components'
		selector: #schemas
		in: self documentStructure30
		is: #( '#/components/schemas/T' '#/components/schemas/S' ).
	self
		assertExpectedAt: '#/components'
		selector: #securitySchemes
		in: self documentStructure30
		is: #( '#/components/securitySchemes/k' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheLinksOfAResponseAreSharedOrInline31 [
	"VERIFIED: two names for the same shared link hold it once"

	self
		assertExpectedAt: '#/paths/~1p/get/responses/200'
		selector: #links
		in: self documentStructure31
		is:
		#( '#/components/links/L' '#/paths/~1p/get/responses/200/links/l3' ).
	self
		assertExpectedAt: '#/paths/~1p/get/responses/200/links/l3'
		selector: #server
		in: self documentStructure31
		is: #( '#/paths/~1p/get/responses/200/links/l3/server' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheOperationOfALinkIsTheOneItsOperationIdOrItsOperationRefDesignates31 [
	"VERIFIED: l1 by operationId, l2 by operationRef; an unknown id or an unresolved reference designates nothing"

	| json links |
	json := self documentSecurity31.
	links := '#/paths/~1p/get/responses/200/links/'.
	#( 'l1' 'l2' ) collect: [ :each | links , each ] thenDo: [ :each |
		self
			assertExpectedAt: each
			selector: #operation
			in: json
			is: #( '#/paths/~1p/get' ) ].
	#( 'l3' 'l4' ) collect: [ :each | links , each ] thenDo: [ :each |
		self
			assertExpectedAt: each
			selector: #operation
			in: json
			is: #(  ) ]
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheOperationsAreInTheOrderOfTheSource30 [
	"VERIFIED: put, get, delete, head as written, not the order of the methods"

	self
		assertExpectedAt: '#/paths/~1p'
		selector: #operations
		in: self documentUnresolved30
		is: #( '#/paths/~1p/put' '#/paths/~1p/get' '#/paths/~1p/delete'
			   '#/paths/~1p/head' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testThePathLevelParametersAreNotInheritedByTheOperations30 [

	self
		assertExpectedAt: '#/paths/~1p'
		selector: #parameters
		in: self documentRefs30
		is: #( '#/paths/~1p/parameters/0' '#/components/parameters/P' ).
	self deny: ((self
			  expectedAt: '#/paths/~1p/get'
			  selector: #parameters
			  in: self documentRefs30) includes: '#/paths/~1p/parameters/0')
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheRealImportOfEveryDocumentHasNoRelationGap [

	#( #documentStructure30 #documentRefs30 #documentUnresolved30
	   #documentStructure31 #documentSecurity31 #documentStructureSwagger2 )
		do: [ :each | self assertRelationFaithful: (self perform: each) ]
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheRootHoldsItsPartsAndTheDefaultServer30 [
	"VERIFIED: an OpenAPI 3 document without servers gets the default server at #/servers/0"

	#( #info #components #tags #servers ) do: [ :each |
		self deny:
			(self expectedAt: '#' selector: each in: self documentStructure30)
				isEmpty ].
	self
		assertExpectedAt: '#'
		selector: #servers
		in: self documentStructure30
		is: #( '#/servers/0' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheScalarExampleAndTheExamplesOfAParameterAreHeld31 [

	self
		assertExpectedAt: '#/paths/~1p/post/parameters/0'
		selector: #examples
		in: self documentSecurity31
		is: #( '#/paths/~1p/post/parameters/0/example'
			   '#/paths/~1p/post/parameters/0/examples/e' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheScalarExampleComesBeforeTheExamplesAndAnUnresolvedExampleIsNotHeld30 [
	"VERIFIED: the example of the media type, then its examples in the order of the source"

	self
		assertExpectedAt: '#/paths/~1p/get/responses/201/content/a~1b'
		selector: #examples
		in: self documentUnresolved30
		is: #( '#/paths/~1p/get/responses/201/content/a~1b/example'
			   '#/paths/~1p/get/responses/201/content/a~1b/examples/e2' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheServersOfTheSourceAreHeldEvenWhenTheyRepeat31 [

	self
		assertExpectedAt: '#'
		selector: #servers
		in: self documentStructure31
		is: #( '#/servers/0' '#/servers/1' ).
	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #servers
		in: self documentStructure31
		is: #( '#/paths/~1p/get/servers/0' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheSharedHeaderAndExampleOfOpenApi31AreHeldLikeThoseOf30 [

	self assertRelationFaithful: self documentSharedKinds31.
	self
		assertExpectedAt:
		'#/paths/~1p/get/responses/200/content/a~1b/encoding/x'
		selector: #headers
		in: self documentSharedKinds31
		is: #( '#/components/headers/H' ).
	self
		assertExpectedAt: '#/components/headers/H'
		selector: #schema
		in: self documentSharedKinds31
		is: #( '#/components/headers/H/schema' )
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheUnresolvedReferencesAreTheOnesOfTheSitesWithoutTarget30 [

	| comparison |
	comparison := self
		              comparisonAt: '#'
		              selector: #unresolvedReferences
		              in: self documentUnresolved30.
	self assert: comparison rule compareMode equals: #set.
	self assert: comparison expected size equals: 9.
	self assert: comparison found asSet equals: comparison expected asSet
]

{ #category : 'tests' }
FamixOpenApiRelationStructureTest >> testTheWebhooksAndThePathItemsOfTheComponentsAreHeld31 [
	"VERIFIED: a webhook that is a $ref to a path item of the components is a clone at the webhook"

	self
		assertExpectedAt: '#'
		selector: #webhooks
		in: self documentStructure31
		is: #( '#/webhooks/wh' '#/webhooks/wr' ).
	self
		assertExpectedAt: '#/components'
		selector: #pathItems
		in: self documentStructure31
		is: #( '#/components/pathItems/PI' ).
	self
		assertExpectedAt: '#/webhooks/wr'
		selector: #operations
		in: self documentStructure31
		is: #( '#/webhooks/wr/get' )
]
