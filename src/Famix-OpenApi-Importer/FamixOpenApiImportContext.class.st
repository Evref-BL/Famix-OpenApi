"
I hold the state shared by the visitors of one import: the OPModel under construction, the pointer index, the diagnostics, the specification version of the document, the parsed JSON tree, the options (source text policy, inline schema merging), the root OpenApi entity and the Components entity. I create entities through the model and register them in the index, I read the JSON nodes safely (a node of the wrong type is reported as a wrongNodeType diagnostic and skipped) and I turn the Errors of a unit of work into importError diagnostics. I belong to the importer, not to the metamodel.
"
Class {
	#name : 'FamixOpenApiImportContext',
	#superclass : 'Object',
	#instVars : [
		'model',
		'index',
		'diagnostics',
		'specVersion',
		'json',
		'sourceTextPolicy',
		'mergesInlineSchemas',
		'openApi',
		'components',
		'creationOrder',
		'creationCounter',
		'mergeReport'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> booleanAt: aKey in: aNode pointer: aPointer [

	^ self
		  valueAt: aKey
		  in: aNode
		  pointer: aPointer
		  expecting: 'a boolean'
		  satisfying: [ :value | self isBooleanValue: value ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> components [

	^ components
]

{ #category : 'entities' }
FamixOpenApiImportContext >> copyCreationIndexOf: anOldEntity to: aNewEntity [
	"Let aNewEntity take the place of anOldEntity in the document order."

	creationOrder at: aNewEntity put: (self creationIndexOf: anOldEntity)
]

{ #category : 'entities' }
FamixOpenApiImportContext >> creationIndexOf: anEntity [
	"Answer the rank of anEntity in the document order of creation."

	^ creationOrder at: anEntity ifAbsent: [ SmallInteger maxVal ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> diagnostics [

	^ diagnostics
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> dictionaryAt: aKey in: aNode pointer: aPointer [

	^ self
		  valueAt: aKey
		  in: aNode
		  pointer: aPointer
		  expecting: 'an object'
		  satisfying: [ :value | value isDictionary ]
]

{ #category : 'entities' }
FamixOpenApiImportContext >> ensureComponents [
	"Answer the Components entity of the document, created on first use."

	components ifNil: [
		components := self
			              newEntity: OPComponents
			              named: 'components'
			              pointer: '#/components'.
		openApi ifNotNil: [ openApi components: components ] ].
	^ components
]

{ #category : 'pointers' }
FamixOpenApiImportContext >> entityAt: aPointer [
	"Answer the entity registered at the document pointer aPointer, or nil."

	^ index lookup: (self indexKeyFor: aPointer)
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> extensionsTextOf: aNode known: aKnownKeys extra: anExtraKeys unmodelled: anUnmodelledKeys at: aPointer [
	"Answer the JSON object text of the keys of aNode that the entity does not model, or nil when there is none: the x- keys, the keys of anExtraKeys (modelled by no slot) and every key that is not in aKnownKeys. The latter are reported as an info unmodelledKeyword (when in anUnmodelledKeys) or unknownKeyword diagnostic."

	| extensions |
	aNode isDictionary ifFalse: [ ^ nil ].
	extensions := OrderedDictionary new.
	aNode keysAndValuesDo: [ :key :value |
		(self
			 isExtensionOrUnmodelled: key
			 known: aKnownKeys
			 extra: anExtraKeys
			 unmodelled: anUnmodelledKeys
			 at: aPointer) ifTrue: [ extensions at: key put: value ] ].
	extensions ifEmpty: [ ^ nil ].
	^ self jsonTextOf: extensions
]

{ #category : 'resolving' }
FamixOpenApiImportContext >> guard: aBlock at: aPointer [
	"Evaluate aBlock, the work of one unit of the import. An Error is recorded as an importError diagnostic at aPointer, so that the import goes on with the next unit; answer nil then."

	^ [ aBlock value ]
		  on: Error
		  do: [ :error |
			  diagnostics
				  error: #importError
				  pointer: aPointer
				  message: error class name , ': ' , error description.
			  nil ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> index [

	^ index
]

{ #category : 'pointers' }
FamixOpenApiImportContext >> indexKeyFor: aPointer [
	"Answer the key under which the entity located at aPointer (a document position) is looked up in the index."

	^ specVersion
		  ifNil: [ aPointer ]
		  ifNotNil: [ specVersion refTargetPointerFor: aPointer ]
]

{ #category : 'initialization' }
FamixOpenApiImportContext >> initialize [

	super initialize.
	diagnostics := FamixOpenApiDiagnostics new.
	index := FamixOpenApiPointerIndex diagnostics: diagnostics.
	model := OPModel new.
	creationOrder := IdentityDictionary new.
	creationCounter := 0.
	sourceTextPolicy := #components.
	mergesInlineSchemas := true.
	mergeReport := Dictionary new
]

{ #category : 'entities' }
FamixOpenApiImportContext >> inlineSchemaCount [
	"Answer the number of Schemas that are not reusable components."

	^ (model allWithSubTypesOf: OPSchema) count: [ :each |
		  each components isNil ]
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> isBooleanValue: aValue [
	"Answer whether aValue is a JSON boolean."

	^ aValue == true or: [ aValue == false ]
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> isExtensionOrUnmodelled: aKey known: aKnownKeys extra: anExtraKeys unmodelled: anUnmodelledKeys at: aPointer [
	"Answer whether aKey goes to the extensions of its node, after reporting it when it is not a known key."

	(specVersion isExtensionKey: aKey) ifTrue: [ ^ true ].
	(anExtraKeys includes: aKey) ifTrue: [ ^ true ].
	(aKnownKeys includes: aKey) ifTrue: [ ^ false ].
	(anUnmodelledKeys includes: aKey)
		ifTrue: [
			diagnostics
				info: #unmodelledKeyword
				pointer:
				(FamixOpenApiJsonPointer pointer: aPointer appending: aKey)
				message: 'Keyword ' , aKey printString
					, ' is not modelled; kept in the extensions' ]
		ifFalse: [
			diagnostics
				info: #unknownKeyword
				pointer:
				(FamixOpenApiJsonPointer pointer: aPointer appending: aKey)
				message:
				'Unknown key ' , aKey printString , '; kept in the extensions' ].
	^ true
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> isList: aValue [
	"Answer whether aValue is a JSON array."

	^ aValue isCollection and: [
		  aValue isString not and: [ aValue isDictionary not ] ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> json [

	^ json
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> json: aParsedTree [

	json := aParsedTree
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> jsonTextOf: aValue [
	"Answer the JSON text of aValue."

	^ NeoJSONWriter toString: aValue
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> listAt: aKey in: aNode pointer: aPointer [

	^ self
		  valueAt: aKey
		  in: aNode
		  pointer: aPointer
		  expecting: 'an array'
		  satisfying: [ :value | self isList: value ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> mergeReport [

	^ mergeReport
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> mergeReport: aDictionary [

	mergeReport := aDictionary
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> mergesInlineSchemas [

	^ mergesInlineSchemas
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> mergesInlineSchemas: aBoolean [

	mergesInlineSchemas := aBoolean
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> model [

	^ model
]

{ #category : 'entities' }
FamixOpenApiImportContext >> newEntity: aClass named: aName pointer: aPointer [
	"Create an entity of aClass in the model, set its canonical pointer and register it in the index."

	| entity |
	entity := self
		          newUnindexedEntity: aClass
		          named: aName
		          pointer: aPointer.
	self register: entity at: aPointer.
	^ entity
]

{ #category : 'entities' }
FamixOpenApiImportContext >> newUnindexedEntity: aClass named: aName pointer: aPointer [
	"Create an entity of aClass in the model and set its canonical pointer, without registering it (a Property shares the pointer of its value schema; an unresolved Reference sits at the pointer of its site)."

	| entity |
	entity := model add: (aClass named: aName).
	entity canonicalPointer: aPointer.
	creationOrder
		at: entity
		put: (creationCounter := creationCounter + 1).
	^ entity
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> numberAt: aKey in: aNode pointer: aPointer [

	^ self
		  valueAt: aKey
		  in: aNode
		  pointer: aPointer
		  expecting: 'a number'
		  satisfying: [ :value | value isNumber ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> openApi [

	^ openApi
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> openApi: anOpenApi [

	openApi := anOpenApi
]

{ #category : 'pointers' }
FamixOpenApiImportContext >> pointerForReference: aRefString [
	"Answer the index key designated by the raw reference aRefString: its percent and tilde escapes decoded then encoded back, with the Swagger 2 sections translated to the components ones."

	| tokens |
	tokens := FamixOpenApiJsonPointer tokensFromReference: aRefString.
	^ specVersion refTargetPointerFor: (tokens
			   ifNil: [ aRefString ]
			   ifNotNil: [ FamixOpenApiJsonPointer pointerFromTokens: tokens ])
]

{ #category : 'source text' }
FamixOpenApiImportContext >> recordSourceTextOf: anEntity from: aNode category: aCategory [
	"Set the sourceText of anEntity to the JSON text of aNode when the policy asks for its category."

	(self shouldRecordSourceTextFor: aCategory) ifTrue: [
		anEntity sourceText: (self jsonTextOf: aNode) ]
]

{ #category : 'resolving' }
FamixOpenApiImportContext >> recordUnresolvedReference: aRefString at: aPointer [
	"Attach to the document a Reference standing for the unresolved aRefString written at aPointer."

	openApi ifNil: [ ^ self ].
	openApi addUnresolvedReference: ((self
			  newUnindexedEntity: OPReference
			  named: (aRefString splitOn: $/) last
			  pointer: aPointer)
			 target: aRefString;
			 yourself)
]

{ #category : 'pointers' }
FamixOpenApiImportContext >> register: anEntity at: aPointer [
	"Register anEntity in the index at its document pointer and, when the version translates it (Swagger 2 #/definitions/X is #/components/schemas/X), at the translated pointer too: both resolve to the same entity."

	| key |
	index register: anEntity at: aPointer.
	key := self indexKeyFor: aPointer.
	key = aPointer ifFalse: [ index register: anEntity at: key ]
]

{ #category : 'pointers' }
FamixOpenApiImportContext >> registerAlias: aPointer to: aRefString [
	"Register the node at aPointer, which is only a reference, as an alias of aRefString."

	index registerAlias: (self indexKeyFor: aPointer) to: aRefString
]

{ #category : 'resolving' }
FamixOpenApiImportContext >> resolveQuietly: aRefString at: aPointer expecting: aClass [
	"Answer the entity designated by aRefString, or nil, without any diagnostic (the caller reports its own)."

	| saved target |
	saved := index diagnostics.
	index setDiagnostics: FamixOpenApiDiagnostics new.
	[
	target := index
		          resolveReference: aRefString
		          from: aPointer
		          expecting: aClass ] ensure: [ index setDiagnostics: saved ].
	^ target
]

{ #category : 'resolving' }
FamixOpenApiImportContext >> resolveReference: aRefString at: aPointer expecting: aClass [
	"Answer the entity designated by aRefString written at aPointer. When it cannot be resolved the index has recorded the diagnostic and I add an unresolved Reference to the document; answer nil."

	| target |
	target := index
		          resolveReference: aRefString
		          from: aPointer
		          expecting: aClass.
	target ifNil: [
		self recordUnresolvedReference: aRefString at: aPointer ].
	^ target
]

{ #category : 'entities' }
FamixOpenApiImportContext >> schemasInCreationOrder [
	"Answer the OrderedCollection of every Schema (SubSchemas included) of the model, in document order."

	^ (model allWithSubTypesOf: OPSchema) asOrderedCollection sort: [ :a :b |
		  (self creationIndexOf: a) <= (self creationIndexOf: b) ]
]

{ #category : 'source text' }
FamixOpenApiImportContext >> shouldRecordSourceTextFor: aCategory [
	"Answer whether the source text is recorded for an entity of aCategory (#component, #pathItem, #operation or any other symbol) under the source text policy."

	sourceTextPolicy == #all ifTrue: [ ^ true ].
	^ sourceTextPolicy == #components and: [
		  #( #component #pathItem #operation ) includes: aCategory ]
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> sourceTextPolicy [

	^ sourceTextPolicy
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> sourceTextPolicy: aSymbol [

	(#( #none #components #all ) includes: aSymbol) ifFalse: [
		^ self error: 'sourceTextPolicy must be #none, #components or #all' ].
	sourceTextPolicy := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> specVersion [

	^ specVersion
]

{ #category : 'accessing' }
FamixOpenApiImportContext >> specVersion: aVersion [
	"Set the version of the document and make the index translate the raw references with it."

	specVersion := aVersion.
	index translateRefsWith: [ :ref | self pointerForReference: ref ]
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> stringAt: aKey in: aNode pointer: aPointer [

	^ self
		  valueAt: aKey
		  in: aNode
		  pointer: aPointer
		  expecting: 'a string'
		  satisfying: [ :value | value isString ]
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> valueAt: aKey in: aNode pointer: aPointer expecting: aDescription satisfying: aBlock [
	"Answer the value of aKey in aNode when it satisfies aBlock. A missing key or a JSON null answers nil; a value of another type is reported as a wrongNodeType warning and answers nil."

	| value |
	aNode isDictionary ifFalse: [ ^ nil ].
	value := aNode at: aKey ifAbsent: [ ^ nil ].
	value ifNil: [ ^ nil ].
	(aBlock value: value) ifTrue: [ ^ value ].
	self
		wrongNodeAt:
		(FamixOpenApiJsonPointer pointer: aPointer appending: aKey)
		expecting: aDescription
		found: value.
	^ nil
]

{ #category : 'reading nodes' }
FamixOpenApiImportContext >> wrongNodeAt: aPointer expecting: aDescription found: aValue [
	"Report that the node at aPointer is not of the expected kind."

	diagnostics
		warning: #wrongNodeType
		pointer: aPointer
		message:
		'Expected ' , aDescription , ' but found ' , aValue class name
]
