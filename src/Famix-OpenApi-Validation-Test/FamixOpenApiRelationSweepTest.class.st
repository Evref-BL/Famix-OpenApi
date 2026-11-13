"
The mutation sweeps of the relation check (V10): on the real model of each small document, EVERY relation that the check compares is changed in turn (a target taken out, a stray one added, a relation of one emptied) and, when it holds several targets of an ordered relation, reordered; each change must be reported once, with the field and the node of the relation.
"
Class {
	#name : 'FamixOpenApiRelationSweepTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiRelationSweepTest >> defaultTimeLimit [

	^ 2 minutes
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheReferencesDocument30IsDetectedWhenItIsChanged [

	self assert:
		(self assertRelationSweepIn: self documentRefs30 named: 'refs30')
		> 30
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheSecurityDocument31IsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentSecurity31
			 named: 'security31') > 90
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheSharedKindsDocument30IsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentSharedKinds30
			 named: 'shared30') > 20
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheSharedKindsDocument31IsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentSharedKinds31
			 named: 'shared31') > 20
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheStructureDocument30IsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentStructure30
			 named: 'structure30') > 150
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheStructureDocument31IsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentStructure31
			 named: 'structure31') > 150
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheSwagger2DocumentIsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentStructureSwagger2
			 named: 'swagger2') > 120
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheSwagger2ParametersDocumentIsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentParametersSwagger2
			 named: 'parametersSwagger2') > 30
]

{ #category : 'tests' }
FamixOpenApiRelationSweepTest >> testEveryRelationOfTheUnresolvedDocument30IsDetectedWhenItIsChanged [

	self assert: (self
			 assertRelationSweepIn: self documentUnresolved30
			 named: 'unresolved30') > 80
]
