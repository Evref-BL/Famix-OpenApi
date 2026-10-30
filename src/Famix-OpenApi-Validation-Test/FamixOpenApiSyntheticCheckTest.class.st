"
Tests of the reverse direction of the existence check (V7b): the entities without node are EXACTLY the derived ones (FamixOpenApiSyntheticExpectations). A sweep over every derived entity of every fixture (taken out: #missingEntity of its rule; doubled: #unexpectedMultiple of its rule; of another class: #wrongClass, or #missingEntity and #extraEntity), and the strays at the look-alike pointers where the old pattern rules accepted anything and the derivation does not apply (a stray entity there is an #extraEntity).
"
Class {
	#name : 'FamixOpenApiSyntheticCheckTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiSyntheticCheckTest >> assertStray: aClass at: aPointer in: aJsonString [
	"An entity of aClass added at aPointer to the faithful model is the only gap, an #extraEntity at that pointer"

	self
		assert: (self
				 gapDescriptionsOf: aJsonString
				 after: [ :model | self add: aClass at: aPointer to: model ])
		equals: { (self describeKind: #extraEntity pointer: aPointer) }
]

{ #category : 'helpers' }
FamixOpenApiSyntheticCheckTest >> assertStrays: aCollection in: aJsonString [
	"aCollection holds class -> pointer associations"

	aCollection do: [ :each |
		self assertStray: each key at: each value in: aJsonString ]
]

{ #category : 'tests - rules' }
FamixOpenApiSyntheticCheckTest >> testADuplicatedSyntheticEntityIsAnUnexpectedMultipleOfItsRule [

	self
		assert: (self
				 gapDescriptionsOf: self documentSwagger2Responses
				 after: [ :model |
					 self
						 add: OPMediaType
						 at: '#/paths/~1p/post/responses/200/content/r~1a'
						 to: model.
					 self add: OPComponents at: '#/components' to: model ])
		equals: #( 'unexpectedMultiple #/components swagger2Components'
			   'unexpectedMultiple #/paths/~1p/post/responses/200/content/r~1a swagger2MediaType' )
]

{ #category : 'tests - rules' }
FamixOpenApiSyntheticCheckTest >> testAForgottenSyntheticEntityIsAMissingEntityOfItsRule [
	"The old rules only accepted them: an example, a mapping entry (3.0), a media type, a scope, a form request body (Swagger 2), a clone entity"

	self
		assert: (self
				 gapDescriptionsOf: self documentOpenApi30Keyed
				 after: [ :model |
					 self
						 remove: OPExample
						 at: '#/paths/~1p/get/parameters/0/example'
						 from: model.
					 self
						 remove: OPDiscriminatorMapping
						 at: '#/components/schemas/S/discriminator/mapping/e'
						 from: model ])
		equals:
			#( 'missingEntity #/components/schemas/S/discriminator/mapping/e discriminatorMappingEntry'
			   'missingEntity #/paths/~1p/get/parameters/0/example scalarExample' ).
	self
		assert:
			(self
				 gapDescriptionsOf: self documentSwagger2Forms
				 after: [ :model |
					 self
						 remove: OPRequestBody
						 at: '#/paths/~1p/put/requestBody'
						 from: model.
					 self
						 remove: OPMediaType
						 at: '#/paths/~1p/put/requestBody/content/multipart~1form-data'
						 from: model ])
		equals:
			#( 'missingEntity #/paths/~1p/put/requestBody swagger2FormDataRequestBody'
			   'missingEntity #/paths/~1p/put/requestBody/content/multipart~1form-data swagger2FormDataRequestBody' ).
	self
		assert: (self
				 gapDescriptionsOf: self documentOpenApi30Clones
				 after: [ :model |
					 self
						 remove: OPHeader
						 at: '#/paths/~1q/get/responses/200/headers/h'
						 from: model ])
		equals:
		#( 'missingEntity #/paths/~1q/get/responses/200/headers/h cloneSubtree' )
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testALookAlikeOfAKeyedEntityWithoutItsSourceKeyIsExtra [
	"An example of a header, of a schema, of a parameter or media type without example; a mapping entry or a scope that the map does not hold; an item for a key the requirement does not have; a discriminator of a schema without one; scopes of a basic scheme"

	self
		assertStrays: {
				(OPExample -> '#/paths/~1p/get/responses/200/headers/h/example').
				(OPExample -> '#/paths/~1p/get/parameters/0/schema/example').
				(OPExample -> '#/paths/~1p/get/parameters/2/example').
				(OPExample -> '#/paths/~1p/get/responses/200/content/c~1d/example').
				(OPExample -> '#/components/schemas/S/example').
				(OPDiscriminatorMapping
				 -> '#/components/schemas/S/discriminator/mapping/zzz').
				(OPDiscriminatorMapping
				 -> '#/components/schemas/N/discriminator/mapping/a').
				(OPDiscriminator -> '#/components/schemas/N/discriminator/zzz').
				(OPSecurityScope
				 -> '#/components/securitySchemes/oa/flows/password/scopes/x').
				(OPSecurityScope -> '#/components/securitySchemes/k/scopes/x').
				(OPSecurityRequirementItem -> '#/paths/~1p/get/security/0/zzz').
				(OPSecurityRequirementItem -> '#/paths/~1p/get/security/1/oa') }
		in: self documentOpenApi30Keyed.
	self
		assertStrays: {
				(OPDiscriminator -> '#/definitions/C/discriminator').
				(OPSecurityScope -> '#/securityDefinitions/b/scopes/x').
				(OPSecurityScope -> '#/securityDefinitions/o2/scopes/x').
				(OPSecurityRequirementItem -> '#/security/0/zzz').
				(OPSecurityRequirementItem -> '#/paths/~1p/get/security/1/oa').
				(OPComponents -> '#/components2') }
		in: self documentSwagger2Security
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testAMediaTypeBelowSomethingThatMakesNoneIsExtra [
	"Swagger 2: a response without schema (or with an unresolved $ref schema), a mime that the produces does not list, a second body parameter, a path level one, a body parameter without schema, a $ref parameter, a typed one, the root"

	self
		assertStrays: {
				(OPMediaType -> '#/paths/~1p/get/responses/204/content/x~1y').
				(OPMediaType -> '#/paths/~1p/post/responses/201/content/r~1a').
				(OPMediaType -> '#/paths/~1p/get/responses/200/content/zz~1zz').
				(OPMediaType -> '#/paths/~1p/get/responses/200/content/r~1a').
				(OPMediaType -> '#/content/r~1a').
				(OPMediaType -> '#/paths/~1p/get/content/o~1a') }
		in: self documentSwagger2Responses.
	self
		assertStrays: {
				(OPMediaType -> '#/paths/~1p/post/parameters/1/content/m~1n').
				(OPMediaType -> '#/paths/~1p/parameters/0/content/x~1y').
				(OPMediaType -> '#/paths/~1p/patch/parameters/0/content/x~1y').
				(OPMediaType -> '#/paths/~1p/get/parameters/0/content/x~1y').
				(OPMediaType -> '#/paths/~1p/post/parameters/0/content/x~1y') }
		in: self documentSwagger2Bodies.
	self
		assertStrays: {
				(OPMediaType -> '#/paths/~1p/get/parameters/0/content/*~1*').
				(OPMediaType -> '#/paths/~1p/get/parameters/3/content/*~1*') }
		in: self documentSwagger2Typed
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testAParasiteBelowACloneSiteIsExtra [
	"The old rule accepted anything below a $ref response or path item: now only what the target gives, re-rooted; a key the target does not have, another class, a clone below a cyclic or an unresolved site"

	self
		assertStrays: {
				(OPSchema -> '#/paths/~1p/get/responses/200/zzz').
				(OPMediaType -> '#/paths/~1p/get/responses/200/content/c~1d').
				(OPHeader -> '#/paths/~1p/get/responses/200/headers/other').
				(OPExample -> '#/paths/~1p/get/responses/200/headers/h/example').
				(OPSchema -> '#/paths/~1p/get/responses/203/content/a~1b/schema').
				(OPMediaType -> '#/paths/~1p/get/responses/202/content/a~1b').
				(OPOperation -> '#/paths/~1q/put').
				(OPResponse -> '#/paths/~1q/get/responses/209').
				(OPMediaType -> '#/paths/~1r/get/responses/200/content/zz') }
		in: self documentOpenApi30Clones.
	self
		assertStrays: {
				(OPOperation -> '#/paths/~1q/put').
				(OPCallback -> '#/paths/~1c/get/callbacks/cb').
				(OPOperation -> '#/paths/~1n/get').
				(OPResponse -> '#/webhooks/w/get/responses/201').
				(OPPath -> '#/webhooks/w/get/callbacks/cb/{$x}').
				(OPOperation -> '#/paths/~1p/post') }
		in: self documentOpenApi31Clones.
	self
		assertStrays: {
				(OPSchema -> '#/paths/~1q/get/responses/200/schema/items/items').
				(OPMediaType -> '#/paths/~1q/get/responses/203/content/a~1b').
				(OPHeader -> '#/paths/~1q/get/responses/200/headers/zzz') }
		in: self documentSwagger2Clones.
	self
		assertStrays: {
				(OPPath -> '#/paths/~1p1/get/callbacks/cb/{$y}/zzz').
				(OPPath -> '#/paths/~1p1/get/callbacks/cb/{$y}').
				(OPOperation -> '#/paths/~1p0/get/callbacks/cb/{$y}/get') }
		in: self documentCallbackClones
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testASchemaBelowSomethingThatMakesNoneIsExtra [
	"Swagger 2: under a $ref parameter, a formData parameter, an untyped parameter, a body parameter (its schema is a node of the document, not a derived one), a path level body, the info, an operation, the root"

	self
		assertStrays: {
				(OPSchema -> '#/paths/~1p/get/parameters/3/schema').
				(OPSchema -> '#/paths/~1p/get/parameters/4/schema').
				(OPSchema -> '#/paths/~1p/get/parameters/1/schema').
				(OPSchema -> '#/paths/~1p/get/parameters/7/schema').
				(OPSchema -> '#/parameters/U/schema').
				(OPSchema -> '#/parameters/H/schema').
				(OPSchema -> '#/paths/~1p/get/schema').
				(OPSchema -> '#/info/schema').
				(OPSchema -> '#/schema').
				(OPSchema
				 -> '#/paths/~1p/get/parameters/0/schema/items/items/items') }
		in: self documentSwagger2Typed.
	self
		assertStrays: {
				(OPSchema -> '#/paths/~1p/post/parameters/0/schema/zzz').
				(OPSchema -> '#/paths/~1p/parameters/0/schema').
				(OPSchema -> '#/paths/~1p/post/parameters/2/schema') }
		in: self documentSwagger2Bodies.
	self
		assertStrays:
		{ (OPSchema -> '#/paths/~1p/post/parameters/0/schema') }
		in: self documentSwagger2Forms
]

{ #category : 'tests - rules' }
FamixOpenApiSyntheticCheckTest >> testASubclassInsteadOfTheExpectedClassIsAWrongClassOfTheRule [
	"The family matches, the class does not (the stub is a subclass of OPSchema)"

	self
		assert:
			(self
				 gapDescriptionsOf: self documentSwagger2Typed
				 after: [ :model |
					 self
						 replace: OPSchema
						 at: '#/parameters/T/schema'
						 with: FamixOpenApiStubSchema
						 in: model ])
		equals:
		#( 'wrongClass #/parameters/T/schema swagger2ParameterSchema' )
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testASwagger2FormRequestBodyHasOnlyItsMediaTypesAndFields [
	"Under a real form request body: a media type that the consumes does not give, a property of an unknown parameter, another depth"

	self
		assertStrays: {
				(OPMediaType
				 ->
				 '#/paths/~1p/post/requestBody/content/application~1x-www-form-urlencoded').
				(OPMediaType -> '#/paths/~1p/put/requestBody/content/a~1b').
				(OPProperty
				 -> '#/paths/~1p/post/requestBody/schema/properties/nope').
				(OPSchema
				 -> '#/paths/~1p/post/requestBody/schema/properties/f/items').
				(OPSchema -> '#/paths/~1p/post/requestBody/schema/zzz') }
		in: self documentSwagger2Forms
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testASwagger2RequestBodyWithoutFormDataIsExtra [
	"The old rule accepted any class at any depth below <operation>/requestBody on every Swagger 2 operation"

	self
		assertStrays: {
				(OPRequestBody -> '#/paths/~1p/get/requestBody').
				(OPMediaType -> '#/paths/~1p/get/requestBody/content/x~1y').
				(OPSchema -> '#/paths/~1p/get/requestBody/schema').
				(OPProperty -> '#/paths/~1p/get/requestBody/schema/properties/p').
				(OPSchema -> '#/paths/~1p/get/requestBody/zzz/deep') }
		in: self documentSwagger2Responses.
	self
		assertStrays: {
				(OPRequestBody -> '#/paths/~1p/post/requestBody').
				(OPMediaType -> '#/paths/~1p/post/requestBody/content/m~1n') }
		in: self documentSwagger2Bodies
]

{ #category : 'tests - rules' }
FamixOpenApiSyntheticCheckTest >> testAWrongClassOfASyntheticEntityIsReportedWithItsRule [
	"Another family: the expected one is missing and the other one is an extra entity; the family of the dummy keeps the pointer"

	self
		assert: (self
				 gapDescriptionsOf: self documentSwagger2Responses
				 after: [ :model |
					 self
						 replace: OPComponents
						 at: '#/components'
						 with: OPTag
						 in: model ])
		equals:
		#( 'extraEntity #/components' 'missingEntity #/components swagger2Components' )
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testAnEntityThatIsNotAServerAtAServerPointerIsExtra [
	"The servers without node are accepted by their pointer and their class: another class there, or a server elsewhere, is an extra entity"

	self
		assertStrays: {
				(OPInfo -> '#/servers/1').
				(OPTag -> '#/servers/0').
				(OPServer -> '#/servers/x').
				(OPServer -> '#/servers') }
		in: self documentOpenApi30Scalars.
	self
		assertStrays: { (OPServer -> '#/servers/0/zzz') }
		in: self documentSwagger2Typed
]

{ #category : 'tests - strays' }
FamixOpenApiSyntheticCheckTest >> testComponentsOfSwagger2NeedARootSectionAndOpenApi3HasNoneSynthetic [
	"The importer builds none for a Swagger 2 document without definitions, parameters, responses nor securityDefinitions; a synthetic Swagger 2 rule does not apply to an OpenAPI 3 document"

	self
		assertStray: OPComponents
		at: '#/components'
		in:
		'{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{}}'.
	self
		assertStrays: {
				(OPComponents -> '#/components2').
				(OPMediaType -> '#/paths/~1p/get/responses/200/content/a~1b/zzz').
				(OPSchema -> '#/paths/~1p/get/parameters/0/schema/items').
				(OPRequestBody -> '#/paths/~1p/get/requestBody2') }
		in: self documentOpenApi30Keyed
]

{ #category : 'tests - sweeps' }
FamixOpenApiSyntheticCheckTest >> testEveryDerivedEntityOfEveryFixtureIsRequiredOnceAndOfItsClass [
	"Taken out, doubled, replaced by another class: always reported, with the name of the rule"

	self allDocuments do: [ :each |
		self assertDerivedSweepsIn: each value named: each key ]
]

{ #category : 'tests - rules' }
FamixOpenApiSyntheticCheckTest >> testTheGapOfAForgottenEntityIsAboutTheNodeItIsDerivedFrom [
	"The spec object of the gap is the one of the node (of the document, or of its clone) that the rule reads, its message names the rule"

	| doc model gaps gap |
	doc := self documentOpenApi30Keyed.
	model := self modelOf: doc.
	self
		remove: OPExample
		at: '#/paths/~1p/get/parameters/0/example'
		from: model.
	self
		remove: OPSecurityScope
		at: '#/components/securitySchemes/oa/flows/implicit/scopes/read'
		from: model.
	gaps := (self reportOf: model for: doc) gaps.
	self
		assert: (gaps collect: #specObject) asSet
		equals: #( 'Parameter' 'OAuthFlow' ) asSet.
	gap := gaps detect: [ :each | each expected = 'OPExample' ].
	self assert: gap specObject equals: 'Parameter'.
	self assert: (gap message includesSubstring: 'scalarExample').
	self assert: gap entity isNil
]
