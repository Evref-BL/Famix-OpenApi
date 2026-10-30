"
The entities the importer builds WITHOUT a node of their own at their pointer, derived EXACTLY from the source inventory (no model, no importer): #expectedEntities answers a collection of FamixOpenApiExpectedEntity (pointer, class, rule, origin node), #expectedEntitiesAt: the ones of a pointer. FamixOpenApiExistenceCheck compares them with the model: a forgotten one is #missingEntity, an entity that none derives is #extraEntity, a duplicate #unexpectedMultiple, a wrong class #wrongClass. The derivation works on a copy of the inventory (#expandedInventory) where (1) the clones of the $ref responses and path items are re-rooted at their sites (FamixOpenApiCloneExpansion) and (2) the schemas the importer builds from other keys are nodes too (FamixOpenApiSwagger2Schemas: the type, format and items of a Swagger 2 typed parameter, the schema of a $ref body parameter, the form schema made of the formData parameters), so that FamixOpenApiNodeExpectation gives the entities of everything added; the entities that are not schemas come from FamixOpenApiSwagger2Content (components, media types by produces and consumes, form request body) and FamixOpenApiKeyedEntities (discriminator, mapping entries, scalar examples, security requirement items and scopes). The servers without node are not derived here (FamixOpenApiSynthesizedServers). The rule names are listed by #dataRules with what each one stands for; an entity below a cloned site always has the rule #cloneSubtree. WHAT IS NOT DERIVED EXACTLY is listed by #knownLimits (each one has a test).
"
Class {
	#name : 'FamixOpenApiSyntheticExpectations',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'expansion',
		'expanded',
		'expectation',
		'entities',
		'ruleByPointer',
		'byPointer'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiSyntheticExpectations class >> dataRules [
	"Rows: rule name, versions, what the importer builds and why it has no source node (the servers are derived by FamixOpenApiSynthesizedServers, the others here)"

	^ #( #( #cloneSubtree 'v2 v30 v31' 'Entity under the site of a $ref response or path item: the clone reads its target again at the pointers below the site (derived by re-rooting the target, FamixOpenApiCloneExpansion)' )
	     #( #synthesizedServer 'v2 v30 v31' 'OPServer at #/servers/N: the default server of an OpenAPI 3 document without servers, the servers made from host, basePath and schemes in Swagger 2 (FamixOpenApiSynthesizedServers)' )
	     #( #swagger2Components 'v2' 'OPComponents at #/components: Swagger 2 has no components, the importer builds them when the root has definitions, parameters, responses or securityDefinitions' )
	     #( #swagger2ParameterSchema 'v2' 'OPSchema at <parameter>/schema and below (items): the type, format and items of a typed parameter become a schema; the schema of a $ref body parameter is read again at the site' )
	     #( #swagger2MediaType 'v2' 'OPMediaType at <response or body parameter>/content/<mime>: one per produces or consumes entry for a response with a schema or the first body parameter' )
	     #( #swagger2Discriminator 'v2' 'OPDiscriminator at <schema>/discriminator: the discriminator of Swagger 2 is a string, not an object' )
	     #( #wrongShapeDiscriminator 'v30 v31' 'OPDiscriminator at <schema>/discriminator when the value is not an object: the importer builds one anyway' )
	     #( #swagger2FormDataRequestBody 'v2' 'Entities at <operation>/requestBody and below: the formData parameters of an operation without body parameter become a request body, its media types, its schema and one property per parameter' )
	     #( #securityScope 'v2 v30 v31' 'OPSecurityScope at <scheme or flow>/scopes/<name>: the keys of the scopes map' )
	     #( #securityRequirementItem 'v2 v30 v31' 'OPSecurityRequirementItem at <requirement>/<scheme name>: the keys of a security requirement' )
	     #( #discriminatorMappingEntry 'v30 v31' 'OPDiscriminatorMapping at <discriminator>/mapping/<key>: the keys of the mapping' )
	     #( #scalarExample 'v30 v31' 'OPExample at <parameter or media type>/example: built from the `example` value of the node' ) )
]

{ #category : 'data' }
FamixOpenApiSyntheticExpectations class >> knownLimits [
	"Rows: name, what the derivation does not follow the importer in. Each one has a test that freezes the gaps it gives, so that a change is noticed"

	^ #( #( #refIntoExtension 'A $ref that designates a value outside the nodes of the grammar (below an x- extension or an unknown key): the importer reads the value, the inventory has no node there. The site is reported #referenceNotResolved, and what the importer builds from the value #extraEntity' )
	     #( #cloneDepth 'Clones nested deeper than FamixOpenApiCloneExpansion class>>dataMaxDepth (32 clones inside clones: callbacks of path items that designate path items): the entities below the deepest derived clone are reported #extraEntity' ) )
]

{ #category : 'instance creation' }
FamixOpenApiSyntheticExpectations class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> add: aClassName at: aPointer rule: aRuleName origin: aNode [
	"An entity of the class aClassName is expected at aPointer, derived from aNode by the rule aRuleName (#cloneSubtree below a cloned site)"

	entities add: (FamixOpenApiExpectedEntity
			 pointer: aPointer
			 className: aClassName
			 rule: (self ruleFor: aPointer default: aRuleName)
			 origin: aNode pointer)
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> addSchemaValue: aValue at: aPointer rule: aRuleName [
	"The importer builds a schema at aPointer from aValue, which is not a node of the document: add the nodes of that schema to the expanded inventory, so that they give their entities. Nothing when the document has a node there"

	| root |
	(expanded includesPointer: aPointer) ifTrue: [ ^ self ].
	root := FamixOpenApiSourceNode
		        specObject: 'Schema'
		        pointer: aPointer
		        in: expanded
		        value: aValue.
	FamixOpenApiSourceWalker new
		walkRoot: root
		into: expanded
		edge: (FamixOpenApiSpecGrammar
				 edgeForKey: 'schema'
				 in: 'Parameter'
				 version: expanded version).
	self tagNodesAt: aPointer rule: aRuleName
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> collectNodeEntities [
	"The entities of the nodes added to the inventory: what FamixOpenApiNodeExpectation says they give"

	entities addAll: (ruleByPointer associations flatCollect: [ :each |
			 self entitiesOfNodeAt: each key rule: each value ])
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> compute [

	entities := OrderedCollection new.
	ruleByPointer := Dictionary new.
	expansion := FamixOpenApiCloneExpansion on: inventory.
	expanded := expansion expandedInventory.
	expectation := FamixOpenApiNodeExpectation on: expanded.
	self markCloneNodes.
	(FamixOpenApiSwagger2Schemas on: self) addSchemaNodes.
	self collectNodeEntities.
	(FamixOpenApiSwagger2Content on: self) derive.
	(FamixOpenApiKeyedEntities on: self) derive.
	byPointer := entities groupedBy: [ :each | each pointer ]
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> eligibleNodesOf: aSpecObjectName [
	"The nodes of the spec object in the expanded inventory that the importer reads (wrong-shaped and dropped ones left out)"

	^ (expanded nodesOf: aSpecObjectName) reject: [ :each |
		  expectation isDropped: each ]
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> entitiesOfNodeAt: aPointer rule: aRuleName [
	"The entities that the node added to the expanded inventory at aPointer gives"

	^ (expectation expectedClassNamesFor: (expanded nodeAt: aPointer))
		  collect: [ :name |
			  FamixOpenApiExpectedEntity
				  pointer: aPointer
				  className: name
				  rule: aRuleName
				  origin: aPointer ]
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> expandedInventory [
	"The inventory the derivations work on: the clones re-rooted, the synthesized schemas added"

	expanded ifNil: [ self compute ].
	^ expanded
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> expectedEntities [
	"Every entity without node of its own that the document implies (the servers excepted), as FamixOpenApiExpectedEntity"

	entities ifNil: [ self compute ].
	^ entities
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> expectedEntitiesAt: aPointer [
	"The expected entities at aPointer, none gives an empty Array"

	byPointer ifNil: [ self compute ].
	^ byPointer at: aPointer ifAbsent: [ #(  ) ]
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> inventory: aSourceInventory [

	inventory := aSourceInventory
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> markCloneNodes [
	"The nodes below a cloned site were added by the expansion"

	expanded allNodes do: [ :each |
		(expansion isBelowCloneSite: each pointer) ifTrue: [
			ruleByPointer at: each pointer put: #cloneSubtree ] ]
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> nodeExpectation [
	"The FamixOpenApiNodeExpectation on the expanded inventory"

	^ expectation
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> pointers [
	"The pointers where an entity is expected"

	byPointer ifNil: [ self compute ].
	^ byPointer keys
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> ruleFor: aPointer default: aRuleName [

	^ (expansion isBelowCloneSite: aPointer)
		  ifTrue: [ #cloneSubtree ]
		  ifFalse: [ aRuleName ]
]

{ #category : 'deriving' }
FamixOpenApiSyntheticExpectations >> specObjectOf: anExpectedEntity [
	"The spec object of the node the entity is derived from, nil when that node is not in the document nor in its expansion"

	^ (self expandedInventory
		   nodeAt: anExpectedEntity originPointer
		   ifAbsent: [ nil ]) ifNotNil: [ :node | node specObject ]
]

{ #category : 'services for the derivations' }
FamixOpenApiSyntheticExpectations >> tagNodesAt: aPointer rule: aRuleName [
	"The nodes at and below aPointer were added by a derivation"

	expanded allNodes do: [ :each |
		(each pointer = aPointer or: [
			 FamixOpenApiSourceNode pointer: each pointer isBelow: aPointer ])
			ifTrue: [
			ruleByPointer at: each pointer ifAbsentPut: [ aRuleName ] ] ]
]
