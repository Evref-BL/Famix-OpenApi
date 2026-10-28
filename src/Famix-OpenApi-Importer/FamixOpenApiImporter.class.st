"
I am the facade of the OpenAPI importer. #importFromString:, #importFromFile: and #importFromJson: answer an OPModel and never raise for bad input: every problem is recorded in #diagnostics (invalidJson, unsupportedVersion, unresolvedReference, ...). After an import I answer the #model, its #openApi root entity (nil when the document could not be read), the #specVersion, the #diagnostics, the pointer #index, the parsed #json and the #mergeReport. Options: #sourceTextPolicy: (#none, #components (default: component entities, path items and operations) or #all) and #mergesInlineSchemas: (default true).
"
Class {
	#name : 'FamixOpenApiImporter',
	#superclass : 'Object',
	#instVars : [
		'sourceTextPolicy',
		'mergesInlineSchemas',
		'context'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'accessing' }
FamixOpenApiImporter >> diagnostics [
	"Answer the FamixOpenApiDiagnostics of the last import."

	^ context diagnostics
]

{ #category : 'importing' }
FamixOpenApiImporter >> importFromFile: aFileReferenceOrPathString [
	"Answer the model built from the JSON file aFileReferenceOrPathString."

	| file |
	file := aFileReferenceOrPathString asFileReference.
	file exists ifFalse: [
		| newContext |
		newContext := self newContext.
		newContext diagnostics
			error: #invalidJson
			pointer: '#'
			message: 'File not found: ' , file fullName.
		context := newContext.
		^ newContext model ].
	^ self importFromString: file contents
]

{ #category : 'importing' }
FamixOpenApiImporter >> importFromJson: aParsedTree [
	"Answer the model built from a JSON tree already parsed (dictionaries, arrays, strings, numbers, booleans and nil)."

	^ self importIn: (self newContext
			   json: aParsedTree;
			   yourself)
]

{ #category : 'importing' }
FamixOpenApiImporter >> importFromString: aJsonString [
	"Answer the model built from the JSON text aJsonString. Nothing is raised: an unparsable text is an invalidJson diagnostic and the model has no OpenApi root."

	| newContext |
	newContext := self newContext.
	[ newContext json: (self parse: aJsonString) ]
		on: Error
		do: [ :error |
			newContext diagnostics
				error: #invalidJson
				pointer: '#'
				message: error description.
			context := newContext.
			^ newContext model ].
	^ self importIn: newContext
]

{ #category : 'importing' }
FamixOpenApiImporter >> importIn: aContext [
	"Run the import of the document of aContext and answer its model."

	context := aContext.
	(FamixOpenApiJsonVisitor on: aContext) visit.
	^ aContext model
]

{ #category : 'accessing' }
FamixOpenApiImporter >> index [
	"Answer the FamixOpenApiPointerIndex of the last import."

	^ context index
]

{ #category : 'initialization' }
FamixOpenApiImporter >> initialize [

	super initialize.
	sourceTextPolicy := #components.
	mergesInlineSchemas := true.
	context := self newContext
]

{ #category : 'accessing' }
FamixOpenApiImporter >> json [
	"Answer the parsed JSON tree of the last import."

	^ context json
]

{ #category : 'accessing' }
FamixOpenApiImporter >> mergeReport [
	"Answer a Dictionary with the number of merged inline schemas (#merged), of sub-schemas (#subSchemas) and of inline schemas before merging (#inlineSchemas)."

	^ context mergeReport
]

{ #category : 'options' }
FamixOpenApiImporter >> mergesInlineSchemas [

	^ mergesInlineSchemas
]

{ #category : 'options' }
FamixOpenApiImporter >> mergesInlineSchemas: aBoolean [
	"Set whether identical inline schemas are merged and sub-schemas detected (default true)."

	mergesInlineSchemas := aBoolean
]

{ #category : 'accessing' }
FamixOpenApiImporter >> model [
	"Answer the OPModel of the last import."

	^ context model
]

{ #category : 'importing' }
FamixOpenApiImporter >> modelFromJsonFile: aFileReferenceOrPathString [
	"Alias of #importFromFile:."

	^ self importFromFile: aFileReferenceOrPathString
]

{ #category : 'importing' }
FamixOpenApiImporter >> modelFromJsonString: aJsonString [
	"Alias of #importFromString:."

	^ self importFromString: aJsonString
]

{ #category : 'importing' }
FamixOpenApiImporter >> newContext [
	"Answer a fresh import context carrying my options."

	^ FamixOpenApiImportContext new
		  sourceTextPolicy: sourceTextPolicy;
		  mergesInlineSchemas: mergesInlineSchemas;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiImporter >> openApi [
	"Answer the OPOpenApi root entity of the last import, or nil when the document could not be read."

	^ context openApi
]

{ #category : 'importing' }
FamixOpenApiImporter >> parse: aJsonString [
	"Answer the tree of aJsonString; the objects keep the order of their keys."

	^ (NeoJSONReader on: aJsonString readStream)
		  mapClass: OrderedDictionary;
		  next
]

{ #category : 'options' }
FamixOpenApiImporter >> sourceTextPolicy [
	"Answer #none, #components (default) or #all."

	^ sourceTextPolicy
]

{ #category : 'options' }
FamixOpenApiImporter >> sourceTextPolicy: aSymbol [
	"Set where the JSON text of the nodes is kept in the sourceText of the entities: #none (nowhere), #components (component entities, path items and operations) or #all."

	(#( #none #components #all ) includes: aSymbol) ifFalse: [
		^ self error: 'sourceTextPolicy must be #none, #components or #all' ].
	sourceTextPolicy := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiImporter >> specVersion [
	"Answer the FamixOpenApiSpecVersion of the last imported document, or nil."

	^ context specVersion
]
