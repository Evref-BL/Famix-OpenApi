Class {
	#name : 'FamixOpenApiGenerator',
	#superclass : 'FamixMetamodelGenerator',
	#instVars : [
		'entities',
		'traits'
	],
	#category : 'FamixOpenApiGenerator',
	#package : 'FamixOpenApiGenerator'
}

{ #category : 'accessing' }
FamixOpenApiGenerator class >> packageName [
    ^ #'Famix-OpenAPI-Model'
]

{ #category : 'accessing' }
FamixOpenApiGenerator class >> prefix [
    ^ #'OP'
]

{ #category : 'accessing' }
FamixOpenApiGenerator class >> submetamodels [ 
	^ { FamixMooseQueryGenerator . FamixGenerator }
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> attribute: aName in: aBehavior type: aTypeName comment: aString [
	"Define the attribute aName of type aTypeName on aBehavior (an entity or a trait) and document it."

	| property |
	property := aBehavior property: aName type: aTypeName.
	property comment: aString.
	^ property
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> canonicalEntityNames [
	"Names of the entities added for the canonical OpenAPI 3.1 shape."

	^ #( OpenApi Server ServerVariable Encoding Discriminator
	     DiscriminatorMapping OAuthFlow Reference ExternalDocumentation
	      )
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> canonicalNodeEntityNames [
	"Names of the original entities that also use the CanonicalNode trait. The entities that disappear in the next regeneration (Api, ExternalDocs, XMLElement, ItemsDefinition, ContainedCollections and the Entry wrappers) are left out."

	^ #( Components Info Contact License Path Operation Parameter
	     Schema Response Header Tag SecurityScheme Example RequestBody
	     MediaType Link Callback SecurityScope SecurityRequirement
	     Property RequiredSecurityScheme )
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalClasses [
	"Entities of the canonical OpenAPI 3.1 shape, added next to the original entities (the original ones are removed in a later regeneration)."

	self
		defineEntityNamed: #OpenApi
		comment:
		'An OpenAPI description document (OpenAPI Object), root of the canonical 3.1 shape. Swagger 2.0 and OpenAPI 3.0.x documents are normalised to this shape by the importer.'.
	self
		defineEntityNamed: #Server
		comment:
		'A server hosting the API (OpenAPI Server Object), declared at document, path item or operation level.'.
	self
		defineEntityNamed: #ServerVariable
		comment:
		'A variable substituted in the URL template of a Server (OpenAPI Server Variable Object). Its name is the variable name.'.
	self
		defineEntityNamed: #Encoding
		comment:
		'Serialization rules applied to one property of a media type schema (OpenAPI Encoding Object).'.
	self
		defineEntityNamed: #Discriminator
		comment:
		'Hint used to select, among oneOf/anyOf/allOf alternatives, the schema matching a payload (OpenAPI Discriminator Object).'.
	self
		defineEntityNamed: #DiscriminatorMapping
		comment:
		'One entry of the mapping of a Discriminator: a discriminating value (its name) bound to the schema it selects.'.
	self
		defineEntityNamed: #OAuthFlow
		comment:
		'One OAuth2 flow of a security scheme (OpenAPI OAuth Flow Object): implicit, password, clientCredentials or authorizationCode.'.
	self
		defineEntityNamed: #Reference
		comment:
		'Placeholder for a $ref that cannot be resolved to an entity of the model, for instance a reference to an external document (OpenAPI Reference Object).'.
	self
		defineEntityNamed: #ExternalDocumentation
		comment:
		'A reference to external documentation (OpenAPI External Documentation Object).'
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalComponentsRelations [
	"Reusable objects: each one is owned by the components and shared by reference. Each row is: provisional relation name, target entity, final relation name, description."

	| components |
	components := self entityNamed: #Components.
	#( #( #directSchemas #Schema 'schemas' 'reusable schemas' )
	   #( #directResponses #Response 'responses' 'reusable responses' )
	   #( #directParameters #Parameter 'parameters' 'reusable parameters' )
	   #( #directRequestBodies #RequestBody 'requestBodies'
	      'reusable request bodies' )
	   #( #directHeaders #Header 'headers' 'reusable headers' )
	   #( #directExamples #Example 'examples' 'reusable examples' )
	   #( #directLinks #Link 'links' 'reusable links' )
	   #( #directCallbacks #Callback 'callbacks' 'reusable callbacks' )
	   #( #directSecuritySchemes #SecurityScheme 'securitySchemes'
	      'reusable security schemes' ) ) do: [ :row |
		| target |
		target := self entityNamed: (row at: 2).
		((components property: (row at: 1)) comment:
			 ('Reference {1} from Components to {2} [0..*]: {4} (provisional name of {3}).'
				  format: {
						  (row at: 1).
						  (row at: 2).
						  (row at: 3).
						  (row at: 4) })) <>-* ((target property: #components) comment:
			 ('Opposite reference components from {1} to Components [0..1], when the object is a reusable one.'
				  format: { (row at: 2) })) ].
	((components property: #pathItems) comment:
		 'Reference pathItems from Components to Path [0..*]: reusable path items.')
	<>-* (((self entityNamed: #Path) property: #components) comment:
			 'Opposite reference components from Path to Components [0..1], when the path item is a reusable one.')
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalDocumentProperties [

	| openApi server variable encoding |
	openApi := self entityNamed: #OpenApi.
	self
		attribute: #sourceVersion
		in: openApi
		type: #String
		comment:
		'Version of the specification as read from the source document: 2.0, 3.0.x or 3.1.x [1].'.
	self
		attribute: #openapiVersion
		in: openApi
		type: #String
		comment: 'Value of the openapi field of the canonical document [1].'.
	self
		attribute: #jsonSchemaDialect
		in: openApi
		type: #String
		comment:
		'URI of the JSON Schema dialect used by the schemas of the document (jsonSchemaDialect field) [1].'.
	self
		attribute: #selfUrl
		in: openApi
		type: #String
		comment:
		'URI under which the document is available ($self field) [1].'.
	server := self entityNamed: #Server.
	self
		attribute: #url
		in: server
		type: #String
		comment: 'URL template of the server [1].'.
	self
		attribute: #description
		in: server
		type: #String
		comment: 'Description of the server [1].'.
	variable := self entityNamed: #ServerVariable.
	self
		attribute: #defaultValue
		in: variable
		type: #String
		comment: 'Value used when the variable is not provided [1].'.
	self
		attribute: #description
		in: variable
		type: #String
		comment: 'Description of the server variable [1].'.
	self
		stringCollection: #enumValues
		in: variable
		comment: 'Allowed values of the server variable [*] (strings).'.
	encoding := self entityNamed: #Encoding.
	self
		attribute: #propertyName
		in: encoding
		type: #String
		comment:
		'Name of the media type schema property this encoding applies to [1].'.
	self
		attribute: #contentType
		in: encoding
		type: #String
		comment: 'Content type(s) accepted for the property [1].'.
	self
		attribute: #style
		in: encoding
		type: #String
		comment: 'Serialization style of the property [1].'.
	self
		attribute: #explode
		in: encoding
		type: #Boolean
		comment:
		'Whether array and object values generate separate parameters [1].'.
	self
		attribute: #allowReserved
		in: encoding
		type: #Boolean
		comment: 'Whether reserved characters are left unescaped [1].'.
	self
		attribute: #description
		in: (self entityNamed: #ExternalDocumentation)
		type: #String
		comment: 'Description of the external documentation [1].'.
	self
		attribute: #url
		in: (self entityNamed: #ExternalDocumentation)
		type: #String
		comment: 'URL of the external documentation [1].'.
	self
		attribute: #target
		in: (self entityNamed: #Reference)
		type: #String
		comment: 'The $ref URI that could not be resolved [1].'.
	self
		attribute: #summary
		in: (self entityNamed: #Reference)
		type: #String
		comment: 'Summary overriding the one of the referenced object [1].'.
	self
		attribute: #description
		in: (self entityNamed: #Reference)
		type: #String
		comment:
		'Description overriding the one of the referenced object [1].'.
	self
		attribute: #summary
		in: (self entityNamed: #Example)
		type: #String
		comment: 'Short description of the example [1].'.
	self
		attribute: #externalValue
		in: (self entityNamed: #Example)
		type: #String
		comment: 'URL of a document holding the example value [1].'
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalDocumentRelations [

	| openApi |
	openApi := self entityNamed: #OpenApi.
	((openApi property: #info) comment:
		 'Reference info from OpenApi to Info [0..1]: metadata of the API.')
	<>- (((self entityNamed: #Info) property: #openApi) comment: 'Opposite reference openApi from Info to OpenApi [0..1].').
	((openApi property: #servers) comment:
		 'Reference servers from OpenApi to Server [0..*]: servers hosting the API.')
	<>-* (((self entityNamed: #Server) property: #openApi) comment:
			 'Opposite reference openApi from Server to OpenApi [0..1], when the server is declared at document level.').
	((openApi property: #paths) comment:
		 'Reference paths from OpenApi to Path [0..*]: the path items of the API.')
	<>-* (((self entityNamed: #Path) property: #openApi) comment:
			 'Opposite reference openApi from Path to OpenApi [0..1], when the path item is declared in paths.').
	((openApi property: #webhooks) comment:
		 'Reference webhooks from OpenApi to Path [0..*]: path items describing the requests the API may send (OpenAPI 3.1 webhooks).')
	<>-* (((self entityNamed: #Path) property: #webhookOf) comment:
			 'Opposite reference webhookOf from Path to OpenApi [0..1], when the path item is declared in webhooks.').
	((openApi property: #components) comment:
		 'Reference components from OpenApi to Components [0..1]: reusable objects of the API.')
	<>- (((self entityNamed: #Components) property: #openApi) comment:
			 'Opposite reference openApi from Components to OpenApi [0..1].').
	((openApi property: #tags) comment:
		 'Reference tags from OpenApi to Tag [0..*]: tags declared by the document.')
	<>-* (((self entityNamed: #Tag) property: #openApi) comment:
			 'Opposite reference openApi from Tag to OpenApi [0..1].').
	((openApi property: #securityRequirements) comment:
		 'Reference securityRequirements from OpenApi to SecurityRequirement [0..*]: security applied to every operation by default.')
	<>-* (((self entityNamed: #SecurityRequirement) property: #openApi)
			 comment:
			 'Opposite reference openApi from SecurityRequirement to OpenApi [0..1].').
	((openApi property: #externalDocs) comment:
		 'Reference externalDocs from OpenApi to ExternalDocumentation [0..1].')
	<>- (((self entityNamed: #ExternalDocumentation) property: #openApi) comment: 'Opposite reference openApi from ExternalDocumentation to OpenApi [0..1].').
	(((self entityNamed: #Server) property: #variables) comment:
		 'Reference variables from Server to ServerVariable [0..*]: substitutions of the URL template.')
	<>-*
		(((self entityNamed: #ServerVariable) property: #server) comment:
			 'Opposite reference server from ServerVariable to Server [0..1].').
	(((self entityNamed: #Path) property: #servers) comment:
		 'Reference servers from Path to Server [0..*]: servers overriding the document ones for this path item.')
	<>-* (((self entityNamed: #Server) property: #path) comment:
			 'Opposite reference path from Server to Path [0..1], when the server is declared by a path item.').
	(((self entityNamed: #Operation) property: #servers) comment:
		 'Reference servers from Operation to Server [0..*]: servers overriding the ones of the path item for this operation.')
	<>-* (((self entityNamed: #Server) property: #operation) comment:
			 'Opposite reference operation from Server to Operation [0..1], when the server is declared by an operation.').
	(((self entityNamed: #Link) property: #server) comment:
		 'Reference server from Link to Server [0..1]: server used by the linked operation.')
	<>- (((self entityNamed: #Server) property: #link) comment:
			 'Opposite reference link from Server to Link [0..1], when the server is declared by a link.').
	(((self traitNamed: #ExternalDocsContainer) property:
		  #externalDocumentation) comment:
		 'Reference externalDocumentation from ExternalDocsContainer to ExternalDocumentation [0..1]: provisional name of externalDocs.')
	<>- (((self entityNamed: #ExternalDocumentation) property: #externalDocsContainer) comment: 'Opposite reference externalDocsContainer from ExternalDocumentation to ExternalDocsContainer [0..1]: the operation, schema or tag that declares the documentation.')
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalHierarchy [

	self canonicalEntityNames , self canonicalNodeEntityNames do: [
		:entityName |
		(self entityNamed: entityName)
		--|> (self traitNamed: #CanonicalNode) ].
	self canonicalEntityNames do: [ :entityName |
		(self entityNamed: entityName) --|> #TNamedEntity.
		(self entityNamed: entityName) --|> (self traitNamed: #SourceText) ].
	"Parameters may carry their payload description in a content map, like request bodies and responses."
	(self entityNamed: #Parameter)
	--|> (self traitNamed: #ContentContainer)
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalNodeProperties [

	self
		attribute: #canonicalPointer
		in: (self traitNamed: #CanonicalNode)
		type: #String
		comment:
		'JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].'.
	self
		attribute: #extensions
		in: (self traitNamed: #CanonicalNode)
		type: #String
		comment:
		'Specification extensions (x-* keys) of the source node, as a JSON object text [1].'
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalOperationProperties [

	| parameter header |
	self
		attribute: #statusCode
		in: (self entityNamed: #Response)
		type: #String
		comment:
		'HTTP status code of the response, a range or default: 200, 2XX or default [1].'.
	self
		attribute: #mediaType
		in: (self entityNamed: #MediaType)
		type: #String
		comment:
		'Media type (MIME type) described, for example application/json [1].'.
	self
		stringCollection: #tagNames
		in: (self entityNamed: #Operation)
		comment:
		'Names of the tags of the operation as written in the source [*] (strings). Use #tags to get the Tag entities.'.
	parameter := self entityNamed: #Parameter.
	self
		attribute: #style
		in: parameter
		type: #String
		comment: 'Serialization style of the parameter value [1].'.
	self
		attribute: #explode
		in: parameter
		type: #Boolean
		comment:
		'Whether array and object values generate separate parameters [1].'.
	self
		attribute: #allowReserved
		in: parameter
		type: #Boolean
		comment:
		'Whether reserved characters are left unescaped in the value [1].'.
	self
		attribute: #deprecated
		in: parameter
		type: #Boolean
		comment: 'Whether the parameter is deprecated [1].'.
	header := self entityNamed: #Header.
	self
		attribute: #required
		in: header
		type: #Boolean
		comment: 'Whether the header is mandatory [1].'.
	self
		attribute: #deprecated
		in: header
		type: #Boolean
		comment: 'Whether the header is deprecated [1].'.
	self
		attribute: #style
		in: header
		type: #String
		comment: 'Serialization style of the header value [1].'.
	self
		attribute: #explode
		in: header
		type: #Boolean
		comment: 'Whether array and object values are exploded [1].'
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalOperationRelations [

	| operation response mediaType callback |
	operation := self entityNamed: #Operation.
	response := self entityNamed: #Response.
	mediaType := self entityNamed: #MediaType.
	callback := self entityNamed: #Callback.
	((operation property: #directResponses) comment:
		 'Reference directResponses from Operation to Response [0..*]: responses by status code (provisional name of responses).')
	<>-* ((response property: #operation) comment:
			 'Opposite reference operation from Response to Operation [0..1], when the response is declared inline by an operation.').
	((operation property: #directCallbacks) comment:
		 'Reference directCallbacks from Operation to Callback [0..*]: callbacks the operation may trigger (provisional name of callbacks).')
	<>-* ((callback property: #operation) comment:
			 'Opposite reference operation from Callback to Operation [0..1], when the callback is declared inline by an operation.').
	((operation property: #securityRequirements) comment:
		 'Reference securityRequirements from Operation to SecurityRequirement [0..*]: security of the operation, overriding the document one.')
	<>-*
		(((self entityNamed: #SecurityRequirement) property: #operation)
			 comment:
			 'Opposite reference operation from SecurityRequirement to Operation [0..1].').
	(((self traitNamed: #ContentContainer) property: #directContent)
		 comment:
		 'Reference directContent from ContentContainer to MediaType [0..*]: payload descriptions by media type (provisional name of content).')
	<>-* ((mediaType property: #contentOwner) comment:
			 'Opposite reference contentOwner from MediaType to ContentContainer [0..1]: the response, request body or parameter that declares the media type.').
	((mediaType property: #encodings) comment:
		 'Reference encodings from MediaType to Encoding [0..*]: serialization rules of the schema properties.')
	<>-* (((self entityNamed: #Encoding) property: #mediaType) comment:
			 'Opposite reference mediaType from Encoding to MediaType [0..1].').
	((mediaType property: #directExamples) comment:
		 'Reference directExamples from MediaType to Example [0..*]: examples of the media type (provisional name of examples).')
	<>-* (((self entityNamed: #Example) property: #mediaType) comment:
			 'Opposite reference mediaType from Example to MediaType [0..1].').
	(((self entityNamed: #Parameter) property: #examples) comment:
		 'Reference examples from Parameter to Example [0..*].')
	<>-* (((self entityNamed: #Example) property: #parameter) comment:
			 'Opposite reference parameter from Example to Parameter [0..1].').
	(((self entityNamed: #Encoding) property: #headers) comment:
		 'Reference headers from Encoding to Header [0..*]: headers sent with the encoded part.')
	<>-* (((self entityNamed: #Header) property: #encoding) comment:
			 'Opposite reference encoding from Header to Encoding [0..1].').
	((response property: #links) comment:
		 'Reference links from Response to Link [0..*]: operations that can be followed from the response.')
	<>-* (((self entityNamed: #Link) property: #response) comment:
			 'Opposite reference response from Link to Response [0..1].').
	(((self entityNamed: #Link) property: #operation) comment:
		 'Reference operation from Link to Operation [0..1]: the linked operation (operationId or operationRef resolved).')
	*- (((self entityNamed: #Operation) property: #usedByLinks) comment:
			 'Links targeting this Operation [0..*].').
	(((callback property: #pathItems) comment: 'Reference pathItems from Callback to Path [0..*]: path items describing the requests sent to the callback URL expressions.') <>-* (((self entityNamed: #Path) property: #callback) comment: 'Opposite reference callback from Path to Callback [0..1], when the path item is declared by a callback.'))
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalProperties [
	"Attributes of the canonical OpenAPI 3.1 shape: on the new entities and on the original entities that are kept."

	self defineCanonicalNodeProperties.
	self defineCanonicalDocumentProperties.
	self defineCanonicalOperationProperties.
	self defineCanonicalSchemaProperties.
	self defineCanonicalSecurityProperties
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalRelations [
	"Relations of the canonical OpenAPI 3.1 shape. Containment relations (<>-, <>-*) have a single owner, either the components or the inline declaration; references shared by several owners are many-to-one (*-) or many-to-many (*-*). A relation whose final name is already used by an original relation toward an Entry wrapper has a provisional name prefixed with direct (or the one given in #provisionalRelationNames); the next regeneration deletes the original relation and renames the new one."

	self defineCanonicalDocumentRelations.
	self defineCanonicalComponentsRelations.
	self defineCanonicalOperationRelations.
	self defineCanonicalSchemaRelations.
	self defineCanonicalSecurityRelations
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalSchemaProperties [

	| schema |
	schema := self entityNamed: #Schema.
	self
		stringCollection: #types
		in: schema
		comment:
		'JSON Schema types of the schema [*] (strings such as string, integer, null); several values for a 3.1 type array.'.
	self
		attribute: #isNullable
		in: schema
		type: #Boolean
		comment:
		'Whether null is an accepted value (nullable in 3.0, null among the types in 3.1) [1].'.
	self
		attribute: #enumValues
		in: schema
		type: #String
		comment: 'Allowed values of the schema, as a JSON array text [1].'.
	self
		attribute: #constValue
		in: schema
		type: #String
		comment:
		'The only allowed value of the schema (const), as JSON text [1].'.
	self
		attribute: #defaultValue
		in: schema
		type: #String
		comment: 'Default value of the schema, as JSON text [1].'.
	self
		attribute: #exampleValue
		in: schema
		type: #String
		comment: 'Example value of the schema, as JSON text [1].'.
	self
		attribute: #deprecated
		in: schema
		type: #Boolean
		comment: 'Whether the schema is deprecated [1].'.
	self
		attribute: #writeOnly
		in: schema
		type: #Boolean
		comment:
		'Whether the value is only sent to the server, never returned [1].'.
	self
		stringCollection: #requiredProperties
		in: schema
		comment:
		'Names of the properties that are mandatory in an instance of the schema [*] (strings).'.
	self
		attribute: #value
		in: (self entityNamed: #DiscriminatorMapping)
		type: #String
		comment:
		'Name or reference of the schema selected by the discriminating value, as written in the source [1].'.
	self
		attribute: #propertyName
		in: (self entityNamed: #Discriminator)
		type: #String
		comment:
		'Name of the property whose value discriminates the schemas [1].'.
	self
		attribute: #isRequired
		in: (self entityNamed: #Property)
		type: #Boolean
		comment:
		'Whether the property is listed as required by its declaring schema [1].'
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalSchemaRelations [

	| schema |
	schema := self entityNamed: #Schema.
	((schema property: #oneOf) comment:
		 'Reference oneOf from Schema to Schema [0..*]: alternatives of which exactly one must match.')
	*-* ((schema property: #usedAsOneOfBy) comment:
			 'Schemas having this Schema in their oneOf [0..*].').
	((schema property: #anyOf) comment:
		 'Reference anyOf from Schema to Schema [0..*]: alternatives of which at least one must match.')
	*-* ((schema property: #usedAsAnyOfBy) comment:
			 'Schemas having this Schema in their anyOf [0..*].').
	((schema property: #not) comment:
		 'Reference not from Schema to Schema [0..1]: schema that must not match.')
	*- ((schema property: #usedAsNotBy) comment:
			 'Schemas having this Schema as their not [0..*].').
	((schema property: #prefixItems) comment:
		 'Reference prefixItems from Schema to Schema [0..*]: schemas of the first array items, in order.')
	*-* ((schema property: #usedAsPrefixItemsBy) comment:
			 'Schemas having this Schema in their prefixItems [0..*].').
	((schema property: #discriminatorEntity) comment:
		 'Reference discriminatorEntity from Schema to Discriminator [0..1].')
	<>- (((self entityNamed: #Discriminator) property: #schema) comment:
			 'Opposite reference schema from Discriminator to Schema [0..1].').
	(((self entityNamed: #Discriminator) property: #mapping) comment:
		 'Reference mapping from Discriminator to DiscriminatorMapping [0..*].')
	<>-*
		(((self entityNamed: #DiscriminatorMapping) property: #discriminator)
			 comment:
			 'Opposite reference discriminator from DiscriminatorMapping to Discriminator [0..1].').
	(((self entityNamed: #DiscriminatorMapping) property: #schema)
		 comment:
		 'Reference schema from DiscriminatorMapping to Schema [0..1]: the selected schema.')
	*- ((schema property: #usedByDiscriminatorMappings) comment:
			 'Discriminator mappings selecting this Schema [0..*].').
	(((self entityNamed: #Property) property: #valueSchema) comment:
		 'Reference valueSchema from Property to Schema [0..1]: schema of the property value.')
	*- ((schema property: #usedAsPropertyValueBy) comment:
			 'Properties whose value schema is this Schema [0..*].')
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalSecurityProperties [

	| flow scheme |
	flow := self entityNamed: #OAuthFlow.
	self
		attribute: #flowType
		in: flow
		type: #String
		comment:
		'Kind of flow: implicit, password, clientCredentials or authorizationCode [1].'.
	self
		attribute: #authorizationUrl
		in: flow
		type: #String
		comment: 'Authorization URL of the flow [1].'.
	self
		attribute: #tokenUrl
		in: flow
		type: #String
		comment: 'Token URL of the flow [1].'.
	self
		attribute: #refreshUrl
		in: flow
		type: #String
		comment: 'URL used to obtain refresh tokens [1].'.
	scheme := self entityNamed: #SecurityScheme.
	self
		attribute: #inLocation
		in: scheme
		type: #String
		comment:
		'Location of an apiKey credential: query, header or cookie (the in field) [1].'.
	self
		attribute: #parameterName
		in: scheme
		type: #String
		comment:
		'Name of the header, query or cookie parameter carrying an apiKey credential (the name field) [1].'
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalSecurityRelations [

	(((self entityNamed: #SecurityScheme) property: #flows) comment:
		 'Reference flows from SecurityScheme to OAuthFlow [0..*]: OAuth2 flows supported by the scheme.')
	<>-*
		(((self entityNamed: #OAuthFlow) property: #securityScheme)
			 comment:
			 'Opposite reference securityScheme from OAuthFlow to SecurityScheme [0..1].').
	(((self entityNamed: #OAuthFlow) property: #scopes) comment:
		 'Reference scopes from OAuthFlow to SecurityScope [0..*]: scopes of the flow with their description.')
	<>-*
		(((self entityNamed: #SecurityScope) property: #oauthFlow) comment:
			 'Opposite reference oauthFlow from SecurityScope to OAuthFlow [0..1].')
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> defineCanonicalTraits [
	"Trait of the canonical OpenAPI 3.1 shape."

	self
		defineTraitNamed: #CanonicalNode
		comment:
		'Common part of the entities of the canonical OpenAPI 3.1 shape: the JSON pointer of the entity in the canonical document and its specification extensions (x-* keys).'
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineClasses [
    super defineClasses.
    entities := Dictionary new.
    self defineEntityNamed: #ContainedCollections.
    self defineEntityNamed: #Api.
    self defineEntityNamed: #Components.
    self defineEntityNamed: #Info.
    self defineEntityNamed: #Contact.
    self defineEntityNamed: #License.
    self defineEntityNamed: #Path.
    self defineEntityNamed: #Operation.
    self defineEntityNamed: #ExternalDocs.
    self defineEntityNamed: #Parameter.
    self defineEntityNamed: #ItemsDefinition.
    self defineEntityNamed: #Schema.
    self defineEntityNamed: #Response.
    self defineEntityNamed: #Header.
    self defineEntityNamed: #Tag.
    self defineEntityNamed: #SecurityScheme.
    self defineEntityNamed: #Example.
    self defineEntityNamed: #RequestBody.
    self defineEntityNamed: #MediaType.
    self defineEntityNamed: #Link.
    self defineEntityNamed: #Callback.
    self defineEntityNamed: #XMLElement.
    self defineEntityNamed: #SecurityScope.
    self defineEntityNamed: #SecurityRequirement.
    self defineEntityNamed: #Property.
    self defineEntityNamed: #ResponseEntry.
    self defineEntityNamed: #SchemaEntry.
    self defineEntityNamed: #ResponseDefinitionEntry.
    self defineEntityNamed: #ParameterEntry.
    self defineEntityNamed: #SecuritySchemeEntry.
    self defineEntityNamed: #MediaTypeEntry.
    self defineEntityNamed: #RequestBodyEntry.
    self defineEntityNamed: #HeaderEntry.
    self defineEntityNamed: #ExampleEntry.
    self defineEntityNamed: #LinkEntry.
    self defineEntityNamed: #CallbackEntry.
    self defineEntityNamed: #RequiredSecurityScheme.
	self defineCanonicalClasses
]

{ #category : 'private' }
FamixOpenApiGenerator >> defineEntityNamed: aSymbol [
    entities at: aSymbol put: (builder newClassNamed: aSymbol comment: 'Generated from openapi2.ecore')
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> defineEntityNamed: aSymbol comment: aString [

	entities
		at: aSymbol
		put: (builder newClassNamed: aSymbol comment: aString)
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineHierarchy [
    super defineHierarchy.
    #(
        ContainedCollections Api Components Info Contact License Path Operation
        ExternalDocs Parameter ItemsDefinition Schema Response Header Tag
        SecurityScheme Example RequestBody MediaType Link Callback XMLElement
        SecurityScope SecurityRequirement Property ResponseEntry SchemaEntry
        ResponseDefinitionEntry ParameterEntry SecuritySchemeEntry MediaTypeEntry
        RequestBodyEntry HeaderEntry ExampleEntry LinkEntry CallbackEntry
        RequiredSecurityScheme)
        do: [ :entityName | (self entityNamed: entityName) --|> #TNamedEntity ].
    #(
        ContainedCollections Api Components Info Contact License Path Operation
        ExternalDocs Parameter ItemsDefinition Schema Response Header Tag
        SecurityScheme Example RequestBody MediaType Link Callback XMLElement
        SecurityScope SecurityRequirement Property ResponseEntry SchemaEntry
        ResponseDefinitionEntry ParameterEntry SecuritySchemeEntry MediaTypeEntry
        RequestBodyEntry HeaderEntry ExampleEntry LinkEntry CallbackEntry
        RequiredSecurityScheme)
        do: [ :entityName | (self entityNamed: entityName) --|> (self traitNamed: #SourceText) ].
    (self entityNamed: #Api) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Api) --|> (self traitNamed: #SecurityContainer).
    (self entityNamed: #Path) --|> (self traitNamed: #ParameterContainer).
    (self entityNamed: #Path) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Operation) --|> (self traitNamed: #ParameterContainer).
    (self entityNamed: #Operation) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Operation) --|> (self traitNamed: #SecurityContainer).
    (self entityNamed: #Operation) --|> (self traitNamed: #ResponseContainer).
    (self entityNamed: #RequestBody) --|> (self traitNamed: #ContentContainer).
    (self entityNamed: #RequestBody) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Parameter) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #Parameter) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #Parameter) --|> (self traitNamed: #ArrayContainer).
    (self entityNamed: #Parameter) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #ItemsDefinition) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #ItemsDefinition) --|> (self traitNamed: #ArrayContainer).
    (self entityNamed: #Schema) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #Schema) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #Schema) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Schema) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Response) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #Response) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Response) --|> (self traitNamed: #ContentContainer).
    (self entityNamed: #Header) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #Header) --|> (self traitNamed: #ArrayContainer).
    (self entityNamed: #Header) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Tag) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Example) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Link) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Callback) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #SecurityScheme) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Property) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #SchemaEntry) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #ResponseDefinitionEntry) --|> (self traitNamed: #ResponseContainer).
    (self entityNamed: #ParameterEntry) --|> (self traitNamed: #ParameterContainer).
	self defineCanonicalHierarchy
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineProperties [
    super defineProperties.
    (((self traitNamed: #JSONSchemaSubset) property: #type type: #String) comment: 'Attribute type from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #format type: #String) comment: 'Attribute format from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #description type: #String) comment: 'Attribute description from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #maximum type: #Number) comment: 'Attribute maximum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #exclusiveMaximum type: #Boolean) comment: 'Attribute exclusiveMaximum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #minimum type: #Number) comment: 'Attribute minimum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #exclusiveMinimum type: #Boolean) comment: 'Attribute exclusiveMinimum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #maxLength type: #Number) comment: 'Attribute maxLength from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #minLength type: #Number) comment: 'Attribute minLength from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #pattern type: #String) comment: 'Attribute pattern from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #maxItems type: #Number) comment: 'Attribute maxItems from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #minItems type: #Number) comment: 'Attribute minItems from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #uniqueItems type: #Boolean) comment: 'Attribute uniqueItems from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #enum type: #Object) comment: 'Attribute enum from JSONSchemaSubset [*]').
    (((self traitNamed: #JSONSchemaSubset) property: #default type: #String) comment: 'Attribute default from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #multipleOf type: #Number) comment: 'Attribute multipleOf from JSONSchemaSubset [1]').
    (((self entityNamed: #Api) property: #openapi type: #String) comment: 'Attribute openapi from API [1]').
    (((self entityNamed: #Api) property: #host type: #String) comment: 'Attribute host from API [1]').
    (((self entityNamed: #Api) property: #basePath type: #String) comment: 'Attribute basePath from API [1]').
    (((self entityNamed: #Api) property: #schemes type: #Object) comment: 'Attribute schemes from API [*]').
    (((self entityNamed: #Api) property: #consumes type: #Object) comment: 'Attribute consumes from API [*]').
    (((self entityNamed: #Api) property: #produces type: #Object) comment: 'Attribute produces from API [*]').
    (((self entityNamed: #Info) property: #title type: #String) comment: 'Attribute title from Info [1]').
    (((self entityNamed: #Info) property: #description type: #String) comment: 'Attribute description from Info [1]').
    (((self entityNamed: #Info) property: #termsOfService type: #String) comment: 'Attribute termsOfService from Info [1]').
    (((self entityNamed: #Info) property: #version type: #String) comment: 'Attribute version from Info [1]').
    (((self entityNamed: #Contact) property: #url type: #String) comment: 'Attribute url from Contact [1]').
    (((self entityNamed: #Contact) property: #email type: #String) comment: 'Attribute email from Contact [1]').
    (((self entityNamed: #License) property: #url type: #String) comment: 'Attribute url from License [1]').
    (((self entityNamed: #Path) property: #relativePath type: #String) comment: 'Attribute relativePath from Path [1]').
    (((self entityNamed: #Path) property: #summary type: #String) comment: 'Attribute summary from Path [1]').
    (((self entityNamed: #Path) property: #description type: #String) comment: 'Attribute description from Path [1]').
    (((self entityNamed: #Operation) property: #tagReferences type: #Object) comment: 'Attribute tagReferences from Operation [*]').
    (((self entityNamed: #Operation) property: #summary type: #String) comment: 'Attribute summary from Operation [1]').
    (((self entityNamed: #Operation) property: #description type: #String) comment: 'Attribute description from Operation [1]').
    (((self entityNamed: #Operation) property: #httpMethod type: #String) comment: 'Attribute httpMethod from Operation [1]: lowercase HTTP verb (get, put, post, delete, options, head, patch, trace).').
    (((self entityNamed: #Operation) property: #operationId type: #String) comment: 'Attribute operationId from Operation [1]').
    (((self entityNamed: #Operation) property: #consumes type: #Object) comment: 'Attribute consumes from Operation [*]').
    (((self entityNamed: #Operation) property: #produces type: #Object) comment: 'Attribute produces from Operation [*]').
    (((self entityNamed: #Operation) property: #schemes type: #Object) comment: 'Attribute schemes from Operation [*]').
    (((self entityNamed: #Operation) property: #deprecated type: #Boolean) comment: 'Attribute deprecated from Operation [1]').
    (((self entityNamed: #ExternalDocs) property: #description type: #String) comment: 'Attribute description from ExternalDocs [1]').
    (((self entityNamed: #ExternalDocs) property: #url type: #String) comment: 'Attribute url from ExternalDocs [1]').
    (((self entityNamed: #Parameter) property: #location type: #String) comment: 'Attribute location from Parameter [1]').
    (((self entityNamed: #Parameter) property: #required type: #Boolean) comment: 'Attribute required from Parameter [1]').
    (((self entityNamed: #Parameter) property: #allowEmptyValue type: #Boolean) comment: 'Attribute allowEmptyValue from Parameter [1]').
    (((self entityNamed: #Parameter) property: #example type: #String) comment: 'Attribute example from Parameter [1]').
    (((self entityNamed: #Schema) property: #title type: #String) comment: 'Attribute title from Schema [1]').
    (((self entityNamed: #Schema) property: #maxProperties type: #Number) comment: 'Attribute maxProperties from Schema [1]').
    (((self entityNamed: #Schema) property: #minProperties type: #Number) comment: 'Attribute minProperties from Schema [1]').
    (((self entityNamed: #Schema) property: #example type: #String) comment: 'Attribute example from Schema [1]').
    (((self entityNamed: #Schema) property: #discriminator type: #String) comment: 'Attribute discriminator from Schema [1]').
    (((self entityNamed: #Schema) property: #readOnly type: #Boolean) comment: 'Attribute readOnly from Schema [1]').
    (((self entityNamed: #Schema) property: #additionalPropertiesAllowed type: #Boolean) comment: 'Attribute additionalPropertiesAllowed from Schema [1]').
    (((self entityNamed: #Response) property: #description type: #String) comment: 'Attribute description from Response [1]').
    (((self entityNamed: #Tag) property: #description type: #String) comment: 'Attribute description from Tag [1]').
    (((self entityNamed: #SecurityScheme) property: #type type: #String) comment: 'Attribute type from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #description type: #String) comment: 'Attribute description from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #location type: #String) comment: 'Attribute location from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #scheme type: #String) comment: 'Attribute scheme from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #bearerFormat type: #String) comment: 'Attribute bearerFormat from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #openIdConnectUrl type: #String) comment: 'Attribute openIdConnectUrl from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #flow type: #String) comment: 'Attribute flow from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #authorizationUrl type: #String) comment: 'Attribute authorizationUrl from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #tokenUrl type: #String) comment: 'Attribute tokenUrl from SecurityScheme [1]').
    (((self entityNamed: #Example) property: #mimeType type: #String) comment: 'Attribute mimeType from Example [1]').
    (((self entityNamed: #Example) property: #value type: #String) comment: 'Attribute value from Example [1]').
    (((self entityNamed: #RequestBody) property: #description type: #String) comment: 'Attribute description from RequestBody [1]').
    (((self entityNamed: #RequestBody) property: #required type: #Boolean) comment: 'Attribute required from RequestBody [1]').
    (((self entityNamed: #MediaType) property: #example type: #Object) comment: 'Attribute example from MediaType [1]').
    (((self entityNamed: #Link) property: #operationRef type: #String) comment: 'Attribute operationRef from Link [1]').
    (((self entityNamed: #Link) property: #operationId type: #String) comment: 'Attribute operationId from Link [1]').
    (((self entityNamed: #Link) property: #requestBody type: #String) comment: 'Attribute requestBody from Link [1]').
    (((self entityNamed: #Link) property: #description type: #String) comment: 'Attribute description from Link [1]').
    (((self entityNamed: #XMLElement) property: #namespace type: #String) comment: 'Attribute namespace from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #prefix type: #String) comment: 'Attribute prefix from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #attribute type: #Boolean) comment: 'Attribute attribute from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #wrapped type: #Boolean) comment: 'Attribute wrapped from XMLElement [1]').
    (((self entityNamed: #SecurityScope) property: #description type: #String) comment: 'Attribute description from SecurityScope [1]').
    (((self traitNamed: #ArrayContainer) property: #collectionFormat type: #String) comment: 'Attribute collectionFormat from ArrayContainer [1]').
    (((self traitNamed: #Referenceable) property: #ref type: #String) comment: 'Attribute ref from Reference Object [1]').
    (((self traitNamed: #SourceText) property: #sourceText type: #String) comment: 'Attribute sourceText from original JSON node [1]').
    (((self entityNamed: #Property) property: #enum type: #Object) comment: 'Attribute enum from Property [*] (array of strings)').
    (((self entityNamed: #Property) property: #required type: #Boolean) comment: 'Attribute required from Property [1]').
    (((self entityNamed: #ResponseEntry) property: #key type: #String) comment: 'Attribute key from ResponseEntry [1]').
    (((self entityNamed: #SchemaEntry) property: #key type: #String) comment: 'Attribute key from SchemaEntry [1]').
    (((self entityNamed: #ResponseDefinitionEntry) property: #key type: #String) comment: 'Attribute key from ResponseDefinitionEntry [1]').
    (((self entityNamed: #ParameterEntry) property: #key type: #String) comment: 'Attribute key from ParameterEntry [1]').
    (((self entityNamed: #SecuritySchemeEntry) property: #key type: #String) comment: 'Attribute key from SecuritySchemeEntry [1]').
    (((self entityNamed: #MediaTypeEntry) property: #key type: #String) comment: 'Attribute key from MediaTypeEntry [1]').
    (((self entityNamed: #RequestBodyEntry) property: #key type: #String) comment: 'Attribute key from RequestBodyEntry [1]').
    (((self entityNamed: #HeaderEntry) property: #key type: #String) comment: 'Attribute key from HeaderEntry [1]').
    (((self entityNamed: #ExampleEntry) property: #key type: #String) comment: 'Attribute key from ExampleEntry [1]').
    (((self entityNamed: #LinkEntry) property: #key type: #String) comment: 'Attribute key from LinkEntry [1]').
    (((self entityNamed: #CallbackEntry) property: #key type: #String) comment: 'Attribute key from CallbackEntry [1]').
	self defineCanonicalProperties
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineRelations [
    super defineRelations.
    (((self entityNamed: #ContainedCollections) property: #parameters) comment: 'Reference parameters from ContainedCollections to Parameter [0..*].') <>-* (self entityNamed: #Parameter).
    (((self entityNamed: #ContainedCollections) property: #schemas) comment: 'Reference schemas from ContainedCollections to Schema [0..*].') <>-* (self entityNamed: #Schema).
    (((self entityNamed: #ContainedCollections) property: #responses) comment: 'Reference responses from ContainedCollections to Response [0..*].') <>-* (self entityNamed: #Response).
    (((self entityNamed: #Api) property: #info) comment: 'Reference info from API to Info [0..1].') <>- (self entityNamed: #Info).
    (((self entityNamed: #Api) property: #paths) comment: 'Reference paths from API to Path [0..*].') <>-* (((self entityNamed: #Path) property: #api) comment: 'Opposite reference api from Path to API [0..1].').
    (((self entityNamed: #Api) property: #components) comment: 'Reference components from API to Components [0..1].') <>- (((self entityNamed: #Components) property: #api) comment: 'Opposite reference api from Components to API [0..1].').
    (((self entityNamed: #Api) property: #definitions) comment: 'Reference definitions from API to SchemaEntry [0..*].') <>-* (self entityNamed: #SchemaEntry).
    (((self entityNamed: #Api) property: #responses) comment: 'Reference responses from API to ResponseDefinitionEntry [0..*].') <>-* (self entityNamed: #ResponseDefinitionEntry).
    (((self entityNamed: #Api) property: #securityDefinitions) comment: 'Reference securityDefinitions from API to SecuritySchemeEntry [0..*].') <>-* (self entityNamed: #SecuritySchemeEntry).
    (((self entityNamed: #Api) property: #tags) comment: 'Reference tags from API to Tag [0..*].') <>-* (((self entityNamed: #Tag) property: #api) comment: 'Opposite reference api from Tag to API [0..1].').
    (((self entityNamed: #Api) property: #parameters) comment: 'Reference parameters from API to ParameterEntry [0..*].') <>-* (self entityNamed: #ParameterEntry).
    (((self entityNamed: #Api) property: #containedCollections) comment: 'Reference containedCollections from API to ContainedCollections [0..1].') <>- (self entityNamed: #ContainedCollections).
    (((self entityNamed: #Components) property: #schemas) comment: 'Reference schemas from Components to SchemaEntry [0..*].') <>-* (self entityNamed: #SchemaEntry).
    (((self entityNamed: #Components) property: #responses) comment: 'Reference responses from Components to ResponseDefinitionEntry [0..*].') <>-* (self entityNamed: #ResponseDefinitionEntry).
    (((self entityNamed: #Components) property: #parameters) comment: 'Reference parameters from Components to ParameterEntry [0..*].') <>-* (self entityNamed: #ParameterEntry).
    (((self entityNamed: #Components) property: #securitySchemes) comment: 'Reference securitySchemes from Components to SecuritySchemeEntry [0..*].') <>-* (self entityNamed: #SecuritySchemeEntry).
    (((self entityNamed: #Components) property: #requestBodies) comment: 'Reference requestBodies from Components to RequestBodyEntry [0..*].') <>-* (self entityNamed: #RequestBodyEntry).
    (((self entityNamed: #Components) property: #headers) comment: 'Reference headers from Components to HeaderEntry [0..*].') <>-* (self entityNamed: #HeaderEntry).
    (((self entityNamed: #Components) property: #examples) comment: 'Reference examples from Components to ExampleEntry [0..*].') <>-* (self entityNamed: #ExampleEntry).
    (((self entityNamed: #Components) property: #links) comment: 'Reference links from Components to LinkEntry [0..*].') <>-* (self entityNamed: #LinkEntry).
    (((self entityNamed: #Components) property: #callbacks) comment: 'Reference callbacks from Components to CallbackEntry [0..*].') <>-* (self entityNamed: #CallbackEntry).
    (((self entityNamed: #Info) property: #contact) comment: 'Reference contact from Info to Contact [0..1].') <>- (self entityNamed: #Contact).
    (((self entityNamed: #Info) property: #license) comment: 'Reference license from Info to License [0..1].') <>- (self entityNamed: #License).
    (((self entityNamed: #Path) property: #operations) comment: 'Reference operations from Path to Operation [0..*]: one operation per HTTP method.') <>-* (((self entityNamed: #Operation) property: #path) comment: 'Opposite reference path from Operation to Path [0..1].').
    (((self entityNamed: #Path) property: #parameters) comment: 'Reference parameters from Path to Parameter [0..*]. A parameter may be shared by several paths.') *-* (((self entityNamed: #Parameter) property: #usedByPaths) comment: 'Paths using this Parameter [0..*].').
    (((self entityNamed: #Operation) property: #responses) comment: 'Reference responses from Operation to ResponseEntry [1..*].') <>-* (self entityNamed: #ResponseEntry).
    (((self entityNamed: #Operation) property: #parameters) comment: 'Reference parameters from Operation to Parameter [0..*]. A parameter may be shared by several operations.') *-* (((self entityNamed: #Parameter) property: #usedByOperations) comment: 'Operations using this Parameter [0..*].').
    (((self entityNamed: #Operation) property: #requestBody) comment: 'Reference requestBody from Operation to RequestBody [0..1]. A request body may be shared by several operations.') *- (((self entityNamed: #RequestBody) property: #usedByOperations) comment: 'Operations using this RequestBody [0..*].').
    (((self entityNamed: #Operation) property: #callbacks) comment: 'Reference callbacks from Operation to CallbackEntry [0..*].') <>-* (self entityNamed: #CallbackEntry).
    (((self entityNamed: #Parameter) property: #declaringContext) comment: 'Reference declaringContext from Parameter to ParameterContainer [0..1].') - (self traitNamed: #ParameterContainer).
    (((self entityNamed: #Parameter) property: #schema) comment: 'Reference schema from Parameter to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedByParameters) comment: 'Parameters whose schema is this Schema [0..*].').
    (((self entityNamed: #Schema) property: #properties) comment: 'Reference properties from Schema to Property [0..*].') <>-* (((self entityNamed: #Property) property: #schema) comment: 'Opposite reference schema from Property to Schema [0..1].').
    (((self entityNamed: #Schema) property: #allOf) comment: 'Reference allOf from Schema to Schema [0..*].') *-* (((self entityNamed: #Schema) property: #usedAsAllOfBy) comment: 'Schemas having this Schema in their allOf [0..*].').
    (((self entityNamed: #Schema) property: #items) comment: 'Reference items from Schema to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedAsItemsBy) comment: 'Schemas having this Schema as their items [0..*].').
    (((self entityNamed: #Schema) property: #xml) comment: 'Reference xml from Schema to XMLElement [0..1].') <>- (self entityNamed: #XMLElement).
    (((self entityNamed: #Schema) property: #additionalProperties) comment: 'Reference additionalProperties from Schema to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedAsAdditionalPropertiesBy) comment: 'Schemas having this Schema as their additionalProperties [0..*].').
    (((self entityNamed: #Schema) property: #declaringContext) comment: 'Reference declaringContext from Schema to SchemaContainer [0..1].') - (self traitNamed: #SchemaContainer).
    (((self entityNamed: #Schema) property: #tupleItems) comment: 'Reference tupleItems from Schema to Schema [0..*].') *-* (((self entityNamed: #Schema) property: #usedAsTupleItemsBy) comment: 'Schemas having this Schema in their tupleItems [0..*].').
    (((self entityNamed: #Response) property: #headers) comment: 'Reference headers from Response to Header [0..*].') <>-* (self entityNamed: #Header).
    (((self entityNamed: #Response) property: #examples) comment: 'Reference examples from Response to Example [0..*].') <>-* (self entityNamed: #Example).
    (((self entityNamed: #Response) property: #declaringContext) comment: 'Reference declaringContext from Response to ResponseContainer [0..1].') - (self traitNamed: #ResponseContainer).
    (((self entityNamed: #Response) property: #schema) comment: 'Reference schema from Response to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedByResponses) comment: 'Responses whose schema is this Schema [0..*].').
    (((self entityNamed: #Header) property: #schema) comment: 'Reference schema from Header to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedByHeaders) comment: 'Headers whose schema is this Schema [0..*].').
    (((self traitNamed: #ContentContainer) property: #content) comment: 'Reference content from ContentContainer to MediaTypeEntry [0..*].') <>-* (self entityNamed: #MediaTypeEntry).
    (((self entityNamed: #MediaType) property: #schema) comment: 'Reference schema from MediaType to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedByMediaTypes) comment: 'Media types whose schema is this Schema [0..*].').
    (((self entityNamed: #MediaType) property: #examples) comment: 'Reference examples from MediaType to ExampleEntry [0..*].') <>-* (self entityNamed: #ExampleEntry).
    (((self entityNamed: #SecurityScheme) property: #scopes) comment: 'Reference scopes from SecurityScheme to SecurityScope [0..*].') <>-* (self entityNamed: #SecurityScope).
    (((self traitNamed: #ExternalDocsContainer) property: #externalDocs) comment: 'Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].') <>- (self entityNamed: #ExternalDocs).
    (((self traitNamed: #ArrayContainer) property: #items) comment: 'Reference items from ArrayContainer to ItemsDefinition [0..1].') <>- (self entityNamed: #ItemsDefinition).
    (((self entityNamed: #SecurityRequirement) property: #securitySchemes) comment: 'Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].') <>-* (self entityNamed: #RequiredSecurityScheme).
    (((self entityNamed: #ResponseEntry) property: #value) comment: 'Reference value from ResponseEntry to Response [0..1].') *- (((self entityNamed: #Response) property: #usedByResponseEntries) comment: 'ResponseEntry entries whose value is this Response [0..*].').
    (((self entityNamed: #SchemaEntry) property: #value) comment: 'Reference value from SchemaEntry to Schema [0..1].') *- (((self entityNamed: #Schema) property: #usedBySchemaEntries) comment: 'SchemaEntry entries whose value is this Schema [0..*].').
    (((self entityNamed: #ResponseDefinitionEntry) property: #value) comment: 'Reference value from ResponseDefinitionEntry to Response [0..1].') *- (((self entityNamed: #Response) property: #usedByResponseDefinitionEntries) comment: 'ResponseDefinitionEntry entries whose value is this Response [0..*].').
    (((self entityNamed: #ParameterEntry) property: #value) comment: 'Reference value from ParameterEntry to Parameter [0..1].') *- (((self entityNamed: #Parameter) property: #usedByParameterEntries) comment: 'ParameterEntry entries whose value is this Parameter [0..*].').
    (((self entityNamed: #MediaTypeEntry) property: #value) comment: 'Reference value from MediaTypeEntry to MediaType [0..1].') *- (((self entityNamed: #MediaType) property: #usedByMediaTypeEntries) comment: 'MediaTypeEntry entries whose value is this MediaType [0..*].').
    (((self entityNamed: #RequestBodyEntry) property: #value) comment: 'Reference value from RequestBodyEntry to RequestBody [0..1].') *- (((self entityNamed: #RequestBody) property: #usedByRequestBodyEntries) comment: 'RequestBodyEntry entries whose value is this RequestBody [0..*].').
    (((self entityNamed: #HeaderEntry) property: #value) comment: 'Reference value from HeaderEntry to Header [0..1].') *- (((self entityNamed: #Header) property: #usedByHeaderEntries) comment: 'HeaderEntry entries whose value is this Header [0..*].').
    (((self entityNamed: #ExampleEntry) property: #value) comment: 'Reference value from ExampleEntry to Example [0..1].') *- (((self entityNamed: #Example) property: #usedByExampleEntries) comment: 'ExampleEntry entries whose value is this Example [0..*].').
    (((self entityNamed: #LinkEntry) property: #value) comment: 'Reference value from LinkEntry to Link [0..1].') *- (((self entityNamed: #Link) property: #usedByLinkEntries) comment: 'LinkEntry entries whose value is this Link [0..*].').
    (((self entityNamed: #CallbackEntry) property: #value) comment: 'Reference value from CallbackEntry to Callback [0..1].') *- (((self entityNamed: #Callback) property: #usedByCallbackEntries) comment: 'CallbackEntry entries whose value is this Callback [0..*].').
    (((self traitNamed: #SecurityContainer) property: #security) comment: 'Reference security from SecurityContainer to SecurityRequirement [0..*].') <>-* (self entityNamed: #SecurityRequirement).
    (((self entityNamed: #SecuritySchemeEntry) property: #value) comment: 'Reference value from SecuritySchemeEntry to SecurityScheme [0..1].') *- (((self entityNamed: #SecurityScheme) property: #usedBySecuritySchemeEntries) comment: 'SecuritySchemeEntry entries whose value is this SecurityScheme [0..*].').
    (((self entityNamed: #RequiredSecurityScheme) property: #securityScopes) comment: 'Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].') *-* (((self entityNamed: #SecurityScope) property: #usedByRequiredSecuritySchemes) comment: 'Required security schemes using this SecurityScope [0..*].').
    (((self entityNamed: #RequiredSecurityScheme) property: #securityScheme) comment: 'Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].') *- (((self entityNamed: #SecurityScheme) property: #usedByRequiredSecuritySchemes) comment: 'Required security schemes using this SecurityScheme [0..*].').
	self defineCanonicalRelations
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineTraitNamed: aSymbol [
    traits at: aSymbol put: (builder newTraitNamed: aSymbol comment: 'Generated from openapi2.ecore')
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> defineTraitNamed: aSymbol comment: aString [

	traits
		at: aSymbol
		put: (builder newTraitNamed: aSymbol comment: aString)
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineTraits [
    super defineTraits.
    traits := Dictionary new.
    self defineTraitNamed: #JSONSchemaSubset.
    self defineTraitNamed: #ParameterContainer.
    self defineTraitNamed: #SchemaContainer.
    self defineTraitNamed: #ResponseContainer.
    self defineTraitNamed: #ExternalDocsContainer.
    self defineTraitNamed: #ArrayContainer.
    self defineTraitNamed: #SecurityContainer.
    self defineTraitNamed: #ContentContainer.
    self defineTraitNamed: #Referenceable.
    self defineTraitNamed: #SourceText.
	self defineCanonicalTraits
]

{ #category : 'private' }
FamixOpenApiGenerator >> entityNamed: aSymbol [
    ^ entities at: aSymbol
]

{ #category : 'definition-canonical' }
FamixOpenApiGenerator >> provisionalRelationNames [
	"Provisional name -> final name of the new relations that cannot yet take their final name because an original relation uses it. Recorded in the commit message and applied by the next regeneration. OPXmlElement (replacing OPXMLElement, with Schema>>xml) is not added yet: its Tonel file name only differs by case from the one of OPXMLElement, which cannot coexist on a case-insensitive file system."

	^ { 'OPComponents>>directSchemas -> schemas'.
	  'OPComponents>>directResponses -> responses'.
	  'OPComponents>>directParameters -> parameters'.
	  'OPComponents>>directRequestBodies -> requestBodies'.
	  'OPComponents>>directHeaders -> headers'.
	  'OPComponents>>directExamples -> examples'.
	  'OPComponents>>directLinks -> links'.
	  'OPComponents>>directCallbacks -> callbacks'.
	  'OPComponents>>directSecuritySchemes -> securitySchemes'.
	  'OPOperation>>directResponses -> responses'.
	  'OPOperation>>directCallbacks -> callbacks'.
	  'OPContentContainer>>directContent -> content (trait used by OPResponse, OPRequestBody and OPParameter)'.
	  'OPMediaType>>directExamples -> examples'.
	  'OPExternalDocsContainer>>externalDocumentation -> externalDocs (target OPExternalDocumentation)' }
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> stringCollection: aName in: aBehavior comment: aString [
	"Define the multivalued attribute aName on aBehavior. Its values are Strings, kept in a collection that is replaced as a whole through the setter; it is empty by default."

	| property |
	property := aBehavior
		            property: aName
		            type: #String
		            defaultValue: #(  ).
	property multivalued: true.
	property comment: aString.
	^ property
]

{ #category : 'private' }
FamixOpenApiGenerator >> traitNamed: aSymbol [
    ^ traits at: aSymbol
]
