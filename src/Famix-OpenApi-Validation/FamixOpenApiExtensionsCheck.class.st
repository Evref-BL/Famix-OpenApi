"
Import fidelity, level 3 (V9): what becomes of the source fields that the value check (V8) does not compare as a typed slot, to say which fields of the specifications are absent from the metamodel and what happens to them at the import. Entry: #checkInventory:model:diagnostics: answers a FamixOpenApiGapReport whose gaps say, per key of a node (the expanded inventory of V8, merging off, clone sites included; the keys beside a $ref are read on the nodes of the sites):
- #onlyInExtensions (informational): the key is not modelled (conformance status #notModelled, an x-* key, an unknown key) and the extensions text of the entity that carries the node holds its value, the same as the source (canonical JSON compare);
- #valueMismatch (failing): the extensions hold the key with another value;
- #ignoredByDiagnostic (informational): the key is not in the extensions and a diagnostic says it is ignored (FamixOpenApiDiagnosticCoverage: refSiblingsIgnored at a node with a $ref, whatever the version: the siblings of a schema of 3.0 or Swagger 2 and those of an ALIAS of the components, 3.0 and 3.1; extraBodyParameter at the dropped parameter; conflictingBodyAndFormData at the operation, for ITS formData parameters only, the kept parameters of the operation are not excused; wrongNodeType at the key for a value of a wrong JSON type, also for a key that the version does not know), the pointer of the diagnostic being the verified one;
- #lost (failing): the key is nowhere (not in the extensions, no diagnostic): a real finding about the importer;
- #silentDrop (failing): a value of the wrong JSON type (V8 #wrongType) that the slot does not hold and that no diagnostic reports; #valueKeptAnyway (informational): the slot holds it anyway (minLength 3.5; the deprecated and writeOnly of a schema of Swagger 2, which the specification does not have and the importer stores in the slots);
- #notDecidable (informational): no diagnostics were given (nil), whether one covers a key that is not in the extensions cannot be told.
The gap report also holds the FREQUENCY table (#extensions, FamixOpenApiExtensionsReport): per version, spec object and field, the occurrences by kind; the keys of relations and of implicit fields are only counted as #deferred (V10).
Not classified: the nodes of the wrong shape, the nodes made by the importer without source (schemas of the typed parameters and the form of Swagger 2), the nodes inside the value of a key that is not modelled (their keys belong to the value of that key). SCOPE: mergesInlineSchemas = FALSE only (preconditions of V7 and V8, reported as gaps). The check does not change the importer and does not depend on it: the diagnostics are any objects that answer #code and #pointer.
KNOWN FACTS (VERIFIED by import experiments, see FamixOpenApiExtensionsCheckTest):
- A path item with a $ref that the importer clones reports the keys of the parameters and bodies of the cloned operations that are beside a $ref TWICE (once under the site and once under the target path), by design: the clone is classified like the target.
- #notDecidable is informational and its gaps have no diagnostics (nil was given).
- REAL IMPORTER FINDINGS, classified #lost on purpose (the check does not hide them): the siblings of a parameter, request body, response, header or link with a $ref at a USE site (3.0 and 3.1: no diagnostic, nothing kept); nullable true of a schema in 3.1 and Swagger 2 (neither a slot nor an extension); the x-* of the Paths, Responses and OAuthFlows containers (no slot, no extensions); the x-* of a formData parameter of an operation without body or of a path item (no diagnostic); maximum with a text (#silentDrop: dropped, no diagnostic).
"
Class {
	#name : 'FamixOpenApiExtensionsCheck',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'lookup',
		'valueCheck',
		'expanded',
		'report',
		'file',
		'diagnostics',
		'parsed',
		'sharedValueCheck'
	],
	#classInstVars : [
		'rowIndex'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiExtensionsCheck class >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"The gap report of the model against the inventory; aDiagnosticsOrNil is nil or a collection of diagnostics (#code, #pointer)"

	^ self new
		  checkInventory: anInventory
		  model: aModel
		  diagnostics: aDiagnosticsOrNil
]

{ #category : 'conformance' }
FamixOpenApiExtensionsCheck class >> conformanceRows [
	"The rows of the conformance of the metamodel to the specifications (FamixOpenApiMetamodelConformance), computed once (see #resetConformance)"

	^ self rowIndex values
]

{ #category : 'data' }
FamixOpenApiExtensionsCheck class >> dataMessages [
	"Rows: kind of gap, what it says about a key"

	^ #( #( #onlyInExtensions 'is kept in the extensions of the entity' )
	     #( #valueMismatch 'is in the extensions with another value' )
	     #( #ignoredByDiagnostic 'is not kept and the importer says so' )
	     #( #lost 'is nowhere in the model and the importer does not say so' )
	     #( #silentDrop 'has a value of the wrong type that the slot does not hold and the importer does not say so' )
	     #( #valueKeptAnyway 'has a value of the wrong type that the slot holds anyway' )
	     #( #notDecidable 'is not in the extensions and no diagnostics were given' ) )
]

{ #category : 'data' }
FamixOpenApiExtensionsCheck class >> dataSynthesizedRules [
	"The rules of FamixOpenApiSyntheticExpectations that make nodes the importer builds without source: they are not source nodes (the schemas of the typed parameters and of the form of Swagger 2)"

	^ #( #swagger2ParameterSchema #swagger2FormDataRequestBody )
]

{ #category : 'conformance' }
FamixOpenApiExtensionsCheck class >> notModelledRows [
	"The rows of the fields that the metamodel does not model (without the x-* rows: the extension keys are classified apart)"

	^ self conformanceRows select: [ :each |
		  each isNotModelled and: [ each fieldName ~= 'x-*' ] ]
]

{ #category : 'conformance' }
FamixOpenApiExtensionsCheck class >> resetConformance [
	"Forget the rows: they are computed again when needed (after a change of the metamodel or of the field table)"

	rowIndex := nil
]

{ #category : 'conformance' }
FamixOpenApiExtensionsCheck class >> rowIndex [
	"A Dictionary { version. spec object. field } -> conformance row"

	^ rowIndex ifNil: [
		  rowIndex := Dictionary new.
		  FamixOpenApiMetamodelConformance check rows do: [ :each |
			  rowIndex
				  at: {
						  each version.
						  each specObject.
						  each fieldName }
				  put: each ].
		  rowIndex ]
]

{ #category : 'conformance' }
FamixOpenApiExtensionsCheck class >> rowOf: aFieldName in: aSpecObjectName version: aVersion [
	"The conformance row of the field, nil when the table has no such field"

	^ self rowIndex
		  at: {
				  aVersion.
				  aSpecObjectName.
				  aFieldName }
		  ifAbsent: [ nil ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> canonicalTextOf: aJsonValue [
	"The canonical text of a JSON value, the same as the one of the value check (sorted keys, 1 and 1.0 are the same)"

	^ FamixOpenApiJsonTextComparator canonicalTextOf: aJsonValue
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> carrierPointerOf: aNode [
	"The pointer of the entities that carry the node: its own, except for the items of a typed parameter of Swagger 2, which the importer makes the schema of the parameter (VERIFIED by import: <parameter>/schema/items)"

	| parameter |
	(aNode version = #v2 and: [ aNode specObject = 'Items' ]) ifFalse: [
		^ aNode pointer ].
	parameter := (expanded ancestorsOf: aNode)
		             detect: [ :each | each specObject = 'Parameter' ]
		             ifNone: [ ^ aNode pointer ].
	^ parameter pointer , '/schema'
	  , (aNode pointer allButFirst: parameter pointer size)
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> carriersOf: aNode [
	"The entities at the place of the node, where its extensions are kept (at a shared pointer, a property and its schema: the key is looked for in each)"

	^ lookup entitiesAt: (self carrierPointerOf: aNode)
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> categoryOf: aKey in: aNode [
	"#extension (to look for in the extensions: not modelled, x-*, unknown, ignored beside a $ref), #deferred (relation, implicit, slot not compared: V10), #siblingSlot (a modelled field beside a $ref, whose slot is read on the entity of the site), #skip (the $ref itself, a field compared by the value check, an entry of a map)"

	(aNode referenceText isNotNil and: [ aKey = '$ref' ]) ifTrue: [
		^ #skip ].
	((self isIgnoredSibling: aKey of: aNode) or: [
		 (aKey beginsWith: 'x-') or: [ aNode unknownKeys includes: aKey ] ])
		ifTrue: [ ^ #extension ].
	^ self categoryOfRow: (self rowOf: aKey in: aNode) in: aNode
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> categoryOfRow: aRowOrNil in: aNode [
	"The category of a key of the node, from its conformance row (nil when the field table has none: an unknown key beside a $ref, an entry of a map)"

	| isReference |
	isReference := aNode referenceText isNotNil.
	aRowOrNil ifNil: [
		^ isReference
			  ifTrue: [ #extension ]
			  ifFalse: [ #skip ] ].
	aRowOrNil isNotModelled ifTrue: [ ^ #extension ].
	(FamixOpenApiValueRules reasonNotComparedFor: aRowOrNil) ifNotNil: [
		^ #deferred ].
	^ isReference
		  ifTrue: [ #siblingSlot ]
		  ifFalse: [ #skip ]
]

{ #category : 'checking' }
FamixOpenApiExtensionsCheck >> checkInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"Answer the FamixOpenApiGapReport of the model against the inventory; aDiagnosticsOrNil is nil or a collection of diagnostics (#code, #pointer: the ones of the importer, in the form the importer gives them)"

	self
		prepareInventory: anInventory
		model: aModel
		diagnostics: aDiagnosticsOrNil.
	self satisfiesPreconditions ifFalse: [ ^ report ].
	self prepare.
	self nodes do: [ :each | self checkNode: each ].
	^ report
]

{ #category : 'checking' }
FamixOpenApiExtensionsCheck >> checkNode: aNode [
	"Classify the keys of the node, then the values of a wrong type"

	(self isChecked: aNode) ifFalse: [ ^ self ].
	aNode value keysDo: [ :each | self classifyKey: each of: aNode ].
	self classifyWrongTypesOf: aNode
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> classifyAbsent: aKey of: aNode [
	"The key is not in the extensions of any entity of the node: a diagnostic that says it is ignored excuses it, else a typed slot that holds the value of the source keeps it anyway (#valueKeptAnyway: the Swagger 2 deprecated of a schema), else it is lost (#notDecidable when no diagnostics were given)"

	| code kind |
	code := self excusingCodeOf: aKey in: aNode.
	kind := code
		        ifNil: [ self kindOfAbsent: aKey of: aNode ]
		        ifNotNil: [ #ignoredByDiagnostic ].
	(self
		 gapOfKind: kind
		 key: aKey
		 of: aNode
		 code: code) expected: (self canonicalTextOf: (aNode valueAt: aKey))
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> classifyExtension: aKey of: aNode [
	"A key that is looked for in the extensions of the entity that carries the node: there (#onlyInExtensions, or #valueMismatch), else a diagnostic says it is ignored, else it is lost"

	(self carriersOf: aNode)
		detect: [ :each | (self extensionsOf: each) includesKey: aKey ]
		ifFound: [ :carrier |
		^ self classifyPresent: aKey of: aNode in: carrier ]
		ifNone: [ ^ self classifyAbsent: aKey of: aNode ]
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> classifyKey: aKey of: aNode [
	"What becomes of the key: kept (or not) as extension, counted for V10, compared as a slot of a node beside a $ref, or not looked at (compared by the value check)"

	| category |
	(self isShadowedByClone: aKey of: aNode) ifTrue: [ ^ self ].
	category := self categoryOf: aKey in: aNode.
	category == #extension ifTrue: [
		^ self classifyExtension: aKey of: aNode ].
	category == #deferred ifTrue: [ ^ self countDeferred: aKey of: aNode ].
	category == #siblingSlot ifTrue: [
		^ self classifySiblingSlot: aKey of: aNode ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> classifyPresent: aKey of: aNode in: anEntity [
	"The extensions of the entity have the key: the value is the one of the source or it is not"

	| expected found kind |
	expected := self canonicalTextOf: (aNode valueAt: aKey).
	found := self canonicalTextOf:
		         ((self extensionsOf: anEntity) at: aKey).
	kind := expected = found
		        ifTrue: [ #onlyInExtensions ]
		        ifFalse: [ #valueMismatch ].
	(self
		 gapOfKind: kind
		 key: aKey
		 of: aNode
		 code: (self keyKeptCodeOf: aKey in: aNode))
		entity: anEntity;
		expected: expected;
		found: found
]

{ #category : 'siblings' }
FamixOpenApiExtensionsCheck >> classifySiblingSlot: aKey of: aNode [
	"A modelled field beside a $ref that the importer reads (OpenAPI 3.1, or the description of an alias): its slot is read on the entity of the site. A value that the slot does not hold is classified as an absent key: ignored when the importer says it ignores the siblings (the aliases of the components), else lost (the importer keeps the one of the target: knownImporterGaps)"

	(valueCheck rulesOf: aNode)
		detect: [ :each | each fieldKey = aKey ]
		ifFound: [ :rule |
			(self siblingSlotKeeps: rule of: aNode) ifFalse: [
				self classifyAbsent: aKey of: aNode ] ]
		ifNone: [  ]
]

{ #category : 'wrong types' }
FamixOpenApiExtensionsCheck >> classifyWrongType: aKey rules: aCollectionOfRules of: aNode [
	"A value of the wrong type, carried by the entities of the rules (a property and its schema carry the same key): #valueKeptAnyway when a slot holds it, else #ignoredByDiagnostic when the importer says it rejects it (the pointer of the diagnostic is the one of the key), else #silentDrop (#notDecidable when no diagnostics were given). Nothing when no entity is in the model (the existence check reports it)"

	| entities code |
	entities := aCollectionOfRules collect: [ :each |
		            each -> (self entityOfRule: each at: aNode) ].
	(entities allSatisfy: [ :each | each value isNil ]) ifTrue: [ ^ self ].
	(entities anySatisfy: [ :each |
		 each value isNotNil and: [
			 self
				 slotOf: each value
				 rule: each key
				 keeps: (aNode valueAt: aKey) ] ]) ifTrue: [
		^ self
			  gapOfKind: #valueKeptAnyway
			  key: aKey
			  of: aNode
			  code: nil ].
	diagnostics isDecidable ifFalse: [
		^ self
			  gapOfKind: #notDecidable
			  key: aKey
			  of: aNode
			  code: nil ].
	code := self rejectingCodeOf: aKey in: aNode.
	^ code
		  ifNil: [
			  self
				  gapOfKind: #silentDrop
				  key: aKey
				  of: aNode
				  code: nil ]
		  ifNotNil: [
			  self
				  gapOfKind: #ignoredByDiagnostic
				  key: aKey
				  of: aNode
				  code: code ]
]

{ #category : 'wrong types' }
FamixOpenApiExtensionsCheck >> classifyWrongTypesOf: aNode [
	"The fields of the node whose value has a JSON type that does not fit (V8 does not compare them), one occurrence per key: what the slots hold, what the importer says"

	| rules |
	aNode referenceText ifNotNil: [ ^ self ].
	rules := (valueCheck wrongTypeRulesOf: aNode) select: [ :each |
		         aNode includesKey: each fieldKey ].
	(rules groupedBy: #fieldKey) keysAndValuesDo: [ :key :group |
		self classifyWrongType: key rules: group of: aNode ]
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> countDeferred: aKey of: aNode [
	"A key of a relation or of an implicit field: only counted, V10 classifies it"

	self
		countKind: #deferred
		key: aKey
		of: aNode
		code: nil
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> countKind: aKind key: aKey of: aNode code: aCodeOrNil [
	"One occurrence of the field in the frequency table"

	(report extensions
		 ensureFrequencyOf: (expanded siteSpecObjectOf: aNode)
		 field: (self labelOf: aKey in: aNode)
		 in: aNode version) recordKind: aKind code: aCodeOrNil
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> droppedChildCodesOf: aNode [
	"The codes of the diagnostics of the operation that say that it drops its formData parameters, when the node is one of them (a kept parameter of the same operation, a path-level parameter, the responses...: none)"

	| owner |
	owner := expanded ownerOf: aNode.
	owner ifNil: [ ^ #(  ) ].
	^ (self isFormDataParameter: aNode)
		  ifTrue: [
		  diagnostics codesAt: owner pointer role: #childrenDropped ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'wrong types' }
FamixOpenApiExtensionsCheck >> entityOfRule: aRule at: aNode [
	"The first entity of the class of the rule at the pointer of the node, nil when there is none"

	^ (lookup
		   entitiesAt: aNode pointer
		   ofClass: (Smalltalk at: aRule targetClassName asSymbol))
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :found | found first ]
]

{ #category : 'siblings' }
FamixOpenApiExtensionsCheck >> entry: anEntry of: aRule at: aNode [
	"True when the entity of the class of the rule, at the pointer of the entry, is in the model and holds the expected value"

	| comparison |
	comparison := FamixOpenApiValueComparison
		              rule: aRule
		              node: aNode
		              entry: anEntry.
	comparison entity: (valueCheck entityOf: comparison).
	^ comparison entity isNotNil and: [ comparison isEquivalent ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> excusingCodeOf: aKey in: aNode [
	"The code of a diagnostic that tells that the key is ignored (nil for none): the keys beside a $ref (the pointer is the one of the node, whatever the version: the importer says it for the siblings it ignores, the aliases of the components), a node that is dropped (the node), a formData parameter dropped by the operation (the operation, only for the formData parameters of it), a value of a wrong type (the key)"

	^ (self siblingCodesOf: aNode)
	  , (diagnostics codesAt: aNode pointer role: #nodeDropped)
	  , (self droppedChildCodesOf: aNode) , (diagnostics
		   codesAt: (self keyPointerOf: aKey in: aNode)
		   role: #valueRejected)
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :codes | codes first ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsCheck >> expandedInventory [
	"The inventory the check reads (clones re-rooted, Swagger 2 schemas added), available once the check ran"

	^ expanded
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> extensionsOf: anEntity [
	"The keys and values of the JSON text of the extensions of the entity (empty when there is none or the text is not a JSON object), parsed once"

	^ parsed
		  at: anEntity
		  ifAbsentPut: [ self objectOfText: anEntity extensions ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsCheck >> file [
	"The name of the source document, nil when it is unknown"

	^ file
]

{ #category : 'accessing' }
FamixOpenApiExtensionsCheck >> file: aString [

	file := aString
]

{ #category : 'gaps' }
FamixOpenApiExtensionsCheck >> gapOfKind: aKind key: aKey of: aNode code: aCodeOrNil [
	"Count the occurrence in the frequency table and add a gap about the key to the report; answers the gap, to complete (entity, expected, found)"

	| gap |
	self
		countKind: aKind
		key: aKey
		of: aNode
		code: aCodeOrNil.
	gap := FamixOpenApiGap
		       kind: aKind
		       pointer: aNode pointer
		       specObject: (expanded siteSpecObjectOf: aNode).
	gap
		fieldKey: aKey;
		message: (self
				 messageOf: aKind
				 key: aKey
				 of: aNode
				 code: aCodeOrNil).
	report add: gap.
	^ gap
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> isChecked: aNode [
	"False for a node that is not an object, for the nodes the importer makes without source and for the nodes inside the value of a key that is not modelled"

	(aNode isWrongShape or: [ aNode value isDictionary not ]) ifTrue: [
		^ false ].
	(self isSynthesized: aNode) ifTrue: [ ^ false ].
	^ (self isInsideUnmodelledValue: aNode) not
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> isFormDataParameter: aNode [
	"True for a parameter of Swagger 2 whose location (the `in` of its effective node, after its $ref) is formData"

	^ (expanded siteSpecObjectOf: aNode) = 'Parameter' and: [
		  (valueCheck swagger2Parameters locationOf: aNode) = 'formData' ]
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> isIgnoredSibling: aKey of: aNode [
	"True for a key beside the $ref that the importer does not read (OpenAPI 3.0 and Swagger 2)"

	^ (valueCheck nodeExpectation ignoredSiblingKeysOf: aNode) includes:
		  aKey
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> isInsideUnmodelledValue: aNode [
	"True when the node, or a node above it, is the value of a field that the metamodel does not model (the $defs of a schema, the examples of a response of Swagger 2, the items of a header...): its keys belong to the value of that field, classified on the node that has the field"

	^ ((expanded ancestorsOf: aNode) copyWithFirst: aNode) anySatisfy: [
		  :each | self isUnmodelledValue: each ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> isKeptBySlot: aKey of: aNode [
	"True when a typed slot of an entity at the place of the node holds the value of the key, though the key is not in the table of the version (the table of any version is read: the importer stores the deprecated of a schema of Swagger 2, which the specification does not have)"

	^ (self slotRulesOf: aKey in: aNode) anySatisfy: [ :rule |
		  (self entityOfRule: rule at: aNode)
			  ifNil: [ false ]
			  ifNotNil: [ :entity |
				  self slotOf: entity rule: rule keeps: (aNode valueAt: aKey) ] ]
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> isShadowedByClone: aKey of: aNode [
	"True for a key of a node with a $ref whose site the clone expansion replaced by a copy of its target that holds the same value for the key (the siblings that the importer applies, 3.1 path item): it is classified on the copy"

	aNode referenceText ifNil: [ ^ false ].
	^ (expanded nodeAt: aNode pointer ifAbsent: [ nil ])
		  ifNil: [ false ]
		  ifNotNil: [ :site |
			  site referenceText isNil and: [
				  (site includesKey: aKey) and: [
					  (site valueAt: aKey) = (aNode valueAt: aKey) ] ] ]
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> isSynthesized: aNode [
	"A node that the importer makes without source (the schema of a typed parameter, the form of Swagger 2)"

	^ self class dataSynthesizedRules includes:
		  (valueCheck derivation ruleAt: aNode pointer)
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> isUnmodelledValue: aNode [
	"True when the field of the parent that led to the node is one that the metamodel does not model"

	| owner field |
	owner := expanded ownerOf: aNode.
	field := expanded fieldOf: aNode.
	(owner isNil or: [ field isNil ]) ifTrue: [ ^ false ].
	^ (self
		   rowOf: field
		   in: (expanded siteSpecObjectOf: owner)
		   version: aNode version)
		  ifNil: [ false ]
		  ifNotNil: [ :row | row isNotModelled ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> keyKeptCodeOf: aKey in: aNode [
	"The code of the diagnostic that says the key is kept in the extensions (the pointer is the one of the key), nil for none"

	^ (diagnostics
		   codesAt: (self keyPointerOf: aKey in: aNode)
		   role: #keyKept)
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :codes | codes first ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> keyPointerOf: aKey in: aNode [
	"The pointer of the key of the node, as the importer gives it in its diagnostics"

	^ FamixOpenApiSourceNode pointerOf: aNode pointer child: aKey
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> kindOfAbsent: aKey of: aNode [
	"The kind of a key that is not in the extensions and that no diagnostic excuses: #valueKeptAnyway when a slot holds its value, #notDecidable when no diagnostics were given, else #lost"

	(self isKeptBySlot: aKey of: aNode) ifTrue: [ ^ #valueKeptAnyway ].
	^ diagnostics isDecidable
		  ifTrue: [ #lost ]
		  ifFalse: [ #notDecidable ]
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> labelOf: aKey in: aNode [
	"The field of the frequency table: x-* for every extension key, the key followed by (beside $ref) when the importer ignores it beside a $ref, the key otherwise"

	(self isIgnoredSibling: aKey of: aNode) ifTrue: [
		^ aKey , ' (beside $ref)' ].
	^ (aKey beginsWith: 'x-')
		  ifTrue: [ 'x-*' ]
		  ifFalse: [ aKey ]
]

{ #category : 'gaps' }
FamixOpenApiExtensionsCheck >> messageOf: aKind key: aKey of: aNode code: aCodeOrNil [
	"What the gap says: the key of the spec object, what became of it, and the code of the diagnostic when there is one"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: (expanded siteSpecObjectOf: aNode);
			  nextPut: $.;
			  nextPutAll: aKey;
			  space;
			  nextPutAll: (self class dataMessages
					   detect: [ :each | each first = aKind ]
					   ifFound: [ :row | row second ]
					   ifNone: [ aKind asString ]).
		  aCodeOrNil ifNotNil: [
			  stream
				  nextPutAll: ' (';
				  nextPutAll: aCodeOrNil;
				  nextPut: $) ] ]
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> nodes [
	"The nodes whose keys are classified: the nodes of the expanded inventory that are not references, and the references (of the document and of the clones), whose siblings are read on the node of the site"

	^ (expanded allNodes reject: [ :each | each referenceText isNotNil ])
	  , self referenceNodes
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> objectOfText: aTextOrNil [
	"The Dictionary that the JSON text holds, an empty one for nil, for a text that is not JSON and for a JSON that is not an object"

	| value |
	aTextOrNil isString ifFalse: [ ^ Dictionary new ].
	value := [ NeoJSONReader fromString: aTextOrNil ]
		         on: NeoJSONParseError
		         do: [ :error | nil ].
	^ value isDictionary
		  ifTrue: [ value ]
		  ifFalse: [ Dictionary new ]
]

{ #category : 'preparing' }
FamixOpenApiExtensionsCheck >> prepare [
	"The expanded inventory (clones re-rooted, Swagger 2 schemas added) and what reads it"

	valueCheck prepare.
	expanded := valueCheck expandedInventory.
	report extensions notModelledRows: self class notModelledRows
]

{ #category : 'preparing' }
FamixOpenApiExtensionsCheck >> prepareInventory: anInventory model: aModel diagnostics: aDiagnosticsOrNil [
	"Look at the model and the diagnostics and start a report"

	inventory := anInventory.
	diagnostics := FamixOpenApiDiagnosticCoverage on: aDiagnosticsOrNil.
	parsed := IdentityDictionary new.
	valueCheck := self valueCheckOn: anInventory model: aModel.
	lookup := valueCheck lookup.
	report := FamixOpenApiGapReport new
		          file: file;
		          yourself
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> referenceNodes [
	"The nodes with a $ref of the document (the clone expansion replaces some by a copy of their target, the node of the document keeps the siblings), and the ones inside the clones"

	^ (inventory allNodes select: [ :each | each referenceText isNotNil ])
	  ,
		  ((expanded allNodes select: [ :each | each referenceText isNotNil ])
			   reject: [ :each | inventory includesPointer: each pointer ])
]

{ #category : 'wrong types' }
FamixOpenApiExtensionsCheck >> rejectingCodeOf: aKey in: aNode [
	"The code of the diagnostic that says the importer rejects the value of the key (the pointer is the one of the key), nil for none"

	^ (diagnostics
		   codesAt: (self keyPointerOf: aKey in: aNode)
		   role: #valueRejected)
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :codes | codes first ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsCheck >> report [
	"The report of the last run"

	^ report
]

{ #category : 'keys' }
FamixOpenApiExtensionsCheck >> rowOf: aKey in: aNode [
	"The conformance row of the key in the spec object of the place of the node"

	^ self
		  rowOf: aKey
		  in: (expanded siteSpecObjectOf: aNode)
		  version: aNode version
]

{ #category : 'nodes' }
FamixOpenApiExtensionsCheck >> rowOf: aFieldName in: aSpecObjectName version: aVersion [
	"The conformance row of the field of the spec object, nil when the field table does not have it"

	^ self class rowOf: aFieldName in: aSpecObjectName version: aVersion
]

{ #category : 'preparing' }
FamixOpenApiExtensionsCheck >> satisfiesPreconditions [
	"False, with the gaps of the value check in the report, for a document of unknown version or a model imported with the inline schemas merged"

	valueCheck satisfiesPreconditions ifTrue: [ ^ true ].
	valueCheck report gaps do: [ :each | report add: each ].
	^ false
]

{ #category : 'preparing' }
FamixOpenApiExtensionsCheck >> shareValueCheck: aValueCheck [
	"Use aValueCheck, prepared on the same inventory and model, instead of a new one: the expansion of the inventory and the lookup of the model are then made once for several checks (FamixOpenApiFidelityChecker). The check must be given before #checkInventory:model:diagnostics:"

	sharedValueCheck := aValueCheck
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> siblingCodesOf: aNode [
	"The codes of the diagnostics that say the importer ignores the keys beside the $ref of the node (none for a node without $ref)"

	aNode referenceText ifNil: [ ^ #(  ) ].
	^ diagnostics codesAt: aNode pointer role: #siblingsIgnored
]

{ #category : 'siblings' }
FamixOpenApiExtensionsCheck >> siblingSlotKeeps: aRule of: aNode [
	"True when every entry of the comparator of the rule is what the entity of the site holds (or the value has not the right type: nothing to compare)"

	| comparator |
	comparator := aRule comparator.
	(comparator applicabilityOf: aNode rule: aRule context: valueCheck)
	== #compare ifFalse: [ ^ true ].
	^ (comparator entriesOf: aNode rule: aRule context: valueCheck)
		  allSatisfy: [ :entry | self entry: entry of: aRule at: aNode ]
]

{ #category : 'wrong types' }
FamixOpenApiExtensionsCheck >> slotOf: anEntity rule: aRule keeps: aSourceValue [
	"True when the slot of the rule holds the value of the source (a JSON text slot: the same JSON). The slot is read by its selector: the table of the rules is data, a boundary where the reflective send is the point"

	| slot |
	slot := anEntity perform: aRule selector.
	slot ifNil: [ ^ false ].
	slot = aSourceValue ifTrue: [ ^ true ].
	^ slot isString and: [
		  (FamixOpenApiJsonTextComparator new foundFrom: slot)
		  = (self canonicalTextOf: aSourceValue) ]
]

{ #category : 'extensions' }
FamixOpenApiExtensionsCheck >> slotRulesOf: aKey in: aNode [
	"The rules of the table (of every version) for the key in the spec object of the place of the node"

	| specObject |
	specObject := expanded siteSpecObjectOf: aNode.
	^ (#( #v30 #v31 #v2 ) flatCollect: [ :each |
		   FamixOpenApiValueRules rulesFor: specObject in: each ]) select: [
		  :each | each fieldKey = aKey ]
]

{ #category : 'preparing' }
FamixOpenApiExtensionsCheck >> valueCheckOn: anInventory model: aModel [
	"The value check that reads the model and supplies the expanded inventory: the one given by #shareValueCheck: when there is one, else a new one"

	^ sharedValueCheck ifNil: [
		  FamixOpenApiValueCheck new
			  prepareInventory: anInventory model: aModel;
			  yourself ]
]
