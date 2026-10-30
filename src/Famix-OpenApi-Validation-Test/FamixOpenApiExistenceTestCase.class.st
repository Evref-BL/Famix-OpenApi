"
Helpers of the tests of the existence check (V7 and V7b): the real importer (mergesInlineSchemas false; the test package may use it, the production package may not), the inventory of the walker, the report of the check, the mutations of a model (add, remove, replace, move an entity) and the sweeps over the entities that the derivations expect. The documents are in FamixOpenApiExistenceDocumentsTestCase.
"
Class {
	#name : 'FamixOpenApiExistenceTestCase',
	#superclass : 'FamixOpenApiExistenceDocumentsTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> add: aClass at: aPointer to: aModel [
	"Add a stray entity of aClass at aPointer"

	aModel add: (aClass new
			 canonicalPointer: aPointer;
			 yourself)
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> alternativeClassTo: aClass [
	"Another class of the family of aClass, nil when the family has none (the sub-schema is left out: it is the sign of a merged import, a precondition of the check)"

	^ ((FamixOpenApiPointerLookup familyOfClass: aClass)
		   withAllSubclasses copyWithoutAll: {
			   aClass.
			   OPSubSchema })
		  detect: [ :each | each isAbstract not ]
		  ifNone: [ nil ]
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> assertDerivedSweepsIn: aJsonString named: aName [
	"Every entity that a derivation expects, in the model of the real import: taken out it is a #missingEntity of its rule, doubled an #unexpectedMultiple of its rule, of another class of its family a #wrongClass of its rule (of another family a #missingEntity and an #extraEntity)"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	(self derivedFor: aJsonString) expectedEntities do: [ :each |
		self
			assertRemoval: each
			in: model
			inventory: inventory
			named: aName.
		self
			assertTwin: each
			in: model
			inventory: inventory
			named: aName.
		self
			assertSubstitute: each
			in: model
			inventory: inventory
			named: aName ]
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertDuplicatesAreDetectedIn: aJsonString named: aName [
	"A second entity of the same class at the pointer of a node is reported as unexpectedMultiple"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	model allModelEntities copy
		select: [ :entity |
		inventory includesPointer: entity canonicalPointer ]
		thenDo: [ :entity |
			| twin kinds |
			twin := entity class new
				        canonicalPointer: entity canonicalPointer;
				        yourself.
			model add: twin.
			kinds := self
				         kindsAt: entity canonicalPointer
				         in: (self reportOf: model inventory: inventory).
			model remove: twin.
			self
				assert: (kinds includes: #unexpectedMultiple)
				description: (self describe: {
							 aName.
							 entity canonicalPointer }) ]
]

{ #category : 'helpers - synthetic' }
FamixOpenApiExistenceTestCase >> assertFaithful: aJsonString [
	"The real import of the document has no gap: what the derivations expect is exactly what the importer builds"

	| gaps |
	gaps := (self reportFor: aJsonString) gaps.
	self assert: gaps isEmpty description: (self describe: gaps)
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> assertGapsOf: aJsonString after: aBlock are: anArray [
	"anArray holds the expected kind -> pointer associations, in any order"

	self
		assert: (self gapsOf: aJsonString after: aBlock)
		equals: (anArray collect: [ :each |
				 self describeKind: each key pointer: each value ]) asArray sorted
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertMovesAreDetectedIn: aJsonString named: aName [
	"Every entity, synthetic or not, moved to a pointer that no node and no rule explains is an extra entity there"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	model allModelEntities copy do: [ :entity |
		| original kinds |
		original := entity canonicalPointer.
		entity canonicalPointer: '#/stray'.
		kinds := self
			         kindsAt: '#/stray'
			         in: (self reportOf: model inventory: inventory).
		entity canonicalPointer: original.
		self
			assert: (kinds includes: #extraEntity)
			description: (self describe: {
						 aName.
						 original.
						 entity class name }) ]
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> assertRemoval: anExpected in: aModel inventory: anInventory named: aName [

	| real descriptions |
	real := self realEntityOf: anExpected in: aModel.
	aModel remove: real.
	descriptions := self descriptionsOf: aModel inventory: anInventory.
	aModel add: real.
	self
		assert: (descriptions includes:
				 (self describeExpected: anExpected kind: #missingEntity))
		description: (self describe: {
					 aName.
					 'removed'.
					 anExpected })
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertRemovalsAreDetectedIn: aJsonString named: aName [
	"Every entity at the pointer of a node is expected by the check: take it out of the model and the check must say so"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	model allModelEntities copy
		select: [ :entity |
		inventory includesPointer: entity canonicalPointer ]
		thenDo: [ :entity |
			| kinds |
			model remove: entity.
			kinds := self
				         kindsAt: entity canonicalPointer
				         in: (self reportOf: model inventory: inventory).
			model add: entity.
			self
				assert:
				(kinds includesAny: #( #missingEntity #referenceNotResolved ))
				description: (self describe: {
							 aName.
							 entity canonicalPointer.
							 entity class name }) ]
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertStrayAt: aPointer in: aModel inventory: anInventory named: aName [
	"A stray entity of a family that no node ever gives (OPDiscriminatorMapping: only a synthetic one) put at aPointer is reported as extra, then taken out again"

	| stray kinds |
	stray := OPDiscriminatorMapping new
		         canonicalPointer: aPointer;
		         yourself.
	aModel add: stray.
	kinds := self
		         kindsAt: aPointer
		         in: (self reportOf: aModel inventory: anInventory).
	aModel remove: stray.
	self
		assert: (kinds includes: #extraEntity)
		description: (self describe: {
					 aName.
					 aPointer })
]

{ #category : 'sweeps' }
FamixOpenApiExistenceTestCase >> assertStraysAreDetectedIn: aJsonString named: aName [
	"An entity of a family that no node gives, put at the pointer of every node in turn"

	| inventory model |
	inventory := self inventoryOf: aJsonString.
	model := self modelOf: aJsonString.
	inventory pointers do: [ :pointer |
		self
			assertStrayAt: pointer
			in: model
			inventory: inventory
			named: aName ]
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> assertSubstitute: anExpected in: aModel inventory: anInventory named: aName [
	"The entity replaced by one of another class of its family (a #wrongClass), or of another family when it has no sibling class (#missingEntity and #extraEntity)"

	| real other substitute descriptions expectedKinds |
	real := self realEntityOf: anExpected in: aModel.
	other := self alternativeClassTo: real class.
	substitute := (other ifNil: [ OPTag ]) new
		              canonicalPointer: anExpected pointer;
		              yourself.
	aModel remove: real.
	aModel add: substitute.
	descriptions := self descriptionsOf: aModel inventory: anInventory.
	aModel remove: substitute.
	aModel add: real.
	expectedKinds := other
		                 ifNil: [ #( #missingEntity #extraEntity ) ]
		                 ifNotNil: [ #( #wrongClass ) ].
	expectedKinds do: [ :kind |
		self
			assert:
			(self
				 descriptions: descriptions
				 include: kind
				 at: anExpected pointer)
			description: (self describe: {
						 aName.
						 'substituted'.
						 anExpected.
						 kind }) ]
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> assertTwin: anExpected in: aModel inventory: anInventory named: aName [

	| twin descriptions |
	twin := (self realEntityOf: anExpected in: aModel) class new
		        canonicalPointer: anExpected pointer;
		        yourself.
	aModel add: twin.
	descriptions := self descriptionsOf: aModel inventory: anInventory.
	aModel remove: twin.
	self
		assert: (descriptions includes:
				 (self describeExpected: anExpected kind: #unexpectedMultiple))
		description: (self describe: {
					 aName.
					 'doubled'.
					 anExpected })
]

{ #category : 'helpers - synthetic' }
FamixOpenApiExistenceTestCase >> derivedCountsByRuleIn: aJsonString [
	"A Dictionary rule name -> number of derived entities"

	| counts |
	counts := (self derivedFor: aJsonString) expectedEntities
		          collect: #ruleName
		          as: Bag.
	^ (counts asSet collect: [ :rule |
		   rule -> (counts occurrencesOf: rule) ]) asDictionary
]

{ #category : 'helpers - synthetic' }
FamixOpenApiExistenceTestCase >> derivedFor: aJsonString [
	"The entities without node that the derivations expect for the document"

	^ FamixOpenApiSyntheticExpectations on:
		  (self inventoryOf: aJsonString)
]

{ #category : 'helpers - synthetic' }
FamixOpenApiExistenceTestCase >> derivedPointersOf: aClass in: aJsonString [
	"The sorted pointers where an entity of exactly aClass is derived (twice when it is derived twice)"

	^ ((self derivedFor: aJsonString) expectedEntities
		   select: [ :each | each targetClassName = aClass name ]
		   thenCollect: #pointer) asArray sorted
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> describe: aCollection [
	"A failure description: the printed elements of aCollection separated by spaces"

	^ ' ' join: (aCollection collect: #asString)
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> describeExpected: anExpected kind: aKind [
	"The description of the gap of aKind about an expected entity"

	^ aKind asString , ' ' , anExpected pointer , ' '
	  , anExpected ruleName asString
]

{ #category : 'helpers - synthetic' }
FamixOpenApiExistenceTestCase >> describeGap: aGap [
	"'kind pointer rule' (without the rule for a gap about a node of the document)"

	^ (self describeKind: aGap kind pointer: aGap sourcePointer)
	  , (aGap ruleName ifNil: [ '' ] ifNotNil: [ :rule | ' ' , rule ])
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> describeKind: aKind pointer: aPointer [

	^ aKind asString , ' ' , aPointer asString
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> descriptions: aCollection include: aKind at: aPointer [
	"True when a description of aCollection is about a gap of aKind at aPointer"

	| prefix |
	prefix := self describeKind: aKind pointer: aPointer.
	^ aCollection anySatisfy: [ :each | each beginsWith: prefix ]
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> descriptionsOf: aModel inventory: anInventory [
	"The 'kind pointer rule' Strings of the gaps of the model"

	^ (self reportOf: aModel inventory: anInventory) gaps collect: [
		  :each | self describeGap: each ]
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> entity: aClass at: aPointer in: aModel [
	"The only entity of exactly aClass at aPointer"

	| found |
	found := self entityOf: aClass at: aPointer in: aModel.
	self assert: found size equals: 1.
	^ found first
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> entityOf: aClass at: aPointer in: aModel [
	"The entity of exactly aClass at aPointer"

	^ (FamixOpenApiPointerLookup onModel: aModel)
		  entitiesAt: aPointer
		  ofClass: aClass
]

{ #category : 'helpers - synthetic' }
FamixOpenApiExistenceTestCase >> gapDescriptionsOf: aJsonString after: aBlock [
	"The gaps of the model of aJsonString mutated by aBlock, as sorted 'kind pointer rule' Strings"

	| model |
	model := self modelOf: aJsonString.
	aBlock value: model.
	^ ((self reportOf: model for: aJsonString) gaps collect: [ :each |
		   self describeGap: each ]) asArray sorted
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> gapsOf: aJsonString after: aBlock [
	"The gaps of the model of aJsonString mutated by aBlock (given the model), as sorted 'kind pointer' Strings"

	| model |
	model := self modelOf: aJsonString.
	aBlock value: model.
	^ ((self reportOf: model for: aJsonString) gaps collect: [ :each |
		   self describeKind: each kind pointer: each sourcePointer ])
		  asArray sorted
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> inventoryOf: aJsonString [
	"The inventory of the source document, read independently of the importer, with the objects in the order of their keys as the importer does"

	^ FamixOpenApiSourceWalker new walkString: aJsonString
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> kindsAt: aPointer in: aReport [
	"The kinds of the gaps of aReport whose source pointer is aPointer"

	^ aReport gaps
		  select: [ :each | each sourcePointer = aPointer ]
		  thenCollect: #kind
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> modelOf: aJsonString [
	"The OPModel the importer builds without merging the inline schemas (1:1)"

	^ self modelOf: aJsonString merging: false
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> modelOf: aJsonString merging: aBoolean [

	^ FamixOpenApiImporter new
		  mergesInlineSchemas: aBoolean;
		  importFromString: aJsonString
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> move: aClass at: aPointer to: aNewPointer in: aModel [

	(self entity: aClass at: aPointer in: aModel) canonicalPointer:
		aNewPointer
]

{ #category : 'sweeps - synthetic' }
FamixOpenApiExistenceTestCase >> realEntityOf: anExpected in: aModel [
	"The entity of the model that the derivation expects"

	^ aModel allModelEntities detect: [ :each |
		  each canonicalPointer = anExpected pointer and: [
			  each class name = anExpected targetClassName ] ]
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> remove: aClass at: aPointer from: aModel [

	aModel remove: (self entity: aClass at: aPointer in: aModel)
]

{ #category : 'mutations' }
FamixOpenApiExistenceTestCase >> replace: aClass at: aPointer with: anotherClass in: aModel [
	"Replace the entity of aClass at aPointer by one of anotherClass at the same pointer"

	self remove: aClass at: aPointer from: aModel.
	self add: anotherClass at: aPointer to: aModel
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportFor: aJsonString [
	"Import the document (1:1) and check the model against the document, with the diagnostics of the import"

	| importer model |
	importer := FamixOpenApiImporter new
		            mergesInlineSchemas: false;
		            yourself.
	model := importer importFromString: aJsonString.
	^ FamixOpenApiExistenceCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: model
		  diagnostics: importer diagnostics
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportOf: aModel for: aJsonString [
	"Check a model (possibly mutated by the test) against the document, without diagnostics"

	^ FamixOpenApiExistenceCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: aModel
		  diagnostics: nil
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportOf: aModel for: aJsonString diagnostics: aCollection [
	"Check a model against the document with the given diagnostics (any objects answering #code and #pointer)"

	^ FamixOpenApiExistenceCheck
		  checkInventory: (self inventoryOf: aJsonString)
		  model: aModel
		  diagnostics: aCollection
]

{ #category : 'helpers' }
FamixOpenApiExistenceTestCase >> reportOf: aModel inventory: anInventory [
	"Check a model against an inventory already built (for the tests that check many mutations of one model)"

	^ FamixOpenApiExistenceCheck
		  checkInventory: anInventory
		  model: aModel
		  diagnostics: nil
]
