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

{ #category : 'private - model' }
FamixOpenApiOperationDependencyGraphBuilder >> entityClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
		at: generatedClassName
		ifAbsent: [ self error: 'Missing generated class: ', generatedClassName asString ]
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

{ #category : 'private - normalization' }
FamixOpenApiOperationDependencyGraphBuilder >> defaultNameNormalizer [
	^ [ :rawName | rawName asString asLowercase ]
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> isRequiredParameter: aParameter [
	| isMarkedAsRequired location |
	isMarkedAsRequired := (aParameter respondsTo: #required)
		and: [ aParameter required = true ].
	location := (aParameter respondsTo: #location)
		ifTrue: [ aParameter location ]
		ifFalse: [ nil ].
	location := location ifNil: [ '' ] ifNotNil: [ location asString asLowercase ].
	^ isMarkedAsRequired or: [ location = 'path' ]
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> isSuccessfulResponseEntry: aResponseEntry [
	| key |
	key := (aResponseEntry respondsTo: #key)
		ifTrue: [ aResponseEntry key ]
		ifFalse: [ nil ].
	key := key ifNil: [ '' ] ifNotNil: [ key asString ].
	^ key isEmpty not and: [ key first = $2 ]
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

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> operationResponses: anOperation [
	| responses |
	(anOperation respondsTo: #responses) ifFalse: [ ^ #() ].
	responses := anOperation responses.
	responses ifNil: [ ^ #() ].
	^ responses select: [ :each | self isSuccessfulResponseEntry: each ]
]

{ #category : 'private - model' }
FamixOpenApiOperationDependencyGraphBuilder >> operationsInModel: aModel [
	| operationClass |
	operationClass := self entityClassNamed: #Operation.
	^ (aModel allWithType: operationClass) asOrderedCollection
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> producedOutputsForOperation: anOperation [
	| outputs |
	outputs := Set new.
	(self operationResponses: anOperation) do: [ :responseEntry |
		| response |
		response := (responseEntry respondsTo: #value)
			ifTrue: [ responseEntry value ]
			ifFalse: [ nil ].
		response ifNotNil: [
			(self responseSchemasFor: response) do: [ :schema |
				self
					collectPropertyNamesFromSchema: schema
					into: outputs
					requiredOnly: false
					visited: IdentitySet new ] ] ].
	^ outputs
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> requiredInputsForOperation: anOperation [
	| requiredInputs |
	requiredInputs := Set new.

	(anOperation respondsTo: #parameters) ifTrue: [
		| parameters |
		parameters := anOperation parameters.
		parameters ifNotNil: [
			parameters do: [ :parameter |
				(self isRequiredParameter: parameter) ifTrue: [
					| normalizedName |
					normalizedName := self
						normalizedNameFrom: ((parameter respondsTo: #name)
							ifTrue: [ parameter name ]
							ifFalse: [ nil ]).
					normalizedName ifNotNil: [ requiredInputs add: normalizedName ] ] ] ] ].

	(self requiredRequestBody: anOperation) ifNotNil: [ :requestBody |
		(self requestBodySchemasFor: requestBody) do: [ :schema |
			self
				collectPropertyNamesFromSchema: schema
				into: requiredInputs
				requiredOnly: true
				visited: IdentitySet new ] ].

	^ requiredInputs
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> requiredRequestBody: anOperation [
	| requestBody |
	(anOperation respondsTo: #requestBody) ifFalse: [ ^ nil ].
	requestBody := anOperation requestBody.
	requestBody ifNil: [ ^ nil ].
	(requestBody respondsTo: #required) ifFalse: [ ^ nil ].
	^ requestBody required = true
		ifTrue: [ requestBody ]
		ifFalse: [ nil ]
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> requestBodySchemasFor: aRequestBody [
	| schemas |
	schemas := OrderedCollection new.
	(aRequestBody respondsTo: #content) ifFalse: [ ^ schemas ].
	aRequestBody content ifNil: [ ^ schemas ].

	aRequestBody content do: [ :contentEntry |
		| mediaType schema |
		mediaType := (contentEntry respondsTo: #value)
			ifTrue: [ contentEntry value ]
			ifFalse: [ nil ].
		schema := (mediaType notNil and: [ mediaType respondsTo: #schema ])
			ifTrue: [ mediaType schema ]
			ifFalse: [ nil ].
		schema ifNotNil: [ schemas add: schema ] ].
	^ schemas
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> responseSchemasFor: aResponse [
	| schemas |
	schemas := OrderedCollection new.

	(aResponse respondsTo: #schema) ifTrue: [
		aResponse schema ifNotNil: [ :schema | schemas add: schema ] ].

	(aResponse respondsTo: #content) ifTrue: [
		aResponse content ifNotNil: [
			aResponse content do: [ :contentEntry |
				| mediaType schema |
				mediaType := (contentEntry respondsTo: #value)
					ifTrue: [ contentEntry value ]
					ifFalse: [ nil ].
				schema := (mediaType notNil and: [ mediaType respondsTo: #schema ])
					ifTrue: [ mediaType schema ]
					ifFalse: [ nil ].
				schema ifNotNil: [ schemas add: schema ] ] ] ].

	^ schemas
]

{ #category : 'private - extraction' }
FamixOpenApiOperationDependencyGraphBuilder >> collectPropertyNamesFromSchema: aSchema into: aSet requiredOnly: requiredOnly visited: visitedSchemas [
	| properties |
	aSchema ifNil: [ ^ self ].
	(visitedSchemas includes: aSchema) ifTrue: [ ^ self ].
	visitedSchemas add: aSchema.

	properties := (aSchema respondsTo: #properties)
		ifTrue: [ aSchema properties ]
		ifFalse: [ nil ].
	properties ifNotNil: [
		properties do: [ :property |
			| includeProperty normalizedName |
			includeProperty := requiredOnly not
				or: [ (property respondsTo: #required) and: [ property required = true ] ].
			includeProperty ifTrue: [
				normalizedName := self
					normalizedNameFrom: ((property respondsTo: #name)
						ifTrue: [ property name ]
						ifFalse: [ nil ]).
				normalizedName ifNotNil: [ aSet add: normalizedName ] ] ] ].

	(aSchema respondsTo: #items) ifTrue: [
		aSchema items ifNotNil: [ :itemsSchema |
			self
				collectPropertyNamesFromSchema: itemsSchema
				into: aSet
				requiredOnly: requiredOnly
				visited: visitedSchemas ] ].

	(aSchema respondsTo: #allOf) ifTrue: [
		aSchema allOf ifNotNil: [
			aSchema allOf do: [ :subSchema |
				self
					collectPropertyNamesFromSchema: subSchema
					into: aSet
					requiredOnly: requiredOnly
					visited: visitedSchemas ] ] ]
]
