"
Import fidelity, level 2 (values, V8): checks that the VALUES of the fields of the nodes of a SOURCE OpenAPI/Swagger document are the ones the importer stored in the slots of the entities it built for them, for the fields that the metamodel models as a typed slot (FamixOpenApiValueRules: the rows are written from the conformance rows and from import experiments). Entry: #checkInventory:model: answers a FamixOpenApiGapReport with the gaps #valueMismatch (the slot does not hold what the source says: expected and found are the normalised values, fieldKey is the key of the source) and the coverage table (FamixOpenApiGapReport>>coverage): per version, spec object, field and slot, how many values were compared and how many did not match.
HOW: the nodes are the ones of the EXPANDED inventory of FamixOpenApiSyntheticExpectations (the clones of the $ref responses and path items re-rooted at their sites, so that the value expected at a clone site is the one of the target; the schemas that Swagger 2 makes of typed parameters), and FamixOpenApiNodeExpectation says which entity carries each node: a rule is compared only for the entity of its class that the node gives (at a shared pointer, OPProperty and OPSchema or OPSecurityScheme and OPOAuthFlow, the entity is chosen PER FIELD by the class of the row). Each row has a comparator (FamixOpenApiValueComparator) that normalises both sides.
SCOPE: mergesInlineSchemas = FALSE only (the same preconditions as the existence check: #preconditionMerged, #preconditionVersion); the existence of the entities is the business of FamixOpenApiExistenceCheck (an entity that is missing is counted as 'no entity' in the coverage, not reported). Names are compared only where the slot is the source value verbatim.
DEFERRED (not compared, on purpose): the targets of the relations (V10), the extensions and the diagnostics (V9: the fields that the metamodel does not model, which are in the extensions text), Link.parameters, the defaults of style and explode, the schema of the formData parameters of Swagger 2 (type file, one property per parameter) and the type, format... of a Swagger 2 header (the importer does not convert them), the merged form. A source value whose JSON type does not fit its field is not compared (#wrongType in the coverage): the importer reports it with a diagnostic and does not store it.
The check does not change the importer and does not depend on it.
"
Class {
	#name : 'FamixOpenApiValueCheck',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'lookup',
		'derived',
		'expanded',
		'expectation',
		'report',
		'file',
		'rulesBySpecObject',
		'comparisons'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiValueCheck class >> checkInventory: anInventory model: aModel [
	"The FamixOpenApiGapReport of the values of the model imported (with mergesInlineSchemas false) from the document that anInventory describes"

	^ self new checkInventory: anInventory model: aModel
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> checkInventory: anInventory model: aModel [
	"Answer the FamixOpenApiGapReport of the values of the model against the inventory"

	self prepareInventory: anInventory model: aModel.
	self satisfiesPreconditions ifFalse: [ ^ report ].
	self prepare.
	expanded allNodes do: [ :each | self checkNode: each ].
	^ report
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> checkNode: aNode [
	"Compare the fields of the node that have a row, with the entities the node gives"

	| names |
	(self isCompared: aNode) ifFalse: [ ^ self ].
	self recordIgnoredSiblingsOf: aNode.
	names := expectation expectedClassNamesFor: aNode.
	(rulesBySpecObject
		 at: (expanded siteSpecObjectOf: aNode)
		 ifAbsent: [ #(  ) ]) do: [ :each |
		self checkRule: each of: aNode names: names ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> checkOnly: aNode [
	"The gaps of the node alone, in a new report (the check must have been run: the mutation sweeps change a slot and look at one node)"

	report := FamixOpenApiGapReport new
		          file: file;
		          yourself.
	self checkNode: aNode.
	^ report
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> checkRule: aRule of: aNode names: aCollectionOfClassNames [
	"The entries of the comparator of the rule for the values of the node, compared with the entities"

	| comparator status values |
	comparator := aRule comparator.
	values := self valueNodeOf: aNode.
	status := comparator
		          applicabilityOf: values
		          rule: aRule
		          context: self.
	status == #notApplicable ifTrue: [ ^ self ].
	status == #wrongType ifTrue: [
		^ report coverage recordWrongType: (self keyOf: aRule) ].
	(comparator entriesOf: values rule: aRule context: self) do: [ :entry |
		self
			compare:
			(FamixOpenApiValueComparison rule: aRule node: aNode entry: entry)
			names: aCollectionOfClassNames ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> compare: aComparison names: aCollectionOfClassNames [
	"The entity of the class of the rule at the pointer: compared when there is one; an entity of the node itself only when the node gives that class (at a shared pointer the class chooses the entity)"

	| entity key |
	(aComparison hasSuffix or: [
		 aCollectionOfClassNames includes: aComparison rule targetClassName ])
		ifFalse: [ ^ self ].
	key := self keyOf: aComparison rule.
	entity := self entityOf: aComparison.
	entity ifNil: [ ^ report coverage recordWithoutEntity: key ].
	aComparison entity: entity.
	comparisons ifNotNil: [ :kept | kept add: aComparison ].
	report coverage recordCompared: key.
	aComparison isInformative ifTrue: [
		report coverage recordInformative: key ].
	aComparison isEquivalent ifFalse: [ self reportMismatch: aComparison ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> comparisons [
	"The comparisons made when #keepComparisons was sent before the check, in the order of the nodes"

	^ comparisons ifNil: [ #(  ) ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> entityOf: aComparison [
	"The first entity of exactly the class of the rule at the pointer of the comparison, nil when there is none"

	^ (lookup
		   entitiesAt: aComparison entityPointer
		   ofClass:
		   (Smalltalk at: aComparison rule targetClassName asSymbol))
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :found | found first ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> expandedInventory [
	"The inventory the check reads (clones re-rooted, Swagger 2 schemas added), available once the check ran"

	^ expanded
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> fieldOf: aNode [
	"The name of the field of the parent that led to the node"

	^ expanded fieldOf: aNode
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> file: aString [
	"The name of the source file, stamped on the gaps"

	file := aString
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> formRequiredOf: anOperationNode [
	"For an operation of Swagger 2 that has formData parameters and no body parameter (it gets a form request body): true when one of them is required, false otherwise; nil when the operation gets no form request body"

	| forms |
	inventory version = #v2 ifFalse: [ ^ nil ].
	(expectation firstBodyParameterOf:
		 anOperationNode pointer , '/parameters') ifNotNil: [ ^ nil ].
	forms := self swagger2Parameters formsIn: anOperationNode.
	forms ifEmpty: [ ^ nil ].
	^ forms anySatisfy: [ :each |
		  FamixOpenApiValueComparator isTrue: (each valueAt: 'required') ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> isCompared: aNode [
	"False for a node that gives no entity (wrong shape, dropped) and for the nodes of the form schema of Swagger 2, whose details are deferred"

	aNode isWrongShape ifTrue: [ ^ false ].
	^ (derived ruleAt: aNode pointer) ~~ #swagger2FormDataRequestBody
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> isComponentEntry: aNode [
	"True for an entry of a map of the components"

	^ expectation isComponentEntry: aNode
]

{ #category : 'preconditions' }
FamixOpenApiValueCheck >> isMergeEvidence: anEntity [
	"A sub-schema, or a schema that took over the pointers of others, exists only when the inline schemas are merged"

	anEntity class == OPSubSchema ifTrue: [ ^ true ].
	^ anEntity class == OPSchema and: [
		  anEntity mergedPointers isNotEmpty ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> isSchemaOfTypedParameter: aNode [

	^ inventory version = #v2 and: [
		  (expanded fieldOf: aNode) = 'schema' and: [
			  (expanded ownerOf: aNode) ifNil: [ false ] ifNotNil: [ :owner |
				  owner specObject = 'Parameter' and: [
					  self swagger2Parameters isInline: owner ] ] ] ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> keepComparisons [
	"Remember every comparison made, see #comparisons (for the mutation sweeps of the tests)"

	comparisons := OrderedCollection new
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> keyOf: aRule [
	"The key of the rule in the coverage table"

	^ aRule coverageKeyIn: inventory version
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> messageOf: aComparison [
	"What the source says and what the slot holds, as text"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: aComparison rule specObject;
			  nextPut: $.;
			  nextPutAll: aComparison rule fieldKey;
			  nextPutAll: ': the source says ';
			  print: aComparison expected;
			  nextPutAll: ', ';
			  nextPutAll: aComparison rule targetClassName;
			  nextPutAll: '>>';
			  nextPutAll: aComparison rule selector;
			  nextPutAll: ' holds ';
			  print: aComparison rawFound ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> node: aNode without: aCollectionOfKeys [
	"A node of the same place (still a reference) whose object does not have the keys"

	| value |
	value := aNode value copy.
	aCollectionOfKeys do: [ :each | value removeKey: each ].
	^ FamixOpenApiSourceNode
		  specObject: aNode specObject
		  pointer: aNode pointer
		  in: expanded
		  value: value
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> ownerOf: aNode [
	"The object node that holds the node"

	^ expanded ownerOf: aNode
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> parameterTargetOf: aNode [
	"The parameter that a $ref designates in Swagger 2 (it can be the body of the operation), the node itself otherwise"

	^ (aNode referenceText isNotNil and: [
		   inventory version = #v2 and: [
			   (expanded siteSpecObjectOf: aNode) = 'Parameter' ] ])
		  ifTrue: [ (expectation chainTargetOf: aNode) ifNil: [ aNode ] ]
		  ifFalse: [ aNode ]
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> prepare [
	"The expanded inventory (clones re-rooted, Swagger 2 schemas added) and what reads it"

	derived := FamixOpenApiSyntheticExpectations on: inventory.
	expanded := derived expandedInventory.
	expectation := derived nodeExpectation.
	rulesBySpecObject := (FamixOpenApiValueRules rules select: [ :each |
		                      each appliesTo: inventory version ])
		                     groupedBy: #specObject
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> prepareInventory: anInventory model: aModel [
	"Look at the model and start a report: the check can then be run on the whole document (#checkInventory:model:) or on one node (#checkOnly:)"

	inventory := anInventory.
	lookup := FamixOpenApiPointerLookup onModel: aModel.
	report := FamixOpenApiGapReport new
		          file: file;
		          yourself
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> recordIgnoredSiblingsOf: aNode [
	"The keys beside the $ref that the importer ignores are not compared: the coverage counts them"

	(expectation ignoredSiblingKeysOf: aNode) do: [ :each |
		report coverage recordIgnoredSibling: each ]
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> referenceTextOf: aNode [
	"The text of the $ref at the place of the node: its own, or the one of the site that the clone expansion replaced by its target"

	^ aNode referenceText ifNil: [
		  derived referenceTextAt: aNode pointer ]
]

{ #category : 'accessing' }
FamixOpenApiValueCheck >> report [
	"The report of the last run"

	^ report
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> reportMismatch: aComparison [

	report coverage recordMismatch: (self keyOf: aComparison rule).
	report add: ((FamixOpenApiGap
			  kind: aComparison comparator gapKind
			  pointer: aComparison entityPointer
			  specObject: (expanded siteSpecObjectOf: aComparison node))
			 entity: aComparison entity;
			 fieldKey: aComparison rule fieldKey;
			 expected: aComparison expected;
			 found: aComparison found;
			 ruleName: (derived ruleAt: aComparison node pointer);
			 message: (self messageOf: aComparison);
			 yourself)
]

{ #category : 'preconditions' }
FamixOpenApiValueCheck >> reportPrecondition: aKind message: aString [

	report add: ((FamixOpenApiGap
			  kind: aKind
			  pointer: FamixOpenApiSourceNode rootPointer
			  specObject: nil)
			 expected: 'a model imported with mergesInlineSchemas = false';
			 message: aString;
			 yourself)
]

{ #category : 'preconditions' }
FamixOpenApiValueCheck >> satisfiesPreconditions [
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
	self
		reportPrecondition: #preconditionMerged
		message:
			'The model was imported with mergesInlineSchemas = true (the first merged schema is at '
			, merged first canonicalPointer printString
			, '): the value check needs mergesInlineSchemas = false'.
	^ false
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> swagger2Parameters [
	"What the importer decides about the parameters of Swagger 2, read on the expanded inventory"

	^ FamixOpenApiSwagger2Parameters
		  inventory: expanded
		  expectation: expectation
]

{ #category : 'checking' }
FamixOpenApiValueCheck >> typedSchemaNodeOf: aNode [
	"The schema that the typed parameter makes of its own keys"

	^ FamixOpenApiSourceNode
		  specObject: 'Schema'
		  pointer: aNode pointer
		  in: expanded
		  value:
		  (self swagger2Parameters schemaValueOf: (expanded ownerOf: aNode))
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> valueNodeOf: aNode [
	"The node whose values the entity of aNode holds: the node itself; for a $ref to a parameter of Swagger 2 (which can be the body of the operation) the parameter it designates; for the schema of a typed parameter of Swagger 2 a node made of the type, format... of the parameter (they replace a schema that the parameter also has: VERIFIED); in every case without the keys beside a $ref that the importer ignores (OpenAPI 3.0, Swagger 2)"

	(self isSchemaOfTypedParameter: aNode) ifTrue: [
		^ self typedSchemaNodeOf: aNode ].
	^ self withoutIgnoredSiblings: (self parameterTargetOf: aNode)
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> version [
	"#v30, #v31 or #v2"

	^ inventory version
]

{ #category : 'context of the comparators' }
FamixOpenApiValueCheck >> withoutIgnoredSiblings: aNode [
	"The node, or a node of the same place without the keys beside its $ref that the importer ignores: they are not expectations (the coverage counts them)"

	^ (expectation ignoredSiblingKeysOf: aNode)
		  ifEmpty: [ aNode ]
		  ifNotEmpty: [ :ignored | self node: aNode without: ignored ]
]
