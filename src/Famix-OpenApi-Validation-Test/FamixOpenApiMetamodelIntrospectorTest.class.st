"
I test FamixOpenApiMetamodelIntrospector against known facts of the generated OpenAPI metamodel: classes, scalar slots, relations, trait-provided slots, relation targets and multiplicity, and the absence of side effects.
"
Class {
	#name : 'FamixOpenApiMetamodelIntrospectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'introspector'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'running' }
FamixOpenApiMetamodelIntrospectorTest >> setUp [

	super setUp.
	introspector := FamixOpenApiMetamodelIntrospector new
]

{ #category : 'tests - classes' }
FamixOpenApiMetamodelIntrospectorTest >> testClassNamed [

	self assert: (introspector classNamed: 'OPInfo') equals: OPInfo.
	self assert: (introspector hasClassNamed: 'OPInfo')
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testDeclaringClassOfTraitSlots [

	self
		assert: (introspector slotNamed: #canonicalPointer in: OPInfo)
				declaringClassName
		equals: #OPCanonicalNode.
	self
		assert:
		(introspector slotNamed: #title in: OPInfo) declaringClassName
		equals: #OPInfo
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testDerivedMooseSlotsAreLeftOut [

	self deny: (introspector isModelled: #isDead in: OPInfo).
	self deny: (introspector isModelled: #numberOfTags in: OPInfo)
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testInfoHasTitleAndContact [

	self assert:
		((introspector propertyNamesOf: OPInfo) includes: #title).
	self assert:
		((introspector relationNamesOf: OPInfo) includes: #contact).
	self deny:
		((introspector propertyNamesOf: OPInfo) includes: #contact)
]

{ #category : 'tests - purity' }
FamixOpenApiMetamodelIntrospectorTest >> testIntrospectionHasNoSideEffect [

	| before after |
	before := OPModel metamodel classes size.
	introspector modelClasses do: [ :each | introspector slotsOf: each ].
	after := OPModel metamodel classes size.
	self assert: after equals: before.
	self
		assert: (introspector slotsOf: OPSchema) size
		equals: (introspector slotsOf: OPSchema) size
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testIsModelled [

	self assert: (introspector isModelled: #title in: OPInfo).
	self deny: (introspector isModelled: #nothing in: OPInfo)
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testKindOf [

	self assert: (introspector kindOf: #title in: OPInfo) equals: #slot.
	self
		assert: (introspector kindOf: #contact in: OPInfo)
		equals: #relation.
	self assert: (introspector kindOf: #nothing in: OPInfo) isNil
]

{ #category : 'tests - classes' }
FamixOpenApiMetamodelIntrospectorTest >> testModelClassesContainTheEntities [

	| classes |
	classes := introspector modelClasses.
	#( #OPInfo #OPSchema #OPParameter #OPSubSchema #OPSecurityScheme )
		do: [ :each |
			self assert: (classes anySatisfy: [ :class | class name = each ]) ]
]

{ #category : 'tests - classes' }
FamixOpenApiMetamodelIntrospectorTest >> testModelClassesLeaveOutEntityAndModel [

	self deny: (introspector modelClasses includes: OPEntity).
	self deny: (introspector modelClasses includes: OPModel)
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testRelationTargetAndMultiplicity [

	| items allOf |
	items := introspector slotNamed: #items in: OPSchema.
	allOf := introspector slotNamed: #allOf in: OPSchema.
	self assert: items targetName equals: #OPSchema.
	self deny: items isMany.
	self assert: allOf isMany.
	self assert: items oppositeName equals: #usedAsItemsBy
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testSchemaHasItemsAllOfAndDiscriminator [

	#( #items #allOf #discriminator ) do: [ :each |
		self assert:
			((introspector relationNamesOf: OPSchema) includes: each) ]
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testSubSchemaInheritsTheSlotsOfSchema [

	self assert: (introspector isModelled: #items in: OPSubSchema).
	self assert: (introspector isModelled: #subSchemaOf in: OPSubSchema)
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testTraitRelationsAreFound [

	self assert:
		((introspector relationNamesOf: OPSchema) includes: #externalDocs).
	self assert:
		((introspector relationNamesOf: OPParameter) includes: #content)
]

{ #category : 'tests - slots' }
FamixOpenApiMetamodelIntrospectorTest >> testTraitSlotsAreFound [

	self assert:
		((introspector propertyNamesOf: OPInfo) includes: #canonicalPointer).
	self assert:
		((introspector propertyNamesOf: OPSchema) includes: #ref).
	self assert:
		((introspector propertyNamesOf: OPParameter) includes: #extensions).
	self assert:
		((introspector propertyNamesOf: OPSchema) includes: #name)
]

{ #category : 'tests - classes' }
FamixOpenApiMetamodelIntrospectorTest >> testUnknownClassNamed [

	self deny: (introspector hasClassNamed: 'OPNothing').
	self assert: (introspector classNamed: 'OPNothing') isNil
]
