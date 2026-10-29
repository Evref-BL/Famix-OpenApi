"
I check the conformance of the generated OpenAPI metamodel (Famix-OpenAPI-Model) to the specifications: for every field of FamixOpenApiSpecFieldTable (OpenAPI 3.0.3, 3.1.x and Swagger 2.0) I find out, with FamixOpenApiFieldMapping and FamixOpenApiMetamodelIntrospector, whether a slot or relation of the metamodel carries it. A selector counts as modelled only when the introspector finds it on the mapped OP class. I also run the reverse check: the slots and relations of the metamodel that correspond to no spec field.
Use FamixOpenApiMetamodelConformance check to get a FamixOpenApiConformanceReport. I never modify the field table, the mapping or the metamodel.
"
Class {
	#name : 'FamixOpenApiMetamodelConformance',
	#superclass : 'Object',
	#instVars : [
		'introspector'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'api' }
FamixOpenApiMetamodelConformance class >> check [
	"Answer the conformance report of the metamodel to the spec field table."

	^ self new check
]

{ #category : 'instance creation' }
FamixOpenApiMetamodelConformance class >> introspector: anIntrospector [
	"Answer a conformance check that reads the metamodel through anIntrospector."

	^ self new
		  introspector: anIntrospector;
		  yourself
]

{ #category : 'checking' }
FamixOpenApiMetamodelConformance >> check [

	| rows |
	rows := self conformanceRows.
	^ FamixOpenApiConformanceReport
		  rows: rows
		  modelOnlyRows: (self modelOnlyRowsGiven: rows)
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> complete: aRow of: aField class: aClassName [

	| entry |
	entry := FamixOpenApiFieldMapping entryFor: aField.
	entry ifNil: [
		^ self completeByDefault: aRow class: aClassName annotation: '' ].
	entry isNotApplicable ifTrue: [
		^ aRow
			  beStatus: #notApplicable
			  class: nil
			  selector: nil
			  note: entry note ].
	entry isNote ifTrue: [
		^ self
			  completeByDefault: aRow
			  class: aClassName
			  annotation: entry note ].
	^ self complete: aRow withEntry: entry class: aClassName
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> complete: aRow withEntry: anEntry class: aClassName [

	| className |
	className := anEntry targetClassName ifNil: [ aClassName ].
	^ anEntry isImplicit
		  ifTrue: [
			  self
				  completeImplicit: aRow
				  class: className
				  selector: anEntry selector
				  note: anEntry note ]
		  ifFalse: [
			  self
				  completeMapped: aRow
				  class: className
				  selector: anEntry selector
				  note: anEntry note ]
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> completeByDefault: aRow class: aClassName annotation: anAnnotation [
	"Compute the status from the default selector of the field. anAnnotation is appended to the note only when the metamodel has no such slot or relation; it is dropped when the row turns out modelled."

	| selector |
	selector := FamixOpenApiFieldMapping defaultSelectorFor:
		            aRow fieldName.
	selector ifNil: [
		^ self markNotModelled: aRow note: (self
				   reason: 'no explicit mapping and the field name is no accessor'
				   annotatedWith: anAnnotation) ].
	(self kindOf: selector inClassNamed: aClassName) ifNil: [
		^ self markNotModelled: aRow note: (self
				   reason: aClassName , ' has no ' , selector
				   annotatedWith: anAnnotation) ].
	^ self
		  completeMapped: aRow
		  class: aClassName
		  selector: selector
		  note: ''
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> completeImplicit: aRow class: aClassName selector: aSelector note: aString [

	(self kindOf: aSelector inClassNamed: aClassName) ifNil: [
		^ self
			  markNotModelled: aRow
			  note: aClassName , ' has no ' , aSelector ].
	^ aRow
		  beStatus: #implicit
		  class: aClassName
		  selector: aSelector
		  note: aString
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> completeMapped: aRow class: aClassName selector: aSelector note: aString [

	| kind |
	kind := self kindOf: aSelector inClassNamed: aClassName.
	kind ifNil: [
		^ self
			  markNotModelled: aRow
			  note: aClassName , ' has no ' , aSelector ].
	^ aRow
		  beStatus: (kind = #slot
				   ifTrue: [ #modelledSlot ]
				   ifFalse: [ #modelledRelation ])
		  class: aClassName
		  selector: aSelector
		  note: aString
]

{ #category : 'checking' }
FamixOpenApiMetamodelConformance >> conformanceRows [

	^ Array streamContents: [ :stream |
		  FamixOpenApiSpecFieldTable versions do: [ :version |
			  stream nextPutAll: (self rowsIn: version) ] ]
]

{ #category : 'reverse check' }
FamixOpenApiMetamodelConformance >> coveredKeysOf: someConformanceRows [

	^ (someConformanceRows
		   select: [ :each | each isModelled ]
		   thenCollect: [ :each | self slotKeyOf: each ]) asSet
]

{ #category : 'initialization' }
FamixOpenApiMetamodelConformance >> initialize [

	super initialize.
	introspector := FamixOpenApiMetamodelIntrospector new
]

{ #category : 'accessing' }
FamixOpenApiMetamodelConformance >> introspector: anIntrospector [
	"Injection point: the introspector that tells which slots and relations the metamodel has. The default reads the real metamodel; tests inject a stub."

	introspector := anIntrospector
]

{ #category : 'reverse check' }
FamixOpenApiMetamodelConformance >> inverseReasonFor: aSlot covered: someKeys [

	^ (aSlot hasOpposite and: [ someKeys includes: aSlot oppositeKey ])
		  ifTrue: [ 'inverse relation of ' , aSlot oppositeKey ]
		  ifFalse: [ nil ]
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> kindOf: aSelector inClassNamed: aClassName [
	"Answer #slot, #relation, or nil when the class does not exist or has no such slot or relation."

	^ (introspector hasClassNamed: aClassName)
		  ifTrue: [
			  introspector
				  kindOf: aSelector
				  in: (introspector classNamed: aClassName) ]
		  ifFalse: [ nil ]
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> markNotModelled: aRow note: aString [

	^ aRow
		  beStatus: #notModelled
		  class: nil
		  selector: nil
		  note: aString
]

{ #category : 'reverse check' }
FamixOpenApiMetamodelConformance >> modelOnlyRowsGiven: someConformanceRows [
	"Answer a row for every slot or relation of the metamodel that no conformance row targets."

	| covered |
	covered := self coveredKeysOf: someConformanceRows.
	^ self modelSlots
		  reject: [ :each | covered includes: each key ]
		  thenCollect: [ :each |
			  FamixOpenApiModelOnlyRow
				  slot: each
				  reason: (self reasonFor: each covered: covered) ]
]

{ #category : 'reverse check' }
FamixOpenApiMetamodelConformance >> modelSlots [
	"Answer every slot or relation of the metamodel once, even when it is inherited or provided by a trait, sorted by key."

	| unique |
	unique := Dictionary new.
	introspector modelClasses do: [ :each |
		(introspector slotsOf: each) do: [ :slot |
			unique at: slot key ifAbsentPut: [ slot ] ] ].
	^ unique values sorted: [ :a :b | a key <= b key ]
]

{ #category : 'resolving' }
FamixOpenApiMetamodelConformance >> reason: aString annotatedWith: anAnnotation [

	^ anAnnotation isEmpty
		  ifTrue: [ aString ]
		  ifFalse: [ aString , '; ' , anAnnotation ]
]

{ #category : 'reverse check' }
FamixOpenApiMetamodelConformance >> reasonFor: aSlot covered: someKeys [
	"Answer why aSlot is model-only, or nil when nothing explains it."

	^ (FamixOpenApiFieldMapping modelOnlyReasonFor: aSlot) ifNil: [
		  self inverseReasonFor: aSlot covered: someKeys ]
]

{ #category : 'checking' }
FamixOpenApiMetamodelConformance >> rowFor: aField in: aVersion [

	| row className |
	row := FamixOpenApiConformanceRow for: aField in: aVersion.
	className := FamixOpenApiFieldMapping classNameFor: aField specObject.
	(className isNotNil and: [ introspector hasClassNamed: className ])
		ifTrue: [ self complete: row of: aField class: className ]
		ifFalse: [ self markNotModelled: row note: 'no OP class' ].
	^ row
]

{ #category : 'checking' }
FamixOpenApiMetamodelConformance >> rowsIn: aVersion [

	^ (FamixOpenApiSpecFieldTable objectNamesIn: aVersion) flatCollect: [
		  :objectName |
		  (FamixOpenApiSpecFieldTable fieldsFor: objectName in: aVersion)
			  collect: [ :field | self rowFor: field in: aVersion ] ]
]

{ #category : 'reverse check' }
FamixOpenApiMetamodelConformance >> slotKeyOf: aConformanceRow [

	^ (introspector
		   slotNamed: aConformanceRow targetSelector
		   in: (introspector classNamed: aConformanceRow targetClassName))
		  key
]
