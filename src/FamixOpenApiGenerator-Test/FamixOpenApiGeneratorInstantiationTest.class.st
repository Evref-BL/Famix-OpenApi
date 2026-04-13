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
	generatedApiClassName := (FamixOpenApiGenerator prefix asString , 'API') asSymbol.
	generatedApiClass := self generatedClassNamed: #Api.
	self assert: generatedApiClass name equals: generatedApiClassName
]
