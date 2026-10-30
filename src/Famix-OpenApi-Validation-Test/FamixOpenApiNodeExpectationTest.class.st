"
Tests of FamixOpenApiNodeExpectation: one test per context rule (the $ref cases, properties, boolean schemas, the 3.1 siblings, the Swagger 2 parameters, the schemas the importer does not read), each on a small document of the right version. The rules were established by experiments on the importer; the check tests and the table test verify them against the real import.
"
Class {
	#name : 'FamixOpenApiNodeExpectationTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiNodeExpectationTest >> assertAt: aPointer in: aJsonString expects: aCollection [
	"The class names (one per family, in any order) the expectation gives for the node at aPointer"

	| inventory node |
	inventory := self inventoryOf: aJsonString.
	node := inventory nodeAt: aPointer.
	self
		assert:
			((FamixOpenApiNodeExpectation on: inventory)
				 expectedClassNamesFor: node) asArray sorted
		equals: aCollection asArray sorted
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testBodyAndFormDataParametersOfAPathItemGiveNothing [

	| doc |
	doc := self documentSwagger2Parameters.
	self assertAt: '#/paths/~1b/parameters/0' in: doc expects: #(  ).
	self
		assertAt: '#/paths/~1b/parameters/0/schema'
		in: doc
		expects: #(  ).
	self assertAt: '#/paths/~1b/parameters/1' in: doc expects: #(  ).
	self
		assertAt: '#/paths/~1b/parameters/2'
		in: doc
		expects: #( 'OPParameter' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testBodyParameterOfAnOperationGivesARequestBodyAndFormDataNothing [

	| doc |
	doc := self documentSwagger2.
	self
		assertAt: '#/paths/~1b/get/parameters/1'
		in: doc
		expects: #( 'OPRequestBody' ).
	self assertAt: '#/paths/~1b/get/parameters/2' in: doc expects: #(  ).
	self assertAt: '#/paths/~1b/get/parameters/3' in: doc expects: #(  ).
	self
		assertAt: '#/paths/~1b/get/parameters/0'
		in: doc
		expects: #( 'OPParameter' ).
	self
		assertAt: '#/paths/~1b/get/parameters/1/schema'
		in: doc
		expects: #(  )
]

{ #category : 'tests - schemas' }
FamixOpenApiNodeExpectationTest >> testBooleanSchemaGivesAnEntityOnlyAsAComponentOrAProperty [

	| doc |
	doc := self documentOpenApi30.
	self
		assertAt: '#/components/schemas/A/properties/s'
		in: doc
		expects: #( 'OPProperty' ).
	self
		assertAt: '#/components/schemas/Bool'
		in: doc
		expects: #( 'OPSchema' ).
	#( 'not' 'items' 'additionalProperties' ) do: [ :field |
		self
			assertAt:
				('#/paths/~1z/get/responses/200/content/a~1b/schema/{1}' format:
					 { field })
			in: self documentOpenApi30Scalars
			expects: #(  ) ].
	self
		assertAt: '#/paths/~1z/get/responses/200/headers/h/schema'
		in: self documentOpenApi30Scalars
		expects: #(  )
]

{ #category : 'tests - 3.0 references' }
FamixOpenApiNodeExpectationTest >> testComponentEntryThatIsOnlyARefHasNoEntityExceptASchema [

	| doc |
	doc := self documentOpenApi30Unresolved.
	#( '#/components/responses/RA' '#/components/responses/RU'
	   '#/components/parameters/PA' '#/components/parameters/PU'
	   '#/components/headers/HU' '#/components/examples/EU'
	   '#/components/requestBodies/RA' '#/components/requestBodies/RU'
	   '#/components/links/LU' '#/components/callbacks/CU'
	   '#/components/securitySchemes/SU' ) do: [ :pointer |
		self assertAt: pointer in: doc expects: #(  ) ].
	self
		assertAt: '#/components/schemas/Alias'
		in: self documentOpenApi30
		expects: #( 'OPSchema' )
]

{ #category : 'tests - schemas' }
FamixOpenApiNodeExpectationTest >> testContainersHaveNoEntity [

	| doc |
	doc := self documentOpenApi30.
	#( '#/paths' '#/paths/~1b/get/responses' '#/components/securitySchemes/oa/flows' )
		do: [ :pointer | self assertAt: pointer in: doc expects: #(  ) ].
	self
		assertAt: '#/components/securitySchemes/oa/flows/implicit'
		in: doc
		expects: #( 'OPOAuthFlow' )
]

{ #category : 'tests - api' }
FamixOpenApiNodeExpectationTest >> testExternalReferenceIsNotResolved [

	| inventory expectation |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.3","components":{"schemas":{"E":{"$ref":"other.json#/x"}}}}'.
	expectation := FamixOpenApiNodeExpectation on: inventory.
	self deny:
		(expectation isResolved:
			 (inventory nodeAt: '#/components/schemas/E'))
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testItemsExamplesAndScopesHaveNoEntityInSwagger2 [

	| doc |
	doc := self documentSwagger2.
	self
		assertAt: '#/paths/~1b/get/parameters/0/items'
		in: doc
		expects: #(  ).
	self
		assertAt: '#/paths/~1b/get/parameters/0/items/items'
		in: doc
		expects: #(  ).
	self
		assertAt: '#/paths/~1b/get/responses/200/headers/h/items'
		in: doc
		expects: #(  ).
	self
		assertAt: '#/paths/~1b/get/responses/200/examples'
		in: doc
		expects: #(  ).
	self
		assertAt: '#/securityDefinitions/oa/scopes'
		in: doc
		expects: #(  )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testOAuth2SchemeOfSwagger2HoldsItsFlow [

	| doc |
	doc := self documentSwagger2.
	self
		assertAt: '#/securityDefinitions/oa'
		in: doc
		expects: #( 'OPSecurityScheme' 'OPOAuthFlow' ).
	self
		assertAt: '#/securityDefinitions/k'
		in: doc
		expects: #( 'OPSecurityScheme' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testOnlyTheFirstBodyParameterOfAnOperationGivesARequestBody [

	| doc |
	doc := self documentSwagger2Parameters.
	self
		assertAt: '#/paths/~1b/post/parameters/0'
		in: doc
		expects: #( 'OPRequestBody' ).
	self
		assertAt: '#/paths/~1b/post/parameters/0/schema'
		in: doc
		expects: #( 'OPSchema' ).
	self assertAt: '#/paths/~1b/post/parameters/1' in: doc expects: #(  ).
	self
		assertAt: '#/paths/~1b/post/parameters/1/schema'
		in: doc
		expects: #(  )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testParametersOfTheRootStayParametersWhateverTheirLocation [

	| doc |
	doc := self documentSwagger2Parameters.
	self assertAt: '#/parameters/PB' in: doc expects: #( 'OPParameter' ).
	self assertAt: '#/parameters/PF' in: doc expects: #( 'OPParameter' ).
	self
		assertAt: '#/parameters/PB/schema'
		in: doc
		expects: #( 'OPSchema' ).
	self
		assertAt: '#/parameters/PA'
		in: self documentSwagger2
		expects: #(  )
]

{ #category : 'tests - schemas' }
FamixOpenApiNodeExpectationTest >> testPropertyGivesAnOPPropertyAndItsSchemaAnOPSchema [

	| doc |
	doc := self documentOpenApi30.
	self
		assertAt: '#/components/schemas/A/properties/r'
		in: doc
		expects: #( 'OPProperty' 'OPSchema' ).
	self
		assertAt: '#/components/schemas/A/properties/p'
		in: doc
		expects: #( 'OPProperty' ).
	self
		assertAt: '#/components/schemas/A/properties/q'
		in: doc
		expects: #( 'OPProperty' 'OPReference' )
]

{ #category : 'tests - 3.1' }
FamixOpenApiNodeExpectationTest >> testPropertyWithSiblingsHasASchemaOnlyInOpenApi31 [

	self
		assertAt: '#/components/schemas/T/properties/pp'
		in: (self documentWithSiblingsIn: '3.0.3')
		expects: #( 'OPProperty' ).
	self
		assertAt: '#/components/schemas/T/properties/pp'
		in: (self documentWithSiblingsIn: '3.1.0')
		expects: #( 'OPProperty' 'OPSchema' )
]

{ #category : 'tests - schemas' }
FamixOpenApiNodeExpectationTest >> testRefSchemaInsideASchemaHasNoEntity [

	| doc |
	doc := self documentOpenApi30.
	#( '#/components/schemas/A/additionalProperties'
	   '#/components/schemas/A/properties/r/items'
	   '#/components/schemas/A/properties/t/allOf/0'
	   '#/components/schemas/One/not' '#/components/schemas/One/oneOf/1' )
		do: [ :pointer | self assertAt: pointer in: doc expects: #(  ) ]
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testRefToABodyParameterGivesARequestBodyAtTheSite [

	| doc |
	doc := self documentSwagger2Parameters.
	self
		assertAt: '#/paths/~1b/put/parameters/2'
		in: doc
		expects: #( 'OPRequestBody' ).
	self
		assertAt: '#/paths/~1b/delete/parameters/0'
		in: doc
		expects: #( 'OPRequestBody' ).
	self assertAt: '#/paths/~1b/put/parameters/1' in: doc expects: #(  ).
	self assertAt: '#/paths/~1b/put/parameters/0' in: doc expects: #(  )
]

{ #category : 'tests - api' }
FamixOpenApiNodeExpectationTest >> testReferenceResolutionDecodesPercentEncodedPointers [

	| inventory expectation node |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.3","components":{"schemas":{"A B":{"type":"string"},"R":{"$ref":"#/components/schemas/A%20B"},"X":{"$ref":"#/components/schemas/Nope"}}}}'.
	expectation := FamixOpenApiNodeExpectation on: inventory.
	node := inventory nodeAt: '#/components/schemas/R'.
	self assert: (expectation isResolved: node).
	self
		assert: (expectation targetOf: node) pointer
		equals: '#/components/schemas/A B'.
	self deny:
		(expectation isResolved:
			 (inventory nodeAt: '#/components/schemas/X'))
]

{ #category : 'tests - 3.0 references' }
FamixOpenApiNodeExpectationTest >> testReferencedPathItemIsClonedAndAnUnresolvedOneIsAlsoAReference [

	| doc |
	doc := self documentOpenApi30.
	self
		assertAt: '#/paths/~1a'
		in: doc
		expects: #( 'OPPath' 'OPReference' ).
	self
		assertAt: '#/paths/~1ext'
		in: doc
		expects: #( 'OPPath' 'OPReference' ).
	self
		assertAt: '#/webhooks/w2'
		in: self documentOpenApi31
		expects: #( 'OPPath' ).
	self
		assertAt: '#/components/pathItems/PI2'
		in: self documentOpenApi31
		expects: #(  )
]

{ #category : 'tests - 3.0 references' }
FamixOpenApiNodeExpectationTest >> testReferencedResponseIsCloned [

	self
		assertAt: '#/paths/~1b/get/responses/200'
		in: self documentOpenApi30
		expects: #( 'OPResponse' )
]

{ #category : 'tests - 3.1' }
FamixOpenApiNodeExpectationTest >> testSchemasOfKeywordsTheImporterDoesNotReadHaveNoEntityNorTheirChildren [

	| doc |
	doc := self documentOpenApi31.
	#( 'patternProperties/^x' 'if' 'then' 'else' 'contains' 'propertyNames'
	   'unevaluatedProperties' 'dependentSchemas/a' '$defs/D' '$defs/D/properties/dd' )
		do: [ :tail |
			self
				assertAt: ('#/components/schemas/S/{1}' format: { tail })
				in: doc
				expects: #(  ) ].
	self
		assertAt: '#/components/schemas/S/anyOf/0'
		in: doc
		expects: #( 'OPSchema' ).
	self
		assertAt: '#/components/schemas/S/items'
		in: doc
		expects: #( 'OPSchema' )
]

{ #category : 'tests - 3.0 references' }
FamixOpenApiNodeExpectationTest >> testSharedObjectsReferencedHaveNoEntityAtTheirUseSite [

	| doc |
	doc := self documentOpenApi30.
	#( '#/paths/~1b/parameters/0' '#/paths/~1b/get/requestBody'
	   '#/paths/~1b/get/callbacks/cb' '#/paths/~1b/get/responses/202/headers/h1'
	   '#/paths/~1b/get/responses/202/links/l1'
	   '#/paths/~1b/get/parameters/0/examples/e2' ) do: [ :pointer |
		self assertAt: pointer in: doc expects: #(  ) ]
]

{ #category : 'tests - 3.1' }
FamixOpenApiNodeExpectationTest >> testSiblingsOfARefMakeASchemaOnlyInOpenApi31 [

	| path |
	path := '#/paths/~1c/post/responses/200/content/a~1b/schema'.
	self
		assertAt: path
		in: (self documentWithSiblingsIn: '3.0.3')
		expects: #(  ).
	self
		assertAt: path
		in: (self documentWithSiblingsIn: '3.1.0')
		expects: #( 'OPSchema' )
]

{ #category : 'tests - 3.1' }
FamixOpenApiNodeExpectationTest >> testSiblingsOfAnUnresolvedRefKeepTheOPReference [

	| path |
	path := '#/paths/~1c/post/responses/200/content/c~1d/schema/allOf/1'.
	self
		assertAt: path
		in: (self documentWithSiblingsIn: '3.0.3')
		expects: #( 'OPReference' ).
	self
		assertAt: path
		in: (self documentWithSiblingsIn: '3.1.0')
		expects: #( 'OPSchema' 'OPReference' )
]

{ #category : 'tests - 3.1' }
FamixOpenApiNodeExpectationTest >> testSiblingsOfOtherObjectsAreIgnored [

	| doc |
	doc := self documentWithSiblingsIn: '3.1.0'.
	#( '#/paths/~1c/post/parameters/0' '#/paths/~1c/post/requestBody'
	   '#/paths/~1c/post/responses/200/headers/h' ) do: [ :pointer |
		self assertAt: pointer in: doc expects: #(  ) ].
	self
		assertAt: '#/paths/~1c/post/responses/201'
		in: doc
		expects: #( 'OPResponse' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiNodeExpectationTest >> testSwagger2ResponsesAndReferences [

	| doc |
	doc := self documentSwagger2.
	self
		assertAt: '#/paths/~1b/get/responses/201'
		in: doc
		expects: #( 'OPResponse' ).
	self
		assertAt: '#/paths/~1b/get/responses/202'
		in: doc
		expects: #( 'OPReference' ).
	self assertAt: '#/responses/RA' in: doc expects: #(  ).
	self assertAt: '#/paths/~1b/parameters/0' in: doc expects: #(  ).
	self
		assertAt: '#/paths/~1b/parameters/1'
		in: doc
		expects: #( 'OPReference' ).
	self assertAt: '#/definitions/Al' in: doc expects: #( 'OPSchema' ).
	self
		assertAt: '#/definitions/Du'
		in: doc
		expects: #( 'OPSchema' 'OPReference' ).
	self
		assertAt: '#/definitions/A/properties/u'
		in: doc
		expects: #( 'OPProperty' 'OPReference' ).
	self
		assertAt: '#/paths/~1a'
		in: doc
		expects: #( 'OPPath' 'OPReference' )
]

{ #category : 'tests - 3.0 references' }
FamixOpenApiNodeExpectationTest >> testUnresolvedRefGivesAnOPReference [

	| doc |
	doc := self documentOpenApi30.
	self
		assertAt: '#/paths/~1b/parameters/1'
		in: doc
		expects: #( 'OPReference' ).
	self
		assertAt: '#/paths/~1b/get/responses/201'
		in: doc
		expects: #( 'OPReference' ).
	self
		assertAt: '#/components/schemas/Dang'
		in: doc
		expects: #( 'OPSchema' 'OPReference' ).
	self
		assertAt: '#/components/schemas/Ext'
		in: doc
		expects: #( 'OPSchema' 'OPReference' )
]

{ #category : 'tests - 3.0 references' }
FamixOpenApiNodeExpectationTest >> testUnresolvedRefInsideASchemaGivesOnlyAnOPReference [

	| doc |
	doc := self documentOpenApi30Unresolved.
	#( '#/components/schemas/S/not' '#/paths/~1z/get/responses/200/content/a~1b/schema/additionalProperties'
	   '#/paths/~1z/get/responses/200/content/a~1b/schema/properties/x/items'
	   '#/paths/~1z/get/responses/200/content/a~1b/schema/properties/x/allOf/0' )
		do: [ :pointer |
			self assertAt: pointer in: doc expects: #( 'OPReference' ) ]
]

{ #category : 'tests - api' }
FamixOpenApiNodeExpectationTest >> testWrongShapeNodeHasNoEntity [

	| doc |
	doc := '{"openapi":"3.0.3","info":"text","paths":{}}'.
	self assertAt: '#/info' in: doc expects: #(  )
]
