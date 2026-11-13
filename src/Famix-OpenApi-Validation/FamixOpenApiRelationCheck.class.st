"
Import fidelity, level 4 (relations, V10): checks that the RELATIONS of the entities of the model (an operation to its parameters, responses and request body, a schema to its properties and its allOf, a security requirement to the schemes...) are the ones that the SOURCE document says: the same children, resolved through $ref to the right target entities, in the right order, with the right count. Entry: #checkInventory:model:diagnostics: answers a FamixOpenApiGapReport with the gaps #relationMismatch (the relation of an entity does not hold the targets that the source designates: expected and found are the lists of the canonical pointers of the targets, fieldKey is the key of the source, the message says what is missing, what is extra or that the order differs) and #countMismatch (for a row compared by its number of targets), and the coverage (FamixOpenApiGapReport>>coverage): per version, spec object, field and relation, how many relations were compared (one per owner), how many targets (#linkCountOf:), how many did not match and how many were deferred, with the reason.
HOW: the table is FamixOpenApiRelationRules (one FamixOpenApiRelationRule per relation of the model, with a derivation of the targets from the source: FamixOpenApiRelationDerivation). The owners are the nodes of the EXPANDED inventory of FamixOpenApiSyntheticExpectations (the clones of the $ref responses and path items re-rooted at their sites, the schemas that Swagger 2 makes of typed parameters), the entities derived without node (the media types of Swagger 2, the entries of the mapping, the items of the security requirements) or the entries of the properties. The target of a child is the entity that the node gives for the family of the relation (FamixOpenApiNodeExpectation says which), else the one its $ref designates, following the importer: a schema designates the schema at the end of ONE step (an alias of the components is an entity), the other objects the end of the chain; an unresolved or cyclic $ref gives no target. The relations of the model are sets that keep the first occurrence: a target met twice in the source is held once (VERIFIED by import).
SCOPE: mergesInlineSchemas = FALSE only (the same preconditions as V7 to V9: #preconditionMerged, #preconditionVersion). The inverse relations (usedBy..., the owner side of a containment: the validator of V4 and V5 checks them) are not compared. DEFERRED, on purpose, each one counted in the coverage with its reason: the keys beside a $ref of OpenAPI 3.1 (the importer reads them, the inventory does not walk them). The check does not change the importer and does not depend on it. The diagnostics of the import are used for one thing: a $ref to a value that is not an object gets a diagnostic (wrongNodeType, unresolvedReference) and no OPReference, and the existence check accepts it the same way, so the unresolved references of the relation check do not expect the OPReference of a site that a diagnostic covers (without diagnostics, it is a gap).
KNOWN LIMIT E1 (frozen by FamixOpenApiRelationSwagger2Test>>testKnownLimitE1ATypedParameterWithItemsAndASchemaGivesARelationMismatchForItsItems): a Swagger 2 typed parameter that has BOTH items and a non-empty schema key (an invalid document, e.g. {""name"":""q"",""in"":""query"",""type"":""array"",""items"":{""type"":""string""},""schema"":{""type"":""string""}}) gives a #relationMismatch for items at '<param>/schema' (missing: none, extra: the schema at '<param>/schema/items'). The virtual pointer of the schema that Swagger 2 makes of the typed keywords is '<param>/schema', the pointer of the real schema key of the document, so the two collide; the existence check reports the entity at '<param>/schema/items' as #extraEntity too. It is not fixed: no valid document has both.
"
Class {
	#name : 'FamixOpenApiRelationCheck',
	#superclass : 'Object',
	#instVars : [
		'valueCheck',
		'inventory',
		'report',
		'file',
		'nodesBySite',
		'syntheticByParent',
		'comparisons',
		'referenceFailures',
		'sharedValueCheck'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiRelationCheck class >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"The FamixOpenApiGapReport of the relations of the model imported (with mergesInlineSchemas false) from the document that anInventory describes"

	^ self new
		  checkInventory: anInventory
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'checking' }
FamixOpenApiRelationCheck >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"Answer the FamixOpenApiGapReport of the relations of the model against the inventory; aDiagnosticsOrNil is nil or the diagnostics of the import (kept, see the class comment)"

	self
		prepareInventory: anInventory
		model: aModel
		diagnostics: aDiagnosticsOrNil.
	self satisfiesPreconditions ifFalse: [ ^ report ].
	self prepare.
	self rules do: [ :each | self checkRule: each ].
	^ report
]

{ #category : 'checking' }
FamixOpenApiRelationCheck >> checkOwner: anOwner rule: aRule [
	"Compare the relation of the entity of the owner with the targets that the source designates: nothing when the model has no entity, a deferral when the source cannot be compared"

	| expected |
	anOwner entity: (self entityOf: anOwner rule: aRule).
	anOwner entity ifNil: [
		^ report coverage recordWithoutEntity: (self keyOf: aRule) ].
	expected := aRule derivation targetsOf: anOwner in: self.
	expected ifNil: [
		^ report coverage
			  recordDeferred: (self keyOf: aRule)
			  reason: aRule derivation reason ].
	self compare: (FamixOpenApiRelationComparison new
			 owner: anOwner;
			 rule: aRule;
			 expected: expected;
			 found: (self foundOf: anOwner rule: aRule);
			 yourself)
]

{ #category : 'checking' }
FamixOpenApiRelationCheck >> checkRule: aRule [
	"Compare the relation of every owner of the rule"

	(self ownersOf: aRule) do: [ :each |
		self checkOwner: each rule: aRule ]
]

{ #category : 'checking' }
FamixOpenApiRelationCheck >> compare: aComparison [
	"Record the comparison in the coverage and report the gap when the relation does not hold what the source designates"

	| key |
	key := self keyOf: aComparison rule.
	comparisons ifNotNil: [ :kept | kept add: aComparison ].
	report coverage recordCompared: key.
	report coverage recordLinks: aComparison expected size at: key.
	aComparison expected isEmpty ifFalse: [
		report coverage recordInformative: key ].
	aComparison isEquivalent ifFalse: [
		self reportMismatch: aComparison key: key ]
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> comparisons [
	"The comparisons made when #keepComparisons was sent before the check, in the order they were made"

	^ comparisons ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> derivation [
	"The FamixOpenApiSyntheticExpectations of the inventory: the entities derived without node"

	^ valueCheck derivation
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> describe: anEntity family: aFamily [
	"The canonical pointer of the entity; followed by its class when it is not of the family of the targets"

	^ (FamixOpenApiPointerLookup familyOf: anEntity) == aFamily
		  ifTrue: [ anEntity canonicalPointer asString ]
		  ifFalse: [
			  anEntity canonicalPointer asString , ' (' , anEntity class name
			  , ')' ]
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> designatedPointerOf: aNode family: aFamily [
	"The pointer of the entity of the family that the $ref of the node designates (the node has an entity of its own or not: an alias schema holds its target), nil when the node is no $ref, the $ref is unresolved or cyclic, or the target gives none"

	^ self designatedPointerOf: aNode family: aFamily visited: Set new
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> designatedPointerOf: aNode family: aFamily visited: aSet [

	| next |
	aNode referenceText ifNil: [ ^ nil ].
	next := self nextNodeOf: aNode.
	next ifNil: [ ^ nil ].
	(aSet includes: next pointer) ifTrue: [ ^ nil ].
	aSet add: next pointer.
	^ self targetPointerOf: next family: aFamily visited: aSet
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> entityOf: anOwner rule: aRule [
	"The first entity of exactly the class of the rule at the pointer of the owner, nil when there is none"

	^ (self lookup entitiesAt: anOwner pointer ofClass: aRule ownerClass)
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :found | found first ]
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> expandedInventory [
	"The inventory the check reads (clones re-rooted, Swagger 2 schemas added), available once the check was prepared"

	^ valueCheck expandedInventory
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> file: aString [
	"The name of the source file, stamped on the gaps"

	file := aString
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> foundOf: anOwner rule: aRule [
	"The canonical pointers of the entities that the relation of the owner holds, in the order of the relation"

	| value |
	value := anOwner entity perform: aRule selector.
	value ifNil: [ ^ #(  ) ].
	^ (value isCollection
		   ifTrue: [ value asArray ]
		   ifFalse: [ { value } ]) collect: [ :each |
		  self describe: each family: aRule targetFamily ]
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> givesEntityOfItsOwn: aNode [
	"True when the node gives an entity at its pointer that is neither the OPReference of an unresolved $ref nor the OPProperty of an entry of properties (which only holds the schema its value gives): the site of a $ref to a body parameter of Swagger 2 gives a request body, not the parameter it designates"

	^ (self nodeExpectation expectedClassNamesFor: aNode) anySatisfy: [
		  :each | (#( 'OPReference' 'OPProperty' ) includes: each) not ]
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> indexNodes [
	"The nodes of the expanded inventory by spec object of their place, sorted by pointer"

	nodesBySite := Dictionary new.
	(self expandedInventory allNodes groupedBy: [ :each |
		 self expandedInventory siteSpecObjectOf: each ]) keysAndValuesDo: [
		:spec
		:nodes |
		nodesBySite
			at: spec
			put: (nodes asArray sorted: [ :a :b | a pointer <= b pointer ]) ]
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> inventory [
	"The inventory of the source document"

	^ inventory
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> isReferenceExcusedAt: aPointer [
	"True when the model has no OPReference at the pointer and a diagnostic says why: the importer reports a $ref whose target is not an object and keeps no OPReference for it (the existence check accepts it the same way)"

	^ (referenceFailures includes: aPointer) and: [
		  (self lookup entitiesAt: aPointer ofClass: OPReference) isEmpty ]
]

{ #category : 'recording' }
FamixOpenApiRelationCheck >> keepComparisons [
	"Remember every comparison made, see #comparisons (for the mutation sweeps of the tests)"

	comparisons := OrderedCollection new
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> keyOf: aRule [
	"The key of the rule in the coverage table"

	^ aRule coverageKeyIn: inventory version
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> lookup [
	"The FamixOpenApiPointerLookup of the model"

	^ valueCheck lookup
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> nextNodeOf: aReferenceNode [
	"The node a $ref designates: for a schema the node the $ref itself designates (an alias of the components is an entity of its own), for the other objects the end of the chain of references"

	^ (self expandedInventory siteSpecObjectOf: aReferenceNode)
	  = 'Schema'
		  ifTrue: [ self nodeExpectation targetOf: aReferenceNode ]
		  ifFalse: [ self nodeExpectation chainTargetOf: aReferenceNode ]
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> node: aNode givesFamily: aFamily [
	"True when the importer builds, at the pointer of the node, an entity of the family"

	^ (self nodeExpectation expectedClassNamesFor: aNode) anySatisfy: [
		  :each |
		  (FamixOpenApiPointerLookup familyOfClass:
			   (Smalltalk at: each asSymbol)) == aFamily ]
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> nodeExpectation [
	"The FamixOpenApiNodeExpectation on the expanded inventory"

	^ valueCheck nodeExpectation
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> nodeOwnersOf: aRule [

	^ (nodesBySite at: aRule specObject ifAbsent: [ #(  ) ])
		  reject: #isWrongShape
		  thenCollect: [ :each |
			  FamixOpenApiRelationOwner
				  pointer: each pointer , aRule ownerSuffix
				  node: each ]
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> ownersOf: aRule [
	"The owners of the relation of the rule: the nodes of its spec object, the entries of the properties of a schema or the entities derived without node"

	aRule ownerKindName == #property ifTrue: [
		^ self propertyOwnersOf: aRule ].
	aRule ownerKindName == #synthetic ifTrue: [
		^ self syntheticOwnersOf: aRule ].
	^ self nodeOwnersOf: aRule
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> pointersOfDerived: aCollection family: aFamily [

	^ aCollection
		  select: [ :each |
			  (FamixOpenApiPointerLookup familyOfClass:
				   (Smalltalk at: each targetClassName asSymbol)) == aFamily ]
		  thenCollect: #pointer
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> pointersOfReferenceFailuresIn: aDiagnosticsOrNil [
	"The pointers of the diagnostics that tell why a $ref gave no OPReference at its site (FamixOpenApiExistenceCheck class>>dataReferenceFailureCodes): the target does not exist, or is not an object"

	| pointers |
	pointers := Set new.
	aDiagnosticsOrNil ifNotNil: [ :all |
		all do: [ :each |
			(FamixOpenApiExistenceCheck dataReferenceFailureCodes includes:
				 each code) ifTrue: [ pointers add: each pointer ] ] ].
	^ pointers
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> prepare [
	"What reads the expanded inventory (clones re-rooted, Swagger 2 schemas added): the nodes by spec object of their place and the entities derived without node by parent"

	valueCheck prepare.
	self indexNodes.
	syntheticByParent := self derivation expectedEntities groupedBy: [
		                     :each |
		                     self expandedInventory pointerAbove:
			                     each pointer ]
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> prepareInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"Look at the model and the diagnostics of the import (they excuse the OPReference that a $ref to a value that is not an object does not get), and start a report"

	inventory := anInventory.
	referenceFailures := self pointersOfReferenceFailuresIn:
		                     aDiagnosticsOrNil.
	valueCheck := self valueCheckOn: anInventory model: aModel.
	report := FamixOpenApiGapReport new
		          file: file;
		          yourself
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> propertyOwnersOf: aRule [

	^ (nodesBySite at: aRule specObject ifAbsent: [ #(  ) ])
		  select: [ :each |
			  each isWrongShape not and: [
				  (self expandedInventory fieldOf: each) = 'properties' ] ]
		  thenCollect: [ :each |
		  FamixOpenApiRelationOwner pointer: each pointer node: each ]
]

{ #category : 'checking' }
FamixOpenApiRelationCheck >> recheck: aComparison [
	"The gaps of one relation again, in a new report (the check must have been run: the mutation sweeps change a relation of the model and look at it)"

	report := FamixOpenApiGapReport new
		          file: file;
		          yourself.
	self checkOwner: aComparison owner rule: aComparison rule.
	^ report
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> report [
	"The report of the last run"

	^ report
]

{ #category : 'checking' }
FamixOpenApiRelationCheck >> reportMismatch: aComparison key: aKey [

	report coverage recordMismatch: aKey.
	report add: ((FamixOpenApiGap
			  kind: aComparison gapKind
			  pointer: aComparison owner sourcePointer
			  specObject: aComparison rule specObject)
			 entity: aComparison owner entity;
			 fieldKey: aComparison rule fieldKey;
			 expected: aComparison expected;
			 found: aComparison found;
			 message: aComparison message;
			 yourself)
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> rules [
	"The rules of the table that are for the version of the document"

	^ FamixOpenApiRelationRules rulesFor: inventory version
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> satisfiesPreconditions [
	"False, with the gaps of the value check in the report, for a document of unknown version or a model imported with the inline schemas merged"

	valueCheck satisfiesPreconditions ifTrue: [ ^ true ].
	valueCheck report gaps do: [ :each | report add: each ].
	^ false
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> shareValueCheck: aValueCheck [
	"Use aValueCheck, prepared on the same inventory and model, instead of a new one: the expansion of the inventory and the lookup of the model are then made once for several checks (FamixOpenApiFidelityChecker). The check must be given before #checkInventory:model:diagnostics:"

	sharedValueCheck := aValueCheck
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> syntheticAt: aPointer family: aFamily [
	"The pointers of the entities of the family derived without node at aPointer"

	^ self
		  pointersOfDerived: (self derivation expectedEntitiesAt: aPointer)
		  family: aFamily
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> syntheticChildrenOf: aPointer family: aFamily [
	"The pointers of the entities of the family derived without node whose pointer is directly below aPointer, in the order of the derivation"

	^ self
		  pointersOfDerived:
		  (syntheticByParent at: aPointer ifAbsent: [ #(  ) ])
		  family: aFamily
]

{ #category : 'owners' }
FamixOpenApiRelationCheck >> syntheticOwnersOf: aRule [
	"One owner per pointer of the entities that the derivation gives, of the class and the rules of the rule"

	| pointers |
	pointers := (self derivation expectedEntities
		             select: [ :each |
			             each targetClassName = aRule ownerClassName and: [
				             aRule syntheticRuleNames includes: each ruleName ] ]
		             thenCollect: #pointer) asSet asArray sorted.
	^ pointers collect: [ :each |
		  FamixOpenApiRelationOwner pointer: each node: nil ]
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> targetPointerOf: aNode family: aFamily [
	"The pointer of the entity of the family that the node gives: its own, else the one its $ref designates; nil when there is none"

	^ self targetPointerOf: aNode family: aFamily visited: Set new
]

{ #category : 'targets' }
FamixOpenApiRelationCheck >> targetPointerOf: aNode family: aFamily visited: aSet [

	(self node: aNode givesFamily: aFamily) ifTrue: [ ^ aNode pointer ].
	(self givesEntityOfItsOwn: aNode) ifTrue: [ ^ nil ].
	^ self designatedPointerOf: aNode family: aFamily visited: aSet
]

{ #category : 'preparing' }
FamixOpenApiRelationCheck >> valueCheckOn: anInventory model: aModel [
	"The value check that reads the model and supplies the expanded inventory: the one given by #shareValueCheck: when there is one, else a new one"

	^ sharedValueCheck ifNil: [
		  FamixOpenApiValueCheck new
			  prepareInventory: anInventory model: aModel;
			  yourself ]
]

{ #category : 'accessing' }
FamixOpenApiRelationCheck >> version [
	"#v30, #v31 or #v2"

	^ inventory version
]
