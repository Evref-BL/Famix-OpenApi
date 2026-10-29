"
Tests for FamixOpenApiNaming synthesized operation names.
"
Class {
	#name : 'FamixOpenApiNamingTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'helpers' }
FamixOpenApiNamingTest >> arrayOf: aSchema [

	^ OPSchema new
		  types: #( 'array' );
		  items: aSchema;
		  yourself
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> ellipsis [

	^ FamixOpenApiNaming ellipsis
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> importedResponseSchema: aSchemaJson version: aVersion [
	"Answer the inline schema of the 200 response of a small document of version aVersion, in which it is aSchemaJson. The document has a component Pet."

	^ self
		  importedSchemaAt:
		  '#/paths/~1pets/get/responses/200/content/application~1json/schema'
		  from: '{"openapi":"' , aVersion
			  ,
			  '","info":{"title":"t","version":"1"},"paths":{"/pets":{"get":{"responses":{"200":{"description":"ok","content":{"application/json":{"schema":'
			  , aSchemaJson
			  ,
			  '}}}}}}},"components":{"schemas":{"Pet":{"type":"object","properties":{"id":{"type":"integer"}}}}}}'
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> importedSchemaAt: aPointer from: aJsonString [
	"Answer the schema of the model imported from aJsonString whose canonical pointer is aPointer."

	^ ((FamixOpenApiImporter new importFromString: aJsonString)
		   allWithType: OPSchema) detect: [ :each |
		  each canonicalPointer asString = aPointer ]
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> nameFor: aVerb path: aPath [

	^ FamixOpenApiNaming synthesizedOperationNameFor: aVerb path: aPath
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> namedSchema: aString [

	^ OPSchema new
		  name: aString;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> objectWithProperties: aCollectionOfStrings [
	"Answer a schema without type that has one string property per name of aCollectionOfStrings, added in that order."

	| schema |
	schema := OPSchema new.
	aCollectionOfStrings do: [ :each |
		schema addProperty: (OPProperty new
				 name: each;
				 valueSchema: (self typedSchema: 'string');
				 yourself) ].
	^ schema
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> structuralNameOf: aSchema [

	^ FamixOpenApiNaming structuralNameOf: aSchema
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testDashIsNotKeptAsIs [
	"Assumption: non-alphanumerics are removed or underscored, so the result has no dash; only check that and the absence of double underscore."

	| name |
	name := self nameFor: 'get' path: '/pet-owners'.
	self deny: (name includes: $-) description: 'No dash in ' , name.
	self
		deny: (name includesSubstring: '__')
		description: 'No double underscore in ' , name.
	self
		assert: (name beginsWith: 'get_pet')
		description: 'Starts with get_pet: ' , name
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testDotIsNotKeptAsIs [

	| name |
	name := self nameFor: 'get' path: '/files.json'.
	self deny: (name includes: $.) description: 'No dot in ' , name.
	self
		deny: (name includesSubstring: '__')
		description: 'No double underscore in ' , name
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedCollapsesNewlinesAndTabs [

	self
		assert: (FamixOpenApiNaming limited: 'a
		b		c')
		equals: 'a b c'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedCollapsesRunsOfWhitespaceAndControlCharacters [

	self
		assert: (FamixOpenApiNaming limited: (String withAll: {
						  $a.
						  Character space.
						  Character space.
						  Character tab.
						  Character cr.
						  Character lf.
						  (Character value: 0).
						  $b }))
		equals: 'a b'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedCountsUnicodeAsOneCharacter [

	| result |
	result := FamixOpenApiNaming limited: (String
			           new: FamixOpenApiNaming maxNameLength
			           withAll: (Character value: 233)).
	self assert: result size equals: FamixOpenApiNaming maxNameLength.
	self assert: result last equals: (Character value: 233)
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedKeepsATextOfExactlyMaxNameLength [

	| text |
	text := String new: FamixOpenApiNaming maxNameLength withAll: $x.
	self assert: (FamixOpenApiNaming limited: text) equals: text
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedKeepsUnicode [

	self
		assert: (FamixOpenApiNaming limited:
				 'Caf' , (String with: (Character value: 233)) , ' '
				 , (String with: (Character value: 16r4E2D)))
		equals: 'Caf' , (String with: (Character value: 233)) , ' '
			, (String with: (Character value: 16r4E2D))
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedNeverLeavesASpaceBeforeTheEllipsis [

	| result |
	result := FamixOpenApiNaming limited:
		          (String
			           new: FamixOpenApiNaming maxNameLength - 2
			           withAll: $x) , ' yyyy'.
	self assert: result size <= FamixOpenApiNaming maxNameLength.
	self assert: result last equals: (Character value: 16r2026).
	self deny: (result at: result size - 1) isSeparator
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedOfBlankStringIsEmpty [

	self
		assert:
		(FamixOpenApiNaming limited: '  ' , (String with: Character tab))
		equals: ''
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedOfEmptyStringIsEmpty [

	self assert: (FamixOpenApiNaming limited: '') equals: ''
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedOfNilIsEmptyString [

	self assert: (FamixOpenApiNaming limited: nil) equals: ''
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedTrimsTheEnds [

	self
		assert: (FamixOpenApiNaming limited: (String withAll: {
						  Character lf.
						  Character space.
						  $a.
						  Character tab }))
		equals: 'a'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testLimitedTruncatesOneCharacterOverMaxNameLength [

	| result |
	result := FamixOpenApiNaming limited:
		          (String
			           new: FamixOpenApiNaming maxNameLength + 1
			           withAll: $x).
	self assert: result size equals: FamixOpenApiNaming maxNameLength.
	self assert: result last equals: (Character value: 16r2026).
	self
		assert: result allButLast
		equals:
		(String new: FamixOpenApiNaming maxNameLength - 1 withAll: $x)
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNameFromAnyAnswersTheFallbackWhenNoCandidate [

	self
		assert: (FamixOpenApiNaming nameFromAny: { nil. '' } fallback: 'fb')
		equals: 'fb'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNameFromAnyAnswersTheFirstNonBlankCandidate [

	self
		assert: (FamixOpenApiNaming
				 nameFromAny: { nil. '  '. 'b'. 'c' }
				 fallback: 'fb')
		equals: 'b'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNestedPathSegmentsJoinedByUnderscore [

	self
		assert:
		(self nameFor: 'delete' path: '/owners/{ownerId}/pets/{petId}')
		equals: 'delete_owners_ownerId_pets_petId'
		description: 'Segments joined by _'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testNeverContainsDoubleUnderscore [

	#( '/a//b' '/a/{b}/' '/{a}/{b}' '/a-b.c' ) do: [ :path |
		| name |
		name := self nameFor: 'put' path: path.
		self
			deny: (name includesSubstring: '__')
			description: 'No double underscore for ' , path , ': ' , name ]
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testPathParameterBracesAreRemoved [

	self
		assert: (self nameFor: 'get' path: '/pets/{petId}')
		equals: 'get_pets_petId'
		description: 'Spec example'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testSameInputGivesSameName [

	self
		assert: (self nameFor: 'get' path: '/pets/{petId}')
		equals: (self nameFor: 'get' path: '/pets/{petId}')
		description: 'Deterministic'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testSimplePath [

	self
		assert: (self nameFor: 'get' path: '/pets')
		equals: 'get_pets'
		description: 'Single segment'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfAllOf [

	self
		assert: (self structuralNameOf: (OPSchema new
					  addAllOf: (self namedSchema: 'Pet');
					  addAllOf: (self objectWithProperties: #( 'b' 'a' ));
					  yourself))
		equals: 'allOf(Pet, object {a, b})'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfAnyOf [

	self
		assert: (self structuralNameOf: (OPSchema new
					  addAnyOf: (self namedSchema: 'Pet');
					  addAnyOf: (self typedSchema: 'integer');
					  yourself))
		equals: 'anyOf(Pet, integer)'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfArrayOfItems [

	self
		assert:
		(self structuralNameOf: (self arrayOf: (self namedSchema: 'Pet')))
		equals: 'array of Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfArrayWithoutItems [

	self
		assert: (self structuralNameOf: (self typedSchema: 'array'))
		equals: 'array'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfBlankNameFallsBackToTheShape [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  name: '  ';
					  yourself))
		equals: 'string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfComponentSchemaIsItsNameWhateverItsShape [

	| schema |
	schema := (self arrayOf: (self typedSchema: 'string'))
		          name: 'Pets';
		          yourself.
	schema components: OPComponents new.
	self assert: (self structuralNameOf: schema) equals: 'Pets'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfConst [

	self
		assert: (self structuralNameOf: (OPSchema new
					  constValue: '"x"';
					  yourself))
		equals: 'const "x"'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfCyclicOneOfTerminates [

	| schema |
	schema := OPSchema new.
	schema addOneOf: schema.
	schema addOneOf: (self namedSchema: 'Pet').
	self
		assert: (self structuralNameOf: schema)
		equals: self ellipsis , ' | Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfDoesNotCountNamedMembersAsNesting [

	self
		assert: (self structuralNameOf: (self arrayOf:
					  (self arrayOf: (self arrayOf: (self namedSchema: 'Pet')))))
		equals: 'array of array of array of Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfDoesNotDependOnTheOrderOfProperties [

	self
		assert:
		(self structuralNameOf:
			 (self objectWithProperties: #( 'c' 'a' 'b' )))
		equals:
		(self structuralNameOf:
			 (self objectWithProperties: #( 'b' 'c' 'a' )))
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfDoesNotModifyTheSchema [

	| schema |
	schema := self arrayOf: (self objectWithProperties: #( 'b' 'a' )).
	self structuralNameOf: schema.
	self assert: schema name isNil.
	self assert: schema items name isNil.
	self assert: schema items properties size equals: 2.
	self assert: schema items properties first name equals: 'b'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEmptyObject [

	self
		assert: (self structuralNameOf: (self typedSchema: 'object'))
		equals: 'object'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEmptySchemaIsAny [

	self assert: (self structuralNameOf: OPSchema new) equals: 'any'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEnum [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  enumValues: '["a","b","c"]';
					  yourself))
		equals: 'string enum {a, b, c}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEnumListsAtMostThreeValues [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  enumValues: '["a","b","c","d"]';
					  yourself))
		equals: 'string enum {a, b, c, ' , self ellipsis , '}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEnumRendersNonStringValues [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'integer')
					  enumValues: '[1,2.5,null]';
					  yourself))
		equals: 'integer enum {1, 2.5, null}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEnumWithUnparsableValuesStillAnswersAName [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  enumValues: '["a"';
					  yourself))
		equals: 'string enum {["a"}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfEnumWithoutType [

	self
		assert: (self structuralNameOf: (OPSchema new
					  enumValues: '["x"]';
					  yourself))
		equals: 'enum {x}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedArrayOfReference [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema:
					  '{"type":"array","items":{"$ref":"#/components/schemas/Pet"}}'
					  version: '3.0.3'))
		equals: 'array of Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedEnumAndFormat [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema:
					  '{"type":"string","enum":["a","b",3,null]}'
					  version: '3.0.3'))
		equals: 'string enum {a, b, 3, ' , self ellipsis , '}'.
	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema: '{"type":"integer","format":"int32"}'
					  version: '3.0.3'))
		equals: 'integer int32'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedMapAndEmptySchema [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema:
					  '{"additionalProperties":{"$ref":"#/components/schemas/Pet"}}'
					  version: '3.0.3'))
		equals: 'map of Pet'.
	self
		assert: (self structuralNameOf:
				 (self importedResponseSchema: '{}' version: '3.0.3'))
		equals: 'any'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedNullableType [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema: '{"type":"string","nullable":true}'
					  version: '3.0.3'))
		equals: 'string?'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedObjectWithProperties [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema:
					  '{"type":"object","properties":{"file":{"type":"string"},"caption":{"type":"string"}}}'
					  version: '3.0.3'))
		equals: 'object {caption, file}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedOneOfOfReferences [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema:
					  '{"oneOf":[{"$ref":"#/components/schemas/Pet"},{"type":"string"}]}'
					  version: '3.0.3'))
		equals: 'Pet | string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedTypeArrayOfSeveralTypes [

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema: '{"type":["string","integer","null"]}'
					  version: '3.1.0'))
		equals: 'integer/string/null'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfImportedTypeArrayWithNull [
	"The importer folds the null of a 3.1 type array into isNullable, so a single type and null gives the same name as a 3.0 nullable."

	self
		assert: (self structuralNameOf: (self
					  importedResponseSchema: '{"type":["string","null"]}'
					  version: '3.1.0'))
		equals: 'string?'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfIsDeterministic [

	| schema |
	schema := self arrayOf: (self objectWithProperties: #( 'b' 'a' )).
	self
		assert: (self structuralNameOf: schema)
		equals: (self structuralNameOf: schema)
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfLimitsTheLength [

	| name |
	name := self structuralNameOf:
		        (self objectWithProperties:
			         { (String new: 200 withAll: $a) }).
	self assert: name size equals: FamixOpenApiNaming maxNameLength.
	self assert: name last equals: (Character value: 16r2026)
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfLimitsTheLengthOfManyMembers [

	| schema name |
	schema := OPSchema new.
	1 to: 500 do: [ :each |
		schema addOneOf: (self namedSchema: ('Member{1}' format: { each })) ].
	name := self structuralNameOf: schema.
	self assert: name size equals: FamixOpenApiNaming maxNameLength.
	self assert: (name beginsWith: 'Member1 | Member2')
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfMapOfAdditionalProperties [

	self
		assert: (self structuralNameOf: (OPSchema new
					  types: #( 'object' );
					  additionalProperties: (self typedSchema: 'string');
					  yourself))
		equals: 'map of string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfMapOfNamedSchema [

	self
		assert: (self structuralNameOf: (OPSchema new
					  additionalProperties: (self namedSchema: 'Pet');
					  yourself))
		equals: 'map of Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfMutuallyReferencingSchemasTerminates [

	| first second |
	first := OPSchema new
		         types: #( 'array' );
		         yourself.
	second := OPSchema new
		          types: #( 'array' );
		          yourself.
	first items: second.
	second items: first.
	self
		assert: (self structuralNameOf: first)
		equals: 'array of array of ' , self ellipsis.
	self
		assert: (self structuralNameOf: second)
		equals: 'array of array of ' , self ellipsis
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNamedSchemaIsItsName [

	self
		assert: (self structuralNameOf: (self namedSchema: 'Pet'))
		equals: 'Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNestedArrays [

	self
		assert: (self structuralNameOf:
				 (self arrayOf: (self arrayOf: (self typedSchema: 'string'))))
		equals: 'array of array of string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNilIsAny [

	self assert: (self structuralNameOf: nil) equals: 'any'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNot [

	self
		assert: (self structuralNameOf: (OPSchema new
					  not: (self namedSchema: 'Pet');
					  yourself))
		equals: 'not Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNotNullableIsNotMarked [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  isNullable: false;
					  yourself))
		equals: 'string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNullOnly [

	self
		assert: (self structuralNameOf: (OPSchema new
					  isNullable: true;
					  yourself))
		equals: 'null'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNullable [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  isNullable: true;
					  yourself))
		equals: 'string?'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfNullableArray [

	self
		assert:
			(self structuralNameOf:
				 ((self arrayOf: (self typedSchema: 'string'))
					  isNullable: true;
					  yourself))
		equals: 'array of string?'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfObjectKeepsUnicodePropertyNames [

	self
		assert: (self structuralNameOf:
				 (self objectWithProperties: { 'légende'. 'fichier'. '日本語' }))
		equals: 'object {fichier, légende, 日本語}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfObjectListsAtMostFourPropertyNames [

	self
		assert: (self structuralNameOf:
				 (self objectWithProperties: #( 'e' 'd' 'c' 'b' 'a' )))
		equals: 'object {a, b, c, d, ' , self ellipsis , '}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfObjectListsTheSortedPropertyNames [

	self
		assert: (self structuralNameOf:
				 (self objectWithProperties: #( 'file' 'caption' )))
		equals: 'object {caption, file}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfObjectSortsPropertyNamesCaseSensitively [

	self
		assert: (self structuralNameOf:
				 (self objectWithProperties: #( 'b' 'B' 'a' 'A' )))
		equals: 'object {A, a, B, b}'.
	self
		assert: (self structuralNameOf:
				 (self objectWithProperties: #( 'A' 'a' 'b' 'B' )))
		equals: 'object {A, a, B, b}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfObjectWithBooleanAdditionalProperties [

	self
		assert: (self structuralNameOf: (OPSchema new
					  types: #( 'object' );
					  additionalPropertiesAllowed: false;
					  yourself))
		equals: 'object'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfObjectWithFourPropertiesHasNoEllipsis [

	self
		assert: (self structuralNameOf:
				 (self objectWithProperties: #( 'd' 'c' 'b' 'a' )))
		equals: 'object {a, b, c, d}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfOneOfJoinsTheMembers [

	self
		assert: (self structuralNameOf: (OPSchema new
					  addOneOf: (self namedSchema: 'Pet');
					  addOneOf: (self namedSchema: 'Dog');
					  yourself))
		equals: 'Pet | Dog'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfOneOfRendersInlineMembers [

	self
		assert: (self structuralNameOf: (OPSchema new
					  addOneOf: (self typedSchema: 'string');
					  addOneOf: (self arrayOf: (self namedSchema: 'Pet'));
					  yourself))
		equals: 'string | array of Pet'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfOneOfWinsOverAnyOfAllOfAndNot [

	self
		assert: (self structuralNameOf: (OPSchema new
					  addOneOf: (self namedSchema: 'A');
					  addAnyOf: (self namedSchema: 'B');
					  addAllOf: (self namedSchema: 'C');
					  not: (self namedSchema: 'D');
					  yourself))
		equals: 'A'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfPropertiesWinOverAdditionalProperties [

	self
		assert:
			(self structuralNameOf: ((self objectWithProperties: #( 'a' ))
					  additionalProperties: (self typedSchema: 'string');
					  yourself))
		equals: 'object {a}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfPropertiesWithoutTypeIsAnObject [

	self
		assert:
		(self structuralNameOf: (self objectWithProperties: #( 'a' )))
		equals: 'object {a}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfRendersThreeLevelsOfNesting [

	| schema |
	schema := self typedSchema: 'string'.
	5 timesRepeat: [ schema := self arrayOf: schema ].
	self
		assert: (self structuralNameOf: schema)
		equals: 'array of array of array of ' , self ellipsis
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfScalar [

	self
		assert: (self structuralNameOf: (self typedSchema: 'string'))
		equals: 'string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfScalarWithFormat [

	self
		assert: (self structuralNameOf: ((self typedSchema: 'integer')
					  format: 'int32';
					  yourself))
		equals: 'integer int32'.
	self
		assert: (self structuralNameOf: ((self typedSchema: 'string')
					  format: 'date-time';
					  yourself))
		equals: 'string date-time'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfSelfReferencingArrayTerminates [

	| schema |
	schema := OPSchema new
		          types: #( 'array' );
		          yourself.
	schema items: schema.
	self
		assert: (self structuralNameOf: schema)
		equals: 'array of ' , self ellipsis
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfSelfReferencingPropertyTerminates [

	| schema |
	schema := self objectWithProperties: #( 'a' ).
	schema properties first valueSchema: schema.
	self assert: (self structuralNameOf: schema) equals: 'object {a}'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfSeveralNullableTypesEndWithNull [

	self
		assert: (self structuralNameOf: (OPSchema new
					  types: #( 'string' 'integer' );
					  isNullable: true;
					  yourself))
		equals: 'integer/string/null'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfSeveralTypesAreSortedAndJoined [

	self
		assert: (self structuralNameOf: (OPSchema new
					  types: #( 'string' 'integer' );
					  yourself))
		equals: 'integer/string'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfTuple [

	self
		assert: (self structuralNameOf: (OPSchema new
					  types: #( 'array' );
					  addPrefixItem: (self typedSchema: 'string');
					  addPrefixItem: (self namedSchema: 'Pet');
					  yourself))
		equals: 'tuple [string, Pet]'
]

{ #category : 'tests - structural names' }
FamixOpenApiNamingTest >> testStructuralNameOfUnresolvedReferenceIsItsLastSegment [

	self
		assert: (self structuralNameOf: (OPSchema new
					  ref: '#/components/schemas/Missing';
					  yourself))
		equals: 'Missing'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testTrailingSlashDoesNotAddTrailingUnderscore [
	"Assumption: no double underscore, and a trailing slash adds no empty segment."

	self
		assert: (self nameFor: 'get' path: '/pets/')
		equals: 'get_pets'
		description: 'Trailing slash ignored'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testUppercaseVerbIsLowercased [
	"Assumption: the verb is lowercased (spec says 'lowercase verb')."

	self
		assert: (self nameFor: 'GET' path: '/pets')
		equals: 'get_pets'
		description: 'Verb lowercased'
]

{ #category : 'tests' }
FamixOpenApiNamingTest >> testVerbIsPrefix [

	self
		assert: (self nameFor: 'post' path: '/pets')
		equals: 'post_pets'
		description: 'Verb prefix'
]

{ #category : 'helpers' }
FamixOpenApiNamingTest >> typedSchema: aString [

	^ OPSchema new
		  types: { aString };
		  yourself
]
