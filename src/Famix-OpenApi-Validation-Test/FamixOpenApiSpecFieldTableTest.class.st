"
I test FamixOpenApiSpecFieldTable: integrity of the data (no duplicates, valid kinds, levels and versions), presence of every spec object per version, spot checks of known facts of the specifications, exact counts per version and level, and the query API.
"
Class {
	#name : 'FamixOpenApiSpecFieldTableTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiSpecFieldTableTest >> fieldNamesOf: aSpecObjectName in: aVersionSymbol [

	^ (FamixOpenApiSpecFieldTable
		   fieldsFor: aSpecObjectName
		   in: aVersionSymbol) collect: #name
]

{ #category : 'helpers' }
FamixOpenApiSpecFieldTableTest >> levelCountsIn: aVersionSymbol [

	^ FamixOpenApiSpecField validLevels collect: [ :level |
		  (FamixOpenApiSpecFieldTable fieldsAt: level in: aVersionSymbol)
			  size ]
]

{ #category : 'helpers' }
FamixOpenApiSpecFieldTableTest >> objectNamesOf3x [

	^ #( 'OpenAPI' 'Info' 'Contact' 'License' 'Server' 'ServerVariable'
	     'Components' 'Paths' 'PathItem' 'Operation' 'ExternalDocumentation'
	     'Parameter' 'RequestBody' 'MediaType' 'Encoding' 'Responses'
	     'Response' 'Callback' 'Example' 'Link' 'Header' 'Tag' 'Reference'
	     'Schema' 'Discriminator' 'XML' 'SecurityScheme' 'OAuthFlows'
	     'OAuthFlow' 'SecurityRequirement' )
]

{ #category : 'helpers' }
FamixOpenApiSpecFieldTableTest >> objectNamesOfSwagger2 [

	^ #( 'Swagger' 'Info' 'Contact' 'License' 'Paths' 'PathItem'
	     'Operation' 'ExternalDocumentation' 'Parameter' 'Responses'
	     'Response' 'Example' 'Header' 'Items' 'Tag' 'Reference'
	     'Schema' 'XML' 'SecurityScheme' 'Scopes' 'SecurityRequirement' )
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testAllFieldsAnswersSpecFields [

	self assert:
		(FamixOpenApiSpecFieldTable allFields allSatisfy: [ :each |
			 each isKindOf: FamixOpenApiSpecField ])
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testCollectionFormatMultiOnlyOnParameter [

	| note |
	note := [ :object |
	        ((FamixOpenApiSpecFieldTable fieldsFor: object in: #v2)
		         detect: [ :each | each name = 'collectionFormat' ]) note ].
	self assert: ((note value: 'Parameter') includesSubstring: 'multi').
	self assert:
		((note value: 'Header') includesSubstring: 'not on Header').
	self assert:
		((note value: 'Items') includesSubstring: 'not on Header')
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testConditionallyRequiredNotesStateTheCondition [

	| fields |
	fields := FamixOpenApiSpecFieldTable allFields select: [ :each |
		          each note beginsWith: 'conditionally required' ].
	self assert: fields isNotEmpty.
	fields do: [ :each |
		self assert: each isRequired.
		self assert: (each note beginsWith: 'conditionally required: ') ]
]

{ #category : 'tests - integrity' }
FamixOpenApiSpecFieldTableTest >> testEveryRequiredFieldIsStructuralOrUseful [

	FamixOpenApiSpecFieldTable allFields do: [ :field |
		field isRequired ifTrue: [ self deny: field level equals: #metadata ] ]
]

{ #category : 'tests - integrity' }
FamixOpenApiSpecFieldTableTest >> testEveryRowHasBooleanRequiredAndStringNote [

	FamixOpenApiSpecFieldTable allFields do: [ :field |
		self assert: (field isRequired isKindOf: Boolean).
		self assert: field note isString.
		self assert: field name isString ]
]

{ #category : 'tests - integrity' }
FamixOpenApiSpecFieldTableTest >> testEveryRowHasValidKindLevelAndVersions [

	FamixOpenApiSpecFieldTable allFields do: [ :field |
		self assert: field hasValidKind description: field printString.
		self assert: field hasValidLevel description: field printString.
		self assert: field hasValidVersions description: field printString ]
]

{ #category : 'tests - counts' }
FamixOpenApiSpecFieldTableTest >> testFieldCountPerLevelInOpenApi30 [
	"structural, useful, metadata"

	self assert: (self levelCountsIn: #v30) equals: #( 118 60 27 )
]

{ #category : 'tests - counts' }
FamixOpenApiSpecFieldTableTest >> testFieldCountPerLevelInOpenApi31 [

	self assert: (self levelCountsIn: #v31) equals: #( 139 65 35 )
]

{ #category : 'tests - counts' }
FamixOpenApiSpecFieldTableTest >> testFieldCountPerLevelInSwagger2 [

	self assert: (self levelCountsIn: #v2) equals: #( 123 41 18 )
]

{ #category : 'tests - counts' }
FamixOpenApiSpecFieldTableTest >> testFieldCountPerVersion [

	self
		assert: (FamixOpenApiSpecFieldTable fieldsIn: #v30) size
		equals: 205.
	self
		assert: (FamixOpenApiSpecFieldTable fieldsIn: #v31) size
		equals: 239.
	self
		assert: (FamixOpenApiSpecFieldTable fieldsIn: #v2) size
		equals: 182
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testFieldsAtLevelAnswersOnlyThatLevel [

	(FamixOpenApiSpecFieldTable fieldsAt: #metadata in: #v31) do: [ :each |
		self assert: each level equals: #metadata.
		self assert: (each appliesIn: #v31) ]
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testFieldsForAnswersOnlyThatObjectAndVersion [

	| fields |
	fields := FamixOpenApiSpecFieldTable fieldsFor: 'Info' in: #v30.
	self assert: (fields allSatisfy: [ :each |
			 each specObject = 'Info' and: [ each appliesIn: #v30 ] ]).
	self
		assert: (fields collect: #name)
		equals:
			#( 'title' 'description' 'termsOfService' 'contact' 'license'
			   'version' 'x-*' )
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testFieldsForUnknownObjectIsEmpty [

	self assert:
		(FamixOpenApiSpecFieldTable fieldsFor: 'Nope' in: #v30) isEmpty
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testInfoSummaryOnlyIn31 [

	self assert:
		((self fieldNamesOf: 'Info' in: #v31) includes: 'summary').
	self deny: ((self fieldNamesOf: 'Info' in: #v30) includes: 'summary').
	self deny: ((self fieldNamesOf: 'Info' in: #v2) includes: 'summary')
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testLevelOfAbsentFieldIsNil [

	self assert: (FamixOpenApiSpecFieldTable
			 levelOf: 'Schema'
			 field: 'nullable'
			 in: #v31) isNil.
	self assert:
		(FamixOpenApiSpecFieldTable levelOf: 'Nope' field: 'x' in: #v2)
			isNil
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testLevelOfKnownFields [

	self
		assert:
		(FamixOpenApiSpecFieldTable levelOf: 'Schema' field: 'type' in: #v30)
		equals: #structural.
	self
		assert: (FamixOpenApiSpecFieldTable
				 levelOf: 'Schema'
				 field: 'description'
				 in: #v31)
		equals: #useful.
	self
		assert: (FamixOpenApiSpecFieldTable
				 levelOf: 'Schema'
				 field: '$comment'
				 in: #v31)
		equals: #metadata.
	self
		assert:
		(FamixOpenApiSpecFieldTable levelOf: 'Info' field: 'x-*' in: #v2)
		equals: #metadata
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testLicenseIdentifierOnlyIn31 [

	self assert:
		((self fieldNamesOf: 'License' in: #v31) includes: 'identifier').
	self deny:
		((self fieldNamesOf: 'License' in: #v30) includes: 'identifier').
	self deny:
		((self fieldNamesOf: 'License' in: #v2) includes: 'identifier')
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testLinkHasOperationRef [

	self assert:
		((self fieldNamesOf: 'Link' in: #v30) includes: 'operationRef').
	self assert:
		((self fieldNamesOf: 'Link' in: #v31) includes: 'operationRef')
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testMarkdownLineEndings [

	| markdown lines |
	markdown := FamixOpenApiSpecFieldTable markdownSummary.
	self deny: (markdown includes: Character cr).
	self assert: (markdown includes: Character lf).
	lines := markdown lines.
	self
		assert: (lines count: [ :line | line beginsWith: '# ' ])
		equals: 1.
	self
		assert: (lines count: [ :line | line beginsWith: '## ' ])
		equals: 3.
	self
		assert: (lines count: [ :line | line beginsWith: '### ' ])
		equals: 81.
	self
		assert:
		(lines count: [ :line |
			 line = '| field | kind | level | R | note |' ])
		equals: 81.
	self
		assert: (lines count: [ :line | line = '|---|---|---|---|---|' ])
		equals: 81
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testMarkdownSummary [

	| markdown |
	markdown := FamixOpenApiSpecFieldTable markdownSummary.
	self assert: markdown isString.
	self assert: (markdown includesSubstring: '## OpenAPI 3.0.3').
	self assert: (markdown includesSubstring: '## OpenAPI 3.1.x').
	self assert: (markdown includesSubstring: '## Swagger 2.0').
	self assert: (markdown includesSubstring: '### Schema').
	self assert:
		(markdown includesSubstring: '| field | kind | level | R | note |').
	self assert: (markdown includesSubstring:
			 '| `prefixItems` | array | structural |  |  |')
]

{ #category : 'tests - integrity' }
FamixOpenApiSpecFieldTableTest >> testNoDuplicateSpecObjectNameVersionTriples [

	| triples |
	triples := FamixOpenApiSpecFieldTable allFields flatCollect: [ :field |
		           field versions collect: [ :version |
			           {
				           field specObject.
				           field name.
				           version } ] ].
	self assert: triples asSet size equals: triples size
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testNullableOnlyInSchema30 [

	self assert:
		((self fieldNamesOf: 'Schema' in: #v30) includes: 'nullable').
	self deny:
		((self fieldNamesOf: 'Schema' in: #v31) includes: 'nullable').
	self deny:
		((self fieldNamesOf: 'Schema' in: #v2) includes: 'nullable')
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testObjectNamesHaveNoDuplicates [

	FamixOpenApiSpecFieldTable versions do: [ :version |
		| names |
		names := FamixOpenApiSpecFieldTable objectNamesIn: version.
		self assert: names asSet size equals: names size ]
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testOpenApiRootPathsAndWebhooks [

	self assert:
		((self fieldNamesOf: 'OpenAPI' in: #v31) includes: 'webhooks').
	self deny:
		((self fieldNamesOf: 'OpenAPI' in: #v30) includes: 'webhooks').
	self assert:
		((self fieldNamesOf: 'OpenAPI' in: #v31) includes:
			 'jsonSchemaDialect')
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testParameter2HasCollectionFormat [

	self assert:
		((self fieldNamesOf: 'Parameter' in: #v2) includes:
			 'collectionFormat').
	self deny: ((self fieldNamesOf: 'Parameter' in: #v30) includes:
			 'collectionFormat')
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testPathItemTraceOnlyIn3x [

	self assert:
		((self fieldNamesOf: 'PathItem' in: #v30) includes: 'trace').
	self assert:
		((self fieldNamesOf: 'PathItem' in: #v31) includes: 'trace').
	self deny:
		((self fieldNamesOf: 'PathItem' in: #v2) includes: 'trace')
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testPrefixItemsOnlyInSchema31 [

	self assert:
		((self fieldNamesOf: 'Schema' in: #v31) includes: 'prefixItems').
	self deny:
		((self fieldNamesOf: 'Schema' in: #v30) includes: 'prefixItems').
	self deny:
		((self fieldNamesOf: 'Schema' in: #v2) includes: 'prefixItems')
]

{ #category : 'tests - integrity' }
FamixOpenApiSpecFieldTableTest >> testReferenceAndSecurityRequirementHaveNoExtensions [

	FamixOpenApiSpecFieldTable versions do: [ :version |
		self deny:
			((self fieldNamesOf: 'Reference' in: version) includes: 'x-*').
		self deny:
			((self fieldNamesOf: 'SecurityRequirement' in: version) includes:
				 'x-*') ]
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testRequestBodyOnlyIn3x [

	self assert:
		(FamixOpenApiSpecFieldTable fieldsFor: 'RequestBody' in: #v2)
			isEmpty.
	self assert:
		((self fieldNamesOf: 'Operation' in: #v2) includes: 'requestBody')
			not
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testRequiredFlagAndNote [

	| field |
	field := (FamixOpenApiSpecFieldTable fieldsFor: 'Parameter' in: #v2)
		         detect: [ :each | each name = 'schema' ].
	self assert: field isRequired.
	self assert: (field note beginsWith: 'conditionally required:').
	self assert: field kind equals: #object
]

{ #category : 'tests - counts' }
FamixOpenApiSpecFieldTableTest >> testRowCountIsTotalOfRows [

	self assert: FamixOpenApiSpecFieldTable allFields size equals: 327
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testSchemaExclusiveMinimumExistsInEveryVersion [

	FamixOpenApiSpecFieldTable versions do: [ :version |
		self
			assert: (FamixOpenApiSpecFieldTable
					 levelOf: 'Schema'
					 field: 'exclusiveMinimum'
					 in: version)
			equals: #structural ]
]

{ #category : 'tests - objects' }
FamixOpenApiSpecFieldTableTest >> testSpecObjectsOfOpenApi30 [

	self
		assert: (FamixOpenApiSpecFieldTable objectNamesIn: #v30) sorted
		equals: self objectNamesOf3x sorted
]

{ #category : 'tests - objects' }
FamixOpenApiSpecFieldTableTest >> testSpecObjectsOfOpenApi31 [

	self
		assert: (FamixOpenApiSpecFieldTable objectNamesIn: #v31) sorted
		equals: self objectNamesOf3x sorted
]

{ #category : 'tests - objects' }
FamixOpenApiSpecFieldTableTest >> testSpecObjectsOfSwagger2 [

	self
		assert: (FamixOpenApiSpecFieldTable objectNamesIn: #v2) sorted
		equals: self objectNamesOfSwagger2 sorted
]

{ #category : 'tests - integrity' }
FamixOpenApiSpecFieldTableTest >> testSpecificationExtensionsAreMetadata [

	FamixOpenApiSpecFieldTable allFields
		select: [ :each | each name = 'x-*' ]
		thenDo: [ :field |
			self assert: field level equals: #metadata.
			self assert: field kind equals: #any.
			self deny: field isRequired ]
]

{ #category : 'tests - spot checks' }
FamixOpenApiSpecFieldTableTest >> testSwaggerRootHasHostBasePathAndSchemes [

	| names |
	names := self fieldNamesOf: 'Swagger' in: #v2.
	self assert: (names includesAll: #( 'host' 'basePath' 'schemes' )).
	self assert:
		(FamixOpenApiSpecFieldTable fieldsFor: 'Swagger' in: #v30) isEmpty
]

{ #category : 'tests - api' }
FamixOpenApiSpecFieldTableTest >> testVersions [

	self
		assert: FamixOpenApiSpecFieldTable versions
		equals: #( v30 v31 v2 )
]
