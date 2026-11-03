"
The value check over the 20 files of the external test corpus (the folder is outside the repository: the tests are skipped, like the ones of FamixOpenApiCorpusTest, when it is absent), each file imported with mergesInlineSchemas false. IMPORTANT: the importer is NOT changed by the steps that wrote this test. The expected result is the FROZEN set of #frozenGaps (every gap of the corpus: file, pointer, kind, field, expected, found): a gap that appears or disappears fails the test, so that a real importer finding is never lost or hidden. It is empty: over the 20 files the importer stores in every compared slot what the source says (first run: no false positive and no importer finding). The coverage is asserted too: nothing was left out for a wrong type or for a missing entity, and every comparator was exercised. The mutation sweep changes every slot compared of every file in turn.
"
Class {
	#name : 'FamixOpenApiValueCorpusTest',
	#superclass : 'FamixOpenApiValueTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiValueCorpusTest >> defaultTimeLimit [
	"The sweeps change every slot of the 20 files in turn (about 10 seconds on their own)"

	^ 2 minutes
]

{ #category : 'helpers' }
FamixOpenApiValueCorpusTest >> fieldsWithAValueInTheCorpus [

	"The coverage keys of the table of rules (version, spec object, field, slot) that have a value that is not a default in the 20 files of the corpus: each one must stay compared (a rule that stops comparing, or an importer or a walker that loses the value, is seen here). Frozen on 169 keys"

	^ #(
		'v2 Contact.email -> OPContact>>email'
		'v2 Contact.name -> OPContact>>name'
		'v2 Contact.url -> OPContact>>url'
		'v2 ExternalDocumentation.description -> OPExternalDocumentation>>description'
		'v2 ExternalDocumentation.url -> OPExternalDocumentation>>url'
		'v2 Header.description -> OPHeader>>description'
		'v2 Info.description -> OPInfo>>description'
		'v2 Info.termsOfService -> OPInfo>>termsOfService'
		'v2 Info.title -> OPInfo>>title'
		'v2 Info.version -> OPInfo>>version'
		'v2 License.name -> OPLicense>>name'
		'v2 License.url -> OPLicense>>url'
		'v2 Operation.deprecated -> OPOperation>>deprecated'
		'v2 Operation.description -> OPOperation>>description'
		'v2 Operation.operationId -> OPOperation>>operationId'
		'v2 Operation.security -> OPOperation>>securityRequirements'
		'v2 Operation.summary -> OPOperation>>summary'
		'v2 Operation.tags -> OPOperation>>tagNames'
		'v2 Operation.{key} -> OPOperation>>httpMethod'
		'v2 Parameter.collectionFormat -> OPParameter>>explode'
		'v2 Parameter.collectionFormat -> OPParameter>>style'
		'v2 Parameter.description -> OPParameter>>description'
		'v2 Parameter.description -> OPRequestBody>>description'
		'v2 Parameter.in -> OPParameter>>location'
		'v2 Parameter.name -> OPParameter>>name'
		'v2 Parameter.required -> OPParameter>>required'
		'v2 Parameter.required -> OPRequestBody>>required'
		'v2 PathItem.{key} -> OPPath>>relativePath'
		'v2 Response.description -> OPResponse>>description'
		'v2 Response.{key} -> OPResponse>>statusCode'
		'v2 Schema.default -> OPSchema>>defaultValue'
		'v2 Schema.description -> OPSchema>>description'
		'v2 Schema.enum -> OPSchema>>enumValues'
		'v2 Schema.example -> OPSchema>>exampleValue'
		'v2 Schema.format -> OPSchema>>format'
		'v2 Schema.maximum -> OPSchema>>maximum'
		'v2 Schema.minimum -> OPSchema>>minimum'
		'v2 Schema.required -> OPProperty>>isRequired'
		'v2 Schema.required -> OPSchema>>requiredProperties'
		'v2 Schema.type -> OPSchema>>types'
		'v2 SecurityScheme.authorizationUrl -> OPOAuthFlow>>authorizationUrl'
		'v2 SecurityScheme.flow -> OPOAuthFlow>>flowType'
		'v2 SecurityScheme.in -> OPSecurityScheme>>inLocation'
		'v2 SecurityScheme.name -> OPSecurityScheme>>parameterName'
		'v2 SecurityScheme.scopes -> OPSecurityScope>>description'
		'v2 SecurityScheme.type -> OPSecurityScheme>>type'
		'v2 Swagger.security -> OPOpenApi>>securityRequirements'
		'v2 Swagger.swagger -> OPOpenApi>>sourceVersion'
		'v2 Swagger.tags -> OPOpenApi>>tags'
		'v2 Tag.description -> OPTag>>description'
		'v2 Tag.name -> OPTag>>name'
		'v2 XML.name -> OPXmlElement>>name'
		'v2 XML.wrapped -> OPXmlElement>>wrapped'
		'v30 Contact.email -> OPContact>>email'
		'v30 Contact.name -> OPContact>>name'
		'v30 Contact.url -> OPContact>>url'
		'v30 Example.value -> OPExample>>value'
		'v30 ExternalDocumentation.description -> OPExternalDocumentation>>description'
		'v30 ExternalDocumentation.url -> OPExternalDocumentation>>url'
		'v30 Header.description -> OPHeader>>description'
		'v30 Info.description -> OPInfo>>description'
		'v30 Info.termsOfService -> OPInfo>>termsOfService'
		'v30 Info.title -> OPInfo>>title'
		'v30 Info.version -> OPInfo>>version'
		'v30 License.name -> OPLicense>>name'
		'v30 License.url -> OPLicense>>url'
		'v30 Link.operationId -> OPLink>>operationId'
		'v30 MediaType.example -> OPExample>>value'
		'v30 MediaType.{key} -> OPMediaType>>mediaType'
		'v30 OAuthFlow.authorizationUrl -> OPOAuthFlow>>authorizationUrl'
		'v30 OAuthFlow.scopes -> OPSecurityScope>>description'
		'v30 OAuthFlow.{key} -> OPOAuthFlow>>flowType'
		'v30 OpenAPI.openapi -> OPOpenApi>>sourceVersion'
		'v30 OpenAPI.security -> OPOpenApi>>securityRequirements'
		'v30 OpenAPI.servers -> OPOpenApi>>servers'
		'v30 OpenAPI.tags -> OPOpenApi>>tags'
		'v30 Operation.description -> OPOperation>>description'
		'v30 Operation.operationId -> OPOperation>>operationId'
		'v30 Operation.security -> OPOperation>>securityRequirements'
		'v30 Operation.summary -> OPOperation>>summary'
		'v30 Operation.tags -> OPOperation>>tagNames'
		'v30 Operation.{key} -> OPOperation>>httpMethod'
		'v30 Parameter.allowEmptyValue -> OPParameter>>allowEmptyValue'
		'v30 Parameter.description -> OPParameter>>description'
		'v30 Parameter.example -> OPExample>>value'
		'v30 Parameter.explode -> OPParameter>>explode'
		'v30 Parameter.in -> OPParameter>>location'
		'v30 Parameter.name -> OPParameter>>name'
		'v30 Parameter.required -> OPParameter>>required'
		'v30 Parameter.style -> OPParameter>>style'
		'v30 PathItem.{key} -> OPPath>>relativePath'
		'v30 RequestBody.description -> OPRequestBody>>description'
		'v30 RequestBody.required -> OPRequestBody>>required'
		'v30 Response.$ref -> OPResponse>>ref'
		'v30 Response.description -> OPResponse>>description'
		'v30 Response.{key} -> OPResponse>>statusCode'
		'v30 Schema.default -> OPSchema>>defaultValue'
		'v30 Schema.description -> OPSchema>>description'
		'v30 Schema.enum -> OPSchema>>enumValues'
		'v30 Schema.example -> OPSchema>>exampleValue'
		'v30 Schema.format -> OPSchema>>format'
		'v30 Schema.maxLength -> OPSchema>>maxLength'
		'v30 Schema.minItems -> OPSchema>>minItems'
		'v30 Schema.minLength -> OPSchema>>minLength'
		'v30 Schema.minProperties -> OPSchema>>minProperties'
		'v30 Schema.minimum -> OPSchema>>minimum'
		'v30 Schema.multipleOf -> OPSchema>>multipleOf'
		'v30 Schema.nullable -> OPSchema>>isNullable'
		'v30 Schema.required -> OPProperty>>isRequired'
		'v30 Schema.required -> OPSchema>>requiredProperties'
		'v30 Schema.type -> OPSchema>>types'
		'v30 SecurityScheme.in -> OPSecurityScheme>>inLocation'
		'v30 SecurityScheme.name -> OPSecurityScheme>>parameterName'
		'v30 SecurityScheme.type -> OPSecurityScheme>>type'
		'v30 Server.url -> OPServer>>url'
		'v30 ServerVariable.default -> OPServerVariable>>defaultValue'
		'v30 ServerVariable.description -> OPServerVariable>>description'
		'v30 ServerVariable.enum -> OPServerVariable>>enumValues'
		'v30 Tag.description -> OPTag>>description'
		'v30 Tag.name -> OPTag>>name'
		'v30 XML.name -> OPXmlElement>>name'
		'v30 XML.wrapped -> OPXmlElement>>wrapped'
		'v31 Example.value -> OPExample>>value'
		'v31 Info.description -> OPInfo>>description'
		'v31 Info.title -> OPInfo>>title'
		'v31 Info.version -> OPInfo>>version'
		'v31 MediaType.example -> OPExample>>value'
		'v31 MediaType.{key} -> OPMediaType>>mediaType'
		'v31 OAuthFlow.authorizationUrl -> OPOAuthFlow>>authorizationUrl'
		'v31 OAuthFlow.scopes -> OPSecurityScope>>description'
		'v31 OAuthFlow.tokenUrl -> OPOAuthFlow>>tokenUrl'
		'v31 OAuthFlow.{key} -> OPOAuthFlow>>flowType'
		'v31 OpenAPI.openapi -> OPOpenApi>>sourceVersion'
		'v31 OpenAPI.security -> OPOpenApi>>securityRequirements'
		'v31 OpenAPI.tags -> OPOpenApi>>tags'
		'v31 Operation.description -> OPOperation>>description'
		'v31 Operation.operationId -> OPOperation>>operationId'
		'v31 Operation.security -> OPOperation>>securityRequirements'
		'v31 Operation.summary -> OPOperation>>summary'
		'v31 Operation.tags -> OPOperation>>tagNames'
		'v31 Operation.{key} -> OPOperation>>httpMethod'
		'v31 Parameter.description -> OPParameter>>description'
		'v31 Parameter.in -> OPParameter>>location'
		'v31 Parameter.name -> OPParameter>>name'
		'v31 Parameter.required -> OPParameter>>required'
		'v31 PathItem.{key} -> OPPath>>relativePath'
		'v31 RequestBody.description -> OPRequestBody>>description'
		'v31 RequestBody.required -> OPRequestBody>>required'
		'v31 Response.description -> OPResponse>>description'
		'v31 Response.{key} -> OPResponse>>statusCode'
		'v31 Schema.description -> OPSchema>>description'
		'v31 Schema.enum -> OPSchema>>enumValues'
		'v31 Schema.example -> OPSchema>>exampleValue'
		'v31 Schema.format -> OPSchema>>format'
		'v31 Schema.maxItems -> OPSchema>>maxItems'
		'v31 Schema.maxLength -> OPSchema>>maxLength'
		'v31 Schema.maximum -> OPSchema>>maximum'
		'v31 Schema.minItems -> OPSchema>>minItems'
		'v31 Schema.minimum -> OPSchema>>minimum'
		'v31 Schema.required -> OPProperty>>isRequired'
		'v31 Schema.required -> OPSchema>>requiredProperties'
		'v31 Schema.type -> OPSchema>>types'
		'v31 SecurityScheme.bearerFormat -> OPSecurityScheme>>bearerFormat'
		'v31 SecurityScheme.description -> OPSecurityScheme>>description'
		'v31 SecurityScheme.in -> OPSecurityScheme>>inLocation'
		'v31 SecurityScheme.name -> OPSecurityScheme>>parameterName'
		'v31 SecurityScheme.scheme -> OPSecurityScheme>>scheme'
		'v31 SecurityScheme.type -> OPSecurityScheme>>type'
		'v31 Tag.name -> OPTag>>name' )
]

{ #category : 'helpers' }
FamixOpenApiValueCorpusTest >> frozenGaps [
	"Rows: file name, pointer, kind, field, expected, found. Empty: the importer stores in every slot compared what the source says. The importer was not changed to get there"

	^ #(  )
]

{ #category : 'helpers' }
FamixOpenApiValueCorpusTest >> mutationFileNames [
	"One file per version: a Swagger 2, an OpenAPI 3.0 and an OpenAPI 3.1 document"

	^ #( 'petstore-swagger2.json' 'petstore-openapi3.json'
	     'oai-learn-v3.1-tictactoe.json' )
]

{ #category : 'helpers' }
FamixOpenApiValueCorpusTest >> reportOfFile: aFile [
	"The report of the value check of aFile imported without merging"

	^ (FamixOpenApiValueCheck new
		   file: aFile basename;
		   yourself)
		  checkInventory: (self inventoryOf: aFile contents)
		  model: (self modelOf: aFile contents)
]

{ #category : 'helpers' }
FamixOpenApiValueCorpusTest >> reports [
	"Associations file name -> report, for every spec file of the corpus"

	^ self specFiles collect: [ :file |
		  file basename -> (self reportOfFile: file) ]
]

{ #category : 'helpers' }
FamixOpenApiValueCorpusTest >> specFiles [
	"The corpus files that are API descriptions. Skips the running test when the corpus folder is absent"

	^ FamixOpenApiExistenceCorpusTest new specFiles
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testCorpusHasTheTwentyFilesAndTheCheckComparesThem [

	| reports coverage |
	reports := self reports.
	self assert: reports size equals: 20.
	coverage := FamixOpenApiCoverage new.
	reports do: [ :each | coverage mergeWith: each value coverage ].
	self assert: coverage totalCompared > 40000.
	self assert: coverage totalInformative > 7000.
	self assert: coverage sortedKeys size > 200
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testCorpusValueGapsAreExactlyTheFrozenOnes [

	| actual |
	actual := Array streamContents: [ :stream |
		          self reports do: [ :each |
			          each value gaps do: [ :gap |
				          stream nextPut: {
						          each key.
						          gap sourcePointer.
						          gap kind.
						          gap fieldKey.
						          gap expected.
						          gap found } ] ] ].
	self assert: actual asSet equals: self frozenGaps asSet.
	self assert: actual size equals: self frozenGaps size
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testEveryFieldThatHasAValueInTheCorpusIsStillCompared [
	"A conservative lower bound, not the exact totals: every field of the table with a value that is not a default in the files of the corpus keeps a count of values compared and of values not default above 0, and the totals do not fall under the ones of V8 (46642 compared, 7751 not default)"

	| coverage |
	coverage := FamixOpenApiCoverage new.
	self reports do: [ :each | coverage mergeWith: each value coverage ].
	self fieldsWithAValueInTheCorpus do: [ :key |
		self
			assert: (coverage comparedCountOf: key) > 0
			description: ('{1} is not compared' format: { key }).
		self
			assert: (coverage informativeCountOf: key) > 0
			description:
			('{1} has no value that is not a default' format: { key }) ].
	self assert: self fieldsWithAValueInTheCorpus size equals: 169.
	self assert: coverage totalCompared >= 46000.
	self assert: coverage totalInformative >= 7500
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testEveryFileOfTheCorpusIsComparedWithoutPrecondition [

	self reports do: [ :each |
		self assert: (each value gapsOfKind: #preconditionMerged) isEmpty.
		self assert: (each value gapsOfKind: #preconditionVersion) isEmpty ]
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testEverySlotOfEveryFileOfTheCorpusIsDetectedWhenItIsChanged [

	| changed |
	changed := self specFiles inject: 0 into: [ :sum :each |
		           sum
		           +
		           (self
			            assertValueSweepIn: each contents
			            named: each basename) ].
	self assert: changed > 40000
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testEverySlotOfThreeFilesOfTheCorpusIsDetectedWhenItIsChanged [

	| changed |
	changed := (self specFiles select: [ :each |
		            self mutationFileNames includes: each basename ])
		           inject: 0
		           into: [ :sum :each |
			           sum
			           +
			           (self
				            assertValueSweepIn: each contents
				            named: each basename) ].
	self assert: changed > 4000
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testNothingOfTheCorpusIsLeftOutForAWrongTypeOrAMissingEntity [

	self reports do: [ :each |
		each value coverage sortedKeys do: [ :key |
			self assert: (each value coverage wrongTypeCountOf: key) equals: 0.
			self
				assert: (each value coverage withoutEntityCountOf: key)
				equals: 0 ] ]
]

{ #category : 'tests' }
FamixOpenApiValueCorpusTest >> testTheKeysBesideARefThatTheImporterIgnoresAreCountedNotCompared [
	"VERIFIED: the corpus has some (the description of the $ref of instagram, the xml of the petstore of Swagger 2): the check does not compare them and has no gap for them"

	| ignored |
	ignored := self reports
		           inject: 0
		           into: [ :sum :each |
		           sum + each value coverage totalIgnoredSiblings ].
	self assert: ignored > 0
]
