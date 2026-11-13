"
The table of the relation check (FamixOpenApiRelationCheck), written as data, one small method per group of spec objects: #rules answers a FamixOpenApiRelationRule per row (the relation of the model, the derivation of its targets from the source, the versions, the compare mode). The rows are written from the conformance rows (FamixOpenApiMetamodelConformance: the relations and the implicit structure that V8 and V9 deferred) and from import experiments (every derivation says in its class comment what was VERIFIED). #reasonNotComparedFor: says, for a conformance row, why the relation check does not compare it (nil when a rule carries it) and #notComparedRows lists them with the reason.
"
Class {
	#name : 'FamixOpenApiRelationRules',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data - document' }
FamixOpenApiRelationRules class >> dataComponents [
	"The sections of the components of OpenAPI 3"

	^ #( #( 'Components' 'OPComponents' #( node ) 'Components'
	        #( #( 'schemas' schemas 'OPSchema' children #( 'schemas' )
	              #( v30 v31 ) )
	           #( 'responses' responses 'OPResponse' children #( 'responses' )
	              #( v30 v31 ) )
	           #( 'parameters' parameters 'OPParameter' children #( 'parameters' )
	              #( v30 v31 ) )
	           #( 'examples' examples 'OPExample' children #( 'examples' )
	              #( v30 v31 ) )
	           #( 'requestBodies' requestBodies 'OPRequestBody'
	              children #( 'requestBodies' ) #( v30 v31 ) )
	           #( 'headers' headers 'OPHeader' children #( 'headers' )
	              #( v30 v31 ) )
	           #( 'securitySchemes' securitySchemes 'OPSecurityScheme'
	              children #( 'securitySchemes' ) #( v30 v31 ) )
	           #( 'links' links 'OPLink' children #( 'links' )
	              #( v30 v31 ) )
	           #( 'callbacks' callbacks 'OPCallback' children #( 'callbacks' )
	              #( v30 v31 ) )
	           #( 'pathItems' pathItems 'OPPath' children #( 'pathItems' )
	              #( v31 ) ) ) ) )
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> dataDeferrals [
	"Rows: spec object, field, reason, for the relation and implicit structure rows of the conformance that no rule carries"

	^ #(  )
]

{ #category : 'data - schemas and security' }
FamixOpenApiRelationRules class >> dataDiscriminator [
	"The discriminators and the entries of their mapping (entities without node)"

	^ #( #( 'Discriminator' 'OPDiscriminator' #( node ) 'Discriminator'
	        #( #( 'mapping' mapping 'OPDiscriminatorMapping'
	              synthetic #( 'mapping' ) #( v30 v31 ) ) ) )
	     #( 'Discriminator' 'OPDiscriminatorMapping'
	        #( synthetic #( discriminatorMappingEntry ) )
	        'Discriminator' #( #( 'mapping' schema 'OPSchema' mappingTarget
	              #(  ) #( v30 v31 ) #(  ) ) ) ) )
]

{ #category : 'data - bodies' }
FamixOpenApiRelationRules class >> dataEncodingAndResponse [
	"The encodings, the responses (the media types of a response of Swagger 2 are derived from produces), the callbacks and the links"

	^ #( #( 'Encoding' 'OPEncoding' #( node ) 'Encoding' #( #( 'headers'
	              headers 'OPHeader' children #( 'headers' )
	              #( v30 v31 ) ) ) )
	     #( 'Response' 'OPResponse' #( node ) 'Response' #( #( 'headers'
	              headers 'OPHeader' children #( 'headers' )
	              #( v30 v31 v2 ) )
	           #( 'content' content 'OPMediaType' children #( 'content' )
	              #( v30 v31 ) )
	           #( 'content' content 'OPMediaType' synthetic #( 'content' )
	              #( v2 ) #( 'Swagger.consumes' 'Swagger.produces'
	                 'Operation.produces' ) )
	           #( 'links' links 'OPLink' children #( 'links' )
	              #( v30 v31 ) ) ) )
	     #( 'Callback' 'OPCallback' #( node ) 'Callback' #( #( '{expression}'
	              pathItems 'OPPath' directChildren #( '{expression}' )
	              #( v30 v31 ) ) ) )
	     #( 'Link' 'OPLink' #( node ) 'Link' #( #( 'server' server 'OPServer'
	              children #( 'server' ) #( v30 v31 ) )
	           #( 'operationId' operation 'OPOperation' linkOperation
	              #(  ) #( v30 v31 ) #( 'operationId' 'operationRef' ) ) ) ) )
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> dataGroups [
	"Every group of rows, see #dataOpenApi"

	^ self dataOpenApi , self dataSwagger , self dataInfoAndServers
	  , self dataComponents , self dataPathItem , self dataOperation
	  , self dataParameter , self dataHeader , self dataRequestBody
	  , self dataMediaType , self dataEncodingAndResponse
	  , self dataSchema , self dataDiscriminator , self dataSecurity
	  , self dataTag
]

{ #category : 'data - bodies' }
FamixOpenApiRelationRules class >> dataHeader [
	"The headers (OpenAPI 3: the header of Swagger 2 is not converted to a schema; the model has no examples for a header)"

	^ #( #( 'Header' 'OPHeader' #( node ) 'Header' #( #( 'schema'
	              schema 'OPSchema' children #( 'schema' ) #( v30 v31 ) ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiRelationRules class >> dataInfoAndServers [
	"Info (contact, license) and Server (variables)"

	^ #( #( 'Info' 'OPInfo' #( node ) 'Info' #( #( 'contact' contact
	              'OPContact' children #( 'contact' ) #( v30 v31 v2 ) )
	           #( 'license' license 'OPLicense' children #( 'license' )
	              #( v30 v31 v2 ) ) ) )
	     #( 'Server' 'OPServer' #( node ) 'Server' #( #( 'variables'
	              variables 'OPServerVariable' children #( 'variables' )
	              #( v30 v31 ) ) ) ) )
]

{ #category : 'data - bodies' }
FamixOpenApiRelationRules class >> dataMediaType [
	"The media types: those of OpenAPI 3 are nodes, those of Swagger 2 are derived from produces and consumes; their schema is the one of the response (Response.schema) or of the body parameter"

	^ #( #( 'MediaType' 'OPMediaType' #( node ) 'MediaType' #( #( 'schema'
	              schema 'OPSchema' children #( 'schema' ) #( v30 v31 ) )
	           #( 'examples' examples 'OPExample' sequence #( #( syntheticAt
	                    #( 'example' ) ) #( children #( 'examples' ) ) )
	              #( v30 v31 ) #( 'example' 'examples' ) )
	           #( 'encoding' encodings 'OPEncoding' children #( 'encoding' )
	              #( v30 v31 ) ) ) )
	     #( 'MediaType' 'OPMediaType' #( synthetic #( swagger2MediaType
	              swagger2FormDataRequestBody cloneSubtree ) )
	        'MediaType' #( #( 'schema' schema 'OPSchema' mediaTypeSchema
	              #(  ) #( v2 ) #( 'Response.schema' ) ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiRelationRules class >> dataOpenApi [
	"Groups: the root of an OpenAPI 3 document. Group: spec object, OP class of the owners, kind of owners, spec object of the conformance rows, rows (field key, selector, OP class of the targets, derivation, arguments, versions, conformance fields carried, compare mode)"

	^ #( #( 'OpenAPI' 'OPOpenApi' #( node ) 'OpenAPI' #( #( 'info' info
	              'OPInfo' children #( 'info' ) #( v30 v31 ) )
	           #( 'servers' servers 'OPServer' servers #(  ) #( v30 v31 ) )
	           #( 'components' components 'OPComponents' children
	              #( 'components' ) #( v30 v31 ) )
	           #( 'paths' paths 'OPPath' container #( 'paths' )
	              #( v30 v31 ) )
	           #( 'security' securityRequirements 'OPSecurityRequirement'
	              children #( 'security' ) #( v30 v31 ) )
	           #( 'tags' tags 'OPTag' children #( 'tags' ) #( v30 v31 ) )
	           #( 'externalDocs' externalDocs 'OPExternalDocumentation'
	              children #( 'externalDocs' ) #( v30 v31 ) )
	           #( 'webhooks' webhooks 'OPPath' children #( 'webhooks' )
	              #( v31 ) ) ) )
	     #( 'OpenAPI' 'OPOpenApi' #( node ) 'Reference' #( #( '$ref'
	              unresolvedReferences 'OPReference' unresolved
	              #(  ) #( v30 v31 ) #( '$ref' ) set ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiRelationRules class >> dataOperation [
	"The operations (the request body of Swagger 2 is its first body parameter, or the form made of its formData parameters)"

	^ #( #( 'Operation' 'OPOperation' #( node ) 'Operation' #( #( 'externalDocs'
	              externalDocs 'OPExternalDocumentation'
	              children #( 'externalDocs' ) #( v30 v31 v2 ) )
	           #( 'parameters' parameters 'OPParameter' children #( 'parameters' )
	              #( v30 v31 v2 ) )
	           #( 'requestBody' requestBody 'OPRequestBody'
	              children #( 'requestBody' ) #( v30 v31 ) )
	           #( 'requestBody' requestBody 'OPRequestBody'
	              sequence #( #( children #( 'parameters' ) )
	                 #( syntheticAt #( 'requestBody' ) ) )
	              #( v2 ) #(  ) )
	           #( 'responses' responses 'OPResponse' container #( 'responses' )
	              #( v30 v31 v2 ) )
	           #( 'callbacks' callbacks 'OPCallback' children #( 'callbacks' )
	              #( v30 v31 ) )
	           #( 'security' securityRequirements 'OPSecurityRequirement'
	              children #( 'security' ) #( v30 v31 v2 ) )
	           #( 'servers' servers 'OPServer' children #( 'servers' )
	              #( v30 v31 ) ) ) ) )
]

{ #category : 'data - bodies' }
FamixOpenApiRelationRules class >> dataParameter [
	"The parameters (the OPRequestBody of a body parameter of Swagger 2 has its media types derived: the consumes of its operation)"

	^ #( #( 'Parameter' 'OPParameter' #( node ) 'Parameter' #( #( 'schema'
	              schema 'OPSchema' parameterSchema #( 'schema' ) #( v30 v31 v2 ) )
	           #( 'examples' examples 'OPExample' sequence #( #( syntheticAt
	                    #( 'example' ) ) #( children #( 'examples' ) ) )
	              #( v30 v31 ) #( 'example' 'examples' ) )
	           #( 'content' content 'OPMediaType' children #( 'content' )
	              #( v30 v31 ) ) ) )
	     #( 'Parameter' 'OPRequestBody' #( node ) 'Parameter' #( #( 'content'
	              content 'OPMediaType' synthetic #( 'content' )
	              #( v2 ) #( 'Operation.consumes' ) ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiRelationRules class >> dataPathItem [
	"The path items: servers, parameters and operations (in the order of the document)"

	^ #( #( 'PathItem' 'OPPath' #( node ) 'PathItem' #( #( 'servers'
	              servers 'OPServer' children #( 'servers' )
	              #( v30 v31 ) )
	           #( 'parameters' parameters 'OPParameter' children #( 'parameters' )
	              #( v30 v31 v2 ) )
	           #( 'operations' operations 'OPOperation' directChildren
	              #( 'get' 'put' 'post' 'delete' 'options' 'head' 'patch'
	                 'trace' )
	              #( v30 v31 v2 ) #( 'get' 'put' 'post' 'delete' 'options'
	                 'head' 'patch' 'trace' ) ) ) ) )
]

{ #category : 'data - bodies' }
FamixOpenApiRelationRules class >> dataRequestBody [
	"The request bodies, the one of the form parameters of Swagger 2 included (an entity without node)"

	^ #( #( 'RequestBody' 'OPRequestBody' #( node ) 'RequestBody'
	        #( #( 'content' content 'OPMediaType' children #( 'content' )
	              #( v30 v31 ) ) ) )
	     #( 'RequestBody' 'OPRequestBody' #( synthetic #( swagger2FormDataRequestBody ) )
	        'RequestBody' #( #( 'content' content 'OPMediaType'
	              synthetic #( 'content' ) #( v2 ) #(  ) ) ) ) )
]

{ #category : 'data - schemas and security' }
FamixOpenApiRelationRules class >> dataSchema [
	"The schemas: the keywords that hold schemas, the xml, the external documentation and the discriminator (a node of OpenAPI 3, derived in Swagger 2); an alias (a $ref that has an entity) holds its target in allOf; the items of a typed parameter of Swagger 2 are the items of the schema it makes"

	^ #( #( 'Schema' 'OPSchema' #( node ) 'Schema' #( #( 'allOf' allOf
	              'OPSchema' sequence #( #( alias #(  ) )
	                 #( children #( 'allOf' ) ) )
	              #( v30 v31 v2 ) )
	           #( 'oneOf' oneOf 'OPSchema' children #( 'oneOf' )
	              #( v30 v31 ) )
	           #( 'anyOf' anyOf 'OPSchema' children #( 'anyOf' )
	              #( v30 v31 ) )
	           #( 'not' not 'OPSchema' children #( 'not' ) #( v30 v31 ) )
	           #( 'items' items 'OPSchema' children #( 'items' )
	              #( v30 v31 v2 ) #( 'items' 'Items.items' 'Parameter.items' ) )
	           #( 'prefixItems' prefixItems 'OPSchema' children #( 'prefixItems' )
	              #( v31 ) )
	           #( 'properties' properties 'OPProperty' children #( 'properties' )
	              #( v30 v31 v2 ) )
	           #( 'additionalProperties' additionalProperties
	              'OPSchema' children #( 'additionalProperties' )
	              #( v30 v31 v2 ) )
	           #( 'xml' xml 'OPXmlElement' children #( 'xml' ) #( v30 v31
	                 v2 ) )
	           #( 'externalDocs' externalDocs 'OPExternalDocumentation'
	              children #( 'externalDocs' ) #( v30 v31 v2 ) )
	           #( 'discriminator' discriminator 'OPDiscriminator'
	              sequence #( #( children #( 'discriminator' ) )
	                 #( syntheticAt #( 'discriminator' ) ) )
	              #( v30 v31 v2 ) ) ) )
	     #( 'Schema' 'OPProperty' #( property ) 'Schema' #( #( 'properties'
	              valueSchema 'OPSchema' propertyValue #(  ) #( v30 v31
	                 v2 ) #(  ) ) ) ) )
]

{ #category : 'data - schemas and security' }
FamixOpenApiRelationRules class >> dataSecurity [
	"The security requirements and their items (entities without node), the security schemes and their flows and scopes (Swagger 2: the oauth2 scheme is also its only flow)"

	^ #( #( 'SecurityRequirement' 'OPSecurityRequirement'
	        #( node ) 'SecurityRequirement' #( #( '{name}' items 'OPSecurityRequirementItem'
	              synthetic #( '' ) #( v30 v31 v2 ) ) ) )
	     #( 'SecurityRequirement' 'OPSecurityRequirementItem'
	        #( synthetic #( securityRequirementItem ) )
	        'SecurityRequirement' #( #( '{name}' scheme 'OPSecurityScheme'
	              requirementScheme #(  ) #( v30 v31 v2 ) #(  ) ) ) )
	     #( 'SecurityScheme' 'OPSecurityScheme' #( node ) 'SecurityScheme'
	        #( #( 'flows' flows 'OPOAuthFlow' container #( 'flows' )
	              #( v30 v31 ) #( 'flows' 'OAuthFlows.implicit'
	                 'OAuthFlows.password' 'OAuthFlows.clientCredentials'
	                 'OAuthFlows.authorizationCode' ) )
	           #( 'flows' flows 'OPOAuthFlow' own #(  ) #( v2 ) #(  ) ) ) )
	     #( 'OAuthFlow' 'OPOAuthFlow' #( node ) 'OAuthFlow' #( #( 'scopes'
	              scopes 'OPSecurityScope' synthetic #( 'scopes' )
	              #( v30 v31 ) ) ) )
	     #( 'SecurityScheme' 'OPOAuthFlow' #( node ) 'SecurityScheme'
	        #( #( 'scopes' scopes 'OPSecurityScope' synthetic #( 'scopes' )
	              #( v2 ) #( 'Scopes.{name}' ) ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiRelationRules class >> dataSwagger [
	"The root of a Swagger 2 document (the servers are made of host, basePath and schemes, the components of the definitions...)"

	^ #( #( 'Swagger' 'OPOpenApi' #( node ) 'Swagger' #( #( 'info' info
	              'OPInfo' children #( 'info' ) #( v2 ) )
	           #( 'host' servers 'OPServer' servers #(  ) #( v2 ) #( 'host'
	                 'basePath' 'schemes' ) )
	           #( 'paths' paths 'OPPath' container #( 'paths' )
	              #( v2 ) )
	           #( 'security' securityRequirements 'OPSecurityRequirement'
	              children #( 'security' ) #( v2 ) )
	           #( 'tags' tags 'OPTag' children #( 'tags' ) #( v2 ) )
	           #( 'externalDocs' externalDocs 'OPExternalDocumentation'
	              children #( 'externalDocs' ) #( v2 ) )
	           #( 'components' components 'OPComponents' syntheticAt
	              #( 'components' ) #( v2 ) #(  ) ) ) )
	     #( 'Swagger' 'OPOpenApi' #( node ) 'Reference' #( #( '$ref'
	              unresolvedReferences 'OPReference' unresolved
	              #(  ) #( v2 ) #( '$ref' ) set ) ) )
	     #( 'Swagger' 'OPComponents' #( node '/components' )
	        'Swagger' #( #( 'definitions' schemas 'OPSchema' children
	              #( 'definitions' ) #( v2 ) )
	           #( 'parameters' parameters 'OPParameter' children #( 'parameters' )
	              #( v2 ) )
	           #( 'responses' responses 'OPResponse' children #( 'responses' )
	              #( v2 ) )
	           #( 'securityDefinitions' securitySchemes 'OPSecurityScheme'
	              children #( 'securityDefinitions' )
	              #( v2 ) ) ) ) )
]

{ #category : 'data - schemas and security' }
FamixOpenApiRelationRules class >> dataTag [
	"The tags"

	^ #( #( 'Tag' 'OPTag' #( node ) 'Tag' #( #( 'externalDocs'
	              externalDocs 'OPExternalDocumentation'
	              children #( 'externalDocs' ) #( v30 v31 v2 ) ) ) ) )
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> isComparedRow: aConformanceRow [
	"True when a rule of the table carries the field of the conformance row"

	^ self rules anySatisfy: [ :each | each carriesRow: aConformanceRow ]
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> isRelationReason: aValueReason [
	"True for the reasons of the value check that send the field to the relation check"

	^ #( 'relation (V10)' 'implicit: structure (V10)' ) includes:
		  aValueReason
]

{ #category : 'coverage' }
FamixOpenApiRelationRules class >> isUncarriedRelationRow: aConformanceRow [
	"True for a row that the value check sent to the relation check and that no rule carries"

	^ (FamixOpenApiValueRules reasonNotComparedFor: aConformanceRow)
		  ifNil: [ false ]
		  ifNotNil: [ :reason |
			  (self isRelationReason: reason) and: [
				  (self isComparedRow: aConformanceRow) not ] ]
]

{ #category : 'coverage' }
FamixOpenApiRelationRules class >> neverComparedIn: aCoverage version: aVersion [
	"The relations of the table for the version that the coverage never compared, as associations coverage key -> reason, sorted by key: the reason of the deferral, that the model has no entity for the owners that were met, or that no owner was met in the documents checked"

	^ ((self rulesFor: aVersion)
		   collect: [ :each | each coverageKeyIn: aVersion ]
		   thenSelect: [ :key | (aCoverage comparedCountOf: key) = 0 ])
		  sorted collect: [ :key |
		  key -> (self reasonNeverComparedAt: key in: aCoverage) ]
]

{ #category : 'coverage' }
FamixOpenApiRelationRules class >> notComparedRows [
	"The relation and implicit structure rows of the conformance that no rule carries, with the reason: empty when the table is complete"

	^ FamixOpenApiMetamodelConformance check rows
		  select: [ :each | self isUncarriedRelationRow: each ]
		  thenCollect: [ :each | each -> (self reasonDeferredFor: each) ]
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> reasonDeferredFor: aConformanceRow [
	"The reason why a relation or an implicit structure row has no rule"

	^ self dataDeferrals
		  detect: [ :each |
			  each first = aConformanceRow specObject and: [
				  each second = aConformanceRow fieldName ] ]
		  ifFound: [ :each | each last ]
		  ifNone: [ 'no rule yet' ]
]

{ #category : 'coverage' }
FamixOpenApiRelationRules class >> reasonNeverComparedAt: aKey in: aCoverage [

	(aCoverage deferralReasonOf: aKey) ifNotNil: [ :reason | ^ reason ].
	(aCoverage withoutEntityCountOf: aKey) > 0 ifTrue: [
		^ 'the model has no entity for the owners met' ].
	^ 'no owner met in the documents checked'
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> reasonNotComparedFor: aConformanceRow [
	"Why the relation check does not compare the field of a row of the conformance (FamixOpenApiConformanceRow): a String, nil when a rule of the table carries it. A field that is not a relation or an implicit structure (a slot, an extension, a field that is not modelled) is not its business: the reason says which check it is"

	| valueReason |
	(self isComparedRow: aConformanceRow) ifTrue: [ ^ nil ].
	valueReason := FamixOpenApiValueRules reasonNotComparedFor:
		               aConformanceRow.
	valueReason ifNil: [ ^ 'compared by the value check (V8)' ].
	^ (self isRelationReason: valueReason)
		  ifTrue: [ self reasonDeferredFor: aConformanceRow ]
		  ifFalse: [ valueReason ]
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> rules [
	"The FamixOpenApiRelationRule of every row of the table"

	^ self dataGroups flatCollect: [ :group |
		  group last collect: [ :row |
			  FamixOpenApiRelationRule group: group row: row ] ]
]

{ #category : 'rules' }
FamixOpenApiRelationRules class >> rulesFor: aVersion [
	"The rules for the version (#v30, #v31 or #v2)"

	^ self rules select: [ :each | each appliesTo: aVersion ]
]
