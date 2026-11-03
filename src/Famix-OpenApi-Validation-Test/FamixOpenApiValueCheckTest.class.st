"
Tests of the value check (V8) on small documents of the right version: for each comparator the real import has no gap (the importer stores what the source says: the expected values are frozen as literals, so they are what the importer builds), and a slot changed in the model is a #valueMismatch with the expected and the found value; the absent-key defaults, type and nullable of 3.0 and 3.1, the moved bounds, JSON text, whole floats, unicode, the clones, the conversions of Swagger 2, the counts, the preconditions and the coverage. The mutation sweeps are in FamixOpenApiValueSweepTest.
"
Class {
	#name : 'FamixOpenApiValueCheckTest',
	#superclass : 'FamixOpenApiValueTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testAClonedResponseIsComparedWithItsTargetAndKeepsTheTextOfTheRef [
	"The clone of a $ref response reads the target again at the site: the description is the one of the target"

	| pointer gaps |
	pointer := '#/paths/~1p~1{id}/get/responses/default'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'description'
				 class: 'OPResponse'
				 in: self documentValues30)
		equals: 'rd'.
	self
		assert: (self
				 expectedAt: pointer
				 field: '$ref'
				 class: 'OPResponse'
				 in: self documentValues30)
		equals: '#/components/responses/R'.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPResponse at: pointer in: model)
			        description: 'other';
			        ref: nil ].
	self
		assert: (gaps collect: #fieldKey) asSet
		equals: #( 'description' '$ref' ) asSet.
	self assert: (gaps collect: #ruleName) asSet equals: #( nil ) asSet
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testADefaultThatIsNullIsTheTextNullAndNotAnAbsentDefault [

	| json |
	json := self documentValues31.
	self
		assert: (self
				 expectedAt: '#/paths/~1b/get/parameters/0/schema'
				 field: 'default'
				 class: 'OPSchema'
				 in: json)
		equals: 'null'.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self
					  entity: OPSchema
					  at: '#/paths/~1b/get/parameters/0/schema'
					  in: model) defaultValue: nil ])
		field: 'default'
		expected: 'null'
		found: nil
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testADocumentOfUnknownVersionIsAPrecondition [

	| report |
	report := self valueReportOf: '{}'.
	self
		assert: (report gaps collect: #kind) asArray
		equals: #( #preconditionVersion )
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testADroppedTextIsAGap [

	| gaps |
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPInfo at: '#/info' in: model) description:
			        nil ].
	self
		assertOneGap: gaps
		field: 'description'
		expected: 'd'
		found: nil
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testAFlagAbsentOrFalseIsTheSameAsNilOrFalseInTheSlot [

	| json |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"deprecated":false,"responses":{"200":{"description":"d"}}},"put":{"responses":{"200":{"description":"d"}}}}}}'.
	self assertFaithfulValues: json.
	self assert: (self valueGapsOf: json after: [ :model |
			 (self entity: OPOperation at: '#/paths/~1p/get' in: model)
				 deprecated: nil.
			 (self entity: OPOperation at: '#/paths/~1p/put' in: model)
				 deprecated: false ]) isEmpty
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testAFlagThatIsNotABooleanInTheSourceIsNotComparedAndCounted [

	| json report |
	json := '{"openapi":"3.0.3","info":{"title":5,"version":"1"},"paths":{"/p":{"get":{"deprecated":"yes","responses":{"200":{"description":"d"}}}}}}'.
	report := self valueReportOf: json.
	self assert: report gaps isEmpty.
	self
		assert: (report coverage wrongTypeCountOf:
				 'v30 Operation.deprecated -> OPOperation>>deprecated')
		equals: 1.
	self
		assert:
		(report coverage wrongTypeCountOf: 'v30 Info.title -> OPInfo>>title')
		equals: 1.
	self
		assert: (report coverage comparedCountOf:
				 'v30 Operation.deprecated -> OPOperation>>deprecated')
		equals: 0
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testAFlagThatIsTrueInTheSlotButNotInTheSourceIsAGapAndTheOtherWayRound [

	self
		assertOneGap:
			(self valueGapsOf: self documentValues30 after: [ :model |
				 (self entity: OPOperation at: '#/paths/~1p~1{id}/get' in: model)
					 deprecated: false ])
		field: 'deprecated'
		expected: true
		found: false.
	self
		assertOneGap:
			(self valueGapsOf: self documentValues30 after: [ :model |
				 (self entity: OPParameter at: self pointerOfParameter in: model)
					 deprecated: true ])
		field: 'deprecated'
		expected: false
		found: true
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testAFormRequestBodyWithoutRequiredParameterIsNotRequired [

	| json |
	json := '{"swagger":"2.0","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"c","in":"formData","type":"string"}],"responses":{"200":{"description":"d"}}}}}}'.
	self assertFaithfulValues: json.
	self
		assert: (self
				 expectedAt: '#/paths/~1p/get/requestBody'
				 field: 'parameters'
				 class: 'OPRequestBody'
				 in: json)
		equals: false
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testAMissingElementOfARelationIsACountMismatch [

	| gaps |
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        | root |
		        root := self entity: OPOpenApi at: '#' in: model.
		        root tags remove: root tags first ].
	self assert: gaps size equals: 1.
	self assert: gaps first kind equals: #countMismatch.
	self assert: gaps first fieldKey equals: 'tags'.
	self assert: gaps first expected equals: 1.
	self assert: gaps first found equals: 0
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testAModelImportedWithTheInlineSchemasMergedIsAPrecondition [

	| doc report |
	doc := FamixOpenApiValidatorTestCase new richDocument.
	report := FamixOpenApiValueCheck
		          checkInventory: (self inventoryOf: doc)
		          model: (self modelOf: doc merging: true).
	self
		assert: (report gaps collect: #kind) asArray
		equals: #( #preconditionMerged ).
	self assert:
		(report gaps first message includesSubstring: 'mergesInlineSchemas').
	self assert: report coverage isEmpty
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testAPathWithATildeIsUnescapedAndAWrongStatusCodeIsAGap [

	| json |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/a~b":{"get":{"responses":{"2XX":{"description":"d"}}}}}}'.
	self assertFaithfulValues: json.
	self
		assert: (self
				 expectedAt: '#/paths/~1a~0b'
				 field: '{key}'
				 class: 'OPPath'
				 in: json)
		equals: '/a~b'.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self
					  entity: OPResponse
					  at: '#/paths/~1a~0b/get/responses/2XX'
					  in: model) statusCode: '200' ])
		field: '{key}'
		expected: '2XX'
		found: '200'
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testAPropertyThatIsNotInTheRequiredArrayIsNotRequired [

	| json gaps |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{},"components":{"schemas":{"S":{"type":"object","required":["a"],"properties":{"a":{"type":"string"},"b":{"type":"string"}}}}}}'.
	self assertFaithfulValues: json.
	self
		assert: (self
				 expectedAt: '#/components/schemas/S/properties/b'
				 field: 'required'
				 class: 'OPProperty'
				 in: json)
		equals: false.
	gaps := self valueGapsOf: json after: [ :model |
		        (self
			         entity: OPProperty
			         at: '#/components/schemas/S/properties/b'
			         in: model) isRequired: true ].
	self
		assertOneGap: gaps
		field: 'required'
		expected: false
		found: true
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testAReferenceThatIsNotAStringIsAnObjectOfItsOwnAndGivesNoGap [
	"The importer reads the parameters (and the response) whose $ref is not a string as objects of their own, and their keys are compared"

	| report |
	self assertFaithfulValues: self documentSwagger2NonStringReferences.
	report := self valueReportOf:
		          self documentSwagger2NonStringReferences.
	self
		assert: (report coverage comparedCountOf:
				 'v2 Parameter.description -> OPRequestBody>>description')
		equals: 1
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testASwagger2ParameterThatHasAlsoASchemaTakesItsTypedKeys [

	self assertFaithfulValues: self documentSwagger2ParameterWithSchema.
	self
		assert: (self
				 expectedAt: '#/paths/~1p/get/parameters/0/schema'
				 field: 'type'
				 class: 'OPSchema'
				 in: self documentSwagger2ParameterWithSchema)
		equals: #( 'string' )
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testATextIsComparedExactlyUnicodeIncluded [

	| gaps |
	self
		assert: (self
				 expectedAt: '#/info'
				 field: 'title'
				 class: 'OPInfo'
				 in: self documentValues30)
		equals: 'Tëst → API'.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPInfo at: '#/info' in: model) title:
			        'Tëst -> API' ].
	self
		assertOneGap: gaps
		field: 'title'
		expected: 'Tëst → API'
		found: 'Tëst -> API'.
	self assert: gaps first sourcePointer equals: '#/info'.
	self assert: gaps first specObject equals: 'Info'.
	self assert: gaps first entity class equals: OPInfo
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testAWholeFloatInTheSourceIsTheSameNumberAsTheIntegerOfTheSlot [

	| pointer |
	pointer := '#/paths/~1b/get/parameters/0/schema'.
	self assert:
		(self valueGapsOf: self documentValues31 after: [ :model |
			 (self entity: OPSchema at: pointer in: model)
				 minimum: 1;
				 maximum: 20.0 ]) isEmpty.
	self
		assertOneGap: (self
				 valueGapsOf: self documentValues31
				 after: [ :model |
				 (self entity: OPSchema at: pointer in: model) minimum: 2 ])
		field: 'minimum'
		expected: 1
		found: 2
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testAnAbsentTextIsExpectedNilAndAValueTheSourceDoesNotHaveIsAGap [

	| json gaps |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{}}'.
	self assertFaithfulValues: json.
	gaps := self valueGapsOf: json after: [ :model |
		        (self entity: OPInfo at: '#/info' in: model)
			        termsOfService: 'http://invented' ].
	self
		assertOneGap: gaps
		field: 'termsOfService'
		expected: nil
		found: 'http://invented'
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testAnAliasSchemaAndASchemaWithSiblingsKeepTheRef [

	| json |
	json := self documentValues31.
	self
		assert: (self
				 expectedAt: '#/components/schemas/T'
				 field: '$ref'
				 class: 'OPSchema'
				 in: json)
		equals: '#/components/schemas/S'.
	self
		assert: (self
				 expectedAt:
				 '#/paths/~1b/get/requestBody/content/application~1vnd.api+json/schema'
				 field: '$ref'
				 class: 'OPSchema'
				 in: json)
		equals: '#/components/schemas/S'.
	self
		assert: (self
				 expectedAt:
				 '#/paths/~1b/get/requestBody/content/application~1vnd.api+json/schema'
				 field: 'title'
				 class: 'OPSchema'
				 in: json)
		equals: 'T31'.
	self
		assert: (self
				 expectedAt:
				 '#/paths/~1b/get/requestBody/content/application~1vnd.api+json/schema'
				 field: 'description'
				 class: 'OPSchema'
				 in: json)
		equals: 'sib31'
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testAnEntityThatIsMissingIsCountedAsWithoutEntityAndNotReported [
	"The existence check reports it"

	| json report model |
	json := self documentValues30.
	model := self modelOf: json.
	model remove: (self entity: OPInfo at: '#/info' in: model).
	report := FamixOpenApiValueCheck
		          checkInventory: (self inventoryOf: json)
		          model: model.
	self assert: report gaps isEmpty.
	self
		assert: (report coverage withoutEntityCountOf:
				 'v30 Info.title -> OPInfo>>title')
		equals: 1.
	self
		assert:
		(report coverage comparedCountOf: 'v30 Info.title -> OPInfo>>title')
		equals: 0
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testAnExtraElementOfARelationIsACountMismatch [

	| gaps |
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        | operation |
		        operation := self
			                     entity: OPOperation
			                     at: '#/paths/~1p~1{id}/get'
			                     in: model.
		        operation addSecurityRequirement: OPSecurityRequirement new ].
	self assert: gaps size equals: 1.
	self assert: gaps first kind equals: #countMismatch.
	self assert: gaps first expected equals: 1.
	self assert: gaps first found equals: 2
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testEnumDefaultAndExampleAreJsonTextComparedStructurally [

	| pointer gaps |
	pointer := self pointerOfParameterSchema.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'enum'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: '["x",{"k":[1,2.5]},null]'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'example'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: '{"b":1}'.
	self assert:
		(self valueGapsOf: self documentValues30 after: [ :model |
			 (self entity: OPSchema at: pointer in: model)
				 enumValues: '[ "x" , { "k" : [ 1.0 , 2.5 ] } , null ]';
				 exampleValue: '{ "b" : 1 }' ]) isEmpty.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPSchema at: pointer in: model) enumValues:
			        '["x",{"k":[1,3]},null]' ].
	self
		assertOneGap: gaps
		field: 'enum'
		expected: '["x",{"k":[1,2.5]},null]'
		found: '["x",{"k":[1,3]},null]'
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testRequiredPropertiesOfTheSchemaAndOfItsProperties [

	| pointer gaps |
	pointer := self pointerOfParameterSchema.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'required'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: #( 'z' ).
	self
		assert: (self
				 expectedAt: pointer , '/properties/z'
				 field: 'required'
				 class: 'OPProperty'
				 in: self documentValues30)
		equals: true.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self
			         entity: OPProperty
			         at: pointer , '/properties/z'
			         in: model) isRequired: false ].
	self
		assertOneGap: gaps
		field: 'required'
		expected: true
		found: false.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPSchema at: pointer in: model)
			        requiredProperties: #( 'z' 'y' ) ].
	self
		assertOneGap: gaps
		field: 'required'
		expected: #( 'z' )
		found: #( 'z' 'y' )
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheBadDocumentsGiveNoMismatchBecauseTheWrongValuesAreNotCompared [

	| report |
	report := self valueReportOf:
		          (self documentsBad detect: [ :each |
			           each key = 'wrongTypes30' ]) value.
	self assert: report gaps isEmpty.
	self
		assert: (report coverage wrongTypeCountOf:
				 'v30 Schema.required -> OPSchema>>requiredProperties')
		equals: 1.
	self
		assert: (report coverage wrongTypeCountOf:
				 'v30 Schema.maximum -> OPSchema>>maximum')
		equals: 1.
	self
		assert: (report coverage wrongTypeCountOf:
				 'v30 Schema.nullable -> OPSchema>>isNullable')
		equals: 1
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheBasicSchemeAndTheFlowsOfSwagger2 [

	| json |
	json := self documentValuesSwagger2.
	self
		assert: ((self valueCheckOf: json) comparisons detect: [ :each |
				 each entityPointer = '#/securityDefinitions/b' and: [
					 each rule selector = #scheme ] ]) expected
		equals: 'basic'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/o'
				 field: 'flow'
				 class: 'OPOAuthFlow'
				 in: json)
		equals: 'authorizationCode'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/o2'
				 field: 'flow'
				 class: 'OPOAuthFlow'
				 in: json)
		equals: 'clientCredentials'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/o3'
				 field: 'flow'
				 class: 'OPOAuthFlow'
				 in: json)
		equals: 'implicit'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/o4'
				 field: 'flow'
				 class: 'OPOAuthFlow'
				 in: json)
		equals: 'password'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/o'
				 field: 'tokenUrl'
				 class: 'OPOAuthFlow'
				 in: json)
		equals: 'tu'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/o/scopes/s'
				 field: 'scopes'
				 class: 'OPSecurityScope'
				 in: json)
		equals: 'sd'.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self
					  entity: OPOAuthFlow
					  at: '#/securityDefinitions/o2'
					  in: model) flowType: 'application' ])
		field: 'flow'
		expected: 'clientCredentials'
		found: 'application'
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheBodyParameterIsTheRequestBodyOfTheOperation [

	| json pointer |
	json := self documentValuesSwagger2.
	pointer := '#/paths/~1p~1{id}/put/parameters/0'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'description'
				 class: 'OPRequestBody'
				 in: json)
		equals: 'bd'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'required'
				 class: 'OPRequestBody'
				 in: json)
		equals: true.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self entity: OPRequestBody at: pointer in: model) required:
					 false ])
		field: 'required'
		expected: true
		found: false
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheBoundsOfOpenApi30AreMovedByTheImporter [

	| pointer gaps |
	pointer := self pointerOfParameterSchema.
	self assert: (self
			 expectedAt: pointer
			 field: 'minimum'
			 class: 'OPSchema'
			 in: self documentValues30) isNil.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'exclusiveMinimum'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: 1.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'maximum'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: 9.5.
	self assert: (self
			 expectedAt: pointer
			 field: 'exclusiveMaximum'
			 class: 'OPSchema'
			 in: self documentValues30) isNil.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPSchema at: pointer in: model)
			        minimum: 1;
			        exclusiveMinimum: nil ].
	self
		assert: (gaps collect: #fieldKey) asSet
		equals: #( 'minimum' 'exclusiveMinimum' ) asSet
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheBoundsOfOpenApi31AreNumbersAsTheyAre [

	| pointer |
	pointer := '#/paths/~1b/get/parameters/0/schema'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'exclusiveMinimum'
				 class: 'OPSchema'
				 in: self documentValues31)
		equals: 3.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'exclusiveMaximum'
				 class: 'OPSchema'
				 in: self documentValues31)
		equals: 9.5.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'minimum'
				 class: 'OPSchema'
				 in: self documentValues31)
		equals: 1.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'maximum'
				 class: 'OPSchema'
				 in: self documentValues31)
		equals: 20
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheCheckDoesNotRaiseOnTheFixturesOfTheExistenceCheckNorOnTheBadDocuments [
	"No gap of value for any of them (the document of unknown version gives its precondition)"

	self allDocuments , self documentsBad do: [ :each |
		| report |
		report := self valueReportOf: each value.
		self
			assert: ((report gaps collect: #kind) asSet difference:
					 #( #preconditionVersion )) isEmpty
			description: each key ]
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheCollectionFormatGivesTheStyleAndTheExplodeOfTheParameter [

	| json base |
	json := self documentValuesSwagger2.
	base := '#/paths/~1p~1{id}/get/parameters/'.
	self
		assert: (self
				 expectedAt: base , '0'
				 field: 'collectionFormat'
				 class: 'OPParameter'
				 in: json)
		equals: 'form'.
	self
		assert: ((self valueCheckOf: json) comparisons select: [ :each |
				 each entityPointer = (base , '0') and: [
					 each rule selector = #explode ] ]) first expected
		equals: true.
	self
		assert: ((self valueCheckOf: json) comparisons select: [ :each |
				 each entityPointer = (base , '3') and: [
					 each rule selector = #style ] ]) first expected
		equals: 'spaceDelimited'.
	self
		assert: ((self valueCheckOf: json) comparisons select: [ :each |
				 each entityPointer = (base , '4') and: [
					 each rule selector = #style ] ]) first expected
		equals: 'pipeDelimited'.
	self assert:
		((self valueCheckOf: json) comparisons select: [ :each |
			 each entityPointer = (base , '2') and: [
				 each rule selector = #style ] ]) first expected isNil.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self entity: OPParameter at: base , '1' in: model) style:
					 'matrix' ])
		field: 'collectionFormat'
		expected: 'form'
		found: 'matrix'
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheComponentsHaveNoStatusCodeNorPath [
	"A response or a path item of the components is not an entry of responses or of paths"

	| json |
	json := self documentValues31.
	self assert: (self valueGapsOf: json after: [ :model |
			 (self entity: OPResponse at: '#/components/responses/R' in: model)
				 statusCode: 'anything'.
			 (self entity: OPPath at: '#/components/pathItems/P' in: model)
				 relativePath: 'anything' ]) isEmpty
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheConstOfOpenApi31 [

	self
		assert: (self
				 expectedAt: '#/paths/~1b/get/parameters/0/schema'
				 field: 'const'
				 class: 'OPSchema'
				 in: self documentValues31)
		equals: '{"a":[1]}'
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheCoverageCountsTheMismatches [

	| model report |
	model := self modelOf: self documentValues30.
	(self entity: OPInfo at: '#/info' in: model)
		title: 'x';
		version: 'y'.
	report := FamixOpenApiValueCheck
		          checkInventory: (self inventoryOf: self documentValues30)
		          model: model.
	self
		assert:
		(report coverage mismatchCountOf: 'v30 Info.title -> OPInfo>>title')
		equals: 1.
	self
		assert: (report coverage mismatchCountOf:
				 'v30 Info.version -> OPInfo>>version')
		equals: 1.
	self assert: report coverage totalMismatched equals: 2.
	self assert: report valueMismatches size equals: 2.
	self assert: report countsByKind equals: (OrderedDictionary new
			 at: #valueMismatch put: 2;
			 yourself).
	self
		assert: report countsBySpecObject
		equals: (OrderedDictionary new
				 at: 'Info' put: 2;
				 yourself).
	self assert: report countsByField equals: (OrderedDictionary new
			 at: 'Info.title' put: 1;
			 at: 'Info.version' put: 1;
			 yourself)
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheCoverageCountsWhatWasComparedAndWhatWasNotADefault [

	| coverage |
	coverage := self coverageOf: self documentValues30.
	self
		assert:
		(coverage comparedCountOf: 'v30 Info.title -> OPInfo>>title')
		equals: 1.
	self
		assert:
		(coverage informativeCountOf: 'v30 Info.title -> OPInfo>>title')
		equals: 1.
	self
		assert: (coverage comparedCountOf:
				 'v30 Operation.deprecated -> OPOperation>>deprecated')
		equals: 1.
	self
		assert:
		(coverage mismatchCountOf: 'v30 Info.title -> OPInfo>>title')
		equals: 0.
	self assert: coverage totalInformative < coverage totalCompared.
	self assert: coverage totalCompared > 150
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheDefinitionsDiscriminatorIsAStringOfSwagger2 [

	| json |
	json := self documentValuesSwagger2.
	self
		assert: (self
				 expectedAt: '#/definitions/D/discriminator'
				 field: 'discriminator'
				 class: 'OPDiscriminator'
				 in: json)
		equals: 'kind'.
	self
		assert: (self
				 expectedAt: '#/definitions/D'
				 field: 'exclusiveMaximum'
				 class: 'OPSchema'
				 in: json)
		equals: 10.
	self
		assert: (self
				 expectedAt: '#/definitions/D'
				 field: 'title'
				 class: 'OPSchema'
				 in: json)
		equals: 'DT'.
	self
		assert: (self
				 expectedAt: '#/definitions/D'
				 field: 'example'
				 class: 'OPSchema'
				 in: json)
		equals: '{"a":1}'.
	self
		assert: (self
				 expectedAt: '#/definitions/D/properties/kind/xml'
				 field: 'name'
				 class: 'OPXmlElement'
				 in: json)
		equals: 'x'
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheExampleLinkAndHeaderObjects [

	self
		assert: (self
				 expectedAt: '#/components/examples/e'
				 field: 'value'
				 class: 'OPExample'
				 in: self documentValues30)
		equals: '{"k":"v"}'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get/responses/200/links/l'
				 field: 'requestBody'
				 class: 'OPLink'
				 in: self documentValues30)
		equals: '{"a":1}'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get/responses/200/headers/h'
				 field: 'style'
				 class: 'OPHeader'
				 in: self documentValues30)
		equals: 'simple'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get/requestBody'
				 field: 'required'
				 class: 'OPRequestBody'
				 in: self documentValues30)
		equals: true
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheFormDataParametersMakeARequestBodyRequiredWhenOneOfThemIs [

	| json pointer |
	json := self documentValuesSwagger2.
	pointer := '#/paths/~1p~1{id}/post/requestBody'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'parameters'
				 class: 'OPRequestBody'
				 in: json)
		equals: true.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self entity: OPRequestBody at: pointer in: model) required:
					 false ])
		field: 'parameters'
		expected: true
		found: false
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheGapsCarryTheFileTheSpecObjectTheEntityAndTheRule [

	| model check gap |
	model := self modelOf: self documentValues31.
	(self entity: OPOperation at: '#/paths/~1a/get' in: model)
		operationId: 'changed'.
	check := FamixOpenApiValueCheck new.
	check file: 'doc.json'.
	gap := (check
		        checkInventory: (self inventoryOf: self documentValues31)
		        model: model) gaps first.
	self assert: gap file equals: 'doc.json'.
	self assert: gap specObject equals: 'Operation'.
	self assert: gap entity class equals: OPOperation.
	self assert: gap ruleName equals: #cloneSubtree.
	self assert: gap sourcePointer equals: '#/paths/~1a/get'.
	self assert: (gap message beginsWith:
			 'Operation.operationId: the source says ''og'', OPOperation>>operationId holds ''changed''')
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheKeysAreTheValuesOfTheVerbTheStatusCodeTheMediaTypeAndThePath [

	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get'
				 field: '{key}'
				 class: 'OPOperation'
				 in: self documentValues30)
		equals: 'get'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get/responses/200'
				 field: '{key}'
				 class: 'OPResponse'
				 in: self documentValues30)
		equals: '200'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get/responses/default'
				 field: '{key}'
				 class: 'OPResponse'
				 in: self documentValues30)
		equals: 'default'.
	self
		assert: (self
				 expectedAt:
				 '#/paths/~1p~1{id}/get/requestBody/content/application~1json'
				 field: '{key}'
				 class: 'OPMediaType'
				 in: self documentValues30)
		equals: 'application/json'.
	self
		assert: (self
				 expectedAt:
				 '#/paths/~1p~1{id}/get/requestBody/content/application~1json/encoding/z'
				 field: '{key}'
				 class: 'OPEncoding'
				 in: self documentValues30)
		equals: 'z'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}'
				 field: '{key}'
				 class: 'OPPath'
				 in: self documentValues30)
		equals: '/p/{id}'.
	self
		assert: (self
				 expectedAt:
				 '#/components/securitySchemes/o/flows/authorizationCode'
				 field: '{key}'
				 class: 'OPOAuthFlow'
				 in: self documentValues30)
		equals: 'authorizationCode'
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheKeysBesideTheRefOfAResponseDoNotOverrideTheTargetButThoseOfAPathItemDoIn31 [
	"VERIFIED: a response clone keeps the description of its target; a path item of OpenAPI 3.1 takes the summary and the description beside the $ref"

	self
		assert: (self
				 expectedAt: '#/paths/~1b/get/responses/200'
				 field: 'description'
				 class: 'OPResponse'
				 in: self documentValues31)
		equals: 'rd'.
	self
		assert: (self
				 expectedAt: '#/paths/~1a'
				 field: 'summary'
				 class: 'OPPath'
				 in: self documentValues31)
		equals: 'sib'.
	self
		assert: (self
				 expectedAt: '#/paths/~1a'
				 field: 'description'
				 class: 'OPPath'
				 in: self documentValues31)
		equals: 'sd'.
	self
		assert: (self
				 expectedAt: '#/paths/~1a'
				 field: '$ref'
				 class: 'OPPath'
				 in: self documentValues31)
		equals: '#/components/pathItems/P'
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheKeywordNullableIsIgnoredInOpenApi31 [

	| json |
	json := '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{},"components":{"schemas":{"S":{"type":"string","nullable":true}}}}'.
	self assertFaithfulValues: json.
	self
		assert: (self
				 expectedAt: '#/components/schemas/S'
				 field: 'type'
				 class: 'OPSchema'
				 in: json)
		equals: #( 'string' )
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheMarkdownOfTheReportHasTheCoverageTableAndLineFeeds [

	| markdown |
	markdown := (self valueReportOf: self documentValues30)
		            markdownSummary.
	self assert: (markdown includesSubstring:
			 '| Field | Compared | Not default | Mismatched | Wrong type | No entity |').
	self assert: (markdown includesSubstring:
			 '| v30 Info.title -> OPInfo>>title | 1 | 1 | 0 | 0 | 0 |').
	self deny: (markdown includes: Character cr).
	self assert: (markdown includes: Character lf)
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testTheNameIsComparedWhereItIsTheSourceValueAndNotWhereItIsAStructuralName [

	| gaps |
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self
			         entity: OPParameter
			         at: self pointerOfParameter
			         in: model) name: 'renamed' ].
	self
		assertOneGap: gaps
		field: 'name'
		expected: 'id'
		found: 'renamed'.
	self assert:
		(self valueGapsOf: self documentValues30 after: [ :model |
			 (self entity: OPInfo at: '#/info' in: model) name: 'renamed'.
			 (self entity: OPOperation at: '#/paths/~1p~1{id}/get' in: model)
				 name: 'renamed' ]) isEmpty
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheNumberOfTagsServersAndSecurityRequirementsIsCompared [

	| json |
	json := self documentValues30.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'tags'
				 class: 'OPOpenApi'
				 in: json)
		equals: 1.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'servers'
				 class: 'OPOpenApi'
				 in: json)
		equals: 1.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'security'
				 class: 'OPOpenApi'
				 in: json)
		equals: 1.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get'
				 field: 'security'
				 class: 'OPOperation'
				 in: json)
		equals: 1
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheOperationBelowAClonedPathItemIsCheckedWithTheRuleOfTheClone [

	| gaps |
	gaps := self valueGapsOf: self documentValues31 after: [ :model |
		        (self entity: OPOperation at: '#/paths/~1a/get' in: model)
			        operationId: 'changed' ].
	self
		assertOneGap: gaps
		field: 'operationId'
		expected: 'og'
		found: 'changed'.
	self assert: gaps first ruleName equals: #cloneSubtree
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testTheRealImportOfTheRichDocumentsHasNoValueGap [

	self assertFaithfulValues: self documentValues30.
	self assertFaithfulValues: self documentValues31.
	self assertFaithfulValues: self documentValuesSwagger2
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheScalarExampleOfAParameterAndOfAMediaTypeIsAnExampleEntity [

	self
		assert: (self
				 expectedAt: self pointerOfParameter , '/example'
				 field: 'example'
				 class: 'OPExample'
				 in: self documentValues30)
		equals: '{"a":[1,2.5]}'.
	self
		assert: (self
				 expectedAt:
				 '#/paths/~1p~1{id}/get/requestBody/content/application~1json/example'
				 field: 'example'
				 class: 'OPExample'
				 in: self documentValues30)
		equals: '{"e":1}'.
	self
		assertOneGap:
			(self valueGapsOf: self documentValues30 after: [ :model |
				 (self
					  entity: OPExample
					  at: self pointerOfParameter , '/example'
					  in: model) value: '{"a":[1,2.6]}' ])
		field: 'example'
		expected: '{"a":[1,2.5]}'
		found: '{"a":[1,2.6]}'
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheSchemaOfTheFormDataParametersIsDeferred [
	"The type file becomes a string with the format binary, one property per parameter: the details are not compared"

	| json |
	json := self documentValuesSwagger2.
	self assert: (self valueGapsOf: json after: [ :model |
			 (self
				  entity: OPSchema
				  at: '#/paths/~1p~1{id}/post/requestBody/schema/properties/f'
				  in: model)
				 format: 'anything';
				 types: #( 'file' ) ]) isEmpty
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheScopesAreComparedOneByOneAtTheEscapedPointer [

	| pointer |
	pointer := '#/components/securitySchemes/o/flows/authorizationCode/scopes/t~1u'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'scopes'
				 class: 'OPSecurityScope'
				 in: self documentValues30)
		equals: 'td'.
	self
		assertOneGap:
			(self valueGapsOf: self documentValues30 after: [ :model |
				 (self entity: OPSecurityScope at: pointer in: model)
					 description: 'other' ])
		field: 'scopes'
		expected: 'td'
		found: 'other'
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheSecurityDefinitionsOfSwagger2AreConverted [

	self
		assert: (self
				 expectedAt: '#/securityDefinitions/b'
				 field: 'type'
				 class: 'OPSecurityScheme'
				 in: self documentValuesSwagger2)
		equals: 'http'.
	self
		assert: (self
				 expectedAt: '#/securityDefinitions/k'
				 field: 'type'
				 class: 'OPSecurityScheme'
				 in: self documentValuesSwagger2)
		equals: 'apiKey'.
	self
		assertOneGap:
			(self valueGapsOf: self documentValuesSwagger2 after: [ :model |
				 (self
					  entity: OPSecurityScheme
					  at: '#/securityDefinitions/b'
					  in: model) type: 'basic' ])
		field: 'type'
		expected: 'http'
		found: 'basic'
]

{ #category : 'tests - keys, clones and references' }
FamixOpenApiValueCheckTest >> testTheSecuritySchemesAndTheFlowsOfOpenApi30 [

	self
		assert: (self
				 expectedAt: '#/components/securitySchemes/k'
				 field: 'name'
				 class: 'OPSecurityScheme'
				 in: self documentValues30)
		equals: 'nm'.
	self
		assert: (self
				 expectedAt: '#/components/securitySchemes/k'
				 field: 'in'
				 class: 'OPSecurityScheme'
				 in: self documentValues30)
		equals: 'header'.
	self
		assert: (self
				 expectedAt: '#/components/securitySchemes/h'
				 field: 'bearerFormat'
				 class: 'OPSecurityScheme'
				 in: self documentValues30)
		equals: 'JWT'.
	self
		assert: (self
				 expectedAt:
				 '#/components/securitySchemes/o/flows/authorizationCode'
				 field: 'refreshUrl'
				 class: 'OPOAuthFlow'
				 in: self documentValues30)
		equals: 'ru'.
	self
		assertOneGap:
			(self valueGapsOf: self documentValues30 after: [ :model |
				 (self
					  entity: OPSecurityScheme
					  at: '#/components/securitySchemes/k'
					  in: model) parameterName: 'other' ])
		field: 'name'
		expected: 'nm'
		found: 'other'
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheServersAreCountedOnlyWhenTheDocumentHasThem [
	"Without servers the importer synthesises one: the existence check compares it"

	| json report |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{}}'.
	report := self valueReportOf: json.
	self assert: report gaps isEmpty.
	self
		assert: (report coverage comparedCountOf:
				 'v30 OpenAPI.servers -> OPOpenApi>>servers')
		equals: 0.
	self
		assert: (report coverage comparedCountOf:
				 'v30 OpenAPI.tags -> OPOpenApi>>tags')
		equals: 1
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheSourceVersionOfTheDocumentIsKeptInSourceVersion [
	"The importer normalises openapiVersion to 3.1.0; the text of the source is in sourceVersion"

	self
		assert: (self
				 expectedAt: '#'
				 field: 'swagger'
				 class: 'OPOpenApi'
				 in: self documentValuesSwagger2)
		equals: '2.0'.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'openapi'
				 class: 'OPOpenApi'
				 in: self documentValues30)
		equals: '3.0.3'.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'openapi'
				 class: 'OPOpenApi'
				 in: self documentValues31)
		equals: '3.1.0'.
	self
		assertOneGap:
			(self valueGapsOf: self documentValues30 after: [ :model |
				 (self entity: OPOpenApi at: '#' in: model) sourceVersion: '3.1.0' ])
		field: 'openapi'
		expected: '3.0.3'
		found: '3.1.0'
]

{ #category : 'tests - text and flags' }
FamixOpenApiValueCheckTest >> testTheStyleExplodeAndAllowReservedAreComparedOnlyWhenTheSourceStatesThem [

	| json |
	json := '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"parameters":[{"name":"a","in":"query"},{"name":"b","in":"query","style":"form","explode":false,"allowReserved":true}],"responses":{"200":{"description":"d"}}}}}}'.
	self assertFaithfulValues: json.
	self assert: (self valueGapsOf: json after: [ :model |
			 (self
				  entity: OPParameter
				  at: '#/paths/~1p/get/parameters/0'
				  in: model)
				 style: 'form';
				 explode: true;
				 allowReserved: true ]) isEmpty.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self
					  entity: OPParameter
					  at: '#/paths/~1p/get/parameters/1'
					  in: model) explode: true ])
		field: 'explode'
		expected: false
		found: true
]

{ #category : 'tests - counts, preconditions and coverage' }
FamixOpenApiValueCheckTest >> testTheTagsAndTheSecurityOfSwagger2AreCounted [

	| json |
	json := self documentValuesSwagger2.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'tags'
				 class: 'OPOpenApi'
				 in: json)
		equals: 1.
	self
		assert: (self
				 expectedAt: '#'
				 field: 'security'
				 class: 'OPOpenApi'
				 in: json)
		equals: 2
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheTypeAndTheNullableOfOpenApi30 [

	| pointer gaps |
	pointer := self pointerOfParameterSchema.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'type'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: #( 'string' ).
	self
		assert: (self
				 expectedAt: pointer
				 field: 'nullable'
				 class: 'OPSchema'
				 in: self documentValues30)
		equals: true.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPSchema at: pointer in: model) isNullable:
			        false ].
	self
		assertOneGap: gaps
		field: 'nullable'
		expected: true
		found: false.
	gaps := self valueGapsOf: self documentValues30 after: [ :model |
		        (self entity: OPSchema at: pointer in: model) types:
			        #( 'integer' ) ].
	self
		assertOneGap: gaps
		field: 'type'
		expected: #( 'string' )
		found: #( 'integer' )
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheTypeAndTheNullableOfOpenApi31 [

	| json gaps |
	json := self documentValues31.
	self
		assert: (self
				 expectedAt: '#/paths/~1b/get/parameters/0/schema'
				 field: 'type'
				 class: 'OPSchema'
				 in: json)
		equals: #( 'integer' ).
	self
		assert: (self
				 expectedAt: '#/paths/~1b/get/parameters/1/schema'
				 field: 'type'
				 class: 'OPSchema'
				 in: json)
		equals: #(  ).
	gaps := self valueGapsOf: json after: [ :model |
		        (self
			         entity: OPSchema
			         at: '#/paths/~1b/get/parameters/0/schema'
			         in: model) isNullable: false ].
	self
		assertOneGap: gaps
		field: 'type'
		expected: true
		found: false.
	gaps := self valueGapsOf: json after: [ :model |
		        (self
			         entity: OPSchema
			         at: '#/components/schemas/S'
			         in: model) types: #( 'string' ) ].
	self
		assertOneGap: gaps
		field: 'type'
		expected: #( 'string' 'integer' )
		found: #( 'string' )
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheTypeFormatAndEnumOfASwagger2HeaderAreNotCompared [
	"The importer does not convert them into a schema (they stay in the extensions): the conformance has no slot for them and the check invents no mismatch"

	| report |
	report := self valueReportOf: self documentValuesSwagger2.
	self assert: report gaps isEmpty.
	self assert: (report coverage sortedKeys noneSatisfy: [ :each |
			 each includesSubstring: 'Header.type' ]).
	self
		assert: (report coverage comparedCountOf:
				 'v2 Header.description -> OPHeader>>description')
		equals: 1
]

{ #category : 'tests - Swagger 2' }
FamixOpenApiValueCheckTest >> testTheTypedParameterMakesASchemaWhoseValuesAreComparedAtTheSchemaPointer [

	| json pointer |
	json := self documentValuesSwagger2.
	pointer := '#/paths/~1p~1{id}/get/parameters/0/schema/items'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'type'
				 class: 'OPSchema'
				 in: json)
		equals: #( 'integer' ).
	self
		assert: (self
				 expectedAt: pointer
				 field: 'format'
				 class: 'OPSchema'
				 in: json)
		equals: 'int32'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'exclusiveMaximum'
				 class: 'OPSchema'
				 in: json)
		equals: 5.
	self assert: (self
			 expectedAt: pointer
			 field: 'maximum'
			 class: 'OPSchema'
			 in: json) isNil.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'enum'
				 class: 'OPSchema'
				 in: json)
		equals: '[1,2]'.
	self
		assert: (self
				 expectedAt: pointer
				 field: 'default'
				 class: 'OPSchema'
				 in: json)
		equals: '1'.
	self
		assert: (self
				 expectedAt: '#/paths/~1p~1{id}/get/parameters/0/schema'
				 field: 'maxItems'
				 class: 'OPSchema'
				 in: json)
		equals: 4.
	self
		assertOneGap: (self valueGapsOf: json after: [ :model |
				 (self entity: OPSchema at: pointer in: model) format: 'int64' ])
		field: 'format'
		expected: 'int32'
		found: 'int64'
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueCheckTest >> testTheXmlElementDiscriminatorAndServerVariablesOfOpenApi30 [

	self
		assert: (self
				 expectedAt: self pointerOfParameterSchema , '/xml'
				 field: 'name'
				 class: 'OPXmlElement'
				 in: self documentValues30)
		equals: 'xn'.
	self
		assert: (self
				 expectedAt: self pointerOfParameterSchema , '/discriminator'
				 field: 'propertyName'
				 class: 'OPDiscriminator'
				 in: self documentValues30)
		equals: 'z'.
	self
		assert: (self
				 expectedAt: '#/servers/0/variables/h'
				 field: 'enum'
				 class: 'OPServerVariable'
				 in: self documentValues30)
		equals: #( 'a' 'b' ).
	self
		assert: (self
				 expectedAt: '#/servers/0/variables/h'
				 field: 'default'
				 class: 'OPServerVariable'
				 in: self documentValues30)
		equals: 'a'
]
