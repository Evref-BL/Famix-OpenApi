"
I am a declarative table of every object and field of OpenAPI 3.0.3 (#v30), OpenAPI 3.1.x (#v31; 3.1.0, 3.1.1 and 3.1.2 have identical fields) and Swagger 2.0 (#v2), all on the class side.
The data is transcribed from the official specifications (https://spec.openapis.org/oas/v3.0.3, https://spec.openapis.org/oas/v3.1.1, https://swagger.io/specification/v2/) and lives in one class-side method per spec object (protocols 'data - ...'), each answering literal rows #(name kind versions level required note).
Each field is classified by LEVEL: #structural (shape of the API or of its data, needed to manipulate the API or generate code), #useful (valuable for tooling, docs or test generation) or #metadata (vendor and tooling metadata only). The LEVEL classification is a PROPOSAL to be reviewed by the user, not a decided fact; when in doubt the lower level was chosen and the doubt is in the note.
API: allFields, fieldsFor:in:, objectNamesIn:, levelOf:field:in:, fieldsAt:in:, versions, markdownSummary.
isRequired answers true for conditionally required fields too (for example a Security Scheme name required for type apiKey); the condition is stated in the note, which then starts with 'conditionally required:'.
The four Swagger 2.0 container objects (Definitions, Parameters Definitions, Responses Definitions, Security Definitions) are deliberately modelled as map fields of the Swagger root object; they accept no x-* extensions.
"
Class {
	#name : 'FamixOpenApiSpecFieldTable',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> allFields [
	"Answer every field row as a FamixOpenApiSpecField"

	^ Array streamContents: [ :stream |
		  self specObjectRows do: [ :association |
			  association value do: [ :row |
				  stream nextPut:
					  (FamixOpenApiSpecField fromRow: row specObject: association key) ] ] ]
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataCallback [

	^ #( #( '{expression}' map #( v30 v31 ) structural false '3.0: a Path Item; 3.1: a Path Item or a Reference; the key is a runtime expression' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataComponents [

	^ #( #( 'schemas' map #( v30 v31 ) structural false '' )
	     #( 'responses' map #( v30 v31 ) structural false '' )
	     #( 'parameters' map #( v30 v31 ) structural false '' )
	     #( 'examples' map #( v30 v31 ) useful false 'LEVEL doubt: examples are documentation, but the section is a components section' )
	     #( 'requestBodies' map #( v30 v31 ) structural false '' )
	     #( 'headers' map #( v30 v31 ) structural false '' )
	     #( 'securitySchemes' map #( v30 v31 ) structural false '' )
	     #( 'links' map #( v30 v31 ) structural false '' )
	     #( 'callbacks' map #( v30 v31 ) structural false '' )
	     #( 'pathItems' map #( v31 ) structural false '' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataContact [

	^ #( #( 'name' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'url' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'email' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataDiscriminator [
	"Swagger 2.0 has no Discriminator Object: a plain string on Schema"

	^ #( #( 'propertyName' scalar #( v30 v31 ) structural true '' )
	     #( 'mapping' map #( v30 v31 ) structural false 'valid only with oneOf, anyOf or allOf' )
	     #( 'x-*' any #( v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataEncoding [

	^ #( #( 'contentType' scalar #( v30 v31 ) structural false '' )
	     #( 'headers' map #( v30 v31 ) structural false '' )
	     #( 'style' scalar #( v30 v31 ) structural false '' )
	     #( 'explode' scalar #( v30 v31 ) structural false '' )
	     #( 'allowReserved' scalar #( v30 v31 ) structural false '' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataExample [

	^ #( #( 'summary' scalar #( v30 v31 ) useful false '' )
	     #( 'description' scalar #( v30 v31 ) useful false '' )
	     #( 'value' any #( v30 v31 ) useful false 'mutually exclusive with externalValue' )
	     #( 'externalValue' scalar #( v30 v31 ) useful false 'mutually exclusive with value' )
	     #( '{mime type}' any #( v2 ) useful false 'entry of Response.examples' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataExternalDocumentation [

	^ #( #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'url' scalar #( v30 v31 v2 ) useful true '' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataHeader [

	^ #( #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'required' scalar #( v30 v31 ) structural false '' )
	     #( 'deprecated' scalar #( v30 v31 ) useful false '' )
	     #( 'allowEmptyValue' scalar #( v30 v31 ) structural false 'inherited from the Parameter structure but meaningless for a header (query-only)' )
	     #( 'style' scalar #( v30 v31 ) structural false '' )
	     #( 'explode' scalar #( v30 v31 ) structural false '' )
	     #( 'allowReserved' scalar #( v30 v31 ) structural false '' )
	     #( 'schema' object #( v30 v31 ) structural false 'mutually exclusive with content' )
	     #( 'example' any #( v30 v31 ) useful false '' )
	     #( 'examples' map #( v30 v31 ) useful false '' )
	     #( 'content' map #( v30 v31 ) structural false 'exactly one entry; mutually exclusive with schema' )
	     #( 'type' scalar #( v2 ) structural true 'string number integer boolean array' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataInfo [

	^ #( #( 'title' scalar #( v30 v31 v2 ) useful true '' )
	     #( 'summary' scalar #( v31 ) useful false '' )
	     #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'termsOfService' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'contact' object #( v30 v31 v2 ) useful false '' )
	     #( 'license' object #( v30 v31 v2 ) useful false '' )
	     #( 'version' scalar #( v30 v31 v2 ) useful true 'version of the API document, not of the OpenAPI spec' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataItems [
	"Items Object, Swagger 2.0 only"

	^ #( #( 'type' scalar #( v2 ) structural true 'string number integer boolean array' )
	     #( 'x-*' any #( v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataLicense [

	^ #( #( 'name' scalar #( v30 v31 v2 ) useful true '' )
	     #( 'url' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'identifier' scalar #( v31 ) useful false 'SPDX license expression; mutually exclusive with url' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataLink [

	^ #( #( 'operationRef' scalar #( v30 v31 ) structural false 'exactly one of operationRef or operationId is required; they are mutually exclusive' )
	     #( 'operationId' scalar #( v30 v31 ) structural false 'exactly one of operationRef or operationId is required; they are mutually exclusive' )
	     #( 'parameters' map #( v30 v31 ) structural false '' )
	     #( 'requestBody' any #( v30 v31 ) structural false '' )
	     #( 'description' scalar #( v30 v31 ) useful false '' )
	     #( 'server' object #( v30 v31 ) structural false '' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataMediaType [

	^ #( #( 'schema' object #( v30 v31 ) structural false '' )
	     #( 'example' any #( v30 v31 ) useful false 'mutually exclusive with examples' )
	     #( 'examples' map #( v30 v31 ) useful false 'mutually exclusive with example' )
	     #( 'encoding' map #( v30 v31 ) structural false 'Map[property name, Encoding]' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecFieldTable class >> dataOAuthFlow [

	^ #( #( 'authorizationUrl' scalar #( v30 v31 ) structural true 'conditionally required: for implicit and authorizationCode' )
	     #( 'tokenUrl' scalar #( v30 v31 ) structural true 'conditionally required: for password, clientCredentials and authorizationCode' )
	     #( 'refreshUrl' scalar #( v30 v31 ) structural false '' )
	     #( 'scopes' map #( v30 v31 ) structural true 'Map[name, description]; may be empty' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecFieldTable class >> dataOAuthFlows [

	^ #( #( 'implicit' object #( v30 v31 ) structural false '' )
	     #( 'password' object #( v30 v31 ) structural false '' )
	     #( 'clientCredentials' object #( v30 v31 ) structural false
	        '' )
	     #( 'authorizationCode' object #( v30 v31 ) structural false
	        '' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataOpenApi [
	"Root object of OpenAPI 3.x. Row: name kind versions level required note"

	^ #( #( 'openapi' scalar #( v30 v31 ) structural true '' )
	     #( 'info' object #( v30 v31 ) useful true 'LEVEL doubt: required, but only documentation content' )
	     #( 'servers' array #( v30 v31 ) structural false '' )
	     #( 'components' object #( v30 v31 ) structural false '' )
	     #( 'paths' object #( v30 v31 ) structural true 'required in 3.0, optional in 3.1; 3.1: the document MUST contain at least one of paths, components or webhooks' )
	     #( 'security' array #( v30 v31 ) structural false '' )
	     #( 'tags' array #( v30 v31 ) useful false '' )
	     #( 'externalDocs' object #( v30 v31 ) useful false '' )
	     #( 'jsonSchemaDialect' scalar #( v31 ) metadata false 'URI of the default $schema dialect' )
	     #( 'webhooks' map #( v31 ) structural false 'Map[string, PathItem or Reference]' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataOperation [

	^ #( #( 'tags' array #( v30 v31 v2 ) useful false '' )
	     #( 'summary' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'externalDocs' object #( v30 v31 v2 ) useful false '' )
	     #( 'operationId' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'parameters' array #( v30 v31 v2 ) structural false '' )
	     #( 'requestBody' object #( v30 v31 ) structural false '' )
	     #( 'responses' object #( v30 v31 v2 ) structural true '' )
	     #( 'callbacks' map #( v30 v31 ) structural false '' )
	     #( 'deprecated' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'security' array #( v30 v31 v2 ) structural false '' )
	     #( 'servers' array #( v30 v31 ) structural false '' )
	     #( 'consumes' array #( v2 ) structural false '' )
	     #( 'produces' array #( v2 ) structural false '' )
	     #( 'schemes' array #( v2 ) structural false '' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataParameter [

	^ #( #( 'name' scalar #( v30 v31 v2 ) structural true '' )
	     #( 'in' scalar #( v30 v31 ) structural true 'query header path cookie' )
	     #( 'in' scalar #( v2 ) structural true 'query header path formData body' )
	     #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'required' scalar #( v30 v31 v2 ) structural false 'must be true for in=path' )
	     #( 'deprecated' scalar #( v30 v31 ) useful false '' )
	     #( 'allowEmptyValue' scalar #( v30 v31 v2 ) structural
	        false '3.0 and 3.1: valid only for in=query, use NOT RECOMMENDED (may be removed); 2.0: valid for in=query and formData' )
	     #( 'style' scalar #( v30 v31 ) structural false '' )
	     #( 'explode' scalar #( v30 v31 ) structural false '' )
	     #( 'allowReserved' scalar #( v30 v31 ) structural false '' )
	     #( 'schema' object #( v30 v31 ) structural false 'mutually exclusive with content' )
	     #( 'schema' object #( v2 ) structural true 'conditionally required: only when in=body' )
	     #( 'example' any #( v30 v31 ) useful false '' )
	     #( 'examples' map #( v30 v31 ) useful false '' )
	     #( 'content' map #( v30 v31 ) structural false 'exactly one entry; mutually exclusive with schema' )
	     #( 'type' scalar #( v2 ) structural true 'conditionally required: when in is not body; string number integer boolean array file (file only for in=formData)' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataPathItem [

	^ #( #( '$ref' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'summary' scalar #( v30 v31 ) useful false '' )
	     #( 'description' scalar #( v30 v31 ) useful false '' )
	     #( 'get' object #( v30 v31 v2 ) structural false '' )
	     #( 'put' object #( v30 v31 v2 ) structural false '' )
	     #( 'post' object #( v30 v31 v2 ) structural false '' )
	     #( 'delete' object #( v30 v31 v2 ) structural false '' )
	     #( 'options' object #( v30 v31 v2 ) structural false '' )
	     #( 'head' object #( v30 v31 v2 ) structural false '' )
	     #( 'patch' object #( v30 v31 v2 ) structural false '' )
	     #( 'trace' object #( v30 v31 ) structural false '' )
	     #( 'servers' array #( v30 v31 ) structural false '' )
	     #( 'parameters' array #( v30 v31 v2 ) structural false 'applies to all operations of the path' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataPaths [

	^ #( #( '/{path}' map #( v30 v31 v2 ) structural false 'patterned field: relative path to PathItem' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataReference [

	^ #( #( '$ref' reference #( v30 v31 v2 ) structural true '' )
	     #( 'summary' scalar #( v31 ) useful false 'overrides the referenced summary' )
	     #( 'description' scalar #( v31 ) useful false 'overrides the referenced description' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataRequestBody [

	^ #( #( 'description' scalar #( v30 v31 ) useful false '' )
	     #( 'content' map #( v30 v31 ) structural true 'Map[media type, MediaType]' )
	     #( 'required' scalar #( v30 v31 ) structural false '' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataResponse [

	^ #( #( 'description' scalar #( v30 v31 v2 ) useful true '' )
	     #( 'headers' map #( v30 v31 v2 ) structural false '' )
	     #( 'content' map #( v30 v31 ) structural false '' )
	     #( 'links' map #( v30 v31 ) structural false '' )
	     #( 'schema' object #( v2 ) structural false '' )
	     #( 'examples' map #( v2 ) useful false 'Map[mime type, example]' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataResponses [

	^ #( #( 'default' object #( v30 v31 v2 ) structural false 'a Response; a Reference is also allowed in 3.x, not in 2.0; at least one response code is required, default alone is acceptable' )
	     #( '{HTTP status code}' map #( v30 v31 v2 ) structural
	        false 'patterned field; ranges like 2XX only in 3.x; at least one response code is required (default alone is acceptable)' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataSchema [
	"Keywords shared by all versions, then those that differ between versions, then the 3.1 only ones"

	^ self dataSchemaShared , self dataSchemaVariants
	  , self dataSchemaV31Only
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataSchemaShared [
	"Schema keywords present in 3.0.3, 3.1.x and 2.0"

	^ #( #( 'title' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'multipleOf' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'maximum' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'exclusiveMaximum' scalar #( v30 v31 v2 ) structural
	        false '3.0: boolean; 3.1: number; 2.0: boolean' )
	     #( 'minimum' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'exclusiveMinimum' scalar #( v30 v31 v2 ) structural
	        false '3.0: boolean; 3.1: number; 2.0: boolean' )
	     #( 'maxLength' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'minLength' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'pattern' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'maxItems' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'minItems' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'uniqueItems' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'maxProperties' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'minProperties' scalar #( v30 v31 v2 ) structural false '' )
	     #( 'required' array #( v30 v31 v2 ) structural false 'array of property names' )
	     #( 'enum' array #( v30 v31 v2 ) structural false '' )
	     #( 'type' scalar #( v30 v31 v2 ) structural false '3.0: single string; 3.1: string or array of strings; 2.0: single string' )
	     #( 'allOf' array #( v30 v31 v2 ) structural false '' )
	     #( 'items' object #( v30 v31 v2 ) structural false '3.0: Schema; 3.1: Schema or boolean; 2.0: Schema only' )
	     #( 'properties' map #( v30 v31 v2 ) structural false '' )
	     #( 'additionalProperties' any #( v30 v31 v2 ) structural
	        false 'boolean or Schema' )
	     #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'format' scalar #( v30 v31 v2 ) structural false 'LEVEL doubt: only an annotation in 3.1, a type modifier in 3.0 and 2.0; drives code generation in all versions' )
	     #( 'default' any #( v30 v31 v2 ) structural false '' )
	     #( 'readOnly' scalar #( v30 v31 v2 ) useful false '3.0: readOnly and writeOnly cannot both be true' )
	     #( 'xml' object #( v30 v31 v2 ) useful false '' )
	     #( 'externalDocs' object #( v30 v31 v2 ) useful false '' )
	     #( 'example' any #( v30 v31 v2 ) useful false '3.1: deprecated in favour of examples; 3.0 and 2.0: not deprecated' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataSchemaV31Only [
	"Schema keywords only in 3.1.x (JSON Schema 2020-12): core, applicator, unevaluated, validation, content, meta-data"

	^ #( #( '$id' scalar #( v31 ) structural false '' )
	     #( '$schema' scalar #( v31 ) metadata false 'dialect declaration' )
	     #( '$ref' reference #( v31 ) structural false '' )
	     #( '$anchor' scalar #( v31 ) structural false '' )
	     #( '$dynamicRef' reference #( v31 ) structural false '' )
	     #( '$dynamicAnchor' scalar #( v31 ) structural false '' )
	     #( '$vocabulary' map #( v31 ) metadata false '' )
	     #( '$comment' scalar #( v31 ) metadata false '' )
	     #( '$defs' map #( v31 ) structural false '' )
	     #( 'prefixItems' array #( v31 ) structural false '' )
	     #( 'contains' object #( v31 ) structural false '' )
	     #( 'patternProperties' map #( v31 ) structural false '' )
	     #( 'dependentSchemas' map #( v31 ) structural false '' )
	     #( 'propertyNames' object #( v31 ) structural false '' )
	     #( 'if' object #( v31 ) structural false '' )
	     #( 'then' object #( v31 ) structural false '' )
	     #( 'else' object #( v31 ) structural false '' )
	     #( 'unevaluatedItems' object #( v31 ) structural false '' )
	     #( 'unevaluatedProperties' object #( v31 ) structural false
	        '' )
	     #( 'const' any #( v31 ) structural false '' )
	     #( 'maxContains' scalar #( v31 ) structural false '' )
	     #( 'minContains' scalar #( v31 ) structural false '' )
	     #( 'dependentRequired' map #( v31 ) structural false 'Map[property name, array of property names]' )
	     #( 'contentEncoding' scalar #( v31 ) metadata false 'replaces format byte' )
	     #( 'contentMediaType' scalar #( v31 ) metadata false 'replaces format binary' )
	     #( 'contentSchema' object #( v31 ) metadata false '' )
	     #( 'examples' array #( v31 ) useful false 'replaces example' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataSchemaVariants [
	"Schema keywords that exist in some versions only, or whose kind differs between versions"

	^ #( #( '$ref' reference #( v2 ) structural false '2.0: a JSON Reference keyword inside the Schema Object (as in 3.1); 3.0 uses a Reference Object instead' )
	     #( 'oneOf' array #( v30 v31 ) structural false '' )
	     #( 'anyOf' array #( v30 v31 ) structural false '' )
	     #( 'not' object #( v30 v31 ) structural false '' )
	     #( 'nullable' scalar #( v30 ) structural false 'removed in 3.1: use type array with null; 3.0: only adds null when type is explicitly set' )
	     #( 'discriminator' object #( v30 v31 ) structural false 'Discriminator Object' )
	     #( 'discriminator' scalar #( v2 ) structural false 'plain string: name of the property' )
	     #( 'writeOnly' scalar #( v30 v31 ) useful false '3.0: readOnly and writeOnly cannot both be true' )
	     #( 'deprecated' scalar #( v30 v31 ) useful false '' ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecFieldTable class >> dataScopes [
	"Scopes Object, Swagger 2.0 only"

	^ #( #( '{name}' scalar #( v2 ) structural false 'patterned field: scope name to description' )
	     #( 'x-*' any #( v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecFieldTable class >> dataSecurityRequirement [

	^ #( #( '{name}' array #( v30 v31 v2 ) structural false 'patterned field: security scheme name to array of scope names' ) )
]

{ #category : 'data - security' }
FamixOpenApiSpecFieldTable class >> dataSecurityScheme [

	^ #( #( 'type' scalar #( v30 ) structural true 'apiKey http oauth2 openIdConnect' )
	     #( 'type' scalar #( v31 ) structural true 'apiKey http mutualTLS oauth2 openIdConnect' )
	     #( 'type' scalar #( v2 ) structural true 'basic apiKey oauth2' )
	     #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'name' scalar #( v30 v31 v2 ) structural true 'conditionally required: for type apiKey' )
	     #( 'in' scalar #( v30 v31 ) structural true 'conditionally required: for type apiKey; values: query header cookie' )
	     #( 'in' scalar #( v2 ) structural true 'conditionally required: for type apiKey; values: query header' )
	     #( 'scheme' scalar #( v30 v31 ) structural true 'conditionally required: for type http' )
	     #( 'bearerFormat' scalar #( v30 v31 ) structural false 'type http; LEVEL doubt: a hint only, no validation effect' )
	     #( 'flows' object #( v30 v31 ) structural true 'conditionally required: for type oauth2' )
	     #( 'openIdConnectUrl' scalar #( v30 v31 ) structural true 'conditionally required: for type openIdConnect' )
	     #( 'flow' scalar #( v2 ) structural true 'conditionally required: for type oauth2; values: implicit password application accessCode' )
	     #( 'authorizationUrl' scalar #( v2 ) structural true 'conditionally required: for flow implicit and accessCode' )
	     #( 'tokenUrl' scalar #( v2 ) structural true 'conditionally required: for flow password, application and accessCode' )
	     #( 'scopes' map #( v2 ) structural true 'conditionally required: for oauth2; Scopes Object' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataServer [

	^ #( #( 'url' scalar #( v30 v31 ) structural true 'may contain {variable} templates' )
	     #( 'description' scalar #( v30 v31 ) useful false '' )
	     #( 'variables' map #( v30 v31 ) structural false 'Map[string, ServerVariable]' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataServerVariable [

	^ #( #( 'default' scalar #( v30 v31 ) structural true '3.1: SHOULD be one of the enum values when enum is defined; 3.0: no such rule' )
	     #( 'enum' array #( v30 v31 ) structural false '3.1: the array MUST NOT be empty; 3.0: no such rule' )
	     #( 'description' scalar #( v30 v31 ) useful false '' )
	     #( 'x-*' any #( v30 v31 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - root' }
FamixOpenApiSpecFieldTable class >> dataSwagger [
	"Root object of Swagger 2.0. Row: name kind versions level required note"

	^ #( #( 'swagger' scalar #( v2 ) structural true 'must be the string 2.0' )
	     #( 'info' object #( v2 ) useful true 'LEVEL doubt: required, but only documentation content' )
	     #( 'host' scalar #( v2 ) structural false '' )
	     #( 'basePath' scalar #( v2 ) structural false '' )
	     #( 'schemes' array #( v2 ) structural false '' )
	     #( 'consumes' array #( v2 ) structural false '' )
	     #( 'produces' array #( v2 ) structural false '' )
	     #( 'paths' object #( v2 ) structural true '' )
	     #( 'definitions' map #( v2 ) structural false 'map; Definitions Object (no x-*): name to Schema' )
	     #( 'parameters' map #( v2 ) structural false 'map; Parameters Definitions Object (no x-*): name to Parameter' )
	     #( 'responses' map #( v2 ) structural false 'map; Responses Definitions Object (no x-*): name to Response' )
	     #( 'securityDefinitions' map #( v2 ) structural false 'map; Security Definitions Object (no x-*): name to Security Scheme' )
	     #( 'security' array #( v2 ) structural false '' )
	     #( 'tags' array #( v2 ) useful false '' )
	     #( 'externalDocs' object #( v2 ) useful false '' )
	     #( 'x-*' any #( v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataTag [

	^ #( #( 'name' scalar #( v30 v31 v2 ) useful true '' )
	     #( 'description' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'externalDocs' object #( v30 v31 v2 ) useful false '' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataV2ParameterValidationRows [
	"Validation rows of a Swagger 2.0 Parameter: like the shared rows, but collectionFormat also accepts multi"

	^ self dataV2ValidationRows collect: [ :row |
		  row first = 'collectionFormat'
			  ifTrue: [ #( 'collectionFormat' scalar #( v2 ) structural false 'csv ssv tsv pipes, or multi (query and formData parameters only)' ) ]
			  ifFalse: [ row ] ]
]

{ #category : 'data - operations' }
FamixOpenApiSpecFieldTable class >> dataV2ValidationRows [
	"Swagger 2.0 fields (other than type) shared by Parameter (non-body), Header and Items"

	^ #( #( 'format' scalar #( v2 ) structural false '' )
	     #( 'items' object #( v2 ) structural true 'conditionally required: only when type is array' )
	     #( 'collectionFormat' scalar #( v2 ) structural false 'csv ssv tsv pipes (multi is valid only on the Parameter Object, not on Header or Items)' )
	     #( 'default' any #( v2 ) structural false '' )
	     #( 'maximum' scalar #( v2 ) structural false '' )
	     #( 'exclusiveMaximum' scalar #( v2 ) structural false 'boolean' )
	     #( 'minimum' scalar #( v2 ) structural false '' )
	     #( 'exclusiveMinimum' scalar #( v2 ) structural false 'boolean' )
	     #( 'maxLength' scalar #( v2 ) structural false '' )
	     #( 'minLength' scalar #( v2 ) structural false '' )
	     #( 'pattern' scalar #( v2 ) structural false '' )
	     #( 'maxItems' scalar #( v2 ) structural false '' )
	     #( 'minItems' scalar #( v2 ) structural false '' )
	     #( 'uniqueItems' scalar #( v2 ) structural false '' )
	     #( 'enum' array #( v2 ) structural false '' )
	     #( 'multipleOf' scalar #( v2 ) structural false '' ) )
]

{ #category : 'data - schema' }
FamixOpenApiSpecFieldTable class >> dataXml [

	^ #( #( 'name' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'namespace' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'prefix' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'attribute' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'wrapped' scalar #( v30 v31 v2 ) useful false '' )
	     #( 'x-*' any #( v30 v31 v2 ) metadata false 'specification extensions' ) )
]

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> fieldsAt: aLevel in: aVersionSymbol [

	^ (self fieldsIn: aVersionSymbol) select: [ :each |
		  each level = aLevel ]
]

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> fieldsFor: aSpecObjectName in: aVersionSymbol [

	^ (self fieldsIn: aVersionSymbol) select: [ :each |
		  each specObject = aSpecObjectName ]
]

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> fieldsIn: aVersionSymbol [

	^ self allFields select: [ :each | each appliesIn: aVersionSymbol ]
]

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> levelOf: aSpecObjectName field: aFieldName in: aVersionSymbol [
	"Answer the level of the field, or nil when the field does not exist in this version"

	^ (self fieldsFor: aSpecObjectName in: aVersionSymbol)
		  detect: [ :each | each name = aFieldName ]
		  ifFound: [ :each | each level ]
		  ifNone: [ nil ]
]

{ #category : 'markdown' }
FamixOpenApiSpecFieldTable class >> markdownSummary [
	"Answer a Markdown String reviewing the whole table: one section per version, one table per spec object. Lines are separated by LF"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: '# OpenAPI specification fields';
			  nextPutAll: String lf;
			  nextPutAll: String lf.
		  self versions do: [ :version |
			  self writeMarkdownFor: version on: stream ] ]
]

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> objectNamesIn: aVersionSymbol [
	"Answer the names of the spec objects existing in this version, in declaration order"

	| names |
	names := OrderedCollection new.
	(self fieldsIn: aVersionSymbol) do: [ :each |
		names addIfNotPresent: each specObject ].
	^ names asArray
]

{ #category : 'data - registry' }
FamixOpenApiSpecFieldTable class >> operationsGroup [

	^ {
		  ('Paths' -> self dataPaths).
		  ('PathItem' -> self dataPathItem).
		  ('Operation' -> self dataOperation).
		  ('ExternalDocumentation' -> self dataExternalDocumentation).
		  ('Parameter' -> (self dataParameter , self dataV2ParameterValidationRows)).
		  ('RequestBody' -> self dataRequestBody).
		  ('MediaType' -> self dataMediaType).
		  ('Encoding' -> self dataEncoding) }
]

{ #category : 'data - registry' }
FamixOpenApiSpecFieldTable class >> responsesGroup [

	^ {
		  ('Responses' -> self dataResponses).
		  ('Response' -> self dataResponse).
		  ('Callback' -> self dataCallback).
		  ('Example' -> self dataExample).
		  ('Link' -> self dataLink).
		  ('Header' -> (self dataHeader , self dataV2ValidationRows)).
		  ('Items' -> (self dataItems , self dataV2ValidationRows)) }
]

{ #category : 'data - registry' }
FamixOpenApiSpecFieldTable class >> rootGroup [

	^ {
		  ('OpenAPI' -> self dataOpenApi).
		  ('Swagger' -> self dataSwagger).
		  ('Info' -> self dataInfo).
		  ('Contact' -> self dataContact).
		  ('License' -> self dataLicense).
		  ('Server' -> self dataServer).
		  ('ServerVariable' -> self dataServerVariable).
		  ('Components' -> self dataComponents) }
]

{ #category : 'data - registry' }
FamixOpenApiSpecFieldTable class >> schemaGroup [

	^ {
		  ('Tag' -> self dataTag).
		  ('Reference' -> self dataReference).
		  ('Schema' -> self dataSchema).
		  ('Discriminator' -> self dataDiscriminator).
		  ('XML' -> self dataXml) }
]

{ #category : 'data - registry' }
FamixOpenApiSpecFieldTable class >> securityGroup [

	^ {
		  ('SecurityScheme' -> self dataSecurityScheme).
		  ('OAuthFlows' -> self dataOAuthFlows).
		  ('OAuthFlow' -> self dataOAuthFlow).
		  ('Scopes' -> self dataScopes).
		  ('SecurityRequirement' -> self dataSecurityRequirement) }
]

{ #category : 'data - registry' }
FamixOpenApiSpecFieldTable class >> specObjectRows [
	"Answer associations spec object name -> rows, for every spec object of every version"

	^ self rootGroup , self operationsGroup , self responsesGroup
	  , self schemaGroup , self securityGroup
]

{ #category : 'markdown' }
FamixOpenApiSpecFieldTable class >> versionLabelFor: aVersionSymbol [

	^ {
		  (#v30 -> 'OpenAPI 3.0.3').
		  (#v31 -> 'OpenAPI 3.1.x').
		  (#v2 -> 'Swagger 2.0') } asDictionary at: aVersionSymbol
]

{ #category : 'api' }
FamixOpenApiSpecFieldTable class >> versions [

	^ #( v30 v31 v2 )
]

{ #category : 'markdown' }
FamixOpenApiSpecFieldTable class >> writeMarkdownField: aField on: aStream [

	aStream
		nextPutAll: '| `';
		nextPutAll: aField name;
		nextPutAll: '` | ';
		nextPutAll: aField kind;
		nextPutAll: ' | ';
		nextPutAll: aField level;
		nextPutAll: ' | ';
		nextPutAll: (aField isRequired
				 ifTrue: [ 'R' ]
				 ifFalse: [ '' ]);
		nextPutAll: ' | ';
		nextPutAll: aField note;
		nextPutAll: ' |';
		nextPutAll: String lf
]

{ #category : 'markdown' }
FamixOpenApiSpecFieldTable class >> writeMarkdownFor: aVersionSymbol on: aStream [

	aStream
		nextPutAll: '## ';
		nextPutAll: (self versionLabelFor: aVersionSymbol);
		nextPutAll: String lf;
		nextPutAll: String lf.
	(self objectNamesIn: aVersionSymbol) do: [ :objectName |
		self writeMarkdownObject: objectName in: aVersionSymbol on: aStream ]
]

{ #category : 'markdown' }
FamixOpenApiSpecFieldTable class >> writeMarkdownObject: aSpecObjectName in: aVersionSymbol on: aStream [

	aStream
		nextPutAll: '### ';
		nextPutAll: aSpecObjectName;
		nextPutAll: String lf;
		nextPutAll: String lf.
	aStream
		nextPutAll: '| field | kind | level | R | note |';
		nextPutAll: String lf.
	aStream
		nextPutAll: '|---|---|---|---|---|';
		nextPutAll: String lf.
	(self fieldsFor: aSpecObjectName in: aVersionSymbol) do: [ :field |
		self writeMarkdownField: field on: aStream ].
	aStream nextPutAll: String lf
]
