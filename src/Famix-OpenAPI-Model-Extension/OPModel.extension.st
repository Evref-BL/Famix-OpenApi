Extension { #name : 'OPModel' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addComponentSchemaNamed: aName types: anArray in: aModel to: aComponents [
	"Add and answer a reusable Schema declared under the components with the key aName."

	| schema |
	schema := (self
		           newSchemaIn: aModel
		           types: anArray
		           pointer: '#/components/schemas/' , aName)
		          name: aName;
		          yourself.
	aComponents addSchema: schema.
	^ schema
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addErrorResponsesTo: anOperation in: aModel components: aComponents [
	"Add the default Error Response of anOperation, an inline Response whose schema is the shared Error schema."

	| response |
	response := self
		            addResponseTo: anOperation
		            status: 'default'
		            description: 'Unexpected error.'
		            in: aModel.
	self
		addMediaTypeTo: response
		type: 'application/json'
		schema: (self entityNamed: 'Error' in: aComponents schemas)
		in: aModel
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addInlineParameterTo: aParameterOwner named: aName location: aLocation types: anArray in: aModel [
	"Add and answer a Parameter declared inline by aParameterOwner (a path or an operation)."

	| parameter |
	parameter := self
		             newParameterIn: aModel
		             named: aName
		             location: aLocation
		             types: anArray
		             pointer:
			             aParameterOwner canonicalPointer , '/parameters/'
			             , aParameterOwner parameters size printString.
	aParameterOwner addParameter: parameter.
	^ parameter
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addMediaTypeTo: aContentOwner type: aMediaType schema: aSchema in: aModel [
	"Add and answer a MediaType of aContentOwner (a response, request body or parameter) described by aSchema."

	| mediaType |
	mediaType := aModel newMediaType
		             mediaType: aMediaType;
		             name: aMediaType;
		             canonicalPointer:
			             aContentOwner canonicalPointer , '/content/'
			             , aMediaType;
		             schema: aSchema;
		             yourself.
	aContentOwner addContent: mediaType.
	^ mediaType
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addOperationTo: aPath method: anHttpMethod id: anOperationId summary: aString in: aModel [
	"Add and answer the operation of aPath for anHttpMethod."

	| operation |
	operation := (aModel newOperationNamed: anOperationId)
		             httpMethod: anHttpMethod;
		             operationId: anOperationId;
		             summary: aString;
		             canonicalPointer:
			             aPath canonicalPointer , '/' , anHttpMethod;
		             yourself.
	aPath addOperation: operation.
	^ operation
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addPathNamed: aRelativePath summary: aString to: anOpenApi in: aModel [
	"Add and answer the path item aRelativePath to the paths of anOpenApi."

	| path |
	path := (aModel newPathNamed: aRelativePath)
		        relativePath: aRelativePath;
		        summary: aString;
		        canonicalPointer:
			        '#/paths/' , (aRelativePath copyReplaceAll: '/' with: '~1');
		        yourself.
	anOpenApi addPath: path.
	^ path
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addPropertyNamed: aName types: anArray to: aSchema in: aModel [
	"Add and answer the Property aName of aSchema whose value is a new inline Schema of the given types."

	| pointer |
	pointer := aSchema canonicalPointer , '/properties/' , aName.
	^ self
		  addPropertyNamed: aName
		  valueSchema:
		  (self newSchemaIn: aModel types: anArray pointer: pointer)
		  to: aSchema
		  in: aModel
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addPropertyNamed: aName valueSchema: aValueSchema to: aSchema in: aModel [
	"Add and answer the Property aName of aSchema whose value is described by aValueSchema."

	| property |
	property := (aModel newPropertyNamed: aName)
		            canonicalPointer:
			            aSchema canonicalPointer , '/properties/' , aName;
		            valueSchema: aValueSchema;
		            yourself.
	aSchema addProperty: property.
	^ property
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> addResponseTo: anOperation status: aStatusCode description: aString in: aModel [
	"Add and answer the Response of anOperation for aStatusCode."

	| response |
	response := (aModel newResponseNamed: aStatusCode)
		            statusCode: aStatusCode;
		            description: aString;
		            canonicalPointer:
			            anOperation canonicalPointer , '/responses/'
			            , aStatusCode;
		            yourself.
	anOperation addResponse: response.
	^ response
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildAnimalSchemasIn: aModel for: aComponents [
	"Declare Cat, Dog, Animal (oneOf Cat and Dog, with a Discriminator and its mappings) and PetOrError (anyOf Pet and Error)."

	| cat dog animal discriminator |
	cat := self
		       addComponentSchemaNamed: 'Cat'
		       types: #( 'object' )
		       in: aModel
		       to: aComponents.
	self
		addPropertyNamed: 'huntingSkill'
		types: #( 'string' )
		to: cat
		in: aModel.
	dog := self
		       addComponentSchemaNamed: 'Dog'
		       types: #( 'object' )
		       in: aModel
		       to: aComponents.
	(self
		 addPropertyNamed: 'packSize'
		 types: #( 'integer' )
		 to: dog
		 in: aModel) valueSchema
		exclusiveMinimum: 0;
		exclusiveMaximum: 1000.
	animal := self
		          addComponentSchemaNamed: 'Animal'
		          types: #( 'object' )
		          in: aModel
		          to: aComponents.
	animal
		addOneOf: cat;
		addOneOf: dog.
	discriminator := aModel newDiscriminator
		                 propertyName: 'petType';
		                 canonicalPointer:
			                 '#/components/schemas/Animal/discriminator';
		                 yourself.
	discriminator
		addMapping: ((aModel newDiscriminatorMappingNamed: 'cat')
				 value: '#/components/schemas/Cat';
				 schema: cat;
				 canonicalPointer:
					 '#/components/schemas/Animal/discriminator/mapping/cat';
				 yourself);
		addMapping: ((aModel newDiscriminatorMappingNamed: 'dog')
				 value: '#/components/schemas/Dog';
				 schema: dog;
				 canonicalPointer:
					 '#/components/schemas/Animal/discriminator/mapping/dog';
				 yourself).
	animal discriminator: discriminator.
	(self
		 addComponentSchemaNamed: 'PetOrError'
		 types: #( 'object' )
		 in: aModel
		 to: aComponents)
		addAnyOf: (self entityNamed: 'Pet' in: aComponents schemas);
		addAnyOf: (self entityNamed: 'Error' in: aComponents schemas)
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildComponentsIn: aModel [
	"Answer the Components holding every reusable object of the Petstore except the security schemes and the links, added once the paths exist."

	| components |
	components := aModel newComponents
		              canonicalPointer: '#/components';
		              yourself.
	self buildSchemasIn: aModel for: components.
	self buildParametersIn: aModel for: components.
	self buildRequestBodiesIn: aModel for: components.
	self buildSharedResponsesIn: aModel for: components.
	self buildSharedHeadersIn: aModel for: components.
	self buildSharedExamplesIn: aModel for: components.
	self buildSharedCallbacksIn: aModel for: components.
	^ components
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildErrorSchemaIn: aModel for: aComponents [
	"Declare the Error schema with its required code and message."

	| error |
	error := self
		         addComponentSchemaNamed: 'Error'
		         types: #( 'object' )
		         in: aModel
		         to: aComponents.
	error requiredProperties: #( 'code' 'message' ).
	(self
		 addPropertyNamed: 'code'
		 types: #( 'integer' )
		 to: error
		 in: aModel) valueSchema format: 'int32'.
	self
		addPropertyNamed: 'message'
		types: #( 'string' )
		to: error
		in: aModel
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildInfoIn: aModel [
	"Answer the Info of the Petstore with its Contact and License."

	^ (aModel newInfoNamed: 'Small Petstore')
		  title: 'Small Petstore';
		  version: '1.0.0';
		  description:
			  'A small Petstore API that instantiates the main concepts of the canonical OpenAPI 3.1 metamodel.';
		  termsOfService: 'https://petstore.example.com/terms';
		  canonicalPointer: '#/info';
		  contact: ((aModel newContactNamed: 'API Support')
				   url: 'https://petstore.example.com/support';
				   email: 'support@petstore.example.com';
				   canonicalPointer: '#/info/contact';
				   yourself);
		  license: ((aModel newLicenseNamed: 'Apache 2.0')
				   url: 'https://www.apache.org/licenses/LICENSE-2.0.html';
				   canonicalPointer: '#/info/license';
				   yourself);
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildListPetsResponsesFor: anOperation in: aModel components: aComponents [
	"Add the 200 Response of listPets, with the Pets array and a pagination Header, and its default Error Response."

	| ok |
	ok := self
		      addResponseTo: anOperation
		      status: '200'
		      description: 'A page of pets.'
		      in: aModel.
	self
		addMediaTypeTo: ok
		type: 'application/json'
		schema: (self entityNamed: 'Pets' in: aComponents schemas)
		in: aModel.
	ok addHeader: (self
			 newHeaderIn: aModel
			 named: 'X-Next'
			 types: #( 'string' )
			 pointer: ok canonicalPointer , '/headers/X-Next').
	self
		addErrorResponsesTo: anOperation
		in: aModel
		components: aComponents
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildParametersIn: aModel for: aComponents [
	"Declare the reusable query Parameter limit."

	| limit |
	limit := self
		         newParameterIn: aModel
		         named: 'limit'
		         location: 'query'
		         types: #( 'integer' )
		         pointer: '#/components/parameters/limit'.
	limit description: 'Maximum number of items to return.'.
	limit schema
		format: 'int32';
		minimum: 1;
		maximum: 100.
	aComponents addParameter: limit
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildPathsIn: aModel for: anOpenApi [
	"Add the path items of the Petstore. The single pet path comes first because the other paths link to its operations."

	self buildPetByIdPathIn: aModel for: anOpenApi.
	self buildPetsPathIn: aModel for: anOpenApi.
	self buildSearchPathIn: aModel for: anOpenApi
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildPetByIdPathIn: aModel for: anOpenApi [
	"Add /pets/{petId}: a path-level parameter shared by the getPet and deletePet operations."

	| components path get delete ok json |
	components := anOpenApi components.
	path := self
		        addPathNamed: '/pets/{petId}'
		        summary: 'A single pet'
		        to: anOpenApi
		        in: aModel.
	self
		addInlineParameterTo: path
		named: 'petId'
		location: 'path'
		types: #( 'integer' )
		in: aModel.
	get := self
		       addOperationTo: path
		       method: 'get'
		       id: 'getPet'
		       summary: 'Info for a specific pet'
		       in: aModel.
	get tagNames: #( 'pets' ).
	ok := self
		      addResponseTo: get
		      status: '200'
		      description: 'The requested pet.'
		      in: aModel.
	json := self
		        addMediaTypeTo: ok
		        type: 'application/json'
		        schema:
		        (self entityNamed: 'Pet' in: components schemas)
		        in: aModel.
	json addExample: (self
			 newExternalExampleIn: aModel
			 pointer: json canonicalPointer , '/examples/RexExample').
	self addNotFoundResponseTo: get in: aModel components: components.
	self addErrorResponsesTo: get in: aModel components: components.
	delete := self
		          addOperationTo: path
		          method: 'delete'
		          id: 'deletePet'
		          summary: 'Delete a pet'
		          in: aModel.
	delete
		tagNames: #( 'pets' );
		deprecated: true.
	self
		addResponseTo: delete
		status: '204'
		description: 'The pet was deleted.'
		in: aModel.
	self addNotFoundResponseTo: delete in: aModel components: components.
	self addErrorResponsesTo: delete in: aModel components: components
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildPetSchemasIn: aModel for: aComponents [
	"Declare NewPet, PetStatus, Pet (allOf NewPet and an inline schema) and Pets (array of Pet)."

	| newPet status pet identifier |
	newPet := self
		          addComponentSchemaNamed: 'NewPet'
		          types: #( 'object' )
		          in: aModel
		          to: aComponents.
	newPet
		title: 'New pet';
		requiredProperties: #( 'name' );
		additionalPropertiesAllowed: false.
	(self
		 addPropertyNamed: 'name'
		 types: #( 'string' )
		 to: newPet
		 in: aModel) isRequired: true.
	(self
		 addPropertyNamed: 'tag'
		 types: #( 'string' 'null' )
		 to: newPet
		 in: aModel) valueSchema isNullable: true.
	status := self
		          addComponentSchemaNamed: 'PetStatus'
		          types: #( 'string' )
		          in: aModel
		          to: aComponents.
	status
		enumValues: '["available","pending","sold"]';
		defaultValue: '"available"'.
	pet := self
		       addComponentSchemaNamed: 'Pet'
		       types: #( 'object' )
		       in: aModel
		       to: aComponents.
	pet exampleValue:
		'{"id":1,"name":"Rex","tag":"dog","status":"available"}'.
	pet xml: ((aModel newXmlElementNamed: 'pet')
			 namespace: 'https://petstore.example.com/schema';
			 prefix: 'ps';
			 attribute: false;
			 wrapped: false;
			 canonicalPointer: '#/components/schemas/Pet/xml';
			 yourself).
	self
		addPropertyNamed: 'status'
		valueSchema: status
		to: pet
		in: aModel.
	identifier := self
		              newSchemaIn: aModel
		              types: #( 'object' )
		              pointer: '#/components/schemas/Pet/allOf/1'.
	(self
		 addPropertyNamed: 'id'
		 types: #( 'integer' )
		 to: identifier
		 in: aModel) valueSchema
		format: 'int64';
		readOnly: true.
	pet
		addAllOf: newPet;
		addAllOf: identifier.
	(self
		 addComponentSchemaNamed: 'Pets'
		 types: #( 'array' )
		 in: aModel
		 to: aComponents)
		items: pet;
		maxItems: 100
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildPetsPathIn: aModel for: anOpenApi [
	"Add /pets: listPets with the shared limit parameter and createPet with the shared request body and a callback."

	| components path list create created pet |
	components := anOpenApi components.
	pet := self entityNamed: 'Pet' in: components schemas.
	path := self
		        addPathNamed: '/pets'
		        summary: 'The collection of pets'
		        to: anOpenApi
		        in: aModel.
	list := self
		        addOperationTo: path
		        method: 'get'
		        id: 'listPets'
		        summary: 'List all pets'
		        in: aModel.
	list tagNames: #( 'pets' ).
	list addParameter:
		(self entityNamed: 'limit' in: components parameters).
	self
		buildListPetsResponsesFor: list
		in: aModel
		components: components.
	create := self
		          addOperationTo: path
		          method: 'post'
		          id: 'createPet'
		          summary: 'Create a pet'
		          in: aModel.
	create tagNames: #( 'pets' ).
	create requestBody:
		(self entityNamed: 'NewPetBody' in: components requestBodies).
	created := self
		           addResponseTo: create
		           status: '201'
		           description: 'The pet was created.'
		           in: aModel.
	self
		addMediaTypeTo: created
		type: 'application/json'
		schema: pet
		in: aModel.
	created addLink: (self
			 newLinkIn: aModel
			 named: 'GetPetById'
			 operation: (self operationNamed: 'getPet' in: anOpenApi)
			 pointer: created canonicalPointer , '/links/GetPetById').
	create addCallback: (self
			 newCallbackIn: aModel
			 named: 'onPetCreated'
			 pointer: create canonicalPointer , '/callbacks/onPetCreated').
	self addErrorResponsesTo: create in: aModel components: components
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildRequestBodiesIn: aModel for: aComponents [
	"Declare the reusable RequestBody NewPetBody with a JSON and a multipart MediaType, the latter with an Encoding."

	| body newPet multipart |
	body := (aModel newRequestBodyNamed: 'NewPetBody')
		        description: 'The pet to add to the store.';
		        required: true;
		        canonicalPointer: '#/components/requestBodies/NewPetBody';
		        yourself.
	aComponents addRequestBody: body.
	newPet := self entityNamed: 'NewPet' in: aComponents schemas.
	self
		addMediaTypeTo: body
		type: 'application/json'
		schema: newPet
		in: aModel.
	multipart := self
		             addMediaTypeTo: body
		             type: 'multipart/form-data'
		             schema: newPet
		             in: aModel.
	multipart addEncoding: ((aModel newEncodingNamed: 'tag')
			 propertyName: 'tag';
			 contentType: 'text/plain';
			 style: 'form';
			 explode: false;
			 allowReserved: false;
			 canonicalPointer: multipart canonicalPointer , '/encoding/tag';
			 addHeader: (self
					  newHeaderIn: aModel
					  named: 'X-Tag-Source'
					  types: #( 'string' )
					  pointer:
						  multipart canonicalPointer
						  , '/encoding/tag/headers/X-Tag-Source');
			 yourself)
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSchemasIn: aModel for: aComponents [
	"Declare the reusable Schemas of the Petstore."

	self buildPetSchemasIn: aModel for: aComponents.
	self buildSubSchemasIn: aModel for: aComponents.
	self buildErrorSchemaIn: aModel for: aComponents.
	self buildAnimalSchemasIn: aModel for: aComponents
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSearchPathIn: aModel for: anOpenApi [
	"Add /pets/search: searchPets reuses the limit parameter already used by listPets."

	| components path search |
	components := anOpenApi components.
	path := self
		        addPathNamed: '/pets/search'
		        summary: 'Search the pets'
		        to: anOpenApi
		        in: aModel.
	search := self
		          addOperationTo: path
		          method: 'get'
		          id: 'searchPets'
		          summary: 'Search pets by name'
		          in: aModel.
	search
		tagNames: #( 'pets' );
		securityDisabled: true.
	self
		addInlineParameterTo: search
		named: 'name'
		location: 'query'
		types: #( 'string' )
		in: aModel.
	search addParameter:
		(self entityNamed: 'limit' in: components parameters).
	self
		addMediaTypeTo: (self
				 addResponseTo: search
				 status: '200'
				 description: 'The matching pets.'
				 in: aModel)
		type: 'application/json'
		schema: (self entityNamed: 'Pets' in: components schemas)
		in: aModel.
	self addErrorResponsesTo: search in: aModel components: components
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSecurityIn: aModel for: anOpenApi [
	"Declare the apiKey and oauth2 SecuritySchemes. The document requires the apiKey. createPet requires the oauth2 scopes AND the apiKey, a single SecurityRequirement with two items. searchPets is public (securityDisabled)."

	| apiKey oauth2 createPet pointer |
	apiKey := self newApiKeySchemeIn: aModel.
	oauth2 := self newOAuth2SchemeIn: aModel.
	anOpenApi components
		addSecurityScheme: apiKey;
		addSecurityScheme: oauth2.
	anOpenApi addSecurityRequirement: (self
			 newSecurityRequirementIn: aModel
			 items: { (self
					  newSecurityRequirementItemIn: aModel
					  scheme: apiKey
					  scopeNames: #(  )
					  pointer: '#/security/0/api_key') }
			 pointer: '#/security/0').
	createPet := self operationNamed: 'createPet' in: anOpenApi.
	pointer := createPet canonicalPointer , '/security/0'.
	createPet addSecurityRequirement: (self
			 newSecurityRequirementIn: aModel
			 items: {
					 (self
						  newSecurityRequirementItemIn: aModel
						  scheme: oauth2
						  scopeNames:
						  (oauth2 flows first scopes collect: [ :each | each name ])
						  pointer: pointer , '/petstore_auth').
					 (self
						  newSecurityRequirementItemIn: aModel
						  scheme: apiKey
						  scopeNames: #(  )
						  pointer: pointer , '/api_key') }
			 pointer: pointer)
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildServersIn: aModel for: anOpenApi [
	"Add a templated Server with its ServerVariable."

	anOpenApi addServer: ((aModel newServerNamed: 'production')
			 url: 'https://{environment}.petstore.example.com/v1';
			 description:
				 'Petstore server selected by the environment variable';
			 canonicalPointer: '#/servers/0';
			 addVariable: ((aModel newServerVariableNamed: 'environment')
					  defaultValue: 'api';
					  enumValues: #( 'api' 'staging' );
					  description: 'Deployment environment';
					  canonicalPointer: '#/servers/0/variables/environment';
					  yourself);
			 yourself)
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSharedCallbacksIn: aModel for: aComponents [
	"Declare the reusable Callback PetEvent."

	aComponents addCallback: (self
			 newCallbackIn: aModel
			 named: 'PetEvent'
			 pointer: '#/components/callbacks/PetEvent')
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSharedExamplesIn: aModel for: aComponents [
	"Declare the reusable Example FluffyExample."

	aComponents addExample:
		((aModel newExampleNamed: 'FluffyExample')
			 summary: 'A fluffy cat';
			 value: '{"id":2,"name":"Fluffy","tag":"cat"}';
			 canonicalPointer: '#/components/examples/FluffyExample';
			 yourself)
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSharedHeadersIn: aModel for: aComponents [
	"Declare the reusable Header X-Rate-Limit. Its schema stands for an identical inline schema that the importer merged into it."

	| header |
	header := self
		          newHeaderIn: aModel
		          named: 'X-Rate-Limit'
		          types: #( 'integer' )
		          pointer: '#/components/headers/X-Rate-Limit'.
	header schema mergedPointers:
		#( '#/paths/~1pets~1search/get/responses/200/headers/X-Rate-Limit/schema' ).
	aComponents addHeader: header
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSharedLinksIn: aModel for: anOpenApi [
	"Declare the reusable Link GetPetByIdShared toward the getPet operation."

	anOpenApi components addLink: (self
			 newLinkIn: aModel
			 named: 'GetPetByIdShared'
			 operation: (self operationNamed: 'getPet' in: anOpenApi)
			 pointer: '#/components/links/GetPetByIdShared')
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSharedResponsesIn: aModel for: aComponents [
	"Declare the reusable Response NotFound, whose JSON content is an Error."

	| notFound |
	notFound := (aModel newResponseNamed: 'NotFound')
		            description: 'The entity was not found.';
		            canonicalPointer: '#/components/responses/NotFound';
		            yourself.
	aComponents addResponse: notFound.
	self
		addMediaTypeTo: notFound
		type: 'application/json'
		schema: (self entityNamed: 'Error' in: aComponents schemas)
		in: aModel
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSharedUsagesIn: aModel for: anOpenApi [
	"Reference the reusable Header, Example, Link, Callback and callback Path item from several places: each of them is then shared by two usages and keeps a single entity. Also add the 206 Response of searchPets, whose schema is the PetSummary SubSchema."

	| components list create get search rateLimit fluffy getPetById petEvent pathItem summaries |
	components := anOpenApi components.
	list := self operationNamed: 'listPets' in: anOpenApi.
	create := self operationNamed: 'createPet' in: anOpenApi.
	get := self operationNamed: 'getPet' in: anOpenApi.
	search := self operationNamed: 'searchPets' in: anOpenApi.
	rateLimit := self entityNamed: 'X-Rate-Limit' in: components headers.
	(self responseWithStatus: '200' of: list) addHeader: rateLimit.
	(self responseWithStatus: '200' of: search) addHeader: rateLimit.
	fluffy := self entityNamed: 'FluffyExample' in: components examples.
	(self responseWithStatus: '201' of: create) content anyOne
		addExample: fluffy.
	(self responseWithStatus: '200' of: get) content anyOne addExample:
		fluffy.
	getPetById := self
		              entityNamed: 'GetPetByIdShared'
		              in: components links.
	(self responseWithStatus: '200' of: list) addLink: getPetById.
	(self responseWithStatus: '201' of: create) addLink: getPetById.
	petEvent := self entityNamed: 'PetEvent' in: components callbacks.
	pathItem := create callbacks first pathItems first.
	create addCallback: petEvent.
	(self operationNamed: 'deletePet' in: anOpenApi) addCallback:
		petEvent.
	petEvent addPathItem: pathItem.
	summaries := self
		             addResponseTo: search
		             status: '206'
		             description: 'A summary of the matching pets.'
		             in: aModel.
	self
		addMediaTypeTo: summaries
		type: 'application/json'
		schema: (self entityNamed: 'PetSummary' in: components schemas)
		in: aModel
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildSubSchemasIn: aModel for: aComponents [
	"Declare PetSummary, a SubSchema of Pet: its id and name properties are properties of Pet (inherited through NewPet and the identifier schema) with equivalent value schemas."

	| summary |
	summary := aModel newSubSchema
		           types: #( 'object' );
		           name: 'PetSummary';
		           canonicalPointer: '#/components/schemas/PetSummary';
		           subSchemaOf:
			           (self entityNamed: 'Pet' in: aComponents schemas);
		           yourself.
	aComponents addSchema: summary.
	(self
		 addPropertyNamed: 'id'
		 types: #( 'integer' )
		 to: summary
		 in: aModel) valueSchema format: 'int64'.
	(self
		 addPropertyNamed: 'name'
		 types: #( 'string' )
		 to: summary
		 in: aModel) isRequired: true.
	^ summary
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildTagsIn: aModel for: anOpenApi [
	"Add two Tags, one of them with external documentation, and the external documentation of the document."

	anOpenApi
		addTag: ((aModel newTagNamed: 'pets')
				 description: 'Everything about the pets';
				 canonicalPointer: '#/tags/0';
				 externalDocs: (self
						  newExternalDocumentationIn: aModel
						  pointer: '#/tags/0/externalDocs');
				 yourself);
		addTag: ((aModel newTagNamed: 'store')
				 description: 'Access to the orders';
				 canonicalPointer: '#/tags/1';
				 yourself);
		externalDocs:
		(self newExternalDocumentationIn: aModel pointer: '#/externalDocs')
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildUnresolvedReferenceIn: aModel for: anOpenApi [
	"Add to anOpenApi a Reference standing for an external $ref that was not resolved. Its canonicalPointer is the one of the site where the $ref appeared."

	anOpenApi addUnresolvedReference:
		((aModel newReferenceNamed: 'Owner')
			 target: 'https://schemas.example.com/owner.json#/Owner';
			 summary: 'The owner of a pet';
			 description: 'External schema that the example does not resolve.';
			 canonicalPointer: '#/components/schemas/Pet/properties/owner';
			 yourself)
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> buildWebhooksIn: aModel for: anOpenApi [
	"Add the newPet webhook, a path item that is not reachable through the paths."

	| path operation |
	path := (aModel newPathNamed: 'newPet')
		        relativePath: 'newPet';
		        summary: 'A new pet is available';
		        canonicalPointer: '#/webhooks/newPet';
		        yourself.
	anOpenApi addWebhook: path.
	operation := self
		             addOperationTo: path
		             method: 'post'
		             id: 'newPetEvent'
		             summary: 'Receive a new pet'
		             in: aModel.
	operation requestBody: (self
			 entityNamed: 'NewPetBody'
			 in: anOpenApi components requestBodies).
	self
		addResponseTo: operation
		status: '200'
		description: 'The event was received.'
		in: aModel
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> entityNamed: aName in: aCollection [
	"Answer the entity of aCollection named aName."

	^ aCollection detect: [ :each | each name = aName ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> exampleMinimalApi [
	"Answer a new OPModel that holds the smallest useful API: one OpenApi with its Info, one Path, one Operation and one Response. Run it with:
		OPModel exampleMinimalApi inspect"

	<script: 'OPModel exampleMinimalApi inspect'>
	| model openApi operation |
	model := self new.
	openApi := (model newOpenApiNamed: 'Minimal API')
		           openapiVersion: '3.1.0';
		           canonicalPointer: '#';
		           info: ((model newInfoNamed: 'Minimal API')
				            title: 'Minimal API';
				            version: '1.0.0';
				            canonicalPointer: '#/info';
				            yourself);
		           yourself.
	operation := self
		             addOperationTo: (self
				              addPathNamed: '/ping'
				              summary: 'Liveness probe'
				              to: openApi
				              in: model)
		             method: 'get'
		             id: 'ping'
		             summary: 'Check that the service is alive'
		             in: model.
	self
		addResponseTo: operation
		status: '200'
		description: 'The service is alive.'
		in: model.
	^ model
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> exampleSmallPetstore [
	"Answer a new OPModel that holds a small Petstore-like API in the OpenAPI 3.1 shape and instantiates every main concept of the metamodel: OpenApi, Info (Contact, License), Server (ServerVariable), Tag, ExternalDocumentation, Components, Path (also as a webhook), Operation, Parameter (inline on a path, inline on an operation, reusable and shared by two operations), RequestBody, Response, MediaType, Encoding, Header, Example, Link, Callback, Schema and SubSchema (object, array, allOf, oneOf, anyOf, enumeration, nullable, readOnly, with an XmlElement and exclusive bounds), Property, Discriminator and its mappings, SecurityScheme (apiKey and oauth2 with OAuthFlow and SecurityScope), SecurityRequirement and an unresolved Reference attached to the root.

	Security: the document requires the apiKey scheme. createPet requires one SecurityRequirement with two SecurityRequirementItems (the oauth2 scopes AND the apiKey). searchPets is public: its securityDisabled is true.

	Shared responses: the reusable NotFound response is copied for each operation that uses it (the 404 of getPet and of deletePet): each copy owns its status code and its operation and keeps the ref of the original and gets its own canonicalPointer (its position under the operation).

	Shared references: the reusable Header X-Rate-Limit is used by two responses, the Example FluffyExample by two media types, the Link GetPetByIdShared by two responses, the Callback PetEvent by two operations and the Path item of the onPetCreated callback by two callbacks (a single entity each, reachable from every usage through the usedBy* relations). PetSummary is a SubSchema of Pet (subSchemaOf) used by the 206 response of searchPets, and the schema of X-Rate-Limit lists the pointer of an identical inline schema in its mergedPointers.
	The Pet schema is shared: it is the item of Pets, a member of PetOrError and the schema of three media types. Run it from a Playground, or from the class browser with the play button of this method:

		OPModel exampleSmallPetstore inspect"

	<script: 'OPModel exampleSmallPetstore inspect'>
	| model openApi |
	model := self new.
	openApi := (model newOpenApiNamed: 'Small Petstore')
		           openapiVersion: '3.1.0';
		           jsonSchemaDialect:
			           'https://json-schema.org/draft/2020-12/schema';
		           selfUrl: 'https://petstore.example.com/openapi.json';
		           canonicalPointer: '#';
		           info: (self buildInfoIn: model);
		           components: (self buildComponentsIn: model);
		           yourself.
	self buildTagsIn: model for: openApi.
	self buildServersIn: model for: openApi.
	self buildPathsIn: model for: openApi.
	self buildWebhooksIn: model for: openApi.
	self buildSharedLinksIn: model for: openApi.
	self buildSharedUsagesIn: model for: openApi.
	self buildSecurityIn: model for: openApi.
	self buildUnresolvedReferenceIn: model for: openApi.
	^ model
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newApiKeySchemeIn: aModel [
	"Answer the apiKey SecurityScheme api_key, read from a header."

	^ (aModel newSecuritySchemeNamed: 'api_key')
		  type: 'apiKey';
		  inLocation: 'header';
		  parameterName: 'X-API-Key';
		  description: 'An API key sent in a header.';
		  canonicalPointer: '#/components/securitySchemes/api_key';
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newCallbackIn: aModel named: aName pointer: aString [
	"Answer a Callback named aName whose path item has a POST operation."

	| callback expression path |
	expression := '{$request.body#/callbackUrl}'.
	callback := (aModel newCallbackNamed: aName)
		            canonicalPointer: aString;
		            yourself.
	path := (aModel newPathNamed: expression)
		        relativePath: expression;
		        canonicalPointer: aString , '/' , expression;
		        yourself.
	self
		addResponseTo: (self
				 addOperationTo: path
				 method: 'post'
				 id: aName , 'Notification'
				 summary: 'Notify the subscriber'
				 in: aModel)
		status: '200'
		description: 'The subscriber acknowledged the notification.'
		in: aModel.
	callback addPathItem: path.
	^ callback
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newExternalDocumentationIn: aModel pointer: aString [
	"Answer an ExternalDocumentation of the Petstore located at aString."

	^ aModel newExternalDocumentation
		  url: 'https://petstore.example.com/docs';
		  description: 'Find out more about the Petstore.';
		  canonicalPointer: aString;
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newExternalExampleIn: aModel pointer: aString [
	"Answer an Example whose value is stored outside of the document."

	^ (aModel newExampleNamed: 'RexExample')
		  summary: 'Rex, loaded from a file';
		  externalValue: 'https://petstore.example.com/examples/rex.json';
		  canonicalPointer: aString;
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newHeaderIn: aModel named: aName types: anArray pointer: aString [
	"Answer a Header named aName with an inline schema of the given types, located at aString."

	^ (aModel newHeaderNamed: aName)
		  description: 'The header ' , aName;
		  canonicalPointer: aString;
		  schema:
			  (self
				   newSchemaIn: aModel
				   types: anArray
				   pointer: aString , '/schema');
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newLinkIn: aModel named: aName operation: anOperation pointer: aString [
	"Answer a Link named aName toward anOperation, served by its own Server."

	^ (aModel newLinkNamed: aName)
		  operationId: anOperation operationId;
		  operation: anOperation;
		  requestBody: '$response.body#/id';
		  description: 'The pet created by this call can be fetched with '
			  , anOperation operationId;
		  canonicalPointer: aString;
		  server: ((aModel newServerNamed: 'links')
				   url: 'https://links.petstore.example.com';
				   canonicalPointer: aString , '/server';
				   yourself);
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newOAuth2SchemeIn: aModel [
	"Answer the oauth2 SecurityScheme petstore_auth with an implicit OAuthFlow and its SecurityScopes."

	| flow pointer |
	pointer := '#/components/securitySchemes/petstore_auth'.
	flow := (aModel newOAuthFlowNamed: 'implicit')
		        flowType: 'implicit';
		        authorizationUrl:
			        'https://petstore.example.com/oauth/authorize';
		        refreshUrl: 'https://petstore.example.com/oauth/refresh';
		        canonicalPointer: pointer , '/flows/implicit';
		        yourself.
	#( 'read:pets' 'write:pets' ) do: [ :scopeName |
		flow addScope: ((aModel newSecurityScopeNamed: scopeName)
				 description: 'Grants the scope ' , scopeName;
				 canonicalPointer: flow canonicalPointer , '/scopes/' , scopeName;
				 yourself) ].
	^ (aModel newSecuritySchemeNamed: 'petstore_auth')
		  type: 'oauth2';
		  description: 'OAuth2 authentication of the Petstore.';
		  canonicalPointer: pointer;
		  addFlow: flow;
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newParameterIn: aModel named: aName location: aLocation types: anArray pointer: aString [
	"Answer a Parameter named aName, located in aLocation (path, query, ...), with an inline schema of the given types."

	^ (aModel newParameterNamed: aName)
		  location: aLocation;
		  required: aLocation = 'path';
		  canonicalPointer: aString;
		  schema:
			  (self
				   newSchemaIn: aModel
				   types: anArray
				   pointer: aString , '/schema');
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newSchemaIn: aModel types: anArray pointer: aString [
	"Answer an inline Schema of the given JSON Schema types located at aString."

	^ aModel newSchema
		  types: anArray;
		  canonicalPointer: aString;
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newSecurityRequirementIn: aModel items: aCollection pointer: aString [
	"Answer a SecurityRequirement made of aCollection of SecurityRequirementItems, all of which must be satisfied together."

	| requirement |
	requirement := aModel newSecurityRequirement
		               canonicalPointer: aString;
		               yourself.
	aCollection do: [ :each | requirement addItem: each ].
	^ requirement
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> newSecurityRequirementItemIn: aModel scheme: aSecurityScheme scopeNames: aCollection pointer: aString [
	"Answer a SecurityRequirementItem that requires aSecurityScheme with the scopes named in aCollection."

	^ (aModel newSecurityRequirementItemNamed: aSecurityScheme name)
		  scheme: aSecurityScheme;
		  scopeNames: aCollection;
		  canonicalPointer: aString;
		  yourself
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> operationNamed: anOperationId in: anOpenApi [
	"Answer the operation of anOpenApi whose operationId is anOperationId."

	^ anOpenApi operations detect: [ :each |
		  each operationId = anOperationId ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPModel class >> responseWithStatus: aStatusCode of: anOperation [
	"Answer the Response of anOperation for aStatusCode."

	^ anOperation responses detect: [ :each |
		  each statusCode = aStatusCode ]
]
