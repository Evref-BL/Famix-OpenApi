"
Fixtures of the tests of the existence check (V7): small OpenAPI 3.0, 3.1 and Swagger 2 documents, one per concern, imported by the real importer with mergesInlineSchemas false (the test package may use the importer, the production package may not), the inventory of the walker and the report of the check.
"
Class {
	#name : 'FamixOpenApiExistenceTestCase',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> allDocuments [
	"Associations name -> JSON text of the fixtures, for the tests that run over all of them"

	^ {
		  ('openApi30' -> self documentOpenApi30).
		  ('openApi30Unresolved' -> self documentOpenApi30Unresolved).
		  ('openApi30Scalars' -> self documentOpenApi30Scalars).
		  ('openApi31' -> self documentOpenApi31).
		  ('openApi31Objects' -> self documentOpenApi31Objects).
		  ('siblings30' -> (self documentWithSiblingsIn: '3.0.3')).
		  ('siblings31' -> (self documentWithSiblingsIn: '3.1.0')).
		  ('swagger2' -> self documentSwagger2).
		  ('swagger2Parameters' -> self documentSwagger2Parameters) }
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertDuplicatesAreDetectedIn: aJsonString named: aName [
	"A second entity of the same class at the pointer of a node is reported as unexpectedMultiple"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	model allModelEntities copy
		select: [ :entity |
		inventory includesPointer: entity canonicalPointer ]
		thenDo: [ :entity |
			| twin kinds |
			twin := entity class new
				        canonicalPointer: entity canonicalPointer;
				        yourself.
			model add: twin.
			kinds := self
				         kindsAt: entity canonicalPointer
				         in: (self reportOf: model inventory: inventory).
			model remove: twin.
			self
				assert: (kinds includes: #unexpectedMultiple)
				description: (self describe: {
							 aName.
							 entity canonicalPointer }) ]
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertMovesAreDetectedIn: aJsonString named: aName [
	"Every entity, synthetic or not, moved to a pointer that no node and no rule explains is an extra entity there"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	model allModelEntities copy do: [ :entity |
		| original kinds |
		original := entity canonicalPointer.
		entity canonicalPointer: '#/stray'.
		kinds := self
			         kindsAt: '#/stray'
			         in: (self reportOf: model inventory: inventory).
		entity canonicalPointer: original.
		self
			assert: (kinds includes: #extraEntity)
			description: (self describe: {
						 aName.
						 original.
						 entity class name }) ]
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertRemovalsAreDetectedIn: aJsonString named: aName [
	"Every entity at the pointer of a node is expected by the check: take it out of the model and the check must say so"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	model allModelEntities copy
		select: [ :entity |
		inventory includesPointer: entity canonicalPointer ]
		thenDo: [ :entity |
			| kinds |
			model remove: entity.
			kinds := self
				         kindsAt: entity canonicalPointer
				         in: (self reportOf: model inventory: inventory).
			model add: entity.
			self
				assert:
				(kinds includesAny: #( #missingEntity #referenceNotResolved ))
				description: (self describe: {
							 aName.
							 entity canonicalPointer.
							 entity class name }) ]
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertStrayAt: aPointer in: aModel inventory: anInventory named: aName [
	"A stray entity of a family that no node ever gives (OPDiscriminatorMapping: only a synthetic one) put at aPointer is reported as extra, then taken out again"

	| stray kinds |
	stray := OPDiscriminatorMapping new
		         canonicalPointer: aPointer;
		         yourself.
	aModel add: stray.
	kinds := self
		         kindsAt: aPointer
		         in: (self reportOf: aModel inventory: anInventory).
	aModel remove: stray.
	self
		assert: (kinds includes: #extraEntity)
		description: (self describe: {
					 aName.
					 aPointer })
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertStraysAreDetectedIn: aJsonString named: aName [
	"An entity of a family that no node gives, put at the pointer of every node in turn"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	inventory pointers do: [ :pointer |
		self
			assertStrayAt: pointer
			in: model
			inventory: inventory
			named: aName ]
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> describe: aCollection [
	"A failure description: the printed elements of aCollection separated by spaces"

	^ ' ' join: (aCollection collect: #asString)
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentOpenApi30 [
	"Every $ref use of OpenAPI 3.0 (shared parameter, header, link, example, callback, request body; cloned response and path item; schema alias, property, items, allOf), resolved or not, with a default-less server list, discriminator, flows, callbacks, encoding, a scalar example..."

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1","contact":{"name":"c"},"license":{"name":"l"}},
"tags":[{"name":"tg","externalDocs":{"url":"http://x"}}],
"paths":{
 "/a":{"$ref":"#/components/pathItems/PI"},
 "/ext":{"$ref":"other.json#/x"},
 "/b":{"parameters":[{"$ref":"#/components/parameters/P"},{"$ref":"#/components/parameters/Nope"}],
  "get":{"operationId":"g","parameters":[{"name":"q","in":"query","schema":{"type":"string","example":"hello"},"example":"ex","examples":{"e1":{"value":1},"e2":{"$ref":"#/components/examples/E"}}}],
   "requestBody":{"$ref":"#/components/requestBodies/RB"},
   "callbacks":{"cb":{"$ref":"#/components/callbacks/CB"},"cb2":{"{$request.body#/u}":{"post":{"responses":{"200":{"description":"d"}}}}}},
   "responses":{"200":{"$ref":"#/components/responses/R"},"201":{"$ref":"#/components/responses/Nope"},"202":{"description":"x","headers":{"h1":{"$ref":"#/components/headers/H"},"h2":{"schema":{"type":"string"}}},"links":{"l1":{"$ref":"#/components/links/L"},"l2":{"operationId":"g","server":{"url":"http://s"}}},"content":{"application/json":{"schema":{"$ref":"#/components/schemas/A"},"encoding":{"p":{"contentType":"x","headers":{"hh":{"schema":{"type":"string"}}}}}}}},
   "default":{"description":"def"}}},
  "post":{"requestBody":{"content":{"a/b":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/A"}},"examples":{"x":{"$ref":"#/components/examples/E"}}}}},"responses":{"200":{"description":"ok"}},"security":[{"oa":["read","write"]},{}]}}},
"servers":[{"url":"http://{h}/v","variables":{"h":{"default":"x","enum":["x","y"]}}}],
"components":{
 "schemas":{"A":{"type":"object","properties":{"p":{"$ref":"#/components/schemas/B"},"q":{"$ref":"#/components/schemas/Nope"},"r":{"type":"array","items":{"$ref":"#/components/schemas/B"}},"s":true,"t":{"allOf":[{"$ref":"#/components/schemas/B"},{"type":"string"}]}},"additionalProperties":{"$ref":"#/components/schemas/B"},"discriminator":{"propertyName":"p","mapping":{"b":"#/components/schemas/B"}},"xml":{"name":"a"},"example":{"k":1}},
  "B":{"type":"string"},"Alias":{"$ref":"#/components/schemas/B"},"Dang":{"$ref":"#/components/schemas/Nope"},"Ext":{"$ref":"http://e.com/x.json"},"Bool":false,"One":{"oneOf":[{"type":"string"},{"$ref":"#/components/schemas/B"}],"not":{"$ref":"#/components/schemas/B"}}},
 "responses":{"R":{"description":"r"},"RA":{"$ref":"#/components/responses/R"}},
 "parameters":{"P":{"name":"p","in":"header","schema":{"type":"string"},"content":{}}},
 "examples":{"E":{"value":2}},
 "requestBodies":{"RB":{"content":{"a/b":{}}}},
 "headers":{"H":{"schema":{"type":"string"}}},
 "securitySchemes":{"oa":{"type":"oauth2","flows":{"implicit":{"authorizationUrl":"http://a","scopes":{"read":"r","write":"w"}},"password":{"tokenUrl":"http://t","scopes":{}}}},"k":{"type":"apiKey","name":"n","in":"header"}},
 "links":{"L":{"operationId":"g"}},
 "callbacks":{"CB":{"{$x}":{"get":{"responses":{"200":{"description":"d"}}}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentOpenApi30Scalars [
	"Boolean schemas and the example of a parameter, a media type and a header"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/z":{"get":{"parameters":[{"name":"a","in":"query","schema":{"type":"string"},"examples":{"x":{"value":{"o":1}}},"example":{"o":1}}],"responses":{"200":{"description":"d","headers":{"h":{"example":3,"schema":true}},"content":{"a/b":{"example":"s","schema":{"type":"array","items":true,"additionalProperties":false,"not":false,"allOf":[true]}}}}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentOpenApi30Unresolved [
	"Unresolved $ref in a schema (items, allOf, additionalProperties, not) and in every kind of components entry"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/z":{"get":{"responses":{"200":{"description":"d","content":{"a/b":{"schema":{"type":"object","properties":{"x":{"type":"array","items":{"$ref":"#/components/schemas/Nope"},"allOf":[{"$ref":"#/components/schemas/Nope2"}]}},"additionalProperties":{"$ref":"#/components/schemas/Nope3"}}}}}}}}},
"components":{"schemas":{"S":{"type":"object","not":{"$ref":"#/components/schemas/Nope4"}}},"responses":{"RU":{"$ref":"#/components/responses/Nope"},"RA":{"$ref":"#/components/responses/R"},"R":{"description":"r"}},"parameters":{"PU":{"$ref":"#/components/parameters/Nope"},"PA":{"$ref":"#/components/parameters/P"},"P":{"name":"p","in":"query"}},"headers":{"HU":{"$ref":"#/components/headers/Nope"}},"examples":{"EU":{"$ref":"#/components/examples/Nope"}},"requestBodies":{"RU":{"$ref":"#/components/requestBodies/Nope"},"RA":{"$ref":"#/components/requestBodies/RU"}},"links":{"LU":{"$ref":"#/x"}},"callbacks":{"CU":{"$ref":"#/x"}},"securitySchemes":{"SU":{"$ref":"#/x"}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentOpenApi31 [
	"Web hooks, a $ref path item, the components path items, the JSON Schema 2020-12 keywords (some of them are not read by the importer), a $ref beside other keys, mutualTLS and openIdConnect"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1","summary":"s","license":{"identifier":"MIT","name":"m"}},"jsonSchemaDialect":"http://x",
"webhooks":{"w":{"post":{"responses":{"200":{"description":"d"}}}},"w2":{"$ref":"#/components/pathItems/PI"}},
"paths":{"/a":{"$ref":"#/components/pathItems/PI","summary":"s"},"/c":{"get":{"responses":{"200":{"$ref":"#/components/responses/R","description":"over"}},"parameters":[{"name":"q","in":"query","content":{"a/b":{"schema":{"type":"string"}}}}]}}},
"components":{"pathItems":{"PI":{"get":{"responses":{"200":{"description":"d"}}}},"PI2":{"$ref":"#/components/pathItems/PI"}},
 "responses":{"R":{"description":"r"}},
 "schemas":{"S":{"type":["object","null"],"$defs":{"D":{"type":"string","properties":{"dd":{"type":"string"}}}},"prefixItems":[{"type":"string"},{"$ref":"#/components/schemas/T"}],"items":{"type":"integer"},"contains":{"type":"string"},"if":{"type":"string"},"then":{"type":"string"},"else":{"type":"string"},"not":{"type":"string"},"patternProperties":{"^x":{"type":"string"}},"propertyNames":{"type":"string"},"unevaluatedProperties":false,"dependentSchemas":{"a":{"type":"string"}},"anyOf":[{"type":"string"}],"properties":{"pp":{"$ref":"#/components/schemas/T","description":"sib"},"q":{"type":"string","$ref":"#/components/schemas/T"}},"const":1,"examples":[1,2]},"T":{"type":"string"},"A2":{"$ref":"#/components/schemas/T","description":"alias"}},
 "securitySchemes":{"mt":{"type":"mutualTLS"},"oi":{"type":"openIdConnect","openIdConnectUrl":"http://x"}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentOpenApi31Objects [
	"The objects of OpenAPI 3.1 that the other fixtures of 3.1 do not hold: contact, servers and variables, external documentation, encoding, callback, link, tag, discriminator, xml, flows, security requirements"

	^ '{"openapi":"3.1.1","info":{"title":"t","version":"1","contact":{"name":"c"}},"servers":[{"url":"http://{h}/v","variables":{"h":{"default":"x"}}}],"tags":[{"name":"tg","externalDocs":{"url":"http://x"}}],"security":[{"oa":["read"]}],
"paths":{"/p":{"post":{"requestBody":{"content":{"multipart/form-data":{"schema":{"type":"object","properties":{"f":{"type":"string"}}},"encoding":{"f":{"contentType":"text/plain"}}}}},"callbacks":{"cb":{"{$request.body#/u}":{"post":{"responses":{"200":{"description":"d"}}}}}},"responses":{"200":{"description":"ok","links":{"l":{"operationId":"x"}}}}}}},
"components":{"schemas":{"Pet":{"type":"object","oneOf":[{"$ref":"#/components/schemas/Cat"}],"discriminator":{"propertyName":"t","mapping":{"c":"#/components/schemas/Cat"}},"xml":{"name":"pet"}},"Cat":{"type":"object"}},
"securitySchemes":{"oa":{"type":"oauth2","flows":{"authorizationCode":{"authorizationUrl":"http://a","tokenUrl":"http://t","scopes":{"read":"r"}},"clientCredentials":{"tokenUrl":"http://t","scopes":{}}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentSwagger2 [
	"Host, basePath and two schemes, produces and consumes, typed parameters with nested items, body and formData parameters, a $ref response and path item, definitions (alias, string discriminator, properties), shared parameters and responses, security definitions with scopes"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1","contact":{"name":"c"},"license":{"name":"l"}},"host":"h.com","basePath":"/v","schemes":["http","https"],"consumes":["application/json","application/xml"],"produces":["application/json","text/plain"],
"tags":[{"name":"t","externalDocs":{"url":"http://x"}}],
"paths":{"/a":{"$ref":"#/x"},"/b":{"parameters":[{"$ref":"#/parameters/P"},{"$ref":"#/parameters/Nope"}],
 "get":{"parameters":[{"name":"q","in":"query","type":"array","items":{"type":"array","items":{"type":"string"}}},{"name":"b","in":"body","schema":{"$ref":"#/definitions/A"}},{"name":"f","in":"formData","type":"string"},{"name":"f2","in":"formData","type":"file"}],
  "responses":{"200":{"description":"ok","schema":{"type":"array","items":{"$ref":"#/definitions/A"}},"headers":{"h":{"type":"array","items":{"type":"string"}}},"examples":{"application/json":{"a":1}}},"201":{"$ref":"#/responses/R"},"202":{"$ref":"#/responses/Nope"},"default":{"description":"d","schema":{"type":"string"}}},"security":[{"oa":["read"]}]},
 "post":{"parameters":[{"name":"b","in":"body","schema":{"type":"object","properties":{"z":{"type":"string"}}}}],"consumes":["a/b"],"produces":["c/d"],"responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/A"}}}},
 "put":{"parameters":[{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"ok"}}}}},
"definitions":{"A":{"type":"object","discriminator":"p","properties":{"p":{"type":"string"},"r":{"$ref":"#/definitions/B"},"s":{"type":"array","items":{"$ref":"#/definitions/B"}},"u":{"$ref":"#/definitions/Nope"},"xx":{"type":"object","xml":{"name":"n"}}},"externalDocs":{"url":"u"}},"B":{"type":"string"},"Al":{"$ref":"#/definitions/B"},"Du":{"$ref":"#/definitions/Nope"}},
"parameters":{"P":{"name":"p","in":"query","type":"string"},"PB":{"name":"b","in":"body","schema":{"type":"string"}},"PA":{"$ref":"#/parameters/P"}},
"responses":{"R":{"description":"r","schema":{"type":"string"}},"RA":{"$ref":"#/responses/R"}},
"securityDefinitions":{"oa":{"type":"oauth2","flow":"implicit","authorizationUrl":"http://a","scopes":{"read":"r","write":"w"}},"k":{"type":"apiKey","name":"n","in":"header"},"b":{"type":"basic"}},"security":[{"k":[]}]}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentSwagger2Parameters [
	"Body and formData parameters in a path item, an operation with two body parameters, $ref to body and formData parameters, shared formData and body parameters"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},
"paths":{"/b":{"parameters":[{"name":"pb","in":"body","schema":{"type":"string"}},{"name":"pf","in":"formData","type":"string"},{"name":"pq","in":"query","type":"string"}],
 "get":{"responses":{"200":{"description":"ok"}}},
 "post":{"parameters":[{"name":"b1","in":"body","schema":{"type":"string"}},{"name":"b2","in":"body","schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}},
 "put":{"parameters":[{"name":"f","in":"formData","type":"file"},{"$ref":"#/parameters/PF"},{"$ref":"#/parameters/PB"}],"responses":{"200":{"description":"ok"}}},
 "delete":{"parameters":[{"$ref":"#/parameters/PB"}],"responses":{"200":{"description":"ok"}}}}},
"parameters":{"PF":{"name":"pf","in":"formData","type":"string"},"PB":{"name":"b","in":"body","schema":{"type":"string"}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceTestCase >> documentWithSiblingsIn: aVersionString [
	"A $ref beside other keys in a parameter, a request body, a header, and in a schema (media type, items, allOf, resolved or not, property)"

	^ '{"openapi":"' , aVersionString
	  ,
		  '","info":{"title":"t","version":"1"},"paths":{"/c":{"post":{"parameters":[{"$ref":"#/components/parameters/P","description":"x"}],"requestBody":{"$ref":"#/components/requestBodies/RB","description":"x"},"responses":{"200":{"description":"d","headers":{"h":{"$ref":"#/components/headers/H","description":"x"}},"content":{"a/b":{"schema":{"$ref":"#/components/schemas/T","description":"sib"}},"c/d":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/T","description":"sib"},"allOf":[{"$ref":"#/components/schemas/T","description":"sib"},{"$ref":"#/components/schemas/Nope","description":"sib"}]}}}},"201":{"$ref":"#/components/responses/R2"}}}}},
"components":{"parameters":{"P":{"name":"p","in":"query"}},"requestBodies":{"RB":{"content":{"a/b":{"schema":{"type":"string"}}}}},"headers":{"H":{"schema":{"type":"string"}}},"schemas":{"T":{"type":"string","properties":{"pp":{"$ref":"#/components/schemas/T","description":"sib"},"nn":{"$ref":"#/components/schemas/Nope","description":"sib"}}}},"responses":{"R2":{"description":"d","headers":{"h":{"schema":{"type":"string"}}},"content":{"a/b":{"schema":{"type":"string"},"examples":{"e":{"value":1}}}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> entityOf: aClass at: aPointer in: aModel [
	"The entity of exactly aClass at aPointer"

	^ (FamixOpenApiPointerLookup onModel: aModel)
		  entitiesAt: aPointer
		  ofClass: aClass
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> inventoryOf: aJsonString [
	"The inventory of the source document, read independently of the importer"

	^ FamixOpenApiSourceWalker new walk:
		  (NeoJSONReader fromString: aJsonString)
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> kindsAt: aPointer in: aReport [
	"The kinds of the gaps of aReport whose source pointer is aPointer"

	^ aReport gaps
		  select: [ :each | each sourcePointer = aPointer ]
		  thenCollect: #kind
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> modelOf: aJsonString [
	"The OPModel the importer builds without merging the inline schemas (1:1)"

	^ self modelOf: aJsonString merging: false
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> modelOf: aJsonString merging: aBoolean [

	^ FamixOpenApiImporter new
		  mergesInlineSchemas: aBoolean;
		  importFromString: aJsonString
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportFor: aJsonString [
	"Import the document (1:1) and check the model against the document, with the diagnostics of the import"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: aJsonString.
	^ FamixOpenApiExistenceCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: model
		  diagnostics: importer diagnostics
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportOf: aModel for: aJsonString [
	"Check a model (possibly mutated by the test) against the document, without diagnostics"

	^ FamixOpenApiExistenceCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: aModel
		  diagnostics: nil
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportOf: aModel for: aJsonString diagnostics: aCollection [
	"Check a model against the document with the given diagnostics (any objects answering #code and #pointer)"

	^ FamixOpenApiExistenceCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: aModel
		  diagnostics: aCollection
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportOf: aModel inventory: anInventory [
	"Check a model against an inventory already built (for the tests that check many mutations of one model)"

	^ FamixOpenApiExistenceCheck
		  checkInventory: anInventory
		  model: aModel
		  diagnostics: nil
]
