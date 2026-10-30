"
I test FamixOpenApiSourceWalker on small hand-written documents per spec object and per version (OpenAPI 3.0, 3.1, Swagger 2): exact node counts and pointers, $ref nodes, extension and unknown keys, wrong shapes, boolean schemas, pointer escaping and the cross-check of the pointer format with the importer.
"
Class {
	#name : 'FamixOpenApiSourceWalkerTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> documentWithSchema: aSchemaObject [
	"An OpenAPI 3.0 document (ordered objects, built without the JSON parser) holding aSchemaObject as components.schemas.Deep"

	| schemas components |
	schemas := OrderedDictionary new.
	schemas at: 'Deep' put: aSchemaObject.
	components := OrderedDictionary new.
	components at: 'schemas' put: schemas.
	^ OrderedDictionary new
		  at: 'openapi' put: '3.0.3';
		  at: 'components' put: components;
		  yourself
]

{ #category : 'tests - pointers' }
FamixOpenApiSourceWalkerTest >> importerPointersWithoutNodeIn: aJsonString [
	"The canonical pointers of the entities of the importer that are not a node of the inventory (in importer order), the default server excepted"

	| importer inventory |
	importer := FamixOpenApiImporter new.
	importer importFromString: aJsonString.
	inventory := self inventoryOf: aJsonString.
	^ (importer model entities collect: [ :each | each canonicalPointer ])
		  reject: [ :pointer |
			  (inventory includesPointer: pointer) or: [
				  pointer beginsWith: '#/servers/' ] ]
]

{ #category : 'helpers' }
FamixOpenApiSourceWalkerTest >> inventoryOf: aJsonString [
	"The inventory of the document of aJsonString, parsed with ordered objects like the importer does"

	^ FamixOpenApiSourceWalker new walkString: aJsonString
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> malformedDocuments [
	"Documents of a known version whose values do not fit the grammar"

	^ #( '{"openapi":"3.0.0","paths":null}'
	     '{"openapi":"3.0.0","paths":"x","info":5,"components":null,"servers":null,"security":7}'
	     '{"openapi":"3.0.0","components":{"schemas":{"a":null,"b":[],"c":"s","d":{"properties":[],"allOf":{},"items":[{}],"required":"x","enum":3}}}}'
	     '{"swagger":"2.0","definitions":{"a":null,"b":[],"c":"s"},"securityDefinitions":{"s":{"scopes":[]}},"parameters":[],"responses":7}'
	     '{"openapi":"3.1.0","components":{"schemas":{"a":{"properties":{"p":{"items":[{},{}]}},"prefixItems":{},"$defs":[],"dependentRequired":{"a":"b"},"const":{},"if":3}}}}'
	     '{"openapi":"3.0.0","paths":{"/a":{"get":{"responses":{"200":{"content":{"a":{"encoding":{"b":{"headers":3}}}},"links":{"l":{"server":[]}}}}}}}}'
	     '{"openapi":"3.0.0","components":{"securitySchemes":{"s":{"flows":{"implicit":[],"password":{"scopes":3}}}}}}'
	     '{"openapi":"3.0.0","$ref":"#/x","paths":{}}'
	     '{"swagger":"2.0","paths":{"/a":{"get":{"parameters":[{"items":5},{"items":[]}]}}}}' )
]

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> nestedSchema: aDepth through: aKeyword [
	"A schema nested aDepth times: through items (an object) or through allOf (an array)"

	| node |
	node := OrderedDictionary new
		        at: 'type' put: 'string';
		        yourself.
	aDepth timesRepeat: [
		node := OrderedDictionary new
			        at: aKeyword put: (aKeyword = 'allOf'
					         ifTrue: [ { node } ]
					         ifFalse: [ node ]);
			        yourself ].
	^ node
]

{ #category : 'helpers' }
FamixOpenApiSourceWalkerTest >> openApi30Document [
	"2 paths, 3 operations, 1 parameter with a schema, 4 responses in 3 Responses"

	^ '{"openapi":"3.0.3","info":{"title":"T","version":"1"},"paths":{"/pets":{"get":{"parameters":[{"name":"limit","in":"query","schema":{"type":"integer"}}],"responses":{"200":{"description":"ok"},"default":{"description":"err"}}},"post":{"responses":{"201":{"description":"c"}}}},"/pets/{id}":{"delete":{"responses":{"204":{"description":"d"}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiSourceWalkerTest >> openApi31Document [

	^ '{"openapi":"3.1.0","info":{"title":"T","version":"1"},"webhooks":{"newPet":{"post":{"requestBody":{"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}}}},"responses":{"200":{"description":"ok"}}}}},"components":{"schemas":{"Pet":{"type":"object","properties":{"tags":{"type":"array","prefixItems":[{"type":"string"},true],"items":false},"meta":{"patternProperties":{"^x":{"type":"string"}},"$defs":{"d":{"type":"integer"}},"dependentSchemas":{"a":{"required":["b"]}},"if":{"type":"string"},"then":{"minLength":1},"else":false,"not":{"type":"null"}}},"discriminator":{"propertyName":"t","mapping":{"a":"#/x"}}}},"pathItems":{"shared":{"get":{"responses":{"200":{"description":"ok"}}}}}}}'
]

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> pointerRepeating: aToken times: aCount [
	"'#/components/schemas/Deep' followed by aCount times /aToken"

	^ String streamContents: [ :stream |
		  stream nextPutAll: '#/components/schemas/Deep'.
		  aCount timesRepeat: [
			  stream
				  nextPut: $/;
				  nextPutAll: aToken ] ]
]

{ #category : 'helpers' }
FamixOpenApiSourceWalkerTest >> swagger2Document [

	^ '{"swagger":"2.0","info":{"title":"T","version":"1"},"paths":{"/pets":{"get":{"parameters":[{"name":"q","in":"query","type":"array","items":{"type":"array","items":{"type":"string","items":{"type":"integer"}}}},{"name":"body","in":"body","schema":{"$ref":"#/definitions/Pet"}}],"responses":{"200":{"description":"ok","schema":{"type":"array","items":{"$ref":"#/definitions/Pet"}},"headers":{"X-Rate":{"type":"integer"}},"examples":{"application/json":{"a":1}}}}}}},"definitions":{"Pet":{"type":"object","discriminator":"kind","properties":{"id":{"type":"integer"}},"xml":{"name":"pet"}}},"parameters":{"Limit":{"name":"limit","in":"query","type":"integer"}},"responses":{"NotFound":{"description":"nf"}},"securityDefinitions":{"oauth":{"type":"oauth2","scopes":{"read":"Read","write":"Write"}}},"security":[{"oauth":["read"]}]}'
]

{ #category : 'tests - schemas' }
FamixOpenApiSourceWalkerTest >> testABooleanOutsideASchemaPositionIsWrongShape [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.1.0","info":true,"paths":{"/a":false},"components":{"parameters":{"p":true}}}'.
	self
		assert: (inventory wrongShapeNodes collect: #pointer)
		equals: #( '#/info' '#/paths/~1a' '#/components/parameters/p' )
]

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> testASchemaWith5000PropertiesIsWalked [

	| properties schema inventory |
	properties := OrderedDictionary new.
	1 to: 5000 do: [ :index |
		properties
			at: ('p<1p>' expandMacrosWith: index)
			put: (OrderedDictionary new
					 at: 'type' put: 'string';
					 yourself) ].
	schema := OrderedDictionary new
		          at: 'properties' put: properties;
		          yourself.
	inventory := FamixOpenApiSourceWalker new walk:
		             (self documentWithSchema: schema).
	self assert: (inventory countOf: 'Schema') equals: 5001.
	self
		assert:
		(inventory childrenOf: '#/components/schemas/Deep/properties') size
		equals: 5000.
	self assert: (inventory includesPointer:
			 '#/components/schemas/Deep/properties/p5000').
	self
		assert:
			(inventory childrenOf: '#/components/schemas/Deep/properties')
				first key
		equals: 'p1'
]

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> testAWideDocumentWith3000PathsIsWalked [

	| paths inventory |
	paths := OrderedDictionary new.
	1 to: 3000 do: [ :index |
		paths
			at: ('/p<1p>' expandMacrosWith: index)
			put: (OrderedDictionary new
					 at: 'get' put: OrderedDictionary new;
					 yourself) ].
	inventory := FamixOpenApiSourceWalker new walk:
		             (OrderedDictionary new
			              at: 'openapi' put: '3.0.3';
			              at: 'paths' put: paths;
			              yourself).
	self assert: inventory pathCount equals: 3000.
	self assert: (inventory countOf: 'Operation') equals: 3000.
	self assert: (inventory operationCountOf: 'get') equals: 3000
]

{ #category : 'tests - schemas' }
FamixOpenApiSourceWalkerTest >> testBooleanSchemasAreSchemas [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.1.0","components":{"schemas":{"T":true,"F":false,"O":{"additionalProperties":false,"items":true,"properties":{"p":true}}}}}'.
	self assert: (inventory countOf: 'Schema') equals: 6.
	self assert: inventory wrongShapeNodes isEmpty.
	self
		assert: (inventory nodeAt: '#/components/schemas/T') value
		equals: true.
	self
		assert: (inventory nodeAt: '#/components/schemas/F') specObject
		equals: 'Schema'.
	self
		assert:
			(inventory nodeAt: '#/components/schemas/O/additionalProperties')
				value
		equals: false.
	self assert: inventory componentSchemaCount equals: 3
]

{ #category : 'tests - other objects' }
FamixOpenApiSourceWalkerTest >> testComponentsMapsAndCallbacks [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.3","components":{"responses":{"R":{"description":"d","headers":{"H":{"schema":{"type":"string"}}},"links":{"L":{"operationId":"x","server":{"url":"u","variables":{"v":{"default":"1","enum":["1","2"]}}}}}}},"parameters":{"P":{"name":"p","in":"query","content":{"text/plain":{"schema":{"type":"string"},"examples":{"E":{"value":1}},"encoding":{"a":{"headers":{"H2":{"description":"x"}}}}}}}},"requestBodies":{"B":{"content":{}}},"securitySchemes":{"S":{"type":"oauth2","flows":{"implicit":{"scopes":{"a":"b"}},"password":{},"clientCredentials":{},"authorizationCode":{}}}},"callbacks":{"C":{"{$request.body#/url}":{"post":{"responses":{"200":{"description":"ok"}}}}}}}}'.
	self assert: (inventory countOf: 'Components') equals: 1.
	self assert: (inventory countOf: 'Response') equals: 2.
	self assert: (inventory countOf: 'Header') equals: 2.
	self assert: (inventory countOf: 'Link') equals: 1.
	self assert: (inventory countOf: 'Server') equals: 1.
	self assert: (inventory countOf: 'ServerVariable') equals: 1.
	self assert: (inventory countOf: 'Parameter') equals: 1.
	self assert: (inventory countOf: 'MediaType') equals: 1.
	self assert: (inventory countOf: 'Example') equals: 1.
	self assert: (inventory countOf: 'Encoding') equals: 1.
	self assert: (inventory countOf: 'RequestBody') equals: 1.
	self assert: (inventory countOf: 'SecurityScheme') equals: 1.
	self assert: (inventory countOf: 'OAuthFlows') equals: 1.
	self assert: (inventory countOf: 'OAuthFlow') equals: 4.
	self assert: (inventory countOf: 'Callback') equals: 1.
	self assert: (inventory countOf: 'PathItem') equals: 1.
	self assert: (inventory countOf: 'Operation') equals: 1.
	self assert: (inventory countOf: 'Schema') equals: 2.
	self
		assert: (inventory includesPointer:
				 '#/components/callbacks/C/{$request.body#/url}') not
		description: 'the expression is escaped'.
	self assert: (inventory includesPointer:
			 '#/components/callbacks/C/{$request.body#~1url}').
	self assert: inventory unknownKeys isEmpty.
	self assert: inventory wrongShapeNodes isEmpty
]

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> testDepth2000NestedAllOfArraysDoesNotUseTheCallStack [

	| walker inventory |
	walker := FamixOpenApiDepthProbeWalker new.
	inventory := walker walk:
		             (self documentWithSchema:
			              (self nestedSchema: 2000 through: 'allOf')).
	self assert: (inventory countOf: 'Schema') equals: 2001.
	self assert: (inventory includesPointer:
			 (self pointerRepeating: 'allOf/0' times: 2000)).
	self assert: walker stackGrowth <= 2
]

{ #category : 'tests - depth' }
FamixOpenApiSourceWalkerTest >> testDepth2000NestedItemsDoesNotUseTheCallStack [

	| walker inventory |
	walker := FamixOpenApiDepthProbeWalker new.
	inventory := walker walk:
		             (self documentWithSchema:
			              (self nestedSchema: 2000 through: 'items')).
	self assert: (inventory countOf: 'Schema') equals: 2001.
	self assert: (inventory includesPointer:
			 (self pointerRepeating: 'items' times: 2000)).
	self deny: (inventory includesPointer:
			 (self pointerRepeating: 'items' times: 2001)).
	self assert: walker stackGrowth <= 2
]

{ #category : 'tests - pointers' }
FamixOpenApiSourceWalkerTest >> testEveryImporterPointerOfOpenApi3IsAPointerOfTheInventory [
	"Cross-check with the importer. The only exception: the importer has an entity for each entry of a discriminator mapping, a scalar below the Discriminator node"

	{
		self openApi30Document.
		self openApi31Document } do: [ :text |
		self
			assert:
				((self importerPointersWithoutNodeIn: text) reject: [ :pointer |
					 pointer includesSubstring: '/discriminator/mapping/' ]) asArray
			equals: #(  ) ]
]

{ #category : 'tests - keys' }
FamixOpenApiSourceWalkerTest >> testExtensionKeysAreRecordedAndUnknownKeysToo [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","x-root":1,"bogus":2,"info":{"title":"t","x-a":{"deep":[1]},"x-b":2,"nope":true},"paths":{"x-p":1,"/a":{"x-q":1,"get":{"x-r":1,"responses":{"x-s":1,"200":{"description":"d","wat":1}}}}}}'.
	self
		assert: inventory unknownKeys
		equals:
		#( '#/bogus' '#/info/nope' '#/paths/~1a/get/responses/200/wat' ).
	self
		assert: inventory extensionKeys
		equals:
			#( '#/x-root' '#/info/x-a' '#/info/x-b' '#/paths/x-p' '#/paths/~1a/x-q'
			   '#/paths/~1a/get/x-r' '#/paths/~1a/get/responses/x-s' ).
	self
		assert: (inventory nodeAt: '#/info') unknownKeys asArray
		equals: #( 'nope' ).
	self
		assert: (inventory nodeAt: '#/info') extensionKeys asArray
		equals: #( 'x-a' 'x-b' ).
	self deny: (inventory includesPointer: '#/info/x-a').
	self deny: (inventory includesPointer: '#/paths/x-p').
	self assert: inventory pathCount equals: 1.
	self assert: inventory wrongShapeNodes isEmpty.
	self assert: inventory pointers size equals: 7
]

{ #category : 'tests - keys' }
FamixOpenApiSourceWalkerTest >> testExtensionKeysDependOnTheObjectAndTheVersion [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.3","components":{"schemas":{"A":{"discriminator":{"propertyName":"t","x-d":1}}}}}'.
	self
		assert: inventory unknownKeys
		equals: #( '#/components/schemas/A/discriminator/x-d' ).
	inventory := self inventoryOf:
		             '{"openapi":"3.1.0","components":{"schemas":{"A":{"discriminator":{"propertyName":"t","x-d":1}}}}}'.
	self assert: inventory unknownKeys isEmpty.
	self
		assert: inventory extensionKeys
		equals: #( '#/components/schemas/A/discriminator/x-d' )
]

{ #category : 'tests - keys' }
FamixOpenApiSourceWalkerTest >> testKeyOrderOfTheDocumentIsKept [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","paths":{"/z":{},"/a":{},"/m":{}}}'.
	self
		assert: ((inventory childrenOf: '#/paths') collect: #key)
		equals: #( '/z' '/a' '/m' )
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> testMalformedDocumentsStillRecordTheirValidParts [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","paths":"x","info":{"title":"t"},"components":{"schemas":{"a":null,"b":{"type":"string"}}}}'.
	self assert: (inventory countOf: 'Info') equals: 1.
	self assert: (inventory countOf: 'Schema') equals: 1.
	self
		assert: (inventory wrongShapeNodes collect: #pointer)
		equals: #( '#/paths' '#/components/schemas/a' ).
	self assert: inventory pathCount equals: 0
]

{ #category : 'tests - OpenAPI 3.0' }
FamixOpenApiSourceWalkerTest >> testOpenApi30CountsPerSpecObject [

	| inventory |
	inventory := self inventoryOf: self openApi30Document.
	self assert: (inventory countOf: 'OpenAPI') equals: 1.
	self assert: (inventory countOf: 'Info') equals: 1.
	self assert: (inventory countOf: 'Paths') equals: 1.
	self assert: (inventory countOf: 'PathItem') equals: 2.
	self assert: (inventory countOf: 'Operation') equals: 3.
	self assert: (inventory countOf: 'Parameter') equals: 1.
	self assert: (inventory countOf: 'Schema') equals: 1.
	self assert: (inventory countOf: 'Responses') equals: 3.
	self assert: (inventory countOf: 'Response') equals: 4.
	self assert: (inventory countOf: 'Reference') equals: 0.
	self assert: inventory pointers size equals: 17.
	self assert: inventory pathCount equals: 2.
	self assert: (inventory operationCountOf: 'get') equals: 1.
	self assert: (inventory operationCountOf: 'delete') equals: 1.
	self assert: (inventory operationCountOf: 'put') equals: 0
]

{ #category : 'tests - OpenAPI 3.0' }
FamixOpenApiSourceWalkerTest >> testOpenApi30PointersInDocumentOrder [

	self
		assert: (self inventoryOf: self openApi30Document) pointers
		equals:
			#( '#' '#/info' '#/paths' '#/paths/~1pets' '#/paths/~1pets/get'
			   '#/paths/~1pets/get/parameters/0'
			   '#/paths/~1pets/get/parameters/0/schema'
			   '#/paths/~1pets/get/responses' '#/paths/~1pets/get/responses/200'
			   '#/paths/~1pets/get/responses/default'
			   '#/paths/~1pets/post' '#/paths/~1pets/post/responses'
			   '#/paths/~1pets/post/responses/201'
			   '#/paths/~1pets~1{id}' '#/paths/~1pets~1{id}/delete'
			   '#/paths/~1pets~1{id}/delete/responses'
			   '#/paths/~1pets~1{id}/delete/responses/204' )
]

{ #category : 'tests - OpenAPI 3.1' }
FamixOpenApiSourceWalkerTest >> testOpenApi31CountsPerSpecObject [

	| inventory |
	inventory := self inventoryOf: self openApi31Document.
	self assert: (inventory countOf: 'OpenAPI') equals: 1.
	self assert: (inventory countOf: 'PathItem') equals: 2.
	self assert: (inventory countOf: 'Operation') equals: 2.
	self assert: (inventory countOf: 'RequestBody') equals: 1.
	self assert: (inventory countOf: 'MediaType') equals: 1.
	self assert: (inventory countOf: 'Reference') equals: 1.
	self assert: (inventory countOf: 'Responses') equals: 2.
	self assert: (inventory countOf: 'Response') equals: 2.
	self assert: (inventory countOf: 'Components') equals: 1.
	self assert: (inventory countOf: 'Discriminator') equals: 1.
	self assert: (inventory countOf: 'Schema') equals: 13.
	self assert: inventory wrongShapeNodes isEmpty.
	self assert: inventory unknownKeys isEmpty
]

{ #category : 'tests - OpenAPI 3.1' }
FamixOpenApiSourceWalkerTest >> testOpenApi31SchemaKeywordPointers [

	| inventory |
	inventory := self inventoryOf: self openApi31Document.
	#( '#/webhooks/newPet' '#/webhooks/newPet/post/requestBody/content/application~1json/schema'
	   '#/components/pathItems/shared' '#/components/schemas/Pet/properties/tags/prefixItems/0'
	   '#/components/schemas/Pet/properties/tags/prefixItems/1'
	   '#/components/schemas/Pet/properties/tags/items'
	   '#/components/schemas/Pet/properties/meta/patternProperties/^x'
	   '#/components/schemas/Pet/properties/meta/$defs/d'
	   '#/components/schemas/Pet/properties/meta/dependentSchemas/a'
	   '#/components/schemas/Pet/properties/meta/if'
	   '#/components/schemas/Pet/properties/meta/then'
	   '#/components/schemas/Pet/properties/meta/else'
	   '#/components/schemas/Pet/properties/meta/not'
	   '#/components/schemas/Pet/discriminator' ) do: [ :pointer |
		self
			assert: (inventory includesPointer: pointer)
			description: pointer ].
	self
		assert: (inventory nodeAt: '#/webhooks/newPet') specObject
		equals: 'PathItem'.
	self
		assert:
		(inventory nodeAt: '#/components/pathItems/shared') specObject
		equals: 'PathItem'.
	self deny: (inventory includesPointer:
			 '#/components/schemas/Pet/discriminator/mapping')
]

{ #category : 'tests - pointers' }
FamixOpenApiSourceWalkerTest >> testPointerEscaping [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","paths":{"/a~b":{"get":{"responses":{"200":{"description":"d"}}}}},"components":{"schemas":{"a/b":{"properties":{"c~1d":{"type":"string"},"~/":{"type":"string"}}}}}}'.
	#( '#/paths/~1a~0b' '#/paths/~1a~0b/get' '#/components/schemas/a~1b'
	   '#/components/schemas/a~1b/properties/c~01d'
	   '#/components/schemas/a~1b/properties/~0~1' ) do: [ :pointer |
		self
			assert: (inventory includesPointer: pointer)
			description: pointer ]
]

{ #category : 'tests - pointers' }
FamixOpenApiSourceWalkerTest >> testPointerEscapingIsTheOneOfTheImporter [

	#( 'plain' '/a~b' 'a/b' '~' '/' '~/' '~1' '~0' '' 'a~1b/~0' ) do: [
		:token |
		self
			assert: (FamixOpenApiSourceNode escapeToken: token)
			equals: (FamixOpenApiJsonPointer encodeToken: token) ].
	self
		assert:
		(FamixOpenApiSourceNode pointerOf: '#/paths' child: '/pets~x')
		equals:
		(FamixOpenApiJsonPointer pointer: '#/paths' appending: '/pets~x').
	self
		assert: (FamixOpenApiSourceNode pointerOf: '#/a' child: 3)
		equals: (FamixOpenApiJsonPointer pointer: '#/a' appending: 3)
]

{ #category : 'tests - references' }
FamixOpenApiSourceWalkerTest >> testReferenceNodeIsCountedAndNotFollowed [

	| inventory node |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","paths":{"/a":{"get":{"responses":{"200":{"$ref":"#/components/responses/R","description":"ignored","x-no":1,"bogus":2}}}}},"components":{"responses":{"R":{"description":"d","content":{"a/b":{"schema":{"type":"string"}}}}}}}'.
	node := inventory nodeAt: '#/paths/~1a/get/responses/200'.
	self assert: node specObject equals: 'Reference'.
	self assert: node isReference.
	self deny: node isWrongShape.
	self assert: (inventory countOf: 'Reference') equals: 1.
	self assert: (inventory countOf: 'Response') equals: 1.
	self assert: (inventory nodesOf: 'Reference') equals: { node }.
	self assert: (inventory childrenOf: node pointer) isEmpty.
	self assert: inventory unknownKeys isEmpty.
	self assert: inventory extensionKeys isEmpty.
	self
		assert: (node value at: '$ref')
		equals: '#/components/responses/R'.
	self assert: (inventory countOf: 'MediaType') equals: 1.
	self assert: (inventory countOf: 'Schema') equals: 1.
	self deny: (inventory includesPointer:
			 '#/components/responses/R/content/a~1b/schema/type')
]

{ #category : 'tests - references' }
FamixOpenApiSourceWalkerTest >> testReferencesAtEveryPositionOfASchema [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","components":{"schemas":{"A":{"$ref":"#/x"},"B":{"allOf":[{"$ref":"#/a"},{"type":"string"}],"properties":{"p":{"$ref":"#/b"}},"items":{"$ref":"#/c"},"not":{"$ref":"#/d"},"additionalProperties":{"$ref":"#/e"}}}}}'.
	self assert: (inventory countOf: 'Reference') equals: 6.
	self assert: (inventory countOf: 'Schema') equals: 2.
	self assert: inventory componentSchemaCount equals: 2
]

{ #category : 'tests - other objects' }
FamixOpenApiSourceWalkerTest >> testRootObjectsInfoContactLicenseTagsAndSecurity [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.3","info":{"title":"T","version":"1","contact":{"name":"c"},"license":{"name":"MIT"}},"servers":[{"url":"u"},{"url":"v"}],"tags":[{"name":"t","externalDocs":{"url":"x"}}],"externalDocs":{"url":"y"},"security":[{"a":[]},{}],"paths":{"/p":{"parameters":[{"name":"n","in":"query"}],"servers":[{"url":"w"}],"get":{"tags":["t"],"externalDocs":{"url":"z"},"security":[{"b":["s"]}],"servers":[{"url":"o"}],"responses":{}}}}}'.
	self assert: (inventory countOf: 'Contact') equals: 1.
	self assert: (inventory countOf: 'License') equals: 1.
	self assert: (inventory countOf: 'Server') equals: 4.
	self assert: (inventory countOf: 'Tag') equals: 1.
	self assert: (inventory countOf: 'ExternalDocumentation') equals: 3.
	self assert: (inventory countOf: 'SecurityRequirement') equals: 3.
	self assert: (inventory countOf: 'Parameter') equals: 1.
	self assert: inventory unknownKeys isEmpty.
	self assert: inventory wrongShapeNodes isEmpty
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiSourceWalkerTest >> testSwagger2CountsPerSpecObject [

	| inventory |
	inventory := self inventoryOf: self swagger2Document.
	self assert: (inventory countOf: 'Swagger') equals: 1.
	self assert: (inventory countOf: 'Info') equals: 1.
	self assert: (inventory countOf: 'Paths') equals: 1.
	self assert: (inventory countOf: 'PathItem') equals: 1.
	self assert: (inventory countOf: 'Operation') equals: 1.
	self assert: (inventory countOf: 'Parameter') equals: 3.
	self assert: (inventory countOf: 'Items') equals: 3.
	self assert: (inventory countOf: 'Reference') equals: 2.
	self assert: (inventory countOf: 'Responses') equals: 1.
	self assert: (inventory countOf: 'Response') equals: 2.
	self assert: (inventory countOf: 'Schema') equals: 3.
	self assert: (inventory countOf: 'XML') equals: 1.
	self assert: (inventory countOf: 'Header') equals: 1.
	self assert: (inventory countOf: 'Example') equals: 1.
	self assert: (inventory countOf: 'SecurityScheme') equals: 1.
	self assert: (inventory countOf: 'Scopes') equals: 1.
	self assert: (inventory countOf: 'SecurityRequirement') equals: 1.
	self assert: inventory wrongShapeNodes isEmpty.
	self assert: inventory unknownKeys isEmpty.
	self assert: inventory componentSchemaCount equals: 1
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiSourceWalkerTest >> testSwagger2DiscriminatorIsAScalarAndComponentsAreUnknown [

	| inventory |
	inventory := self inventoryOf:
		             '{"swagger":"2.0","definitions":{"A":{"discriminator":"kind"}},"components":{}}'.
	self assert: inventory unknownKeys equals: #( '#/components' ).
	self assert: (inventory countOf: 'Discriminator') equals: 0.
	self assert: (inventory countOf: 'Schema') equals: 1
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiSourceWalkerTest >> testSwagger2PointersAndRecursiveItems [

	| inventory |
	inventory := self inventoryOf: self swagger2Document.
	#( '#/paths/~1pets/get/parameters/0/items'
	   '#/paths/~1pets/get/parameters/0/items/items'
	   '#/paths/~1pets/get/parameters/0/items/items/items'
	   '#/paths/~1pets/get/parameters/1'
	   '#/paths/~1pets/get/parameters/1/schema'
	   '#/paths/~1pets/get/responses/200/schema'
	   '#/paths/~1pets/get/responses/200/headers/X-Rate'
	   '#/paths/~1pets/get/responses/200/examples'
	   '#/definitions/Pet' '#/definitions/Pet/properties/id'
	   '#/definitions/Pet/xml' '#/parameters/Limit' '#/responses/NotFound'
	   '#/securityDefinitions/oauth' '#/securityDefinitions/oauth/scopes'
	   '#/security/0' ) do: [ :pointer |
		self
			assert: (inventory includesPointer: pointer)
			description: pointer ].
	self
		assert:
			(inventory nodeAt:
				 '#/paths/~1pets/get/parameters/0/items/items/items') specObject
		equals: 'Items'.
	self
		assert:
		(inventory nodeAt: '#/paths/~1pets/get/parameters/1') specObject
		equals: 'Parameter'.
	self
		assert:
			(inventory nodeAt: '#/paths/~1pets/get/parameters/1/schema')
				specObject
		equals: 'Reference'.
	self
		assert:
			(inventory nodeAt: '#/paths/~1pets/get/responses/200/schema/items')
				specObject
		equals: 'Reference'.
	self
		assert: (inventory nodeAt: '#/responses/NotFound') specObject
		equals: 'Response'.
	self
		assert: (inventory nodeAt: '#/parameters/Limit') specObject
		equals: 'Parameter'.
	self deny: (inventory includesPointer:
			 '#/paths/~1pets/get/responses/200/examples/application~1json')
]

{ #category : 'tests - pointers' }
FamixOpenApiSourceWalkerTest >> testSwagger2PointersThatTheImporterSynthesizes [
	"Documents what a pointer-based comparison (step V7) must know: for Swagger 2 the importer gives pointers to entities that have no node in the source (an upgraded components root, schemas of typed parameters, the */* media type, scopes, security requirement entries, a string discriminator)"

	self
		assert:
		(self importerPointersWithoutNodeIn: self swagger2Document) asArray
		equals: #( '#/components' '#/definitions/Pet/discriminator'
			   '#/securityDefinitions/oauth/scopes/read'
			   '#/securityDefinitions/oauth/scopes/write'
			   '#/paths/~1pets/get/parameters/0/schema'
			   '#/paths/~1pets/get/parameters/0/schema/items'
			   '#/paths/~1pets/get/parameters/0/schema/items/items'
			   '#/paths/~1pets/get/parameters/1/content/*~1*'
			   '#/paths/~1pets/get/responses/200/content/*~1*'
			   '#/security/0/oauth' )
]

{ #category : 'tests - versions' }
FamixOpenApiSourceWalkerTest >> testUnknownVersionGivesAnEmptyInventory [

	#( '{}' '[]' '{"openapi":3}' '{"openapi":"4.0.0"}'
	   '{"openapi":null}' '{"swagger":2}' '{"swagger":"1.2"}'
	   '"text"' '12' 'null' 'true' ) do: [ :text |
		| inventory |
		inventory := self inventoryOf: text.
		self assert: inventory version equals: #unknownVersion.
		self assert: inventory isUnknownVersion.
		self assert: inventory pointers isEmpty.
		self assert: inventory counts isEmpty ]
]

{ #category : 'tests - versions' }
FamixOpenApiSourceWalkerTest >> testValuesThatAreNotParsedDocumentsAreUnknownVersions [

	{
		nil.
		42.
		'text'.
		true.
		#(  ).
		Dictionary new.
		OrderedDictionary new } do: [ :value |
		self
			assert: (FamixOpenApiSourceWalker new walk: value) version
			equals: #unknownVersion ]
]

{ #category : 'tests - versions' }
FamixOpenApiSourceWalkerTest >> testVersionDetection [

	self
		assert: (self inventoryOf: self openApi30Document) version
		equals: #v30.
	self
		assert: (self inventoryOf: self openApi31Document) version
		equals: #v31.
	self
		assert: (self inventoryOf: self swagger2Document) version
		equals: #v2.
	self
		assert: (self inventoryOf: '{"openapi":"3.1.2"}') version
		equals: #v31.
	self
		assert: (self inventoryOf: '{"openapi":"3.0.0"}') version
		equals: #v30.
	self
		assert: (self inventoryOf: '{"swagger":"2.0"}') version
		equals: #v2
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> testWalkerNeverRaisesOnMalformedDocuments [

	self malformedDocuments do: [ :text |
		self
			shouldnt: [ self inventoryOf: text ]
			raise: Error
			description: text ]
]

{ #category : 'tests - OpenAPI 3.1' }
FamixOpenApiSourceWalkerTest >> testWebhooksAreUnknownInOpenApi30 [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.3","webhooks":{"w":{"post":{}}},"components":{"pathItems":{}}}'.
	self
		assert: inventory unknownKeys
		equals: #( '#/webhooks' '#/components/pathItems' ).
	self assert: (inventory countOf: 'PathItem') equals: 0
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> testWrongShapeNodesAreNotDescendedInto [

	| inventory |
	inventory := self inventoryOf:
		             '{"openapi":"3.0.0","info":[{"title":"t"}],"paths":{"/a":[{"get":{}}]},"components":{"schemas":{"S":["x"]}}}'.
	self
		assert: inventory pointers
		equals:
		#( '#' '#/info' '#/paths' '#/paths/~1a' '#/components'
		   '#/components/schemas/S' ).
	self assert: (inventory countOf: 'Operation') equals: 0
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> testWrongShapeNodesKeepTheExpectedSpecObjectAndAreNotCounted [

	| inventory |
	inventory := self inventoryOf: self wrongShapeDocument.
	self assert: (inventory nodeAt: '#/info') specObject equals: 'Info'.
	self assert: (inventory nodeAt: '#/info') isWrongShape.
	self
		assert: (inventory nodeAt: '#/paths/~1a') specObject
		equals: 'PathItem'.
	self
		assert:
		(inventory nodeAt: '#/paths/~1c/get/parameters/2') specObject
		equals: 'Parameter'.
	self
		assert: (inventory nodeAt: '#/paths/~1c/get/tags') specObject
		equals: 'Value'.
	self assert: (inventory countOf: 'Info') equals: 0.
	self assert: (inventory countOf: 'Parameter') equals: 0.
	self assert: (inventory countOf: 'PathItem') equals: 2.
	self assert: (inventory countOf: 'Operation') equals: 1.
	self assert: inventory pathCount equals: 3.
	self assert: inventory componentSchemaCount equals: 0
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> testWrongShapesAreRecordedInDocumentOrder [

	| inventory |
	inventory := self inventoryOf: self wrongShapeDocument.
	self
		assert: (inventory wrongShapeNodes collect: #pointer)
		equals:
			#( '#/info' '#/paths/~1a' '#/paths/~1b/get' '#/paths/~1b/parameters'
			   '#/paths/~1b/servers' '#/paths/~1c/get/responses'
			   '#/paths/~1c/get/parameters/0' '#/paths/~1c/get/parameters/1'
			   '#/paths/~1c/get/parameters/2' '#/paths/~1c/get/parameters/3'
			   '#/paths/~1c/get/tags' '#/components/schemas'
			   '#/components/responses/R' '#/components/securitySchemes/s/flows'
			   '#/servers' '#/security/0' '#/tags' )
]

{ #category : 'tests - wrong shapes' }
FamixOpenApiSourceWalkerTest >> wrongShapeDocument [

	^ '{"openapi":"3.0.0","info":[],"paths":{"/a":[],"/b":{"get":"nope","parameters":{},"servers":3},"/c":{"get":{"responses":[],"parameters":[1,"x",null,[]],"tags":{}}}},"components":{"schemas":[],"responses":{"R":5},"securitySchemes":{"s":{"flows":[]}}},"servers":"x","security":[[]],"tags":{}}'
]
