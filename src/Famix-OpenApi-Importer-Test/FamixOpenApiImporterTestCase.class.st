"
Abstract superclass of the importer tests: it provides the JSON document builders and the navigation helpers of the final model (OPOpenApi root, components holding their entities directly) shared by the importer test classes.
"
Class {
	#name : 'FamixOpenApiImporterTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'importer'
	],
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'testing' }
FamixOpenApiImporterTestCase class >> isAbstract [
	^ self == FamixOpenApiImporterTestCase
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> assert: anActualValue equals: anExpectedValue description: aString [

	self
		assert: anActualValue = anExpectedValue
		description:
			aString , ' (expected ' , anExpectedValue printString , ', got '
			, anActualValue printString , ')'
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> assertEntityHasNonEmptyName: anEntity [

	self assert: anEntity name notNil.
	self assert: anEntity name asString isEmpty not
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> assertEntityHasNonEmptySourceText: anEntity [

	self assert: anEntity sourceText notNil.
	self assert: anEntity sourceText asString isEmpty not
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> assertExactlyOneSchemaNamed: aName in: aModel [

	self
		assert: (self schemasNamed: aName in: aModel) size = 1
		description: 'Exactly one schema entity should be named ' , aName
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> assertNoStubSchemasIn: aModel [

	self
		assert: (self stubSchemasIn: aModel) isEmpty
		description:
		'A schema entity holding only a $ref (no content) remains in the model'
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> componentIn: aCollection pointer: aPointer [
	"Answer the reusable entity of aCollection (a section of the components) whose canonicalPointer is aPointer."

	^ aCollection
		  detect: [ :each | each canonicalPointer = aPointer ]
		  ifNone: [ self fail: 'No component at ' , aPointer printString ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> componentSchemaNamed: aKey in: aModel [

	^ (self componentsIn: aModel) schemas
		  detect: [ :each | each name = aKey ]
		  ifNone: [
		  self fail: 'No component schema named ' , aKey printString ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> componentsIn: aModel [

	^ (self entitiesNamed: #Components in: aModel) anyOne
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> entitiesNamed: anEntityName in: aModel [
	"Answer the entities of the generated class anEntityName, subclasses included (a SubSchema is a Schema)."

	^ aModel allWithSubTypesOf: (self generatedClassNamed: anEntityName)
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> generatedClassNamed: anEntityName [

	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString
	                       , anEntityName asString) asSymbol.
	^ Smalltalk globals at: generatedClassName ifAbsent: [
		  self fail:
			  'Missing generated class: ' , generatedClassName asString ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> importJson: aJsonString [
	"Import aJsonString with a fresh importer (kept in #importer) and answer the model."

	importer := FamixOpenApiImporter new.
	^ importer importFromString: aJsonString
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> importJson: aJsonString using: anImporter [
	"Import aJsonString with anImporter, configured by the test, and answer the model."

	importer := anImporter.
	^ importer importFromString: aJsonString
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> importOpenApi31: aMembersString [

	^ self importJson: (self openApi31Json: aMembersString)
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> importOpenApi3: aMembersString [

	^ self importJson: (self openApi3Json: aMembersString)
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> importSwagger2: aMembersString [

	^ self importJson: (self swagger2Json: aMembersString)
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> importer [

	^ importer
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> jsonFrom: aTemplate [
	"Answer aTemplate where every backtick stands for a JSON double quote (keeps the fixtures readable)."

	^ aTemplate copyReplaceAll: '`' with: '"'
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> mediaTypeNamed: aMediaType of: aContentOwner [

	^ aContentOwner content
		  detect: [ :each | each mediaType = aMediaType ]
		  ifNone: [ self fail: 'No media type ' , aMediaType printString ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> openApi31Json: aMembersString [

	^ self jsonFrom:
		  '{`openapi`:`3.1.0`,`info`:{`title`:`t`,`version`:`1`},'
		  , aMembersString , '}'
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> openApi3Json: aMembersString [

	^ self jsonFrom:
		  '{`openapi`:`3.0.0`,`info`:{`title`:`t`,`version`:`1`},'
		  , aMembersString , '}'
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> openApiIn: aModel [

	^ (self entitiesNamed: #OpenApi in: aModel) anyOne
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> operationWithId: anOperationId in: aModel [

	^ (self entitiesNamed: #Operation in: aModel)
		  detect: [ :each | each operationId = anOperationId ]
		  ifNone: [ self fail: 'No operation with id ' , anOperationId ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> parsedJson: aJsonText [
	"Answer the Smalltalk value of aJsonText, a JSON text stored by the importer (enumValues, defaultValue, extensions...)."

	aJsonText ifNil: [ self fail: 'JSON text expected, got nil' ].
	^ NeoJSONReader fromString: aJsonText
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> propertyNamed: aPropertyName ofSchema: aSchema [

	^ aSchema properties
		  detect: [ :each | each name = aPropertyName ]
		  ifNone: [ self fail: 'No property named ' , aPropertyName ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> responseOf: anOperation code: aStatusCode [

	^ anOperation responses
		  detect: [ :each | each statusCode = aStatusCode ]
		  ifNone: [
			  self fail:
				  'No response with status code ' , aStatusCode printString ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> schemasIn: aModel [

	^ self entitiesNamed: #Schema in: aModel
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> schemasJson: aSchemasString [

	^ '`paths`:{},`components`:{`schemas`:{' , aSchemasString , '}}'
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> schemasNamed: aName in: aModel [
	"Answer the component schemas (declared under components) named aName. Inline schemas are ignored."

	^ (self schemasIn: aModel) select: [ :each |
		  each components isNotNil and: [ each name = aName ] ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> stubSchemasIn: aModel [
	"A stub is a schema carrying a reference but no content at all."

	^ (self schemasIn: aModel) select: [ :each |
		  each ref isNotNil and: [
			  each types isEmpty and: [
				  each properties isEmpty and: [
					  each items isNil and: [ each allOf isEmpty ] ] ] ] ]
]

{ #category : 'helpers' }
FamixOpenApiImporterTestCase >> swagger2Json: aMembersString [

	^ self jsonFrom:
		  '{`swagger`:`2.0`,`info`:{`title`:`t`,`version`:`1`},'
		  , aMembersString , '}'
]
