"
I orchestrate the import of one parsed document held by my context: I detect the specification version, then run the passes in order: root (FamixOpenApiDocumentVisitor), schemas (FamixOpenApiSchemaVisitor: creation then filling), then the merging of identical inline schemas and the detection of sub-schemas (FamixOpenApiSchemaMerger). Each pass is guarded: an Error becomes an importError diagnostic and the import goes on. The visitors of the next steps (paths, operations, parameters, ...) will be run between the schema passes and the merging.
"
Class {
	#name : 'FamixOpenApiJsonVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> mergeSchemas [
	"Pass 3: merge the identical inline schemas and detect the sub-schemas, when the option asks for it; record the report."

	context mergesInlineSchemas
		ifTrue: [
			context mergeReport:
				(FamixOpenApiSchemaMerger new mergeIn: context) ]
		ifFalse: [
			context mergeReport: (Dictionary new
					 at: #merged put: 0;
					 at: #subSchemas put: 0;
					 at: #inlineSchemas put: context inlineSchemaCount;
					 yourself) ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visit [
	"Import the document of my context: detect its version, then read the root, the schemas and merge the identical inline schemas. Nothing is raised: the problems are diagnostics."

	| version |
	version := FamixOpenApiSpecVersion
		           detectIn: self json
		           diagnostics: self diagnostics.
	version ifNil: [ ^ self ].
	context specVersion: version.
	self guard: [ self visitDocument ] at: '#'.
	self openApi ifNil: [ ^ self ].
	self guard: [ self visitSchemas ] at: '#'.
	self guard: [ self mergeSchemas ] at: '#'
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitDocument [
	"Pass: the root, its info, servers, tags, external documentation and components skeleton."

	(FamixOpenApiDocumentVisitor on: context) visit
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitSchemas [
	"Passes 1 and 2: create then fill the component schemas."

	(FamixOpenApiSchemaVisitor on: context) visit
]
