"
I answer questions about the generated OpenAPI metamodel (package Famix-OpenAPI-Model): which entity classes exist, which slots (scalar properties) and relations each class has, including those provided by traits, and the target and multiplicity of a relation.
I read the Fame meta-description of OPModel (OPModel metamodel, a set of FM3 classes and properties) rather than the pragmas or comments of the accessors: it is the runtime source of truth of the metamodel, it already folds in trait-provided and inherited properties, and it knows the relation targets, multiplicities and opposites, while the accessor comments are only free text. Derived properties of Moose entities (tags, isDead...) are ignored.
I have no side effect and I never mutate the metamodel. Classes are answered as Smalltalk classes; slots as FamixOpenApiModelSlot.
"
Class {
	#name : 'FamixOpenApiMetamodelIntrospector',
	#superclass : 'Object',
	#instVars : [
		'metamodel'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'classes' }
FamixOpenApiMetamodelIntrospector >> classNamed: aString [
	"Answer the entity class named aString, or nil when the metamodel has none. Ask hasClassNamed: first."

	^ self modelClasses
		  detect: [ :each | each name = aString asSymbol ]
		  ifNone: [ nil ]
]

{ #category : 'classes' }
FamixOpenApiMetamodelIntrospector >> hasClassNamed: aString [

	^ self modelClasses anySatisfy: [ :each |
		  each name = aString asSymbol ]
]

{ #category : 'initialization' }
FamixOpenApiMetamodelIntrospector >> initialize [

	super initialize.
	metamodel := OPModel metamodel
]

{ #category : 'classes' }
FamixOpenApiMetamodelIntrospector >> isModelClass: anFm3Class [

	| implementing |
	implementing := anFm3Class implementingClass.
	^ implementing isNotNil and: [
		  implementing ~~ OPEntity and: [
			  implementing inheritsFrom: OPEntity ] ]
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> isModelled: aSelector in: aClass [
	"True when aClass has a slot or a relation named aSelector."

	^ (self slotNamed: aSelector in: aClass) isNotNil
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> keyOf: anFm3Property [

	^ anFm3Property mmClass implementingClass name , '>>'
	  , anFm3Property name
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> kindOf: aSelector in: aClass [
	"Answer #slot, #relation, or nil when aClass has no such slot or relation."

	^ (self slotNamed: aSelector in: aClass) ifNotNil: [ :each |
		  each kind ]
]

{ #category : 'classes' }
FamixOpenApiMetamodelIntrospector >> modelClasses [
	"Answer the entity classes of the metamodel (OPInfo, OPSchema...), sorted by name. OPEntity and OPModel are not entities of an API and are left out."

	^ (metamodel classes
		   select: [ :each | self isModelClass: each ]
		   thenCollect: [ :each | each implementingClass ]) sorted: [ :a :b |
		  a name <= b name ]
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> propertyNamesOf: aClass [
	"Answer the selectors of the scalar slots of aClass, trait-provided ones included."

	^ (self slotsOf: aClass)
		  select: [ :each | each isSlot ]
		  thenCollect: [ :each | each selector ]
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> relationNamesOf: aClass [
	"Answer the selectors of the relations of aClass, trait-provided ones included."

	^ (self slotsOf: aClass)
		  select: [ :each | each isRelation ]
		  thenCollect: [ :each | each selector ]
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> slotFor: anFm3Property [

	^ FamixOpenApiModelSlot new
		  declaringClassName: anFm3Property mmClass implementingClass name;
		  selector: anFm3Property name asSymbol;
		  kind: (anFm3Property type isPrimitive
				   ifTrue: [ #slot ]
				   ifFalse: [ #relation ]);
		  targetName: (self targetNameOf: anFm3Property type);
		  oppositeName: (anFm3Property opposite ifNotNil: [ :opposite |
					   opposite name asSymbol ]);
		  oppositeKey:
			  (anFm3Property opposite ifNotNil: [ :opposite |
					   self keyOf: opposite ]);
		  isMany: anFm3Property isMultivalued;
		  yourself
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> slotNamed: aSelector in: aClass [
	"Answer the slot or relation of aClass named aSelector, or nil when aClass has none."

	^ (self slotsOf: aClass)
		  detect: [ :each | each selector = aSelector asSymbol ]
		  ifNone: [ nil ]
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> slotsOf: aClass [
	"Answer the slots and relations of aClass, sorted by selector, including the ones inherited or provided by traits. Derived properties are left out."

	^ ((metamodel fmTypeOf: aClass) allProperties
		   reject: [ :each | each isDerived ]
		   thenCollect: [ :each | self slotFor: each ]) sorted: [ :a :b |
		  a selector <= b selector ]
]

{ #category : 'slots' }
FamixOpenApiMetamodelIntrospector >> targetNameOf: anFm3Type [

	^ anFm3Type isPrimitive
		  ifTrue: [ anFm3Type name ]
		  ifFalse: [ anFm3Type implementingClass name ]
]
