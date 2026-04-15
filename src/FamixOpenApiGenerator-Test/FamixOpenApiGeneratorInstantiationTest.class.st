Class {
	#name : 'FamixOpenApiGeneratorInstantiationTest',
	#superclass : 'TestCase',
	#category : 'FamixOpenApiGenerator-Test',
	#package : 'FamixOpenApiGenerator-Test'
}

{ #category : 'private' }
FamixOpenApiGeneratorInstantiationTest >> allGeneratedEntityNames [
	^ #(
		ContainedCollections Api Components Info Contact License Path Operation
		ExternalDocs Parameter ItemsDefinition Schema Response Header Tag
		SecurityScheme Example RequestBody MediaType Link Callback XMLElement
		SecurityScope SecurityRequirement Property ResponseEntry SchemaEntry
		ResponseDefinitionEntry ParameterEntry SecuritySchemeEntry MediaTypeEntry
		RequestBodyEntry HeaderEntry ExampleEntry LinkEntry CallbackEntry
		RequiredSecurityScheme)
]

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
FamixOpenApiGeneratorInstantiationTest >> testAllEntitiesExposeSourceTextAccessor [
	self allGeneratedEntityNames do: [ :entityName |
		| generatedClass instance |
		generatedClass := self generatedClassNamed: entityName.
		instance := generatedClass new.
		self assert: (instance respondsTo: #sourceText).
		self assert: (instance respondsTo: #sourceText:).
		instance sourceText: '{"node":true}'.
		self assert: instance sourceText equals: '{"node":true}' ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testCanInstantiateGeneratedEntities [
	| entityNames |
	entityNames := #(Api Components Path Operation RequestBody MediaType Schema Property Response).
	entityNames do: [ :entityName |
		| generatedClass instance |
		generatedClass := self generatedClassNamed: entityName.
		instance := generatedClass new.
		self assert: instance class equals: generatedClass ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testReferenceableEntitiesExposeRefAccessor [
	| referenceableEntities |
	referenceableEntities := #(Path Parameter Schema Response Header Example SecurityScheme RequestBody Link Callback).
	referenceableEntities do: [ :entityName |
		| generatedClass instance |
		generatedClass := self generatedClassNamed: entityName.
		instance := generatedClass new.
		self assert: (instance respondsTo: #ref).
		self assert: (instance respondsTo: #ref:).
				instance ref: '#/components/schemas/Pet'.
				self assert: instance ref equals: '#/components/schemas/Pet' ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testPropertyEntityExposesEnumAccessor [
	| generatedClass instance |
	generatedClass := self generatedClassNamed: #Property.
	instance := generatedClass new.
	self assert: (instance respondsTo: #enum).
	self assert: (instance respondsTo: #enum:).
	instance enum: #('cat' 'dog').
	self assert: instance enum asArray equals: #('cat' 'dog')
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testPropertyEntityExposesValueSchemaAccessor [
	| generatedClass instance schemaClass schemaInstance |
	generatedClass := self generatedClassNamed: #Property.
	schemaClass := self generatedClassNamed: #Schema.
	instance := generatedClass new.
	schemaInstance := schemaClass new.
	self assert: (instance respondsTo: #valueSchema).
	self assert: (instance respondsTo: #valueSchema:).
	instance valueSchema: schemaInstance.
	self assert: instance valueSchema == schemaInstance
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testUsesCurrentPrefixForGeneratedEntities [
	| generatedApiClassName generatedApiClass |
	generatedApiClassName := (FamixOpenApiGenerator prefix asString , 'Api') asSymbol.
	generatedApiClass := self generatedClassNamed: #Api.
	self assert: generatedApiClass name equals: generatedApiClassName
]
