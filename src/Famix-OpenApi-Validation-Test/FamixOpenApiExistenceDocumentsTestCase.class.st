"
The small OpenAPI 3.0, 3.1 and Swagger 2 documents (JSON texts) that the tests of the existence check run on, one per concern, and the list of all of them (#allDocuments). Abstract: the helpers that import, derive and check them are in FamixOpenApiExistenceTestCase.
"
Class {
	#name : 'FamixOpenApiExistenceDocumentsTestCase',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'documents' }
FamixOpenApiExistenceDocumentsTestCase >> allDocuments [
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
		  ('swagger2Parameters' -> self documentSwagger2Parameters).
		  ('swagger2Responses' -> self documentSwagger2Responses).
		  ('swagger2Bodies' -> self documentSwagger2Bodies).
		  ('swagger2BodyReferences' -> self documentSwagger2BodyReferences).
		  ('swagger2Forms' -> self documentSwagger2Forms).
		  ('swagger2Typed' -> self documentSwagger2Typed).
		  ('swagger2Security' -> self documentSwagger2Security).
		  ('swagger2Clones' -> self documentSwagger2Clones).
		  ('swagger2WrongShapes' -> self documentSwagger2WrongShapes).
		  ('swagger2Examples' -> self documentSwagger2Examples).
		  ('swagger2ParameterWithSchema'
		   -> self documentSwagger2ParameterWithSchema).
		  ('openApi30Keyed' -> self documentOpenApi30Keyed).
		  ('openApi30Clones' -> self documentOpenApi30Clones).
		  ('openApi31Clones' -> self documentOpenApi31Clones).
		  ('openApi31Dropped' -> self documentOpenApi31Dropped).
		  ('callbackClones' -> self documentCallbackClones).
		  ('callbackTargets' -> self documentCallbackTargets).
		  ('activeReferenceCycle' -> self documentActiveReferenceCycle) }
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentActiveReferenceCycle [
	"OpenAPI 3.0: /a clones /c through a callback, and /c has a callback that designates /c: inside the clone that $ref is the one being read (the importer reports a refCycle and gives an OPPath without content)"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/a":{"get":{"callbacks":{"cb":{"{$x}":{"$ref":"#/paths/~1c"}}},"responses":{"200":{"description":"d"}}}},"/c":{"get":{"callbacks":{"cb":{"{$y}":{"$ref":"#/paths/~1c"}}},"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentCallbackClones [
	"OpenAPI 3.1: callbacks of path items that designate later entries of paths (clones inside clones), an earlier entry (shared), a component (shared) and a target that does not exist (read again, unresolved)"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{"/p0":{"get":{"callbacks":{"cb":{"{$x}":{"$ref":"#/paths/~1p1"},"{$y}":{"$ref":"#/components/pathItems/PI"},"{$z}":{"$ref":"#/components/pathItems/Nope"}}},"responses":{"200":{"description":"d"}}}},"/p1":{"get":{"callbacks":{"cb":{"{$x}":{"$ref":"#/paths/~1p2"},"{$y}":{"$ref":"#/paths/~1p0"}}},"responses":{"200":{"description":"d"}}}},"/p2":{"get":{"callbacks":{"cb":{"{$x}":{"post":{"responses":{"200":{"description":"d"}}}}}},"responses":{"200":{"description":"d"}}}}},"components":{"pathItems":{"PI":{"get":{"responses":{"200":{"description":"d"}}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentCallbackTargets [
	"OpenAPI 3.0: callbacks that designate a path item inside an entry of paths: shared when the importer visited it before (the same entry above, an earlier entry), cloned when it comes after (the same entry below, a later entry)"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/a":{"get":{"callbacks":{"cb":{"{$x}":{"post":{"responses":{"200":{"description":"d"}}}},"{$y}":{"$ref":"#/paths/~1a/post/callbacks/cb/{$k}"},"{$z}":{"$ref":"#/paths/~1a/get/callbacks/cb/{$x}"}}},"responses":{"200":{"description":"d"}}},"post":{"callbacks":{"cb":{"{$k}":{"put":{"responses":{"200":{"description":"d"}}}}}},"responses":{"200":{"description":"d"}}}},"/b":{"get":{"callbacks":{"cb":{"{$w}":{"$ref":"#/paths/~1a/get/callbacks/cb/{$x}"},"{$v}":{"$ref":"#/paths/~1c/get/callbacks/cb/{$m}"}}},"responses":{"200":{"description":"d"}}}},"/c":{"get":{"callbacks":{"cb":{"{$m}":{"delete":{"responses":{"200":{"description":"d"}}}}}},"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentNestedCallbacks: aCount [
	"OpenAPI 3.0: aCount + 1 entries of paths, each with a callback that designates the next one (a clone inside a clone, aCount levels deep); the last one has a plain path item"

	^ String streamContents: [ :stream |
		  stream nextPutAll:
			  '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{'.
		  0 to: aCount do: [ :index |
			  index > 0 ifTrue: [ stream nextPut: $, ].
			  self writeNestedCallbackEntry: index last: aCount on: stream ].
		  stream nextPutAll: '}}' ]
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi30 [
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

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi30Clones [
	"OpenAPI 3.0 clones: $ref responses (resolved, alias of an alias, unresolved, cyclic) with headers, content, schemas and examples; $ref path items (another entry of paths, which has a $ref response itself)"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"responses":{"200":{"$ref":"#/components/responses/R"},"201":{"$ref":"#/components/responses/RA"},"202":{"$ref":"#/components/responses/Nope"},"203":{"$ref":"#/components/responses/Cyc"}}}},"/q":{"$ref":"#/paths/~1p"},"/r":{"$ref":"#/paths/~1q"}},"components":{"responses":{"R":{"description":"r","headers":{"h":{"schema":{"type":"string"},"example":3}},"content":{"a/b":{"schema":{"$ref":"#/components/schemas/S"},"example":{"a":1},"examples":{"x":{"value":1}}}}},"RA":{"$ref":"#/components/responses/R"},"Cyc":{"$ref":"#/components/responses/Cyc2"},"Cyc2":{"$ref":"#/components/responses/Cyc"}},"schemas":{"S":{"type":"object","properties":{"a":{"type":"string"}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi30Keyed [
	"OpenAPI 3.0: examples (null, object, scalar; of a parameter, a media type, a header, a schema), discriminators (mapping with escaped keys, string, without mapping), oauth2 flows with scopes, requirements with an unknown scheme and an empty one"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"q","in":"query","example":null,"schema":{"type":"string","example":"s"}},{"name":"r","in":"query","example":{"k":[1]}},{"name":"n","in":"query"}],"responses":{"200":{"description":"d","headers":{"h":{"example":1,"schema":{"type":"string"}}},"content":{"a/b":{"example":"e","schema":{"type":"string"}},"c/d":{"examples":{"x":{"value":1}}}}}},"security":[{"oa":["read"],"unknown":[]},{}]}}},"components":{"schemas":{"S":{"type":"object","discriminator":{"propertyName":"p","mapping":{"a/b":"x","c~d":"y","e":"z"}}},"W":{"type":"object","discriminator":"str"},"N":{"type":"object","discriminator":{"propertyName":"p"}}},"securitySchemes":{"oa":{"type":"oauth2","flows":{"implicit":{"authorizationUrl":"a","scopes":{"read":"r","a/b":"w"}},"password":{"tokenUrl":"t","scopes":{}}}},"k":{"type":"apiKey","name":"n","in":"header"}},"parameters":{"P":{"name":"p","in":"query","example":3}}},"security":[{"k":[]}]}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi30Scalars [
	"Boolean schemas and the example of a parameter, a media type and a header"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/z":{"get":{"parameters":[{"name":"a","in":"query","schema":{"type":"string"},"examples":{"x":{"value":{"o":1}}},"example":{"o":1}}],"responses":{"200":{"description":"d","headers":{"h":{"example":3,"schema":true}},"content":{"a/b":{"example":"s","schema":{"type":"array","items":true,"additionalProperties":false,"not":false,"allOf":[true]}}}}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi30Unresolved [
	"Unresolved $ref in a schema (items, allOf, additionalProperties, not) and in every kind of components entry"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/z":{"get":{"responses":{"200":{"description":"d","content":{"a/b":{"schema":{"type":"object","properties":{"x":{"type":"array","items":{"$ref":"#/components/schemas/Nope"},"allOf":[{"$ref":"#/components/schemas/Nope2"}]}},"additionalProperties":{"$ref":"#/components/schemas/Nope3"}}}}}}}}},
"components":{"schemas":{"S":{"type":"object","not":{"$ref":"#/components/schemas/Nope4"}}},"responses":{"RU":{"$ref":"#/components/responses/Nope"},"RA":{"$ref":"#/components/responses/R"},"R":{"description":"r"}},"parameters":{"PU":{"$ref":"#/components/parameters/Nope"},"PA":{"$ref":"#/components/parameters/P"},"P":{"name":"p","in":"query"}},"headers":{"HU":{"$ref":"#/components/headers/Nope"}},"examples":{"EU":{"$ref":"#/components/examples/Nope"}},"requestBodies":{"RU":{"$ref":"#/components/requestBodies/Nope"},"RA":{"$ref":"#/components/requestBodies/RU"}},"links":{"LU":{"$ref":"#/x"}},"callbacks":{"CU":{"$ref":"#/x"}},"securitySchemes":{"SU":{"$ref":"#/x"}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi31 [
	"Web hooks, a $ref path item, the components path items, the JSON Schema 2020-12 keywords (some of them are not read by the importer), a $ref beside other keys, mutualTLS and openIdConnect"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1","summary":"s","license":{"identifier":"MIT","name":"m"}},"jsonSchemaDialect":"http://x",
"webhooks":{"w":{"post":{"responses":{"200":{"description":"d"}}}},"w2":{"$ref":"#/components/pathItems/PI"}},
"paths":{"/a":{"$ref":"#/components/pathItems/PI","summary":"s"},"/c":{"get":{"responses":{"200":{"$ref":"#/components/responses/R","description":"over"}},"parameters":[{"name":"q","in":"query","content":{"a/b":{"schema":{"type":"string"}}}}]}}},
"components":{"pathItems":{"PI":{"get":{"responses":{"200":{"description":"d"}}}},"PI2":{"$ref":"#/components/pathItems/PI"}},
 "responses":{"R":{"description":"r"}},
 "schemas":{"S":{"type":["object","null"],"$defs":{"D":{"type":"string","properties":{"dd":{"type":"string"}}}},"prefixItems":[{"type":"string"},{"$ref":"#/components/schemas/T"}],"items":{"type":"integer"},"contains":{"type":"string"},"if":{"type":"string"},"then":{"type":"string"},"else":{"type":"string"},"not":{"type":"string"},"patternProperties":{"^x":{"type":"string"}},"propertyNames":{"type":"string"},"unevaluatedProperties":false,"dependentSchemas":{"a":{"type":"string"}},"anyOf":[{"type":"string"}],"properties":{"pp":{"$ref":"#/components/schemas/T","description":"sib"},"q":{"type":"string","$ref":"#/components/schemas/T"}},"const":1,"examples":[1,2]},"T":{"type":"string"},"A2":{"$ref":"#/components/schemas/T","description":"alias"}},
 "securitySchemes":{"mt":{"type":"mutualTLS"},"oi":{"type":"openIdConnect","openIdConnectUrl":"http://x"}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi31Clones [
	"OpenAPI 3.1 path item clones: siblings of the $ref override the target, a path item that designates a clone, a self cycle, an unresolved target (its siblings give nothing), a web hook, a callback and a $ref response inside the clones"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{"/p":{"$ref":"#/components/pathItems/PI","summary":"s","get":{"responses":{"200":{"description":"o"}}}},"/q":{"$ref":"#/paths/~1p"},"/c":{"$ref":"#/paths/~1c"},"/n":{"$ref":"#/components/pathItems/Nope","get":{"responses":{"200":{"description":"d"}}}}},"webhooks":{"w":{"$ref":"#/components/pathItems/PI"}},"components":{"pathItems":{"PI":{"get":{"callbacks":{"cb":{"{$x}":{"$ref":"#/components/pathItems/PJ"}}},"responses":{"200":{"$ref":"#/components/responses/R"}}}},"PJ":{"post":{"responses":{"200":{"description":"d"}}}}},"responses":{"R":{"description":"r","content":{"a/b":{"example":1}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi31Dropped [
	"OpenAPI 3.1: schemas below the keywords the importer does not read ($defs, if) hold a discriminator and an example that give nothing"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{},"components":{"schemas":{"S":{"type":"object","$defs":{"X":{"discriminator":{"propertyName":"p","mapping":{"a":"b"}},"example":1,"properties":{"p":{"type":"string"}}}},"if":{"discriminator":"str"}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentOpenApi31Objects [
	"The objects of OpenAPI 3.1 that the other fixtures of 3.1 do not hold: contact, servers and variables, external documentation, encoding, callback, link, tag, discriminator, xml, flows, security requirements"

	^ '{"openapi":"3.1.1","info":{"title":"t","version":"1","contact":{"name":"c"}},"servers":[{"url":"http://{h}/v","variables":{"h":{"default":"x"}}}],"tags":[{"name":"tg","externalDocs":{"url":"http://x"}}],"security":[{"oa":["read"]}],
"paths":{"/p":{"post":{"requestBody":{"content":{"multipart/form-data":{"schema":{"type":"object","properties":{"f":{"type":"string"}}},"encoding":{"f":{"contentType":"text/plain"}}}}},"callbacks":{"cb":{"{$request.body#/u}":{"post":{"responses":{"200":{"description":"d"}}}}}},"responses":{"200":{"description":"ok","links":{"l":{"operationId":"x"}}}}}}},
"components":{"schemas":{"Pet":{"type":"object","oneOf":[{"$ref":"#/components/schemas/Cat"}],"discriminator":{"propertyName":"t","mapping":{"c":"#/components/schemas/Cat"}},"xml":{"name":"pet"}},"Cat":{"type":"object"}},
"securitySchemes":{"oa":{"type":"oauth2","flows":{"authorizationCode":{"authorizationUrl":"http://a","tokenUrl":"http://t","scopes":{"read":"r"}},"clientCredentials":{"tokenUrl":"http://t","scopes":{}}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2 [
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

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Bodies [
	"Swagger 2 body parameters: the first one of an operation gives the request body (inline, or a $ref), the second one, a path level one and a formData one beside a body give nothing; an unresolved $ref and a body without schema"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"consumes":["x/y"],"paths":{"/p":{"parameters":[{"name":"pb","in":"body","schema":{"type":"string"}},{"name":"pf","in":"formData","type":"string"}],"post":{"consumes":["m/n"],"parameters":[{"name":"b1","in":"body","schema":{"type":"string"}},{"name":"b2","in":"body","schema":{"type":"integer"}},{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}},"put":{"parameters":[{"$ref":"#/parameters/B"},{"name":"b2","in":"body","schema":{"type":"integer"}}],"responses":{"200":{"description":"d"}}},"get":{"parameters":[{"$ref":"#/parameters/Nope"},{"$ref":"#/parameters/B"}],"responses":{"200":{"description":"d"}}},"patch":{"parameters":[{"name":"b1","in":"body"}],"responses":{"200":{"description":"d"}}}}},"parameters":{"B":{"name":"b","in":"body","schema":{"type":"object","properties":{"x":{"type":"string"}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2BodyReferences [
	"Swagger 2: $ref body parameters whose target has no schema, a schema that is a string, a schema that is a $ref"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"$ref":"#/parameters/B2"}],"responses":{"200":{"description":"d"}}},"put":{"parameters":[{"$ref":"#/parameters/B3"}],"responses":{"200":{"description":"d"}}},"post":{"parameters":[{"$ref":"#/parameters/B4"}],"responses":{"200":{"description":"d"}}}}},"parameters":{"B2":{"name":"b","in":"body"},"B3":{"name":"b","in":"body","schema":"oops"},"B4":{"name":"b","in":"body","schema":{"$ref":"#/definitions/D"}}},"definitions":{"D":{"type":"string"}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Clones [
	"Swagger 2 clones: $ref responses (resolved, alias, unresolved, cyclic) with a schema and a header, a $ref path item, the root produces and security"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"produces":["a/b"],"paths":{"/p":{"get":{"responses":{"200":{"$ref":"#/responses/R"},"201":{"$ref":"#/responses/RA"},"202":{"$ref":"#/responses/Nope"},"203":{"$ref":"#/responses/Cyc"}}}},"/q":{"$ref":"#/paths/~1p"}},"responses":{"R":{"description":"r","schema":{"type":"array","items":{"type":"string"}},"headers":{"h":{"type":"integer"}}},"RA":{"$ref":"#/responses/R"},"Cyc":{"$ref":"#/responses/Cyc2"},"Cyc2":{"$ref":"#/responses/Cyc"}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Examples [
	"Swagger 2: the `example` of a typed (query) parameter gives an OPExample, the one of a body parameter (an OPRequestBody), a header and a response do not"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"q","in":"query","type":"string","example":1},{"name":"b","in":"body","example":2,"schema":{"type":"string"}}],"responses":{"200":{"description":"d","examples":{"a/b":1},"headers":{"h":{"type":"string","example":3}}}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Forms [
	"Swagger 2 formData parameters of operations without body parameter: a file (multipart), an array, a $ref parameter, a repeated name, form media types of the consumes, other consumes, parameters without name or type"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"post":{"parameters":[{"name":"f","in":"formData","type":"file","required":true},{"name":"g","in":"formData","type":"array","items":{"type":"string"}},{"$ref":"#/parameters/F"},{"name":"f","in":"formData","type":"integer"}],"responses":{"200":{"description":"d"}}},"put":{"consumes":["application/x-www-form-urlencoded","multipart/form-data","a/b"],"parameters":[{"name":"f","in":"formData","type":"file"}],"responses":{"200":{"description":"d"}}},"patch":{"consumes":["a/b"],"parameters":[{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}},"get":{"parameters":[{"name":"f","in":"formData"},{"in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}}}},"parameters":{"F":{"name":"ff","in":"formData","type":"string","default":"x"}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2ParameterWithSchema [
	"Swagger 2: a query parameter that has a `schema` key beside its type: the node of the document is there, no schema is derived from the type"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"q","in":"query","type":"string","schema":{"type":"integer"}}],"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Parameters [
	"Body and formData parameters in a path item, an operation with two body parameters, $ref to body and formData parameters, shared formData and body parameters"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},
"paths":{"/b":{"parameters":[{"name":"pb","in":"body","schema":{"type":"string"}},{"name":"pf","in":"formData","type":"string"},{"name":"pq","in":"query","type":"string"}],
 "get":{"responses":{"200":{"description":"ok"}}},
 "post":{"parameters":[{"name":"b1","in":"body","schema":{"type":"string"}},{"name":"b2","in":"body","schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}},
 "put":{"parameters":[{"name":"f","in":"formData","type":"file"},{"$ref":"#/parameters/PF"},{"$ref":"#/parameters/PB"}],"responses":{"200":{"description":"ok"}}},
 "delete":{"parameters":[{"$ref":"#/parameters/PB"}],"responses":{"200":{"description":"ok"}}}}},
"parameters":{"PF":{"name":"pf","in":"formData","type":"string"},"PB":{"name":"b","in":"body","schema":{"type":"string"}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Responses [
	"Swagger 2 responses: produces of the operation, of the root when the list of the operation is empty, a response without schema, a $ref schema, an unresolved $ref schema"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"produces":["r/a"],"paths":{"/p":{"get":{"produces":["o/a","o/b"],"responses":{"200":{"description":"d","schema":{"type":"string"}},"204":{"description":"none"}}},"put":{"produces":[],"responses":{"200":{"description":"d","schema":{"type":"string"}}}},"post":{"responses":{"200":{"description":"d","schema":{"$ref":"#/definitions/A"}},"201":{"description":"u","schema":{"$ref":"#/definitions/Nope"}}}}}},"definitions":{"A":{"type":"string"}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Security [
	"Swagger 2: oauth2 schemes with scopes (also one without flow, one with a scopes value that is not an object), a basic scheme with scopes, requirements with an unknown scheme and an empty one, string, object and absent discriminators"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"security":[{"oa":["read"],"zzz":[]},{}],"responses":{"200":{"description":"d"}}}}},"securityDefinitions":{"oa":{"type":"oauth2","flow":"implicit","authorizationUrl":"http://a","scopes":{"read":"r","a/b":"w"}},"b":{"type":"basic","scopes":{"x":"y"}},"o2":{"type":"oauth2","scopes":"x"}},"security":[{"b":[]}],"definitions":{"A":{"type":"object","discriminator":"k","properties":{"k":{"type":"string"}}},"B":{"type":"object","discriminator":{"propertyName":"k"}},"C":{"type":"object"}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2Typed [
	"Swagger 2 typed parameters: nested items, an untyped header, an items $ref, a $ref parameter (shared), an unresolved one, a body, a cookie, a parameter without location; path level and global ones"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"parameters":[{"name":"pq","in":"query","type":"array","items":{"type":"string"}},{"$ref":"#/parameters/T"}],"get":{"parameters":[{"name":"a","in":"query","type":"array","items":{"type":"array","items":{"type":"integer","enum":[1]}}},{"name":"h","in":"header"},{"name":"r","in":"query","type":"array","items":{"$ref":"#/definitions/D"}},{"$ref":"#/parameters/T"},{"$ref":"#/parameters/Nope"},{"name":"b","in":"body","schema":{"type":"string"}},{"name":"c","in":"cookie","type":"string"},{"name":"x"}],"responses":{"200":{"description":"d"}}}}},"parameters":{"T":{"name":"t","in":"query","type":"string","format":"date"},"U":{"$ref":"#/parameters/T"},"H":{"name":"hh","in":"header"}},"definitions":{"D":{"type":"string"}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> documentSwagger2WrongShapes [
	"Swagger 2 values of the wrong shape: schemas of responses that are a boolean, a string, null (a response with a good schema keeps its media type); a parameters list that is a string (path item) and parameters that are strings, numbers, null among good ones"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"produces":["a/b"],"paths":{"/p":{"parameters":"oops","post":{"parameters":["oops",5,null,{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}},"get":{"parameters":["oops",{"name":"q","in":"query","type":"string"}],"responses":{"200":{"description":"d","schema":true},"201":{"description":"d","schema":"x"},"202":{"description":"d","schema":null},"203":{"description":"d","schema":{"type":"string"}}}}}}}'
]

{ #category : 'fixtures - documents' }
FamixOpenApiExistenceDocumentsTestCase >> documentWithSiblingsIn: aVersionString [
	"A $ref beside other keys in a parameter, a request body, a header, and in a schema (media type, items, allOf, resolved or not, property)"

	^ '{"openapi":"' , aVersionString
	  ,
		  '","info":{"title":"t","version":"1"},"paths":{"/c":{"post":{"parameters":[{"$ref":"#/components/parameters/P","description":"x"}],"requestBody":{"$ref":"#/components/requestBodies/RB","description":"x"},"responses":{"200":{"description":"d","headers":{"h":{"$ref":"#/components/headers/H","description":"x"}},"content":{"a/b":{"schema":{"$ref":"#/components/schemas/T","description":"sib"}},"c/d":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/T","description":"sib"},"allOf":[{"$ref":"#/components/schemas/T","description":"sib"},{"$ref":"#/components/schemas/Nope","description":"sib"}]}}}},"201":{"$ref":"#/components/responses/R2"}}}}},
"components":{"parameters":{"P":{"name":"p","in":"query"}},"requestBodies":{"RB":{"content":{"a/b":{"schema":{"type":"string"}}}}},"headers":{"H":{"schema":{"type":"string"}}},"schemas":{"T":{"type":"string","properties":{"pp":{"$ref":"#/components/schemas/T","description":"sib"},"nn":{"$ref":"#/components/schemas/Nope","description":"sib"}}}},"responses":{"R2":{"description":"d","headers":{"h":{"schema":{"type":"string"}}},"content":{"a/b":{"schema":{"type":"string"},"examples":{"e":{"value":1}}}}}}}}'
]

{ #category : 'documents - synthetic' }
FamixOpenApiExistenceDocumentsTestCase >> writeNestedCallbackEntry: anIndex last: aLastIndex on: aStream [
	"The entry /p<anIndex> of documentNestedCallbacks:"

	aStream
		nextPutAll: '"/p';
		print: anIndex;
		nextPutAll: '":{"get":{"callbacks":{"cb":{"{$x}":'.
	anIndex < aLastIndex
		ifTrue: [
			aStream
				nextPutAll: '{"$ref":"#/paths/~1p';
				print: anIndex + 1;
				nextPutAll: '"}' ]
		ifFalse: [
			aStream nextPutAll:
				'{"post":{"responses":{"200":{"description":"d"}}}}' ].
	aStream nextPutAll: '}},"responses":{"200":{"description":"d"}}}}'
]
