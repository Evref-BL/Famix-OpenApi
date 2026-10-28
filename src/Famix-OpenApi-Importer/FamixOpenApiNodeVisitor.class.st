"
I am the abstract superclass of the visitors that read one part of an OpenAPI document into the model. I know the import context shared by all the visitors and offer short helpers on it (version, diagnostics, entity creation, pointers, external documentation). My subclasses implement one area each: document root, schemas and, in the next steps, paths, operations, parameters, responses, and so on.
"
Class {
	#name : 'FamixOpenApiNodeVisitor',
	#superclass : 'Object',
	#instVars : [
		'context'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'instance creation' }
FamixOpenApiNodeVisitor class >> on: anImportContext [
	"Answer a visitor working on anImportContext."

	^ self basicNew
		  setContext: anImportContext;
		  initialize;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> booleanAt: aKey in: aNode at: aPointer [

	^ context booleanAt: aKey in: aNode pointer: aPointer
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> context [

	^ context
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> diagnostics [

	^ context diagnostics
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> dictionaryAt: aKey in: aNode at: aPointer [

	^ context dictionaryAt: aKey in: aNode pointer: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> extensionsOf: aNode known: aKnownKeys at: aPointer [
	"Answer the extensions text of aNode (x- keys and unknown keys, the latter reported), or nil."

	^ context
		  extensionsTextOf: aNode
		  known: aKnownKeys
		  extra: #(  )
		  unmodelled: #(  )
		  at: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> externalDocsIn: aNode at: aPointer [
	"Answer the ExternalDocumentation described under the externalDocs key of aNode (located at aPointer), or nil."

	| node pointer docs |
	node := self dictionaryAt: 'externalDocs' in: aNode at: aPointer.
	node ifNil: [ ^ nil ].
	pointer := self pointer: aPointer appending: 'externalDocs'.
	docs := self
		        newEntity: OPExternalDocumentation
		        named: nil
		        pointer: pointer.
	docs
		description: (self stringAt: 'description' in: node at: pointer);
		url: (self stringAt: 'url' in: node at: pointer);
		extensions:
			(self
				 extensionsOf: node
				 known: #( 'description' 'url' )
				 at: pointer).
	context recordSourceTextOf: docs from: node category: #inline.
	^ docs
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> guard: aBlock at: aPointer [

	^ context guard: aBlock at: aPointer
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> index [

	^ context index
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> json [

	^ context json
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> listAt: aKey in: aNode at: aPointer [

	^ context listAt: aKey in: aNode pointer: aPointer
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> model [

	^ context model
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> newEntity: aClass named: aName pointer: aPointer [
	"Create and register an entity of aClass at aPointer."

	^ context newEntity: aClass named: aName pointer: aPointer
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> numberAt: aKey in: aNode at: aPointer [

	^ context numberAt: aKey in: aNode pointer: aPointer
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> openApi [

	^ context openApi
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> pointer: aPointer appending: aToken [

	^ FamixOpenApiJsonPointer pointer: aPointer appending: aToken
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> pointer: aPointer appending: aToken appending: anotherToken [

	^ self
		  pointer: (self pointer: aPointer appending: aToken)
		  appending: anotherToken
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> setContext: anImportContext [

	context := anImportContext
]

{ #category : 'accessing' }
FamixOpenApiNodeVisitor >> specVersion [

	^ context specVersion
]

{ #category : 'helpers' }
FamixOpenApiNodeVisitor >> stringAt: aKey in: aNode at: aPointer [

	^ context stringAt: aKey in: aNode pointer: aPointer
]
