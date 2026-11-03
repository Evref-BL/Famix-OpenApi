"
The comparator table of the value check (V8): for each field of a spec object that the metamodel carries in a typed slot, the OP class and the slot, the comparator (FamixOpenApiValueComparator) and the versions. The data is in the methods data<Group>, one per spec object (or per OP class that carries fields of one spec object): each answers #(spec object, OP class name, rows), a row being #(field key, selector, comparator name[, versions]); #rules builds the FamixOpenApiValueRule of every row. The table is written from the conformance rows (FamixOpenApiMetamodelConformance) and from import experiments: it never compares a field that the conformance says is not modelled. NAMES are compared only where the name slot is the source value verbatim (Tag, Parameter, Contact, License, XML); the structural names are not compared. Deferred: the merged form, the targets of the relations, Link.parameters, the default of style and explode, the schema of a formData parameter, the type, format... of a Swagger 2 header (not converted by the importer), the extensions (V9).
"
Class {
	#name : 'FamixOpenApiValueRules',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataBodyParameter [
	"A body parameter of Swagger 2 that is the request body of its operation: the importer builds an OPRequestBody at its pointer"

	^ #( 'Parameter' 'OPRequestBody' #( #( 'description' #description
	           #text ) #( 'required' #required #flag ) ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataContact [
	"The name slot of a contact is the name of the source (VERIFIED)"

	^ #( 'Contact' 'OPContact' #( #( 'name' #name #text )
	        #( 'url' #url #text ) #( 'email' #email #text ) ) )
]

{ #category : 'data - counts' }
FamixOpenApiValueRules class >> dataCountGroups [

	^ {
		  self dataOpenApiCounts.
		  self dataSwaggerCounts.
		  self dataOperationCounts }
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataDiscriminator [

	^ #( 'Discriminator' 'OPDiscriminator' #( #( 'propertyName'
	           #propertyName #text ) ) )
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> dataDocumentGroups [

	^ {
		  self dataOpenApi.
		  self dataSwagger.
		  self dataInfo.
		  self dataContact.
		  self dataLicense.
		  self dataExternalDocumentation.
		  self dataTag.
		  self dataServer.
		  self dataServerVariable }
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataEncoding [

	^ #( 'Encoding' 'OPEncoding' #( #( '{key}' #propertyName
	           #key ) #( 'contentType' #contentType #text )
	        #( 'style' #style #explicitText )
	        #( 'explode' #explode #explicitFlag )
	        #( 'allowReserved' #allowReserved #explicitFlag ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiValueRules class >> dataExample [

	^ #( 'Example' 'OPExample' #( #( 'summary' #summary #text #( #v30
	              #v31 ) ) #( 'value' #value #jsonText #( #v30 #v31 ) )
	        #( 'externalValue' #externalValue #text #( #v30 #v31 ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataExternalDocumentation [

	^ #( 'ExternalDocumentation' 'OPExternalDocumentation'
	     #( #( 'description' #description #text )
	        #( 'url' #url #text ) ) )
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataFormRequestBody [
	"The formData parameters of an operation make a request body that is required when one of them is"

	^ #( 'Operation' 'OPRequestBody' #( #( 'parameters' #required
	           #formRequired ) ) )
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> dataGroups [
	"Every group of the table"

	^ self dataDocumentGroups , self dataPathGroups
	  , self dataSchemaGroups , self dataSecurityGroups
	  , self dataCountGroups
]

{ #category : 'data - responses' }
FamixOpenApiValueRules class >> dataHeader [
	"Swagger 2 headers: the description only (the type, format... are not converted by the importer)"

	^ #( 'Header' 'OPHeader' #( #( 'description' #description
	           #text ) #( 'required' #required #flag #( #v30 #v31 ) )
	        #( 'deprecated' #deprecated #flag #( #v30 #v31 ) )
	        #( 'style' #style #explicitText #( #v30 #v31 ) )
	        #( 'explode' #explode #explicitFlag #( #v30 #v31 ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataInfo [

	^ #( 'Info' 'OPInfo' #( #( 'title' #title #text )
	        #( 'description' #description #text )
	        #( 'termsOfService' #termsOfService #text )
	        #( 'version' #version #text ) ) )
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> dataKeyRows [
	"Rows: spec object, field of the conformance whose name is the key of a node that has its own spec object"

	^ #( #( 'Paths' '/{path}' ) #( 'Responses' 'default' )
	     #( 'Responses' '{HTTP status code}' )
	     #( 'Callback' '{expression}' ) #( 'OAuthFlows' 'implicit' )
	     #( 'OAuthFlows' 'password' ) #( 'OAuthFlows' 'clientCredentials' )
	     #( 'OAuthFlows' 'authorizationCode' ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataLicense [

	^ #( 'License' 'OPLicense' #( #( 'name' #name #text )
	        #( 'url' #url #text ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiValueRules class >> dataLink [

	^ #( 'Link' 'OPLink' #( #( 'operationRef' #operationRef #text )
	        #( 'operationId' #operationId #text )
	        #( 'requestBody' #requestBody #jsonText )
	        #( 'description' #description #text ) ) )
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataMediaType [

	^ #( 'MediaType' 'OPMediaType' #( #( '{key}' #mediaType #key ) ) )
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataMediaTypeExample [

	^ #( 'MediaType' 'OPExample' #( #( 'example' #value #example ) ) )
]

{ #category : 'data - security' }
FamixOpenApiValueRules class >> dataOAuthFlow [
	"OpenAPI 3: the flow type is the key of the flow in the flows"

	^ #( 'OAuthFlow' 'OPOAuthFlow' #( #( '{key}' #flowType #key )
	        #( 'authorizationUrl' #authorizationUrl #text )
	        #( 'tokenUrl' #tokenUrl #text )
	        #( 'refreshUrl' #refreshUrl #text ) ) )
]

{ #category : 'data - security' }
FamixOpenApiValueRules class >> dataOAuthFlowScopes [

	^ #( 'OAuthFlow' 'OPSecurityScope' #( #( 'scopes' #description
	           #scopes ) ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataOpenApi [
	"The version of the document: the importer keeps the text of the source in sourceVersion (openapiVersion is the version it normalises to, 3.1.0 for every OpenAPI 3 document: VERIFIED)"

	^ #( 'OpenAPI' 'OPOpenApi' #( #( 'openapi' #sourceVersion
	           #text #( #v30 #v31 ) )
	        #( 'jsonSchemaDialect' #jsonSchemaDialect #text #( #v31 ) ) ) )
]

{ #category : 'data - counts' }
FamixOpenApiValueRules class >> dataOpenApiCounts [
	"The number of elements of the relations of the document whose elements are never references: the servers (when the document has them), the tags and the security requirements"

	^ #( 'OpenAPI' 'OPOpenApi' #( #( 'servers' #servers #explicitCount
	           #( #v30 #v31 ) )
	        #( 'tags' #tags #count #( #v30 #v31 ) )
	        #( 'security' #securityRequirements #count #( #v30 #v31 ) ) ) )
]

{ #category : 'data - servers and paths' }
FamixOpenApiValueRules class >> dataOperation [

	^ #( 'Operation' 'OPOperation' #( #( 'tags' #tagNames #stringList )
	        #( 'summary' #summary #text ) #( 'description' #description
	           #text ) #( 'operationId' #operationId #text )
	        #( 'deprecated' #deprecated #flag )
	        #( '{key}' #httpMethod #key ) ) )
]

{ #category : 'data - counts' }
FamixOpenApiValueRules class >> dataOperationCounts [

	^ #( 'Operation' 'OPOperation' #( #( 'security' #securityRequirements
	           #count ) ) )
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataParameter [
	"The name slot is the name of the source (VERIFIED). style, explode and allowReserved only when the source states them; Swagger 2: the style and explode come from collectionFormat"

	^ #( 'Parameter' 'OPParameter' #( #( 'name' #name #text )
	        #( 'in' #location #text ) #( 'description' #description
	           #text ) #( 'required' #required #flag )
	        #( 'deprecated' #deprecated #flag #( #v30 #v31 ) )
	        #( 'allowEmptyValue' #allowEmptyValue #flag )
	        #( 'style' #style #explicitText #( #v30 #v31 ) )
	        #( 'explode' #explode #explicitFlag #( #v30 #v31 ) )
	        #( 'allowReserved' #allowReserved #explicitFlag #( #v30 #v31 ) )
	        #( 'collectionFormat' #style #collectionStyle
	           #( #v2 ) )
	        #( 'collectionFormat' #explode #collectionExplode
	           #( #v2 ) ) ) )
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataParameterExample [
	"The scalar example is an example entity below the parameter"

	^ #( 'Parameter' 'OPExample' #( #( 'example' #value #example #( #v30
	              #v31 ) ) ) )
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> dataPathGroups [

	^ {
		  self dataPathItem.
		  self dataOperation.
		  self dataParameter.
		  self dataParameterExample.
		  self dataBodyParameter.
		  self dataFormRequestBody.
		  self dataRequestBody.
		  self dataMediaType.
		  self dataMediaTypeExample.
		  self dataEncoding.
		  self dataResponse.
		  self dataExample.
		  self dataLink.
		  self dataHeader }
]

{ #category : 'data - servers and paths' }
FamixOpenApiValueRules class >> dataPathItem [
	"The ref is the one of the site (a clone, an entry that is a $ref); the relativePath is the key of the entries of paths, webhooks and callbacks; summary and description are not in Swagger 2"

	^ #( 'PathItem' 'OPPath' #( #( '$ref' #ref #referenceText )
	        #( '{key}' #relativePath #pathKey )
	        #( 'summary' #summary #text #( #v30 #v31 ) )
	        #( 'description' #description #text #( #v30 #v31 ) ) ) )
]

{ #category : 'data - parameters and bodies' }
FamixOpenApiValueRules class >> dataRequestBody [

	^ #( 'RequestBody' 'OPRequestBody' #( #( 'description' #description
	           #text ) #( 'required' #required #flag ) ) )
]

{ #category : 'data - responses' }
FamixOpenApiValueRules class >> dataResponse [
	"The ref is the one of the site of a clone"

	^ #( 'Response' 'OPResponse' #( #( 'description' #description
	           #text ) #( '{key}' #statusCode #statusKey )
	        #( '$ref' #ref #referenceText ) ) )
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataSchemaDiscriminator [
	"The discriminator of Swagger 2 is a string"

	^ #( 'Schema' 'OPDiscriminator' #( #( 'discriminator' #propertyName
	           #discriminatorName #( #v2 ) ) ) )
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataSchemaFlags [

	^ #( 'Schema' 'OPSchema' #( #( 'uniqueItems' #uniqueItems
	           #flag ) #( 'readOnly' #readOnly #flag )
	        #( 'writeOnly' #writeOnly #flag #( #v30 #v31 ) )
	        #( 'deprecated' #deprecated #flag #( #v30 #v31 ) ) ) )
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> dataSchemaGroups [

	^ {
		  self dataSchemaTexts.
		  self dataSchemaNumbers.
		  self dataSchemaFlags.
		  self dataSchemaStructure.
		  self dataSchemaProperty.
		  self dataSchemaDiscriminator.
		  self dataDiscriminator.
		  self dataXml }
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataSchemaNumbers [
	"Numbers of a schema; the bounds of OpenAPI 3.1 are numbers, the ones of OpenAPI 3.0 and Swagger 2 are moved by the importer (see FamixOpenApiBoundComparator)"

	^ #( 'Schema' 'OPSchema' #( #( 'multipleOf' #multipleOf #number )
	        #( 'maxLength' #maxLength #number )
	        #( 'minLength' #minLength #number )
	        #( 'maxItems' #maxItems #number )
	        #( 'minItems' #minItems #number )
	        #( 'maxProperties' #maxProperties #number )
	        #( 'minProperties' #minProperties #number )
	        #( 'maximum' #maximum #number #( #v31 ) )
	        #( 'minimum' #minimum #number #( #v31 ) )
	        #( 'exclusiveMaximum' #exclusiveMaximum #number #( #v31 ) )
	        #( 'exclusiveMinimum' #exclusiveMinimum #number #( #v31 ) )
	        #( 'maximum' #maximum #inclusiveMaximum #( #v30 #v2 ) )
	        #( 'minimum' #minimum #inclusiveMinimum #( #v30 #v2 ) )
	        #( 'exclusiveMaximum' #exclusiveMaximum #exclusiveMaximum
	           #( #v30 #v2 ) )
	        #( 'exclusiveMinimum' #exclusiveMinimum #exclusiveMinimum
	           #( #v30 #v2 ) ) ) )
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataSchemaProperty [
	"The entry of the properties of a schema: the OPProperty is required when its name is in the required array of the schema"

	^ #( 'Schema' 'OPProperty' #( #( 'required' #isRequired #propertyRequired ) ) )
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataSchemaStructure [
	"type and nullable (3.0: the keyword nullable; 3.1: the type null), the required array and the values stored as JSON text"

	^ #( 'Schema' 'OPSchema' #( #( 'type' #types #types )
	        #( 'nullable' #isNullable #nullable30 #( #v30 ) )
	        #( 'type' #isNullable #nullable31 #( #v31 ) )
	        #( 'required' #requiredProperties #stringList )
	        #( 'enum' #enumValues #jsonText )
	        #( 'default' #defaultValue #jsonText )
	        #( 'example' #exampleValue #jsonText )
	        #( 'const' #constValue #jsonText #( #v31 ) ) ) )
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataSchemaTexts [
	"Strings of a schema, stored verbatim (the $ref is the text of the reference of the schema: an alias, a 3.1 schema with siblings, a clone)"

	^ #( 'Schema' 'OPSchema' #( #( 'title' #title #text )
	        #( 'description' #description #text )
	        #( 'format' #format #text ) #( 'pattern' #pattern #text )
	        #( '$ref' #ref #referenceText ) ) )
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> dataSecurityGroups [

	^ {
		  self dataSecurityScheme.
		  self dataSecuritySchemeFlow.
		  self dataSecuritySchemeScopes.
		  self dataOAuthFlow.
		  self dataOAuthFlowScopes }
]

{ #category : 'data - security' }
FamixOpenApiValueRules class >> dataSecurityScheme [
	"Swagger 2: basic is the type http with the scheme basic; apiKey keeps its name and in"

	^ #( 'SecurityScheme' 'OPSecurityScheme' #( #( 'type' #type #text
	           #( #v30 #v31 ) ) #( 'type' #type #securityTypeV2
	           #( #v2 ) ) #( 'type' #scheme #basicSchemeV2 #( #v2 ) )
	        #( 'description' #description #text )
	        #( 'name' #parameterName #text )
	        #( 'in' #inLocation #text ) #( 'scheme' #scheme #text #( #v30
	              #v31 ) ) #( 'bearerFormat' #bearerFormat #text #( #v30
	              #v31 ) )
	        #( 'openIdConnectUrl' #openIdConnectUrl #text #( #v30 #v31 ) ) ) )
]

{ #category : 'data - security' }
FamixOpenApiValueRules class >> dataSecuritySchemeFlow [
	"An oauth2 scheme of Swagger 2 is also an OAuth flow at its own pointer"

	^ #( 'SecurityScheme' 'OPOAuthFlow' #( #( 'flow' #flowType #flowTypeV2
	           #( #v2 ) ) #( 'authorizationUrl' #authorizationUrl
	           #text #( #v2 ) )
	        #( 'tokenUrl' #tokenUrl #text #( #v2 ) ) ) )
]

{ #category : 'data - security' }
FamixOpenApiValueRules class >> dataSecuritySchemeScopes [

	^ #( 'SecurityScheme' 'OPSecurityScope' #( #( 'scopes' #description
	           #scopes #( #v2 ) ) ) )
]

{ #category : 'data - servers and paths' }
FamixOpenApiValueRules class >> dataServer [

	^ #( 'Server' 'OPServer' #( #( 'url' #url #text )
	        #( 'description' #description #text ) ) )
]

{ #category : 'data - servers and paths' }
FamixOpenApiValueRules class >> dataServerVariable [
	"The default and the enum of a server variable are plain strings in the slots, not JSON text as for a schema (VERIFIED)"

	^ #( 'ServerVariable' 'OPServerVariable' #( #( 'default' #defaultValue
	           #text ) #( 'enum' #enumValues #stringList )
	        #( 'description' #description #text ) ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataSwagger [

	^ #( 'Swagger' 'OPOpenApi' #( #( 'swagger' #sourceVersion
	           #text #( #v2 ) ) ) )
]

{ #category : 'data - counts' }
FamixOpenApiValueRules class >> dataSwaggerCounts [

	^ #( 'Swagger' 'OPOpenApi' #( #( 'tags' #tags #count #( #v2 ) )
	        #( 'security' #securityRequirements #count #( #v2 ) ) ) )
]

{ #category : 'data - document' }
FamixOpenApiValueRules class >> dataTag [
	"The name slot of a tag is the name of the source (VERIFIED)"

	^ #( 'Tag' 'OPTag' #( #( 'name' #name #text ) #( 'description'
	           #description #text ) ) )
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> dataVerbs [

	^ #( 'get' 'put' 'post' 'delete' 'options' 'head' 'patch' 'trace' )
]

{ #category : 'data - schemas' }
FamixOpenApiValueRules class >> dataXml [
	"The name slot of an xml element is the name of the source (VERIFIED)"

	^ #( 'XML' 'OPXmlElement' #( #( 'name' #name #text )
	        #( 'namespace' #namespace #text )
	        #( 'prefix' #prefix #text ) #( 'attribute' #attribute
	           #flag ) #( 'wrapped' #wrapped #flag ) ) )
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> isComparedRow: aConformanceRow [

	^ (self isRuleRow: aConformanceRow) or: [
		  (self isSchemaAliasRow: aConformanceRow) or: [
			  self isKeyRow: aConformanceRow ] ]
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> isKeyRow: aConformanceRow [
	"The field is the key of a node, compared as {key} of that node (the verbs of a path item are the keys of its operations)"

	^ (self dataKeyRows includes: {
			   aConformanceRow specObject.
			   aConformanceRow fieldName }) or: [
		  aConformanceRow specObject = 'PathItem' and: [
			  self dataVerbs includes: aConformanceRow fieldName ] ]
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> isRuleRow: aConformanceRow [
	"A rule of the table is about the field"

	^ self rules anySatisfy: [ :each |
		  (each
			   isAbout: aConformanceRow specObject
			   in: aConformanceRow version) and: [
			  each fieldKey = aConformanceRow fieldName ] ]
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> isSchemaAliasRow: aConformanceRow [
	"Swagger 2: the type, format, enum... of a typed parameter and of its items are the fields of the schema the importer makes of them, compared as such"

	^ aConformanceRow version = #v2 and: [
		  (aConformanceRow specObject = 'Items' or: [
			   aConformanceRow specObject = 'Parameter' and: [
				   FamixOpenApiSwagger2Parameters dataSchemaKeys includes:
					   aConformanceRow fieldName ] ]) and: [
			  (self rulesFor: 'Schema' in: #v2) anySatisfy: [ :each |
				  each fieldKey = aConformanceRow fieldName ] ] ]
]

{ #category : 'coverage of the conformance rows' }
FamixOpenApiValueRules class >> reasonNotComparedFor: aConformanceRow [
	"Why the field of a row of the conformance (FamixOpenApiConformanceRow) is not compared by the value check: a String, nil when it is compared (by a rule of the table, as a field of the schema that Swagger 2 makes of a typed parameter, or as the key of its node)"

	(self isComparedRow: aConformanceRow) ifTrue: [ ^ nil ].
	aConformanceRow fieldName = 'x-*' ifTrue: [ ^ 'extension (V9)' ].
	aConformanceRow isNotModelled ifTrue: [ ^ 'notModelled (V9)' ].
	aConformanceRow status == #modelledRelation ifTrue: [
		^ 'relation (V10)' ].
	aConformanceRow status == #modelledSlot ifTrue: [ ^ 'deferred slot' ].
	^ 'implicit: structure (V10)'
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> rules [
	"The FamixOpenApiValueRule of every row of the table"

	^ self dataGroups flatCollect: [ :group | self rulesOfGroup: group ]
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> rulesFor: aSpecObjectName in: aVersion [
	"The rules of the spec object for the version"

	^ self rules select: [ :each |
		  each isAbout: aSpecObjectName in: aVersion ]
]

{ #category : 'rules' }
FamixOpenApiValueRules class >> rulesOfGroup: aGroup [
	"The rules of a group: spec object, OP class name, rows"

	^ aGroup third collect: [ :row |
		  FamixOpenApiValueRule
			  specObject: aGroup first
			  className: aGroup second
			  row: row ]
]
