Class {
	#name : 'FamixOpenApiGeneratorInstantiationTest',
	#superclass : 'TestCase',
	#category : 'FamixOpenApiGenerator-Test',
	#package : 'FamixOpenApiGenerator-Test'
}

{ #category : 'helpers' }
FamixOpenApiGeneratorInstantiationTest >> allGeneratedEntityNames [
	"Answer the names of all the entities of the metamodel, listed independently from the generator."

	^ #( OpenApi Info Contact License Server ServerVariable Tag
	     ExternalDocumentation Path Operation Parameter RequestBody Response
	     Header MediaType Encoding Example Link Callback Components Schema
	     Property Discriminator DiscriminatorMapping XmlElement SecurityScheme
	     OAuthFlow SecurityScope SecurityRequirement SecurityRequirementItem
	     Reference )
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
	entityNames := #(OpenApi Components Path Operation RequestBody MediaType Schema Property Response).
	entityNames do: [ :entityName |
		| generatedClass instance |
		generatedClass := self generatedClassNamed: entityName.
		instance := generatedClass new.
		self assert: instance class equals: generatedClass ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testGeneratorDefinesEveryExpectedEntity [
	self
		assert: (FamixOpenApiGenerator new entityDefinitions collect: #key) asSet
		equals: self allGeneratedEntityNames asSet
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testOldEntitiesAreNotGeneratedAnymore [
	#( Api ExternalDocs XMLElement ItemsDefinition ContainedCollections ResponseEntry SchemaEntry
	   RequiredSecurityScheme ) do: [ :entityName |
		self deny: (Smalltalk globals includesKey: (FamixOpenApiGenerator prefix asString , entityName asString) asSymbol) ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testPropertyEntityExposesIsRequiredAccessor [
	| generatedClass instance |
	generatedClass := self generatedClassNamed: #Property.
	instance := generatedClass new.
	self assert: (instance respondsTo: #isRequired).
	self assert: (instance respondsTo: #isRequired:).
	instance isRequired: true.
	self assert: instance isRequired
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
FamixOpenApiGeneratorInstantiationTest >> testUsesCurrentPrefixForGeneratedEntities [
	| generatedOpenApiClassName generatedOpenApiClass |
	generatedOpenApiClassName := (FamixOpenApiGenerator prefix asString , 'OpenApi') asSymbol.
	generatedOpenApiClass := self generatedClassNamed: #OpenApi.
	self assert: generatedOpenApiClass name equals: generatedOpenApiClassName
]
