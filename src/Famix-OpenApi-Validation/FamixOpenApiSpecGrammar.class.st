"
I am the declarative grammar of OpenAPI 3.0.3 (#v30), OpenAPI 3.1.x (#v31) and Swagger 2.0 (#v2): for every non-scalar field of FamixOpenApiSpecFieldTable I say which spec object the child is (FamixOpenApiGrammarEdge). The data lives in one class-side method per spec object (protocols 'data - ...'), each answering literal rows #(field kind target versions). Fields of kind scalar need no row (they have the implicit shape #scalar); the 'x-*' extension rows are derived from the field table as #any edges. I know no model class: I only read the field table. API: allEdges, edgesFor:in:, edgeFor:field:in:, edgeForKey:in:version:, rootObjectNameIn:, edgeCountIn:, reset.
"
Class {
	#name : 'FamixOpenApiSpecGrammar',
	#superclass : 'Object',
	#classInstVars : [
		'index'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> allEdges [
	"Answer the scalar edges, the declared edges and the extension edges, in this order (a later edge replaces an earlier one of the same field in the index)"

	^ self scalarEdges , self declaredEdges , self extensionEdges
]

{ #category : 'private' }
FamixOpenApiSpecGrammar class >> buildIndex [

	| built |
	built := Dictionary new.
	self allEdges do: [ :edge |
		edge versions do: [ :version |
			((built at: version ifAbsentPut: [ Dictionary new ])
				 at: edge specObject
				 ifAbsentPut: [ OrderedDictionary new ]) at: edge name put: edge ] ].
	^ built
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataCallback [
	"Patterned field: each runtime expression is a PathItem"

	^ #( #( '{expression}' object 'PathItem' #( v30 v31 ) ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecGrammar class >> dataComponents [

	^ #( #( 'schemas' map 'Schema' #( v30 v31 ) )
	     #( 'responses' map 'Response' #( v30 v31 ) )
	     #( 'parameters' map 'Parameter' #( v30 v31 ) )
	     #( 'examples' map 'Example' #( v30 v31 ) )
	     #( 'requestBodies' map 'RequestBody' #( v30 v31 ) )
	     #( 'headers' map 'Header' #( v30 v31 ) )
	     #( 'securitySchemes' map 'SecurityScheme' #( v30 v31 ) )
	     #( 'links' map 'Link' #( v30 v31 ) )
	     #( 'callbacks' map 'Callback' #( v30 v31 ) )
	     #( 'pathItems' map 'PathItem' #( v31 ) ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecGrammar class >> dataDiscriminator [

	^ #( #( 'mapping' mapOfScalars nil #( v30 v31 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataEncoding [

	^ #( #( 'headers' map 'Header' #( v30 v31 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataExample [
	"3.x: value is free JSON. Swagger 2: the patterned field is a mime type holding free JSON"

	^ #( #( 'value' any nil #( v30 v31 ) )
	     #( '{mime type}' any nil #( v2 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataHeader [

	^ #( #( 'schema' object 'Schema' #( v30 v31 ) )
	     #( 'example' any nil #( v30 v31 ) )
	     #( 'examples' map 'Example' #( v30 v31 ) )
	     #( 'content' map 'MediaType' #( v30 v31 ) )
	     #( 'items' object 'Items' #( v2 ) )
	     #( 'default' any nil #( v2 ) ) #( 'enum' any nil #( v2 ) ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecGrammar class >> dataInfo [

	^ #( #( 'contact' object 'Contact' #( v30 v31 v2 ) )
	     #( 'license' object 'License' #( v30 v31 v2 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataItems [
	"Swagger 2 Items object; recursive through items"

	^ #( #( 'items' object 'Items' #( v2 ) )
	     #( 'default' any nil #( v2 ) ) #( 'enum' any nil #( v2 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataLink [

	^ #( #( 'parameters' mapOfAny nil #( v30 v31 ) )
	     #( 'requestBody' any nil #( v30 v31 ) )
	     #( 'server' object 'Server' #( v30 v31 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataMediaType [

	^ #( #( 'schema' object 'Schema' #( v30 v31 ) )
	     #( 'example' any nil #( v30 v31 ) )
	     #( 'examples' map 'Example' #( v30 v31 ) )
	     #( 'encoding' map 'Encoding' #( v30 v31 ) ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecGrammar class >> dataOAuthFlow [

	^ #( #( 'scopes' mapOfScalars nil #( v30 v31 ) ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecGrammar class >> dataOAuthFlows [

	^ #( #( 'implicit' object 'OAuthFlow' #( v30 v31 ) )
	     #( 'password' object 'OAuthFlow' #( v30 v31 ) )
	     #( 'clientCredentials' object 'OAuthFlow' #( v30 v31 ) )
	     #( 'authorizationCode' object 'OAuthFlow' #( v30 v31 ) ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecGrammar class >> dataOpenApi [
	"Root object of OpenAPI 3.x. Row: field kind target versions"

	^ #( #( 'info' object 'Info' #( v30 v31 ) )
	     #( 'servers' array 'Server' #( v30 v31 ) )
	     #( 'components' object 'Components' #( v30 v31 ) )
	     #( 'paths' object 'Paths' #( v30 v31 ) )
	     #( 'webhooks' map 'PathItem' #( v31 ) )
	     #( 'security' array 'SecurityRequirement' #( v30 v31 ) )
	     #( 'tags' array 'Tag' #( v30 v31 ) )
	     #( 'externalDocs' object 'ExternalDocumentation'
	        #( v30 v31 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataOperation [

	^ #( #( 'tags' arrayOfScalars nil #( v30 v31 v2 ) )
	     #( 'externalDocs' object 'ExternalDocumentation'
	        #( v30 v31 v2 ) )
	     #( 'parameters' array 'Parameter' #( v30 v31 v2 ) )
	     #( 'requestBody' object 'RequestBody' #( v30 v31 ) )
	     #( 'responses' object 'Responses' #( v30 v31 v2 ) )
	     #( 'callbacks' map 'Callback' #( v30 v31 ) )
	     #( 'security' array 'SecurityRequirement' #( v30 v31 v2 ) )
	     #( 'servers' array 'Server' #( v30 v31 ) )
	     #( 'consumes' arrayOfScalars nil #( v2 ) )
	     #( 'produces' arrayOfScalars nil #( v2 ) )
	     #( 'schemes' arrayOfScalars nil #( v2 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataParameter [

	^ #( #( 'schema' object 'Schema' #( v30 v31 v2 ) )
	     #( 'example' any nil #( v30 v31 ) )
	     #( 'examples' map 'Example' #( v30 v31 ) )
	     #( 'content' map 'MediaType' #( v30 v31 ) )
	     #( 'items' object 'Items' #( v2 ) )
	     #( 'default' any nil #( v2 ) ) #( 'enum' any nil #( v2 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataPathItem [

	^ #( #( 'get' object 'Operation' #( v30 v31 v2 ) )
	     #( 'put' object 'Operation' #( v30 v31 v2 ) )
	     #( 'post' object 'Operation' #( v30 v31 v2 ) )
	     #( 'delete' object 'Operation' #( v30 v31 v2 ) )
	     #( 'options' object 'Operation' #( v30 v31 v2 ) )
	     #( 'head' object 'Operation' #( v30 v31 v2 ) )
	     #( 'patch' object 'Operation' #( v30 v31 v2 ) )
	     #( 'trace' object 'Operation' #( v30 v31 ) )
	     #( 'servers' array 'Server' #( v30 v31 ) )
	     #( 'parameters' array 'Parameter' #( v30 v31 v2 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataPaths [
	"Patterned field: each key '/...' is a PathItem"

	^ #( #( '/{path}' object 'PathItem' #( v30 v31 v2 ) ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecGrammar class >> dataReference [
	"A node holding $ref is a Reference: the walker reports it and does not follow it"

	^ #( #( '$ref' reference nil #( v30 v31 v2 ) ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecGrammar class >> dataRequestBody [

	^ #( #( 'content' map 'MediaType' #( v30 v31 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataResponse [

	^ #( #( 'headers' map 'Header' #( v30 v31 v2 ) )
	     #( 'content' map 'MediaType' #( v30 v31 ) )
	     #( 'links' map 'Link' #( v30 v31 ) )
	     #( 'schema' object 'Schema' #( v2 ) )
	     #( 'examples' object 'Example' #( v2 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataResponses [
	"'default' is a fixed field; the HTTP status codes are a patterned field"

	^ #( #( 'default' object 'Response' #( v30 v31 v2 ) )
	     #( '{HTTP status code}' object 'Response' #( v30 v31 v2 ) ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecGrammar class >> dataSchema [
	"Fields of Schema common to the three versions"

	^ #( #( 'required' arrayOfScalars nil #( v30 v31 v2 ) )
	     #( 'enum' any nil #( v30 v31 v2 ) )
	     #( 'allOf' array 'Schema' #( v30 v31 v2 ) )
	     #( 'items' object 'Schema' #( v30 v31 v2 ) )
	     #( 'properties' map 'Schema' #( v30 v31 v2 ) )
	     #( 'additionalProperties' object 'Schema' #( v30 v31 v2 ) )
	     #( 'default' any nil #( v30 v31 v2 ) )
	     #( 'xml' object 'XML' #( v30 v31 v2 ) )
	     #( 'externalDocs' object 'ExternalDocumentation'
	        #( v30 v31 v2 ) )
	     #( 'example' any nil #( v30 v31 v2 ) ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecGrammar class >> dataSchemaV31Only [
	"Fields of Schema that only exist in OpenAPI 3.1 (JSON Schema 2020-12)"

	^ #( #( '$dynamicRef' reference nil #( v31 ) )
	     #( '$vocabulary' mapOfScalars nil #( v31 ) )
	     #( '$defs' map 'Schema' #( v31 ) )
	     #( 'prefixItems' array 'Schema' #( v31 ) )
	     #( 'contains' object 'Schema' #( v31 ) )
	     #( 'patternProperties' map 'Schema' #( v31 ) )
	     #( 'dependentSchemas' map 'Schema' #( v31 ) )
	     #( 'propertyNames' object 'Schema' #( v31 ) )
	     #( 'if' object 'Schema' #( v31 ) )
	     #( 'then' object 'Schema' #( v31 ) )
	     #( 'else' object 'Schema' #( v31 ) )
	     #( 'unevaluatedItems' object 'Schema' #( v31 ) )
	     #( 'unevaluatedProperties' object 'Schema' #( v31 ) )
	     #( 'const' any nil #( v31 ) ) #( 'dependentRequired'
	        mapOfArrays nil #( v31 ) )
	     #( 'contentSchema' object 'Schema' #( v31 ) )
	     #( 'examples' any nil #( v31 ) ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecGrammar class >> dataSchemaVariants [
	"Fields of Schema of OpenAPI 3.x and the $ref field kept by the table"

	^ #( #( '$ref' reference nil #( v31 v2 ) )
	     #( 'oneOf' array 'Schema' #( v30 v31 ) )
	     #( 'anyOf' array 'Schema' #( v30 v31 ) )
	     #( 'not' object 'Schema' #( v30 v31 ) )
	     #( 'discriminator' object 'Discriminator' #( v30 v31 ) ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecGrammar class >> dataScopes [
	"Swagger 2 Scopes object: every key is a scope name holding a description. The field table has no row for this patterned field"

	^ #( #( '{name}' scalar nil #( v2 ) ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecGrammar class >> dataSecurityRequirement [
	"Patterned field: each key is a scheme name holding an array of scope names"

	^ #( #( '{name}' arrayOfScalars nil #( v30 v31 v2 ) ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecGrammar class >> dataSecurityScheme [
	"3.x: flows is an OAuthFlows object. Swagger 2: scopes is a Scopes object"

	^ #( #( 'flows' object 'OAuthFlows' #( v30 v31 ) )
	     #( 'scopes' object 'Scopes' #( v2 ) ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecGrammar class >> dataServer [

	^ #( #( 'variables' map 'ServerVariable' #( v30 v31 ) ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecGrammar class >> dataServerVariable [

	^ #( #( 'enum' any nil #( v30 v31 ) ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecGrammar class >> dataSwagger [
	"Root object of Swagger 2.0. Row: field kind target versions"

	^ #( #( 'info' object 'Info' #( v2 ) )
	     #( 'schemes' arrayOfScalars nil #( v2 ) )
	     #( 'consumes' arrayOfScalars nil #( v2 ) )
	     #( 'produces' arrayOfScalars nil #( v2 ) )
	     #( 'paths' object 'Paths' #( v2 ) )
	     #( 'definitions' map 'Schema' #( v2 ) )
	     #( 'parameters' map 'Parameter' #( v2 ) )
	     #( 'responses' map 'Response' #( v2 ) )
	     #( 'securityDefinitions' map 'SecurityScheme' #( v2 ) )
	     #( 'security' array 'SecurityRequirement' #( v2 ) )
	     #( 'tags' array 'Tag' #( v2 ) ) #( 'externalDocs' object 'ExternalDocumentation'
	        #( v2 ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiSpecGrammar class >> dataTag [

	^ #( #( 'externalDocs' object 'ExternalDocumentation'
	        #( v30 v31 v2 ) ) )
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> declaredEdgeCountIn: aVersionSymbol [
	"The number of edges written in the data methods (the extension edges excluded) existing in the version"

	^ self declaredEdges count: [ :each | each appliesIn: aVersionSymbol ]
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> declaredEdges [
	"Answer the edges written in the data methods"

	^ Array streamContents: [ :stream |
		  self edgeRows do: [ :association |
			  association value do: [ :row |
				  stream nextPut:
					  (FamixOpenApiGrammarEdge
						   fromRow: row
						   specObject: association key) ] ] ]
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> edgeCountIn: aVersionSymbol [
	"The number of non-scalar edges (declared and extension) existing in the version"

	^ self allEdges count: [ :each |
		  each isScalar not and: [ each appliesIn: aVersionSymbol ] ]
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> edgeFor: aSpecObjectName field: aFieldName in: aVersionSymbol [
	"Answer the edge declared for this field, or the unknown edge (isUnknown) when there is none"

	^ (self fieldIndexFor: aSpecObjectName version: aVersionSymbol)
		  at: aFieldName
		  ifAbsent: [ FamixOpenApiGrammarEdge unknown ]
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> edgeForKey: aKey in: aSpecObjectName version: aVersionSymbol [
	"Answer the edge describing the key aKey of an object: its fixed field, else the extension edge for an x- key when the object accepts extensions, else the patterned field that matches, else the unknown edge"

	| edges |
	edges := self fieldIndexFor: aSpecObjectName version: aVersionSymbol.
	^ edges
		  at: aKey
		  ifAbsent: [ self edgeForOtherKey: aKey among: edges ]
]

{ #category : 'private' }
FamixOpenApiSpecGrammar class >> edgeForOtherKey: aKey among: aFieldDictionary [

	(aKey beginsWith: 'x-') ifTrue: [
		aFieldDictionary at: 'x-*' ifPresent: [ :edge | ^ edge ] ].
	^ aFieldDictionary
		  detect: [ :each | each isPatterned and: [ each matchesKey: aKey ] ]
		  ifNone: [ FamixOpenApiGrammarEdge unknown ]
]

{ #category : 'data - registry' }
FamixOpenApiSpecGrammar class >> edgeRows [
	"Answer associations spec object name -> rows of declared edges, for every spec object that has non-scalar fields"

	^ {
		  ('OpenAPI' -> self dataOpenApi).
		  ('Swagger' -> self dataSwagger).
		  ('Info' -> self dataInfo).
		  ('Server' -> self dataServer).
		  ('ServerVariable' -> self dataServerVariable).
		  ('Components' -> self dataComponents).
		  ('Paths' -> self dataPaths).
		  ('PathItem' -> self dataPathItem).
		  ('Operation' -> self dataOperation).
		  ('Parameter' -> self dataParameter).
		  ('RequestBody' -> self dataRequestBody).
		  ('MediaType' -> self dataMediaType).
		  ('Encoding' -> self dataEncoding).
		  ('Responses' -> self dataResponses).
		  ('Response' -> self dataResponse).
		  ('Callback' -> self dataCallback).
		  ('Example' -> self dataExample).
		  ('Link' -> self dataLink).
		  ('Header' -> self dataHeader).
		  ('Items' -> self dataItems).
		  ('Tag' -> self dataTag).
		  ('Reference' -> self dataReference).
		  ('Schema' -> self schemaRows).
		  ('Discriminator' -> self dataDiscriminator).
		  ('SecurityScheme' -> self dataSecurityScheme).
		  ('OAuthFlows' -> self dataOAuthFlows).
		  ('OAuthFlow' -> self dataOAuthFlow).
		  ('Scopes' -> self dataScopes).
		  ('SecurityRequirement' -> self dataSecurityRequirement) }
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> edgesFor: aSpecObjectName in: aVersionSymbol [

	^ (self fieldIndexFor: aSpecObjectName version: aVersionSymbol)
		  values
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> extensionEdges [
	"Answer the #any edge of every x-* row of the field table"

	^ FamixOpenApiSpecFieldTable allFields
		  select: [ :each | each name = 'x-*' ]
		  thenCollect: [ :each |
			  FamixOpenApiGrammarEdge
				  extensionOf: each specObject
				  versions: each versions ]
]

{ #category : 'private' }
FamixOpenApiSpecGrammar class >> fieldIndexFor: aSpecObjectName version: aVersionSymbol [
	"Answer the Dictionary field name -> edge of the object in the version (empty when it has none)"

	^ (self index at: aVersionSymbol ifAbsent: [ ^ Dictionary new ])
		  at: aSpecObjectName
		  ifAbsent: [ Dictionary new ]
]

{ #category : 'private' }
FamixOpenApiSpecGrammar class >> index [
	"Dictionary version -> (Dictionary spec object -> (Dictionary field name -> edge)), built once"

	^ index ifNil: [ index := self buildIndex ]
]

{ #category : 'class initialization' }
FamixOpenApiSpecGrammar class >> reset [
	"Forget the index built from the data methods"

	index := nil
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> rootObjectNameIn: aVersionSymbol [
	"The spec object of the root of a document"

	^ aVersionSymbol = #v2
		  ifTrue: [ 'Swagger' ]
		  ifFalse: [ 'OpenAPI' ]
]

{ #category : 'api' }
FamixOpenApiSpecGrammar class >> scalarEdges [
	"Answer the #scalar edge of every field of kind scalar of the field table"

	^ FamixOpenApiSpecFieldTable allFields
		  select: [ :each | each kind = #scalar ]
		  thenCollect: [ :each |
			  FamixOpenApiGrammarEdge
				  fromRow: {
						  each name.
						  #scalar.
						  nil.
						  each versions }
				  specObject: each specObject ]
]

{ #category : 'data - registry' }
FamixOpenApiSpecGrammar class >> schemaRows [

	^ self dataSchema , self dataSchemaVariants , self dataSchemaV31Only
]
