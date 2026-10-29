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
FamixOpenApiJsonVisitor >> checkOperations [
	"Report the operationIds used by several operations."

	self pathVisitor reportDuplicateOperationIds
]

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

{ #category : 'naming' }
FamixOpenApiJsonVisitor >> nameInlineSchemas [
	"Pass 4: give a name to every inline schema (not owned by components) that has none: its structural name, or 'part of <parent>' for a SubSchema. All the names are computed before any is set, so that no name depends on the naming of another inline schema. Component schemas keep their name; pointers, merges and diagnostics are not touched."

	| names |
	names := OrderedCollection new.
	(self unnamedInlineSchemasOf: OPSchema) do: [ :each |
		names add: each -> (FamixOpenApiNaming structuralNameOf: each) ].
	(self unnamedInlineSchemasOf: OPSubSchema) do: [ :each |
		names add: each -> (self subSchemaNameOf: each) ].
	names do: [ :each | each key name: each value ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> resolveLinks [
	"Final pass before the merge: set the operation of the links."

	(FamixOpenApiLinkResolver on: context) resolve
]

{ #category : 'naming' }
FamixOpenApiJsonVisitor >> subSchemaNameOf: aSubSchema [
	"Answer 'part of <parent>' where the parent is the schema aSubSchema is a sub-schema of, named by its own name or else by its structural name, or 'part of schema' when it has no parent or no name."

	| parent parentName |
	parent := aSubSchema subSchemaOf.
	parent ifNil: [ ^ 'part of schema' ].
	parentName := parent name isNil
		              ifTrue: [ FamixOpenApiNaming structuralNameOf: parent ]
		              ifFalse: [ FamixOpenApiNaming limited: parent name ].
	^ FamixOpenApiNaming limited: (parentName isEmpty
			   ifTrue: [ 'part of schema' ]
			   ifFalse: [ 'part of ' , parentName ])
]

{ #category : 'naming' }
FamixOpenApiJsonVisitor >> unnamedInlineSchemasOf: aSchemaClass [
	"Answer the instances of exactly aSchemaClass that are not owned by components and have no name."

	^ (context model allWithType: aSchemaClass) select: [ :each |
		  each components isNil and: [ each name isNil ] ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visit [
	"Import the document of my context: detect its version, then read the root, create the components, read the schemas, fill the components, read the paths, the webhooks and the security, resolve the links, merge the identical inline schemas and name the inline schemas. Nothing is raised: the problems are diagnostics."

	| version components |
	version := FamixOpenApiSpecVersion
		           detectIn: self json
		           diagnostics: self diagnostics.
	version ifNil: [ ^ self ].
	context specVersion: version.
	self guard: [ self visitDocument ] at: '#'.
	self openApi ifNil: [ ^ self ].
	components := FamixOpenApiComponentsVisitor on: context.
	self guard: [ components createComponents ] at: '#/components'.
	self guard: [ self visitSchemas ] at: '#'.
	self guard: [ components fillComponents ] at: '#/components'.
	self guard: [ self visitPaths ] at: '#/paths'.
	self guard: [ self visitWebhooks ] at: '#/webhooks'.
	self guard: [ self visitSecurity ] at: '#/security'.
	self guard: [ self checkOperations ] at: '#'.
	self guard: [ self resolveLinks ] at: '#'.
	self guard: [ self mergeSchemas ] at: '#'.
	self guard: [ self nameInlineSchemas ] at: '#'
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitComponents [
	"Passes 1 and 2: create then fill the components other than the schemas."

	(FamixOpenApiComponentsVisitor on: context) visit
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitDocument [
	"Pass: the root, its info, servers, tags, external documentation and components skeleton."

	(FamixOpenApiDocumentVisitor on: context) visit
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitPaths [
	"Read the paths and their operations, which can refer to every component."

	self pathVisitor visitPaths
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitSchemas [
	"Passes 1 and 2: create then fill the component schemas."

	(FamixOpenApiSchemaVisitor on: context) visit
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitSecurity [
	"Read the security requirements of the root."

	self securityVisitor
		fillSecurityOfOpenApi: self openApi
		from: self json
		at: '#'
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitWebhooks [

	self pathVisitor visitWebhooks
]
