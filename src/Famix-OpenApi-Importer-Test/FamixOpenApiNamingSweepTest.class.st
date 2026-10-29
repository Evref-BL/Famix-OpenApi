"
Final sweep of the naming series: whatever the document version and the merging of inline schemas, no entity of the imported model has a nil or blank name, except the entities whose name is naturally optional in the specification (see #optionallyNamelessClassNames).
"
Class {
	#name : 'FamixOpenApiNamingSweepTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> assertNoUnexpectedlyUnnamedEntityIn: aJsonString merging: aBoolean [

	| model |
	model := self
		         importJson: aJsonString
		         using: (FamixOpenApiImporter new
				          mergesInlineSchemas: aBoolean;
				          yourself).
	self assert: model allModelEntities size > 10.
	self
		assert: (self unexpectedlyUnnamedClassNamesIn: model)
		equals: #(  )
]

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> openApi31Document [

	^ self jsonFrom:
		  '{`openapi`:`3.1.0`,`info`:{`title`:`Petstore 3.1`,`version`:`1`,`summary`:`s`,`license`:{`name`:`MIT`,`identifier`:`MIT`}},`webhooks`:{`newPet`:{`post`:{`requestBody`:{`content`:{`application/json`:{`schema`:{`$ref`:`#/components/schemas/Pet`}}}},`responses`:{`200`:{`description`:`ok`}}}}},`paths`:{`/pets/{id}`:{`get`:{`operationId`:`getPet`,`parameters`:[{`name`:`id`,`in`:`path`,`required`:true,`schema`:{`type`:[`string`,`null`]}}],`responses`:{`200`:{`description`:`ok`,`content`:{`application/json`:{`schema`:{`type`:`object`,`properties`:{`pet`:{`$ref`:`#/components/schemas/Pet`},`extra`:{`type`:`object`,`properties`:{`k`:{`type`:`string`}}}},`allOf`:[{`type`:`object`,`properties`:{`z`:{`type`:`integer`}}}]}}}}}}}},`components`:{`schemas`:{`Pet`:{`type`:`object`,`properties`:{`name`:{`type`:[`string`,`null`]},`kids`:{`type`:`array`,`items`:{`type`:`object`,`properties`:{`age`:{`type`:`integer`}}}}}}},`securitySchemes`:{`bearer`:{`type`:`http`,`scheme`:`bearer`},`oidc`:{`type`:`openIdConnect`,`openIdConnectUrl`:`https://o`}}},`security`:[{`bearer`:[],`oidc`:[]}]}'
]

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> openApi3Document [

	^ self jsonFrom:
		  '{`openapi`:`3.0.3`,`info`:{`title`:`Petstore`,`version`:`1`,`contact`:{`email`:`a@b.c`},`license`:{`url`:`https://l`}},`servers`:[{`url`:`https://{env}.example.com`,`variables`:{`env`:{`default`:`prod`}}}],`tags`:[{`name`:`pets`,`externalDocs`:{`url`:`https://d`}},{`description`:`unnamed tag`}],`security`:[{`key`:[]},{}],`paths`:{`/pets`:{`parameters`:[{`name`:`limit`,`in`:`query`,`schema`:{`type`:`integer`}}],`get`:{`operationId`:`listPets`,`tags`:[`pets`],`callbacks`:{`done`:{`{$request.body#/url}`:{`post`:{`responses`:{`200`:{`description`:`ok`}}}}}},`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`schema`:{`type`:`integer`}}},`links`:{`next`:{`operationId`:`listPets`}},`content`:{`application/json`:{`schema`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/Pet`}},`examples`:{`one`:{`value`:{`a`:1}}}}}}}},`post`:{`requestBody`:{`content`:{`application/json`:{`schema`:{`oneOf`:[{`type`:`object`,`properties`:{`n`:{`type`:`string`}}},{`type`:`string`}]}}}},`responses`:{`default`:{`description`:`err`}}}}},`components`:{`schemas`:{`Pet`:{`type`:`object`,`discriminator`:{`propertyName`:`kind`},`xml`:{`name`:`pet`},`properties`:{`name`:{`type`:`string`,`xml`:{`attribute`:true}},`tags`:{`type`:`array`,`items`:{`type`:`string`}},`owner`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}},`state`:{`type`:`string`,`enum`:[`a`,`b`]}}}},`securitySchemes`:{`key`:{`type`:`apiKey`,`in`:`header`,`name`:`X`}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> optionallyNamelessClassNames [
	"The classes whose name is naturally optional: the name of a Contact, a License and a Tag is optional in the specifications (a Tag has no name only when the document is incomplete), and an Xml element carries a name only when the xml object gives one. Evaluated on the sample documents and on the test corpus, these and only these remain without a name."

	^ #( #OPContact #OPLicense #OPTag #OPXmlElement )
]

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> swagger2Document [

	^ self jsonFrom:
		  '{`swagger`:`2.0`,`info`:{`title`:`Petstore 2`,`version`:`1`,`contact`:{`name`:`me`},`license`:{`name`:`MIT`}},`host`:`example.com`,`basePath`:`/v1`,`tags`:[{`name`:`pets`}],`security`:[{`api_key`:[]}],`paths`:{`/pets`:{`get`:{`operationId`:`listPets`,`tags`:[`pets`],`parameters`:[{`name`:`ids`,`in`:`query`,`type`:`array`,`items`:{`type`:`integer`}}],`responses`:{`200`:{`description`:`ok`,`headers`:{`X-Rate`:{`type`:`integer`}},`schema`:{`type`:`array`,`items`:{`$ref`:`#/definitions/Pet`}}},`default`:{`$ref`:`#/responses/Err`}}},`post`:{`parameters`:[{`name`:`body`,`in`:`body`,`schema`:{`type`:`object`,`properties`:{`n`:{`type`:`string`}}}}],`responses`:{`201`:{`description`:`made`}}}}},`definitions`:{`Pet`:{`type`:`object`,`discriminator`:`kind`,`xml`:{`name`:`pet`},`properties`:{`kind`:{`type`:`string`},`status`:{`type`:`string`,`enum`:[`available`,`sold`]},`photoUrls`:{`type`:`array`,`items`:{`type`:`string`}},`owner`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}}}}},`responses`:{`Err`:{`description`:`error`}},`securityDefinitions`:{`api_key`:{`type`:`apiKey`,`name`:`k`,`in`:`header`}}}'
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testOnlyTheOptionalClassesAreLeftWithoutANameOnTheSampleDocuments [
	"Guard of the exception list: the optional classes do occur without a name in the samples, so the list is not wider than needed."

	| classNames |
	classNames := {
		              self openApi3Document.
		              self openApi31Document.
		              self swagger2Document }
		              flatCollect: [ :json |
			              (self unnamedEntitiesIn: (self importJson: json))
				              collect: [ :each | each class name ] ]
		              as: Set.
	self assert:
		(classNames includesAll: #( #OPContact #OPTag #OPLicense )).
	self assert:
		(self optionallyNamelessClassNames includesAll: classNames)
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testOpenApi31DocumentHasNoUnnamedEntityWithMerging [

	self
		assertNoUnexpectedlyUnnamedEntityIn: self openApi31Document
		merging: true
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testOpenApi31DocumentHasNoUnnamedEntityWithoutMerging [

	self
		assertNoUnexpectedlyUnnamedEntityIn: self openApi31Document
		merging: false
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testOpenApi3DocumentHasNoUnnamedEntityWithMerging [

	self
		assertNoUnexpectedlyUnnamedEntityIn: self openApi3Document
		merging: true
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testOpenApi3DocumentHasNoUnnamedEntityWithoutMerging [

	self
		assertNoUnexpectedlyUnnamedEntityIn: self openApi3Document
		merging: false
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testSwagger2DocumentHasNoUnnamedEntityWithMerging [

	self
		assertNoUnexpectedlyUnnamedEntityIn: self swagger2Document
		merging: true
]

{ #category : 'tests' }
FamixOpenApiNamingSweepTest >> testSwagger2DocumentHasNoUnnamedEntityWithoutMerging [

	self
		assertNoUnexpectedlyUnnamedEntityIn: self swagger2Document
		merging: false
]

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> unexpectedlyUnnamedClassNamesIn: aModel [
	"Answer the sorted names of the classes of the entities of aModel without a name, whose name is not optional."

	^ ((self unnamedEntitiesIn: aModel)
		   collect: [ :each | each class name ]
		   as: Set) asArray sorted reject: [ :each |
		  self optionallyNamelessClassNames includes: each ]
]

{ #category : 'fixtures' }
FamixOpenApiNamingSweepTest >> unnamedEntitiesIn: aModel [
	"Answer the entities of aModel whose name is nil or blank."

	^ aModel allModelEntities select: [ :each |
		  each name isNil or: [ each name asString trimBoth isEmpty ] ]
]
