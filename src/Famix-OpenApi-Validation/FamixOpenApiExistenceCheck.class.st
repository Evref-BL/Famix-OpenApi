"
Import fidelity, level 1 (existence): checks that every node of a SOURCE OpenAPI/Swagger document that should have an entity in the imported model has one, at the right pointer and of the right class, and that the model has no other entity than the ones the document implies: the set of entities of the model must be EXACTLY the expected one (V7b).
INPUTS: the FamixOpenApiSourceInventory of the document (FamixOpenApiSourceWalker, read with the objects in the order of their keys: #walkString:), the OPModel, and optionally the diagnostics of the import (any collection whose elements answer #code, #pointer and #severity: only an #unresolvedReference or a #wrongNodeType at the site of a $ref is used, see #dataReferenceFailureCodes).
MODE REQUIREMENT: the model must have been imported with mergesInlineSchemas = FALSE, so that every schema sits at its own pointer (1:1). The merged form is a later step and is not handled: when an OPSchema has mergedPointers, or the model holds an OPSubSchema, the only gap is one #preconditionMerged and nothing else is compared. An inventory of an unknown version gives one #preconditionVersion.
FORWARD: for each node, FamixOpenApiNodeExpectation says which OP classes (one per family) should sit at its pointer; each one must be there exactly once and of exactly that class (#missingEntity, #wrongClass, #unexpectedMultiple); an entity of another family is an #extraEntity; an unresolved $ref must give an OPReference or be covered by a diagnostic (#referenceNotResolved). A node of the wrong shape gives no entity of its own: its pointer is compared as a pointer without node.
REVERSE: at every pointer without node (of the right shape) the entities of the model are compared, family by family, with the ones that FamixOpenApiSyntheticExpectations derives from the source (the clones, the Swagger 2 schemas, media types and request bodies, the discriminators, the examples, the security items and scopes...): an expected one that is not there is a #missingEntity (the gap has the #ruleName that expects it), one that nothing expects an #extraEntity, more than expected an #unexpectedMultiple, another class of the family a #wrongClass. The servers without node are checked by number, pointer and url (FamixOpenApiSynthesizedServers: #countMismatch, #valueMismatch). What the derivation does not follow is listed by FamixOpenApiSyntheticExpectations class>>knownLimits.
The check does not change the importer and does not depend on it.
"
Class {
	#name : 'FamixOpenApiExistenceCheck',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'lookup',
		'expectation',
		'unresolvedPointers',
		'report',
		'file',
		'derived',
		'servers'
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

{ #category : 'data' }
FamixOpenApiExistenceCheck class >> dataReferenceFailureCodes [
	"The codes of the diagnostics that tell why a $ref gave no entity at its site: the target does not exist, or is not an object"

	^ #( #unresolvedReference #wrongNodeType )
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> acceptServer: anEntity [
	"True for a server without node (its number and urls are compared apart), recorded as such"

	(servers isSynthesizedServer: anEntity) ifFalse: [ ^ false ].
	report recordSynthetic: #synthesizedServer.
	^ true
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> checkDerivedAt: aPointer [
	"The entities at a pointer without node, family by family, against the derived ones; the servers without node are accepted here and compared apart"

	| expected found |
	found := (lookup entitiesAt: aPointer) reject: [ :each |
		         self acceptServer: each ].
	expected := derived expectedEntitiesAt: aPointer.
	(self familiesOf: expected and: found) do: [ :family |
		self
			checkFamilyAt: aPointer
			expected: (expected select: [ :each | each family == family ])
			found: (found select: [ :each |
					 (FamixOpenApiPointerLookup familyOf: each) == family ]) ]
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> checkEntitiesWithoutNode [
	"The pointers that no node has: the entities there are exactly the ones the derivations expect (the servers are checked apart), no more, no less"

	derived expectedEntities do: [ :each |
		report recordDerived: each ruleName ].
	self pointersWithoutNode do: [ :each | self checkDerivedAt: each ]
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> checkExpected: expectedOnes found: foundOnes at: aPointer [
	"The entities of the expected class are matched one to one (and counted for their rule); what remains is compared in order: another class is a #wrongClass, an expected one left is #missingEntity, an entity left is #unexpectedMultiple"

	| missing surplus |
	missing := OrderedCollection withAll: expectedOnes.
	surplus := OrderedCollection withAll: foundOnes.
	expectedOnes do: [ :each |
		surplus
			detect: [ :entity | entity class name = each targetClassName ]
			ifFound: [ :entity |
				surplus remove: entity.
				missing remove: each.
				report recordSynthetic: each ruleName ] ].
	self reportLeftoversAt: aPointer missing: missing surplus: surplus
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> checkFamilyAt: aPointer expected: expectedOnes found: foundOnes [
	"One family at a pointer: an entity of a family that nothing expects is an #extraEntity, else the expected ones and the found ones are compared"

	expectedOnes isEmpty ifTrue: [
		^ foundOnes do: [ :each | self reportExtraWithoutNode: each ] ].
	self checkExpected: expectedOnes found: foundOnes at: aPointer
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
	derived := FamixOpenApiSyntheticExpectations on: anInventory.
	servers := FamixOpenApiSynthesizedServers on: anInventory.
	unresolvedPointers := self
		                      pointersWithCodes: self class dataReferenceFailureCodes
		                      in: aDiagnosticsOrNil.
	self checkNodes.
	self checkEntitiesWithoutNode.
	self checkSynthesizedServers.
	^ report
]

{ #category : 'checking - nodes' }
FamixOpenApiExistenceCheck >> checkNode: aNode [
	"Compare the entities at the pointer of aNode with the ones it should give; a node of the wrong shape gives none of its own, what stands at its pointer is compared with the derived entities"

	| names found matched |
	aNode isWrongShape ifTrue: [
		^ report recordNode: aNode specObject expected: 0 found: 0 ].
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

	| found urls |
	found := self synthesizedServers.
	urls := servers expectedUrls.
	urls do: [ :unused | report recordDerived: #synthesizedServer ].
	found size = urls size ifFalse: [
		^ self reportServerCount: urls size found: found size ].
	found withIndexDo: [ :each :index |
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

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> familiesOf: expectedOnes and: foundOnes [
	"The families (classes directly below OPEntity) of the expected entities and of the found ones"

	^ (expectedOnes collect: #family as: Set) union: (foundOnes
			   collect: [ :each | FamixOpenApiPointerLookup familyOf: each ]
			   as: Set)
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
FamixOpenApiExistenceCheck >> gapOfKind: aKind derived: anExpectedEntity [
	"A gap about an entity without node of its own, that a rule derives: it says which rule and from which node"

	^ (FamixOpenApiGap
		   kind: aKind
		   pointer: anExpectedEntity pointer
		   specObject: (derived specObjectOf: anExpectedEntity))
		  ruleName: anExpectedEntity ruleName;
		  yourself
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
	"True when a node that can give entities (not of the wrong shape) sits at the pointer of anEntity"

	^ self isNodePointer: anEntity canonicalPointer
]

{ #category : 'preconditions' }
FamixOpenApiExistenceCheck >> isMergeEvidence: anEntity [
	"A sub-schema, or a schema that took over the pointers of others, exists only when the inline schemas are merged"

	anEntity class == OPSubSchema ifTrue: [ ^ true ].
	^ anEntity class == OPSchema and: [
		  anEntity mergedPointers isNotEmpty ]
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> isNodePointer: aPointer [
	"True when a node that can give entities, one of the right shape, sits at aPointer (nil is no pointer)"

	^ aPointer isNotNil and: [
		  (inventory nodeAt: aPointer ifAbsent: [ nil ])
			  ifNil: [ false ]
			  ifNotNil: [ :node | node isWrongShape not ] ]
]

{ #category : 'private' }
FamixOpenApiExistenceCheck >> pointersWithCodes: aCollection in: aDiagnosticsOrNil [
	"The pointers of the diagnostics whose code is one of aCollection"

	| pointers |
	pointers := Set new.
	aDiagnosticsOrNil ifNotNil: [ :diagnostics |
		diagnostics do: [ :each |
			(aCollection includes: each code) ifTrue: [ pointers add: each pointer ] ] ].
	^ pointers
]

{ #category : 'checking - entities' }
FamixOpenApiExistenceCheck >> pointersWithoutNode [
	"The pointers (nil for the entities that have none) where the model holds an entity or a derivation expects one, and that are not the pointer of a node that gives entities"

	| pointers |
	pointers := Set withAll: derived pointers.
	pointers addAll: lookup pointers.
	(lookup includesPointer: nil) ifTrue: [ pointers add: nil ].
	^ (pointers reject: [ :each | self isNodePointer: each ]) sorted: [
		  :a
		  :b | a asString <= b asString ]
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
	"An entity whose pointer is not a node and that no derivation expects"

	report add: ((FamixOpenApiGap
			  kind: #extraEntity
			  pointer: anEntity canonicalPointer
			  specObject: nil)
			 entity: anEntity;
			 found: anEntity class name;
			 message:
				 'No source node at the pointer of this ' , anEntity class name
				 , ', and no rule derives it';
			 yourself)
]

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportLeftoversAt: aPointer missing: aMissingCollection surplus: aSurplusCollection [
	"The expected entities not matched and the entities not matched, of one family at a pointer without node"

	| paired |
	paired := aMissingCollection size min: aSurplusCollection size.
	1 to: paired do: [ :index |
		self
			reportWrongDerived: (aSurplusCollection at: index)
			expected: (aMissingCollection at: index)
			at: aPointer ].
	(aMissingCollection allButFirst: paired) do: [ :each |
		self reportMissingDerived: each ].
	(aSurplusCollection allButFirst: paired) ifNotEmpty: [ :rest |
		self reportMultipleDerived: rest at: aPointer ]
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
FamixOpenApiExistenceCheck >> reportMissingDerived: anExpectedEntity [
	"An entity that a rule derives is not in the model"

	report add:
		((self gapOfKind: #missingEntity derived: anExpectedEntity)
			 expected: anExpectedEntity targetClassName;
			 message:
				 'No ' , anExpectedEntity targetClassName , ' at '
				 , anExpectedEntity pointer , ', expected by the rule '
				 , anExpectedEntity ruleName asString , ' from '
				 , anExpectedEntity originPointer;
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

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportMultipleDerived: aCollection at: aPointer [
	"More entities of a family than the derivations expect at a pointer without node"

	| expected |
	expected := (derived expectedEntitiesAt: aPointer) detect: [ :each |
		            each family
		            ==
		            (FamixOpenApiPointerLookup familyOf: aCollection first) ].
	report add: ((self gapOfKind: #unexpectedMultiple derived: expected)
			 entity: aCollection first;
			 expected: expected targetClassName;
			 found: (aCollection collect: [ :each | each class name ]) asArray;
			 message:
				 aCollection size printString , ' more entities of the family of '
				 , expected targetClassName , ' at ' , aPointer , ' than the rule '
				 , expected ruleName asString , ' derives';
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

{ #category : 'reporting' }
FamixOpenApiExistenceCheck >> reportWrongDerived: anEntity expected: anExpectedEntity at: aPointer [
	"The entity of the family is not of the class that a rule derives"

	report add: ((self gapOfKind: #wrongClass derived: anExpectedEntity)
			 entity: anEntity;
			 expected: anExpectedEntity targetClassName;
			 found: anEntity class name;
			 message:
				 'This ' , anEntity class name , ' at ' , aPointer
				 , ' should be a ' , anExpectedEntity targetClassName , ' (rule '
				 , anExpectedEntity ruleName asString , ')';
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
			   servers isSynthesizedServer: each ] ]) sorted: [ :a :b |
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
