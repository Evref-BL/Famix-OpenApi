"
Tests of the names given at import time to the inline schemas (structural names), to the SubSchemas ('part of <parent>') and to the Discriminators, with and without merging: one behaviour per test.
"
Class {
	#name : 'FamixOpenApiInlineNamingTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> discriminatorJson: aSchemasString [

	^ self openApi3Json: (self schemasJson: aSchemasString)
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> discriminatorNamesOf: aModel [

	^ (self entitiesNamed: #Discriminator in: aModel) collect: [ :each |
		  each name ]
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> importWithMerging: aBoolean json: aJsonString [

	^ self importJson: aJsonString using: (FamixOpenApiImporter new
			   mergesInlineSchemas: aBoolean;
			   yourself)
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> inlineNamesOf: aModel [

	^ (self inlineSchemasOf: aModel) collect: [ :each | each name ]
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> inlineSchemasOf: aModel [
	"Answer the schemas, SubSchemas included, that are not owned by components."

	^ (self schemasIn: aModel) select: [ :each | each components isNil ]
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> petstoreOpenApi3Json [

	^ self openApi3Json:
		  '`paths`:{`/pets`:{`get`:{`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Pet`}}}}}}}}},`components`:{`schemas`:{`Pet`:{`type`:`object`,`properties`:{`name`:{`type`:`string`},`tags`:{`type`:`array`,`items`:{`type`:`string`}}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> petstoreSwagger2Json [

	^ self swagger2Json:
		  '`paths`:{`/pets`:{`get`:{`responses`:{`200`:{`description`:`ok`,`schema`:{`type`:`array`,`items`:{`$ref`:`#/definitions/Pet`}}}}}}},`definitions`:{`Pet`:{`type`:`object`,`properties`:{`photoUrls`:{`type`:`array`,`items`:{`type`:`string`}},`status`:{`type`:`string`,`enum`:[`available`,`sold`]},`id`:{`type`:`integer`,`format`:`int64`}}}}'
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> pointersOfInlineSchemasIn: aModel [
	"Answer the pointers of the inline schemas of aModel, with the pointers of the schemas merged into them."

	| pointers |
	pointers := Set new.
	(self inlineSchemasOf: aModel) do: [ :each |
		pointers add: each canonicalPointer.
		pointers addAll: each mergedPointers ].
	^ pointers
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> sortedInlineNamesOfImport: aJsonString merging: aBoolean [

	^ (self inlineNamesOf:
		   (self importWithMerging: aBoolean json: aJsonString)) sorted
		  asArray
]

{ #category : 'fixtures' }
FamixOpenApiInlineNamingTest >> subSetOfComponentJson [

	^ self openApi3Json: (self schemasJson:
			   '`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`},`tag`:{`type`:`string`}}},`Holder`:{`type`:`object`,`properties`:{`pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`}}}}}')
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testComponentSchemaKeepsItsNameAndIsNotDisturbedByAnInlineSchemaNamedString [

	| model component |
	model := self
		         importWithMerging: true
		         json: (self openApi3Json: (self schemasJson:
					           '`string`:{`type`:`object`,`properties`:{`a`:{`type`:`integer`}}},`Holder`:{`type`:`object`,`properties`:{`s`:{`type`:`string`}}}')).
	self
		assert: (self inlineNamesOf: model) sorted asArray
		equals: #( 'integer' 'string' ).
	component := self componentSchemaNamed: 'string' in: model.
	self assert: component types equals: #( 'object' ).
	self
		assert: component canonicalPointer
		equals: '#/components/schemas/string'.
	self assert: (self componentsIn: model) schemas size equals: 2
]

{ #category : 'tests - discriminators' }
FamixOpenApiInlineNamingTest >> testDiscriminatorGivenAsAStringInSwagger2IsNamedAfterTheComponent [

	| model |
	model := self importSwagger2:
		         '`paths`:{},`definitions`:{`Animal`:{`type`:`object`,`discriminator`:`kind`,`properties`:{`kind`:{`type`:`string`}}}}'.
	self
		assert: (self discriminatorNamesOf: model) asArray
		equals: #( 'Animal.kind' )
]

{ #category : 'tests - discriminators' }
FamixOpenApiInlineNamingTest >> testDiscriminatorNameSurvivesTheMerging [

	| model |
	#( true false ) do: [ :merges |
		model := self
			         importWithMerging: merges
			         json: (self discriminatorJson:
					          '`Animal`:{`type`:`object`,`properties`:{`kind`:{`type`:`string`}},`discriminator`:{`propertyName`:`kind`,`mapping`:{`dog`:`#/components/schemas/Dog`}}},`Dog`:{`allOf`:[{`$ref`:`#/components/schemas/Animal`}]}').
		self
			assert: (self discriminatorNamesOf: model) asArray
			equals: #( 'Animal.kind' ) ]
]

{ #category : 'tests - discriminators' }
FamixOpenApiInlineNamingTest >> testDiscriminatorOfAComponentIsNamedAfterTheComponentAndThePropertyName [

	| model |
	model := self importWithMerging: true json: (self discriminatorJson:
			          '`Animal`:{`type`:`object`,`properties`:{`kind`:{`type`:`string`}},`discriminator`:{`propertyName`:`kind`}}').
	self
		assert: (self discriminatorNamesOf: model) asArray
		equals: #( 'Animal.kind' )
]

{ #category : 'tests - discriminators' }
FamixOpenApiInlineNamingTest >> testDiscriminatorOfAnInlineSchemaIsNamedAfterThePropertyNameOnly [

	| model |
	model := self
		         importWithMerging: false
		         json: (self discriminatorJson:
				          '`Holder`:{`type`:`object`,`properties`:{`pet`:{`type`:`object`,`discriminator`:{`propertyName`:`kind`},`properties`:{`kind`:{`type`:`string`}}}}}').
	self
		assert: (self discriminatorNamesOf: model) asArray
		equals: #( 'kind' )
]

{ #category : 'tests - discriminators' }
FamixOpenApiInlineNamingTest >> testDiscriminatorWithoutAPropertyNameIsNamedDiscriminator [

	| model |
	model := self importWithMerging: true json: (self discriminatorJson:
			          '`Animal`:{`type`:`object`,`discriminator`:{`mapping`:{}}}').
	self
		assert: (self discriminatorNamesOf: model) asArray
		equals: #( 'discriminator' )
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testInlineSubSchemaIsNamedAfterItsParent [

	| model subSchema |
	model := self
		         importWithMerging: true
		         json: self subSetOfComponentJson.
	subSchema := (self inlineSchemasOf: model) detect: [ :each |
		             each isKindOf: (self generatedClassNamed: #SubSchema) ].
	self assert: subSchema name equals: 'part of Pet'.
	self assert: subSchema subSchemaOf name equals: 'Pet'
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testNoInlineSchemaIsLeftWithoutAName [

	#( true false ) do: [ :merges |
		#( #petstoreSwagger2Json #petstoreOpenApi3Json #subSetOfComponentJson )
			do: [ :selector |
				| model |
				model := self
					         importWithMerging: merges
					         json: (self perform: selector).
				self deny:
					((self schemasIn: model) anySatisfy: [ :each | each name isNil ]) ] ]
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testNoSubSchemaExistsWithoutMergingSoNoPartOfNameIsGiven [

	| model |
	model := self
		         importWithMerging: false
		         json: self subSetOfComponentJson.
	self deny: ((self inlineNamesOf: model) anySatisfy: [ :each |
			 each beginsWith: 'part of' ]).
	self assert: (self inlineNamesOf: model) size equals: 6
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testOpenApi3PetstoreInlineSchemasAreNamedStructurallyWithMerging [

	self
		assert: (self
				 sortedInlineNamesOfImport: self petstoreOpenApi3Json
				 merging: true)
		equals: #( 'array of Pet' 'array of string' 'string' )
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testOpenApi3PetstoreInlineSchemasAreNamedStructurallyWithoutMerging [

	self
		assert: (self
				 sortedInlineNamesOfImport: self petstoreOpenApi3Json
				 merging: false)
		equals: #( 'array of Pet' 'array of string' 'string' 'string' )
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testPointersAndDiagnosticsAreUnchangedByTheNaming [

	| merged unmerged |
	merged := self
		          importWithMerging: true
		          json: self petstoreOpenApi3Json.
	self
		assert: self importer diagnostics codes asArray
		equals: #( #operationIdMissing ).
	unmerged := self
		            importWithMerging: false
		            json: self petstoreOpenApi3Json.
	self
		assert: self importer diagnostics codes asArray
		equals: #( #operationIdMissing ).
	self
		assert: (self pointersOfInlineSchemasIn: merged)
		equals: (self pointersOfInlineSchemasIn: unmerged).
	self assert: ((self inlineSchemasOf: unmerged) anySatisfy: [ :each |
			 each canonicalPointer
			 =
			 '#/paths/~1pets/get/responses/200/content/application~1json/schema'
				 and: [ each name = 'array of Pet' ] ])
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testSubSchemaOfAnInlineParentIsNamedAfterTheStructuralNameOfTheParent [

	| model subSchema parent |
	model := self importWithMerging: true json: (self openApi3Json:
			          '`paths`:{`/a`:{`get`:{`operationId`:`a`,`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`},`tag`:{`type`:`string`}}}}}}}}},`/b`:{`get`:{`operationId`:`b`,`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`}}}}}}}}}}').
	subSchema := (self inlineSchemasOf: model) detect: [ :each |
		             each isKindOf: (self generatedClassNamed: #SubSchema) ].
	parent := subSchema subSchemaOf.
	self assert: parent name equals: 'object {id, name, tag}'.
	self assert: subSchema name equals: 'part of object {id, name, tag}'
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testSwagger2PetstoreInlineSchemasAreNamedStructurallyWithMerging [

	self
		assert: (self
				 sortedInlineNamesOfImport: self petstoreSwagger2Json
				 merging: true)
		equals:
		#( 'array of Pet' 'array of string' 'integer int64' 'string'
		   'string enum {available, sold}' )
]

{ #category : 'tests - inline schemas' }
FamixOpenApiInlineNamingTest >> testSwagger2PetstoreInlineSchemasAreNamedStructurallyWithoutMerging [

	self
		assert: (self
				 sortedInlineNamesOfImport: self petstoreSwagger2Json
				 merging: false)
		equals:
		#( 'array of Pet' 'array of string' 'integer int64' 'string'
		   'string enum {available, sold}' )
]
