"
I am the abstract description of a supported specification version (Swagger 2, OpenAPI 3.0, 3.1). I detect the version of a document and normalise its version specific constructs (nullability, bounds, servers, reference targets) to the 3.1 shape used by the model.
"
Class {
	#name : 'FamixOpenApiSpecVersion',
	#superclass : 'Object',
	#instVars : [
		'sourceVersion'
	],
	#classVars : [
		'SchemaKeywords',
		'UnmodelledSchemaKeywords'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'detection' }
FamixOpenApiSpecVersion class >> detectIn: aJsonDictionary diagnostics: aDiagnostics [
	"Answer the version instance of the document aJsonDictionary, or nil after recording an unsupportedVersion error."

	| hasOpenApi hasSwagger |
	aJsonDictionary isDictionary ifFalse: [
		^ self
			  unsupportedIn: aDiagnostics
			  reason: 'The document is not a JSON object' ].
	hasOpenApi := aJsonDictionary includesKey: 'openapi'.
	hasSwagger := aJsonDictionary includesKey: 'swagger'.
	(hasOpenApi and: [ hasSwagger ]) ifTrue: [
		aDiagnostics
			warning: #ambiguousVersion
			pointer: '#/openapi'
			message: 'Both swagger and openapi keys are present; using openapi' ].
	hasOpenApi ifTrue: [
		^ self
			  detectOpenApi: (aJsonDictionary at: 'openapi')
			  diagnostics: aDiagnostics ].
	hasSwagger ifTrue: [
		^ self
			  detectSwagger: (aJsonDictionary at: 'swagger')
			  diagnostics: aDiagnostics ].
	^ self
		  unsupportedIn: aDiagnostics
		  reason: 'Neither swagger nor openapi key found'
]

{ #category : 'detection' }
FamixOpenApiSpecVersion class >> detectOpenApi: aVersion diagnostics: aDiagnostics [

	(aVersion isString and: [ aVersion beginsWith: '3' ]) ifFalse: [
		^ self
			  unsupportedIn: aDiagnostics
			  reason: 'Unsupported openapi value ' , aVersion printString ].
	(aVersion beginsWith: '3.0') ifTrue: [
		^ FamixOpenApi30Version new setSourceVersion: aVersion ].
	(aVersion beginsWith: '3.1') ifFalse: [
		aDiagnostics
			warning: #unknownVersion
			pointer: '#/openapi'
			message: 'Unknown OpenAPI version ' , aVersion printString
				, '; reading it as 3.1' ].
	^ FamixOpenApi31Version new setSourceVersion: aVersion
]

{ #category : 'detection' }
FamixOpenApiSpecVersion class >> detectSwagger: aVersion diagnostics: aDiagnostics [

	(aVersion isString and: [ aVersion beginsWith: '2' ]) ifFalse: [
		^ self
			  unsupportedIn: aDiagnostics
			  reason: 'Unsupported swagger value ' , aVersion printString ].
	^ FamixOpenApiSwagger2Version new setSourceVersion: aVersion
]

{ #category : 'keywords' }
FamixOpenApiSpecVersion class >> resetKeywordTables [
	"Forget the cached keyword tables."

	SchemaKeywords := nil.
	UnmodelledSchemaKeywords := nil
]

{ #category : 'keywords' }
FamixOpenApiSpecVersion class >> schemaKeywords [
	"Answer the Set of the JSON-Schema keywords mapped to Schema slots by the model."

	^ SchemaKeywords ifNil: [
		  SchemaKeywords := 'type format title description default enum const example required properties items prefixItems allOf oneOf anyOf not additionalProperties discriminator xml externalDocs readOnly writeOnly deprecated nullable minimum maximum exclusiveMinimum exclusiveMaximum multipleOf minLength maxLength pattern minItems maxItems uniqueItems minProperties maxProperties $ref'
			                    substrings asSet ]
]

{ #category : 'keywords' }
FamixOpenApiSpecVersion class >> unmodelledSchemaKeywords [
	"Answer the Set of the JSON-Schema keywords that the model does not map."

	^ UnmodelledSchemaKeywords ifNil: [
		  UnmodelledSchemaKeywords := '$id $schema $anchor $comment $defs $dynamicRef $dynamicAnchor if then else dependentSchemas dependentRequired patternProperties propertyNames contains minContains maxContains unevaluatedItems unevaluatedProperties contentEncoding contentMediaType contentSchema examples'
			                              substrings asSet ]
]

{ #category : 'detection' }
FamixOpenApiSpecVersion class >> unsupportedIn: aDiagnostics reason: aString [

	aDiagnostics error: #unsupportedVersion pointer: '#' message: aString.
	^ nil
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> canonicalVersion [
	"Answer the OpenAPI version the model is normalised to."

	^ '3.1.0'
]

{ #category : 'references and servers' }
FamixOpenApiSpecVersion >> defaultServers [

	^ { (Dictionary new
		   at: 'url' put: '/';
		   yourself) }
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> exclusiveBoundAt: anExclusiveKey boundAt: aBoundKey in: aSchemaNode [

	| exclusive |
	aSchemaNode isDictionary ifFalse: [ ^ nil ].
	exclusive := aSchemaNode at: anExclusiveKey ifAbsent: [ nil ].
	exclusive isNumber ifTrue: [ ^ exclusive ].
	exclusive == true ifTrue: [
		^ self numberAt: aBoundKey in: aSchemaNode ].
	^ nil
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> exclusiveMaximumFrom: aSchemaNode [
	"Answer the exclusive maximum of aSchemaNode or nil, from the numeric (3.1) or boolean (Swagger 2, 3.0) form."

	^ self
		  exclusiveBoundAt: 'exclusiveMaximum'
		  boundAt: 'maximum'
		  in: aSchemaNode
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> exclusiveMinimumFrom: aSchemaNode [
	"Answer the exclusive minimum of aSchemaNode or nil, from the numeric (3.1) or boolean (Swagger 2, 3.0) form."

	^ self
		  exclusiveBoundAt: 'exclusiveMinimum'
		  boundAt: 'minimum'
		  in: aSchemaNode
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> explicitNullFlagFrom: aSchemaNode [
	"Answer whether aSchemaNode carries the version specific nullable flag set to true. No flag by default."

	^ false
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> isBooleanExclusive: aKey in: aSchemaNode [

	^ aSchemaNode isDictionary and: [
		  (aSchemaNode at: aKey ifAbsent: [ nil ]) == true ]
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> isExtensionKey: aString [
	"Answer whether aString is a specification extension key (x- prefix)."

	^ aString isString and: [ aString beginsWith: 'x-' ]
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> isNullableFrom: aSchemaNode [
	"Answer whether aSchemaNode accepts null, by the rules of the receiver (or a type array / type null, tolerated in every version)."

	aSchemaNode isDictionary ifFalse: [ ^ false ].
	^ (self explicitNullFlagFrom: aSchemaNode) or: [
		  (self rawTypesFrom: aSchemaNode) includes: 'null' ]
]

{ #category : 'testing' }
FamixOpenApiSpecVersion >> isOpenApi30 [

	^ false
]

{ #category : 'testing' }
FamixOpenApiSpecVersion >> isOpenApi31 [

	^ false
]

{ #category : 'testing' }
FamixOpenApiSpecVersion >> isSwagger2 [

	^ false
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> maximumFrom: aSchemaNode [
	"Answer the inclusive maximum of aSchemaNode or nil (a boolean exclusiveMaximum moves the bound to the exclusive slot)."

	(self isBooleanExclusive: 'exclusiveMaximum' in: aSchemaNode)
		ifTrue: [ ^ nil ].
	^ self numberAt: 'maximum' in: aSchemaNode
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> minimumFrom: aSchemaNode [
	"Answer the inclusive minimum of aSchemaNode or nil (a boolean exclusiveMinimum moves the bound to the exclusive slot)."

	(self isBooleanExclusive: 'exclusiveMinimum' in: aSchemaNode)
		ifTrue: [ ^ nil ].
	^ self numberAt: 'minimum' in: aSchemaNode
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> numberAt: aKey in: aSchemaNode [

	| value |
	aSchemaNode isDictionary ifFalse: [ ^ nil ].
	value := aSchemaNode at: aKey ifAbsent: [ nil ].
	^ value isNumber
		  ifTrue: [ value ]
		  ifFalse: [ nil ]
]

{ #category : 'references and servers' }
FamixOpenApiSpecVersion >> openApiServersFrom: aDocumentNode [
	"Answer a copy of the servers array of aDocumentNode, or the default server when absent or empty."

	| servers |
	servers := aDocumentNode isDictionary
		           ifTrue: [ aDocumentNode at: 'servers' ifAbsent: [ nil ] ]
		           ifFalse: [ nil ].
	(servers isCollection and: [
		 servers isString not and: [ servers isDictionary not ] ]) ifFalse: [
		^ self defaultServers ].
	servers := (servers select: #isDictionary) collect: [ :each |
		           each copy ].
	^ servers isEmpty
		  ifTrue: [ self defaultServers ]
		  ifFalse: [ servers asArray ]
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: sourceVersion asString;
		nextPut: $)
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> rawTypesFrom: aSchemaNode [
	"Answer the Array of type Strings of aSchemaNode, null included."

	| type |
	aSchemaNode isDictionary ifFalse: [ ^ #(  ) ].
	type := aSchemaNode at: 'type' ifAbsent: [ nil ].
	type isString ifTrue: [ ^ { type } ].
	(type isCollection and: [ type isDictionary not ]) ifTrue: [
		^ (type select: #isString) asArray ].
	^ #(  )
]

{ #category : 'references and servers' }
FamixOpenApiSpecVersion >> refTargetPointerFor: aRefString [
	"Answer the canonical pointer designated by the raw reference aRefString. Unchanged by default."

	^ aRefString
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> schemaKeywords [
	"Answer the JSON-Schema keywords mapped to Schema slots."

	^ self class schemaKeywords
]

{ #category : 'references and servers' }
FamixOpenApiSpecVersion >> serversFrom: aDocumentNode [
	"Answer an Array of Dictionaries (url, description, variables) describing the servers of aDocumentNode."

	self subclassResponsibility
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> setSourceVersion: aString [

	sourceVersion := aString
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> sourceVersion [
	"Answer the version String as read in the document."

	^ sourceVersion
]

{ #category : 'schema normalisation' }
FamixOpenApiSpecVersion >> typesFrom: aSchemaNode [
	"Answer the Array of type Strings of aSchemaNode, without 'null'."

	^ (self rawTypesFrom: aSchemaNode) reject: [ :each | each = 'null' ]
]

{ #category : 'accessing' }
FamixOpenApiSpecVersion >> unmodelledSchemaKeywords [
	"Answer the JSON-Schema keywords not mapped by the model."

	^ self class unmodelledSchemaKeywords
]
