"
Tests of FamixOpenApiSynthesizedServers: the urls of the servers without source node (default server of OpenAPI 3, host/basePath/schemes of Swagger 2), compared with what the importer really builds.
"
Class {
	#name : 'FamixOpenApiSynthesizedServersTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> assertUrls: anArray in: aJsonString [
	"The expected urls are the given ones and the importer really builds them"

	self assert: (self expectedUrlsOf: aJsonString) equals: anArray.
	self assert: (self importedUrlsOf: aJsonString) equals: anArray
]

{ #category : 'helpers' }
FamixOpenApiSynthesizedServersTest >> expectedUrlsOf: aJsonString [

	^ (FamixOpenApiSynthesizedServers on: (self inventoryOf: aJsonString))
		  expectedUrls asArray
]

{ #category : 'helpers' }
FamixOpenApiSynthesizedServersTest >> importedUrlsOf: aJsonString [
	"The urls of the OPServer that are not nodes of the document, in the order of their pointers #/servers/N"

	| inventory servers |
	inventory := self inventoryOf: aJsonString.
	servers := ((self modelOf: aJsonString) allWithType: OPServer)
		           reject: [ :each |
		           inventory includesPointer: each canonicalPointer ].
	^ (servers sorted: [ :a :b |
		   a canonicalPointer <= b canonicalPointer ])
		  collect: #url
		  as: Array
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testOpenApi3WithAnEmptyServerListHasTheDefaultServer [

	self
		assertUrls: #( '/' )
		in: '{"openapi":"3.0.3","servers":[],"paths":{}}'
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testOpenApi3WithServersHasNoSynthesizedServer [

	self
		assertUrls: #(  )
		in: '{"openapi":"3.0.3","servers":[{"url":"http://a"}],"paths":{}}'
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testOpenApi3WithoutServersHasTheDefaultServer [

	self assertUrls: #( '/' ) in: '{"openapi":"3.1.0","paths":{}}'.
	self assertUrls: #( '/' ) in: '{"openapi":"3.0.0","paths":{}}'
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testSwagger2HasOneServerPerScheme [

	self
		assertUrls: #( 'http://h.com/v' 'https://h.com/v' )
		in:
		'{"swagger":"2.0","host":"h.com","basePath":"/v","schemes":["http","https"],"paths":{}}'
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testSwagger2WithBadValuesFollowsTheImporter [

	self
		assertUrls: #( 'https://h.com' )
		in:
		'{"swagger":"2.0","host":"h.com","basePath":12,"schemes":"http","paths":{}}'.
	self
		assertUrls: #( 'http://h.com' )
		in:
		'{"swagger":"2.0","host":"h.com","schemes":["http",3],"paths":{}}'
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testSwagger2WithoutHostUsesTheBasePathOrSlash [

	self
		assertUrls: #( '/v1' )
		in:
		'{"swagger":"2.0","basePath":"/v1","schemes":["http"],"paths":{}}'.
	self assertUrls: #( '/' ) in: '{"swagger":"2.0","paths":{}}'
]

{ #category : 'tests' }
FamixOpenApiSynthesizedServersTest >> testSwagger2WithoutSchemesUsesHttps [

	self
		assertUrls: #( 'https://h.com' )
		in: '{"swagger":"2.0","host":"h.com","paths":{}}'
]
