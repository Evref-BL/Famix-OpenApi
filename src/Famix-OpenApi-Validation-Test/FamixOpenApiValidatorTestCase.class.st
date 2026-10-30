"
Shared helpers of the model validator tests: a small hand-built and coherent OPModel, a snapshot of a whole model (entities, names, attributes and relations) used to prove that validation does not modify it, the validation of a model with one rule class, and temporary rule subclasses (registered for the test only and removed in tearDown).
"
Class {
	#name : 'FamixOpenApiValidatorTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'temporaryRules'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> addAllEntitiesOf: anOpenApi to: aModel [
	"Add to aModel the entities built by #coherentModel: they are collected through the relations of the root."

	| components path operation |
	components := anOpenApi components.
	path := anOpenApi paths anyOne.
	operation := path operations anyOne.
	aModel addAll: {
			anOpenApi.
			anOpenApi info.
			anOpenApi info contact.
			components.
			path.
			operation }.
	aModel addAll: components schemas.
	aModel addAll: components parameters.
	aModel addAll: operation responses
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> addSharedParameterTo: aComponents operation: anOperation [

	| parameter |
	parameter := OPParameter new
		             name: 'limit';
		             yourself.
	aComponents addParameter: parameter.
	anOperation addParameter: parameter
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> assignPointersIn: aModel [
	"Give every entity of aModel a distinct canonical pointer (an imported model has them, a hand-built one has none)."

	aModel allModelEntities doWithIndex: [ :each :index |
		each canonicalPointer: '#/entity/' , index printString ]
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> codesOf: aFindings [
	"Answer the sorted codes of aFindings, with repetitions."

	^ (aFindings collect: #code) asArray sorted
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> coherentModel [
	"Answer a small coherent OPModel: root, info with a contact, a schema in the components, a path with an operation and its response, a shared parameter. Every entity has a distinct canonical pointer."

	| model openApi components path operation |
	model := OPModel new.
	openApi := OPOpenApi new
		           name: 'API';
		           yourself.
	components := OPComponents new
		              name: 'components';
		              yourself.
	openApi components: components.
	components addSchema: (OPSchema new
			 name: 'Pet';
			 yourself).
	openApi info: (OPInfo new
			 name: 'info';
			 yourself).
	openApi info contact: OPContact new.
	path := OPPath new
		        name: '/pets';
		        yourself.
	openApi addPath: path.
	operation := OPOperation new
		             name: 'listPets';
		             yourself.
	path addOperation: operation.
	operation addResponse: (OPResponse new
			 name: '200';
			 yourself).
	self addSharedParameterTo: components operation: operation.
	self addAllEntitiesOf: openApi to: model.
	self assignPointersIn: model.
	^ model
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> componentSchemaNamed: aString in: aModel [
	"Answer the schema named aString that is an entry of the components of aModel."

	^ (aModel allWithType: OPSchema) detect: [ :each |
		  each name = aString and: [ each components isNotNil ] ]
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> detachPetPathFrom: aModel [
	"Detach the path /pets/{petId} of #richDocument, with its operations, from the root of aModel. Answer the path."

	| path |
	path := (aModel allWithType: OPPath) detect: [ :each |
		        each name = '/pets/{petId}' ].
	(self rootOf: aModel) paths remove: path.
	^ path
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> entityOf: aClass in: aModel [
	"Answer the first entity of aModel that is a aClass."

	^ (aModel allWithType: aClass) anyOne
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> identitiesOf: aValue [

	aValue ifNil: [ ^ #(  ) ].
	^ (aValue isCollection
		   ifTrue: [ aValue asArray ]
		   ifFalse: [ { aValue } ]) collect: [ :each | each identityHash ]
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> importedModel [
	"Answer the OPModel of #richDocument imported with the inline schemas merged."

	^ self importedModelMerging: true
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> importedModelMerging: aBoolean [
	"Answer the OPModel the importer builds from #richDocument."

	^ FamixOpenApiImporter new
		  mergesInlineSchemas: aBoolean;
		  importFromString: self richDocument
]

{ #category : 'temporary rules' }
FamixOpenApiValidatorTestCase >> installTemporaryRuleNamed: aName source: aSource [
	"Create a concrete rule subclass named aName, whose method is aSource, registered until tearDown."

	| class |
	class := (FamixOpenApiValidationRule << aName)
		         package: 'Famix-OpenApi-Validation-Test';
		         install.
	class compile: aSource classified: 'checking'.
	temporaryRules add: class.
	^ class
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> richDocument [
	"A small OpenAPI 3.1 document that exercises the importer: shared and missing parameter references, a component response reference, an allOf (a sub-schema when the inline schemas are merged), a schema designated by a $ref, a 3.1 alias and a dangling alias (a $ref next to keywords), a property whose $ref is missing and an inline schema merged into a component."

	^ '{"openapi":"3.1.0","info":{"title":"Petstore","version":"1.0"},"servers":[{"url":"https://pets.example.com"}],"paths":{"/pets":{"get":{"operationId":"listPets","parameters":[{"$ref":"#/components/parameters/Limit"},{"$ref":"#/components/parameters/Missing"}],"responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/Pet"}}}}}}},"post":{"operationId":"addPet","requestBody":{"content":{"application/json":{"schema":{"$ref":"#/components/schemas/NewPet"}}}},"responses":{"201":{"description":"created","content":{"application/json":{"schema":{"type":"object","properties":{"id":{"type":"integer"},"name":{"type":"string"}}}}}}}}},"/pets/{petId}":{"get":{"operationId":"showPet","parameters":[{"name":"petId","in":"path","required":true,"schema":{"type":"string"}}],"responses":{"200":{"description":"ok","content":{"application/json":{"schema":{"$ref":"#/components/schemas/Pet"}}}},"404":{"$ref":"#/components/responses/NotFound"}}}}},"components":{"parameters":{"Limit":{"name":"limit","in":"query","schema":{"type":"integer"}}},"responses":{"NotFound":{"description":"nf"}},"schemas":{"Pet":{"type":"object","required":["id"],"properties":{"id":{"type":"integer"},"name":{"type":"string"},"tag":{"type":"string"},"owner":{"$ref":"#/components/schemas/Nobody"}}},"NewPet":{"allOf":[{"$ref":"#/components/schemas/Pet"},{"type":"object","properties":{"extra":{"type":"string"}}}]},"Alias":{"$ref":"#/components/schemas/Pet","description":"alias"},"Dangling":{"$ref":"#/components/schemas/Nope","description":"dangling"}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> rootOf: aModel [

	^ (aModel allWithType: OPOpenApi) anyOne
]

{ #category : 'running' }
FamixOpenApiValidatorTestCase >> setUp [

	super setUp.
	temporaryRules := OrderedCollection new
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> snapshotOf: aModel [
	"Answer an Array describing every entity of aModel: its class, its name and all its non-derived properties (relations by identity)."

	^ (aModel allModelEntities collect: [ :each |
		   self snapshotOfEntity: each ]) asArray sorted: [ :a :b |
		  a first <= b first ]
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> snapshotOf: aProperty in: anEntity [

	| value |
	value := anEntity mmGetProperty: aProperty.
	^ aProperty type isPrimitive
		  ifTrue: [ aProperty name -> value printString ]
		  ifFalse: [ aProperty name -> (self identitiesOf: value) ]
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> snapshotOfEntity: anEntity [

	^ {
		  anEntity identityHash.
		  anEntity class name.
		  anEntity name.
		  (anEntity mooseDescription allProperties
			   reject: [ :each | each isDerived ]
			   thenCollect: [ :each | self snapshotOf: each in: anEntity ])
			  asArray }
]

{ #category : 'running' }
FamixOpenApiValidatorTestCase >> tearDown [

	temporaryRules do: [ :each | each removeFromSystem ].
	super tearDown
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> validate: aModel with: aRuleClass [
	"Answer the findings of the single rule class aRuleClass on aModel."

	^ FamixOpenApiModelValidator new
		  validate: aModel
		  rules: { aRuleClass }
]

{ #category : 'fixtures' }
FamixOpenApiValidatorTestCase >> writeSlot: aName of: anEntity value: aValue [
	"Write the slot aName of anEntity as a raw instance variable: the Fame opposite relation is NOT updated, which breaks the coherence of the model on purpose."

	anEntity
		instVarAt: (anEntity class instVarIndexFor: aName)
		put: aValue
]
