Class {
	#name : #FamixOpenApiGeneratorInstantiationTest,
	#superclass : #TestCase,
	#category : 'FamixOpenApiGenerator-Test'
}

{ #category : 'private' }
FamixOpenApiGeneratorInstantiationTest >> generatedClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
		at: generatedClassName
		ifAbsent: [ self fail: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'running' }
FamixOpenApiGeneratorInstantiationTest >> setUp [
	super setUp.
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testCanInstantiateGeneratedEntities [
	| entityNames |
	entityNames := #(Api Path Operation Schema Property Response).
	entityNames do: [ :entityName |
		| generatedClass instance |
		generatedClass := self generatedClassNamed: entityName.
		instance := generatedClass new.
		self assert: instance class equals: generatedClass ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testUsesCurrentPrefixForGeneratedEntities [
	| generatedApiClassName generatedApiClass |
	generatedApiClassName := (FamixOpenApiGenerator prefix asString , 'Api') asSymbol.
	generatedApiClass := self generatedClassNamed: #Api.
	self assert: generatedApiClass name equals: generatedApiClassName
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testReferenceableEntitiesExposeRefAccessor [
	| referenceableEntities |
	referenceableEntities := #(Path Parameter Schema Response Header Example SecurityScheme).
	referenceableEntities do: [ :entityName |
		| generatedClass instance |
		generatedClass := self generatedClassNamed: entityName.
		instance := generatedClass new.
		self assert: (instance respondsTo: #ref).
		self assert: (instance respondsTo: #ref:).
		instance ref: '#/components/schemas/Pet'.
		self assert: instance ref equals: '#/components/schemas/Pet' ]
]
