"
V10: the relations of the conversions of Swagger 2, VERIFIED by import: the servers made of host, basePath and schemes, the components made of the definitions, the media types made of produces and consumes with the schema of the response or of the body parameter, the request body of a body parameter (first one only, also through a $ref) and of the formData parameters, the schema of a typed parameter and its items, the oauth2 scheme that is its own flow.
"
Class {
	#name : 'FamixOpenApiRelationSwagger2Test',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> documentTypedParameterWithItemsAndSchema [
	"Swagger 2: a typed parameter that has items AND a non-empty schema (an invalid document: the schema of a typed parameter is the one that the typed keywords give)"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"q","in":"query","type":"array","items":{"type":"string"},"schema":{"type":"string"}}],"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testAMediaTypeListedTwiceInProducesIsHeldTwice [
	"VERIFIED: two entities at the same pointer, both in the relation (the other relations are sets, this one is derived without node)"

	self assertRelationFaithful: self documentDuplicatesSwagger2.
	self
		assertExpectedAt: '#/paths/~1p/get/responses/200'
		selector: #content
		in: self documentDuplicatesSwagger2
		is: #( '#/paths/~1p/get/responses/200/content/a~1b'
			   '#/paths/~1p/get/responses/200/content/a~1b'
			   '#/paths/~1p/get/responses/200/content/c~1d' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testAParameterWithAnInThatIsNotBodyOrFormDataIsTypedWhateverTheValueAndHoldsNoSchemaOfItsSchemaKey [
	"VERIFIED by import: a parameter that has an `in` (a text the importer does not know, a number, null, a list, an object, a $ref that is not a text) is a typed parameter that ignores its `schema` key; the importer reports a value that is not a text as wrongNodeType and keeps no schema (nor a request body)"

	#( '7' 'null' '"text"' 'true' '[]' '{}' '{"a":{"b":[1]}}'
	   '{"$ref":null}' '{"$ref":7}' '{"x-a":1}' ) do: [ :each |
		| json |
		json := self
			        replace: '"name":"b","in":"body"'
			        with: ('"name":"b","in":{1}' format: { each })
			        in: self documentStructureSwagger2.
		self assertRelationFaithful: json.
		self assert: (self reportFor: json) gaps isEmpty.
		self
			assertExpectedAt: '#/paths/~1p/post/parameters/0'
			selector: #schema
			in: json
			is: #(  ) ]
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testAParameterWithoutAnInHoldsTheSchemaOfItsSchemaKey [
	"VERIFIED by import: without `in` the parameter is not typed, it holds the schema of its `schema` key"

	| json |
	json := self
		        replace: '"name":"b","in":"body"'
		        with: '"name":"b"'
		        in: self documentStructureSwagger2.
	self assertRelationFaithful: json.
	self
		assertExpectedAt: '#/paths/~1p/post/parameters/0'
		selector: #schema
		in: json
		is: #( '#/definitions/D' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testAReferenceToABodyParameterIsARequestBodyAtTheSiteWithItsOwnSchema [
	"VERIFIED: the parameter of the components is not held by the operation; the schema of its target is read again at the site"

	| json |
	json := self documentStructureSwagger2.
	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #requestBody
		in: json
		is: #( '#/paths/~1p/get/parameters/0' ).
	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #parameters
		in: json
		is: #(  ).
	self
		assertExpectedAt:
		'#/paths/~1p/get/parameters/0/content/application~1json'
		selector: #schema
		in: json
		is: #( '#/paths/~1p/get/parameters/0/schema' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testAResponseReferenceIsACloneWhoseMediaTypesHoldTheSchemaReadAgainAtTheSite [
	"VERIFIED: the schema of the response of the components is read again below the site"

	self
		assertExpectedAt:
		'#/paths/~1p/post/responses/201/content/application~1json'
		selector: #schema
		in: self documentStructureSwagger2
		is: #( '#/paths/~1p/post/responses/201/schema' ).
	self
		assertExpectedAt: '#/responses/R/content/application~1json'
		selector: #schema
		in: self documentStructureSwagger2
		is: #( '#/responses/R/schema' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testAResponseWithASchemaHoldsOneMediaTypePerProducesAndAResponseWithoutOneHoldsNone [

	| json |
	json := self documentStructureSwagger2.
	self
		assertExpectedAt: '#/paths/~1p/post/responses/200'
		selector: #content
		in: json
		is: #( '#/paths/~1p/post/responses/200/content/application~1json'
			   '#/paths/~1p/post/responses/200/content/text~1plain' ).
	self
		assertExpectedAt:
		'#/paths/~1p/post/responses/200/content/text~1plain'
		selector: #schema
		in: json
		is: #( '#/definitions/D' ).
	self
		assertExpectedAt: '#/paths/~1p/post/responses/default'
		selector: #content
		in: json
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testASecondBodyParameterAndTheFormParametersOfAnOperationWithABodyAreNotHeld [
	"VERIFIED: only the first body parameter is the request body"

	| json |
	json := self documentParametersSwagger2.
	self assertRelationFaithful: json.
	self
		assertExpectedAt: '#/paths/~1p/post'
		selector: #requestBody
		in: json
		is: #( '#/paths/~1p/post/parameters/0' ).
	self
		assertExpectedAt: '#/paths/~1p/post'
		selector: #parameters
		in: json
		is:
		#( '#/paths/~1p/post/parameters/3' '#/paths/~1p/post/parameters/4' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testATypedParameterHasASchemaAndAnArrayParameterItsItems [

	self
		assertExpectedAt: '#/paths/~1p/post/parameters/1'
		selector: #schema
		in: self documentStructureSwagger2
		is: #( '#/paths/~1p/post/parameters/1/schema' ).
	self
		assertExpectedAt: '#/paths/~1p/post/parameters/1/schema'
		selector: #items
		in: self documentStructureSwagger2
		is: #( '#/paths/~1p/post/parameters/1/schema/items' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testATypedParameterThatAlsoHasASchemaKeyHoldsTheSchemaOfItsType [
	"VERIFIED by import: the schema of the type (at <parameter>/schema), not the $ref of the `schema` key. Known limit: the `schema` key shadows the typed schema in the expanded inventory, so the items below it are reported by the existence check as well as by the relation check (a document that Swagger 2 does not allow: type and schema together); only the relation of the parameter is asserted"

	| json |
	json := self
		        replace: '"type":"array","items":{"type":"integer"}}'
		        with:
		        '"type":"array","items":{"type":"integer"},"schema":{"$ref":"#/definitions/D"}}'
		        in: self documentStructureSwagger2.
	self
		assertExpectedAt: '#/paths/~1p/post/parameters/1'
		selector: #schema
		in: json
		is: #( '#/paths/~1p/post/parameters/1/schema' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testKnownLimitE1ATypedParameterWithItemsAndASchemaGivesARelationMismatchForItsItems [
	"KNOWN LIMIT E1 (frozen, see the comment of FamixOpenApiRelationCheck): the virtual pointer of the schema of the typed parameter ('<param>/schema') is the one of the real schema key of the document, so the items of the typed schema are looked for at the pointer where the importer put the real schema: the relation check says that items is missing there and that the entity at '<param>/schema/items' is extra, and the existence check says #extraEntity at that entity. VERIFIED by import. An invalid document"

	| gaps |
	gaps := (self relationReportFor:
		         self documentTypedParameterWithItemsAndSchema) gaps.
	self assert: gaps size equals: 1.
	self assert: gaps first kind equals: #relationMismatch.
	self
		assert: gaps first sourcePointer
		equals: '#/paths/~1p/get/parameters/0/schema'.
	self assert: gaps first fieldKey equals: 'items'.
	self
		assert:
			((self reportFor: self documentTypedParameterWithItemsAndSchema)
				 gaps collect: [ :each | each kind -> each sourcePointer ])
		equals:
		{ (#extraEntity -> '#/paths/~1p/get/parameters/0/schema/items') }
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheBodyParameterIsTheRequestBodyAtItsPointerWithTheMediaTypesOfConsumes [

	| json |
	json := self documentStructureSwagger2.
	self
		assertExpectedAt: '#/paths/~1p/post'
		selector: #requestBody
		in: json
		is: #( '#/paths/~1p/post/parameters/0' ).
	self
		assertExpectedAt: '#/paths/~1p/post/parameters/0'
		selector: #content
		in: json
		is: #( '#/paths/~1p/post/parameters/0/content/application~1json'
			   '#/paths/~1p/post/parameters/0/content/application~1xml' ).
	self
		assertExpectedAt:
		'#/paths/~1p/post/parameters/0/content/application~1xml'
		selector: #schema
		in: json
		is: #( '#/definitions/D' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheComponentsHoldTheDefinitionsTheParametersTheResponsesAndTheSecurityDefinitions [

	| json |
	json := self documentStructureSwagger2.
	self
		assertExpectedAt: '#'
		selector: #components
		in: json
		is: #( '#/components' ).
	self
		assertExpectedAt: '#/components'
		selector: #schemas
		in: json
		is: #( '#/definitions/D' '#/definitions/E' ).
	self
		assertExpectedAt: '#/components'
		selector: #parameters
		in: json
		is: #( '#/parameters/Q' '#/parameters/B' ).
	self
		assertExpectedAt: '#/components'
		selector: #responses
		in: json
		is: #( '#/responses/R' ).
	self
		assertExpectedAt: '#/components'
		selector: #securitySchemes
		in: json
		is: #( '#/securityDefinitions/k' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheDefinitionsHoldTheirAllOfAndTheStringDiscriminator [

	self
		assertExpectedAt: '#/definitions/D'
		selector: #allOf
		in: self documentStructureSwagger2
		is: #( '#/definitions/E' ).
	self
		assertExpectedAt: '#/definitions/D'
		selector: #discriminator
		in: self documentStructureSwagger2
		is: #( '#/definitions/D/discriminator' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheFormMediaTypesAreThoseOfTheOperationConsumesOrTheRootOrTheDefaultOfTheForm [
	"VERIFIED by import: the form media types of the consumes of the operation (in its order), else of the root; without any, multipart/form-data for a form with a file, else application/x-www-form-urlencoded"

	| json multipart urlencoded rootMultipart |
	json := self documentFormsSwagger2.
	rootMultipart := self
		                 replace: '"consumes":["application/json"],"paths"'
		                 with: '"consumes":["multipart/form-data"],"paths"'
		                 in: json.
	multipart := 'multipart~1form-data'.
	urlencoded := 'application~1x-www-form-urlencoded'.
	self assertRelationFaithful: json.
	self assertRelationFaithful: rootMultipart.
	{
		('post' -> { multipart }).
		('put' -> { urlencoded }).
		('patch' -> { multipart }).
		('get' -> { urlencoded }).
		('delete' -> {
			 urlencoded.
			 multipart }).
		('head' -> { urlencoded }) } do: [ :each |
		self
			assertExpectedAt:
			('#/paths/~1p/{1}/requestBody' format: { each key })
			selector: #content
			in: json
			is: (each value collect: [ :mime |
					 '#/paths/~1p/{1}/requestBody/content/{2}' format: {
							 each key.
							 mime } ]) ].
	self
		assertExpectedAt: '#/paths/~1p/get/requestBody'
		selector: #content
		in: rootMultipart
		is: { '#/paths/~1p/get/requestBody/content/multipart~1form-data' }
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheFormParametersMakeARequestBodyWithAFormSchemaOfProperties [

	| json |
	json := self documentStructureSwagger2.
	self
		assertExpectedAt: '#/paths/~1p/put'
		selector: #requestBody
		in: json
		is: #( '#/paths/~1p/put/requestBody' ).
	self
		assertExpectedAt: '#/paths/~1p/put/requestBody'
		selector: #content
		in: json
		is: #( '#/paths/~1p/put/requestBody/content/multipart~1form-data' ).
	self
		assertExpectedAt:
		'#/paths/~1p/put/requestBody/content/multipart~1form-data'
		selector: #schema
		in: json
		is: #( '#/paths/~1p/put/requestBody/schema' ).
	self
		assertExpectedAt: '#/paths/~1p/put/requestBody/schema'
		selector: #properties
		in: json
		is: #( '#/paths/~1p/put/requestBody/schema/properties/f'
			   '#/paths/~1p/put/requestBody/schema/properties/g' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheImporterMeetsTheDefinitionsThenTheResponsesThenThePaths [
	"VERIFIED by import (documentUnresolvedSwagger2): the unresolvedReferences of the root are N7 (definitions), N6 (responses), then N2, N1, N3, N4 (paths). N5, the parameter Q that is an alias of the components, is a componentAlias diagnostic, not a reference"

	| importer model root |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: self documentUnresolvedSwagger2.
	root := model allModelEntities detect: [ :each |
		        each class == OPOpenApi ].
	self
		assert: (root unresolvedReferences collect: #name as: Array)
		equals: #( 'N7' 'N6' 'N2' 'N1' 'N3' 'N4' ).
	self
		assert: (importer diagnostics withCode: #componentAlias) size
		equals: 1.
	self
		assert:
		(importer diagnostics withCode: #componentAlias) first pointer
		equals: '#/parameters/Q'
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheOperationsAreInTheOrderOfTheSourceAndTheirParametersLeaveOutTheBodyAndTheForm [
	"VERIFIED: the body parameter is the request body, the formData parameters make the form"

	self
		assertExpectedAt: '#/paths/~1p'
		selector: #operations
		in: self documentStructureSwagger2
		is: #( '#/paths/~1p/post' '#/paths/~1p/put' '#/paths/~1p/get' ).
	self
		assertExpectedAt: '#/paths/~1p/post'
		selector: #parameters
		in: self documentStructureSwagger2
		is: #( '#/paths/~1p/post/parameters/1'
		   '#/parameters/Q' ).
	self
		assertExpectedAt: '#/paths/~1p/put'
		selector: #parameters
		in: self documentStructureSwagger2
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheServersAreMadeOfHostBasePathAndSchemes [

	self
		assertExpectedAt: '#'
		selector: #servers
		in: self documentStructureSwagger2
		is: #( '#/servers/0' '#/servers/1' )
]

{ #category : 'tests' }
FamixOpenApiRelationSwagger2Test >> testTheUnresolvedReferencesAreComparedAsASetBecauseTheImporterMeetsTheDefinitionsBeforeThePaths [
	"VERIFIED by import: the importer keeps the unresolved references of the definitions, then the responses, before those of the paths (see the next test), the document lists the paths first: the same references in another order, not a gap"

	| comparison |
	self assertRelationFaithful: self documentUnresolvedSwagger2.
	comparison := self
		              comparisonAt: '#'
		              selector: #unresolvedReferences
		              in: self documentUnresolvedSwagger2.
	self assert: comparison rule compareMode equals: #set.
	self assert: comparison expected size equals: 6.
	self assert: comparison found asSet equals: comparison expected asSet.
	self deny: comparison found equals: comparison expected
]
