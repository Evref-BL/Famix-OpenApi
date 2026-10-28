"
Behaviour tests of the import of paths, operations, parameters, request bodies, responses, headers, links, callbacks, webhooks, the reusable sections of the components and the security (step B). Small fixtures, one behaviour per test. Convention: canonicalPointer is the position of the SOURCE node the entity comes from.
"
Class {
	#name : 'FamixOpenApiOperationsImportTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> allSectionsJson [
	"One entry in every reusable section of the components (OpenAPI 3.1, which has them all)."

	^ self jsonFrom:
		  '`components`:{`parameters`:{`P`:{`name`:`p`,`in`:`query`}},`responses`:{`R`:{`description`:`r`}},`requestBodies`:{`B`:{`content`:{`text/plain`:{}}}},`headers`:{`H`:{`schema`:{`type`:`string`}}},`examples`:{`E`:{`value`:1}},`links`:{`L`:{`operationId`:`x`}},`callbacks`:{`C`:{`{$u}`:{`post`:{`operationId`:`cb`}}}},`securitySchemes`:{`S`:{`type`:`http`,`scheme`:`bearer`}},`pathItems`:{`I`:{`get`:{`operationId`:`ig`}}}}'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> assertSection: aSelector holdsKey: aKey [
	"The section aSelector of the components holds exactly one entity, named aKey and positioned at #/components/<section>/<aKey>."

	| section entity |
	section := (self componentsIn:
		            (self importOpenApi31: self allSectionsJson)) perform:
		           aSelector.
	self assert: section size equals: 1.
	entity := section anyOne.
	self assert: entity name equals: aKey.
	self
		assert: entity canonicalPointer
		equals: '#/components/' , aSelector , '/' , aKey
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> callbackJson [

	^ self jsonFrom:
		  '`paths`:{`/subscribe`:{`post`:{`operationId`:`subscribe`,`callbacks`:{`onEvent`:{`{$request.body#/url}`:{`post`:{`operationId`:`notify`}}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiOperationsImportTest >> diagnosticsWithCode: aCode [

	^ importer diagnostics withCode: aCode
]

{ #category : 'helpers' }
FamixOpenApiOperationsImportTest >> headerNamed: aName of: aResponse [

	^ aResponse headers
		  detect: [ :each | each name = aName ]
		  ifNone: [ self fail: 'No header ' , aName printString ]
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> importSchemes [

	^ self importOpenApi3:
		  '`paths`:{},' , (self jsonFrom: self schemesJson)
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> linkJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`getA`,`responses`:{`200`:{`description`:`ok`,`links`:{`next`:{`operationId`:`getB`,`description`:`go`}}}}}},`/b`:{`get`:{`operationId`:`getB`,`responses`:{`200`:{`description`:`ok`}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiOperationsImportTest >> okResponses [
	"A responses object with one response, to keep the fixtures short."

	^ '`responses`:{`200`:{`description`:`ok`}}'
]

{ #category : 'helpers' }
FamixOpenApiOperationsImportTest >> operationAt: aVerb of: aRelativePath in: aModel [
	"Answer the operation of the path aRelativePath declared for aVerb (lowercase)."

	^ (self pathNamed: aRelativePath in: aModel) operationForHttpMethod:
		  aVerb
]

{ #category : 'helpers' }
FamixOpenApiOperationsImportTest >> parameterNamed: aName of: anOwner [

	^ anOwner parameters
		  detect: [ :each | each name = aName ]
		  ifNone: [ self fail: 'No parameter ' , aName printString ]
]

{ #category : 'helpers' }
FamixOpenApiOperationsImportTest >> pathNamed: aRelativePath in: aModel [

	^ (self entitiesNamed: #Path in: aModel)
		  detect: [ :each | each relativePath = aRelativePath ]
		  ifNone: [ self fail: 'No path ' , aRelativePath printString ]
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> schemesJson [
	"One scheme of every type, as a components section."

	^ '`components`:{`securitySchemes`:{`key`:{`type`:`apiKey`,`in`:`cookie`,`name`:`sid`,`description`:`k`},`bearer`:{`type`:`http`,`scheme`:`bearer`,`bearerFormat`:`JWT`},`basic`:{`type`:`http`,`scheme`:`basic`},`oauth`:{`type`:`oauth2`,`flows`:{`implicit`:{`authorizationUrl`:`https://a`,`scopes`:{`r`:`Read`}},`clientCredentials`:{`tokenUrl`:`https://t`,`refreshUrl`:`https://f`,`scopes`:{}}}},`oidc`:{`type`:`openIdConnect`,`openIdConnectUrl`:`https://o/.well-known`}}}'
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> securitySchemeNamed: aName in: aModel [

	^ (self componentsIn: aModel) securitySchemes
		  detect: [ :each | each name = aName ]
		  ifNone: [ self fail: 'No security scheme ' , aName printString ]
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> sharedHeaderJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`$ref`:`#/components/headers/Rate`}}}}}},`/b`:{`get`:{`operationId`:`opB`,`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`$ref`:`#/components/headers/Rate`}}}}}}},`components`:{`headers`:{`Rate`:{`schema`:{`type`:`integer`}}}}'
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testAbsentOperationSecurityIsNotDisabled [

	| operation |
	operation := self
		             operationWithId: 'op'
		             in:
		             (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`operationId`:`op`}}}').
	self assert: operation securityDisabled equals: false.
	self assert: operation securityRequirements isEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testAllEightVerbsAreOperationsOfTheirPath [
	"get put post delete options head patch trace: one operation each, httpMethod in lowercase, owned by the path."

	| model path |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{},`put`:{},`post`:{},`delete`:{},`options`:{},`head`:{},`patch`:{},`trace`:{}}}'.
	path := self pathNamed: '/a' in: model.
	self assert: path operations size equals: 8.
	self
		assert: (path operations collect: #httpMethod) asArray
		equals:
		#( 'get' 'put' 'post' 'delete' 'options' 'head' 'patch' 'trace' ).
	path operations do: [ :each | self assert: each path == path ]
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testApiKeySchemeKeepsParameterNameAndLocation [

	| scheme |
	scheme := self securitySchemeNamed: 'key' in: self importSchemes.
	self assert: scheme type equals: 'apiKey'.
	self assert: scheme parameterName equals: 'sid'.
	self assert: scheme inLocation equals: 'cookie'.
	self assert: scheme description equals: 'k'
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testBadOperationDoesNotStopTheImportOfTheFollowingOnes [
	"One malformed operation is reported; the other operations and paths are still imported."

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:`oops`,`post`:{`operationId`:`goodPost`}},`/b`:{`get`:{`operationId`:`goodGet`}}}'.
	self assert: (self diagnosticsWithCode: #wrongNodeType) notEmpty.
	self
		assert: (self entitiesNamed: #Operation in: model) size
		equals: 2.
	self assert: (self operationWithId: 'goodPost' in: model) isNotNil.
	self assert: (self operationWithId: 'goodGet' in: model) isNotNil
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testCallbackIsNamedByItsKeyAndOwnsExpressionPathItems [

	| model callback path |
	model := self importOpenApi3: self callbackJson.
	callback := (self operationWithId: 'subscribe' in: model) callbacks
		            anyOne.
	self assert: callback name equals: 'onEvent'.
	self assert: callback pathItems size equals: 1.
	path := callback pathItems anyOne.
	self assert: path relativePath equals: '{$request.body#/url}'.
	self assert: path operations size equals: 1.
	self assert: path operations anyOne operationId equals: 'notify'.
	self assert: path operations anyOne httpMethod equals: 'post'
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testCallbackPathItemsAreNotPathsOfTheDocument [

	| model |
	model := self importOpenApi3: self callbackJson.
	self assert: (self openApiIn: model) paths size equals: 1
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testClonedResponseCopiesTheMediaTypesOfTheComponentIntoOwnEntities [

	| model component clone |
	model := self importOpenApi3: self twoOperationsSharingAResponseJson.
	component := (self componentsIn: model) responses anyOne.
	clone := self
		         responseOf: (self operationWithId: 'opA' in: model)
		         code: '404'.
	self assert: clone content size equals: component content size.
	self assert: (self mediaTypeNamed: 'text/plain' of: clone)
		~~ (self mediaTypeNamed: 'text/plain' of: component).
	self assert: (self mediaTypeNamed: 'text/plain' of: clone) schema
		== (self mediaTypeNamed: 'text/plain' of: component) schema
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testClonedResponseKeepsTheComponentRefAndItsOwnPointer [

	| model clone |
	model := self importOpenApi3: self twoOperationsSharingAResponseJson.
	clone := self
		         responseOf: (self operationWithId: 'opA' in: model)
		         code: '404'.
	self assert: clone ref equals: '#/components/responses/NotFound'.
	self
		assert: clone canonicalPointer
		equals: '#/paths/~1a/post/responses/404'.
	self assert: clone description equals: 'nf'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentCallbackAndPathItemOperationsAreImported [
	"The operations declared inside reusable callbacks and path items exist in the model."

	| model |
	model := self importOpenApi31: self allSectionsJson.
	self
		assert: (self operationWithId: 'cb' in: model) httpMethod
		equals: 'post'.
	self
		assert: (self operationWithId: 'ig' in: model) httpMethod
		equals: 'get'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentCallbackIsNamedByItsKey [

	self assertSection: #callbacks holdsKey: 'C'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentExampleIsNamedByItsKey [

	self assertSection: #examples holdsKey: 'E'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentExampleKeepsItsValueAsJsonText [

	| example |
	example := (self componentsIn:
		            (self importOpenApi31: self allSectionsJson)) examples
		           anyOne.
	self assert: (self parsedJson: example value) equals: 1
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentHeaderIsNamedByItsKey [

	self assertSection: #headers holdsKey: 'H'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentHeaderKeepsItsSchema [

	self
		assert:
			(self componentsIn: (self importOpenApi31: self allSectionsJson))
				headers anyOne schema types asArray
		equals: #( 'string' )
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentLinkIsNamedByItsKey [

	self assertSection: #links holdsKey: 'L'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentParameterKeepsItsOwnNameAndIsPositionedAtItsKey [
	"Unlike the other sections, a Parameter name is the HTTP parameter name (it takes part in the override rule of effectiveParameters), so the component key P is only visible in the canonicalPointer."

	| parameter |
	parameter := (self componentsIn:
		              (self importOpenApi31: self allSectionsJson))
		             parameters anyOne.
	self assert: parameter name equals: 'p'.
	self
		assert: parameter canonicalPointer
		equals: '#/components/parameters/P'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentPathItemIsNamedByItsKey [

	self assertSection: #pathItems holdsKey: 'I'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentRequestBodyIsNamedByItsKey [

	self assertSection: #requestBodies holdsKey: 'B'
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testComponentResponseHasNoStatusCodeAndNoOperation [

	| component |
	component := (self componentsIn:
		              (self importOpenApi3:
			               self twoOperationsSharingAResponseJson)) responses
		             anyOne.
	self assert: component statusCode isNil.
	self assert: component operation isNil.
	self assert: component ref isNil.
	self
		assert: component canonicalPointer
		equals: '#/components/responses/NotFound'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentResponseIsNamedByItsKey [

	self assertSection: #responses holdsKey: 'R'
]

{ #category : 'tests - components sections (step B)' }
FamixOpenApiOperationsImportTest >> testComponentSecuritySchemeIsNamedByItsKey [

	self assertSection: #securitySchemes holdsKey: 'S'
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testDistinctOperationIdsAreNotReportedAsDuplicates [

	self importOpenApi3:
		'`paths`:{`/a`:{`get`:{`operationId`:`one`}},`/b`:{`get`:{`operationId`:`two`}}}'.
	self assert:
		(self diagnosticsWithCode: #operationIdDuplicate) isEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testDuplicateOperationIdKeepsBothOperations [

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`same`}},`/b`:{`get`:{`operationId`:`same`}}}'.
	self
		assert: (self entitiesNamed: #Operation in: model) size
		equals: 2.
	self
		assert:
			((self entitiesNamed: #Operation in: model) collect:
				 #canonicalPointer) asSet
		equals: #( '#/paths/~1a/get' '#/paths/~1b/get' ) asSet
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testDuplicateOperationIdListsTheTwoPointers [
	"#operationIdDuplicate names every pointer that declares the id."

	| messages |
	self importOpenApi3:
		'`paths`:{`/a`:{`get`:{`operationId`:`same`}},`/b`:{`post`:{`operationId`:`same`}}}'.
	messages := (self diagnosticsWithCode: #operationIdDuplicate)
		            collect: [ :each |
		            each message , ' ' , each pointer asString ].
	self assert: messages notEmpty.
	self assert: (messages anySatisfy: [ :each |
			 each includesSubstring: '#/paths/~1a/get' ]).
	self assert: (messages anySatisfy: [ :each |
			 each includesSubstring: '#/paths/~1b/post' ])
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testEffectiveSecurityOfADisabledOperationIsEmpty [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`security`:[{`a`:[]}],`paths`:{`/a`:{`get`:{`operationId`:`op`,`security`:[]}}},'
			              , self twoSchemesJson).
	self assert: operation effectiveSecurity isEmpty
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testEffectiveSecurityOfAnOperationWithItsOwnSecurityIsItsOwn [

	| model operation |
	model := self importOpenApi3:
		         '`security`:[{`a`:[]}],`paths`:{`/a`:{`get`:{`operationId`:`op`,`security`:[{`b`:[]}]}}},'
		         , self twoSchemesJson.
	operation := self operationWithId: 'op' in: model.
	self
		assert: operation effectiveSecurity asArray
		equals: operation securityRequirements asArray.
	self assert: operation effectiveSecurity size equals: 1.
	self
		assert: operation effectiveSecurity anyOne items anyOne scheme name
		equals: 'b'
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testEffectiveSecurityOfAnOperationWithoutSecurityIsTheDocumentOne [

	| model operation |
	model := self importOpenApi3:
		         '`security`:[{`a`:[]}],`paths`:{`/a`:{`get`:{`operationId`:`op`}}},'
		         , self twoSchemesJson.
	operation := self operationWithId: 'op' in: model.
	self
		assert: operation effectiveSecurity asArray
		equals: (self openApiIn: model) securityRequirements asArray
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testEmptyOperationSecurityDisablesSecurityAndCreatesNoRequirement [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`security`:[{`a`:[]}],`paths`:{`/a`:{`get`:{`operationId`:`op`,`security`:[]}}},'
			              , self twoSchemesJson).
	self assert: operation securityDisabled equals: true.
	self assert: operation securityRequirements isEmpty
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testEmptySecurityRequirementObjectIsARequirementWithNoItems [
	"{} means anonymous access: it is an alternative of its own, with no item."

	| model |
	model := self importOpenApi3:
		         '`security`:[{},{`a`:[]}],`paths`:{},'
		         , self twoSchemesJson.
	self
		assert: (self openApiIn: model) securityRequirements size
		equals: 2.
	self assert:
		(self openApiIn: model) securityRequirements first items isEmpty.
	self
		assert: (self openApiIn: model) securityRequirements last items size
		equals: 1
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testEncodingKeepsPropertyNameContentTypeAndHeaders [

	| encoding |
	encoding := (self entitiesNamed: #Encoding in: (self importOpenApi3:
			              '`paths`:{`/a`:{`post`:{`requestBody`:{`content`:{`multipart/form-data`:{`schema`:{`type`:`object`},`encoding`:{`icon`:{`contentType`:`image/png`,`style`:`form`,`explode`:true,`allowReserved`:true,`headers`:{`X-Rate`:{`schema`:{`type`:`integer`}}}}}}}}}}}'))
		            anyOne.
	self assert: encoding propertyName equals: 'icon'.
	self assert: encoding contentType equals: 'image/png'.
	self assert: encoding style equals: 'form'.
	self assert: encoding explode equals: true.
	self assert: encoding allowReserved equals: true.
	self assert: encoding headers size equals: 1.
	self assert: encoding headers anyOne name equals: 'X-Rate'
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testEntityWithoutExtensionsHasNone [

	self assert: (self
			 operationWithId: 'op'
			 in:
			 (self importOpenApi3:
				  '`paths`:{`/a`:{`get`:{`operationId`:`op`}}}')) extensions isNil
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testExamplesMapOfAParameterIsOneExamplePerKey [

	| parameter |
	parameter := (self
		              entitiesNamed: #Parameter
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`get`:{`parameters`:[{`name`:`n`,`in`:`query`,`examples`:{`one`:{`summary`:`first`,`value`:1},`two`:{`value`:2}}}]}}}'))
		             anyOne.
	self
		assert: (parameter examples collect: #name) asArray
		equals: #( 'one' 'two' ).
	self assert: parameter examples first summary equals: 'first'.
	self
		assert: (self parsedJson: parameter examples last value)
		equals: 2
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testExtensionKeywordIsNotReportedAsUnknown [

	self importOpenApi3:
		'`paths`:{`/a`:{`x-path`:1,`get`:{`operationId`:`op`,`x-op`:1}}}'.
	self assert: (self diagnosticsWithCode: #unknownKeyword) isEmpty
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testExtensionsOfOperationParameterAndResponseAreJsonText [
	"x-* members are kept as JSON text on the entity (key included)."

	| model operation |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`op`,`x-internal`:{`a`:1},`parameters`:[{`name`:`p`,`in`:`query`,`x-p`:2}],`responses`:{`200`:{`description`:`ok`,`x-r`:[1,2]}}}}}'.
	operation := self operationWithId: 'op' in: model.
	self
		assert: ((self parsedJson: operation extensions) at: 'x-internal')
		equals: (Dictionary new
				 at: 'a' put: 1;
				 yourself).
	self
		assert:
		((self parsedJson: operation parameters anyOne extensions) at: 'x-p')
		equals: 2.
	self
		assert:
			((self parsedJson:
				  (self responseOf: operation code: '200') extensions) at: 'x-r')
				asArray
		equals: #( 1 2 )
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testHttpBasicSchemeKeepsScheme [

	| scheme |
	scheme := self securitySchemeNamed: 'basic' in: self importSchemes.
	self assert: scheme type equals: 'http'.
	self assert: scheme scheme equals: 'basic'.
	self assert: scheme bearerFormat isNil
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testHttpBearerSchemeKeepsSchemeAndBearerFormat [

	| scheme |
	scheme := self securitySchemeNamed: 'bearer' in: self importSchemes.
	self assert: scheme type equals: 'http'.
	self assert: scheme scheme equals: 'bearer'.
	self assert: scheme bearerFormat equals: 'JWT'
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testInlineOperationParameterPointerIsItsPosition [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`paths`:{`/pets`:{`get`:{`operationId`:`op`,`parameters`:[{`name`:`a`,`in`:`query`},{`name`:`b`,`in`:`query`}]}}}').
	self
		assert: operation parameters first canonicalPointer
		equals: '#/paths/~1pets/get/parameters/0'.
	self
		assert: operation parameters last canonicalPointer
		equals: '#/paths/~1pets/get/parameters/1'
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testInlinePathParameterPointerIsItsPosition [

	| path |
	path := self pathNamed: '/pets' in: (self importOpenApi3:
			         '`paths`:{`/pets`:{`parameters`:[{`name`:`a`,`in`:`header`}]}}').
	self
		assert: path parameters anyOne canonicalPointer
		equals: '#/paths/~1pets/parameters/0'
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testInlineRequestBodyKeepsItsAttributesAndPointer [

	| body |
	body := (self
		         operationAt: 'post'
		         of: '/pets'
		         in: (self importOpenApi3:
				          '`paths`:{`/pets`:{`post`:{`requestBody`:{`description`:`d`,`required`:true,`content`:{`application/json`:{`schema`:{`type`:`object`}}}}}}}'))
		        requestBody.
	self assert: body notNil.
	self assert: body description equals: 'd'.
	self assert: body required equals: true.
	self
		assert: body canonicalPointer
		equals: '#/paths/~1pets/post/requestBody'.
	self assert: body content size equals: 1
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testInlineResponseHeaderIsNamedByItsKey [

	| response header |
	response := (self entitiesNamed: #Response in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`description`:`r`,`required`:true,`schema`:{`type`:`integer`}}}}}}}}'))
		            anyOne.
	header := self headerNamed: 'X-Rate' of: response.
	self assert: header description equals: 'r'.
	self assert: header required equals: true.
	self assert: header schema types asArray equals: #( 'integer' ).
	self assert: header usedByResponses asArray equals: { response }.
	self
		assert: header canonicalPointer
		equals: '#/paths/~1a/get/responses/200/headers/X-Rate'
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testLinkIsNamedByItsKeyAndResolvesItsOperationId [

	| model link target |
	model := self importOpenApi3: self linkJson.
	target := self operationWithId: 'getB' in: model.
	link := (self entitiesNamed: #Link in: model) anyOne.
	self assert: link name equals: 'next'.
	self assert: link operationId equals: 'getB'.
	self assert: link operation == target.
	self assert: target usedByLinks asArray equals: { link }.
	self assert: link description equals: 'go'
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testLinkKeepsItsOperationRef [

	| link |
	link := (self entitiesNamed: #Link in: (self importOpenApi3:
			          '`paths`:{`/a`:{`get`:{`operationId`:`getA`,`responses`:{`200`:{`description`:`ok`,`links`:{`byRef`:{`operationRef`:`#/paths/~1a/get`}}}}}}}'))
		        anyOne.
	self assert: link operationRef equals: '#/paths/~1a/get'.
	self assert:
		(self diagnosticsWithCode: #linkOperationUnresolved) isEmpty
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testLinkPointsToAnOperationDeclaredAfterIt [
	"The operationId is resolved after all the operations exist, whatever their order."

	| model |
	model := self importOpenApi3: self linkJson.
	self assert:
		(self diagnosticsWithCode: #linkOperationUnresolved) isEmpty.
	self assert:
		(self entitiesNamed: #Link in: model) anyOne operation notNil
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testLinkWithUnknownOperationIdIsReportedAndHasNoOperation [

	| link |
	link := (self entitiesNamed: #Link in: (self importOpenApi3:
			          '`paths`:{`/a`:{`get`:{`operationId`:`getA`,`responses`:{`200`:{`description`:`ok`,`links`:{`bad`:{`operationId`:`nowhere`}}}}}}}'))
		        anyOne.
	self assert: link operation isNil.
	self assert: link operationId equals: 'nowhere'.
	self
		assert: (self diagnosticsWithCode: #linkOperationUnresolved) size
		equals: 1.
	self assert:
		(self diagnosticsWithCode: #linkOperationUnresolved) first isWarning
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testMediaTypeExamplesMapIsOneExamplePerKey [

	| mediaType |
	mediaType := (self
		              entitiesNamed: #MediaType
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`post`:{`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`object`},`examples`:{`cat`:{`value`:1},`dog`:{`value`:2}}}}}}}}'))
		             anyOne.
	self
		assert: (mediaType examples collect: #name) asArray
		equals: #( 'cat' 'dog' )
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testMediaTypeOwnsItsSchemaAndKnowsItsOwner [

	| body mediaType |
	body := (self operationAt: 'post' of: '/a' in: (self importOpenApi3:
			          '`paths`:{`/a`:{`post`:{`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`string`}},`text/plain`:{`schema`:{`type`:`integer`}}}}}}}'))
		        requestBody.
	self
		assert: (body content collect: #mediaType) asArray
		equals: #( 'application/json' 'text/plain' ).
	mediaType := self mediaTypeNamed: 'application/json' of: body.
	self assert: mediaType contentOwner == body.
	self assert: mediaType schema types asArray equals: #( 'string' )
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testMediaTypeSingularExampleIsAnExampleNamedExample [

	| mediaType |
	mediaType := (self
		              entitiesNamed: #MediaType
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`post`:{`requestBody`:{`content`:{`application/json`:{`example`:7}}}}}}'))
		             anyOne.
	self assert: mediaType examples size equals: 1.
	self assert: mediaType examples anyOne name equals: 'example'
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testMissingOperationIdIsReportedAsWarningAtTheOperation [

	| diagnostic |
	self importOpenApi3: '`paths`:{`/pets`:{`get`:{}}}'.
	self
		assert: (self diagnosticsWithCode: #operationIdMissing) size
		equals: 1.
	diagnostic := (self diagnosticsWithCode: #operationIdMissing) first.
	self assert: diagnostic isWarning.
	self assert: diagnostic pointer equals: '#/paths/~1pets/get'
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testOAuth2FlowKeepsItsUrlsAndScopes [

	| scheme implicit credentials |
	scheme := self securitySchemeNamed: 'oauth' in: self importSchemes.
	implicit := scheme flows detect: [ :each |
		            each flowType = 'implicit' ].
	credentials := scheme flows detect: [ :each |
		               each flowType = 'clientCredentials' ].
	self assert: implicit authorizationUrl equals: 'https://a'.
	self
		assert: (implicit scopes collect: #name) asArray
		equals: #( 'r' ).
	self assert: credentials tokenUrl equals: 'https://t'.
	self assert: credentials refreshUrl equals: 'https://f'.
	self assert: credentials scopes isEmpty
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testOAuth2SchemeHasOneFlowPerDeclaredFlow [

	| scheme |
	scheme := self securitySchemeNamed: 'oauth' in: self importSchemes.
	self assert: scheme type equals: 'oauth2'.
	self
		assert: (scheme flows collect: #flowType) asArray
		equals: #( 'implicit' 'clientCredentials' ).
	scheme flows do: [ :each |
		self assert: each securityScheme == scheme ]
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testOpenIdConnectSchemeKeepsItsUrl [

	| scheme |
	scheme := self securitySchemeNamed: 'oidc' in: self importSchemes.
	self assert: scheme type equals: 'openIdConnect'.
	self assert: scheme openIdConnectUrl equals: 'https://o/.well-known'
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testOperationKeepsItsDescriptiveAttributes [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`operationId`:`op`,`summary`:`sum`,`description`:`desc`,`deprecated`:true,`tags`:[`t1`,`t2`]}}}').
	self assert: operation summary equals: 'sum'.
	self assert: operation description equals: 'desc'.
	self assert: operation deprecated equals: true.
	self assert: operation tagNames asArray equals: #( 't1' 't2' ).
	self assert: operation name equals: 'op'
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testOperationLevelServersAreImported [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`operationId`:`op`,`servers`:[{`url`:`https://o1`},{`url`:`https://o2`}]}}}').
	self
		assert: (operation servers collect: #url) asArray
		equals: #( 'https://o1' 'https://o2' ).
	self assert: operation servers first operation == operation
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testOperationParameterOverridesPathParameterWithSameNameAndLocation [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`paths`:{`/a`:{`parameters`:[{`name`:`p`,`in`:`query`},{`name`:`other`,`in`:`query`}],`get`:{`operationId`:`op`,`parameters`:[{`name`:`p`,`in`:`query`,`required`:true}]}}}').
	self
		assert: (operation effectiveParameters collect: #name) asArray
		equals: #( 'p' 'other' ).
	self
		assert: operation effectiveParameters first required
		equals: true
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testOperationResponsesAreImportedInDocumentOrder [

	| operation |
	operation := (self
		              entitiesNamed: #Operation
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`get`:{`responses`:{`404`:{`description`:`nf`},`200`:{`description`:`ok`},`default`:{`description`:`d`}}}}}'))
		             anyOne.
	self
		assert: (operation responses collect: #statusCode) asArray
		equals: #( '404' '200' 'default' )
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testOperationSecurityRequirementsAreOwnedByTheOperation [

	| model operation |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`op`,`security`:[{`a`:[`s`]}]}}},'
		         , self twoSchemesJson.
	operation := self operationWithId: 'op' in: model.
	self assert: operation securityRequirements size equals: 1.
	self assert:
		operation securityRequirements anyOne operation == operation.
	self
		assert:
		operation securityRequirements anyOne items anyOne scopeNames
			asArray
		equals: #( 's' ).
	self assert: operation securityDisabled equals: false
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testOperationTagNamesAreKeptAndDeclaredTagsAreResolvedInOrder [
	"tagNames keeps every name as written; the derived tags answer the declared Tag entities, in the order of tagNames, skipping undeclared names."

	| model operation |
	model := self importOpenApi3:
		         '`tags`:[{`name`:`pets`},{`name`:`store`}],`paths`:{`/a`:{`get`:{`operationId`:`op`,`tags`:[`store`,`ghost`,`pets`]}}}'.
	operation := self operationWithId: 'op' in: model.
	self
		assert: operation tagNames asArray
		equals: #( 'store' 'ghost' 'pets' ).
	self
		assert: (operation tags collect: #name) asArray
		equals: #( 'store' 'pets' )
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testOperationThatIsAStringIsReportedWithoutRaising [

	| model |
	self
		shouldnt: [
		model := self importOpenApi3: '`paths`:{`/a`:{`get`:`oops`}}' ]
		raise: Error.
	self assert: (self diagnosticsWithCode: #wrongNodeType) notEmpty.
	self assert: (self entitiesNamed: #Operation in: model) isEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testOperationWithAnOperationIdIsNotReportedAsMissing [

	self importOpenApi3: '`paths`:{`/pets`:{`get`:{`operationId`:`x`}}}'.
	self assert: (self diagnosticsWithCode: #operationIdMissing) isEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testOperationWithoutOperationIdIsNamedAfterVerbAndPath [

	| operation |
	operation := (self
		              entitiesNamed: #Operation
		              in:
		              (self importOpenApi3:
			               '`paths`:{`/pets/{petId}`:{`get`:{}}}')) anyOne.
	self assert: operation name equals: 'get_pets_petId'.
	self assert: operation operationId isNil
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testOperationWithoutRequestBodyHasNone [

	self assert: (self
			 operationAt: 'get'
			 of: '/a'
			 in: (self importOpenApi3: '`paths`:{`/a`:{`get`:{}}}'))
			requestBody isNil
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testOperationWithoutTagsHasNoTagNames [

	self assert: (self
			 operationWithId: 'op'
			 in:
			 (self importOpenApi3:
				  '`paths`:{`/a`:{`get`:{`operationId`:`op`}}}')) tagNames isEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testOperationsOfAPathKeepTheDocumentOrder [

	| path |
	path := self pathNamed: '/a' in: (self importOpenApi3:
			         '`paths`:{`/a`:{`post`:{},`get`:{},`delete`:{}}}').
	self
		assert: (path operations collect: #httpMethod) asArray
		equals: #( 'post' 'get' 'delete' )
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testOperationsOfTheDocumentAreTheOperationsOfItsPaths [

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{},`post`:{}},`/b`:{`get`:{}}}'.
	self assert: (self openApiIn: model) operations size equals: 3.
	self
		assert: (self entitiesNamed: #Operation in: model) size
		equals: 3
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testParameterContentIsImportedAsMediaTypes [
	"A parameter with content (instead of schema) owns media types."

	| parameter mediaType |
	parameter := (self
		              entitiesNamed: #Parameter
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`get`:{`parameters`:[{`name`:`filter`,`in`:`query`,`content`:{`application/json`:{`schema`:{`type`:`object`}}}}]}}}'))
		             anyOne.
	self assert: parameter schema isNil.
	self assert: parameter content size equals: 1.
	mediaType := self mediaTypeNamed: 'application/json' of: parameter.
	self assert: mediaType schema notNil.
	self assert: mediaType schema types asArray equals: #( 'object' )
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testParameterEntryThatIsNotAnObjectDoesNotStopTheOthers [

	| model |
	self
		shouldnt: [
			model := self importOpenApi3:
				         '`paths`:{`/a`:{`get`:{`operationId`:`op`,`parameters`:[7,{`name`:`ok`,`in`:`query`}]}}}' ]
		raise: Error.
	self assert: (self diagnosticsWithCode: #wrongNodeType) notEmpty.
	self
		assert:
			((self operationWithId: 'op' in: model) parameters collect: #name)
				asArray
		equals: #( 'ok' )
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testParameterKeepsItsAttributes [

	| parameter |
	parameter := (self
		              entitiesNamed: #Parameter
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`get`:{`parameters`:[{`name`:`tags`,`in`:`query`,`description`:`d`,`required`:true,`deprecated`:true,`allowEmptyValue`:true,`style`:`form`,`explode`:false,`allowReserved`:true,`schema`:{`type`:`string`}}]}}}'))
		             anyOne.
	self assert: parameter name equals: 'tags'.
	self assert: parameter location equals: 'query'.
	self assert: parameter description equals: 'd'.
	self assert: parameter required equals: true.
	self assert: parameter deprecated equals: true.
	self assert: parameter allowEmptyValue equals: true.
	self assert: parameter style equals: 'form'.
	self assert: parameter explode equals: false.
	self assert: parameter allowReserved equals: true.
	self assert: parameter schema types asArray equals: #( 'string' )
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testParametersKeepTheDocumentOrder [

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`operationId`:`op`,`parameters`:[{`name`:`z`,`in`:`query`},{`name`:`a`,`in`:`query`},{`name`:`m`,`in`:`header`}]}}}').
	self
		assert: (operation parameters collect: #name) asArray
		equals: #( 'z' 'a' 'm' )
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testParametersThatAreNotAnArrayAreReportedWithoutRaising [

	| model |
	self
		shouldnt: [
			model := self importOpenApi3:
				         '`paths`:{`/a`:{`get`:{`operationId`:`op`,`parameters`:{`name`:`p`}}}}' ]
		raise: Error.
	self assert: (self diagnosticsWithCode: #wrongNodeType) notEmpty.
	self assert:
		(self operationWithId: 'op' in: model) parameters isEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testPathBelongsToTheDocument [

	| model |
	model := self importOpenApi3: '`paths`:{`/a`:{}}'.
	self assert:
		(self pathNamed: '/a' in: model) openApi == (self openApiIn: model)
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testPathItemRefCloneIsDistinctFromTheComponentOperation [

	| model component site |
	model := self importOpenApi31:
		         '`paths`:{`/b`:{`$ref`:`#/components/pathItems/Common`}},`components`:{`pathItems`:{`Common`:{`get`:{`summary`:`shared`}}}}'.
	component := (self componentsIn: model) pathItems anyOne.
	site := self pathNamed: '/b' in: model.
	self assert: component operations size equals: 1.
	self assert: component operations anyOne path == component.
	self assert: component operations anyOne ~~ site operations anyOne.
	self assert: component ref isNil
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testPathItemRefIsClonedIntoTheSitePath [
	"Clone strategy: a path item that is only a $ref gets its own operations, owned by the site Path, which keeps the ref; the component keeps its own."

	| model component site |
	model := self importOpenApi31:
		         '`paths`:{`/b`:{`$ref`:`#/components/pathItems/Common`}},`components`:{`pathItems`:{`Common`:{`get`:{`summary`:`shared`}}}}'.
	component := (self componentsIn: model) pathItems anyOne.
	site := self pathNamed: '/b' in: model.
	self assert: site ~~ component.
	self assert: site ref equals: '#/components/pathItems/Common'.
	self assert: site operations size equals: 1.
	self assert: site operations anyOne path == site.
	self assert: site operations anyOne summary equals: 'shared'
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testPathItemSharedByTwoCallbacksIsUsedByBoth [

	| model path |
	model := self importOpenApi31:
		         '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`callbacks`:{`e`:{`{$u}`:{`$ref`:`#/components/pathItems/Common`}}}}},`/b`:{`post`:{`operationId`:`opB`,`callbacks`:{`e`:{`{$u}`:{`$ref`:`#/components/pathItems/Common`}}}}}},`components`:{`pathItems`:{`Common`:{`get`:{`operationId`:`cg`}}}}'.
	path := (self componentsIn: model) pathItems anyOne.
	self assert: path usedByCallbacks size equals: 2.
	self assert: (self operationWithId: 'cg' in: model) path == path
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testPathItemThatIsANumberIsReportedWithoutRaising [

	| model |
	self
		shouldnt: [ model := self importOpenApi3: '`paths`:{`/a`:5}' ]
		raise: Error.
	self assert: (self diagnosticsWithCode: #wrongNodeType) notEmpty
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testPathKeepsItsRelativePathAndNameAndPointer [

	| path |
	path := self pathNamed: '/pets/{petId}' in: (self importOpenApi3:
			         '`paths`:{`/pets/{petId}`:{`summary`:`s`,`description`:`d`}}').
	self assert: path name equals: '/pets/{petId}'.
	self assert: path summary equals: 's'.
	self assert: path description equals: 'd'.
	self assert: (path canonicalPointer beginsWith: '#/paths/~1pets~1')
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testPathLevelAndOperationLevelParametersAreBothKept [
	"The path owns its parameters, the operation owns its own; effectiveParameters answers both."

	| model path operation |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`parameters`:[{`name`:`p`,`in`:`header`}],`get`:{`operationId`:`op`,`parameters`:[{`name`:`q`,`in`:`query`}]}}}'.
	path := self pathNamed: '/a' in: model.
	operation := self operationWithId: 'op' in: model.
	self
		assert: (path parameters collect: #name) asArray
		equals: #( 'p' ).
	self
		assert: (operation parameters collect: #name) asArray
		equals: #( 'q' ).
	self
		assert: (operation effectiveParameters collect: #name) asArray
		equals: #( 'q' 'p' )
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testPathLevelServersAreImported [

	| path |
	path := self pathNamed: '/a' in: (self importOpenApi3:
			         '`paths`:{`/a`:{`servers`:[{`url`:`https://p.example.com`,`description`:`pd`}]}}').
	self assert: path servers size equals: 1.
	self assert: path servers anyOne url equals: 'https://p.example.com'.
	self assert: path servers anyOne description equals: 'pd'.
	self assert: path servers anyOne path == path
]

{ #category : 'tests - paths and operations (step B)' }
FamixOpenApiOperationsImportTest >> testPathsKeepTheDocumentOrder [
	"The paths of the document are listed in the order they are written (not sorted, not hashed)."

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/b`:{},`/a`:{},`/c`:{},`/a2`:{}}'.
	self
		assert:
		((self openApiIn: model) paths collect: #relativePath) asArray
		equals: #( '/b' '/a' '/c' '/a2' )
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testReferencedResponseIsClonedPerOperationIntoDistinctEntities [
	"Two operations using the same component response own two distinct clones, neither being the component."

	| model component cloneA cloneB |
	model := self importOpenApi3: self twoOperationsSharingAResponseJson.
	component := (self componentsIn: model) responses anyOne.
	cloneA := self
		          responseOf: (self operationWithId: 'opA' in: model)
		          code: '404'.
	cloneB := self
		          responseOf: (self operationWithId: 'opB' in: model)
		          code: '404'.
	self assert: cloneA ~~ cloneB.
	self assert: cloneA ~~ component.
	self assert: cloneB ~~ component.
	self assert: (self entitiesNamed: #Response in: model) size equals: 3
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testRequirementWithTwoSchemesIsOneRequirementWithTwoItemsAndScopes [
	"{a: [], b: [scope]} is ONE requirement of TWO items (a logical AND): each item has its scheme resolved and its scope names."

	| model requirement itemA itemB |
	model := self importOpenApi3:
		         '`security`:[{`a`:[],`b`:[`s1`,`s2`]}],`paths`:{},'
		         , self twoSchemesJson.
	requirement := (self openApiIn: model) securityRequirements anyOne.
	self
		assert: (self openApiIn: model) securityRequirements size
		equals: 1.
	self assert: requirement items size equals: 2.
	itemA := requirement items detect: [ :each | each scheme name = 'a' ].
	itemB := requirement items detect: [ :each | each scheme name = 'b' ].
	self assert:
		itemA scheme == (self securitySchemeNamed: 'a' in: model).
	self assert: itemA scopeNames isEmpty.
	self assert: itemB scopeNames asArray equals: #( 's1' 's2' ).
	self
		assert: (self securitySchemeNamed: 'b' in: model)
				usedBySecurityRequirementItems asArray
		equals: { itemB }
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testResponseContentIsImportedAsMediaTypes [

	| response |
	response := (self entitiesNamed: #Response in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`array`}}}}}}}}'))
		            anyOne.
	self
		assert: (response content collect: #mediaType) asArray
		equals: #( 'application/json' ).
	self
		assert: response content anyOne schema types asArray
		equals: #( 'array' )
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testResponseKeepsItsDescriptionAndPointer [

	| response |
	response := (self entitiesNamed: #Response in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`responses`:{`200`:{`description`:`fine`}}}}}'))
		            anyOne.
	self assert: response description equals: 'fine'.
	self
		assert: response canonicalPointer
		equals: '#/paths/~1a/get/responses/200'
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testResponseWithoutHeadersHasNone [

	self assert: (self entitiesNamed: #Header in: (self importOpenApi3:
				  '`paths`:{`/a`:{`get`:{`responses`:{`200`:{`description`:`ok`}}}}}'))
			isEmpty
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testResponsesKeepTheirStatusCodeAndOperation [
	"A numeric code, the default response and a range all become responses of the operation, with the code as written."

	| operation |
	operation := self operationWithId: 'op' in: (self importOpenApi3:
			              '`paths`:{`/a`:{`get`:{`operationId`:`op`,`responses`:{`200`:{`description`:`ok`},`default`:{`description`:`d`},`2XX`:{`description`:`r`}}}}}').
	self
		assert: (operation responses collect: #statusCode) asArray
		equals: #( '200' 'default' '2XX' ).
	operation responses do: [ :each |
		self assert: each operation == operation ]
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testResponsesThatAreAnArrayAreReportedWithoutRaising [

	| model |
	self
		shouldnt: [
			model := self importOpenApi3:
				         '`paths`:{`/a`:{`get`:{`operationId`:`op`,`responses`:[1,2]}}}' ]
		raise: Error.
	self assert: (self diagnosticsWithCode: #wrongNodeType) notEmpty.
	self assert: (self operationWithId: 'op' in: model) responses isEmpty
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testRootSecurityIsOwnedByTheDocument [

	| model requirement |
	model := self importOpenApi3:
		         '`security`:[{`a`:[`s`]}],`paths`:{},'
		         , self twoSchemesJson.
	requirement := (self openApiIn: model) securityRequirements anyOne.
	self assert: requirement openApi == (self openApiIn: model).
	self assert: requirement operation isNil
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testSameParameterReferencedTwiceByAnOperationIsListedOnce [
	"Many-to-many links never hold duplicates."

	| model component |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`parameters`:[{`$ref`:`#/components/parameters/L`},{`$ref`:`#/components/parameters/L`}]}}},`components`:{`parameters`:{`L`:{`name`:`limit`,`in`:`query`}}}'.
	component := (self componentsIn: model) parameters anyOne.
	self assert: component usedByOperations size equals: 1.
	self
		assert: (self operationWithId: 'opA' in: model) parameters size
		equals: 1
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testSecurityRequirementPointerIsThePositionOfItsSourceNode [
	"canonicalPointer = the position of the source node: the requirement is the object at index n of the security array."

	| model |
	model := self importOpenApi3:
		         '`security`:[{`a`:[]},{`b`:[]}],`paths`:{`/a`:{`get`:{`operationId`:`op`,`security`:[{`a`:[]}]}}},'
		         , self twoSchemesJson.
	self
		assert: ((self openApiIn: model) securityRequirements collect:
				 #canonicalPointer) asArray
		equals: #( '#/security/0' '#/security/1' ).
	self
		assert:
			(self operationWithId: 'op' in: model) securityRequirements anyOne
				canonicalPointer
		equals: '#/paths/~1a/get/security/0'
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testSharedCallbackIsUsedByTwoOperations [

	| model callback |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`callbacks`:{`e`:{`$ref`:`#/components/callbacks/E`}}}},`/b`:{`post`:{`operationId`:`opB`,`callbacks`:{`e`:{`$ref`:`#/components/callbacks/E`}}}}},`components`:{`callbacks`:{`E`:{`{$request.body#/u}`:{`post`:{`operationId`:`n`}}}}}'.
	callback := (self componentsIn: model) callbacks anyOne.
	self assert: (self entitiesNamed: #Callback in: model) size equals: 1.
	self assert: callback usedByOperations size equals: 2.
	self assert:
		(self operationWithId: 'opA' in: model) callbacks anyOne == callback
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> testSharedHeaderIsUsedByTwoResponses [

	| model header |
	model := self importOpenApi3: self sharedHeaderJson.
	header := (self componentsIn: model) headers anyOne.
	self assert: (self entitiesNamed: #Header in: model) size equals: 1.
	self assert: header usedByResponses size equals: 2
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testSharedLinkIsUsedByTwoResponses [

	| model link |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`responses`:{`200`:{`description`:`ok`,`links`:{`n`:{`$ref`:`#/components/links/Next`}}}}}},`/b`:{`get`:{`operationId`:`opB`,`responses`:{`200`:{`description`:`ok`,`links`:{`n`:{`$ref`:`#/components/links/Next`}}}}}}},`components`:{`links`:{`Next`:{`operationId`:`opB`}}}'.
	link := (self componentsIn: model) links anyOne.
	self assert: (self entitiesNamed: #Link in: model) size equals: 1.
	self assert: link usedByResponses size equals: 2
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testSharedParameterIsOneEntityForTwoOperationsAndAPath [
	"A $ref parameter is the component entity itself, never a copy: it is used by two operations and one path, and listed once by each."

	| model component |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`parameters`:[{`$ref`:`#/components/parameters/L`}]}},`/b`:{`parameters`:[{`$ref`:`#/components/parameters/L`}],`get`:{`operationId`:`opB`,`parameters`:[{`$ref`:`#/components/parameters/L`}]}}},`components`:{`parameters`:{`L`:{`name`:`limit`,`in`:`query`}}}'.
	component := (self componentsIn: model) parameters anyOne.
	self
		assert: (self entitiesNamed: #Parameter in: model) size
		equals: 1.
	self assert: component usedByOperations size equals: 2.
	self assert: component usedByPaths size equals: 1.
	(Array with: 'opA' with: 'opB') do: [ :id |
		| operation |
		operation := self operationWithId: id in: model.
		self assert: operation parameters size equals: 1.
		self assert: operation parameters anyOne == component ].
	self assert:
		(self pathNamed: '/b' in: model) parameters anyOne == component
]

{ #category : 'tests - request bodies and media types (step B)' }
FamixOpenApiOperationsImportTest >> testSharedRequestBodyIsOneEntityUsedByTwoOperations [

	| model component |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`requestBody`:{`$ref`:`#/components/requestBodies/B`}}},`/b`:{`post`:{`operationId`:`opB`,`requestBody`:{`$ref`:`#/components/requestBodies/B`}}}},`components`:{`requestBodies`:{`B`:{`content`:{`text/plain`:{`schema`:{`type`:`string`}}}}}}'.
	component := (self componentsIn: model) requestBodies anyOne.
	self
		assert: (self entitiesNamed: #RequestBody in: model) size
		equals: 1.
	self assert: component usedByOperations size equals: 2.
	self assert:
		(self operationWithId: 'opA' in: model) requestBody == component.
	self assert:
		(self operationWithId: 'opB' in: model) requestBody == component
]

{ #category : 'tests - parameters (step B)' }
FamixOpenApiOperationsImportTest >> testSingularExampleOfAParameterIsAnExampleNamedExample [

	| parameter |
	parameter := (self
		              entitiesNamed: #Parameter
		              in: (self importOpenApi3:
				               '`paths`:{`/a`:{`get`:{`parameters`:[{`name`:`n`,`in`:`query`,`example`:5}]}}}'))
		             anyOne.
	self assert: parameter examples size equals: 1.
	self assert: parameter examples anyOne name equals: 'example'.
	self
		assert: (self parsedJson: parameter examples anyOne value)
		equals: 5
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testTwoSecurityAlternativesAreTwoRequirements [

	| model |
	model := self importOpenApi3:
		         '`security`:[{`a`:[]},{`b`:[]}],`paths`:{},'
		         , self twoSchemesJson.
	self
		assert: (self openApiIn: model) securityRequirements size
		equals: 2.
	(self openApiIn: model) securityRequirements do: [ :each |
		self assert: each items size equals: 1 ]
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testUnknownOperationKeywordIsReportedAsInfo [
	"The diagnostic is an info positioned at the unknown keyword itself."

	| diagnostic |
	self importOpenApi3:
		'`paths`:{`/a`:{`get`:{`operationId`:`op`,`foo`:1}}}'.
	self
		assert: (self diagnosticsWithCode: #unknownKeyword) size
		equals: 1.
	diagnostic := (self diagnosticsWithCode: #unknownKeyword) first.
	self assert: diagnostic isInfo.
	self assert: diagnostic pointer equals: '#/paths/~1a/get/foo'.
	self assert: (diagnostic message includesSubstring: 'foo')
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testUnknownParameterKeywordIsReportedAsInfo [

	self importOpenApi3:
		'`paths`:{`/a`:{`get`:{`operationId`:`op`,`parameters`:[{`name`:`p`,`in`:`query`,`bar`:1}]}}}'.
	self
		assert: (self diagnosticsWithCode: #unknownKeyword) size
		equals: 1.
	self
		assert: (self diagnosticsWithCode: #unknownKeyword) first pointer
		equals: '#/paths/~1a/get/parameters/0/bar'
]

{ #category : 'tests - tags servers path items extensions (step B)' }
FamixOpenApiOperationsImportTest >> testUnknownResponseKeywordIsReportedAsInfo [

	self importOpenApi3:
		'`paths`:{`/a`:{`get`:{`operationId`:`op`,`responses`:{`200`:{`description`:`ok`,`baz`:1}}}}}'.
	self
		assert: (self diagnosticsWithCode: #unknownKeyword) size
		equals: 1.
	self
		assert: (self diagnosticsWithCode: #unknownKeyword) first pointer
		equals: '#/paths/~1a/get/responses/200/baz'
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> testUnknownSecuritySchemeIsReported [
	"A requirement naming a scheme that is not declared is a #securitySchemeUnresolved warning and does not raise."

	self
		shouldnt: [
		self importOpenApi3: '`security`:[{`ghost`:[]}],`paths`:{}' ]
		raise: Error.
	self
		assert: (self diagnosticsWithCode: #securitySchemeUnresolved) size
		equals: 1.
	self assert:
		(self diagnosticsWithCode: #securitySchemeUnresolved) first
			isWarning
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testWebhookIsAPathNamedByItsKeyWithItsOperations [

	| model openApi webhook |
	model := self importOpenApi31:
		         '`webhooks`:{`newPet`:{`post`:{`operationId`:`onNewPet`},`put`:{`operationId`:`onPetUpdate`}}}'.
	openApi := self openApiIn: model.
	webhook := openApi webhooks anyOne.
	self assert: webhook name equals: 'newPet'.
	self assert: webhook operations size equals: 2.
	self assert: webhook webhookOf == openApi.
	self assert: webhook canonicalPointer equals: '#/webhooks/newPet'
]

{ #category : 'tests - links callbacks webhooks (step B)' }
FamixOpenApiOperationsImportTest >> testWebhookOperationsAreNotOperationsOfThePaths [

	| model |
	model := self importOpenApi31:
		         '`paths`:{`/a`:{`get`:{`operationId`:`g`}}},`webhooks`:{`w`:{`post`:{`operationId`:`p`}}}'.
	self assert: (self openApiIn: model) operations size equals: 1.
	self
		assert: (self entitiesNamed: #Operation in: model) size
		equals: 2
]

{ #category : 'tests - responses and headers (step B)' }
FamixOpenApiOperationsImportTest >> twoOperationsSharingAResponseJson [

	^ self jsonFrom:
		  '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`responses`:{`404`:{`$ref`:`#/components/responses/NotFound`}}}},`/b`:{`post`:{`operationId`:`opB`,`responses`:{`404`:{`$ref`:`#/components/responses/NotFound`}}}}},`components`:{`responses`:{`NotFound`:{`description`:`nf`,`content`:{`text/plain`:{`schema`:{`type`:`string`}}}}}}'
]

{ #category : 'tests - security (step B)' }
FamixOpenApiOperationsImportTest >> twoSchemesJson [

	^ self jsonFrom:
		  '`components`:{`securitySchemes`:{`a`:{`type`:`apiKey`,`in`:`header`,`name`:`ka`},`b`:{`type`:`apiKey`,`in`:`query`,`name`:`kb`}}}'
]
