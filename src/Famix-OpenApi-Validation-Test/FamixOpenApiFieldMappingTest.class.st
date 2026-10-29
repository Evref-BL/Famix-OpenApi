"
I test the consistency of FamixOpenApiFieldMapping data: every spec object and every override names an existing OP class and an existing slot or relation, every entry names a field of the field table, and the lookup rules (default selector, x-* extensions) hold.
"
Class {
	#name : 'FamixOpenApiFieldMappingTest',
	#superclass : 'TestCase',
	#instVars : [
		'introspector'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> assertEntry: anEntry of: anObjectName [

	| className |
	className := anEntry targetClassName ifNil: [
		             FamixOpenApiFieldMapping classNameFor: anObjectName ].
	self
		assert: (introspector hasClassNamed: className)
		description: ('{1} {2}: no class {3}' format: {
					 anObjectName.
					 anEntry fieldName.
					 className }).
	self
		assert: (introspector
				 isModelled: anEntry selector
				 in: (introspector classNamed: className))
		description: ('{1} {2}: {3} has no {4}' format: {
					 anObjectName.
					 anEntry fieldName.
					 className.
					 anEntry selector })
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> fieldNamed: aName in: anObjectName [

	^ FamixOpenApiSpecFieldTable allFields detect: [ :each |
		  each specObject = anObjectName and: [ each name = aName ] ]
]

{ #category : 'running' }
FamixOpenApiFieldMappingTest >> setUp [

	super setUp.
	introspector := FamixOpenApiMetamodelIntrospector new
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testDefaultSelector [

	self
		assert: (FamixOpenApiFieldMapping defaultSelectorFor: 'title')
		equals: #title.
	self assert:
		(FamixOpenApiFieldMapping defaultSelectorFor: 'x-*') isNil.
	self assert:
		(FamixOpenApiFieldMapping defaultSelectorFor: '$ref') isNil.
	self assert:
		(FamixOpenApiFieldMapping defaultSelectorFor: '{name}') isNil.
	self assert:
		(FamixOpenApiFieldMapping defaultSelectorFor: '/{path}') isNil
]

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> testEveryEntryNamesAFieldOfItsObject [

	FamixOpenApiFieldMapping allEntries do: [ :each |
		self
			assert:
				(FamixOpenApiSpecFieldTable allFields anySatisfy: [ :field |
					 field specObject = each key and: [
						 field name = each value fieldName ] ])
			description: ('{1} has no field {2}' format: {
						 each key.
						 each value fieldName }) ]
]

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> testEveryModelOnlyReasonNamesAnExistingClass [

	FamixOpenApiFieldMapping dataModelOnlyReasons do: [ :row |
		self
			assert: (Smalltalk globals includesKey: row first asSymbol)
			description: row first ]
]

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> testEveryOverrideNamesAnExistingClassAndSelector [

	FamixOpenApiFieldMapping allEntries
		reject: [ :each | each value isNotApplicable or: [ each value isNote ] ]
		thenDo: [ :each | self assertEntry: each value of: each key ]
]

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> testEverySpecObjectHasAnExistingOPClass [

	| names |
	names := OrderedCollection new.
	FamixOpenApiSpecFieldTable versions do: [ :version |
		names addAll: (FamixOpenApiSpecFieldTable objectNamesIn: version) ].
	names asSet do: [ :each |
		self
			assert: (FamixOpenApiFieldMapping classNameFor: each) isNotNil
			description: ('{1} has no OP class' format: { each }) ]
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testExplicitClassEntry [

	| entry |
	entry := FamixOpenApiFieldMapping entryFor:
		         (self fieldNamed: 'flow' in: 'SecurityScheme').
	self assert: entry targetClassName equals: 'OPOAuthFlow'
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testExtensionsEntryIsSharedByEveryObject [

	| entry |
	entry := FamixOpenApiFieldMapping entryFor:
		         (self fieldNamed: 'x-*' in: 'Info').
	self assert: entry isImplicit.
	self assert: entry selector equals: #extensions
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testFieldWithoutEntry [

	self assert: (FamixOpenApiFieldMapping entryFor:
			 (self fieldNamed: 'title' in: 'Info')) isNil
]

{ #category : 'tests' }
FamixOpenApiFieldMappingTest >> testKnownImporterGaps [
	| gaps |
	gaps := FamixOpenApiFieldMapping knownImporterGaps.
	self deny: gaps isEmpty.
	self assert: (gaps allSatisfy: [ :each | each isString and: [ each notEmpty ] ]).
	self assert: (gaps anySatisfy: [ :each | each includesSubstring: 'Header' ])
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testModelOnlyReasonUnknown [

	self assert: (FamixOpenApiFieldMapping modelOnlyReasonFor:
			 (introspector slotNamed: #title in: OPInfo)) isNil
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testModelOnlyReasonWithWildcard [

	| slot |
	slot := introspector slotNamed: #isRequired in: OPProperty.
	self assert:
		(FamixOpenApiFieldMapping modelOnlyReasonFor: slot) isNotNil
]

{ #category : 'tests' }
FamixOpenApiFieldMappingTest >> testNoteEntry [
	| entry |
	entry := FamixOpenApiFieldMapping entryFor:
		         (self fieldNamed: 'type' in: 'Header').
	self assert: entry isNote.
	self assert: entry mode equals: #note.
	self deny: entry isImplicit.
	self deny: entry isNotApplicable.
	self deny: entry hasExplicitClass.
	self assert: entry selector isEmpty.
	self assert: entry note isString.
	self deny: entry note isEmpty
]

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> testObjectClassNamesAreForObjectsOfTheTable [

	| names |
	names := Set new.
	FamixOpenApiSpecFieldTable versions do: [ :version |
		names addAll: (FamixOpenApiSpecFieldTable objectNamesIn: version) ].
	FamixOpenApiFieldMapping dataObjectClassNames do: [ :pair |
		self
			assert: (names includes: pair first)
			description: ('{1} is no spec object' format: { pair first }) ]
]

{ #category : 'tests - consistency' }
FamixOpenApiFieldMappingTest >> testObjectClassNamesExistInTheMetamodel [

	FamixOpenApiFieldMapping dataObjectClassNames do: [ :pair |
		self
			assert: (introspector hasClassNamed: pair last)
			description: ('{1} does not exist' format: { pair last }) ]
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testOverrideEntry [

	| entry |
	entry := FamixOpenApiFieldMapping entryFor:
		         (self fieldNamed: 'enum' in: 'Schema').
	self assert: entry selector equals: #enumValues.
	self assert: entry mode equals: #map.
	self assert: entry hasExplicitClass not
]

{ #category : 'tests - lookup' }
FamixOpenApiFieldMappingTest >> testUnknownObjectHasNoClass [

	self assert: (FamixOpenApiFieldMapping classNameFor: 'Nothing') isNil
]
