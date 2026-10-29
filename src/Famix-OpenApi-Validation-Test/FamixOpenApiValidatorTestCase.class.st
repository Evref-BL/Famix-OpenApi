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
FamixOpenApiValidatorTestCase >> coherentModel [
	"Answer a small coherent OPModel: root, info with a contact, a schema in the components, a path with an operation and its response, a shared parameter."

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
	^ model
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
