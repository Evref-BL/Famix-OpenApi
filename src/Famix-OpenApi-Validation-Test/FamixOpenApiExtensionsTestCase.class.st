"
Base of the tests of the extensions check (V9): the documents (small, one per version and per group of cases) and the helpers that import a document with the REAL importer and give its diagnostics to FamixOpenApiExtensionsCheck, then look at the kind of the gap of a key at a pointer. Abstract: it has no test of its own.
"
Class {
	#name : 'FamixOpenApiExtensionsTestCase',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> assert: anActual equals: anExpected description: aString [
	"The comparison with a description (the actual value is added to it)"

	self
		assert: anActual = anExpected
		description: aString , ': ' , anActual printString
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> assertKind: aKind at: aPointer key: aKey in: aReport [
	"The key of the node at the pointer has exactly one gap, of the kind"

	self
		assert: (self kindsAt: aPointer key: aKey in: aReport) = { aKind }
		description: (self describe: {
					 aPointer.
					 aKey.
					 aKind.
					 (self kindsAt: aPointer key: aKey in: aReport) })
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> assertKind: aKind forPairs: aCollection in: aReport [
	"Every pair (pointer, key) has exactly one gap, of the kind"

	aCollection do: [ :each |
		self
			assertKind: aKind
			at: each first
			key: each last
			in: aReport ]
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> assertNoGapAt: aPointer key: aKey in: aReport [
	"The key of the node at the pointer is not classified (compared by the value check, or inside another value)"

	self
		assert: (self kindsAt: aPointer key: aKey in: aReport) isEmpty
		description: (self describe: {
					 aPointer.
					 aKey.
					 (self kindsAt: aPointer key: aKey in: aReport) })
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentBodiesSwagger2 [
	"Swagger 2: a second body parameter (dropped: extraBodyParameter), the formData parameters of an operation that also has a body (dropped: conflictingBodyAndFormData) and of one that has none (they make the form: their x-* is nowhere)"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"post":{"operationId":"a","parameters":[{"name":"b1","in":"body","schema":{"type":"string"}},{"name":"b2","in":"body","description":"second","x-b":1,"schema":{"type":"integer"}},{"name":"f","in":"formData","type":"string","x-f":2}],"responses":{"200":{"description":"d"}}},"put":{"operationId":"b","parameters":[{"name":"f","in":"formData","type":"string","x-f":3}],"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentExtensions30 [
	"OpenAPI 3.0: the keys that the metamodel has no slot for (Header.example, Header.allowEmptyValue, Link.parameters, Example.description), x-* at several levels and unknown keys (zzz, Info.summary, Schema.$id)"

	^ '{"openapi":"3.0.3","x-root":1,"zzz":{"a":[1,2.5]},"info":{"title":"t","version":"1","summary":"S","x-i":"v","contact":{"x-c":true},"license":{"name":"n","x-l":null}},"servers":[{"url":"http://s","x-srv":1}],"tags":[{"name":"a","x-tag":1}],"paths":{"/p":{"x-pi":1,"get":{"operationId":"g","x-op":{"k":[1,2]},"parameters":[{"name":"q","in":"query","x-par":1,"schema":{"type":"string","x-sch":1}}],"responses":{"200":{"description":"d","x-r":1,"headers":{"h":{"example":"ex","allowEmptyValue":true,"x-h":1,"schema":{"type":"string"}}},"links":{"l":{"operationId":"g","parameters":{"a":"$request.path.a"},"x-l":2}}}}}}},"components":{"examples":{"e":{"summary":"s","description":"dd","value":1,"x-e":1}},"schemas":{"S":{"type":"object","$id":"x","x-s":{"b":1.0},"properties":{"p":{"type":"string","x-prop":1}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentExtensions31 [
	"OpenAPI 3.1: Info.summary, License.identifier, the keywords of a schema that the metamodel does not model, with schemas below some of them (their keys belong to the value of the keyword)"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1","summary":"S","license":{"name":"n","identifier":"MIT"}},"paths":{},"components":{"schemas":{"S":{"type":"object","$id":"i","$anchor":"a","$comment":"c","$defs":{"d":{"type":"string","if":{"type":"integer"}}},"if":{"type":"string","x-n":1},"then":{"minLength":1},"else":{"maxLength":2},"patternProperties":{"^a":{"type":"string"}},"contains":{"type":"string"},"propertyNames":{"pattern":"^a"},"unevaluatedProperties":false,"unevaluatedItems":false,"dependentSchemas":{"a":{"type":"string"}},"dependentRequired":{"a":["b"]},"minContains":1,"maxContains":2,"contentEncoding":"base64","contentMediaType":"image/png","examples":[1,2],"x-s":1}},"examples":{"e":{"description":"dd","value":1}},"headers":{"h":{"example":"ex","x-h":1}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentExtensionsSwagger2 [
	"Swagger 2: Operation.schemes, Items.collectionFormat of a typed parameter (kept in the extensions of its schema), Response.examples with its inside, the keywords of a Header (not converted to a schema), x-* on definitions, parameters and security"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"operationId":"g","schemes":["https"],"parameters":[{"name":"q","in":"query","type":"array","x-par":1,"items":{"type":"string","collectionFormat":"csv","x-it":1}}],"responses":{"200":{"description":"d","examples":{"application/json":{"a":1}},"headers":{"h":{"type":"integer","format":"int32","maximum":5,"minimum":1,"items":{"type":"string","collectionFormat":"csv"},"collectionFormat":"csv","default":1,"enum":[1,2],"x-h":1}}}}}}},"definitions":{"S":{"type":"string","x-def":1}},"securityDefinitions":{"k":{"type":"apiKey","name":"n","in":"header","x-sec":1}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentParametersSwagger2 [
	"Swagger 2: an operation with a body parameter, a second body parameter (extraBodyParameter), a formData parameter (dropped: conflictingBodyAndFormData at the operation), a kept query parameter and a kept header parameter with x-*; path-level body and formData parameters, and an operation with formData parameters only (they make the form)"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"parameters":[{"name":"pb","in":"body","x-pb":1,"schema":{"type":"string"}},{"name":"pf","in":"formData","type":"string","x-pf":1}],"post":{"operationId":"a","parameters":[{"name":"b1","in":"body","x-b1":1,"schema":{"type":"string"}},{"name":"b2","in":"body","x-b2":1,"schema":{"type":"integer"}},{"name":"f","in":"formData","type":"string","x-f":2},{"name":"q","in":"query","type":"string","x-q":1},{"name":"h","in":"header","type":"string","x-h":1}],"responses":{"200":{"description":"d"}}},"get":{"operationId":"c","parameters":[{"name":"f","in":"formData","type":"string","x-f":3}],"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentRefKinds: aVersion [
	"OpenAPI 3.0 or 3.1 (the version text): the six kinds that are not schemas (parameter, request body, response, header, link, example) as an ALIAS in the components (a $ref with siblings: the importer says componentAlias and refSiblingsIgnored at the alias) and as a USE site in an operation (nothing is said: the siblings are lost)"

	^ '{"openapi":"' , aVersion
	  ,
	  '","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"operationId":"g","parameters":[{"$ref":"#/components/parameters/P","description":"sib","x-s":1}],"requestBody":{"$ref":"#/components/requestBodies/B","description":"rb","x-b":1},"responses":{"200":{"$ref":"#/components/responses/R","description":"rsib","x-r":1},"201":{"description":"d","headers":{"h":{"$ref":"#/components/headers/H","description":"hs","x-h":1}},"links":{"l":{"$ref":"#/components/links/L","summary":"ls","x-l":1}}}}}}},"components":{"parameters":{"P":{"name":"q","in":"query"},"P2":{"$ref":"#/components/parameters/P","description":"..","x-foo":1}},"requestBodies":{"B":{"content":{}},"B2":{"$ref":"#/components/requestBodies/B","description":"..","x-foo":1}},"responses":{"R":{"description":"rd"},"R2":{"$ref":"#/components/responses/R","description":"..","x-foo":1}},"headers":{"H":{"description":"hd"},"H2":{"$ref":"#/components/headers/H","description":"..","x-foo":1}},"links":{"L":{"operationId":"g"},"L2":{"$ref":"#/components/links/L","summary":"..","description":"d","x-foo":1}},"examples":{"E":{"summary":"s"},"E2":{"$ref":"#/components/examples/E","summary":"..","description":"d","x-foo":1}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentSchemaKeys: aHeadJson schema: aSchemaJson [
	"A document of the version of the head (the text of the keys openapi or swagger, info and paths: ends with a comma) with a schema S, in the components (3.x) or the definitions (Swagger 2)"

	| isSwagger2 |
	isSwagger2 := aHeadJson beginsWith: '{"swagger"'.
	^ aHeadJson , (isSwagger2
		   ifTrue: [ '"definitions":{"S":' ]
		   ifFalse: [ '"components":{"schemas":{"S":' ]) , aSchemaJson
	  , (isSwagger2
			   ifTrue: [ '}}' ]
			   ifFalse: [ '}}}' ])
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentSiblings30 [
	"OpenAPI 3.0: keys beside a $ref. A schema and a path item that resolves: the importer ignores them and says so (refSiblingsIgnored). A parameter, a request body, a response, a header, a link and a path item that does not resolve: ignored WITHOUT a diagnostic"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"operationId":"g","parameters":[{"$ref":"#/components/parameters/P","description":"sib","x-s":1}],"requestBody":{"$ref":"#/components/requestBodies/B","description":"rb"},"responses":{"200":{"$ref":"#/components/responses/R","description":"rsib","x-r":1},"201":{"description":"d","headers":{"h":{"$ref":"#/components/headers/H","description":"hs"}},"links":{"l":{"$ref":"#/components/links/L","description":"ls"}}}}}},"/q":{"$ref":"#/paths/~1p","summary":"qs","x-q":1},"/r":{"$ref":"#/paths/~1nowhere","summary":"rs"}},"components":{"parameters":{"P":{"name":"q","in":"query"}},"requestBodies":{"B":{"content":{}}},"responses":{"R":{"description":"rd"}},"headers":{"H":{"description":"hd"}},"links":{"L":{"operationId":"g"}},"schemas":{"T":{"type":"string"},"S":{"$ref":"#/components/schemas/T","title":"sib","description":"alias","x-t":1},"O":{"properties":{"p":{"$ref":"#/components/schemas/T","description":"ps","x-p":1}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentSiblings31 [
	"OpenAPI 3.1: the siblings of a $ref are read by the spec. A schema alias keeps them (extensions), a path item applies them, and the others (parameter, request body, response, header, link) lose them: nothing is said"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"operationId":"g","parameters":[{"$ref":"#/components/parameters/P","description":"sib","x-s":1}],"requestBody":{"$ref":"#/components/requestBodies/B","description":"rb"},"responses":{"200":{"$ref":"#/components/responses/R","description":"rsib","x-r":1},"201":{"description":"d","headers":{"h":{"$ref":"#/components/headers/H","description":"hs"}},"links":{"l":{"$ref":"#/components/links/L","summary":"ls"}}}}}},"/q":{"$ref":"#/paths/~1p","summary":"qs","x-q":1}},"components":{"parameters":{"P":{"name":"q","in":"query"}},"requestBodies":{"B":{"content":{}}},"responses":{"R":{"description":"rd"}},"headers":{"H":{"description":"hd"}},"links":{"L":{"operationId":"g"}},"schemas":{"T":{"type":"string"},"S":{"$ref":"#/components/schemas/T","title":"sib","description":"alias","x-t":1}}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentSiblingsSwagger2 [
	"Swagger 2: keys beside a $ref of a schema (response and definition), of a parameter and of a response"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"operationId":"g","parameters":[{"$ref":"#/parameters/P","description":"sib","x-s":1}],"responses":{"200":{"description":"d","schema":{"$ref":"#/definitions/S","description":"sib","x-k":1}},"404":{"$ref":"#/responses/R","description":"rs"}}}}},"parameters":{"P":{"name":"q","in":"query","type":"string"}},"responses":{"R":{"description":"rd"}},"definitions":{"S":{"type":"string"},"A":{"$ref":"#/definitions/S","title":"t","description":"alias"}}}'
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> documentWrongTypes30 [
	"OpenAPI 3.0: values of a JSON type that does not fit the field. The importer drops them with a diagnostic (wrongNodeType) for title of Info, deprecated and format, and WITHOUT one for maximum, minimum, nullable and title of a schema (null)"

	^ '{"openapi":"3.0.3","info":{"title":5,"version":"1"},"paths":{"/p":{"get":{"operationId":"g","deprecated":"yes","responses":{"200":{"description":"d"}}}}},"components":{"schemas":{"S":{"type":"object","format":5,"maximum":"5","minimum":"1","nullable":null,"title":null,"minLength":3.5}}}}'
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> entityAt: aPointer ofClass: aClass in: aModel [
	"The entity of the class at the pointer of the model"

	^ ((FamixOpenApiPointerLookup onModel: aModel)
		   entitiesAt: aPointer
		   ofClass: aClass) first
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> extensionsReportOf: aJsonString [
	"The report of the extensions check of the real import of the document, with the diagnostics of the importer"

	| imported |
	imported := self importedOf: aJsonString.
	^ self
		  extensionsReportOf: aJsonString
		  model: imported first
		  diagnostics: imported last
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> extensionsReportOf: aJsonString model: aModel diagnostics: aCollectionOrNil [

	^ FamixOpenApiExtensionsCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: aModel
		  diagnostics: aCollectionOrNil
]

{ #category : 'documents' }
FamixOpenApiExtensionsTestCase >> headOf: aVersion [
	"The start of a document: #v30, #v31 or #v2, with an empty paths (ends with a comma)"

	aVersion = #v2 ifTrue: [
		^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{},' ].
	^ '{"openapi":"' , (aVersion = #v30
		   ifTrue: [ '3.0.3' ]
		   ifFalse: [ '3.1.0' ])
	  , '","info":{"title":"t","version":"1"},"paths":{},'
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> importedOf: aJsonString [
	"An Array: the model the real importer builds without merging the inline schemas, and its diagnostics"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: aJsonString.
	^ {
		  model.
		  importer diagnostics }
]

{ #category : 'helpers' }
FamixOpenApiExtensionsTestCase >> kindsAt: aPointer key: aKey in: aReport [
	"The kinds of the gaps of the report about the key of the node at the pointer"

	^ aReport gaps
		  select: [ :each |
		  each sourcePointer = aPointer and: [ each fieldKey = aKey ] ]
		  thenCollect: #kind
]
