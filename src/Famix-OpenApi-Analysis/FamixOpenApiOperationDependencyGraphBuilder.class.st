"
I build a directed graph between the operations (OPOperation) of an OpenAPI model. An edge A -> B means that every required input of B (required parameters, and required properties of a required request body) is found among the outputs of A (property names of the schemas of the media types of the successful, 2xx, responses of A). Names are compared after normalisation: lowercased by default, customisable with #nameNormalizer:. The graph is a Dictionary mapping each operation to the Set of the operations that can follow it. B with no required input has no incoming edge.
"
Class {
	#name : 'FamixOpenApiOperationDependencyGraphBuilder',
	#superclass : 'Object',
	#instVars : [
		'graph',
		'model',
		'nameNormalizer'
	],
	#category : 'Famix-OpenApi-Analysis',
	#package : 'Famix-OpenApi-Analysis'
}

{ #category : 'outputs' }
FamixOpenApiOperationDependencyGraphBuilder >> addName: aRawName into: aSet [

	(self normalizedNameFrom: aRawName) ifNotNil: [ :name |
		aSet add: name ]
]

{ #category : 'outputs' }
FamixOpenApiOperationDependencyGraphBuilder >> addNamesOfProperties: properties into: aSet [

	properties do: [ :each | self addName: each name into: aSet ]
]

{ #category : 'building' }
FamixOpenApiOperationDependencyGraphBuilder >> buildFromModel: aModel [
	| operations producedOutputsByOperation requiredInputsByOperation |
	self model: aModel.
	operations := self operationsInModel: aModel.
	graph := Dictionary new.
	producedOutputsByOperation := Dictionary new.
	requiredInputsByOperation := Dictionary new.

	operations do: [ :operation |
		graph at: operation put: Set new.
		producedOutputsByOperation
			at: operation
			put: (self producedOutputsForOperation: operation).
		requiredInputsByOperation
			at: operation
			put: (self requiredInputsForOperation: operation) ].

	operations do: [ :sourceOperation |
		| sourceOutputs |
		sourceOutputs := producedOutputsByOperation at: sourceOperation.
		operations do: [ :targetOperation |
			| requiredInputs |
			sourceOperation == targetOperation ifFalse: [
				requiredInputs := requiredInputsByOperation at: targetOperation.
				(requiredInputs isEmpty not
					and: [ requiredInputs allSatisfy: [ :each | sourceOutputs includes: each ] ])
					ifTrue: [ (graph at: sourceOperation) add: targetOperation ] ] ] ].

	^ graph
]

{ #category : 'outputs' }
FamixOpenApiOperationDependencyGraphBuilder >> collectOutputNamesOf: aSchema into: aSet visited: visitedSchemas [
	"Collect the names of the properties of aSchema, inherited ones included (allOf), then those of its array items and of the union of its oneOf and anyOf members."

	(visitedSchemas includes: aSchema) ifTrue: [ ^ self ].
	visitedSchemas add: aSchema.
	self addNamesOfProperties: aSchema allProperties into: aSet.
	(self outputRelatedSchemasOf: aSchema) do: [ :each |
		self collectOutputNamesOf: each into: aSet visited: visitedSchemas ]
]

{ #category : 'inputs' }
FamixOpenApiOperationDependencyGraphBuilder >> collectRequiredBodyPropertiesOf: anOperation into: aSet [

	| requestBody |
	requestBody := anOperation requestBody.
	(requestBody isNotNil and: [ requestBody required = true ]) ifFalse: [
		^ self ].
	(self schemasOfContent: requestBody content) do: [ :schema |
			self
				collectRequiredNamesOf: schema
				into: aSet
				visited: IdentitySet new ]
]

{ #category : 'inputs' }
FamixOpenApiOperationDependencyGraphBuilder >> collectRequiredNamesOf: aSchema into: aSet visited: visitedSchemas [
	"Collect the names of the required properties of aSchema, inherited ones included (allOf), and those of its array items. oneOf and anyOf members are alternatives: they are not followed."

	(visitedSchemas includes: aSchema) ifTrue: [ ^ self ].
	visitedSchemas add: aSchema.
	aSchema requiredProperties do: [ :each |
		self addName: each into: aSet ].
	self
		addNamesOfProperties:
		(aSchema allProperties select: [ :each | each isRequired = true ])
		into: aSet.
	(self itemsOf: aSchema) , aSchema allOf do: [ :each |
		self collectRequiredNamesOf: each into: aSet visited: visitedSchemas ]
]

{ #category : 'inputs' }
FamixOpenApiOperationDependencyGraphBuilder >> collectRequiredParametersOf: anOperation into: aSet [

	(anOperation effectiveParameters select: [ :each |
		 self isRequiredParameter: each ]) do: [ :each |
		self addName: each name into: aSet ]
]

{ #category : 'private - normalization' }
FamixOpenApiOperationDependencyGraphBuilder >> defaultNameNormalizer [
	^ [ :rawName | rawName asString asLowercase ]
]

{ #category : 'accessing' }
FamixOpenApiOperationDependencyGraphBuilder >> graph [
	^ graph ifNil: [ Dictionary new ]
]

{ #category : 'accessing' }
FamixOpenApiOperationDependencyGraphBuilder >> initialize [
	super initialize.
	nameNormalizer := self defaultNameNormalizer
]

{ #category : 'inputs' }
FamixOpenApiOperationDependencyGraphBuilder >> isRequiredParameter: aParameter [
	"Path parameters are always required."

	^ aParameter required = true or: [ aParameter location = 'path' ]
]

{ #category : 'building' }
FamixOpenApiOperationDependencyGraphBuilder >> isSuccessfulResponse: aResponse [
	"A response is successful when its status code starts with 2 (200, 201, 2XX). default is not."

	^ aResponse statusCode asString beginsWith: '2'
]

{ #category : 'outputs' }
FamixOpenApiOperationDependencyGraphBuilder >> itemsOf: aSchema [
	"Answer the array items schema of aSchema as a collection, empty when there is none."

	^ aSchema items ifNil: [ #(  ) ] ifNotNil: [ :items | { items } ]
]

{ #category : 'accessing' }
FamixOpenApiOperationDependencyGraphBuilder >> model [
	^ model
]

{ #category : 'accessing' }
FamixOpenApiOperationDependencyGraphBuilder >> model: aModel [
	model := aModel
]

{ #category : 'accessing' }
FamixOpenApiOperationDependencyGraphBuilder >> nameNormalizer [
	^ nameNormalizer ifNil: [ self defaultNameNormalizer ]
]

{ #category : 'accessing' }
FamixOpenApiOperationDependencyGraphBuilder >> nameNormalizer: aBlock [
	nameNormalizer := aBlock ifNil: [ self defaultNameNormalizer ]
]

{ #category : 'private - normalization' }
FamixOpenApiOperationDependencyGraphBuilder >> normalizedNameFrom: aRawName [
	| normalized raw |
	aRawName ifNil: [ ^ nil ].
	raw := aRawName asString trimBoth.
	raw isEmpty ifTrue: [ ^ nil ].
	normalized := self nameNormalizer value: raw.
	normalized ifNil: [ ^ nil ].
	normalized := normalized asString trimBoth.
	^ normalized isEmpty
		ifTrue: [ nil ]
		ifFalse: [ normalized ]
]

{ #category : 'building' }
FamixOpenApiOperationDependencyGraphBuilder >> operationsInModel: aModel [
	"Answer the operations of aModel."

	^ (aModel allWithType: OPOperation) asOrderedCollection
]

{ #category : 'outputs' }
FamixOpenApiOperationDependencyGraphBuilder >> outputRelatedSchemasOf: aSchema [
	"Schemas whose properties are also outputs of aSchema."

	^ (self itemsOf: aSchema) , aSchema allOf , aSchema oneOf
	  , aSchema anyOf
]

{ #category : 'outputs' }
FamixOpenApiOperationDependencyGraphBuilder >> producedOutputsForOperation: anOperation [
	"Answer the normalized property names found in the schemas of the successful responses of anOperation."

	| outputs |
	outputs := Set new.
	(self successfulResponsesOf: anOperation) do: [ :response |
			(self schemasOfContent: response content) do: [ :schema |
					self
						collectOutputNamesOf: schema
						into: outputs
						visited: IdentitySet new ] ].
	^ outputs
]

{ #category : 'inputs' }
FamixOpenApiOperationDependencyGraphBuilder >> requiredInputsForOperation: anOperation [
	"Answer the normalized names of the required parameters of anOperation and of the required properties of its required request body."

	| requiredInputs |
	requiredInputs := Set new.
	self collectRequiredParametersOf: anOperation into: requiredInputs.
	self
		collectRequiredBodyPropertiesOf: anOperation
		into: requiredInputs.
	^ requiredInputs
]

{ #category : 'building' }
FamixOpenApiOperationDependencyGraphBuilder >> schemasOfContent: aMediaTypeCollection [

	^ aMediaTypeCollection
		  select: [ :each | each schema notNil ]
		  thenCollect: [ :each | each schema ]
]

{ #category : 'building' }
FamixOpenApiOperationDependencyGraphBuilder >> successfulResponsesOf: anOperation [

	^ anOperation responses select: [ :each |
		  self isSuccessfulResponse: each ]
]
