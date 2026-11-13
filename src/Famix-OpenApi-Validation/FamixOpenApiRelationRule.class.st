"
One row of the table of the relation check (FamixOpenApiRelationRules): a relation of the model (the OP class that holds it, its selector, the OP class of the targets) with the SPEC OBJECT of the source whose nodes own it, the way the targets are derived from the source (a derivation, see FamixOpenApiRelationDerivation class>>named:arguments:family:), the versions it is for, how the lists are compared (#ordered: same targets in the same order; #set: same targets whatever the order; #count: same number) and the fields of the conformance rows that it carries (rowFields, of the spec object rowSpecObject: the fields that V8 and V9 deferred as relation or implicit structure). ownerKind says where the owners come from: #(#node) the nodes of the spec object (#(#node suffix): the entity sits at the pointer of the node plus the suffix, the components of Swagger 2), #(#property) the entries of the properties of a schema, #(#synthetic ruleNames) the entities that a derivation without node gives (FamixOpenApiSyntheticExpectations).
"
Class {
	#name : 'FamixOpenApiRelationRule',
	#superclass : 'Object',
	#instVars : [
		'derivation',
		'group',
		'row'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiRelationRule class >> group: aGroup row: aRow [
	"A rule from a group of FamixOpenApiRelationRules and one of its rows (see the class comment)"

	^ self new
		  initializeGroup: aGroup row: aRow;
		  yourself
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> appliesTo: aVersion [
	"True when the rule is for the version (#v30, #v31 or #v2)"

	^ self versions includes: aVersion
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> arguments [

	^ row at: 5
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> carriesRow: aConformanceRow [
	"True when the rule compares the field of the conformance row (FamixOpenApiConformanceRow): a field of the spec object of the rule, or a field written with its spec object (Items.items)"

	(self versions includes: aConformanceRow version) ifFalse: [ ^ false ].
	^ (self rowSpecObject = aConformanceRow specObject and: [
		   self rowFields includes: aConformanceRow fieldName ]) or: [
		  self rowFields includes:
			  aConformanceRow specObject , '.' , aConformanceRow fieldName ]
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> compareMode [
	"#ordered, #set or #count"

	^ row at: 8 ifAbsent: [ #ordered ]
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> coverageKeyIn: aVersion [
	"The key of the coverage table: version, spec object, field, class and relation"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: aVersion;
			  space;
			  nextPutAll: self specObject;
			  nextPut: $.;
			  nextPutAll: self fieldKey;
			  nextPutAll: ' -> ';
			  nextPutAll: self ownerClassName;
			  nextPutAll: '>>';
			  nextPutAll: self selector ]
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> derivation [
	"The derivation of the targets of the rule"

	^ derivation ifNil: [
		  derivation := FamixOpenApiRelationDerivation
			                named: self derivationName
			                arguments: self arguments
			                family: self targetFamily ]
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> derivationName [

	^ row at: 4
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> fieldKey [
	"The key of the source that gives the relation (the first of the keys when several), as the coverage and the gaps name it"

	^ row first
]

{ #category : 'initialization' }
FamixOpenApiRelationRule >> initializeGroup: aGroup row: aRow [
	"The group of FamixOpenApiRelationRules (spec object, OP class of the owners, kind of owners, spec object of the conformance rows, rows) and one of its rows: the field key, the selector, the OP class of the targets, the derivation, its arguments, the versions and, optionally, the conformance fields carried (the field key when omitted) and the compare mode (#ordered when omitted)"

	group := aGroup.
	row := aRow
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> ownerClass [
	"The OP class of the entities that hold the relation"

	^ Smalltalk at: self ownerClassName asSymbol
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> ownerClassName [
	"The name of the OP class that holds the relation"

	^ group at: 2
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> ownerKind [
	"Where the owners come from, see the class comment"

	^ group at: 3
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> ownerKindName [
	"#node, #property or #synthetic"

	^ self ownerKind first
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> ownerSuffix [
	"The text added to the pointer of the node to get the pointer of the entity (the components of Swagger 2), empty for the other rules"

	^ self ownerKind at: 2 ifAbsent: [ '' ]
]

{ #category : 'printing' }
FamixOpenApiRelationRule >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self specObject asString;
		nextPut: $.;
		nextPutAll: self fieldKey asString;
		nextPutAll: ' -> ';
		nextPutAll: self ownerClassName asString;
		nextPutAll: '>>';
		nextPutAll: self selector asString;
		nextPut: $)
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> rowFields [
	"The names of the fields of the conformance rows that the rule carries: the key when the row does not say"

	^ row at: 7 ifAbsent: [ { self fieldKey } ]
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> rowSpecObject [
	"The spec object of the conformance rows that the rule carries"

	^ group at: 4
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> selector [
	"The selector of the relation of the OP class"

	^ row at: 2
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> specObject [
	"The name of the spec object of the source nodes that own the relation"

	^ group first
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> syntheticRuleNames [
	"The names of the rules that derive the entities that own the relation, for the kind #synthetic"

	^ self ownerKind at: 2 ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> targetClassName [
	"The name of the OP class of the targets"

	^ row at: 3
]

{ #category : 'querying' }
FamixOpenApiRelationRule >> targetFamily [
	"The family of the targets: the class directly below OPEntity that the target class belongs to"

	^ FamixOpenApiPointerLookup familyOfClass:
		  (Smalltalk at: self targetClassName asSymbol)
]

{ #category : 'accessing' }
FamixOpenApiRelationRule >> versions [
	"The versions the rule is for (#v30, #v31, #v2)"

	^ row at: 6
]
