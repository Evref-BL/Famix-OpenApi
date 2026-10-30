"
Tests of FamixOpenApiPointerLookup: the index of the entities by canonical pointer, the families and the filters.
"
Class {
	#name : 'FamixOpenApiPointerLookupTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures' }
FamixOpenApiPointerLookupTest >> entity: aClass at: aPointer [

	^ aClass new
		  canonicalPointer: aPointer;
		  yourself
]

{ #category : 'fixtures' }
FamixOpenApiPointerLookupTest >> lookupOn: aCollection [

	^ FamixOpenApiPointerLookup onEntities: aCollection
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testEntitiesAtAnswersEveryEntityOfThePointer [

	| property schema lookup |
	property := self entity: OPProperty at: '#/a'.
	schema := self entity: OPSchema at: '#/a'.
	lookup := self lookupOn: {
			          property.
			          schema.
			          (self entity: OPInfo at: '#/b') }.
	self assert: (lookup entitiesAt: '#/a') asSet equals: {
			property.
			schema } asSet.
	self assert: (lookup entitiesAt: '#/b') size equals: 1
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testEntitiesInFamilyKeepsOnlyTheFamily [

	| property schema sub lookup |
	property := self entity: OPProperty at: '#/a'.
	schema := self entity: OPSchema at: '#/a'.
	sub := self entity: OPSubSchema at: '#/a'.
	lookup := self lookupOn: {
			          property.
			          schema.
			          sub }.
	self
		assert: (lookup entitiesAt: '#/a' inFamily: OPSchema) asSet
		equals: {
				schema.
				sub } asSet.
	self
		assert: (lookup entitiesAt: '#/a' inFamily: OPProperty)
		equals: { property }.
	self assert: (lookup entitiesAt: '#/a' inFamily: OPInfo) isEmpty
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testEntitiesOfClassIsExact [

	| schema sub lookup |
	schema := self entity: OPSchema at: '#/a'.
	sub := self entity: OPSubSchema at: '#/a'.
	lookup := self lookupOn: {
			          schema.
			          sub }.
	self
		assert: (lookup entitiesAt: '#/a' ofClass: OPSchema)
		equals: { schema }.
	self
		assert: (lookup entitiesAt: '#/a' ofClass: OPSubSchema)
		equals: { sub }
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testEntityInFamilyAnswersTheEntityOrNil [

	| schema lookup |
	schema := self entity: OPSchema at: '#/a'.
	lookup := self lookupOn: { schema }.
	self
		assert: (lookup entityAt: '#/a' inFamily: OPSchema)
		identicalTo: schema.
	self assert: (lookup entityAt: '#/a' inFamily: OPProperty) isNil.
	self assert: (lookup entityAt: '#/zzz' inFamily: OPSchema) isNil
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testOnModelIndexesTheEntitiesOfTheModel [

	| model info |
	model := OPModel new.
	info := self entity: OPInfo at: '#/info'.
	model add: info.
	self
		assert: ((FamixOpenApiPointerLookup onModel: model)
				 entityAt: '#/info'
				 inFamily: OPInfo)
		identicalTo: info
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testPointersListsTheIndexedPointersWithoutNil [

	| lookup stray |
	stray := OPInfo new.
	lookup := self lookupOn: {
			          (self entity: OPInfo at: '#/b').
			          (self entity: OPTag at: '#/c').
			          stray }.
	self assert: lookup pointers asSet equals: #( '#/b' '#/c' ) asSet.
	self assert: (lookup allEntities includes: stray).
	self assert: lookup allEntities size equals: 3
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testSubSchemaBelongsToTheFamilyOfSchema [

	self
		assert: (FamixOpenApiPointerLookup familyOf: OPSubSchema new)
		equals: OPSchema.
	self
		assert: (FamixOpenApiPointerLookup familyOf: OPSchema new)
		equals: OPSchema.
	self
		assert: (FamixOpenApiPointerLookup familyOf: OPProperty new)
		equals: OPProperty
]

{ #category : 'tests' }
FamixOpenApiPointerLookupTest >> testUnknownPointerHasNoEntity [

	| lookup |
	lookup := self lookupOn: { (self entity: OPInfo at: '#/b') }.
	self assert: (lookup entitiesAt: '#/zzz') isEmpty.
	self deny: (lookup includesPointer: '#/zzz').
	self assert: (lookup includesPointer: '#/b')
]
