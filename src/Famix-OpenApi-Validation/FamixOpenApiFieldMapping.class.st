"
I am the human-reviewed data that tells, for each spec object of FamixOpenApiSpecFieldTable, which class of the OpenAPI metamodel (OP*) carries it, and for each spec field which slot or relation carries it when that is not simply the field name converted to an accessor.
All the data is on the class side, one small data method per concern, like the field table.
API: classNameFor: aSpecObjectName, entryFor: aSpecField, defaultSelectorFor: aFieldName, modelOnlyReasonFor: aModelSlot.
An entry is an array #(field mode selector className note). Mode is #map (the field is carried by the slot or relation selector), #implicit (the field is carried by the structure, for example a patterned key, a map or a conversion done by the importer, and selector names the slot or relation that carries it) or #notApplicable (the field has no meaning for the model, note gives the reason). className is empty when the entry applies to the class of the spec object, otherwise it names the OP class that carries the field (for example the Swagger 2.0 flow field of a Security Scheme is carried by OPOAuthFlow). A field without entry takes its default selector: the field name when it is a plain identifier (so $ref, x-* and {name} have none). x-* extensions are implicit on the extensions slot of every class.
A mapping is a PROPOSAL reviewed by the user; the conformance report counts a selector as modelled only when the metamodel really has it.
An entry of mode #notModelled states a verified gap: the field has no slot and note says where its value survives (for example only as extensions JSON text). It is data, so the validation package does not reference the importer.
Known importer gap (see knownImporterGaps): Swagger 2 Header keywords are not converted to a schema (importer fidelity gap, to be handled in the import-fidelity step).
"
Class {
	#name : 'FamixOpenApiFieldMapping',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'api' }
FamixOpenApiFieldMapping class >> allEntries [
	"Answer every explicit entry as an association spec object name -> FamixOpenApiMappingEntry."

	^ self entriesByObject associations flatCollect: [ :each |
		  each value collect: [ :row |
			  each key -> (FamixOpenApiMappingEntry fromRow: row) ] ]
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> bodyEntries [

	^ {
		  ('Parameter' -> self dataParameter).
		  ('Header' -> self dataHeader).
		  ('Response' -> self dataResponse).
		  ('MediaType' -> self dataMediaType) }
]

{ #category : 'api' }
FamixOpenApiFieldMapping class >> classNameFor: aSpecObjectName [
	"Answer the name of the OP class carrying the spec object, or nil when the object has none."

	^ (self dataObjectClassNames
		   detect: [ :each | each first = aSpecObjectName ]
		   ifNone: [ nil ]) ifNotNil: [ :pair | pair last ]
]

{ #category : 'data - paths and operations' }
FamixOpenApiFieldMapping class >> dataCallback [

	^ #( #( '{expression}' implicit pathItems '' 'the path items of the callback, keyed by relativePath' ) )
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> dataCollectionFormatNote [

	^ 'converted to style and explode: csv to form with explode false, multi to form with explode true, ssv to spaceDelimited, pipes to pipeDelimited; tsv gets no style and no explode (both nil, kept only in extensions) (verified by import)'
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> dataDerivedReasons [

	^ #( #( 'OPSchema' 'additionalPropertiesAllowed'
	        'derived: boolean form of additionalProperties' )
	     #( 'OPOperation' 'httpMethod' 'derived: the key of the operation in its path item' )
	     #( 'OPOperation' 'securityDisabled' 'derived: security [] in the source' )
	     #( 'OPLink' 'operation' 'derived: the operation resolved from operationId or operationRef' )
	     #( 'OPOperation' 'usedByLinks' 'inverse relation of OPLink>>operation' ) )
]

{ #category : 'data - root and info' }
FamixOpenApiFieldMapping class >> dataExample [

	^ { (self extensionsOnlyEntry: 'description') }
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> dataHeader [
	"Swagger 2.0 header keywords are not converted to a schema by the importer: see knownImporterGaps."

	^ ((self dataSwagger2InlineKeywords , #( 'collectionFormat' )) collect: [ :each |
		   { each. #note. ''. ''. self dataSwagger2HeaderNote } ])
	  , { (self extensionsOnlyEntry: 'example') }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> dataImporterReasons [

	^ #( #( 'OPCanonicalNode' 'canonicalPointer' 'importer-internal: JSON pointer of the entity in the canonical document' )
	     #( 'OPSourceText' 'sourceText' 'importer-internal: source text kept for traceability' )
	     #( 'OPSchema' 'mergedPointers' 'importer-internal: pointers of identical inline schemas merged into one entity' )
	     #( 'OPSchema' 'subSchemas' 'importer-derived: strict subsets of a schema, not in the source' )
	     #( 'OPSubSchema' 'subSchemaOf' 'importer-derived: strict subsets of a schema, not in the source' )
	     #( 'OPOpenApi' 'unresolvedReferences' 'importer-derived: references that could not be resolved' )
	     #( 'OPReference' 'openApi' 'inverse relation of OPOpenApi>>unresolvedReferences' )
	     #( 'OPOpenApi' 'selfUrl' 'field $self of OpenAPI 3.2, outside the versions of the field table' ) )
]

{ #category : 'data - root and info' }
FamixOpenApiFieldMapping class >> dataInfo [

	^ { (self extensionsOnlyEntry: 'summary') }
]

{ #category : 'data - schemas' }
FamixOpenApiFieldMapping class >> dataItems [

	^ #( #( 'type' map types '' '' ) #( 'default' map defaultValue
	        '' '' ) #( 'enum' map enumValues '' '' ) )
	  , { { 'collectionFormat'. #note. ''. ''. 'kept as extensions JSON text of the items schema (verified by import)' } }
]

{ #category : 'data - root and info' }
FamixOpenApiFieldMapping class >> dataLicense [

	^ { (self extensionsOnlyEntry: 'identifier') }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> dataMapEntryReasons [

	^ #( #( 'OPProperty' '*' 'entry of the Schema properties map: name, value schema and required flag derived from the required list' )
	     #( 'OPSchema' 'usedAsPropertyValueBy' 'inverse relation of OPProperty>>valueSchema' )
	     #( 'OPDiscriminatorMapping' '*' 'entry of the Discriminator mapping map' )
	     #( 'OPSchema' 'usedByDiscriminatorMappings'
	        'inverse relation of OPDiscriminatorMapping>>schema' )
	     #( 'OPSecurityRequirementItem' '*' 'entry of the Security Requirement map: scheme and scopes' )
	     #( 'OPSecurityScheme' 'usedBySecurityRequirementItems'
	        'inverse relation of OPSecurityRequirementItem>>scheme' )
	     #( 'OPEncoding' 'propertyName' 'key of the Encoding map of a Media Type' )
	     #( 'OPSecurityScope' 'description' 'value of the Scopes map entry: the description of the scope' ) )
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> dataMediaType [

	^ { #( 'encoding' map encodings '' '' ). self exampleAsExampleEntry }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> dataModelOnlyReasons [
	"Rows #(declaringClass selector reason) explaining why a slot of the metamodel corresponds to no spec field; selector * stands for every slot of the declaring class."

	^ self dataImporterReasons , self dataDerivedReasons
	  , self dataMapEntryReasons
]

{ #category : 'data - security' }
FamixOpenApiFieldMapping class >> dataOAuthFlows [

	^ #( #( 'implicit' implicit flows '' 'one OAuthFlow per flow, flowType gives the key' )
	     #( 'password' implicit flows '' 'one OAuthFlow per flow, flowType gives the key' )
	     #( 'clientCredentials' implicit flows '' 'one OAuthFlow per flow, flowType gives the key' )
	     #( 'authorizationCode' implicit flows '' 'one OAuthFlow per flow, flowType gives the key' ) )
]

{ #category : 'data - classes' }
FamixOpenApiFieldMapping class >> dataObjectClassNames [
	"Pairs spec object name -> name of the OP class that carries it. The container objects (Paths, Responses, Scopes...) are carried by the class of their entries."

	^ #( #( 'OpenAPI' 'OPOpenApi' ) #( 'Swagger' 'OPOpenApi' )
	     #( 'Info' 'OPInfo' ) #( 'Contact' 'OPContact' )
	     #( 'License' 'OPLicense' ) #( 'Server' 'OPServer' )
	     #( 'ServerVariable' 'OPServerVariable' )
	     #( 'Components' 'OPComponents' )
	     #( 'Paths' 'OPPath' ) #( 'PathItem' 'OPPath' )
	     #( 'Operation' 'OPOperation' ) #( 'ExternalDocumentation'
	        'OPExternalDocumentation' )
	     #( 'Parameter' 'OPParameter' ) #( 'RequestBody' 'OPRequestBody' )
	     #( 'MediaType' 'OPMediaType' ) #( 'Encoding' 'OPEncoding' )
	     #( 'Responses' 'OPResponse' ) #( 'Response' 'OPResponse' )
	     #( 'Callback' 'OPCallback' ) #( 'Example' 'OPExample' )
	     #( 'Link' 'OPLink' ) #( 'Header' 'OPHeader' )
	     #( 'Items' 'OPSchema' ) #( 'Tag' 'OPTag' ) #( 'Reference'
	        'OPReference' ) #( 'Schema' 'OPSchema' )
	     #( 'Discriminator' 'OPDiscriminator' )
	     #( 'XML' 'OPXmlElement' ) #( 'SecurityScheme' 'OPSecurityScheme' )
	     #( 'OAuthFlows' 'OPSecurityScheme' )
	     #( 'OAuthFlow' 'OPOAuthFlow' ) #( 'Scopes' 'OPSecurityScope' )
	     #( 'SecurityRequirement' 'OPSecurityRequirement' ) )
]

{ #category : 'data - root and info' }
FamixOpenApiFieldMapping class >> dataOpenApi [

	^ #( #( 'openapi' map openapiVersion '' 'version of the canonical document' )
	     #( 'security' map securityRequirements '' '' ) )
]

{ #category : 'data - paths and operations' }
FamixOpenApiFieldMapping class >> dataOperation [

	^ #( #( 'tags' map tagNames '' 'names of the tags; the tags relation of the document holds the Tag entities' )
	     #( 'security' map securityRequirements '' '' )
	     #( 'consumes' implicit mediaType OPMediaType 'converted to the media types of the request body' )
	     #( 'produces' implicit mediaType OPMediaType 'converted to the media types of the responses' ) )
	  , { { 'schemes'. #note. ''. ''. 'kept as extensions JSON text of OPOperation, no server (verified by import)' } }
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> dataParameter [

	^ { #( 'in' map location '' '' ). self exampleAsExampleEntry } , self swagger2InlineEntries
]

{ #category : 'data - paths and operations' }
FamixOpenApiFieldMapping class >> dataPathItem [

	^ #( #( '$ref' map ref '' '' ) #( 'get' implicit operations
	        '' 'one Operation per method, httpMethod gives the key' )
	     #( 'put' implicit operations '' 'one Operation per method, httpMethod gives the key' )
	     #( 'post' implicit operations '' 'one Operation per method, httpMethod gives the key' )
	     #( 'delete' implicit operations '' 'one Operation per method, httpMethod gives the key' )
	     #( 'options' implicit operations '' 'one Operation per method, httpMethod gives the key' )
	     #( 'head' implicit operations '' 'one Operation per method, httpMethod gives the key' )
	     #( 'patch' implicit operations '' 'one Operation per method, httpMethod gives the key' )
	     #( 'trace' implicit operations '' 'one Operation per method, httpMethod gives the key' ) )
]

{ #category : 'data - paths and operations' }
FamixOpenApiFieldMapping class >> dataPaths [

	^ #( #( '/{path}' implicit relativePath '' 'the key of the path item' ) )
]

{ #category : 'data - schemas' }
FamixOpenApiFieldMapping class >> dataReference [

	^ #( #( '$ref' implicit target '' 'a reference that cannot be resolved is kept as the target of a Reference; a resolved one is the ref slot of the referenceable entity' ) )
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> dataResponse [

	^ #( #( 'schema' implicit content '' 'Swagger 2.0 schema converted to the schema of the media types of the response' ) )
	  , { (self extensionsOnlyEntry: 'examples') }
]

{ #category : 'data - paths and operations' }
FamixOpenApiFieldMapping class >> dataResponses [

	^ #( #( 'default' implicit statusCode '' 'status code default' )
	     #( '{HTTP status code}' implicit statusCode '' 'the key of the response' ) )
]

{ #category : 'data - schemas' }
FamixOpenApiFieldMapping class >> dataSchema [

	^ #( #( '$ref' map ref '' '' ) #( 'type' map types '' '' )
	     #( 'enum' map enumValues '' '' )
	     #( 'default' map defaultValue '' '' )
	     #( 'example' map exampleValue '' '' )
	     #( 'required' map requiredProperties '' 'the names of the required properties' )
	     #( 'const' map constValue '' '' )
	     #( 'nullable' map isNullable '' '' ) )
	  , self dataSchemaExtensionsOnly
]

{ #category : 'data - schemas' }
FamixOpenApiFieldMapping class >> dataSchemaExtensionsOnly [
	"Keywords of JSON Schema 2020-12 (OpenAPI 3.1) that OPSchema has no slot for."

	^ #( '$id' '$anchor' '$defs' '$dynamicAnchor' '$dynamicRef' 'if' 'then' 'else' 'contains' 'patternProperties' 'propertyNames' 'dependentSchemas' 'dependentRequired' 'maxContains' 'minContains' 'unevaluatedItems' 'unevaluatedProperties' 'examples' '$comment' 'contentEncoding' 'contentMediaType' 'contentSchema' )
		  collect: [ :each | self extensionsOnlyEntry: each ]
]

{ #category : 'data - security' }
FamixOpenApiFieldMapping class >> dataScopes [

	^ #( #( '{name}' implicit name '' 'the name of the scope; its value is the description' ) )
]

{ #category : 'data - security' }
FamixOpenApiFieldMapping class >> dataSecurityRequirement [

	^ #( #( '{name}' implicit items '' 'one item per scheme name, scopeNames gives the scopes' ) )
]

{ #category : 'data - security' }
FamixOpenApiFieldMapping class >> dataSecurityScheme [

	^ #( #( 'in' map inLocation '' '' ) #( 'name' map parameterName
	        '' 'name of the header, query or cookie parameter of an apiKey' )
	     #( 'flow' implicit flowType OPOAuthFlow 'Swagger 2.0 flat flow converted to an OAuthFlow' )
	     #( 'authorizationUrl' implicit authorizationUrl OPOAuthFlow
	        'Swagger 2.0 flat flow converted to an OAuthFlow' )
	     #( 'tokenUrl' implicit tokenUrl OPOAuthFlow 'Swagger 2.0 flat flow converted to an OAuthFlow' )
	     #( 'scopes' implicit scopes OPOAuthFlow 'Swagger 2.0 flat flow converted to an OAuthFlow' ) )
]

{ #category : 'data - root and info' }
FamixOpenApiFieldMapping class >> dataServerVariable [

	^ #( #( 'default' map defaultValue '' '' )
	     #( 'enum' map enumValues '' '' ) )
]

{ #category : 'data - root and info' }
FamixOpenApiFieldMapping class >> dataSwagger [

	^ #( #( 'swagger' map sourceVersion '' 'kept as the version of the source document' )
	     #( 'host' implicit servers '' 'converted to the url of a Server' )
	     #( 'basePath' implicit servers '' 'converted to the url of a Server' )
	     #( 'schemes' implicit servers '' 'converted to the url of a Server' )
	     #( 'consumes' implicit mediaType OPMediaType 'converted to the media types of the request bodies' )
	     #( 'produces' implicit mediaType OPMediaType 'converted to the media types of the responses' )
	     #( 'definitions' implicit schemas OPComponents 'converted to components.schemas' )
	     #( 'parameters' implicit parameters OPComponents 'converted to components.parameters' )
	     #( 'responses' implicit responses OPComponents 'converted to components.responses' )
	     #( 'securityDefinitions' implicit securitySchemes
	        OPComponents 'converted to components.securitySchemes' )
	     #( 'security' map securityRequirements '' '' ) )
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> dataSwagger2HeaderNote [

	^ 'Swagger 2 header keyword: not converted to a schema by the importer; survives only as extensions JSON text (verified by import)'
]

{ #category : 'data - classes' }
FamixOpenApiFieldMapping class >> dataSwagger2InlineKeywords [
	"Names of the Swagger 2.0 keywords of the non-body Parameter and Header objects; the model carries them in the schema of the parameter or header."

	^ #( 'type' 'format' 'items' 'default' 'maximum' 'exclusiveMaximum'
	     'minimum' 'exclusiveMinimum' 'maxLength' 'minLength' 'pattern'
	     'maxItems' 'minItems' 'uniqueItems' 'enum' 'multipleOf' )
]

{ #category : 'api' }
FamixOpenApiFieldMapping class >> defaultSelectorFor: aFieldName [
	"Answer the accessor named after aFieldName when it is a plain identifier, nil for $ref, x-*, {name}, /{path}..."

	^ (self isPlainIdentifier: aFieldName)
		  ifTrue: [ aFieldName asSymbol ]
		  ifFalse: [ nil ]
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> entriesByObject [
	"Answer a Dictionary spec object name -> rows of explicit entries."

	^ (self rootEntries , self pathEntries , self bodyEntries
	   , self schemaEntries , self securityEntries) asDictionary
]

{ #category : 'api' }
FamixOpenApiFieldMapping class >> entryFor: aSpecField [
	"Answer the explicit entry of aSpecField, the shared entry of the x-* extensions, or nil when the field has none and takes its default selector."

	aSpecField name = 'x-*' ifTrue: [
		^ FamixOpenApiMappingEntry extensions ].
	^ (self entriesByObject at: aSpecField specObject ifAbsent: [ #(  ) ])
		  detect: [ :row | row first = aSpecField name ]
		  ifFound: [ :row | FamixOpenApiMappingEntry fromRow: row ]
		  ifNone: [ nil ]
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> exampleAsExampleEntry [

	^ #( 'example' implicit examples '' 'converted to an OPExample named example in examples (verified by import)' )
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> extensionsOnlyEntry: aFieldName [
	"Answer the annotation-only entry of a field that the metamodel has no slot for and whose value survives only as extensions JSON text. The status stays computed: the note is used only while the metamodel lacks the slot."

	^ { aFieldName. #note. ''. ''. self extensionsOnlyNote }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> extensionsOnlyNote [

	^ 'kept as extensions JSON text (verified by import)'
]

{ #category : 'api' }
FamixOpenApiFieldMapping class >> isPlainIdentifier: aFieldName [

	^ aFieldName isNotEmpty and: [
		  aFieldName first isLetter and: [
			  aFieldName allSatisfy: [ :each | each isAlphaNumeric ] ] ]
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> knownImporterGaps [
	"Documentation of findings about the importer, established by importing real documents. The validation package does not reference the importer: these are data only."

	^ #( 'Swagger 2 Header keywords are not converted to a schema (importer fidelity gap, to be handled in the import-fidelity step)' )
]

{ #category : 'api' }
FamixOpenApiFieldMapping class >> modelOnlyReasonFor: aModelSlot [
	"Answer why aModelSlot corresponds to no spec field, or nil when it is not explained by the data."

	^ self dataModelOnlyReasons
		  detect: [ :row |
			  row first = aModelSlot declaringClassName asString and: [
				  row second = '*' or: [
					  row second = aModelSlot selector asString ] ] ]
		  ifFound: [ :row | row third ]
		  ifNone: [ nil ]
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> pathEntries [

	^ {
		  ('Paths' -> self dataPaths).
		  ('PathItem' -> self dataPathItem).
		  ('Operation' -> self dataOperation).
		  ('Responses' -> self dataResponses).
		  ('Callback' -> self dataCallback) }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> rootEntries [

	^ {
		  ('OpenAPI' -> self dataOpenApi).
		  ('Swagger' -> self dataSwagger).
		  ('Info' -> self dataInfo).
		  ('License' -> self dataLicense).
		  ('Example' -> self dataExample).
		  ('ServerVariable' -> self dataServerVariable) }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> schemaEntries [

	^ {
		  ('Items' -> self dataItems).
		  ('Reference' -> self dataReference).
		  ('Schema' -> self dataSchema) }
]

{ #category : 'data - tables' }
FamixOpenApiFieldMapping class >> securityEntries [

	^ {
		  ('SecurityScheme' -> self dataSecurityScheme).
		  ('OAuthFlows' -> self dataOAuthFlows).
		  ('Scopes' -> self dataScopes).
		  ('SecurityRequirement' -> self dataSecurityRequirement) }
]

{ #category : 'data - bodies and parameters' }
FamixOpenApiFieldMapping class >> swagger2InlineEntries [
	"Entries of the Swagger 2.0 keywords of a non-body Parameter: carried by the schema of the parameter."

	^ (self dataSwagger2InlineKeywords collect: [ :each |
		   {
			   each.
			   #implicit.
			   #schema.
			   ''.
			   'Swagger 2.0 keyword carried by the schema of the parameter' } ])
	  , { { 'collectionFormat'. #implicit. #style. ''. self dataCollectionFormatNote } }
]
