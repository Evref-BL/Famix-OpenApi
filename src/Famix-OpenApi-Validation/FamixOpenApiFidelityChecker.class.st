"
Entry point of the import fidelity checks: ONE call runs the four checks on a source document and the model imported from it, and answers ONE FamixOpenApiFidelityReport.

USAGE (the importer is used by the caller: this package does not reference it)
  imp := FamixOpenApiImporter new.
  imp mergesInlineSchemas: false.
  model := imp importFromFile: '/path/spec.json'.
  report := FamixOpenApiFidelityChecker new
      checkJsonString: '/path/spec.json' asFileReference contents
      model: model
      diagnostics: imp diagnostics all.
  report isFaithful. report markdownSummary.
See FamixOpenApiValidation for the whole guide.

API. Instance and class side: #checkJson:model:diagnostics: (the parsed JSON, with the objects as OrderedDictionary: the order of the keys counts), #checkJsonString:model:diagnostics: (the text is parsed like the importer does; a text that is not JSON gives a report with one #invalidJson gap, nothing is raised), #checkInventory:model:diagnostics: (a FamixOpenApiSourceInventory already walked). aDiagnosticsOrNil is nil or the diagnostics of the import (anything that answers #do: with elements answering #code and #pointer: FamixOpenApiDiagnostics or its #all). #file: gives the label of the document in the report, #checks: selects some checks among #existence #values #extensions #relations (default: all, see #allChecks).

CHECKS (preconditions: the model was imported with mergesInlineSchemas = FALSE; the version of the document is known: else ONE gap, #preconditionMerged or #preconditionVersion, and the four checks are skipped)
- existence (V7/V7b, FamixOpenApiExistenceCheck): every node that should have an entity has one, of the right class, at the right pointer, and the model has no other entity than the ones the document implies.
- values (V8, FamixOpenApiValueCheck): the fields that the metamodel models as a slot hold the value of the source.
- extensions (V9, FamixOpenApiExtensionsCheck): what becomes of the other fields (kept in the extensions, reported by a diagnostic, lost): the frequency table and the candidates to model.
- relations (V10, FamixOpenApiRelationCheck): the relations hold the targets that the source designates (through $ref), in the order and the number of the source.

SHARED WORK. The document is walked ONCE. One FamixOpenApiValueCheck is prepared once (lookup of the model, expansion of the inventory: the clones re-rooted, the schemas that Swagger 2 makes of typed parameters) and the four checks read it (#shareValueCheck:). Each check keeps its own entry point.

NOT VERIFIED (nothing here compares): the merged form (mergesInlineSchemas = true); the names of the entities, but where the slot is the source value verbatim; the defaults of style and explode; Link.parameters; the schema of the formData parameters of Swagger 2 and the keywords of a Swagger 2 header; the inverse relations (the model validator checks their coherence, not against the source); the structure inside the value of a key that is not modelled (compared as canonical text); the nodes of the wrong shape; what the derivation does not follow (FamixOpenApiSyntheticExpectations class>>knownLimits); the keys beside a $ref of OpenAPI 3.1 for the relations (deferred, counted). The list is data: FamixOpenApiFidelityReport class>>notVerified.

FAILING and INFORMATIONAL: see FamixOpenApiFidelityReport (the failing kinds are those of the four checks, informational ones are #onlyInExtensions #ignoredByDiagnostic #valueKeptAnyway #notDecidable). The checker does not change the importer and does not depend on it.
"
Class {
	#name : 'FamixOpenApiFidelityChecker',
	#superclass : 'Object',
	#instVars : [
		'file',
		'checks',
		'inventory',
		'model',
		'diagnostics',
		'valueCheck',
		'result'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiFidelityChecker class >> allChecks [
	"The checks that run by default: the four of FamixOpenApiFidelityReport class>>checkNames"

	^ FamixOpenApiFidelityReport checkNames
]

{ #category : 'checking' }
FamixOpenApiFidelityChecker class >> checkJson: aParsedJson model: aModel diagnostics: aDiagnosticsOrNil [
	"The FamixOpenApiFidelityReport of the model against the parsed JSON document (objects as OrderedDictionary); aDiagnosticsOrNil is nil or the diagnostics of the import"

	^ self new
		  checkJson: aParsedJson
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'checking' }
FamixOpenApiFidelityChecker class >> checkJsonString: aString model: aModel diagnostics: aDiagnosticsOrNil [
	"The FamixOpenApiFidelityReport of the model against the JSON text of the document: a text that is not JSON gives one #invalidJson gap"

	^ self new
		  checkJsonString: aString
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'checking' }
FamixOpenApiFidelityChecker >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"Answer the FamixOpenApiFidelityReport of the model against a document already walked. The preconditions are asked once: when they fail the report has the one gap and the four checks are skipped"

	inventory := anInventory.
	model := aModel.
	diagnostics := aDiagnosticsOrNil.
	result := self newReport.
	self prepareValueCheck.
	valueCheck satisfiesPreconditions
		ifTrue: [
			valueCheck prepare.
			self runChecks ]
		ifFalse: [ self reportPreconditionFailure ].
	^ result
]

{ #category : 'checking' }
FamixOpenApiFidelityChecker >> checkJson: aParsedJson model: aModel diagnostics: aDiagnosticsOrNil [
	"Answer the FamixOpenApiFidelityReport of the model against the parsed JSON document (the objects are OrderedDictionary, as FamixOpenApiSourceWalker>>#walkString: reads them: their order counts). Nothing is raised for a document of an unknown shape: it gives a #preconditionVersion gap"

	^ self
		  checkInventory: (FamixOpenApiSourceWalker new walk: aParsedJson)
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'checking' }
FamixOpenApiFidelityChecker >> checkJsonString: aString model: aModel diagnostics: aDiagnosticsOrNil [
	"Answer the FamixOpenApiFidelityReport of the model against the JSON text of the document. A text that is not JSON gives a report with one #invalidJson gap, nothing is raised"

	| parsed |
	parsed := [ self parse: aString ]
		          on: Error
		          do: [ :error |
		          ^ self invalidJsonReportOn: aModel error: error ].
	^ self checkJson: parsed model: aModel diagnostics: aDiagnosticsOrNil
]

{ #category : 'initialization' }
FamixOpenApiFidelityChecker >> checks: someCheckNames [
	"Run only these checks, among FamixOpenApiFidelityChecker class>>allChecks (#existence #values #extensions #relations). The others are listed in the report as skipped"

	| unknown |
	unknown := someCheckNames reject: [ :each |
		           self class allChecks includes: each ].
	unknown ifNotEmpty: [
		self error: 'Unknown check ' , unknown first printString ].
	checks := someCheckNames asArray
]

{ #category : 'initialization' }
FamixOpenApiFidelityChecker >> file: aString [
	"The label of the document in the report and on its gaps"

	file := aString
]

{ #category : 'initialization' }
FamixOpenApiFidelityChecker >> initialize [

	super initialize.
	checks := self class allChecks
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> invalidJsonGapOf: anError [

	^ (FamixOpenApiGap
		   kind: #invalidJson
		   pointer: FamixOpenApiSourceNode rootPointer
		   specObject: nil)
		  expected: 'a JSON document';
		  message: 'The text of the document is not JSON: '
			  , anError messageText asString;
		  yourself
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> invalidJsonReportOn: aModel error: anError [
	"The report of a text that is not JSON: one #invalidJson gap, the four checks skipped"

	| gaps |
	inventory := FamixOpenApiSourceWalker new walk: nil.
	model := aModel.
	result := self newReport.
	gaps := self newGapReport.
	gaps add: (self invalidJsonGapOf: anError).
	result addReport: gaps ofCheck: #document.
	self class allChecks do: [ :each | result skip: each ].
	^ result
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> mergedMessage [
	"The model has merged schemas: the first one is named"

	| first |
	first := valueCheck lookup allEntities detect: [ :each |
		         valueCheck isMergeEvidence: each ].
	^ 'The model was imported with mergesInlineSchemas = true (the first merged schema is at '
	  , first canonicalPointer printString
	  , '): the fidelity checks need mergesInlineSchemas = false'
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> newGapReport [

	^ FamixOpenApiGapReport new
		  file: file;
		  yourself
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> newReport [
	"The report of the document: its label, version, number of nodes and of entities"

	^ FamixOpenApiFidelityReport new
		  addDocumentLabeled: file
		  version: inventory version
		  nodes: inventory pointers size
		  entities: model allModelEntities size;
		  yourself
]

{ #category : 'checking' }
FamixOpenApiFidelityChecker >> parse: aString [
	"The JSON text as the importer reads it: the objects keep the order of their keys"

	^ (NeoJSONReader on: aString readStream)
		  mapClass: OrderedDictionary;
		  next
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> preconditionGap [
	"The gap of the value check, worded for the whole series of checks"

	| gap |
	gap := valueCheck report gaps first.
	^ (FamixOpenApiGap
		   kind: gap kind
		   pointer: gap sourcePointer
		   specObject: nil)
		  expected: gap expected;
		  message: (self preconditionMessageOf: gap kind);
		  yourself
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> preconditionMessageOf: aKind [

	^ aKind = #preconditionVersion
		  ifTrue: [
		  'The version of the document is unknown: no check can run' ]
		  ifFalse: [ self mergedMessage ]
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> prepareValueCheck [
	"The value check that every check reads: the lookup of the model, then (see #runChecks) the expansion of the inventory, made once"

	valueCheck := FamixOpenApiValueCheck new
		              file: file;
		              yourself.
	valueCheck prepareInventory: inventory model: model
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> reportPreconditionFailure [
	"The one gap of the precondition that failed (asked once), the four checks skipped"

	| gaps |
	gaps := self newGapReport.
	gaps add: self preconditionGap.
	result addReport: gaps ofCheck: #preconditions.
	self class allChecks do: [ :each | result skip: each ]
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> runChecks [
	"The selected checks, in the order of the report; the others are skipped"

	self runners do: [ :each |
		(checks includes: each key)
			ifTrue: [ result addReport: each value value ofCheck: each key ]
			ifFalse: [ result skip: each key ] ]
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> runExistence [

	^ FamixOpenApiExistenceCheck new
		  file: file;
		  shareValueCheck: valueCheck;
		  checkInventory: inventory model: model diagnostics: diagnostics
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> runExtensions [

	^ FamixOpenApiExtensionsCheck new
		  file: file;
		  shareValueCheck: valueCheck;
		  checkInventory: inventory model: model diagnostics: diagnostics
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> runRelations [

	^ FamixOpenApiRelationCheck new
		  file: file;
		  shareValueCheck: valueCheck;
		  checkInventory: inventory model: model diagnostics: diagnostics
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> runValues [

	^ valueCheck checkNodes
]

{ #category : 'private' }
FamixOpenApiFidelityChecker >> runners [
	"Associations check name -> block that runs it"

	^ {
		  (#existence -> [ self runExistence ]).
		  (#values -> [ self runValues ]).
		  (#extensions -> [ self runExtensions ]).
		  (#relations -> [ self runRelations ]) }
]
