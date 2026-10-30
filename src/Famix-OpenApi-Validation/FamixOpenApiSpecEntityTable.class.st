"
The data of the existence check: for every spec object of the OpenAPI grammar, the OP class of the entity the importer builds at the pointer of its source node, or none. The table is only the BASE case (a plain, inline object of that kind, imported with mergesInlineSchemas = false): FamixOpenApiNodeExpectation applies the context rules on top of it ($ref, properties, boolean schemas, Swagger 2 parameters). It is deliberately not FamixOpenApiFieldMapping classNameFor:, which is a stand-in made for the conformance check ('Paths' is carried by OPPath, 'Items' by OPSchema, 'Responses' by OPResponse there, while no entity sits at those nodes). Data methods: #dataEntities (every version), #dataNoEntity (objects with no entity of their own, every version) and #dataSwagger2 (what changes in Swagger 2).
"
Class {
	#name : 'FamixOpenApiSpecEntityTable',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'api' }
FamixOpenApiSpecEntityTable class >> classNameFor: aSpecObjectName version: aVersionSymbol [
	"The name of the OP class of the entity at the pointer of a plain node of the spec object, nil when there is none (or for 'Reference', ruled by its context)"

	| row |
	row := (aVersionSymbol = #v2
		        ifTrue: [
		        self rowFor: aSpecObjectName in: self dataSwagger2 ]
		        ifFalse: [ nil ]) ifNil: [
		       self rowFor: aSpecObjectName in: self dataEntities ].
	row ifNil: [ ^ nil ].
	^ row second = #none
		  ifTrue: [ nil ]
		  ifFalse: [ row second ]
]

{ #category : 'data' }
FamixOpenApiSpecEntityTable class >> dataEntities [
	"Rows: spec object, name of the OP class of the entity at the pointer of the node"

	^ #( #( 'OpenAPI' 'OPOpenApi' ) #( 'Swagger' 'OPOpenApi' )
	     #( 'Info' 'OPInfo' ) #( 'Contact' 'OPContact' )
	     #( 'License' 'OPLicense' ) #( 'Server' 'OPServer' )
	     #( 'ServerVariable' 'OPServerVariable' )
	     #( 'Components' 'OPComponents' )
	     #( 'PathItem' 'OPPath' ) #( 'Operation' 'OPOperation' )
	     #( 'ExternalDocumentation' 'OPExternalDocumentation' )
	     #( 'Parameter' 'OPParameter' ) #( 'RequestBody' 'OPRequestBody' )
	     #( 'MediaType' 'OPMediaType' ) #( 'Encoding' 'OPEncoding' )
	     #( 'Response' 'OPResponse' ) #( 'Callback' 'OPCallback' )
	     #( 'Example' 'OPExample' ) #( 'Link' 'OPLink' )
	     #( 'Header' 'OPHeader' ) #( 'Tag' 'OPTag' ) #( 'Schema' 'OPSchema' )
	     #( 'Discriminator' 'OPDiscriminator' )
	     #( 'XML' 'OPXmlElement' ) #( 'SecurityScheme' 'OPSecurityScheme' )
	     #( 'OAuthFlow' 'OPOAuthFlow' ) #( 'SecurityRequirement'
	        'OPSecurityRequirement' ) )
]

{ #category : 'data' }
FamixOpenApiSpecEntityTable class >> dataNoEntity [
	"Rows: spec object, why no entity sits at the pointer of its node (every version)"

	^ #( #( 'Paths' 'container of the path items: the paths are its entries, #/paths has no entity' )
	     #( 'Responses' 'container of the responses of an operation: no entity of its own' )
	     #( 'OAuthFlows' 'container of the flows: the OPSecurityScheme carries it, the flows are OPOAuthFlow' )
	     #( 'Scopes' 'map name -> description: each key is an OPSecurityScope at <pointer>/<name>, a synthetic pointer' )
	     #( 'Items' 'Swagger 2 items of a typed parameter: the schema is built at <parameter>/schema/items, a synthetic pointer; the items of a header give nothing' ) )
]

{ #category : 'data' }
FamixOpenApiSpecEntityTable class >> dataSwagger2 [
	"Rows: spec object, name of the OP class or #none, why. What differs from #dataEntities in a Swagger 2 document"

	^ #( #( 'Example' #none 'the examples of a response are a map mime type -> value: only OpenAPI 3 has Example objects' ) )
]

{ #category : 'api' }
FamixOpenApiSpecEntityTable class >> decidesOn: aSpecObjectName version: aVersionSymbol [
	"True when the table says something about the spec object: an entity, no entity or the context rules for a Reference"

	^ aSpecObjectName = 'Reference' or: [
		  (aVersionSymbol = #v2 and: [
			   (self rowFor: aSpecObjectName in: self dataSwagger2) isNotNil ])
			  or: [
				  (self rowFor: aSpecObjectName in: self dataEntities) isNotNil
					  or: [
					  (self rowFor: aSpecObjectName in: self dataNoEntity) isNotNil ] ] ]
]

{ #category : 'api' }
FamixOpenApiSpecEntityTable class >> noteFor: aSpecObjectName version: aVersionSymbol [
	"Why the spec object has no entity of its own, or an empty String"

	aVersionSymbol = #v2 ifTrue: [
		(self rowFor: aSpecObjectName in: self dataSwagger2) ifNotNil: [
			:row | ^ row last ] ].
	^ (self rowFor: aSpecObjectName in: self dataNoEntity)
		  ifNil: [ '' ]
		  ifNotNil: [ :row | row last ]
]

{ #category : 'private' }
FamixOpenApiSpecEntityTable class >> rowFor: aSpecObjectName in: aTable [

	^ aTable
		  detect: [ :each | each first = aSpecObjectName ]
		  ifNone: [ nil ]
]
