"
Generates the Famix-OpenAPI-Model package (prefix OP): the entities of an OpenAPI 3.1 document. Swagger 2.0 and OpenAPI 3.0.x documents are normalised to this shape by the importer.

The entities are listed once in #entityDefinitions and the traits in #traitDefinitions. Attributes are declared by the #definePropertiesOf* methods and relations by the #defineRelationsOf* methods, as rows interpreted by #defineAttributesIn:rows: and #defineRelationsIn:.

Regenerate with FamixOpenApiGenerator new generate (not generateWithCleaning, which removes the whole package, including the extension methods that the Famix-OpenAPI-Model-Extension package adds to the generated classes). Classes of removed entities must then be removed by hand.
Never edit the generated classes: change this generator.
"
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

{ #category : 'private' }
FamixOpenApiGenerator >> behaviorNamed: aSymbol [
	"Answer the entity or the trait named aSymbol."

	^ entities at: aSymbol ifAbsent: [ traits at: aSymbol ]
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> defineAttributesIn: aBehaviorName rows: aCollection [
	"Define attributes on the entity or trait named aBehaviorName. Each row is { attribute name. type name (#String, #Number, #Boolean or #Strings for a collection of Strings). comment }."

	| behavior |
	behavior := self behaviorNamed: aBehaviorName.
	aCollection do: [ :row |
		row second = #Strings
			ifTrue: [
			self stringCollection: row first in: behavior comment: row third ]
			ifFalse: [
				self
					attribute: row first
					in: behavior
					type: row second
					comment: row third ] ]
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineClasses [

	super defineClasses.
	entities := Dictionary new.
	self entityDefinitions do: [ :each |
		self defineEntityNamed: each key comment: each value ].
	(builder ensureAbstractClassNamed: #Entity) comment:
		'Common superclass of the entities of the OpenAPI metamodel.'.
	builder model comment:
		'Moose model holding the entities of one or several OpenAPI documents (an OpenApi entity is the root of each document).'
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> defineEntityNamed: aSymbol comment: aString [

	entities
		at: aSymbol
		put: (builder newClassNamed: aSymbol comment: aString)
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineHierarchy [
	| subSchema |
	super defineHierarchy.
	subSchema := self entityNamed: #SubSchema.
	"A SubSchema inherits the traits of Schema through its superclass."
	(entities reject: [ :entity | entity == subSchema ]) valuesDo: [ :entity |
		entity --|> #TNamedEntity.
		entity --|> (self traitNamed: #SourceText).
		entity --|> (self traitNamed: #CanonicalNode) ].
	subSchema --|> (self entityNamed: #Schema).
	#( Path Parameter Schema Response Header Example SecurityScheme
	   RequestBody Link Callback ) do: [ :entityName |
		(self entityNamed: entityName)
		--|> (self traitNamed: #Referenceable) ].
	#( RequestBody Parameter Response ) do: [ :entityName |
		(self entityNamed: entityName)
		--|> (self traitNamed: #ContentContainer) ].
	#( Operation Schema Tag ) do: [ :entityName |
		(self entityNamed: entityName)
		--|> (self traitNamed: #ExternalDocsContainer) ]
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineProperties [

	super defineProperties.
	self definePropertiesOfTraits.
	self definePropertiesOfDocument.
	self definePropertiesOfOperations.
	self definePropertiesOfSchemas.
	self definePropertiesOfSecurity
]

{ #category : 'definition-properties' }
FamixOpenApiGenerator >> definePropertiesOfDocument [

	self defineAttributesIn: #OpenApi rows: {
			{ #sourceVersion. #String. 'Version of the specification of the source document: 2.0, 3.0.x or 3.1.x.' }.
			{ #openapiVersion. #String. 'Value of the openapi field of the canonical document.' }.
			{ #jsonSchemaDialect. #String. 'URI of the JSON Schema dialect used by the schemas of the document (jsonSchemaDialect field).' }.
			{ #selfUrl. #String. 'URI under which the document is available ($self field).' } }.
	self defineAttributesIn: #Info rows: {
			{ #title. #String. 'Title of the API.' }.
			{ #description. #String. 'Description of the API.' }.
			{ #termsOfService. #String. 'URL of the terms of service of the API.' }.
			{ #version. #String. 'Version of the API (not the one of the specification).' } }.
	self defineAttributesIn: #Contact rows: {
			{ #url. #String. 'URL of the contact page.' }.
			{ #email. #String. 'Email address of the contact.' } }.
	self
		defineAttributesIn: #License
		rows: { { #url. #String. 'URL of the license text.' } }.
	self defineAttributesIn: #Server rows: {
			{ #url. #String. 'URL template of the server.' }.
			{ #description. #String. 'Description of the server.' } }.
	self defineAttributesIn: #ServerVariable rows: {
			{ #defaultValue. #String. 'Value used when the variable is not provided.' }.
			{ #description. #String. 'Description of the server variable.' }.
			{ #enumValues. #Strings. 'Allowed values of the server variable.' } }.
	self
		defineAttributesIn: #Tag
		rows: { { #description. #String. 'Description of the tag.' } }.
	self defineAttributesIn: #ExternalDocumentation rows: {
			{ #description. #String. 'Description of the external documentation.' }.
			{ #url. #String. 'URL of the external documentation.' } }.
	self defineAttributesIn: #Reference rows: {
			{ #target. #String. 'The $ref URI that could not be resolved.' }.
			{ #summary. #String. 'Summary overriding the one of the referenced object.' }.
			{ #description. #String. 'Description overriding the one of the referenced object.' } }
]

{ #category : 'definition-properties' }
FamixOpenApiGenerator >> definePropertiesOfOperations [

	self defineAttributesIn: #Path rows: {
			{ #relativePath. #String. 'Relative path of the path item, for example /pets/{petId}.' }.
			{ #summary. #String. 'Short summary of the path item.' }.
			{ #description. #String. 'Description of the path item.' } }.
	self defineAttributesIn: #Operation rows: {
			{ #summary. #String. 'Short summary of the operation.' }.
			{ #description. #String. 'Description of the operation.' }.
			{ #httpMethod. #String. 'Lowercase HTTP verb of the operation: get, put, post, delete, options, head, patch or trace.' }.
			{ #operationId. #String. 'Unique identifier of the operation in the document.' }.
			{ #deprecated. #Boolean. 'Whether the operation is deprecated.' }.
			{ #tagNames. #Strings. 'Names of the tags of the operation as written in the source. Use #tags to get the Tag entities.' } }.
	((self entityNamed: #Operation)
		 property: #securityDisabled
		 type: #Boolean
		 defaultValue: false) comment:
		'True when the operation explicitly disables the security of the document (security: [] in the source); false otherwise. See #effectiveSecurity.'.
	self defineAttributesIn: #Parameter rows: {
			{ #location. #String. 'Where the parameter is located: path, query, header or cookie (the in field).' }.
			{ #required. #Boolean. 'Whether the parameter is mandatory.' }.
			{ #allowEmptyValue. #Boolean. 'Whether a query parameter may be sent with an empty value.' }.
			{ #description. #String. 'Description of the parameter.' }.
			{ #style. #String. 'Serialization style of the parameter value.' }.
			{ #explode. #Boolean. 'Whether array and object values generate separate parameters.' }.
			{ #allowReserved. #Boolean. 'Whether reserved characters are left unescaped in the value.' }.
			{ #deprecated. #Boolean. 'Whether the parameter is deprecated.' } }.
	self defineAttributesIn: #RequestBody rows: {
			{ #description. #String. 'Description of the request body.' }.
			{ #required. #Boolean. 'Whether the request body is mandatory.' } }.
	self defineAttributesIn: #Response rows: {
			{ #statusCode. #String. 'HTTP status code of the response, a range or default: 200, 2XX or default.' }.
			{ #description. #String. 'Description of the response.' } }.
	self defineAttributesIn: #Header rows: {
			{ #description. #String. 'Description of the header.' }.
			{ #required. #Boolean. 'Whether the header is mandatory.' }.
			{ #deprecated. #Boolean. 'Whether the header is deprecated.' }.
			{ #style. #String. 'Serialization style of the header value.' }.
			{ #explode. #Boolean. 'Whether array and object values are exploded.' } }.
	self
		defineAttributesIn: #MediaType
		rows:
		{ { #mediaType. #String. 'Media type (MIME type) described, for example application/json.' } }.
	self defineAttributesIn: #Encoding rows: {
			{ #propertyName. #String. 'Name of the media type schema property this encoding applies to.' }.
			{ #contentType. #String. 'Content type or types accepted for the property.' }.
			{ #style. #String. 'Serialization style of the property.' }.
			{ #explode. #Boolean. 'Whether array and object values generate separate parameters.' }.
			{ #allowReserved. #Boolean. 'Whether reserved characters are left unescaped.' } }.
	self defineAttributesIn: #Example rows: {
			{ #summary. #String. 'Short description of the example.' }.
			{ #value. #String. 'Value of the example, as JSON text.' }.
			{ #externalValue. #String. 'URL of a document holding the example value.' } }.
	self defineAttributesIn: #Link rows: {
			{ #operationRef. #String. 'URI reference of the linked operation (operationRef field).' }.
			{ #operationId. #String. 'operationId of the linked operation.' }.
			{ #requestBody. #String. 'Expression or literal used as request body of the linked operation.' }.
			{ #description. #String. 'Description of the link.' } }
]

{ #category : 'definition-properties' }
FamixOpenApiGenerator >> definePropertiesOfSchemas [

	self defineAttributesIn: #Schema rows: {
			{ #title. #String. 'Title of the schema.' }.
			{ #description. #String. 'Description of the schema.' }.
			{ #types. #Strings. 'JSON Schema types of the schema, such as string, integer or null; several values for a 3.1 type array.' }.
			{ #format. #String. 'Format of the values, such as int32, int64 or date-time.' }.
			{ #isNullable. #Boolean. 'Whether null is an accepted value (nullable in 3.0, null among the types in 3.1).' }.
			{ #enumValues. #String. 'Allowed values of the schema, as a JSON array text.' }.
			{ #constValue. #String. 'The only allowed value of the schema (const), as JSON text.' }.
			{ #defaultValue. #String. 'Default value of the schema, as JSON text.' }.
			{ #exampleValue. #String. 'Example value of the schema, as JSON text.' }.
			{ #deprecated. #Boolean. 'Whether the schema is deprecated.' }.
			{ #readOnly. #Boolean. 'Whether the value is only returned by the server, never sent to it.' }.
			{ #writeOnly. #Boolean. 'Whether the value is only sent to the server, never returned.' }.
			{ #requiredProperties. #Strings. 'Names of the properties that are mandatory in an instance of the schema.' }.
			{ #mergedPointers. #Strings. 'canonicalPointers of identical inline schemas that the importer merged into this entity; the entity''s own canonicalPointer is the first occurrence.' }.
			{ #additionalPropertiesAllowed. #Boolean. 'Whether additional properties are allowed when additionalProperties is a boolean in the source.' }.
			{ #maximum. #Number. 'Inclusive upper bound of a number.' }.
			{ #minimum. #Number. 'Inclusive lower bound of a number.' }.
			{ #exclusiveMaximum. #Number. 'Exclusive upper bound of a number (OpenAPI 3.1 form).' }.
			{ #exclusiveMinimum. #Number. 'Exclusive lower bound of a number (OpenAPI 3.1 form).' }.
			{ #multipleOf. #Number. 'A number is valid when it is a multiple of this value.' }.
			{ #maxLength. #Number. 'Maximum length of a string.' }.
			{ #minLength. #Number. 'Minimum length of a string.' }.
			{ #pattern. #String. 'Regular expression a string must match.' }.
			{ #maxItems. #Number. 'Maximum number of items of an array.' }.
			{ #minItems. #Number. 'Minimum number of items of an array.' }.
			{ #uniqueItems. #Boolean. 'Whether the items of an array must be distinct.' }.
			{ #maxProperties. #Number. 'Maximum number of properties of an object.' }.
			{ #minProperties. #Number. 'Minimum number of properties of an object.' } }.
	self
		defineAttributesIn: #Property
		rows:
		{ { #isRequired. #Boolean. 'Whether the property is listed as required by its declaring schema.' } }.
	self
		defineAttributesIn: #Discriminator
		rows:
		{ { #propertyName. #String. 'Name of the property whose value discriminates the schemas.' } }.
	self
		defineAttributesIn: #DiscriminatorMapping
		rows:
		{ { #value. #String. 'Name or reference of the schema selected by the discriminating value, as written in the source.' } }.
	self defineAttributesIn: #XmlElement rows: {
			{ #namespace. #String. 'URI of the XML namespace.' }.
			{ #prefix. #String. 'Prefix of the XML namespace.' }.
			{ #attribute. #Boolean. 'Whether the property is an XML attribute rather than an element.' }.
			{ #wrapped. #Boolean. 'Whether the items of an array are wrapped in an enclosing element.' } }
]

{ #category : 'definition-properties' }
FamixOpenApiGenerator >> definePropertiesOfSecurity [

	self defineAttributesIn: #SecurityScheme rows: {
			{ #type. #String. 'Type of the scheme: apiKey, http, oauth2, openIdConnect or mutualTLS.' }.
			{ #description. #String. 'Description of the security scheme.' }.
			{ #scheme. #String. 'Name of the HTTP authorization scheme, such as basic or bearer.' }.
			{ #bearerFormat. #String. 'Hint on the format of the bearer token.' }.
			{ #openIdConnectUrl. #String. 'URL of the OpenID Connect discovery document.' }.
			{ #inLocation. #String. 'Location of an apiKey credential: query, header or cookie (the in field).' }.
			{ #parameterName. #String. 'Name of the header, query or cookie parameter carrying an apiKey credential (the name field).' } }.
	self defineAttributesIn: #OAuthFlow rows: {
			{ #flowType. #String. 'Kind of flow: implicit, password, clientCredentials or authorizationCode.' }.
			{ #authorizationUrl. #String. 'Authorization URL of the flow.' }.
			{ #tokenUrl. #String. 'Token URL of the flow.' }.
			{ #refreshUrl. #String. 'URL used to obtain refresh tokens.' } }.
	self
		defineAttributesIn: #SecurityScope
		rows:
		{ { #description. #String. 'Description of what the scope grants.' } }.
	self
		defineAttributesIn: #SecurityRequirementItem
		rows:
		{ { #scopeNames. #Strings. 'Names of the scopes required from the security scheme (empty when the scheme has no scopes).' } }
]

{ #category : 'definition-properties' }
FamixOpenApiGenerator >> definePropertiesOfTraits [

	self defineAttributesIn: #CanonicalNode rows: {
			{ #canonicalPointer. #String. 'JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet.' }.
			{ #extensions. #String. 'Specification extensions (x-* keys) of the source node, as a JSON object text.' } }.
	self
		defineAttributesIn: #SourceText
		rows:
		{ { #sourceText. #String. 'Text of the JSON node the entity was built from.' } }.
	self
		defineAttributesIn: #Referenceable
		rows:
		{ { #ref. #String. 'The $ref, as written in the source, that designates the reusable object this entity is or was copied from (for example #/components/schemas/Pet). Empty when the entity is not the result of a reference.' } }
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineRelations [

	super defineRelations.
	self defineRelationsOfDocument.
	self defineRelationsOfComponents.
	self defineRelationsOfOperations.
	self defineRelationsOfSchemas.
	self defineRelationsOfSecurity
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> defineRelationsIn: aCollection [
	"Define bidirectional relations. Each row is { kind. owner name. relation name. target name. opposite name. relation comment. opposite comment }. The kind is #containsOne (owner contains one target), #containsMany (owner contains several targets), #manyToOne (the owner refers to one target, a target is referred to by several owners) or #manyToMany. Owner and target are entity or trait names."

	aCollection do: [ :row |
		| origin opposite |
		origin := ((self behaviorNamed: (row at: 2)) property: (row at: 3))
			          comment: (row at: 6);
			          yourself.
		opposite := ((self behaviorNamed: (row at: 4)) property: (row at: 5))
			            comment: (row at: 7);
			            yourself.
		self relate: origin with: opposite kind: row first ]
]

{ #category : 'definition-relations' }
FamixOpenApiGenerator >> defineRelationsOfComponents [

	#( #( schemas Schema 'reusable schemas' )
	   #( responses Response 'reusable responses' )
	   #( parameters Parameter 'reusable parameters' )
	   #( requestBodies RequestBody 'reusable request bodies' )
	   #( headers Header 'reusable headers' )
	   #( examples Example 'reusable examples' )
	   #( links Link 'reusable links' ) #( callbacks Callback 'reusable callbacks' )
	   #( securitySchemes SecurityScheme 'reusable security schemes' )
	   #( pathItems Path 'reusable path items' ) ) do: [ :row |
		self defineRelationsIn: { {
				#containsMany.
				#Components.
				row first.
				row second.
				#components.
				('The ' , row third
				 ,
				 ' of the document, owned by the components and shared by reference.').
				'The components owning the object, when it is a reusable one.' } } ]
]

{ #category : 'definition-relations' }
FamixOpenApiGenerator >> defineRelationsOfDocument [

	self defineRelationsIn: {
			{ #containsOne. #OpenApi. #info. #Info. #openApi. 'Metadata of the API.'.
			'The document the Info describes.' }.
			{ #containsMany. #OpenApi. #servers. #Server. #openApi. 'Servers hosting the API.'.
			'The document declaring the server, when it is declared at document level.' }.
			{ #containsMany. #OpenApi. #paths. #Path. #openApi. 'Path items of the API.'.
			'The document declaring the path item in its paths.' }.
			{ #containsMany. #OpenApi. #webhooks. #Path. #webhookOf. 'Path items describing the requests the API may send (OpenAPI 3.1 webhooks).'.
			'The document declaring the path item in its webhooks.' }.
			{ #containsOne. #OpenApi. #components. #Components. #openApi.
			'Reusable objects of the API.'. 'The document the components belong to.' }.
			{ #containsMany. #OpenApi. #tags. #Tag. #openApi. 'Tags declared by the document.'.
			'The document declaring the tag.' }.
			{ #containsMany. #OpenApi. #securityRequirements.
			#SecurityRequirement. #openApi. 'Security requirements applied to every operation by default, as alternatives.'.
			'The document declaring the requirement as its default security.' }.
			{ #containsOne. #OpenApi. #externalDocs. #ExternalDocumentation.
			#openApi. 'External documentation of the API as a whole.'.
			'The document the external documentation belongs to.' }.
			{ #containsMany. #OpenApi. #unresolvedReferences.
			#Reference. #openApi. 'References that could not be resolved to an entity of the model, for example references to external documents.'.
			'The document in which the unresolved reference appears.' }.
			{ #containsOne. #Info. #contact. #Contact. #info. 'Contact of the API.'.
			'The Info declaring the contact.' }.
			{ #containsOne. #Info. #license. #License. #info. 'License of the API.'.
			'The Info declaring the license.' }.
			{ #containsMany. #Server. #variables. #ServerVariable.
			#server. 'Variables substituted in the URL template of the server.'.
			'The server declaring the variable.' }.
			{ #containsMany. #Path. #servers. #Server. #path. 'Servers overriding the ones of the document for this path item.'.
			'The path item declaring the server.' }.
			{ #containsMany. #Operation. #servers. #Server. #operation.
			'Servers overriding the ones of the path item for this operation.'.
			'The operation declaring the server.' }.
			{ #containsOne. #Link. #server. #Server. #link. 'Server used by the linked operation.'.
			'The link declaring the server.' }.
			{ #containsOne. #ExternalDocsContainer. #externalDocs. #ExternalDocumentation.
			#externalDocsContainer. 'External documentation of the entity.'.
			'The operation, schema or tag the external documentation belongs to.' } }
]

{ #category : 'definition-relations' }
FamixOpenApiGenerator >> defineRelationsOfOperations [

	self defineRelationsIn: {
			{ #containsMany. #Path. #operations. #Operation. #path. 'Operations of the path item, one per HTTP method.'.
			'The path item declaring the operation.' }.
			{ #manyToMany. #Path. #parameters. #Parameter. #usedByPaths.
			'Parameters shared by all the operations of the path item. A parameter may be shared by several paths.'.
			'Path items using this parameter.' }.
			{ #manyToMany. #Operation. #parameters. #Parameter. #usedByOperations.
			'Parameters of the operation. A parameter may be shared by several operations.'.
			'Operations using this parameter.' }.
			{ #manyToOne. #Operation. #requestBody. #RequestBody. #usedByOperations.
			'Request body accepted by the operation. A request body may be shared by several operations.'.
			'Operations using this request body.' }.
			{ #containsMany. #Operation. #responses. #Response. #operation.
			'Responses of the operation, one per status code.'.
			'The operation owning the response.' }.
			{ #manyToMany. #Operation. #callbacks. #Callback. #usedByOperations.
			'Callbacks the operation may trigger. A callback may be shared by several operations.'.
			'Operations using this callback.' }.
			{ #containsMany. #Operation. #securityRequirements.
			#SecurityRequirement. #operation. 'Security requirements of the operation, as alternatives; they replace the ones of the document. See #effectiveSecurity.'.
			'The operation declaring the requirement.' }.
			{ #manyToOne. #Link. #operation. #Operation. #usedByLinks.
			'The linked operation (operationId or operationRef resolved).'.
			'Links targeting this operation.' }.
			{ #manyToMany. #Callback. #pathItems. #Path. #usedByCallbacks. 'Path items describing the requests sent to the callback URL expressions. A path item may be shared by several callbacks.'.
			'Callbacks using this path item.' }.
			{ #containsMany. #ContentContainer. #content. #MediaType. #contentOwner.
			'Payload descriptions of the entity, one per media type.'.
			'The response, request body or parameter declaring the media type.' }.
			{ #containsMany. #MediaType. #encodings. #Encoding. #mediaType.
			'Serialization rules of the schema properties.'.
			'The media type declaring the encoding.' }.
			{ #manyToMany. #MediaType. #examples. #Example. #usedByMediaTypes.
			'Examples of the media type. An example may be shared by several media types.'. 'Media types using this example.' }.
			{ #manyToMany. #Parameter. #examples. #Example. #usedByParameters.
			'Examples of the parameter value. An example may be shared by several parameters.'.
			'Parameters using this example.' }.
			{ #manyToMany. #Encoding. #headers. #Header. #usedByEncodings. 'Headers sent with the encoded part. A header may be shared by several encodings.'.
			'Encodings using this header.' }.
			{ #manyToMany. #Response. #headers. #Header. #usedByResponses. 'Headers of the response. A header may be shared by several responses.'.
			'Responses using this header.' }.
			{ #manyToMany. #Response. #links. #Link. #usedByResponses. 'Links of the response, toward operations that can be followed from it. A link may be shared by several responses.'.
			'Responses using this link.' }.
			{ #manyToOne. #Parameter. #schema. #Schema. #usedByParameters.
			'Schema of the parameter value.'. 'Parameters whose schema is this schema.' }.
			{ #manyToOne. #Header. #schema. #Schema. #usedByHeaders.
			'Schema of the header value.'. 'Headers whose schema is this schema.' }.
			{ #manyToOne. #MediaType. #schema. #Schema. #usedByMediaTypes.
			'Schema of the payload.'. 'Media types whose schema is this schema.' } }
]

{ #category : 'definition-relations' }
FamixOpenApiGenerator >> defineRelationsOfSchemas [

	self defineRelationsIn: {
			{ #containsMany. #Schema. #properties. #Property. #schema. 'Named properties of an object schema.'.
			'The schema declaring the property.' }.
			{ #manyToMany. #Schema. #allOf. #Schema. #usedAsAllOfBy.
			'Schemas that must all match.'. 'Schemas having this schema in their allOf.' }.
			{ #manyToMany. #Schema. #oneOf. #Schema. #usedAsOneOfBy.
			'Alternatives of which exactly one must match.'.
			'Schemas having this schema in their oneOf.' }.
			{ #manyToMany. #Schema. #anyOf. #Schema. #usedAsAnyOfBy.
			'Alternatives of which at least one must match.'.
			'Schemas having this schema in their anyOf.' }.
			{ #manyToMany. #Schema. #prefixItems. #Schema. #usedAsPrefixItemsBy.
			'Schemas of the first items of an array, in order (tuple validation).'.
			'Schemas having this schema in their prefixItems.' }.
			{ #manyToOne. #Schema. #not. #Schema. #usedAsNotBy. 'Schema that must not match.'.
			'Schemas having this schema as their not.' }.
			{ #manyToOne. #Schema. #items. #Schema. #usedAsItemsBy.
			'Schema of the items of an array.'.
			'Schemas having this schema as their items.' }.
			{ #manyToOne. #Schema. #additionalProperties. #Schema. #usedAsAdditionalPropertiesBy.
			'Schema of the additional properties of an object.'.
			'Schemas having this schema as their additionalProperties.' }.
			{ #containsOne. #Schema. #discriminator. #Discriminator.
			#schema. 'Discriminator selecting the matching alternative of the schema.'.
			'The schema declaring the discriminator.' }.
			{ #containsOne. #Schema. #xml. #XmlElement. #schema. 'XML representation of the schema.'.
			'The schema declaring the XML element.' }.
			{ #containsMany. #Discriminator. #mapping. #DiscriminatorMapping.
			#discriminator. 'Explicit bindings of discriminating values to schemas.'.
			'The discriminator declaring the mapping.' }.
			{ #manyToOne. #DiscriminatorMapping. #schema. #Schema. #usedByDiscriminatorMappings.
			'The schema selected by the discriminating value.'.
			'Discriminator mappings selecting this schema.' }.
			{ #manyToOne. #Property. #valueSchema. #Schema. #usedAsPropertyValueBy.
			'Schema of the property value.'. 'Properties whose value schema is this schema.' }.
			{ #manyToOne. #SubSchema. #subSchemaOf. #Schema. #subSchemas.
			'The larger Schema of which the receiver is a strict subset (same property names, with equivalent value schemas).'.
			'SubSchemas created by the importer as strict subsets of this schema.' } }
]

{ #category : 'definition-relations' }
FamixOpenApiGenerator >> defineRelationsOfSecurity [

	self defineRelationsIn: {
			{ #containsMany. #SecurityScheme. #flows. #OAuthFlow. #securityScheme.
			'OAuth2 flows supported by the scheme.'.
			'The security scheme declaring the flow.' }.
			{ #containsMany. #OAuthFlow. #scopes. #SecurityScope. #oauthFlow.
			'Scopes offered by the flow, with their description.'.
			'The flow offering the scope.' }.
			{ #containsMany. #SecurityRequirement. #items. #SecurityRequirementItem.
			#requirement. 'Schemes that must all be satisfied together (logical AND).'.
			'The requirement the item belongs to.' }.
			{ #manyToOne. #SecurityRequirementItem. #scheme. #SecurityScheme.
			#usedBySecurityRequirementItems. 'The security scheme required by the item.'.
			'Requirement items that require this security scheme.' } }
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
	self traitDefinitions do: [ :each |
		self defineTraitNamed: each key comment: each value ]
]

{ #category : 'definition-entities' }
FamixOpenApiGenerator >> entityDefinitions [
	"Answer the entities of the metamodel: each association binds the name of an entity to the text of its class comment. This is the only place where the entities are listed."

	^ {
		  (#OpenApi
		   ->
		   'An OpenAPI description document (OpenAPI Object), root of the model. Swagger 2.0 and OpenAPI 3.0.x documents are normalised by the importer to the OpenAPI 3.1 shape described by this model.').
		  (#Info
		   ->
		   'Metadata of the API: title, version, description, terms of service, contact and license (OpenAPI Info Object).').
		  (#Contact
		   -> 'Contact information of the API (OpenAPI Contact Object).').
		  (#License -> 'License of the API (OpenAPI License Object).').
		  (#Server
		   ->
		   'A server hosting the API (OpenAPI Server Object), declared at document, path item, operation or link level.').
		  (#ServerVariable
		   ->
		   'A variable substituted in the URL template of a Server (OpenAPI Server Variable Object). Its name is the variable name.').
		  (#Tag
		   ->
		   'A tag declared by the document to group operations (OpenAPI Tag Object).').
		  (#ExternalDocumentation
		   ->
		   'A reference to external documentation (OpenAPI External Documentation Object).').
		  (#Path
		   ->
		   'A path item (OpenAPI Path Item Object): the operations available on one relative path, declared in the paths, in the webhooks, in a callback or among the reusable path items. A path item may be shared by several callbacks.').
		  (#Operation
		   ->
		   'An HTTP operation of a path item (OpenAPI Operation Object): one verb on one path, with its parameters, request body, responses, callbacks and security.').
		  (#Parameter
		   ->
		   'A parameter of an operation or of a path item (OpenAPI Parameter Object), located in the path, the query, a header or a cookie. It may be shared by several operations.').
		  (#RequestBody
		   ->
		   'The payload an operation accepts (OpenAPI Request Body Object), described by media types. It may be shared by several operations.').
		  (#Response
		   ->
		   'A response of an operation for one status code (OpenAPI Response Object). A reusable response referenced by several operations is copied for each of them: each copy owns its status code and operation and keeps the reference to the original.').
		  (#Header
		   ->
		   'A header of a response or of an encoding (OpenAPI Header Object). A reusable header may be shared by several responses and encodings.').
		  (#MediaType
		   ->
		   'The description of a payload for one media type, such as application/json (OpenAPI Media Type Object).').
		  (#Encoding
		   ->
		   'Serialization rules applied to one property of a media type schema (OpenAPI Encoding Object).').
		  (#Example
		   ->
		   'An example value (OpenAPI Example Object), inline or reusable. A reusable example may be shared by several parameters and media types.').
		  (#Link
		   ->
		   'A link from a response to an operation that can be followed with values of the response (OpenAPI Link Object). A reusable link may be shared by several responses.').
		  (#Callback
		   ->
		   'Requests an operation may send to a URL given at runtime (OpenAPI Callback Object), described by path items. A reusable callback may be shared by several operations.').
		  (#Components
		   ->
		   'The reusable objects of the document (OpenAPI Components Object): schemas, responses, parameters, request bodies, headers, examples, links, callbacks, security schemes and path items. Each reusable object is owned by the components and shared by reference.').
		  (#Schema
		   ->
		   'A JSON Schema (OpenAPI Schema Object) describing a value: its types, constraints, properties and composition (allOf, oneOf, anyOf, not).').
		  (#SubSchema
		   ->
		   'A Schema that is a strict subset of a larger Schema (same property names with equivalent value schemas). Created by the importer, it does not exist as such in the source document; subSchemaOf points to the larger Schema.').
		  (#Property
		   ->
		   'A named property of an object Schema. It binds a name to the Schema of the value and tells whether the property is required.').
		  (#Discriminator
		   ->
		   'Hint used to select, among oneOf/anyOf/allOf alternatives, the schema matching a payload (OpenAPI Discriminator Object).').
		  (#DiscriminatorMapping
		   ->
		   'One entry of the mapping of a Discriminator: a discriminating value (its name) bound to the Schema it selects.').
		  (#XmlElement
		   ->
		   'XML representation of a Schema (OpenAPI XML Object): element name, namespace, prefix, attribute or wrapped array. Its name is the XML element name.').
		  (#SecurityScheme
		   ->
		   'A security scheme usable by the API (OpenAPI Security Scheme Object): apiKey, http, oauth2, openIdConnect or mutualTLS.').
		  (#OAuthFlow
		   ->
		   'One OAuth2 flow of a security scheme (OpenAPI OAuth Flow Object): implicit, password, clientCredentials or authorizationCode.').
		  (#SecurityScope
		   ->
		   'A scope offered by an OAuth2 flow, with its description. Scopes exist only under OAuthFlow.').
		  (#SecurityRequirement
		   ->
		   'An alternative of the security of an API or of an operation (OpenAPI Security Requirement Object). All its items must be satisfied together (logical AND); the requirements of the same list are alternatives (logical OR).').
		  (#SecurityRequirementItem
		   ->
		   'One security scheme required by a SecurityRequirement, with the names of the scopes needed from it.').
		  (#Reference
		   ->
		   'A $ref that cannot be resolved to an entity of the model, for instance a reference to an external document (OpenAPI Reference Object). It is owned by the root OpenApi.') }
]

{ #category : 'private' }
FamixOpenApiGenerator >> entityNamed: aSymbol [
    ^ entities at: aSymbol
]

{ #category : 'definition-helpers' }
FamixOpenApiGenerator >> relate: anOriginProperty with: anOppositeProperty kind: aKind [
	"Declare the two properties as opposites of each other, with the multiplicity and the containment given by aKind."

	aKind = #containsOne ifTrue: [
		^ anOriginProperty <>- anOppositeProperty ].
	aKind = #containsMany ifTrue: [
		^ anOriginProperty <>-* anOppositeProperty ].
	aKind = #manyToOne ifTrue: [
		^ anOriginProperty *- anOppositeProperty ].
	aKind = #manyToMany ifTrue: [
		^ anOriginProperty *-* anOppositeProperty ].
	^ self error: 'Unknown kind of relation: ' , aKind printString
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

{ #category : 'definition' }
FamixOpenApiGenerator >> traitDefinitions [
	"Answer the traits of the metamodel: each association binds the name of a trait to the text of its comment. This is the only place where the traits are listed."

	^ {
		  (#CanonicalNode
		   ->
		   'Common part of the entities of the model: the JSON pointer of the entity in the canonical OpenAPI 3.1 document and its specification extensions (x-* keys).').
		  (#SourceText
		   ->
		   'Keeps the text of the JSON node an entity was built from, for traceability.').
		  (#Referenceable
		   ->
		   'Entities that can be designated by a $ref (reusable objects) and keep the reference they come from.').
		  (#ContentContainer
		   ->
		   'Entities that describe a payload through media types: Response, RequestBody and Parameter.').
		  (#ExternalDocsContainer
		   ->
		   'Entities that may point to external documentation: Operation, Schema and Tag.') }
]

{ #category : 'private' }
FamixOpenApiGenerator >> traitNamed: aSymbol [
    ^ traits at: aSymbol
]
