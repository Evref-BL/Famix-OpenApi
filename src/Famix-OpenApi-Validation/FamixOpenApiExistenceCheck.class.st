"
Import fidelity, level 1 (existence): checks that every node of a SOURCE OpenAPI/Swagger document that should have an entity in the imported model has one, at the right pointer and of the right class, and that the model has no entity without a source node, except the documented synthetic ones.
INPUTS: the FamixOpenApiSourceInventory of the document (FamixOpenApiSourceWalker), the OPModel, and optionally the diagnostics of the import (any collection whose elements answer #code, #pointer and #severity: only an #unresolvedReference at the site of a $ref is used).
MODE REQUIREMENT: the model must have been imported with mergesInlineSchemas = FALSE, so that every schema sits at its own pointer (1:1). The merged form is a later step and is not handled: when an OPSchema has mergedPointers, or the model holds an OPSubSchema, the only gap is one #preconditionMerged and nothing else is compared. An inventory of an unknown version gives one #preconditionVersion.
FORWARD: for each node, FamixOpenApiNodeExpectation says which OP classes (one per family) should sit at its pointer; each one must be there exactly once and of exactly that class (#missingEntity, #wrongClass, #unexpectedMultiple); an entity of another family is an #extraEntity; an unresolved $ref must give an OPReference or be covered by a diagnostic (#referenceNotResolved).
REVERSE: an entity whose pointer is not the pointer of a node must be accepted by a rule of FamixOpenApiSyntheticPointerRules, else #extraEntity; the servers without node are checked by number and url (#countMismatch, #valueMismatch).
The check does not change the importer and does not depend on it.
"
Class {
	#name : 'FamixOpenApiExistenceCheck',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'lookup',
		'expectation',
		'synthetic',
		'unresolvedPointers',
		'report',
		'file'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiExistenceCheck class >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"The FamixOpenApiGapReport of the model imported (with mergesInlineSchemas false) from the document that anInventory describes"

	^ self new
		  checkInventory: anInventory
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> checkEntitiesWithoutNode [
	"The entities whose pointer is not the one of a node (the other ones were compared with their node)"

	lookup allEntities do: [ :each |
		(self hasNodeAtPointerOf: each) ifFalse: [
			self checkEntityWithoutNode: each ] ]
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> checkEntityWithoutNode: anEntity [
	"Accepted when a documented rule explains the pointer, an #extraEntity otherwise"

	(synthetic ruleNameFor: anEntity)
		ifNil: [ self reportExtraWithoutNode: anEntity ]
		ifNotNil: [ :rule | report recordSynthetic: rule ]
]

{ #category : 'checking' }
FamixOpenApiExistenceCheck >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"Answer the FamixOpenApiGapReport of the model against the inventory; aDiagnosticsOrNil is nil or a collection of diagnostics (#code, #pointer)"

	inventory := anInventory.
	lookup := FamixOpenApiPointerLookup onModel: aModel.
	report := FamixOpenApiGapReport new
		          file: file;
		          yourself.
	self satisfiesPreconditions ifFalse: [ ^ report ].
	expectation := FamixOpenApiNodeExpectation on: anInventory.
	synthetic := FamixOpenApiSyntheticPointerRules on: anInventory.
	unresolvedPointers := self
		                      pointersWithCode: #unresolvedReference
		                      in: aDiagnosticsOrNil.
	self checkNodes.
	self checkEntitiesWithoutNode.
	self checkSynthesizedServers.
	^ report
]

{ #category : 'checking - nodes' }
FamixOpenApiExistenceCheck >> checkNode: aNode [
	"Compare the entities at the pointer of aNode with the ones it should give"

	| names found matched |
	names := expectation expectedClassNamesFor: aNode.
	found := lookup entitiesAt: aNode pointer.
	matched := names count: [ :each |
		           self verifyExpected: each at: aNode among: found ].
	self checkUnexpectedAt: aNode among: found expected: names.
	report
		recordNode: aNode specObject
		expected: names size
		found: matched
]

{ #category : 'checking - nodes' }
FamixOpenApiExistenceCheck >> checkNodes [

	inventory allNodes do: [ :each | self checkNode: each ]
]

{ #category : 'checking - servers' }
FamixOpenApiExistenceCheck >> checkServer: aServer at: anIndex expectedUrl: aUrl [
	"The pointer must be #/servers/<index - 1> and the url the expected one"

	| expectedPointer |
	expectedPointer := '#/servers/' , (anIndex - 1) printString.
	aServer canonicalPointer = expectedPointer ifFalse: [
		self
			reportServer: aServer
			expected: expectedPointer
			found: aServer canonicalPointer ].
	aServer url = aUrl ifFalse: [
		self reportServer: aServer expected: aUrl found: aServer url ]
]

{ #category : 'checking - servers' }
FamixOpenApiExistenceCheck >> checkSynthesizedServers [
	"The servers without node must be the ones the document implies: as many as expected, with their urls, at #/servers/0, #/servers/1..."

	| servers urls |
	servers := self synthesizedServers.
	urls := (FamixOpenApiSynthesizedServers on: inventory) expectedUrls.
	servers size = urls size ifFalse: [
		^ self reportServerCount: urls size found: servers size ].
	servers withIndexDo: [ :each :index |
		self checkServer: each at: index expectedUrl: (urls at: index) ]
]

{ #category : 'checking - nodes' }
FamixOpenApiExistenceCheck >> checkUnexpectedAt: aNode among: aCollection expected: aClassNameCollection [
	"An entity at the pointer of aNode whose family is not one of the expected ones"

	| families |
	families := aClassNameCollection collect: [ :each |
		            self familyNamed: each ].
	aCollection do: [ :each |
		(families includes: (FamixOpenApiPointerLookup familyOf: each))
			ifFalse: [ self reportExtra: each at: aNode ] ]
]

{ #category : 'private' }
FamixOpenApiExistenceCheck >> entitiesOfFamilyOf: aClassName in: aCollection [

	| family |
	family := self familyNamed: aClassName.
	^ aCollection select: [ :each |
		  (FamixOpenApiPointerLookup familyOf: each) == family ]
]

{ #category : 'private' }
FamixOpenApiExistenceCheck >> familyNamed: aClassName [
	"The family (the class directly below OPEntity) of the OP class named aClassName"

	^ FamixOpenApiPointerLookup familyOfClass:
		  (Smalltalk at: aClassName asSymbol)
]

{ #category : 'accessing' }
FamixOpenApiExistenceCheck >> file: aString [
	"The name of the source file, stamped on the gaps"

	file := aString
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> gapOfKind: aKind node: aNode [
	"A gap about a source node"

	^ FamixOpenApiGap
		  kind: aKind
		  pointer: aNode pointer
		  specObject: aNode specObject
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> hasNodeAtPointerOf: anEntity [

	^ anEntity canonicalPointer isNotNil and: [
		  inventory includesPointer: anEntity canonicalPointer ]
]

{ #category : 'preconditions' }
FamixOpenApiExistenceCheck >> isMergeEvidence: anEntity [
	"A sub-schema, or a schema that took over the pointers of others, exists only when the inline schemas are merged"

	anEntity class == OPSubSchema ifTrue: [ ^ true ].
	^ anEntity class == OPSchema and: [
		  anEntity mergedPointers isNotEmpty ]
]

{ #category : 'private' }
FamixOpenApiExistenceCheck >> pointersWithCode: aSymbol in: aDiagnosticsOrNil [
	"The pointers of the diagnostics that have the code aSymbol"

	| pointers |
	pointers := Set new.
	aDiagnosticsOrNil ifNotNil: [ :diagnostics |
		diagnostics do: [ :each |
			each code = aSymbol ifTrue: [ pointers add: each pointer ] ] ].
	^ pointers
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportExtra: anEntity at: aNode [
	"An entity at the pointer of a node that should not give one of its family"

	report add: ((self gapOfKind: #extraEntity node: aNode)
			 entity: anEntity;
			 found: anEntity class name;
			 message: 'This ' , aNode specObject , ' should not give a '
				 , anEntity class name;
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportExtraWithoutNode: anEntity [
	"An entity whose pointer is not a node and that no documented rule explains"

	report add: ((FamixOpenApiGap
			  kind: #extraEntity
			  pointer: anEntity canonicalPointer
			  specObject: nil)
			 entity: anEntity;
			 found: anEntity class name;
			 message:
				 'No source node at the pointer of this ' , anEntity class name
				 , ', and no synthetic rule';
			 yourself)
]

{ #category : 'preconditions' }
FamixOpenApiExistenceCheck >> reportMerged: aCollection [

	self
		reportPrecondition: #preconditionMerged
		message: 'The model was imported with mergesInlineSchemas = true ('
			, aCollection size printString
			, ' schemas with merged pointers or sub-schemas, the first at '
			, aCollection first canonicalPointer printString
			, '): the existence check needs mergesInlineSchemas = false'
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportMissing: aClassName at: aNode [

	report add: ((self gapOfKind: #missingEntity node: aNode)
			 expected: aClassName;
			 message:
				 'No ' , aClassName , ' at the pointer of this '
				 , aNode specObject;
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportMultiple: aCollection expected: aClassName at: aNode [

	report add: ((self gapOfKind: #unexpectedMultiple node: aNode)
			 entity: aCollection first;
			 expected: aClassName;
			 found: (aCollection collect: [ :each | each class name ]) asArray;
			 message:
				 aCollection size printString , ' entities of the family of '
				 , aClassName , ' at the same pointer';
			 yourself)
]

{ #category : 'preconditions' }
FamixOpenApiExistenceCheck >> reportPrecondition: aKind message: aString [

	report add: ((FamixOpenApiGap
			  kind: aKind
			  pointer: FamixOpenApiSourceNode rootPointer
			  specObject: nil)
			 expected: 'a model imported with mergesInlineSchemas = false';
			 message: aString;
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportServer: aServer expected: anExpected found: aFound [

	report add: ((FamixOpenApiGap
			  kind: #valueMismatch
			  pointer: aServer canonicalPointer
			  specObject: 'Server')
			 entity: aServer;
			 expected: anExpected;
			 found: aFound;
			 message:
				 'A server without source node has not the expected pointer or url';
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportServerCount: anExpectedCount found: aFoundCount [

	report add: ((FamixOpenApiGap
			  kind: #countMismatch
			  pointer: '#/servers'
			  specObject: 'Server')
			 expected: anExpectedCount;
			 found: aFoundCount;
			 message: 'The servers without source node should be '
				 , anExpectedCount printString , ', not '
				 , aFoundCount printString;
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportUnresolved: aNode [
	"The $ref of aNode designates nothing in the document: the model has neither an OPReference at its site nor a diagnostic"

	report add: ((self gapOfKind: #referenceNotResolved node: aNode)
			 expected: 'OPReference or an unresolvedReference diagnostic';
			 found: aNode referenceText;
			 message: 'The unresolved $ref ' , aNode referenceText printString
				 , ' is neither an OPReference nor a diagnostic';
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportWrongClass: anEntity expected: aClassName at: aNode [

	report add: ((self gapOfKind: #wrongClass node: aNode)
			 entity: anEntity;
			 expected: aClassName;
			 found: anEntity class name;
			 message:
				 'This ' , aNode specObject , ' should give an ' , aClassName
				 , ', not a ' , anEntity class name;
			 yourself)
]

{ #category : 'preconditions' }
FamixOpenApiExistenceCheck >> satisfiesPreconditions [
	"False, with one gap in the report, for a document of unknown version or a model imported with the inline schemas merged"

	| merged |
	inventory isUnknownVersion ifTrue: [
		self
			reportPrecondition: #preconditionVersion
			message:
			'The version of the document is unknown: nothing can be compared'.
		^ false ].
	merged := lookup allEntities select: [ :each |
		          self isMergeEvidence: each ].
	merged ifEmpty: [ ^ true ].
	self reportMerged: merged.
	^ false
]

{ #category : 'checking - servers' }
FamixOpenApiExistenceCheck >> synthesizedServers [
	"The OPServer without source node, in the order of their pointer #/servers/N"

	^ (lookup allEntities select: [ :each |
		   (self hasNodeAtPointerOf: each) not and: [
			   synthetic isSynthesizedServer: each ] ]) sorted: [ :a :b |
		  (a canonicalPointer allButFirst: 10) asNumber
		  <= (b canonicalPointer allButFirst: 10) asNumber ]
]

{ #category : 'checking - nodes' }
FamixOpenApiExistenceCheck >> verifyAbsenceOf: aClassName at: aNode [
	"No entity of the family: an OPReference expected for an unresolved $ref may be replaced by a diagnostic; anything else is missing. Answer whether the absence is covered"

	aClassName = 'OPReference' ifFalse: [
		self reportMissing: aClassName at: aNode.
		^ false ].
	(unresolvedPointers includes: aNode pointer) ifTrue: [ ^ true ].
	self reportUnresolved: aNode.
	^ false
]

{ #category : 'checking - nodes' }
FamixOpenApiExistenceCheck >> verifyExpected: aClassName at: aNode among: aCollection [
	"Answer whether exactly one entity of the family of aClassName is there, of exactly that class; report it when not"

	| inFamily |
	inFamily := self entitiesOfFamilyOf: aClassName in: aCollection.
	inFamily isEmpty ifTrue: [
		^ self verifyAbsenceOf: aClassName at: aNode ].
	inFamily size > 1 ifTrue: [
		self reportMultiple: inFamily expected: aClassName at: aNode.
		^ false ].
	inFamily first class name = aClassName ifTrue: [ ^ true ].
	self reportWrongClass: inFamily first expected: aClassName at: aNode.
	^ false
]
