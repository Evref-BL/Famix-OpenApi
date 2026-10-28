"
Tests of the schema hooks (types, nullability, bounds, servers, keywords) of FamixOpenApiSpecVersion subclasses.
"
Class {
	#name : 'FamixOpenApiSpecVersionSchemaHooksTest',
	#superclass : 'TestCase',
	#instVars : [
		'swagger2',
		'v30',
		'v31'
	],
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> allVersions [

	^ {
		  swagger2.
		  v30.
		  v31 }
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> node: anAssociationArray [

	^ Dictionary newFrom: anAssociationArray
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> setUp [

	super setUp.
	swagger2 := FamixOpenApiSwagger2Version new.
	v30 := FamixOpenApi30Version new.
	v31 := FamixOpenApi31Version new
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test30IgnoresXNullable [

	self
		assert:
		(v30 isNullableFrom: (self node: { ('x-nullable' -> true) }))
		equals: false
		description: '3.0 x-nullable'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test30NullableFalseIsNotNullable [

	self
		assert: (v30 isNullableFrom: (self node: { ('nullable' -> false) }))
		equals: false
		description: 'nullable false'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test30NullableTrueIsNullable [

	self
		assert: (v30 isNullableFrom: (self node: { ('nullable' -> true) }))
		equals: true
		description: 'nullable true'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test30ServersAreTheDocumentServers [

	| servers result |
	servers := { (self node: {
			            ('url' -> 'https://a.example/v1').
			            ('description' -> 'A') }) }.
	result := v30 serversFrom: (self node: { ('servers' -> servers) }).
	self assert: result size equals: 1 description: 'size'.
	self
		assert: (result first at: 'url')
		equals: 'https://a.example/v1'
		description: 'url'.
	self
		assert: (result first at: 'description')
		equals: 'A'
		description: 'description'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test30ServersEmptyDefaultToSlash [

	self
		assert: (v30 serversFrom: (self node: { ('servers' -> #(  )) }))
		equals: { (self node: { ('url' -> '/') }) }
		description: 'empty'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test31ServersAbsentDefaultToSlash [

	self
		assert: (v31 serversFrom: Dictionary new)
		equals: { (self node: { ('url' -> '/') }) }
		description: 'default'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> test31ServersKeepVariables [

	| vars result |
	vars := self node:
		        { ('port' -> (self node: { ('default' -> '8080') })) }.
	result := v31 serversFrom:
		          (self node: { ('servers' -> { (self node: {
					             ('url' -> 'http://h:{port}').
					             ('variables' -> vars) }) }) }).
	self
		assert: (result first at: 'variables')
		equals: vars
		description: 'variables'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testAbsentExclusiveMaximumKeepsMaximum [

	| node |
	node := self node: { ('maximum' -> 9) }.
	self allVersions do: [ :v |
		self
			assert: (v maximumFrom: node)
			equals: 9
			description: v printString , ' maximum'.
		self
			assert: (v exclusiveMaximumFrom: node)
			equals: nil
			description: v printString , ' exclusive' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testAbsentExclusiveMinimumKeepsMinimum [

	| node |
	node := self node: { ('minimum' -> 5) }.
	self allVersions do: [ :v |
		self
			assert: (v minimumFrom: node)
			equals: 5
			description: v printString , ' minimum'.
		self
			assert: (v exclusiveMinimumFrom: node)
			equals: nil
			description: v printString , ' exclusive' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testBooleanExclusiveMaximumFalseKeepsMaximum [

	| node |
	node := self node: {
			        ('maximum' -> 9).
			        ('exclusiveMaximum' -> false) }.
	self allVersions do: [ :v |
		self
			assert: (v maximumFrom: node)
			equals: 9
			description: v printString , ' maximum'.
		self
			assert: (v exclusiveMaximumFrom: node)
			equals: nil
			description: v printString , ' exclusive' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testBooleanExclusiveMaximumTrueMovesTheBound [

	| node |
	node := self node: {
			        ('maximum' -> 9).
			        ('exclusiveMaximum' -> true) }.
	self allVersions do: [ :v |
		self
			assert: (v exclusiveMaximumFrom: node)
			equals: 9
			description: v printString , ' exclusive'.
		self
			assert: (v maximumFrom: node)
			equals: nil
			description: v printString , ' maximum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testBooleanExclusiveMaximumTrueWithoutMaximumAnswersNils [

	| node |
	node := self node: { ('exclusiveMaximum' -> true) }.
	self allVersions do: [ :v |
		self
			assert: (v exclusiveMaximumFrom: node)
			equals: nil
			description: v printString , ' exclusive'.
		self
			assert: (v maximumFrom: node)
			equals: nil
			description: v printString , ' maximum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testBooleanExclusiveMinimumFalseKeepsMinimum [

	| node |
	node := self node: {
			        ('minimum' -> 5).
			        ('exclusiveMinimum' -> false) }.
	self allVersions do: [ :v |
		self
			assert: (v minimumFrom: node)
			equals: 5
			description: v printString , ' minimum'.
		self
			assert: (v exclusiveMinimumFrom: node)
			equals: nil
			description: v printString , ' exclusive' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testBooleanExclusiveMinimumTrueMovesTheBound [

	| node |
	node := self node: {
			        ('minimum' -> 5).
			        ('exclusiveMinimum' -> true) }.
	self allVersions do: [ :v |
		self
			assert: (v exclusiveMinimumFrom: node)
			equals: 5
			description: v printString , ' exclusive'.
		self
			assert: (v minimumFrom: node)
			equals: nil
			description: v printString , ' minimum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testBooleanExclusiveMinimumTrueWithoutMinimumAnswersNils [

	| node |
	node := self node: { ('exclusiveMinimum' -> true) }.
	self allVersions do: [ :v |
		self
			assert: (v exclusiveMinimumFrom: node)
			equals: nil
			description: v printString , ' exclusive'.
		self
			assert: (v minimumFrom: node)
			equals: nil
			description: v printString , ' minimum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testEmptyNodeHasNoMinimumNorMaximum [

	self allVersions do: [ :v |
		self
			assert: (v minimumFrom: Dictionary new)
			equals: nil
			description: v printString , ' min'.
		self
			assert: (v maximumFrom: Dictionary new)
			equals: nil
			description: v printString , ' max'.
		self
			assert: (v exclusiveMinimumFrom: Dictionary new)
			equals: nil
			description: v printString , ' exMin'.
		self
			assert: (v exclusiveMaximumFrom: Dictionary new)
			equals: nil
			description: v printString , ' exMax' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testExtensionKeyHasXDashPrefix [

	self allVersions do: [ :v |
		self
			assert: (v isExtensionKey: 'x-foo')
			equals: true
			description: v printString , ' x-foo'.
		self
			assert: (v isExtensionKey: 'x-')
			equals: true
			description: v printString , ' x-' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testExtensionKeyIsFalseForNonStrings [

	self
		assert: (v30 isExtensionKey: nil)
		equals: false
		description: 'nil'.
	self
		assert: (v30 isExtensionKey: 42)
		equals: false
		description: 'integer'.
	self
		assert: (v30 isExtensionKey: #( 'x-a' ))
		equals: false
		description: 'array'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testFloatBoundsAreKept [

	self
		assert: (v30 minimumFrom: (self node: { ('minimum' -> 0.5) }))
		equals: 0.5
		description: 'float'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testKeywordSetsAreAvailableOnEveryVersion [

	self allVersions do: [ :v |
		self
			assert: (v schemaKeywords includes: 'type')
			description: v printString , ' type'.
		self
			assert: (v unmodelledSchemaKeywords includes: 'if')
			description: v printString , ' if' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testMappedAndUnmodelledKeywordsAreDisjoint [

	self allVersions do: [ :v |
		self
			assert: (v schemaKeywords select: [ :k |
					 v unmodelledSchemaKeywords includes: k ]) isEmpty
			description: v printString , ' disjoint' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testMinimumAndMaximumAreIndependent [

	| node |
	node := self node: {
			        ('minimum' -> 1).
			        ('exclusiveMinimum' -> true).
			        ('maximum' -> 9) }.
	self assert: (v30 maximumFrom: node) equals: 9 description: 'maximum'.
	self
		assert: (v30 exclusiveMaximumFrom: node)
		equals: nil
		description: 'exclusiveMaximum'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testMissingTypeAnswersEmptyArray [

	self allVersions do: [ :v |
		self
			assert: (v typesFrom: Dictionary new)
			equals: #(  )
			description: v printString ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testNonExtensionKeys [

	self allVersions do: [ :v |
		self assert: (v isExtensionKey: 'x') equals: false description: 'x'.
		self
			assert: (v isExtensionKey: 'type')
			equals: false
			description: 'type'.
		self
			assert: (v isExtensionKey: 'X-foo')
			equals: false
			description: 'X-foo'.
		self
			assert: (v isExtensionKey: '')
			equals: false
			description: 'empty' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testNullableMissingKeysAnswersFalse [

	self allVersions do: [ :v |
		self
			assert: (v isNullableFrom: Dictionary new)
			equals: false
			description: v printString ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testNullableOfEmptyTypeNodeAnswersFalse [

	self allVersions do: [ :v |
		self
			assert: (v isNullableFrom: (self node: { ('type' -> 'string') }))
			equals: false
			description: v printString ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testNumericExclusiveMaximumIsTheExclusiveBound [

	| node |
	node := self node: {
			        ('maximum' -> 20).
			        ('exclusiveMaximum' -> 9) }.
	self allVersions do: [ :v |
		self
			assert: (v exclusiveMaximumFrom: node)
			equals: 9
			description: v printString , ' exclusive'.
		self
			assert: (v maximumFrom: node)
			equals: 20
			description: v printString , ' maximum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testNumericExclusiveMinimumIsTheExclusiveBound [

	| node |
	node := self node: {
			        ('minimum' -> 1).
			        ('exclusiveMinimum' -> 5) }.
	self allVersions do: [ :v |
		self
			assert: (v exclusiveMinimumFrom: node)
			equals: 5
			description: v printString , ' exclusive'.
		self
			assert: (v minimumFrom: node)
			equals: 1
			description: v printString , ' minimum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testNumericExclusiveMinimumWithoutMinimumLeavesMinimumNil [

	self allVersions do: [ :v |
		| node |
		node := self node: { ('exclusiveMinimum' -> 5) }.
		self
			assert: (v exclusiveMinimumFrom: node)
			equals: 5
			description: v printString , ' exclusive'.
		self
			assert: (v minimumFrom: node)
			equals: nil
			description: v printString , ' minimum' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSchemaKeywordsAreSetsOfStrings [

	self
		assert: (v31 schemaKeywords isKindOf: Set)
		description: 'mapped is Set'.
	self
		assert: (v31 unmodelledSchemaKeywords isKindOf: Set)
		description: 'unmodelled is Set'.
	self
		assert: (v31 schemaKeywords allSatisfy: #isString)
		description: 'mapped strings'.
	self
		assert: (v31 unmodelledSchemaKeywords allSatisfy: #isString)
		description: 'unmodelled strings'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSchemaKeywordsContainMappedKeywords [

	#( 'type' 'format' 'title' 'description' 'default' 'enum' 'const'
	   'example' 'required' 'properties' 'items' 'prefixItems'
	   'allOf' 'oneOf' 'anyOf' 'not' 'additionalProperties'
	   'discriminator' 'xml' 'externalDocs' 'readOnly' 'writeOnly'
	   'deprecated' 'nullable' 'minimum' 'maximum' 'exclusiveMinimum'
	   'exclusiveMaximum' 'multipleOf' 'minLength' 'maxLength'
	   'pattern' 'minItems' 'maxItems' 'uniqueItems' 'minProperties'
	   'maxProperties' '$ref' ) do: [ :each |
		self
			assert: (v31 schemaKeywords includes: each)
			description: each , ' is mapped' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSingleStringTypeAnswersOneElementArray [

	self allVersions do: [ :v |
		self
			assert: (v typesFrom: (self node: { ('type' -> 'string') }))
			equals: #( 'string' )
			description: v printString ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2BasePathDefaultsToEmpty [

	| result |
	result := swagger2 serversFrom:
		          (self node: { ('host' -> 'api.example.com') }).
	self
		assert: (result collect: [ :s | s at: 'url' ]) asArray
		equals: #( 'https://api.example.com' )
		description: 'urls'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2HostBasePathAndSchemesGiveOneServerPerScheme [

	| result |
	result := swagger2 serversFrom: (self node: {
				           ('host' -> 'api.example.com').
				           ('basePath' -> '/v1').
				           ('schemes' -> #( 'http' 'https' )) }).
	self
		assert: (result collect: [ :s | s at: 'url' ]) asArray
		equals:
		#( 'http://api.example.com/v1' 'https://api.example.com/v1' )
		description: 'urls'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2IgnoresPlainNullable [

	self
		assert:
		(swagger2 isNullableFrom: (self node: { ('nullable' -> true) }))
		equals: false
		description: 'swagger2 nullable'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2SchemesDefaultToHttps [

	| result |
	result := swagger2 serversFrom: (self node: {
				           ('host' -> 'api.example.com').
				           ('basePath' -> '/v1') }).
	self
		assert: (result collect: [ :s | s at: 'url' ]) asArray
		equals: #( 'https://api.example.com/v1' )
		description: 'urls'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2ServersAreDictionaries [

	(swagger2 serversFrom: (self node: { ('host' -> 'h') })) do: [ :s |
		self assert: (s isKindOf: Dictionary) description: 'dictionary' ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2WithoutHostNorBasePathUsesSlash [

	| result |
	result := swagger2 serversFrom: Dictionary new.
	self
		assert: (result collect: [ :s | s at: 'url' ]) asArray
		equals: #( '/' )
		description: 'urls'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2WithoutHostUsesBasePath [

	| result |
	result := swagger2 serversFrom:
		          (self node: { ('basePath' -> '/v1') }).
	self
		assert: (result collect: [ :s | s at: 'url' ]) asArray
		equals: #( '/v1' )
		description: 'urls'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2XNullableFalseIsNotNullable [

	self
		assert:
		(swagger2 isNullableFrom: (self node: { ('x-nullable' -> false) }))
		equals: false
		description: 'x-nullable false'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testSwagger2XNullableTrueIsNullable [

	self
		assert:
		(swagger2 isNullableFrom: (self node: { ('x-nullable' -> true) }))
		equals: true
		description: 'x-nullable'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testTypeArrayIsKeptWithoutNull [

	self
		assert:
		(v31 typesFrom: (self node: { ('type' -> #( 'string' 'null' )) }))
		equals: #( 'string' )
		description: 'string+null'.
	self
		assert:
		(v31 typesFrom: (self node: { ('type' -> #( 'string' 'integer' )) }))
		equals: #( 'string' 'integer' )
		description: 'two types'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testTypeArrayOfOnlyNullAnswersEmptyArray [

	self
		assert: (v31 typesFrom: (self node: { ('type' -> #( 'null' )) }))
		equals: #(  )
		description: 'only null'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testTypeArrayWithNullIsNullableInEveryVersion [

	self allVersions do: [ :v |
		self
			assert:
			(v isNullableFrom:
				 (self node: { ('type' -> #( 'string' 'null' )) }))
			equals: true
			description: v printString ]
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testTypeArrayWithoutNullIsNotNullable [

	self
		assert: (v31 isNullableFrom:
				 (self node: { ('type' -> #( 'string' 'integer' )) }))
		equals: false
		description: 'no null'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testTypesFromEmptyTypeArrayAnswersEmptyArray [

	self
		assert: (v31 typesFrom: (self node: { ('type' -> #(  )) }))
		equals: #(  )
		description: 'empty array'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionSchemaHooksTest >> testUnmodelledSchemaKeywordsContainUnmodelledKeywords [

	#( '$id' '$schema' '$anchor' '$comment' '$defs' '$dynamicRef'
	   'if' 'then' 'else' 'dependentSchemas' 'dependentRequired'
	   'patternProperties' 'propertyNames' 'contains' 'minContains'
	   'maxContains' 'unevaluatedItems' 'unevaluatedProperties'
	   'contentEncoding' 'contentMediaType' 'contentSchema'
	   'examples' ) do: [ :each |
		self
			assert: (v31 unmodelledSchemaKeywords includes: each)
			description: each , ' is unmodelled' ]
]
