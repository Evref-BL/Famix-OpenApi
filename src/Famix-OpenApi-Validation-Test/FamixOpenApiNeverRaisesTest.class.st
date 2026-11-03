"
The existence check and the value check never raise: every position of the rich documents (OpenAPI 3.0, 3.1, Swagger 2) is replaced in turn by a number, a string, null, true, an empty array, an empty object, a nested object and an object whose $ref is not a string, the document is imported and both checks run. The positions are the first one of every (spec object, field) and a sample of the others, chosen with a fixed seed. The exceptions of the importer itself are kept apart (importerErrors) and the document is skipped.
"
Class {
	#name : 'FamixOpenApiNeverRaisesTest',
	#superclass : 'FamixOpenApiValueTestCase',
	#instVars : [
		'failures',
		'importerErrors',
		'runs',
		'positionClasses'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> checkText: aJsonString label: aLabel [
	"Import the text (an exception of the importer is kept in importerErrors and the text skipped), then run the three checks, which must not raise"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := [ importer importFromString: aJsonString ]
		         on: Error
		         do: [ :error |
			         importerErrors add: aLabel -> error messageText.
			         ^ self ].
	runs := runs + 1.
	self
		guard: [
			FamixOpenApiExistenceCheck
				checkInventory: (self inventoryOf: aJsonString)
				model: model
				diagnostics: importer diagnostics ]
		label: aLabel
		check: 'existence'.
	self
		guard: [ self valueReportOf: aJsonString model: model ]
		label: aLabel
		check: 'value'.
	self
		guard: [
			FamixOpenApiExtensionsCheck
				checkInventory: (self inventoryOf: aJsonString)
				model: model
				diagnostics: importer diagnostics ]
		label: aLabel
		check: 'extensions'
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> child: aToken of: aContainer [
	"The element of an object (token: key) or of an array (token: 0-based index)"

	^ aContainer isDictionary
		  ifTrue: [ aContainer at: aToken ]
		  ifFalse: [ aContainer at: aToken + 1 ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> collectPathsIn: aJsonValue from: aPath on: aStream [

	aStream nextPut: aPath.
	aJsonValue isDictionary ifTrue: [
		aJsonValue keysAndValuesDo: [ :key :each |
			self collectPathsIn: each from: aPath , { key } on: aStream ] ].
	aJsonValue isArray ifTrue: [
		aJsonValue withIndexDo: [ :each :index |
			self collectPathsIn: each from: aPath , { (index - 1) } on: aStream ] ]
]

{ #category : 'accessing' }
FamixOpenApiNeverRaisesTest >> defaultTimeLimit [
	"About 4000 documents are imported and checked"

	^ 3 minutes
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> failures [
	"What the checks raised: document, position, replacement, check and exception"

	^ failures
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> fuzzDocument: aJsonString named: aName [
	"Both checks over the document mutated at the chosen positions, in turn by every replacement"

	| json inventory |
	json := (NeoJSONReader on: aJsonString readStream)
		        mapClass: OrderedDictionary;
		        next.
	inventory := self inventoryOf: aJsonString.
	(self positionsOf: json in: inventory) do: [ :path |
		self replacements do: [ :each |
			self
				checkText: (self mutate: json at: path with: each)
				label: (self labelOf: aName at: path replacedBy: each) ] ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> fuzzRichDocuments [

	self richDocuments do: [ :each |
		self fuzzDocument: each value named: each key ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> guard: aBlock label: aLabel check: aCheckName [
	"Run the block, keep the exception in failures instead of raising it"

	aBlock
		on: Error
		do: [ :error |
			failures add:
				aCheckName , ' ' , aLabel , ': ' , error class name , ' '
				, error messageText asString , ' in '
				, error signalerContext sender printString ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> importerErrors [
	"What the importer itself raised, for the documents the checks skipped"

	^ importerErrors
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> labelOf: aName at: aPath replacedBy: aReplacement [

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: aName;
			  space;
			  nextPutAll: (self pointerOf: aPath);
			  nextPutAll: ' <- ';
			  print: aReplacement ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> mutate: aJsonValue at: aPath with: aReplacement [
	"The JSON text of a copy of the value where the position has the replacement"

	| copy holder |
	aPath ifEmpty: [ ^ self textOf: aReplacement ].
	copy := aJsonValue deepCopy.
	holder := aPath allButLast
		          inject: copy
		          into: [ :each :token | self child: token of: each ].
	self put: aReplacement at: aPath last in: holder.
	^ self textOf: copy
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> nestedObject [

	^ OrderedDictionary new
		  at: 'a' put: (OrderedDictionary new
				   at: 'b' put: #( 1 );
				   yourself);
		  yourself
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> objectWithNumericReference [

	^ OrderedDictionary new
		  at: '$ref' put: 7;
		  yourself
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> pathsIn: aJsonValue [
	"Every position of the value as a path of tokens (the key of an object, the index of an array), the root included (the empty path)"

	^ Array streamContents: [ :stream |
		  self collectPathsIn: aJsonValue from: #(  ) on: stream ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> pointerOf: aPath [

	^ aPath
		  inject: FamixOpenApiSourceNode rootPointer
		  into: [ :pointer :token |
			  FamixOpenApiSourceNode pointerOf: pointer child: token ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> positionClassOf: aPath in: anInventory [
	"The version, the spec object and the field of the position: the ones of the node when it is one, the ones of the object that holds it and the key otherwise"

	| node |
	node := anInventory nodeAt: (self pointerOf: aPath) ifAbsent: [ nil ].
	node ifNotNil: [
		^ anInventory version asString , ' '
		  , (anInventory siteSpecObjectOf: node) asString , '.'
		  , (anInventory fieldOf: node) asString ].
	^ anInventory version asString , ' '
	  , (self scalarClassOf: aPath in: anInventory)
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> positionClasses [
	"The (spec object, field) pairs of the positions tried"

	^ positionClasses
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> positionsOf: aJsonValue in: anInventory [
	"The first position of every (version, spec object, field) that no document tried before, and a sample of 15 others, chosen with a fixed seed (the result is always the same for a document)"

	| byClass random all firsts |
	all := self pathsIn: aJsonValue.
	byClass := all groupedBy: [ :each |
		           self positionClassOf: each in: anInventory ].
	firsts := byClass keys asArray sorted
		          reject: [ :each | positionClasses includes: each ]
		          thenCollect: [ :each | (byClass at: each) first ].
	positionClasses addAll: byClass keys.
	random := Random seed: 42.
	^ firsts , ((1 to: 15) collect: [ :each | all atRandom: random ])
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> put: aValue at: aToken in: aContainer [

	aContainer isDictionary
		ifTrue: [ aContainer at: aToken put: aValue ]
		ifFalse: [ aContainer at: aToken + 1 put: aValue ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> replacements [
	"The values put in turn at a position: a number, a string, null, true, an empty array, an empty object, a nested object and an object whose $ref is not a string"

	^ {
		  7.
		  'text'.
		  nil.
		  true.
		  #(  ).
		  OrderedDictionary new.
		  self nestedObject.
		  self objectWithNumericReference }
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> richDocuments [
	"Associations name -> JSON text of the rich fixtures: OpenAPI 3.0, 3.1 and Swagger 2, for the checks of values and of existence"

	^ {
		  ('values30' -> self documentValues30).
		  ('values31' -> self documentValues31).
		  ('valuesSwagger2' -> self documentValuesSwagger2).
		  ('openApi30' -> self documentOpenApi30).
		  ('openApi31' -> self documentOpenApi31).
		  ('swagger2' -> self documentSwagger2) }
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> runs [
	"The number of documents imported and checked"

	^ runs
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> scalarClassOf: aPath in: anInventory [
	"The position is not a node: the object that holds it is the longest prefix that is one"

	| size owner |
	size := (aPath size - 1 to: 0 by: -1)
		        detect: [ :each |
			        (anInventory
				         nodeAt: (self pointerOf: (aPath first: each))
				         ifAbsent: [ nil ]) isNotNil ]
		        ifNone: [ 0 ].
	owner := anInventory
		         nodeAt: (self pointerOf: (aPath first: size))
		         ifAbsent: [ nil ].
	^ (owner
		   ifNil: [ '-' ]
		   ifNotNil: [ :node | node specObject asString ]) , '.'
	  , (aPath at: size + 1) asString , (aPath size > (size + 1)
		   ifTrue: [ '/*' ]
		   ifFalse: [ '' ])
]

{ #category : 'running' }
FamixOpenApiNeverRaisesTest >> setUp [

	super setUp.
	failures := OrderedCollection new.
	importerErrors := OrderedCollection new.
	positionClasses := Set new.
	runs := 0
]

{ #category : 'tests' }
FamixOpenApiNeverRaisesTest >> testAMutationReplacesOnlyThePosition [

	| json mutated |
	json := (NeoJSONReader on: '{"a":[1,{"b":2}],"c":3}' readStream)
		        mapClass: OrderedDictionary;
		        next.
	mutated := self mutate: json at: #( 'a' 1 'b' ) with: 'x'.
	self assert: mutated equals: '{"a":[1,{"b":"x"}],"c":3}'.
	self assert: (self mutate: json at: #(  ) with: 7) equals: '7'.
	self assert: (json at: 'c') equals: 3
]

{ #category : 'tests' }
FamixOpenApiNeverRaisesTest >> testRichDocumentsNeverRaise [
	"Neither check raises over the rich documents with a position replaced (importer exceptions are kept in importerErrors and skipped)"

	self fuzzRichDocuments.
	self
		assert: failures isEmpty
		description:
		(self describe: (failures first: (5 min: failures size))).
	self assert: runs >= 3000.
	self assert: positionClasses size >= 250
]

{ #category : 'tests' }
FamixOpenApiNeverRaisesTest >> testThePositionsOfADocumentAreAlwaysTheSame [

	| json inventory first second |
	json := (NeoJSONReader on: self documentValues31 readStream)
		        mapClass: OrderedDictionary;
		        next.
	inventory := self inventoryOf: self documentValues31.
	first := self positionsOf: json in: inventory.
	positionClasses := Set new.
	second := self positionsOf: json in: inventory.
	self assert: first equals: second.
	self assert: (first includes: #(  ))
]

{ #category : 'tests' }
FamixOpenApiNeverRaisesTest >> testTheReplacementsAreTheEightKindsOfValues [

	self assert: self replacements size equals: 8.
	self assert: self replacements last isDictionary.
	self assert: (self replacements last at: '$ref') equals: 7
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> textOf: aJsonValue [

	^ String streamContents: [ :stream |
		  (NeoJSONWriter on: stream) nextPut: aJsonValue ]
]

{ #category : 'fuzzing' }
FamixOpenApiNeverRaisesTest >> valueReportOf: aJsonString model: aModel [

	^ (self valueCheckOf: aJsonString model: aModel) report
]
