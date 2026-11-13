"
Intentionally minimal smoke tests of the validation package skeleton: they only check that the entry point answers a description and that the model package is loadable.
"
Class {
	#name : 'FamixOpenApiValidationTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiValidationTest >> testDescriptionIsNotEmptyString [
	"Intentionally minimal smoke test."

	| description |
	description := FamixOpenApiValidation description.
	self assert: description isString.
	self deny: description isEmpty
]

{ #category : 'tests' }
FamixOpenApiValidationTest >> testModelPackageIsLoadable [
	"Intentionally minimal smoke test: the generated model must be loaded."

	self assert: (Smalltalk includesKey: #OPInfo)
]

{ #category : 'tests' }
FamixOpenApiValidationTest >> testTheClassCommentGivesTheUsageThatTheTestsRun [
	"Every selector of the guide is in the comment"

	#( 'FamixOpenApiImporter new' 'mergesInlineSchemas: false'
	   'importFromFile:' 'FamixOpenApiFidelityChecker new'
	   'checkJsonString:' 'model:' 'diagnostics: imp diagnostics all'
	   'isFaithful' 'markdownSummary' 'FamixOpenApiModelValidator new validate: model'
	   'FamixOpenApiMetamodelConformance check markdownSummary'
	   'checkFidelityOfJsonString:model:diagnostics:'
	   'FamixOpenApiFidelityCorpus' ) do: [ :each |
		self
			assert: (FamixOpenApiValidation comment includesSubstring: each)
			description: each ]
]

{ #category : 'tests' }
FamixOpenApiValidationTest >> testTheUsageGuideOfTheCorpusRuns [
	"The step 5 of the guide: the reports of several documents in a FamixOpenApiFidelityCorpus"

	| corpus imp |
	corpus := FamixOpenApiFidelityCorpus new.
	imp := FamixOpenApiImporter new.
	imp mergesInlineSchemas: false.
	corpus add: (FamixOpenApiFidelityChecker new
			 checkJsonString: self usageSpecText
			 model: (imp importFromString: self usageSpecText)
			 diagnostics: imp diagnostics all).
	self assert: corpus isFaithful.
	self assert:
		(corpus markdownSummary includesSubstring: '## Verdict per file')
]

{ #category : 'tests' }
FamixOpenApiValidationTest >> testTheUsageGuideRuns [
	"The calls of the USAGE of the class comment of FamixOpenApiValidation, in the same order, on a file of a memory file system (the guide says '/path/spec.json')"

	| file imp model report validation conformance |
	file := FileSystem memory / 'spec.json'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: self usageSpecText ].
	imp := FamixOpenApiImporter new.
	imp mergesInlineSchemas: false.
	model := imp importFromFile: file.
	report := FamixOpenApiFidelityChecker new
		          checkJsonString: file contents
		          model: model
		          diagnostics: imp diagnostics all.
	self assert: report isFaithful.
	self assert:
		(report markdownSummary includesSubstring: '**Verdict: FAITHFUL**').
	self assert: report failingGaps isEmpty.
	self assert: report countsByCheckAndKind isNotNil.
	self assert: report coverage totalCompared > 0.
	self deny: report frequencies isEmpty.
	self assert: (FamixOpenApiValidation
			 checkFidelityOfJsonString: file contents
			 model: model
			 diagnostics: imp diagnostics all) isFaithful.
	self
		assert: (FamixOpenApiFidelityChecker new
				 checks: #( #existence #relations );
				 file: 'spec.json';
				 checkJsonString: file contents
				 model: model
				 diagnostics: imp diagnostics all) checksRun
		equals: #( #existence #relations ).
	validation := (FamixOpenApiModelValidator new validate: model)
		              markdownSummary.
	self assert: validation isString.
	conformance := FamixOpenApiMetamodelConformance check markdownSummary.
	self assert: conformance isString.
	self assert: conformance isNotEmpty
]

{ #category : 'tests' }
FamixOpenApiValidationTest >> usageSpecText [
	"A small OpenAPI 3.0 document"

	^ '{"openapi":"3.0.3","info":{"title":"t","version":"1"},"paths":{"/p":{"get":{"operationId":"g","responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"$ref":"#/components/schemas/A"}}}}}}}},"components":{"schemas":{"A":{"type":"object","x-note":1,"properties":{"a":{"type":"string"}}}}}}'
]
