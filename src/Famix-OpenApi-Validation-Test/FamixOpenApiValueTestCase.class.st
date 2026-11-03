"
Helpers of the tests of the value check (V8): the real importer (mergesInlineSchemas false), the inventory of the walker, the check with the comparisons it made, the mutation of the slot of an entity (a value that is not equivalent to the expected one: FamixOpenApiValueComparator>>aDifferentValueFrom:) and the sweeps over every comparison of a document: each slot compared is changed in turn and the check must report exactly that slot (#valueMismatch, or #countMismatch for a number of elements) and nothing else. The documents are rich ones of each version (every compared field with a value that is not a default, unicode, nested JSON, whole floats) and small ones for the conversions; the fixtures of the existence check are inherited.
"
Class {
	#name : 'FamixOpenApiValueTestCase',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'checking' }
FamixOpenApiValueTestCase >> assertFaithfulValues: aJsonString [
	"The real import of the document has no gap of value"

	| gaps |
	gaps := (self valueReportOf: aJsonString) gaps.
	self assert: gaps isEmpty description: (self describe: gaps)
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> assertOneGap: aCollection field: aFieldKey expected: anExpected found: aFound [
	"The gaps are one #valueMismatch about the field, with the normalised expected and found values"

	self assert: aCollection size equals: 1.
	self assert: aCollection first kind equals: #valueMismatch.
	self assert: aCollection first fieldKey equals: aFieldKey.
	self assert: aCollection first expected equals: anExpected.
	self assert: aCollection first found equals: aFound
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> assertSweepOf: aComparison in: aCheck named: aName [
	"The slot of the comparison changed: the check of the node reports exactly it"

	| restore gaps |
	restore := self mutate: aComparison.
	gaps := (aCheck checkOnly: aComparison node) gaps.
	restore value.
	self assert: gaps size = 1 description: (self describe: {
				 aName.
				 aComparison entityPointer.
				 aComparison rule.
				 gaps }).
	self
		assert: (self isGap: gaps first about: aComparison)
		description: (self describe: {
					 aName.
					 aComparison rule.
					 gaps first })
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> assertValueSweepIn: aJsonString named: aName [
	"Every slot the check compares, changed in turn to a value that is not equivalent to the expected one, is the only gap of its node (#valueMismatch, #countMismatch for a number of elements). Answers the number of slots changed"

	| check comparisons |
	check := self valueCheckOf: aJsonString.
	self
		assert: check report gaps isEmpty
		description: (self describe: {
					 aName.
					 check report gaps }).
	comparisons := check comparisons copy.
	comparisons do: [ :each |
		self assertSweepOf: each in: check named: aName ].
	^ comparisons size
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> classOfRelation: aSelector [
	"The class of the elements of the relations the check counts"

	^ Smalltalk at: ({
			   (#servers -> #OPServer).
			   (#tags -> #OPTag).
			   (#securityRequirements -> #OPSecurityRequirement) } asDictionary
			   at: aSelector)
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> comparisonAt: aPointer field: aFieldKey class: aClassName in: aCheck [
	"The comparison of the check for the field of the node at the pointer, carried by the class"

	^ aCheck comparisons detect: [ :each |
		  each entityPointer = aPointer and: [
			  each rule fieldKey = aFieldKey and: [
				  each rule targetClassName = aClassName ] ] ]
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> coverageOf: aJsonString [
	"The coverage of the value check of the real import"

	^ (self valueReportOf: aJsonString) coverage
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> documentOpenApiSiblings: aSchemaText kind: aKind [

	^ '{"openapi":"' , (aKind = #v31
		   ifTrue: [ '3.1.0' ]
		   ifFalse: [ '3.0.3' ])
	  ,
	  '","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"q","in":"query","schema":'
	  , aSchemaText
	  , '}],"requestBody":{"content":{"application/json":{"schema":'
	  , aSchemaText
	  ,
	  '}}},"responses":{"200":{"description":"d","content":{"application/json":{"schema":'
	  , aSchemaText
	  , '}}}}}}},"components":{"schemas":{"S":{"type":"string"},"A":'
	  , aSchemaText , ',"O":{"type":"object","properties":{"p":'
	  , aSchemaText , '},"allOf":[' , aSchemaText
	  , '],"additionalProperties":' , aSchemaText , ',"not":'
	  , aSchemaText , '},"Ar":{"type":"array","items":' , aSchemaText
	  , '}}}}'
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> documentSiblings: aKind fragment: aString [
	"A document of the kind (#v30, #v31 or #v2) where S is a schema, A an alias, and the schemas that are a $ref to S with the keywords of the fragment beside the $ref are in every place a schema can be: a property, the items, an element of allOf, the additional properties, the schema of a media type or of a parameter, the schema of a body parameter or of a response"

	| s |
	s := self schemaWithSiblings: aKind fragment: aString.
	^ aKind = #v2
		  ifTrue: [ self documentSwagger2Siblings: s ]
		  ifFalse: [ self documentOpenApiSiblings: s kind: aKind ]
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> documentSwagger2Siblings: aSchemaText [

	^ '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"b","in":"body","schema":'
	  , aSchemaText
	  , '}],"responses":{"200":{"description":"d","schema":'
	  , aSchemaText , '}}}}},"definitions":{"S":{"type":"string"},"A":'
	  , aSchemaText , ',"O":{"type":"object","properties":{"p":'
	  , aSchemaText , '},"allOf":[' , aSchemaText
	  , '],"additionalProperties":' , aSchemaText
	  , '},"Ar":{"type":"array","items":' , aSchemaText , '}}}'
]

{ #category : 'documents' }
FamixOpenApiValueTestCase >> documentValues30 [
	"OpenAPI 3.0: every compared field with a value that is not a default: nullable and exclusive bounds of the 3.0 form, JSON text with nested objects and whole floats, unicode, the flags, style and explode, an alias and a cloned response, scopes, the example of a parameter and of a media type"

	^ '{"openapi":"3.0.3","info":{"title":"Tëst → API","version":"1.0","description":"d","termsOfService":"http://tos","contact":{"name":"n","url":"http://u","email":"e@x"},"license":{"name":"MIT","url":"http://l"}},"servers":[{"url":"http://{h}/v","description":"s","variables":{"h":{"default":"a","enum":["a","b"],"description":"hd"}}}],"tags":[{"name":"a","description":"ad","externalDocs":{"url":"http://x","description":"xd"}}],"security":[{"k":[]}],"paths":{"/p/{id}":{"summary":"ps","description":"pd","get":{"operationId":"g","summary":"s","description":"d","tags":["a","b"],"deprecated":true,"security":[{"k":[]}],"parameters":[{"name":"id","in":"path","required":true,"description":"pd","deprecated":false,"allowEmptyValue":false,"style":"simple","explode":false,"allowReserved":true,"example":{"a":[1,2.5]},"schema":{"type":"string","nullable":true,"minLength":1,"maxLength":10,"pattern":"^a","format":"uuid","enum":["x",{"k":[1,2.5]},null],"default":"x","example":{"b":1.0},"title":"T","description":"dé→ü","readOnly":true,"writeOnly":false,"deprecated":true,"minimum":1,"exclusiveMinimum":true,"maximum":9.5,"exclusiveMaximum":false,"multipleOf":0.5,"uniqueItems":true,"maxItems":3,"minItems":1,"maxProperties":4,"minProperties":1,"required":["z"],"properties":{"z":{"type":"integer"}},"xml":{"name":"xn","namespace":"ns","prefix":"p","attribute":true,"wrapped":true},"discriminator":{"propertyName":"z"}}}],"requestBody":{"description":"rbd","required":true,"content":{"application/json":{"example":{"e":1},"schema":{"$ref":"#/components/schemas/S"},"encoding":{"z":{"contentType":"text/plain","style":"form","explode":true,"allowReserved":true}}}}},"responses":{"200":{"description":"ok","headers":{"h":{"description":"hd","required":true,"deprecated":true,"style":"simple","explode":true}},"links":{"l":{"operationRef":"#/x","operationId":"oid","requestBody":{"a":1},"description":"ld"}}},"default":{"$ref":"#/components/responses/R"}}}}},"components":{"schemas":{"S":{"type":"object","nullable":false},"A":{"$ref":"#/components/schemas/S"}},"responses":{"R":{"description":"rd"}},"examples":{"e":{"summary":"es","value":{"k":"v"},"externalValue":"http://ev"}},"securitySchemes":{"k":{"type":"apiKey","name":"nm","in":"header","description":"kd"},"h":{"type":"http","scheme":"bearer","bearerFormat":"JWT"},"oi":{"type":"openIdConnect","openIdConnectUrl":"http://oi"},"o":{"type":"oauth2","flows":{"authorizationCode":{"authorizationUrl":"au","tokenUrl":"tu","refreshUrl":"ru","scopes":{"s":"sd","t/u":"td"}}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiValueTestCase >> documentValues31 [
	"OpenAPI 3.1: the type as an array with null, number bounds, const, jsonSchemaDialect, a schema with a $ref and siblings, a path item that is a $ref with siblings (the keys beside the $ref override the target), a cloned response, a webhook, an unusual media type"

	^ '{"openapi":"3.1.0","jsonSchemaDialect":"http://d","info":{"title":"t31","version":"2","summary":"is"},"servers":[{"url":"http://s1"},{"url":"http://s2"}],"paths":{"/a":{"$ref":"#/components/pathItems/P","summary":"sib","description":"sd"},"/b":{"get":{"operationId":"b","parameters":[{"name":"q","in":"query","example":5,"schema":{"type":["integer","null"],"const":{"a":[1]},"exclusiveMinimum":3,"exclusiveMaximum":9.5,"minimum":1.0,"maximum":20,"multipleOf":0.5,"default":null,"enum":[1,null,"a"],"readOnly":false,"example":"x","deprecated":true,"writeOnly":true}},{"name":"r","in":"query","schema":{"type":"null"}}],"requestBody":{"content":{"application/vnd.api+json":{"schema":{"$ref":"#/components/schemas/S","description":"sib31","title":"T31"},"examples":{"e":{"summary":"es","value":[1,2],"externalValue":"http://ev"}}}}},"responses":{"200":{"$ref":"#/components/responses/R","description":"over"},"2XX":{"description":"range"}}}}},"webhooks":{"w":{"post":{"operationId":"hook","responses":{"200":{"description":"w"}}}}},"components":{"schemas":{"S":{"type":["string","integer"],"format":"int32"},"T":{"$ref":"#/components/schemas/S"}},"responses":{"R":{"description":"rd"}},"pathItems":{"P":{"summary":"ps","get":{"operationId":"og","responses":{"200":{"description":"d"}}}}}}}'
]

{ #category : 'documents' }
FamixOpenApiValueTestCase >> documentValuesSwagger2 [
	"Swagger 2: the typed parameters with their keywords and collection formats (csv, multi, ssv, pipes, tsv), exclusive bounds as booleans, a body parameter (the request body of the operation), formData parameters (a request body required because one is), security definitions of every type and flow with scopes, a definition with discriminator, required and xml, the host, base path and schemes (two servers)"

	^ '{"swagger":"2.0","info":{"title":"t2","version":"1","description":"d","termsOfService":"tos","contact":{"name":"n","url":"u","email":"e"},"license":{"name":"l","url":"lu"}},"host":"h.com","basePath":"/v1","schemes":["https","http"],"consumes":["application/json"],"produces":["application/json"],"security":[{"k":[]},{"o":["s"]}],"tags":[{"name":"a","description":"td"}],"paths":{"/p/{id}":{"get":{"operationId":"g","summary":"s","description":"d","tags":["a"],"deprecated":true,"parameters":[{"name":"id","in":"path","required":true,"description":"pd","type":"array","items":{"type":"integer","format":"int32","maximum":5,"exclusiveMaximum":true,"minimum":1,"enum":[1,2],"default":1,"multipleOf":1},"collectionFormat":"multi","maxItems":4,"minItems":1,"uniqueItems":true,"allowEmptyValue":true},{"name":"q","in":"query","type":"string","collectionFormat":"csv","default":"x","pattern":"p","maxLength":3,"minLength":1},{"name":"t","in":"query","type":"array","items":{"type":"string"},"collectionFormat":"tsv"},{"name":"s","in":"query","type":"array","items":{"type":"string"},"collectionFormat":"ssv"},{"name":"pp","in":"query","type":"array","items":{"type":"string"},"collectionFormat":"pipes"},{"name":"n","in":"query","type":"number","minimum":0,"exclusiveMinimum":true}],"responses":{"200":{"description":"ok","schema":{"type":"string"},"headers":{"h":{"description":"hd","type":"integer"}}},"default":{"description":"def"}}},"put":{"operationId":"pu","parameters":[{"name":"b","in":"body","description":"bd","required":true,"schema":{"type":"object","properties":{"a":{"type":"string"}},"required":["a"]}}],"responses":{"200":{"description":"d"}}},"post":{"operationId":"po","parameters":[{"name":"a","in":"formData","type":"string","required":true},{"name":"f","in":"formData","type":"file"}],"responses":{"200":{"description":"d"}}}}},"definitions":{"D":{"type":"object","discriminator":"kind","properties":{"kind":{"type":"string","xml":{"name":"x"}}},"required":["kind"],"readOnly":true,"example":{"a":1},"maximum":10,"exclusiveMaximum":true,"title":"DT"},"A":{"$ref":"#/definitions/D"}},"securityDefinitions":{"k":{"type":"apiKey","name":"X","in":"header","description":"kd"},"b":{"type":"basic"},"o":{"type":"oauth2","flow":"accessCode","authorizationUrl":"au","tokenUrl":"tu","scopes":{"s":"sd"}},"o2":{"type":"oauth2","flow":"application","tokenUrl":"tu"},"o3":{"type":"oauth2","flow":"implicit","authorizationUrl":"au"},"o4":{"type":"oauth2","flow":"password","tokenUrl":"tu"}}}'
]

{ #category : 'documents' }
FamixOpenApiValueTestCase >> documentsBad [
	"Associations name -> JSON text: six documents that are wrong in different ways (no version, nothing in it, values of the wrong JSON type, the typed parameters and bodies of Swagger 2 that are not, references that do not resolve, that come back to themselves)"

	^ {
		  ('noVersion' -> '{}').
		  ('empty' -> '{"openapi":"3.0.3"}').
		  ('wrongTypes30'
		   ->
		   '{"openapi":"3.0.3","info":5,"paths":[],"components":{"schemas":{"A":5,"B":null,"C":{"type":{"x":1},"properties":[1],"required":7,"enum":"a","maximum":"4","nullable":"yes"}}}}').
		  ('wrongTypes2'
		   ->
		   '{"swagger":"2.0","info":{},"paths":{"/p":{"get":{"parameters":[5,{"in":"body"},{"name":"x","in":"formData","type":7},{"name":"y","in":"query","type":"string","collectionFormat":9}],"responses":{"200":5}}}},"definitions":{"A":{"$ref":"#/definitions/A"}}}').
		  ('wrongTypes31'
		   ->
		   '{"openapi":"3.1.0","info":{"title":null,"version":1},"servers":[7,{"url":5}],"tags":[1,{"name":2}],"security":[5],"paths":{"/p":{"get":{"callbacks":{"c":{"x":{"$ref":"#/paths/~1p"}}},"responses":{"default":{"$ref":"#/nope"}}}}}}').
		  ('cycles'
		   ->
		   '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"$ref":"#/components/parameters/P"}],"responses":{"200":{"$ref":"#/components/responses/R"}}}}},"components":{"parameters":{"P":{"$ref":"#/components/parameters/P"}},"responses":{"R":{"$ref":"#/components/responses/S"},"S":{"$ref":"#/components/responses/R"}}}}') }
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> expectedAt: aPointer field: aFieldKey class: aClassName in: aJsonString [
	"The value that the check expects for the field of the node at the pointer"

	^ (self
		   comparisonAt: aPointer
		   field: aFieldKey
		   class: aClassName
		   in: (self valueCheckOf: aJsonString)) expected
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> isGap: aGap about: aComparison [

	^ aGap kind = aComparison comparator gapKind and: [
		  aGap sourcePointer = aComparison entityPointer and: [
			  aGap fieldKey = aComparison rule fieldKey and: [
				  aGap expected = aComparison expected and: [
					  aGap entity == aComparison entity and: [
						  aGap found ~= aGap expected ] ] ] ] ]
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> mutate: aComparison [
	"Change the slot of the entity of the comparison to a value that is not equivalent to the expected one; answers a block that puts it back"

	aComparison comparator gapKind == #countMismatch ifTrue: [
		^ self mutateRelationOf: aComparison ].
	^ self mutateSlotOf: aComparison
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> mutateRelationOf: aComparison [
	"One element less, or one more when the relation is empty"

	| relation removed added |
	relation := aComparison rawFound.
	relation ifNotEmpty: [
		removed := relation first.
		relation remove: removed.
		^ [ relation add: removed ] ].
	added := (self classOfRelation: aComparison rule selector) new.
	relation add: added.
	^ [ relation remove: added ]
]

{ #category : 'sweeps - values' }
FamixOpenApiValueTestCase >> mutateSlotOf: aComparison [

	| original |
	original := aComparison rawFound.
	aComparison entity
		perform: (aComparison rule selector , ':') asSymbol
		with:
		(aComparison comparator aDifferentValueFrom: aComparison expected).
	^ [
	  aComparison entity
		  perform: (aComparison rule selector , ':') asSymbol
		  with: original ]
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> pointerOfParameter [
	"The parameter of the operation of documentValues30"

	^ '#/paths/~1p~1{id}/get/parameters/0'
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> pointerOfParameterSchema [

	^ self pointerOfParameter , '/schema'
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> referenceOfTarget: aKind [
	"The $ref to the schema S of the document of the kind"

	^ aKind = #v2
		  ifTrue: [ '#/definitions/S' ]
		  ifFalse: [ '#/components/schemas/S' ]
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> schemaWithSiblings: aKind fragment: aString [
	"A schema that is a $ref to S, followed by the keywords of the fragment"

	^ '{"$ref":"' , (self referenceOfTarget: aKind) , '"' , aString , '}'
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> siblingFragmentOf: aKind keys: aCollection variant: aNumber [
	"The JSON text of the keywords of the keys, for the kind of document, with the values of the variant (1 or 2): each one is preceded by a comma"

	^ String streamContents: [ :stream |
		  self siblingPieces
			  select: [ :each |
				  (each fourth includes: aKind) and: [
					  aCollection includes: each first ] ]
			  thenDo: [ :each |
				  stream
					  nextPutAll: ',"';
					  nextPutAll: each first;
					  nextPutAll: '":';
					  nextPutAll: (each at: aNumber + 1) ] ]
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> siblingKeysOf: aKind [
	"The keys of the keywords a schema of the kind of document (#v30, #v31 or #v2) can have beside its $ref"

	^ self siblingPieces
		  select: [ :each | each fourth includes: aKind ]
		  thenCollect: #first
]

{ #category : 'documents - siblings' }
FamixOpenApiValueTestCase >> siblingPieces [
	"The keywords a schema can have beside its $ref: key, JSON text of the variant 1, JSON text of the variant 2 (another value of the same JSON type), the kinds of document that have it"

	| all |
	all := #( #v30 #v31 #v2 ).
	^ {
		  {
			  'description'.
			  '"D1"'.
			  '"D2"'.
			  all }.
		  {
			  'title'.
			  '"T1"'.
			  '"T2"'.
			  all }.
		  {
			  'nullable'.
			  'true'.
			  'false'.
			  all }.
		  {
			  'readOnly'.
			  'true'.
			  'false'.
			  all }.
		  {
			  'writeOnly'.
			  'true'.
			  'false'.
			  all }.
		  {
			  'deprecated'.
			  'true'.
			  'false'.
			  all }.
		  {
			  'uniqueItems'.
			  'true'.
			  'false'.
			  all }.
		  {
			  'example'.
			  '{"a":[1,2.5]}'.
			  '{"b":null}'.
			  all }.
		  {
			  'default'.
			  '"x"'.
			  '"y"'.
			  all }.
		  {
			  'enum'.
			  '["x",null]'.
			  '[1,2]'.
			  all }.
		  {
			  'type'.
			  '"object"'.
			  '"array"'.
			  all }.
		  {
			  'format'.
			  '"f1"'.
			  '"f2"'.
			  all }.
		  {
			  'minimum'.
			  '1'.
			  '2.5'.
			  all }.
		  {
			  'maximum'.
			  '9'.
			  '10'.
			  all }.
		  {
			  'exclusiveMinimum'.
			  'true'.
			  'false'.
			  #( #v30 #v2 ) }.
		  {
			  'exclusiveMaximum'.
			  'true'.
			  'false'.
			  #( #v30 #v2 ) }.
		  {
			  'multipleOf'.
			  '2'.
			  '3'.
			  all }.
		  {
			  'minLength'.
			  '1'.
			  '2'.
			  all }.
		  {
			  'maxLength'.
			  '5'.
			  '6'.
			  all }.
		  {
			  'pattern'.
			  '"^a"'.
			  '"^b"'.
			  all }.
		  {
			  'minItems'.
			  '1'.
			  '2'.
			  all }.
		  {
			  'maxItems'.
			  '3'.
			  '4'.
			  all }.
		  {
			  'minProperties'.
			  '1'.
			  '2'.
			  all }.
		  {
			  'maxProperties'.
			  '4'.
			  '5'.
			  all }.
		  {
			  'required'.
			  '["a"]'.
			  '["b"]'.
			  all }.
		  {
			  'properties'.
			  '{"a":{"type":"string"}}'.
			  '{"b":{"type":"integer"}}'.
			  all }.
		  {
			  'items'.
			  '{"type":"string"}'.
			  '{"type":"integer"}'.
			  all }.
		  {
			  'additionalProperties'.
			  'false'.
			  'true'.
			  all }.
		  {
			  'allOf'.
			  '[{"type":"string"}]'.
			  '[{"type":"integer"}]'.
			  all }.
		  {
			  'oneOf'.
			  '[{"type":"string"}]'.
			  '[{"type":"integer"}]'.
			  #( #v30 #v31 ) }.
		  {
			  'not'.
			  '{"type":"string"}'.
			  '{"type":"integer"}'.
			  #( #v30 #v31 ) }.
		  {
			  'discriminator'.
			  '{"propertyName":"a"}'.
			  '{"propertyName":"b"}'.
			  #( #v30 #v31 ) }.
		  {
			  'discriminator'.
			  '"a"'.
			  '"b"'.
			  #( #v2 ) }.
		  {
			  'xml'.
			  '{"name":"n1"}'.
			  '{"name":"n2"}'.
			  all }.
		  {
			  'externalDocs'.
			  '{"url":"u1"}'.
			  '{"url":"u2"}'.
			  all }.
		  {
			  'x-a'.
			  '1'.
			  '2'.
			  all } }
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> valueCheckOf: aJsonString [
	"The check that ran over the real import of the document, with its comparisons kept"

	^ self valueCheckOf: aJsonString model: (self modelOf: aJsonString)
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> valueCheckOf: aJsonString model: aModel [

	| check |
	check := FamixOpenApiValueCheck new.
	check keepComparisons.
	check checkInventory: (self inventoryOf: aJsonString) model: aModel.
	^ check
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> valueGapsOf: aJsonString after: aBlock [
	"The gaps of the value check of the real import mutated by aBlock (given the model)"

	| model |
	model := self modelOf: aJsonString.
	aBlock value: model.
	^ (self valueCheckOf: aJsonString model: model) report gaps
]

{ #category : 'checking' }
FamixOpenApiValueTestCase >> valueReportOf: aJsonString [
	"The report of the value check of the real import (1:1) of the document"

	^ FamixOpenApiValueCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: (self modelOf: aJsonString)
]
