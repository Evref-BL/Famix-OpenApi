"
Tests of the exact derivation of the entities without node (FamixOpenApiSyntheticExpectations, V7b): per synthetic kind, a small document of the right version gives exactly the expected pointers (frozen as literals) AND the real import of the same document has no gap (so the literals are what the importer builds); then the clones (re-rooting), the rule names, the known limits and the invariants over all the fixtures.
"
Class {
	#name : 'FamixOpenApiSyntheticExpectationsTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testABodyReferenceGivesMediaTypesOnlyWhenItsTargetHasAnObjectSchema [
	"A $ref to a body parameter without schema, with a schema that is a string: none; with a schema that is a $ref: the media types (*/* without consumes) of the one request body"

	| doc |
	doc := self documentSwagger2BodyReferences.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/post/parameters/0/content/*~1*' ).
	self assert: (self derivedPointersOf: OPSchema in: doc) isEmpty
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testAParameterThatHasASchemaNodeGetsNoSchemaFromItsType [
	"The node of the document is at <parameter>/schema: the derivation adds nothing there (it would be a second entity)"

	| doc |
	doc := self documentSwagger2ParameterWithSchema.
	self assertFaithful: doc.
	self assert: (self derivedPointersOf: OPSchema in: doc) isEmpty
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testAPathItemIsNotClonedInsideTheCloneOfTheSameReference [
	"/a clones /c (a callback), whose own callback designates /c: the importer reports a refCycle there and keeps an OPPath without content"

	| doc |
	doc := self documentActiveReferenceCycle.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPPath in: doc)
		equals:
		#( '#/paths/~1a/get/callbacks/cb/{$x}/get/callbacks/cb/{$y}' ).
	self
		assert: (self derivedPointersOf: OPOperation in: doc)
		equals: #( '#/paths/~1a/get/callbacks/cb/{$x}/get' )
]

{ #category : 'tests - importer findings' }
FamixOpenApiSyntheticExpectationsTest >> testAProducesEntryThatIsNotAStringGivesTheImporterAnEntityWithoutPointer [
	"REAL IMPORTER FINDING (the importer is not changed by V7b): a number in the produces list gives an OPMediaType with no canonical pointer (name 5, no media type), next to the right one; the derivation (the strings only) cannot expect it, so the check reports it as an extra entity. Frozen here, like the findings of the corpus"

	| doc |
	doc := '{"swagger":"2.0","info":{"title":"t","version":"1"},"produces":["a/b",5],"paths":{"/p":{"get":{"responses":{"200":{"description":"d","schema":{"type":"string"}}}}}}}'.
	self
		assert:
		((self reportFor: doc) gaps collect: [ :each |
			 self describeGap: each ])
		equals: #( 'extraEntity nil' ).
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/responses/200/content/a~1b' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testBodyParametersGiveTheirMediaTypesByConsumesAndNothingElse [
	"The first body parameter of an operation (inline or $ref): media types by consumes (operation, else root), and the schema of a $ref one; the second one, the one of the path item, one beside formData and an unresolved $ref give nothing"

	| doc |
	doc := self documentSwagger2Bodies.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/parameters/1/content/x~1y'
			   '#/paths/~1p/post/parameters/0/content/m~1n'
			   '#/paths/~1p/put/parameters/0/content/x~1y' ).
	self
		assert: (self derivedPointersOf: OPSchema in: doc)
		equals: #( '#/paths/~1p/get/parameters/1/schema'
			   '#/paths/~1p/get/parameters/1/schema/properties/x'
			   '#/paths/~1p/put/parameters/0/schema'
			   '#/paths/~1p/put/parameters/0/schema/properties/x' ).
	self
		assert: (self derivedPointersOf: OPProperty in: doc)
		equals: #( '#/paths/~1p/get/parameters/1/schema/properties/x'
			   '#/paths/~1p/put/parameters/0/schema/properties/x' )
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testCallbackPathItemsAreClonedWhenTheirTargetComesLaterAndSharedOtherwise [
	"/p0 clones /p1 (later) which clones /p2 (later); /p1 clones /p2; a callback to an earlier entry (/p1 to /p0) or to a component is shared (no OPPath below it); one to a target that does not exist is read again (an OPPath, the target being unresolved)"

	| doc |
	doc := self documentCallbackClones.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPPath in: doc)
		equals:
			#( '#/paths/~1p0/get/callbacks/cb/{$x}/get/callbacks/cb/{$x}'
			   '#/paths/~1p0/get/callbacks/cb/{$x}/get/callbacks/cb/{$x}/get/callbacks/cb/{$x}'
			   '#/paths/~1p1/get/callbacks/cb/{$x}/get/callbacks/cb/{$x}' ).
	self
		assert: (self derivedPointersOf: OPOperation in: doc) size
		equals: 5
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testCallbackTargetsInsideAnEntryAreSharedOnlyWhenVisitedBeforeTheSite [
	"The importer shares the entity of a path item it created before reaching the site, wherever it is (the same entry above the site, an earlier entry), and clones the one that comes later (the same entry below, a later entry)"

	| doc |
	doc := self documentCallbackTargets.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPOperation in: doc)
		equals: #( '#/paths/~1a/get/callbacks/cb/{$y}/put'
			   '#/paths/~1b/get/callbacks/cb/{$v}/delete' )
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testEverythingBelowACloneSiteHasTheRuleCloneSubtree [
	"Also a media type or a schema of Swagger 2, which have their own rule elsewhere (here the response of #/responses has it)"

	self
		assert: (self derivedCountsByRuleIn: self documentSwagger2Clones)
		equals: {
				(#swagger2Components -> 1).
				(#swagger2MediaType -> 1).
				(#cloneSubtree -> 20) } asDictionary
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testFormDataParametersGiveAFormRequestBodyOnlyWithoutBodyParameter [
	"One request body per operation (here all four), its media types (form ones of the consumes, else multipart for a file, else urlencoded), its schema and one property (with its schema, and the items) per parameter name"

	| doc |
	doc := self documentSwagger2Forms.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPRequestBody in: doc)
		equals:
			#( '#/paths/~1p/get/requestBody' '#/paths/~1p/patch/requestBody'
			   '#/paths/~1p/post/requestBody' '#/paths/~1p/put/requestBody' ).
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals:
			#( '#/paths/~1p/get/requestBody/content/application~1x-www-form-urlencoded'
			   '#/paths/~1p/patch/requestBody/content/application~1x-www-form-urlencoded'
			   '#/paths/~1p/post/requestBody/content/multipart~1form-data'
			   '#/paths/~1p/put/requestBody/content/application~1x-www-form-urlencoded'
			   '#/paths/~1p/put/requestBody/content/multipart~1form-data' ).
	self
		assert: (self derivedPointersOf: OPProperty in: doc)
		equals: #( '#/paths/~1p/get/requestBody/schema/properties/f'
			   '#/paths/~1p/patch/requestBody/schema/properties/f'
			   '#/paths/~1p/post/requestBody/schema/properties/f'
			   '#/paths/~1p/post/requestBody/schema/properties/ff'
			   '#/paths/~1p/post/requestBody/schema/properties/g'
			   '#/paths/~1p/put/requestBody/schema/properties/f' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testFormSchemaHasOneSchemaPerPropertyAndTheItemsOfAnArray [
	"The form schema and its property schemas (nothing for the properties of a document order duplicate)"

	| doc |
	doc := self documentSwagger2Forms.
	self
		assert: (self derivedPointersOf: OPSchema in: doc)
		equals: #( '#/paths/~1p/get/requestBody/schema'
			   '#/paths/~1p/get/requestBody/schema/properties/f'
			   '#/paths/~1p/patch/requestBody/schema'
			   '#/paths/~1p/patch/requestBody/schema/properties/f'
			   '#/paths/~1p/post/requestBody/schema'
			   '#/paths/~1p/post/requestBody/schema/properties/f'
			   '#/paths/~1p/post/requestBody/schema/properties/ff'
			   '#/paths/~1p/post/requestBody/schema/properties/g'
			   '#/paths/~1p/post/requestBody/schema/properties/g/items'
			   '#/paths/~1p/put/requestBody/schema'
			   '#/paths/~1p/put/requestBody/schema/properties/f' )
]

{ #category : 'tests - known limits' }
FamixOpenApiSyntheticExpectationsTest >> testKnownLimitsAreTheListedOnes [
	"The limits of the derivation, by name: each one is frozen by the test named testLimit<Name>"

	self
		assert:
		(FamixOpenApiSyntheticExpectations knownLimits collect: #first)
		equals: #( #refIntoExtension #cloneDepth ).
	self assert:
		(self class includesSelector: #testLimitRefIntoExtension).
	self assert: (self class includesSelector: #testLimitCloneDepth)
]

{ #category : 'tests - known limits' }
FamixOpenApiSyntheticExpectationsTest >> testLimitCloneDepth [
	"Twenty clones inside clones are derived; beyond FamixOpenApiCloneExpansion dataMaxDepth the entities below the deepest clone are reported as extra ones"

	| gaps |
	self assertFaithful: (self documentNestedCallbacks: 20).
	self assert: FamixOpenApiCloneExpansion dataMaxDepth equals: 32.
	gaps := (self reportFor: (self documentNestedCallbacks: 33)) gaps.
	self deny: gaps isEmpty.
	self assert: (gaps allSatisfy: [ :each | each kind = #extraEntity ])
]

{ #category : 'tests - known limits' }
FamixOpenApiSyntheticExpectationsTest >> testLimitRefIntoExtension [
	"The importer reads the value a $ref designates below an extension, the inventory has no node there: the gaps are the ones of an unresolved $ref whose clone exists"

	| doc |
	doc := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"x-r":{"R":{"description":"r","content":{"a/b":{"schema":{"type":"string"}}}}},"paths":{"/p":{"get":{"responses":{"200":{"$ref":"#/x-r/R"}}}}}}'.
	self
		assert:
			((self reportFor: doc) gaps collect: [ :each |
				 self describeGap: each ]) asArray sorted
		equals: #( 'extraEntity #/paths/~1p/get/responses/200'
			   'extraEntity #/paths/~1p/get/responses/200/content/a~1b'
			   'extraEntity #/paths/~1p/get/responses/200/content/a~1b/schema'
			   'referenceNotResolved #/paths/~1p/get/responses/200' )
]

{ #category : 'tests - data' }
FamixOpenApiSyntheticExpectationsTest >> testNoDerivedEntityIsAtThePointerOfANodeOfTheDocument [
	"What a node gives is checked with the node: the derivations only expect entities where the document has no node of the right shape (the sites of the clones, which the document has, only give entities below them)"

	self allDocuments do: [ :each |
		| inventory |
		inventory := self inventoryOf: each value.
		(self derivedFor: each value) expectedEntities do: [ :entity |
			(inventory nodeAt: entity pointer ifAbsent: [ nil ]) ifNotNil: [
				:node |
				self assert: node isWrongShape description: (self describe: {
							 each key.
							 entity }) ] ] ]
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testOpenApi30ClonesAreReRootedAtTheirSites [
	"A $ref response gives, below its site, what its target gives (also through an alias of an alias); nothing below a cyclic one, an OPReference below an unresolved one that sits in a cloned path item. A $ref path item gives the operations of its target, with the clones of its target, below the site (/r clones /q, which clones /p)"

	| doc |
	doc := self documentOpenApi30Clones.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/responses/200/content/a~1b'
			   '#/paths/~1p/get/responses/201/content/a~1b'
			   '#/paths/~1q/get/responses/200/content/a~1b'
			   '#/paths/~1q/get/responses/201/content/a~1b'
			   '#/paths/~1r/get/responses/200/content/a~1b'
			   '#/paths/~1r/get/responses/201/content/a~1b' ).
	self
		assert: (self derivedPointersOf: OPHeader in: doc)
		equals: #( '#/paths/~1p/get/responses/200/headers/h'
			   '#/paths/~1p/get/responses/201/headers/h'
			   '#/paths/~1q/get/responses/200/headers/h'
			   '#/paths/~1q/get/responses/201/headers/h'
			   '#/paths/~1r/get/responses/200/headers/h'
			   '#/paths/~1r/get/responses/201/headers/h' ).
	self
		assert: (self derivedPointersOf: OPOperation in: doc)
		equals: #( '#/paths/~1q/get' '#/paths/~1r/get' ).
	self
		assert: (self derivedPointersOf: OPResponse in: doc)
		equals:
			#( '#/paths/~1q/get/responses/200' '#/paths/~1q/get/responses/201'
			   '#/paths/~1r/get/responses/200' '#/paths/~1r/get/responses/201' ).
	self
		assert: (self derivedPointersOf: OPReference in: doc)
		equals:
		#( '#/paths/~1q/get/responses/202' '#/paths/~1r/get/responses/202' )
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticExpectationsTest >> testOpenApi30KeyedEntities [
	"Scalar and object examples of a parameter and of a media type (not of a header, a schema nor an absent one), the mapping entries with their escaped keys, a string discriminator, the scopes of the flows, the keys of the requirements"

	| doc |
	doc := self documentOpenApi30Keyed.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPExample in: doc)
		equals: #( '#/components/parameters/P/example'
			   '#/paths/~1p/get/parameters/0/example'
			   '#/paths/~1p/get/parameters/1/example'
			   '#/paths/~1p/get/responses/200/content/a~1b/example' ).
	self
		assert: (self derivedPointersOf: OPDiscriminatorMapping in: doc)
		equals: #( '#/components/schemas/S/discriminator/mapping/a~1b'
			   '#/components/schemas/S/discriminator/mapping/c~0d'
			   '#/components/schemas/S/discriminator/mapping/e' ).
	self
		assert: (self derivedPointersOf: OPDiscriminator in: doc)
		equals: #( '#/components/schemas/W/discriminator' ).
	self
		assert: (self derivedPointersOf: OPSecurityScope in: doc)
		equals:
			#( '#/components/securitySchemes/oa/flows/implicit/scopes/a~1b'
			   '#/components/securitySchemes/oa/flows/implicit/scopes/read' ).
	self
		assert: (self derivedPointersOf: OPSecurityRequirementItem in: doc)
		equals:
			#( '#/paths/~1p/get/security/0/oa' '#/paths/~1p/get/security/0/unknown'
			   '#/security/0/k' )
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testOpenApi31PathItemClonesHoldOperationsAndTheSiblingsOverrideTheTarget [
	"/p designates a component and has its own `get` (it overrides the one of the component); /q designates /p: the chain ends at the component, whose get (with its callback and its $ref response, cloned) is read at /q; the web hook clones the component too; the $ref response of the component path item itself is a use site (a clone); /c cycles on itself and /n designates nothing: nothing below"

	| doc |
	doc := self documentOpenApi31Clones.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPOperation in: doc)
		equals: #( '#/paths/~1p/get' '#/paths/~1q/get' '#/webhooks/w/get' ).
	self
		assert: (self derivedPointersOf: OPResponse in: doc)
		equals:
			#( '#/paths/~1p/get/responses/200' '#/paths/~1q/get/responses/200'
			   '#/webhooks/w/get/responses/200' ).
	self
		assert: (self derivedPointersOf: OPCallback in: doc)
		equals:
		#( '#/paths/~1q/get/callbacks/cb' '#/webhooks/w/get/callbacks/cb' ).
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals:
			#( '#/components/pathItems/PI/get/responses/200/content/a~1b'
			   '#/paths/~1q/get/responses/200/content/a~1b'
			   '#/webhooks/w/get/responses/200/content/a~1b' )
]

{ #category : 'tests - data' }
FamixOpenApiSyntheticExpectationsTest >> testRuleNamesOfTheDerivationsAreTheDocumentedOnes [
	"Every rule a derivation names is in dataRules, and every documented rule (the servers excepted: FamixOpenApiSynthesizedServers) is used by one of the fixtures"

	| documented used |
	documented := (FamixOpenApiSyntheticExpectations dataRules collect:
		               #first) asSet copyWithout: #synthesizedServer.
	used := (self allDocuments flatCollect: [ :each |
		         (self derivedFor: each value) expectedEntities collect:
			         #ruleName ]) asSet.
	self assert: used equals: documented
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticExpectationsTest >> testRulesOfTheKeyedEntitiesOfOpenApi3 [
	"A discriminator that is a string in OpenAPI 3 is the rule wrongShapeDiscriminator (the mapping entries and the scopes have theirs); the rules of Swagger 2 do not apply to OpenAPI 3"

	self
		assert: (self derivedCountsByRuleIn: self documentOpenApi30Keyed)
		equals: {
				(#scalarExample -> 4).
				(#discriminatorMappingEntry -> 3).
				(#wrongShapeDiscriminator -> 1).
				(#securityScope -> 2).
				(#securityRequirementItem -> 3) } asDictionary
]

{ #category : 'tests - data' }
FamixOpenApiSyntheticExpectationsTest >> testSchemaKeysOfATypedParameterAreTheOnesOfTheImporter [
	"The validation does not depend on the importer: it keeps its own copy of the keys, and this test (the test package may use the importer) compares both"

	self
		assert: FamixOpenApiSwagger2Parameters dataSchemaKeys asArray
		equals: FamixOpenApiSwagger2Version new parameterSchemaKeys asArray
]

{ #category : 'tests - data' }
FamixOpenApiSyntheticExpectationsTest >> testServersAreNotDerivedHere [
	"The servers without node have their own derivation (FamixOpenApiSynthesizedServers); the derived ones have a pointer, a class of the family of their name, a rule and an origin"

	self allDocuments do: [ :each |
		(self derivedFor: each value) expectedEntities do: [ :entity |
			self deny: entity ruleName equals: #synthesizedServer.
			self deny: entity targetClassName equals: 'OPServer'.
			self assert: entity pointer isString.
			self assert: entity originPointer isString.
			self assert: (entity family isKindOf: Class) ] ]
]

{ #category : 'tests - clones' }
FamixOpenApiSyntheticExpectationsTest >> testSwagger2ClonesCarryTheirSchemaItemsAndMediaTypes [
	"A $ref response (also an alias) gives its header, its schema with the items and one media type per produces below each site; /q clones /p, with the clones of /p; the unresolved one gives an OPReference in the clone, the cyclic one nothing"

	| doc |
	doc := self documentSwagger2Clones.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPSchema in: doc)
		equals: #( '#/paths/~1p/get/responses/200/schema'
			   '#/paths/~1p/get/responses/200/schema/items'
			   '#/paths/~1p/get/responses/201/schema'
			   '#/paths/~1p/get/responses/201/schema/items'
			   '#/paths/~1q/get/responses/200/schema'
			   '#/paths/~1q/get/responses/200/schema/items'
			   '#/paths/~1q/get/responses/201/schema'
			   '#/paths/~1q/get/responses/201/schema/items' ).
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/responses/200/content/a~1b'
			   '#/paths/~1p/get/responses/201/content/a~1b'
			   '#/paths/~1q/get/responses/200/content/a~1b'
			   '#/paths/~1q/get/responses/201/content/a~1b'
			   '#/responses/R/content/a~1b' ).
	self
		assert: (self derivedPointersOf: OPReference in: doc)
		equals: #( '#/paths/~1q/get/responses/202' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testSwagger2ComponentsNeedADefinitionsParametersResponsesOrSecuritySection [
	"The importer builds the empty components only for those root keys (whatever their value)"

	{
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{}}'
		 -> 0).
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},"definitions":{}}'
		 -> 1).
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},"parameters":5}'
		 -> 1).
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},"responses":{}}'
		 -> 1).
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},"securityDefinitions":[]}'
		 -> 1).
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},"tags":[]}'
		 -> 0).
		('{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},"x-definitions":{}}'
		 -> 0) } do: [ :each |
		self assertFaithful: each key.
		self
			assert: (self derivedPointersOf: OPComponents in: each key) size
			equals: each value ]
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testSwagger2DiscriminatorScopesAndRequirementItems [
	"A string (or object) discriminator, the scopes of the oauth2 schemes that hold a scopes object (not a basic scheme nor a scopes string), every key of a requirement even of an unknown scheme"

	| doc |
	doc := self documentSwagger2Security.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPDiscriminator in: doc)
		equals:
		#( '#/definitions/A/discriminator' '#/definitions/B/discriminator' ).
	self
		assert: (self derivedPointersOf: OPSecurityScope in: doc)
		equals: #( '#/securityDefinitions/oa/scopes/a~1b'
			   '#/securityDefinitions/oa/scopes/read' ).
	self
		assert: (self derivedPointersOf: OPSecurityRequirementItem in: doc)
		equals:
			#( '#/paths/~1p/get/security/0/oa' '#/paths/~1p/get/security/0/zzz'
			   '#/security/0/b' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testSwagger2ResponsesGetOneMediaTypePerProducesOfTheNearestList [
	"The produces of the operation, else (empty list) of the root; none for a response without schema nor for one whose schema is an unresolved $ref"

	| doc |
	doc := self documentSwagger2Responses.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/responses/200/content/o~1a'
			   '#/paths/~1p/get/responses/200/content/o~1b'
			   '#/paths/~1p/post/responses/200/content/r~1a'
			   '#/paths/~1p/put/responses/200/content/r~1a' ).
	self assert: (self derivedCountsByRuleIn: doc) equals: {
			(#swagger2MediaType -> 4).
			(#swagger2Components -> 1) } asDictionary
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testTheExampleOfATypedParameterIsDerivedButNotTheOneOfABodyParameter [
	"The importer builds an OPExample for the `example` of an OPParameter; a body parameter is an OPRequestBody, a header and a response example are not read"

	| doc |
	doc := self documentSwagger2Examples.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPExample in: doc)
		equals: #( '#/paths/~1p/get/parameters/0/example' ).
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/parameters/1/content/*~1*' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testTypedParametersGiveASchemaWithTheirItemsChain [
	"Typed parameters (not $ref, not body, not formData, with an `in`) of an operation, of a path item and of #/parameters; none for an untyped header, a $ref, an unresolved $ref, a body, a parameter without location; the body without consumes has */*"

	| doc |
	doc := self documentSwagger2Typed.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPSchema in: doc)
		equals:
			#( '#/parameters/T/schema' '#/paths/~1p/get/parameters/0/schema'
			   '#/paths/~1p/get/parameters/0/schema/items'
			   '#/paths/~1p/get/parameters/0/schema/items/items'
			   '#/paths/~1p/get/parameters/2/schema'
			   '#/paths/~1p/get/parameters/6/schema'
			   '#/paths/~1p/parameters/0/schema'
			   '#/paths/~1p/parameters/0/schema/items' ).
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/parameters/5/content/*~1*' )
]

{ #category : 'tests - swagger 2' }
FamixOpenApiSyntheticExpectationsTest >> testValuesOfTheWrongShapeGiveNothingAndTheirNeighboursStillDo [
	"A response schema that is a boolean, a string or null gives no media type; parameters that are not objects, and a parameters list that is a string, give nothing and do not hide the good parameter next to them"

	| doc |
	doc := self documentSwagger2WrongShapes.
	self assertFaithful: doc.
	self
		assert: (self derivedPointersOf: OPMediaType in: doc)
		equals: #( '#/paths/~1p/get/responses/203/content/a~1b'
			   '#/paths/~1p/post/requestBody/content/application~1x-www-form-urlencoded' ).
	self
		assert: (self derivedPointersOf: OPSchema in: doc)
		equals: #( '#/paths/~1p/get/parameters/1/schema'
			   '#/paths/~1p/post/requestBody/schema'
			   '#/paths/~1p/post/requestBody/schema/properties/f' ).
	self
		assert: (self derivedPointersOf: OPRequestBody in: doc)
		equals: #( '#/paths/~1p/post/requestBody' )
]

{ #category : 'tests - 3.x' }
FamixOpenApiSyntheticExpectationsTest >> testWhatIsBelowTheKeywordsTheImporterDoesNotReadGivesNothing [
	"A discriminator and an example below $defs, a discriminator below `if`: no entity"

	| doc |
	doc := self documentOpenApi31Dropped.
	self assertFaithful: doc.
	self assert: (self derivedFor: doc) expectedEntities isEmpty
]
