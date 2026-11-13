"
The common ground of the tests of the relation check (V10): small documents of every version that exercise the relations (shared and cloned $ref, aliases, duplicates, unresolved and cyclic references, the conversions of Swagger 2, the security graph), and the helpers that import a document, run FamixOpenApiRelationCheck and mutate a relation of the model.
"
Class {
	#name : 'FamixOpenApiRelationTestCase',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> addStrayTo: aRelation rule: aRule [

	| stray |
	stray := (Smalltalk at: aRule targetClassName asSymbol) new.
	aRelation add: stray.
	^ [ aRelation remove: stray ]
]

{ #category : 'sweeps' }
FamixOpenApiRelationTestCase >> assertChangeSweepOf: aComparison in: aCheck named: aName [
	"The relation changed: the check of the owner reports exactly it"

	| restore gaps |
	restore := self mutateRelationOfComparison: aComparison.
	gaps := (aCheck recheck: aComparison) gaps.
	restore value.
	self assert: gaps size = 1 description: (self describe: {
				 aName.
				 aComparison owner pointer.
				 aComparison rule.
				 gaps }).
	self assertGap: gaps first isAbout: aComparison named: aName
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> assertExpectedAt: aPointer selector: aSelector in: aJsonString is: anArray [
	"The source designates the targets of the array, in order, and the model holds them"

	| comparison |
	comparison := self
		              comparisonAt: aPointer
		              selector: aSelector
		              in: aJsonString.
	self assert: comparison expected equals: anArray.
	self assert: comparison found equals: anArray
]

{ #category : 'sweeps' }
FamixOpenApiRelationTestCase >> assertGap: aGap isAbout: aComparison named: aName [

	self
		assert: (aGap kind = aComparison gapKind and: [
				 aGap fieldKey = aComparison rule fieldKey and: [
					 aGap sourcePointer = aComparison owner sourcePointer ] ])
		description: (self describe: {
					 aName.
					 aComparison rule.
					 aGap })
]

{ #category : 'sweeps' }
FamixOpenApiRelationTestCase >> assertMoveSweepOf: aComparison in: aCheck named: aName [
	"The first target moved to the end: an order difference"

	| restore gaps |
	restore := self reorderRelationOfComparison: aComparison.
	gaps := (aCheck recheck: aComparison) gaps.
	restore value.
	self assert: gaps size = 1 description: (self describe: {
				 aName.
				 aComparison owner pointer.
				 aComparison rule.
				 gaps }).
	self assertGap: gaps first isAbout: aComparison named: aName.
	self
		assert: ('*order differs*' match: gaps first message)
		description: (self describe: {
					 aName.
					 gaps first message })
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> assertRelationFaithful: aJsonString [
	"The real import of the document has no relation gap"

	| gaps |
	gaps := (self relationReportFor: aJsonString) gaps.
	self assert: gaps isEmpty description: (self describe: gaps)
]

{ #category : 'sweeps' }
FamixOpenApiRelationTestCase >> assertRelationSweepIn: aJsonString named: aName [
	"Every relation that the check compares on the real model of the document, changed (a target less, a stray one, emptied) is reported, once, with the field and the node of the relation; moved (the first target to the end) when it holds several targets of an ordered relation, it is reported as an order difference; the model is faithful again afterwards. Answers the number of mutations"

	| model check count |
	model := self modelOf: aJsonString.
	check := FamixOpenApiRelationCheck new
		         keepComparisons;
		         yourself.
	check
		checkInventory: (self inventoryOf: aJsonString)
		model: model
		diagnostics: nil.
	count := 0.
	check comparisons do: [ :each |
		self assertChangeSweepOf: each in: check named: aName.
		(self isMovable: each) ifTrue: [
			self assertMoveSweepOf: each in: check named: aName.
			count := count + 1 ].
		count := count + 1 ].
	self
		assert: (self relationReportOf: model for: aJsonString) gaps isEmpty
		description: aName , ': the model is not faithful after the sweep'.
	^ count
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> changeSingle: aValue of: anEntity selector: aSelector rule: aRule [
	"A relation of one is emptied, or gets a stray entity of the class of the targets when it was empty"

	| setter |
	setter := (aSelector , ':') asSymbol.
	aValue ifNotNil: [
		anEntity perform: setter with: nil.
		^ [ anEntity perform: setter with: aValue ] ].
	anEntity
		perform: setter
		with: (Smalltalk at: aRule targetClassName asSymbol) new.
	^ [ anEntity perform: setter with: nil ]
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> comparisonAt: aPointer selector: aSelector in: aJsonString [
	"The comparison of the relation of the owner at the pointer, with what the source designates (expected) and what the model holds (found)"

	| check |
	check := FamixOpenApiRelationCheck new
		         keepComparisons;
		         yourself.
	check
		checkInventory: (self inventoryOf: aJsonString)
		model: (self modelOf: aJsonString)
		diagnostics: nil.
	^ check comparisons detect: [ :each |
		  each owner pointer = aPointer and: [
			  each rule selector = aSelector ] ]
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> descriptionsOfRelationGaps: aReport [

	^ (aReport gaps collect: [ :each |
		   each kind asString , ' ' , each sourcePointer , ' '
		   , each fieldKey asString ]) asArray sorted
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentCallbacks31 [
	"OpenAPI 3.1: callbacks whose path items are a $ref to a path item registered before the site (shared: the importer holds the entity of the target) or after it (a clone at the site)"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{"/z":{"put":{"responses":{"200":{"description":"z"}}}},"/a":{"get":{"responses":{"200":{"description":"d"}},"callbacks":{"c1":{"{$x}":{"$ref":"#/paths/~1z"}},"c2":{"{$y}":{"$ref":"#/paths/~1b"}}}}},"/b":{"post":{"responses":{"200":{"description":"b"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentDuplicateOperationIds30 [
	"OpenAPI 3.0: two operations with the same operationId (the one of /z comes first in the document, the one of /a first in the alphabet) and a link, on a third path, to that operationId (VERIFIED by import: the link holds the first operation of the document)"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/z":{"get":{"operationId":"dup","responses":{"200":{"description":"z"}}}},"/a":{"get":{"operationId":"dup","responses":{"200":{"description":"a"}}}},"/m":{"get":{"operationId":"m","responses":{"200":{"description":"m","links":{"l":{"operationId":"dup"}}}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentDuplicatesSwagger2 [
	"Swagger 2: a media type listed twice in produces (two entities at the same pointer, both held by the response)"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"produces":["a/b","a/b","c/d"],"paths":{"/p":{"get":{"responses":{"200":{"description":"d","schema":{"type":"string"}}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentFormsSwagger2 [
	"Swagger 2: operations with a formData parameter and the consumes the media types of the form depend on (VERIFIED by import: the form media types are those of the consumes of the operation, or of the root when the operation has no consumes or an empty one; a consumes without any form media type, like a/b, gives the default; without any, multipart/form-data for a form with a file, else application/x-www-form-urlencoded)"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"consumes":["application/json"],"paths":{"/p":{"post":{"operationId":"a","parameters":[{"name":"f","in":"formData","type":"file"}],"responses":{"200":{"description":"d"}}},"put":{"operationId":"b","consumes":["application/x-www-form-urlencoded"],"parameters":[{"name":"f","in":"formData","type":"file"}],"responses":{"200":{"description":"d"}}},"patch":{"operationId":"c","consumes":["a/b","multipart/form-data"],"parameters":[{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}},"get":{"operationId":"d","parameters":[{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}},"delete":{"operationId":"e","consumes":["application/x-www-form-urlencoded","multipart/form-data"],"parameters":[{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}},"head":{"operationId":"f","consumes":["a/b"],"parameters":[{"name":"f","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentParametersSwagger2 [
	"Swagger 2: a path item with a body and a formData parameter, an operation with two body parameters (the second is dropped), a formData parameter (dropped) and two kept parameters, and an operation with a formData parameter only"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"parameters":[{"name":"pb","in":"body","x-pb":1,"schema":{"type":"string"}},{"name":"pf","in":"formData","type":"string","x-pf":1}],"post":{"operationId":"a","parameters":[{"name":"b1","in":"body","x-b1":1,"schema":{"type":"string"}},{"name":"b2","in":"body","x-b2":1,"schema":{"type":"integer"}},{"name":"f","in":"formData","type":"string","x-f":2},{"name":"q","in":"query","type":"string","x-q":1},{"name":"h","in":"header","type":"string","x-h":1}],"responses":{"200":{"description":"d"}}},"get":{"operationId":"c","parameters":[{"name":"f","in":"formData","type":"string","x-f":3}],"responses":{"200":{"description":"d"}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentRefs30 [
	"OpenAPI 3.0: a shared parameter listed twice (held once), an alias of a parameter (no entity), path-level parameters that the operation does not inherit, a default response that is a $ref"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"parameters":[{"name":"pa","in":"query"},{"$ref":"#/components/parameters/P"}],"get":{"operationId":"g","parameters":[{"$ref":"#/components/parameters/P"},{"$ref":"#/components/parameters/Q"},{"$ref":"#/components/parameters/P"},{"$ref":"#/components/parameters/Alias"}],"responses":{"200":{"description":"d"},"default":{"$ref":"#/components/responses/R"}}}}},"components":{"parameters":{"P":{"name":"q","in":"query"},"Q":{"name":"r","in":"query"},"Alias":{"$ref":"#/components/parameters/Q"}},"responses":{"R":{"description":"r"}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentSecurity31 [
	"OpenAPI 3.1: security requirements with an unknown scheme and an empty one, oauth2 flows with scopes, links by operationId and operationRef, a parameter with example and examples, a $ref that has an allOf beside it, discriminator mappings (a name, a $ref, unresolved, external)"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"security":[{"k":["a"],"unknown":[]},{}],"paths":{"/p":{"get":{"operationId":"g","responses":{"200":{"description":"d","links":{"l1":{"operationId":"g"},"l2":{"operationRef":"#/paths/~1p/get"},"l3":{"operationId":"zz"},"l4":{"operationRef":"#/paths/~1nowhere/get"},"l5":{"operationId":"g","server":{"url":"x"}}}}}},"post":{"operationId":"q","parameters":[{"name":"p","in":"query","example":3,"examples":{"e":{"value":1}}}],"responses":{"200":{"description":"d"}}}}},"components":{"securitySchemes":{"k":{"type":"oauth2","flows":{"implicit":{"authorizationUrl":"http://a","scopes":{"a":"A","b":"B"}},"password":{"tokenUrl":"http://t","scopes":{}}}}},"schemas":{"T":{"type":"string"},"Mix":{"$ref":"#/components/schemas/T","allOf":[{"type":"integer"}],"description":"d"},"Bad":{"$ref":"#/components/schemas/Nope","description":"d"},"Disc":{"oneOf":[{"$ref":"#/components/schemas/T"}],"discriminator":{"propertyName":"p","mapping":{"a":"T","b":"#/components/schemas/T","c":"#/components/schemas/Nope","d":"http://ext/x"}}},"Ar":{"type":"array","items":{"$ref":"#/components/schemas/T"},"xml":{"name":"n"},"externalDocs":{"url":"http://e"}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentSharedKinds30 [
	"OpenAPI 3.0: a shared header used twice by a response and by an encoding, a shared example and an inline one in the examples of a media type"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"responses":{"200":{"description":"d","headers":{"h":{"$ref":"#/components/headers/H"},"h2":{"$ref":"#/components/headers/H"}},"content":{"a/b":{"schema":{"type":"string"},"examples":{"e":{"$ref":"#/components/examples/E"},"f":{"value":1}},"encoding":{"x":{"headers":{"eh":{"$ref":"#/components/headers/H"}}}}}}}}}}},"components":{"headers":{"H":{"schema":{"type":"string"}}},"examples":{"E":{"value":2}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentSharedKinds31 [
	"OpenAPI 3.1: the same shared header and example as documentSharedKinds30 (headers with a schema, an encoding with a header, examples of a media type)"

	^ self documentSharedKinds30 copyReplaceAll: '3.0.3' with: '3.1.0'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentStructure30 [
	"OpenAPI 3.0: shared component parameter, request body and response used by an operation, a path item that is a $ref (clone), responses in the order 200 then 404, a schema graph (allOf, properties, discriminator and its mapping) and a security requirement"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"servers":[{"url":"http://s"}],"tags":[{"name":"a"}],"paths":{"/p":{"parameters":[{"$ref":"#/components/parameters/P"},{"name":"pp","in":"query"}],"get":{"operationId":"g","tags":["a"],"parameters":[{"$ref":"#/components/parameters/P"},{"name":"z","in":"query","schema":{"type":"string"}},{"name":"pp","in":"query","description":"override"}],"requestBody":{"$ref":"#/components/requestBodies/B"},"responses":{"200":{"$ref":"#/components/responses/R"},"404":{"description":"nf","content":{"application/json":{"schema":{"$ref":"#/components/schemas/S"}}}}},"security":[{"k":["a","b"]},{}]}},"/q":{"$ref":"#/paths/~1p"}},"components":{"parameters":{"P":{"name":"q","in":"query","schema":{"$ref":"#/components/schemas/T"}}},"requestBodies":{"B":{"content":{"a/b":{"schema":{"type":"string"}}}}},"responses":{"R":{"description":"d","headers":{"h":{"schema":{"type":"string"}}}}},"schemas":{"T":{"type":"string"},"S":{"allOf":[{"$ref":"#/components/schemas/T"},{"type":"object","properties":{"a":{"$ref":"#/components/schemas/T"},"b":{"type":"integer"}}}],"discriminator":{"propertyName":"a","mapping":{"x":"#/components/schemas/T"}}}},"securitySchemes":{"k":{"type":"http","scheme":"basic"}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentStructure31 [
	"OpenAPI 3.1: servers, operation servers, links, callbacks (shared and inline), webhooks, a path item of the components, allOf with a repeated target, oneOf, prefixItems, an alias of the components, a 3.1 schema that is a $ref with a sibling"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"servers":[{"url":"http://a"},{"url":"http://a"}],"paths":{"/p":{"get":{"operationId":"g","servers":[{"url":"u1"}],"responses":{"200":{"description":"d","links":{"l1":{"$ref":"#/components/links/L"},"l2":{"$ref":"#/components/links/L"},"l3":{"operationId":"g","server":{"url":"ls"}}}}},"callbacks":{"cb":{"$ref":"#/components/callbacks/CB"},"cb2":{"{$request.body#/u}":{"post":{"responses":{"200":{"description":"x"}}}}}}}}},"webhooks":{"wh":{"post":{"responses":{"200":{"description":"w"}}}},"wr":{"$ref":"#/components/pathItems/PI"}},"components":{"links":{"L":{"operationId":"g"}},"pathItems":{"PI":{"get":{"responses":{"200":{"description":"pi"}}}}},"callbacks":{"CB":{"{$x}":{"put":{"responses":{"200":{"description":"cbr"}}}}}},"schemas":{"T":{"type":"string"},"U":{"type":"integer"},"S":{"allOf":[{"$ref":"#/components/schemas/T"},{"$ref":"#/components/schemas/T"},{"$ref":"#/components/schemas/U"}],"oneOf":[{"$ref":"#/components/schemas/U"},{"$ref":"#/components/schemas/T"}],"prefixItems":[{"type":"string"},{"$ref":"#/components/schemas/T","description":"sib"}],"items":{"$ref":"#/components/schemas/T"},"not":{"$ref":"#/components/schemas/U"},"additionalProperties":{"$ref":"#/components/schemas/T"},"properties":{"b":{"type":"string"},"a":{"$ref":"#/components/schemas/T"}}},"A":{"$ref":"#/components/schemas/T"},"B":{"allOf":[{"$ref":"#/components/schemas/A"}]},"C":{"additionalProperties":true,"items":false}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentStructureSwagger2 [
	"Swagger 2: host, basePath and schemes (servers), consumes and produces (media types), a body parameter, a typed array parameter, a $ref to a body parameter, a response with a schema and a $ref response (clone), formData parameters (form request body), definitions with allOf and a discriminator, an oauth2 scheme with scopes"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"host":"h.com","basePath":"/v1","schemes":["https","http"],"consumes":["application/json","application/xml"],"produces":["application/json","text/plain"],"paths":{"/p":{"parameters":[{"name":"pq","in":"query","type":"string"},{"$ref":"#/parameters/Q"}],"post":{"operationId":"a","parameters":[{"name":"b","in":"body","schema":{"$ref":"#/definitions/D"}},{"name":"x","in":"query","type":"array","items":{"type":"integer"}},{"$ref":"#/parameters/Q"}],"responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/D"},"headers":{"h":{"type":"string"}}},"201":{"$ref":"#/responses/R"},"default":{"description":"d"}},"security":[{"k":["s1"]}]},"put":{"operationId":"b","consumes":["multipart/form-data"],"parameters":[{"name":"f","in":"formData","type":"string"},{"name":"g","in":"formData","type":"file"}],"responses":{"200":{"description":"ok"}}},"get":{"operationId":"c","parameters":[{"$ref":"#/parameters/B"}],"responses":{"200":{"description":"ok"}}}}},"parameters":{"Q":{"name":"q","in":"query","type":"string"},"B":{"name":"bb","in":"body","schema":{"type":"string"}}},"responses":{"R":{"description":"r","schema":{"type":"string"}}},"definitions":{"D":{"type":"object","properties":{"a":{"type":"string"}},"allOf":[{"$ref":"#/definitions/E"}],"discriminator":"a"},"E":{"type":"string"}},"securityDefinitions":{"k":{"type":"oauth2","flow":"implicit","authorizationUrl":"http://a","scopes":{"s1":"d","s2":"e"}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentUnresolved30 [
	"OpenAPI 3.0: unresolved and cyclic $ref (parameter, request body, response, schema, example), operations in the order put, get, delete, head, a scalar example and examples, an encoding with a header"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"parameters":[{"name":"pa","in":"query"}],"put":{"operationId":"p","responses":{"200":{"description":"d"}}},"get":{"operationId":"g","parameters":[{"$ref":"#/components/parameters/Nope"},{"name":"ok","in":"query","schema":{"$ref":"#/components/schemas/Nope"}},{"$ref":"#/components/parameters/Cyc"}],"requestBody":{"$ref":"#/components/requestBodies/Nope"},"responses":{"200":{"$ref":"#/components/responses/Nope"},"201":{"description":"d","content":{"a/b":{"schema":{"$ref":"#/components/schemas/Cyc"},"examples":{"e1":{"$ref":"#/components/examples/Nope"},"e2":{"summary":"s"}},"example":5,"encoding":{"f":{"headers":{"X":{"description":"x"}}}}}}}}},"delete":{"responses":{"200":{"description":"d"}}},"head":{"responses":{"200":{"description":"d"}}}}},"components":{"parameters":{"Cyc":{"$ref":"#/components/parameters/Cyc2"},"Cyc2":{"$ref":"#/components/parameters/Cyc"}},"schemas":{"Cyc":{"$ref":"#/components/schemas/Cyc2"},"Cyc2":{"$ref":"#/components/schemas/Cyc"},"Un":{"allOf":[{"$ref":"#/components/schemas/Nope"},{"type":"string"}],"properties":{"p":{"$ref":"#/components/schemas/Nope"}},"items":{"$ref":"#/components/schemas/Nope"}}}}}'
]

{ #category : 'documents' }
FamixOpenApiRelationTestCase >> documentUnresolvedSwagger2 [
	"Swagger 2: unresolved references at the paths (a body parameter schema, a parameter, a response schema, a response), in the parameters, in the responses and in the definitions of the root, the paths coming FIRST in the document (VERIFIED by import: the importer meets the definitions first, then the responses, then the paths, so the unresolvedReferences of the root are N7, N6, N2, N1, N3, N4; N5 is not a reference but a componentAlias diagnostic, the parameter Q being an alias of the components)"

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"post":{"parameters":[{"name":"b","in":"body","schema":{"$ref":"#/definitions/N1"}},{"$ref":"#/parameters/N2"}],"responses":{"200":{"description":"d","schema":{"$ref":"#/definitions/N3"}},"201":{"$ref":"#/responses/N4"}}}}},"parameters":{"Q":{"$ref":"#/parameters/N5"}},"responses":{"R":{"description":"r","schema":{"$ref":"#/definitions/N6"}}},"definitions":{"D":{"type":"object","properties":{"a":{"$ref":"#/definitions/N7"}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> expectedAt: aPointer selector: aSelector in: aJsonString [
	"What the source designates for the relation of the owner at the pointer, as an Array of canonical pointers"

	^ (self comparisonAt: aPointer selector: aSelector in: aJsonString)
		  expected
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> firstGapOf: aJsonString after: aBlock [
	"The only gap of the model of aJsonString mutated by aBlock"

	| model report |
	model := self modelOf: aJsonString.
	aBlock value: model.
	report := self relationReportOf: model for: aJsonString.
	self assert: report gaps size equals: 1.
	^ report gaps first
]

{ #category : 'sweeps' }
FamixOpenApiRelationTestCase >> isMovable: aComparison [
	"True when moving the first target of the relation to the end changes the order of an ordered relation: it holds several different targets"

	^ aComparison rule compareMode == #ordered and: [
		  aComparison expected asSet size > 1 ]
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> mutateRelationOfComparison: aComparison [
	"Change the relation of the comparison so that it no longer holds what the source designates: answer a block that restores it, order included. A relation that holds several targets loses the first one, a relation of one is emptied, an empty relation gets a stray entity of the class of the targets"

	| entity selector value |
	entity := aComparison owner entity.
	selector := aComparison rule selector.
	value := entity perform: selector.
	value isCollection ifFalse: [
		^ self
			  changeSingle: value
			  of: entity
			  selector: selector
			  rule: aComparison rule ].
	value isEmpty ifTrue: [
		^ self addStrayTo: value rule: aComparison rule ].
	^ self removeFirstOf: value
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> relationGapsOf: aJsonString after: aBlock [
	"The gaps of the relations of the model of aJsonString mutated by aBlock (given the model), as sorted 'kind pointer field' Strings"

	| model |
	model := self modelOf: aJsonString.
	aBlock value: model.
	^ self descriptionsOfRelationGaps:
		  (self relationReportOf: model for: aJsonString)
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> relationGapsOfModelOf: aModelJson against: aSourceJson [
	"The gaps of the relations of the model imported from a document against ANOTHER one (the source side mutations: the model is the original, the source changed)"

	^ self descriptionsOfRelationGaps:
		  (self
			   relationReportOf: (self modelOf: aModelJson)
			   for: aSourceJson)
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> relationReportFor: aJsonString [
	"Import the document (1:1) and check the relations of the model against the document, with the diagnostics of the import"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: aJsonString.
	^ FamixOpenApiRelationCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: model
		  diagnostics: importer diagnostics
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> relationReportOf: aModel for: aJsonString [
	"Check a model (possibly mutated by the test) against the document"

	^ FamixOpenApiRelationCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: aModel
		  diagnostics: nil
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> removeFirstOf: aRelation [
	"The first target taken out; the block puts all of them back in their order"

	| all |
	all := aRelation asArray.
	aRelation remove: all first.
	^ [ self setRelation: aRelation to: all ]
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> reorderRelationOfComparison: aComparison [
	"Move the first target of the relation to the end: answer a block that restores the order"

	| relation all |
	relation := aComparison owner entity perform:
		            aComparison rule selector.
	all := relation asArray.
	self setRelation: relation to: all allButFirst , { all first }.
	^ [ self setRelation: relation to: all ]
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> replace: anOldText with: aNewText in: aJsonString [
	"The document with the text replaced (it must be there)"

	self assert: (aJsonString includesSubstring: anOldText).
	^ aJsonString copyReplaceAll: anOldText with: aNewText
]

{ #category : 'helpers' }
FamixOpenApiRelationTestCase >> setRelation: aRelation to: aCollection [
	"The relation holds exactly the elements of the collection, in its order"

	aRelation asArray do: [ :each | aRelation remove: each ].
	aCollection do: [ :each | aRelation add: each ]
]
