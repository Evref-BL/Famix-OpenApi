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
	     SubSchema Property Discriminator DiscriminatorMapping XmlElement SecurityScheme
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
	entityNames := #(OpenApi Components Path Operation RequestBody MediaType Schema SubSchema Property Response).
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
FamixOpenApiGeneratorInstantiationTest >> testSharedReferencesHaveManyToManyUsageRelationsAndNoSingleOwner [

	#( #( Response headers Header usedByResponses )
	   #( Encoding headers Header usedByEncodings )
	   #( Response links Link usedByResponses )
	   #( Parameter examples Example usedByParameters )
	   #( MediaType examples Example usedByMediaTypes )
	   #( Operation callbacks Callback usedByOperations )
	   #( Callback pathItems Path usedByCallbacks ) ) do: [ :row |
		| owner target |
		owner := self generatedClassNamed: row first.
		target := self generatedClassNamed: row third.
		self assert: (owner canUnderstand: row second).
		self assert: (target canUnderstand: row fourth).
		self assert: (owner new perform: row second) isEmpty.
		self assert: (target new perform: row fourth) isEmpty ].
	#( #( Header response ) #( Header encoding ) #( Link response )
	   #( Example parameter ) #( Example mediaType )
	   #( Callback operation ) #( Path callback ) ) do: [ :row |
		self deny:
			((self generatedClassNamed: row first) includesSelector: row second) ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testSharedReferencesStayContainedByTheComponents [
	#( #( Header headers addHeader: ) #( Link links addLink: ) #( Example examples addExample: )
	   #( Callback callbacks addCallback: ) #( Path pathItems addPathItem: ) ) do: [ :row |
		| entity components |
		entity := (self generatedClassNamed: row first) new.
		components := (self generatedClassNamed: #Components) new.
		components perform: row third with: entity.
		self assert: entity components equals: components.
		self assert: (components perform: row second) asArray equals: { entity } ]
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testSubSchemaIsASubclassOfSchemaAndKeepsItsSlotsAndTraits [

	| subSchema |
	subSchema := self generatedClassNamed: #SubSchema.
	self
		assert: subSchema superclass
		equals: (self generatedClassNamed: #Schema).
	self
		assert: (subSchema slots collect: #name) asArray
		equals: #( subSchemaOf ).
	self assert:
		(subSchema inheritsFrom: (self generatedClassNamed: #Schema)).
	self assert: (subSchema canUnderstand: #mergedPointers).
	self assert: (subSchema canUnderstand: #canonicalPointer).
	self assert: subSchema comment isNotEmpty
]

{ #category : 'tests' }
FamixOpenApiGeneratorInstantiationTest >> testUsesCurrentPrefixForGeneratedEntities [
	| generatedOpenApiClassName generatedOpenApiClass |
	generatedOpenApiClassName := (FamixOpenApiGenerator prefix asString , 'OpenApi') asSymbol.
	generatedOpenApiClass := self generatedClassNamed: #OpenApi.
	self assert: generatedOpenApiClass name equals: generatedOpenApiClassName
]
