"
Entry point of the validation tools of the Famix OpenApi metamodel and importer: the conformance of the metamodel to the spec field table, the coherence of a model, and the import fidelity of a model against the source document it was imported from (four checks: existence, values, extensions and diagnostics, relations).

USAGE (Playground). The importer is called by the caller: this package does not reference it.

1. Import the JSON file WITHOUT merging the inline schemas (the fidelity checks need a 1:1 model):
  imp := FamixOpenApiImporter new.
  imp mergesInlineSchemas: false.
  model := imp importFromFile: '/path/spec.json'.

2. Check the fidelity of the model against the text of the file: one call, one FamixOpenApiFidelityReport (the diagnostics of the import excuse what the importer says it ignores; nil is accepted):
  report := FamixOpenApiFidelityChecker new
      checkJsonString: '/path/spec.json' asFileReference contents
      model: model
      diagnostics: imp diagnostics all.
  report isFaithful.
  report markdownSummary.
isFaithful is true when no check found a failing gap. markdownSummary gives the verdict, the failing gaps by check and kind, the informational counts, the coverage per version, the candidates to model, the known findings about the importer and what is not verified. Also: report failingGaps, report countsByCheckAndKind, report coverage, report frequencies. The same call exists as FamixOpenApiValidation checkFidelityOfJsonString:model:diagnostics:. FamixOpenApiFidelityChecker new checks: #(#existence #relations) runs a subset, file: labels the document. A model imported with the inline schemas merged, or a document of an unknown version, gives ONE precondition gap and no check runs; a text that is not JSON gives one #invalidJson gap.

3. The coherence of the model (the rules of FamixOpenApiValidationRule: containment, references, inverse relations...):
  (FamixOpenApiModelValidator new validate: model) markdownSummary.

4. The conformance of the metamodel to the field table of the specifications:
  FamixOpenApiMetamodelConformance check markdownSummary.

5. Several documents: add the report of each one to a FamixOpenApiFidelityCorpus (#add:), then ask it #isFaithful and #markdownSummary (the verdict of every file, then the merged coverage, frequencies and findings).

Each selector of this guide is run by FamixOpenApiValidationTest>>testTheUsageGuideRuns.
"
Class {
	#name : 'FamixOpenApiValidation',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'fidelity' }
FamixOpenApiValidation class >> checkFidelityOfJsonString: aString model: aModel diagnostics: aDiagnosticsOrNil [
	"The FamixOpenApiFidelityReport of aModel (imported with mergesInlineSchemas = false) against the JSON text aString it was imported from. aDiagnosticsOrNil is nil or the diagnostics of the import. The import itself is the caller's: see the comment of this class"

	^ FamixOpenApiFidelityChecker
		  checkJsonString: aString
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'accessing' }
FamixOpenApiValidation class >> description [
	"A short description of the validation tools"

	^ 'Validation tools for the Famix OpenApi metamodel and importer: conformance of the metamodel, coherence of a model, import fidelity against the source document (see the class comment for the usage)'
]
