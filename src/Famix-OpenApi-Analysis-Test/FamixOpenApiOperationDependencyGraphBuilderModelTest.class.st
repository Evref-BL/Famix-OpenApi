"
I test FamixOpenApiOperationDependencyGraphBuilder against small OpenAPI 3.x documents imported into the final metamodel: allOf inheritance, array items, status codes, required parameters and body properties, merged inline schemas, oneOf unions, SubSchemas and operations without operationId. Each document has a source operation GET /src whose 2xx response is described by the schema under test, and a target operation POST /dst requiring the input uid.
"
Class {
	#name : 'FamixOpenApiOperationDependencyGraphBuilderModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'graph'
	],
	#category : 'Famix-OpenApi-Analysis-Test',
	#package : 'Famix-OpenApi-Analysis-Test'
}

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> assertEdgeFrom: sourceId to: targetId [

	self assert: ((graph at: (self operationWithId: sourceId)) includes:
			 (self operationWithId: targetId))
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> buildFromDocument: aJsonString [

	model := FamixOpenApiImporter new modelFromJsonString: aJsonString.
	graph := FamixOpenApiOperationDependencyGraphBuilder new
		         buildFromModel: model
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> buildFromSourceSchema: schemaJson components: componentsJson [

	^ self
		  buildFromSourceSchema: schemaJson
		  status: '200'
		  components: componentsJson
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> buildFromSourceSchema: schemaJson status: aStatus components: componentsJson [

	self buildFromDocument: (self
			 documentWithSourceResponses:
			 (self responsesWithStatus: aStatus schema: schemaJson)
			 target: self uidQueryTarget
			 components: componentsJson)
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> denyEdgeFrom: sourceId to: targetId [

	self deny: ((graph at: (self operationWithId: sourceId)) includes:
			 (self operationWithId: targetId))
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> documentWithSourceResponses: responsesJson target: targetJson components: componentsJson [

	^ '{"openapi":"3.0.4","info":{"title":"T","version":"1"},"paths":{"/src":{"get":{"operationId":"src","responses":'
	  , responsesJson , '}},"/dst":{"post":{"operationId":"dst",'
	  , targetJson , '}}},"components":{"schemas":{' , componentsJson
	  , '}}}'
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> operationWithId: anId [

	^ (model allWithType: OPOperation) detect: [ :each |
		  each operationId = anId ]
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> responsesWithStatus: aStatus schema: schemaJson [

	^ '{"' , aStatus
	  , '":{"description":"r","content":{"application/json":{"schema":'
	  , schemaJson , '}}}}'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testAllOfInheritedPropertiesAreOutputs [

	self
		buildFromSourceSchema: '{"$ref":"#/components/schemas/Child"}'
		components: '"Base":{"type":"object",' , self uidProperty
			,
			'},"Child":{"allOf":[{"$ref":"#/components/schemas/Base"}],"properties":{"other":{"type":"string"}}}'.
	self assertEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testArrayResponseUsesItemsProperties [

	self
		buildFromSourceSchema:
		'{"type":"array","items":{"$ref":"#/components/schemas/Item"}}'
		components: '"Item":{"type":"object",' , self uidProperty , '}'.
	self assertEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testDefaultResponseIsIgnored [

	self
		buildFromSourceSchema: '{"$ref":"#/components/schemas/Item"}'
		status: 'default'
		components: '"Item":{"type":"object",' , self uidProperty , '}'.
	self denyEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testErrorResponseIsIgnored [

	self
		buildFromSourceSchema: '{"$ref":"#/components/schemas/Item"}'
		status: '404'
		components: '"Item":{"type":"object",' , self uidProperty , '}'.
	self denyEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testMergedIdenticalInlineSchemasStillGiveEdges [

	| document |
	document := '{"openapi":"3.0.4","info":{"title":"T","version":"1"},"paths":{"/a":{"get":{"operationId":"a","responses":'
	            , (self
			             responsesWithStatus: '200'
			             schema: '{"type":"object",' , self uidProperty , '}')
	            , '}},"/b":{"get":{"operationId":"b","responses":'
	            , (self
			             responsesWithStatus: '200'
			             schema: '{"type":"object",' , self uidProperty , '}')
	            , '}},"/dst":{"post":{"operationId":"dst",'
	            , self uidQueryTarget , '}}}}'.
	self buildFromDocument: document.
	self assertEdgeFrom: 'a' to: 'dst'.
	self assertEdgeFrom: 'b' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testOneOfMembersAreUnioned [

	self buildFromDocument: (self
			 documentWithSourceResponses: (self
					  responsesWithStatus: '200'
					  schema:
					  '{"oneOf":[{"$ref":"#/components/schemas/A"},{"$ref":"#/components/schemas/B"}]}')
			 target:
			 '"parameters":[{"name":"uid","in":"query","required":true,"schema":{"type":"string"}},{"name":"token","in":"query","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}'
			 components: '"A":{"type":"object",' , self uidProperty
				 ,
				 '},"B":{"type":"object","properties":{"token":{"type":"string"}}}').
	self assertEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testOperationWithoutOperationIdIsANode [

	| document source target |
	document := '{"openapi":"3.0.4","info":{"title":"T","version":"1"},"paths":{"/src":{"get":{"responses":'
	            , (self
			             responsesWithStatus: '200'
			             schema: '{"type":"object",' , self uidProperty , '}')
	            , '}},"/dst":{"post":{"operationId":"dst",'
	            , self uidQueryTarget , '}}}}'.
	self buildFromDocument: document.
	source := (model allWithType: OPOperation) detect: [ :each |
		          each operationId isNil ].
	target := self operationWithId: 'dst'.
	self assert: ((graph at: source) includes: target).
	self assert: source name equals: 'get_src'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testOptionalQueryParameterIsNotAnInput [

	self buildFromDocument: (self
			 documentWithSourceResponses: (self
					  responsesWithStatus: '200'
					  schema: '{"type":"object",' , self uidProperty , '}')
			 target:
			 '"parameters":[{"name":"uid","in":"query","schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}'
			 components: '').
	self denyEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testRequiredBodyPropertyIsAnInputButOptionalIsNot [

	| body |
	body := [ :required |
		        '"requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object",'
		        , required , self uidProperty
		        , '}}}},"responses":{"200":{"description":"ok"}}' ].
	self buildFromDocument: (self
			 documentWithSourceResponses: (self
					  responsesWithStatus: '200'
					  schema: '{"type":"object",' , self uidProperty , '}')
			 target: (body value: '"required":["uid"],')
			 components: '').
	self assertEdgeFrom: 'src' to: 'dst'.
	self buildFromDocument: (self
			 documentWithSourceResponses: (self
					  responsesWithStatus: '200'
					  schema: '{"type":"object",' , self uidProperty , '}')
			 target: (body value: '')
			 components: '').
	self denyEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testStatusRangeTwoXXIsSuccessful [

	self
		buildFromSourceSchema: '{"$ref":"#/components/schemas/Item"}'
		status: '2XX'
		components: '"Item":{"type":"object",' , self uidProperty , '}'.
	self assertEdgeFrom: 'src' to: 'dst'
]

{ #category : 'tests' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> testSubSchemaResponseGivesEdge [

	self
		buildFromSourceSchema:
		'{"type":"object","properties":{"uid":{"type":"string"},"name":{"type":"string"}}}'
		components:
		'"Pet":{"type":"object","properties":{"uid":{"type":"string"},"name":{"type":"string"},"tag":{"type":"string"}}}'.
	self assert: (model allWithType: OPSubSchema) size equals: 1.
	self assertEdgeFrom: 'src' to: 'dst'
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> uidProperty [

	^ '"properties":{"uid":{"type":"string"}}'
]

{ #category : 'fixtures' }
FamixOpenApiOperationDependencyGraphBuilderModelTest >> uidQueryTarget [

	^ '"parameters":[{"name":"uid","in":"query","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok"}}'
]
