"
Tests of the classification of the extensions check (V9) on small documents of OpenAPI 3.0, 3.1 and Swagger 2, imported by the REAL importer whose diagnostics are given to the check: what is kept in the extensions (#onlyInExtensions), what the importer says it ignores (#ignoredByDiagnostic), what is lost (#lost, real findings frozen here: the keys beside the $ref of a parameter, response... that nothing keeps and nothing reports), the values of a wrong type (#silentDrop, #ignoredByDiagnostic), and the keys that are not classified (inside another value).
"
Class {
	#name : 'FamixOpenApiExtensionsCheckTest',
	#superclass : 'FamixOpenApiExtensionsTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> aliasPairs [
	"The pointer and key of the siblings of the six aliases of #documentRefKinds:"

	^ #( #( '#/components/parameters/P2' 'description' )
	     #( '#/components/parameters/P2' 'x-foo' )
	     #( '#/components/requestBodies/B2'
	        'description' )
	     #( '#/components/requestBodies/B2'
	        'x-foo' ) #( '#/components/responses/R2'
	        'description' )
	     #( '#/components/responses/R2' 'x-foo' )
	     #( '#/components/headers/H2' 'description' )
	     #( '#/components/headers/H2' 'x-foo' )
	     #( '#/components/links/L2' 'summary' )
	     #( '#/components/links/L2' 'description' )
	     #( '#/components/links/L2' 'x-foo' )
	     #( '#/components/examples/E2' 'summary' )
	     #( '#/components/examples/E2' 'description' )
	     #( '#/components/examples/E2' 'x-foo' ) )
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> kindsOfSchema: aSchemaJson version: aVersion [
	"The report of the real import of a document of the version with the schema S: the kinds of the keys by key, an Array of associations"

	| report |
	report := self extensionsReportOf:
		          (self
			           documentSchemaKeys: (self headOf: aVersion)
			           schema: aSchemaJson).
	^ report gaps collect: [ :each | each fieldKey -> each kind ]
]

{ #category : 'data' }
FamixOpenApiExtensionsCheckTest >> pairsKept30 [
	"Pairs (pointer, key) of documentExtensions30 that the importer keeps in the extensions"

	^ #( #( '#' 'x-root' ) #( '#' 'zzz' ) #( '#/info' 'summary' )
	     #( '#/info' 'x-i' ) #( '#/info/contact' 'x-c' )
	     #( '#/info/license' 'x-l' ) #( '#/servers/0' 'x-srv' )
	     #( '#/tags/0' 'x-tag' ) #( '#/paths/~1p' 'x-pi' )
	     #( '#/paths/~1p/get' 'x-op' ) #( '#/paths/~1p/get/parameters/0'
	        'x-par' ) #( '#/paths/~1p/get/parameters/0/schema'
	        'x-sch' ) #( '#/paths/~1p/get/responses/200'
	        'x-r' ) #( '#/paths/~1p/get/responses/200/headers/h'
	        'example' ) #( '#/paths/~1p/get/responses/200/headers/h'
	        'allowEmptyValue' )
	     #( '#/paths/~1p/get/responses/200/headers/h'
	        'x-h' ) #( '#/paths/~1p/get/responses/200/links/l'
	        'parameters' ) #( '#/paths/~1p/get/responses/200/links/l'
	        'x-l' ) #( '#/components/examples/e'
	        'description' ) #( '#/components/examples/e'
	        'x-e' ) #( '#/components/schemas/S' '$id' )
	     #( '#/components/schemas/S' 'x-s' )
	     #( '#/components/schemas/S/properties/p'
	        'x-prop' ) )
]

{ #category : 'data' }
FamixOpenApiExtensionsCheckTest >> pairsKept31 [
	"Pairs (pointer, key) of documentExtensions31 that the importer keeps in the extensions"

	| schema |
	schema := '#/components/schemas/S'.
	^ #( #( '#/info' 'summary' ) #( '#/info/license' 'identifier' )
	     #( '#/components/examples/e' 'description' )
	     #( '#/components/headers/h' 'example' )
	     #( '#/components/headers/h' 'x-h' ) )
	  ,
		  (#( '$id' '$anchor' '$comment' '$defs' 'if' 'then' 'else' 'patternProperties'
		      'contains' 'propertyNames' 'unevaluatedProperties'
		      'unevaluatedItems' 'dependentSchemas' 'dependentRequired'
		      'minContains' 'maxContains' 'contentEncoding'
		      'contentMediaType' 'examples' 'x-s' ) collect: [ :each |
			   {
				   schema.
				   each } ])
]

{ #category : 'data' }
FamixOpenApiExtensionsCheckTest >> pairsKeptSwagger2 [
	"Pairs (pointer, key) of documentExtensionsSwagger2 that the importer keeps in the extensions"

	| header |
	header := '#/paths/~1p/get/responses/200/headers/h'.
	^ #( #( '#/paths/~1p/get' 'schemes' )
	     #( '#/paths/~1p/get/parameters/0' 'x-par' )
	     #( '#/paths/~1p/get/parameters/0/items'
	        'collectionFormat' ) #( '#/paths/~1p/get/parameters/0/items'
	        'x-it' ) #( '#/paths/~1p/get/responses/200'
	        'examples' ) #( '#/definitions/S' 'x-def' )
	     #( '#/securityDefinitions/k' 'x-sec' ) )
	  ,
		  (#( 'type' 'format' 'maximum' 'minimum' 'items' 'collectionFormat'
		      'default' 'enum' 'x-h' ) collect: [ :each |
			   {
				   header.
				   each } ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testADroppedFormDataParameterThatIsAReferenceIsExcused [
	"A formData parameter given by a $ref (components parameters) of an operation that has a body is dropped too: the key beside the $ref is excused by the diagnostic of the operation"

	| json report |
	json := '{"swagger":"2.0","info":{"title":"t","version":"1"},"parameters":{"FP":{"name":"fp","in":"formData","type":"string"}},"paths":{"/p":{"post":{"operationId":"a","parameters":[{"name":"b1","in":"body","schema":{"type":"string"}},{"$ref":"#/parameters/FP","x-sib":1}],"responses":{"200":{"description":"d"}}}}}}'.
	report := self extensionsReportOf: json.
	self
		assertKind: #ignoredByDiagnostic
		at: '#/paths/~1p/post/parameters/1'
		key: 'x-sib'
		in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testAMergedModelIsAPrecondition [
	"The preconditions of the value check: a model imported with the inline schemas merged, a document of unknown version"

	| json report |
	json := self documentOpenApi30.
	report := self
		          extensionsReportOf: json
		          model: (self modelOf: json merging: true)
		          diagnostics: #(  ).
	self assert: report gaps size equals: 1.
	self assert: report gaps first kind equals: #preconditionMerged.
	report := self
		          extensionsReportOf: '{"x":1}'
		          model: (self modelOf: '{"x":1}')
		          diagnostics: #(  ).
	self assert: report gaps size equals: 1.
	self assert: report gaps first kind equals: #preconditionVersion
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testAWrongTypeOfAKeyThatSwagger2DoesNotKnowIsIgnoredByDiagnostic [
	"Swagger 2: deprecated and writeOnly with a text are not in the table of the version, the importer says wrongNodeType at the key (VERIFIED by import): #ignoredByDiagnostic (the role valueRejected), not lost"

	| gaps |
	gaps := self
		        kindsOfSchema:
		        '{"type":"string","deprecated":"true","writeOnly":"y","readOnly":"x"}'
		        version: #v2.
	self assert: gaps size equals: 3.
	self assert:
		(gaps allSatisfy: [ :each | each value = #ignoredByDiagnostic ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testAliasesInTheComponentsAreIgnoredByDiagnostic30 [
	"OpenAPI 3.0: the importer says componentAlias and refSiblingsIgnored at an alias of the six kinds, the siblings are ignored by diagnostic (VERIFIED by import)"

	| report |
	report := self extensionsReportOf: (self documentRefKinds: '3.0.3').
	self
		assertKind: #ignoredByDiagnostic
		forPairs: self aliasPairs
		in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testAliasesInTheComponentsAreIgnoredByDiagnostic31 [
	"OpenAPI 3.1: the same diagnostics at the alias of the five kinds that are not schemas (before the fix the siblings were reported lost, a false failure)"

	| report |
	report := self extensionsReportOf: (self documentRefKinds: '3.1.0').
	self
		assertKind: #ignoredByDiagnostic
		forPairs: self aliasPairs
		in: report.
	self assert:
		((report gapsOfKind: #ignoredByDiagnostic) allSatisfy: [ :each |
			 each message includesSubstring: 'refSiblingsIgnored' ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testDroppedParametersOfSwagger2 [
	"The x-* of a second body parameter (extraBodyParameter, the pointer of the parameter) and of a formData parameter of an operation that also has a body (conflictingBodyAndFormData, the pointer of the operation) are ignored with a diagnostic; the one of a formData parameter without body is lost (REAL FINDING: nothing is said)"

	| report |
	report := self extensionsReportOf: self documentBodiesSwagger2.
	self
		assertKind: #ignoredByDiagnostic
		forPairs: #( #( '#/paths/~1p/post/parameters/1'
			      'x-b' ) #( '#/paths/~1p/post/parameters/2'
			      'x-f' ) )
		in: report.
	self
		assertKind: #lost
		forPairs: #( #( '#/paths/~1p/put/parameters/0'
		      'x-f' ) )
		in: report.
	self
		assert:
			(report extensions frequencyOf: 'Parameter' field: 'x-*' in: #v2)
				codes
		equals: #( #conflictingBodyAndFormData #extraBodyParameter )
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testExtensionsOfTheContainersPathsResponsesAndOAuthFlowsAreLost [
	"KNOWN IMPORTER FINDING (frozen): the Paths, Responses and OAuthFlows objects have no slot and no extensions in the metamodel: their x-* are #lost in 3.0, 3.1 and Swagger 2 (VERIFIED by import); those of a path item, a response and a flow stay kept"

	| template report |
	template := '{"openapi":"@V","info":{"title":"t","version":"1"},"paths":{"x-p":1,"/p":{"get":{"operationId":"g","responses":{"x-r":1,"200":{"description":"d"}}}}},"components":{"securitySchemes":{"o":{"type":"oauth2","flows":{"x-o":1,"implicit":{"authorizationUrl":"http://a","scopes":{},"x-i":1}}}}}}'.
	#( '3.0.3' '3.1.0' ) do: [ :version |
		report := self extensionsReportOf:
			          (template copyReplaceAll: '@V' with: version).
		self
			assertKind: #lost
			forPairs: #( #( '#/paths' 'x-p' ) #( '#/paths/~1p/get/responses'
				      'x-r' ) #( '#/components/securitySchemes/o/flows'
				      'x-o' ) )
			in: report.
		self
			assertKind: #onlyInExtensions
			at: '#/components/securitySchemes/o/flows/implicit'
			key: 'x-i'
			in: report ].
	report := self extensionsReportOf:
		          '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"x-p":1,"/p":{"get":{"operationId":"g","responses":{"x-r":1,"200":{"description":"d"}}}}}}'.
	self
		assertKind: #lost
		forPairs: #( #( '#/paths' 'x-p' ) #( '#/paths/~1p/get/responses'
			      'x-r' ) )
		in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysBesideARefInOpenApi31AreKeptOrLost [
	"The siblings of a schema alias and of a path item are kept (extensions of the entity of the site, or applied: no gap for summary); REAL FINDING (importer): those of a parameter, request body, response, header and link are lost without a diagnostic (knownImporterGaps), also the x-* and the summary of a link"

	| report |
	report := self extensionsReportOf: self documentSiblings31.
	self
		assertKind: #onlyInExtensions
		forPairs: #( #( '#/paths/~1q' 'x-q' ) #( '#/components/schemas/S'
			      'x-t' ) )
		in: report.
	self
		assertKind: #lost
		forPairs: #( #( '#/paths/~1p/get/parameters/0'
			      'description' )
			   #( '#/paths/~1p/get/parameters/0' 'x-s' )
			   #( '#/paths/~1p/get/requestBody' 'description' )
			   #( '#/paths/~1p/get/responses/200'
			      'description' )
			   #( '#/paths/~1p/get/responses/200'
			      'x-r' ) #( '#/paths/~1p/get/responses/201/headers/h'
			      'description' ) #( '#/paths/~1p/get/responses/201/links/l'
			      'summary' ) )
		in: report.
	self assertNoGapAt: '#/paths/~1q' key: 'summary' in: report.
	self assertNoGapAt: '#/components/schemas/S' key: 'title' in: report.
	self
		assertNoGapAt: '#/components/schemas/S'
		key: 'description'
		in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysBesideARefInSwagger2 [
	"A schema (response, definition): ignored with a diagnostic; a parameter and a response: lost without one (REAL FINDING)"

	| report |
	report := self extensionsReportOf: self documentSiblingsSwagger2.
	self
		assertKind: #ignoredByDiagnostic
		forPairs: #( #( '#/paths/~1p/get/responses/200/schema'
			      'description' ) #( '#/paths/~1p/get/responses/200/schema'
			      'x-k' ) #( '#/definitions/A' 'title' ) )
		in: report.
	self
		assertKind: #lost
		forPairs: #( #( '#/paths/~1p/get/parameters/0'
			      'description' )
			   #( '#/paths/~1p/get/parameters/0' 'x-s' )
			   #( '#/paths/~1p/get/responses/404'
			      'description' ) )
		in: report.
	self assertNoGapAt: '#/definitions/A' key: 'description' in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysBesideARefThatNothingKeepsAndNothingReportsAreLost30 [
	"REAL FINDING (importer): a parameter, a request body, a response, a header, a link or a path item that does not resolve, with keys beside its $ref: the spec ignores them, the importer ignores them WITHOUT a diagnostic (the x-* too)"

	| report |
	report := self extensionsReportOf: self documentSiblings30.
	self
		assertKind: #lost
		forPairs: #( #( '#/paths/~1p/get/parameters/0'
			      'description' )
			   #( '#/paths/~1p/get/parameters/0' 'x-s' )
			   #( '#/paths/~1p/get/requestBody' 'description' )
			   #( '#/paths/~1p/get/responses/200'
			      'description' )
			   #( '#/paths/~1p/get/responses/200'
			      'x-r' ) #( '#/paths/~1p/get/responses/201/headers/h'
			      'description' ) #( '#/paths/~1p/get/responses/201/links/l'
			      'description' ) #( '#/paths/~1r' 'summary' ) )
		in: report.
	self
		assert: report failingGaps size
		equals: (report gapsOfKind: #lost) size
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysBesideARefThatTheImporterIgnoresAndSaysSo30 [
	"A schema and a path item that resolves: refSiblingsIgnored, whose pointer is the one of the node; the description of an alias is read (no gap)"

	| report |
	report := self extensionsReportOf: self documentSiblings30.
	self
		assertKind: #ignoredByDiagnostic
		forPairs: #( #( '#/paths/~1q' 'summary' )
			   #( '#/paths/~1q' 'x-q' ) #( '#/components/schemas/S'
			      'title' ) #( '#/components/schemas/S'
			      'x-t' ) #( '#/components/schemas/O/properties/p'
			      'description' ) #( '#/components/schemas/O/properties/p'
			      'x-p' ) )
		in: report.
	self
		assertNoGapAt: '#/components/schemas/S'
		key: 'description'
		in: report.
	self
		assert: (report extensions
				 frequencyOf: 'Schema'
				 field: 'title (beside $ref)'
				 in: #v30) codes
		equals: #( #refSiblingsIgnored )
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysThatTheMetamodelDoesNotModelAreKeptInTheExtensions30 [
	"Header.example, Header.allowEmptyValue, Link.parameters, Example.description, x-* at every level, unknown keys (zzz, Info.summary, Schema.$id): kept, with the value of the source"

	| report |
	report := self extensionsReportOf: self documentExtensions30.
	self assert: report failingGaps isEmpty.
	self
		assertKind: #onlyInExtensions
		forPairs: self pairsKept30
		in: report.
	self assert: report gaps size equals: self pairsKept30 size
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysThatTheMetamodelDoesNotModelAreKeptInTheExtensions31 [
	"Info.summary, License.identifier, Example.description, Header.example and the keywords of a schema that the metamodel does not model"

	| report |
	report := self extensionsReportOf: self documentExtensions31.
	self assert: report failingGaps isEmpty.
	self
		assertKind: #onlyInExtensions
		forPairs: self pairsKept31
		in: report.
	self assert: report gaps size equals: self pairsKept31 size
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testKeysThatTheMetamodelDoesNotModelAreKeptInTheExtensionsSwagger2 [
	"Operation.schemes, Items.collectionFormat (carried by the schema of the parameter), Response.examples, the keywords of a header, x-* on definitions and security schemes"

	| report |
	report := self extensionsReportOf: self documentExtensionsSwagger2.
	self assert: report failingGaps isEmpty.
	self
		assertKind: #onlyInExtensions
		forPairs: self pairsKeptSwagger2
		in: report.
	self assert: report gaps size equals: self pairsKeptSwagger2 size
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testNothingInsideTheValueOfAKeyThatIsNotModelledIsClassified [
	"The schemas below $defs, if, patternProperties... (3.1), the examples and the items of a header (Swagger 2) belong to the value of their key: their own keys are not classified"

	| report |
	report := self extensionsReportOf: self documentExtensions31.
	self assert: (report gaps noneSatisfy: [ :each |
			 each sourcePointer beginsWith: '#/components/schemas/S/' ]).
	report := self extensionsReportOf: self documentExtensionsSwagger2.
	self assert: (report gaps noneSatisfy: [ :each |
			 each sourcePointer beginsWith:
				 '#/paths/~1p/get/responses/200/headers/h/' ]).
	self assert: (report gaps noneSatisfy: [ :each |
			 each sourcePointer beginsWith:
				 '#/paths/~1p/get/responses/200/examples' ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testNullableIsLostInOpenApi31AndSwagger2ButNotIn30 [
	"KNOWN IMPORTER FINDING (frozen): nullable true is neither a slot (isNullable false) nor an extension in 3.1 and Swagger 2: #lost; in 3.0 it is a slot, compared by V8, no gap here (VERIFIED by import)"

	self
		assert:
		(self
			 kindsOfSchema: '{"type":"string","nullable":true}'
			 version: #v31)
		equals: { ('nullable' -> #lost) }.
	self
		assert:
		(self
			 kindsOfSchema: '{"type":"string","nullable":true}'
			 version: #v2)
		equals: { ('nullable' -> #lost) }.
	self
		assert:
		(self
			 kindsOfSchema: '{"type":"string","nullable":true}'
			 version: #v30)
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testOnlyTheParametersThatTheImporterDropsAreExcusedInSwagger2 [
	"The formData parameter of an operation with a body is dropped (conflictingBodyAndFormData at the operation), the second body parameter too (extraBodyParameter at it); the kept query and header parameters are kept in the extensions; the path-level body and formData parameters and the formData parameter of an operation without body are lost, nothing is said (VERIFIED by import)"

	| report |
	report := self extensionsReportOf: self documentParametersSwagger2.
	self
		assertKind: #ignoredByDiagnostic
		forPairs: #( #( '#/paths/~1p/post/parameters/2'
			      'x-f' ) #( '#/paths/~1p/post/parameters/1'
			      'x-b2' ) )
		in: report.
	self
		assertKind: #onlyInExtensions
		forPairs: #( #( '#/paths/~1p/post/parameters/3'
			      'x-q' ) #( '#/paths/~1p/post/parameters/4'
			      'x-h' ) #( '#/paths/~1p/post/parameters/0'
			      'x-b1' ) )
		in: report.
	self
		assertKind: #lost
		forPairs: #( #( '#/paths/~1p/parameters/0'
			      'x-pb' ) #( '#/paths/~1p/parameters/1'
			      'x-pf' ) #( '#/paths/~1p/get/parameters/0'
			      'x-f' ) )
		in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testSiblingsAtTheUseSitesAreLost30 [
	"OpenAPI 3.0: a parameter, request body, response, header or link with a $ref and siblings in an operation: nothing is said and nothing is kept (VERIFIED by import): lost, a real importer finding"

	| json imported |
	json := self documentRefKinds: '3.0.3'.
	imported := self importedOf: json.
	self assert: (imported last all noneSatisfy: [ :each |
			 each pointer beginsWith: '#/paths/' ]).
	self assertKind: #lost forPairs: self usePairs in: (self
			 extensionsReportOf: json
			 model: imported first
			 diagnostics: imported last)
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testSiblingsAtTheUseSitesAreLost31 [
	"OpenAPI 3.1: the same: the use sites stay lost (no diagnostic: a real importer finding), only the aliases of the components are excused"

	| report |
	report := self extensionsReportOf: (self documentRefKinds: '3.1.0').
	self assertKind: #lost forPairs: self usePairs in: report.
	self
		assert: (report gapsOfKind: #lost) size
		equals: self usePairs size
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testSwagger2FormDataExtensionsOfAnOperationWithoutBodyAreLost [
	"KNOWN IMPORTER FINDING (frozen): the formData parameters of an operation without a body make the form of the request body, their x-* are nowhere and nothing is said (VERIFIED by import)"

	| report |
	report := self extensionsReportOf: self documentParametersSwagger2.
	self
		assertKind: #lost
		at: '#/paths/~1p/get/parameters/0'
		key: 'x-f'
		in: report.
	self assert:
		(report failingGaps anySatisfy: [ :each | each fieldKey = 'x-f' ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testTheConformanceRowsAreComputedAgainAfterAReset [

	| before |
	before := FamixOpenApiExtensionsCheck conformanceRows size.
	FamixOpenApiExtensionsCheck resetConformance.
	self
		assert: FamixOpenApiExtensionsCheck conformanceRows size
		equals: before.
	self assert: before > 100
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testTheDeprecatedAndWriteOnlyOfASchemaOfSwagger2AreKeptAnyway [
	"Swagger 2 has no deprecated nor writeOnly in a schema, but the importer stores them in the slots (VERIFIED by import): #valueKeptAnyway, informational (same as V8 for a slot that holds a value of the source)"

	| gaps |
	gaps := self
		        kindsOfSchema:
		        '{"type":"string","deprecated":true,"writeOnly":true}'
		        version: #v2.
	self assert: gaps asSet equals: {
			('deprecated' -> #valueKeptAnyway).
			('writeOnly' -> #valueKeptAnyway) } asSet
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testValuesOfAWrongType [
	"With a diagnostic (wrongNodeType at the key): ignoredByDiagnostic. Without one: silentDrop (REAL FINDING: maximum, minimum and nullable of a schema, a null title). A number of the right type is compared by V8 (minLength 3.5: no gap)"

	| report |
	report := self extensionsReportOf: self documentWrongTypes30.
	self
		assertKind: #ignoredByDiagnostic
		forPairs:
			#( #( '#/info' 'title' ) #( '#/paths/~1p/get' 'deprecated' )
			   #( '#/components/schemas/S' 'format' ) )
		in: report.
	self
		assertKind: #silentDrop
		forPairs: #( #( '#/components/schemas/S' 'maximum' )
			   #( '#/components/schemas/S' 'minimum' )
			   #( '#/components/schemas/S' 'nullable' )
			   #( '#/components/schemas/S' 'title' ) )
		in: report.
	self
		assertNoGapAt: '#/components/schemas/S'
		key: 'minLength'
		in: report.
	self
		assertNoGapAt: '#/components/schemas/S'
		key: 'exclusiveMaximum'
		in: report
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> testWithoutDiagnosticsTheKeysThatAreNotKeptAreNotDecidable [
	"nil diagnostics: whether a diagnostic covers a key cannot be told: #notDecidable, never #ignoredByDiagnostic, #lost or #silentDrop; what is kept in the extensions is still #onlyInExtensions"

	| imported report kinds |
	imported := self importedOf: self documentSiblings30.
	report := self
		          extensionsReportOf: self documentSiblings30
		          model: imported first
		          diagnostics: nil.
	kinds := report gaps collect: #kind as: Set.
	self assert: kinds equals: #( #notDecidable ) asSet.
	report := self
		          extensionsReportOf: self documentExtensions30
		          model: (self importedOf: self documentExtensions30) first
		          diagnostics: nil.
	self
		assert: (report gapsOfKind: #onlyInExtensions) size
		equals: self pairsKept30 size.
	report := self
		          extensionsReportOf: self documentWrongTypes30
		          model: (self importedOf: self documentWrongTypes30) first
		          diagnostics: nil.
	self assert: (report gapsOfKind: #notDecidable) size equals: 7.
	self assert: report failingGaps isEmpty
]

{ #category : 'tests' }
FamixOpenApiExtensionsCheckTest >> usePairs [
	"The pointer and key of the siblings of the use sites of #documentRefKinds: (parameter, request body, response, header, link)"

	^ #( #( '#/paths/~1p/get/parameters/0' 'description' )
	     #( '#/paths/~1p/get/parameters/0' 'x-s' )
	     #( '#/paths/~1p/get/requestBody' 'description' )
	     #( '#/paths/~1p/get/requestBody' 'x-b' )
	     #( '#/paths/~1p/get/responses/200'
	        'description' )
	     #( '#/paths/~1p/get/responses/200'
	        'x-r' ) #( '#/paths/~1p/get/responses/201/headers/h'
	        'description' ) #( '#/paths/~1p/get/responses/201/headers/h'
	        'x-h' ) #( '#/paths/~1p/get/responses/201/links/l'
	        'summary' ) #( '#/paths/~1p/get/responses/201/links/l'
	        'x-l' ) )
]
