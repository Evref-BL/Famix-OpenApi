"
Tests of the merging of identical inline schemas and of the detection of SubSchemas by the importer: one behaviour per test.
"
Class {
	#name : 'FamixOpenApiMergeTest',
	#superclass : 'FamixOpenApiImporterTestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> importWithoutMerging: aMembersString [

	^ self
		  importJson: (self openApi3Json: aMembersString)
		  using: (FamixOpenApiImporter new
				   mergesInlineSchemas: false;
				   yourself)
]

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> inlineEqualToComponentJson [
	"Name is a component; the property n of Holder repeats its content inline."

	^ self schemasJson:
		  '`Holder`:{`type`:`object`,`properties`:{`n`:{`type`:`string`,`maxLength`:8}}},`Name`:{`type`:`string`,`maxLength`:8}'
]

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> mergedSchemaOf: aSchema property: aPropertyName [

	^ (self propertyNamed: aPropertyName ofSchema: aSchema) valueSchema
]

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> notASubSetJson [
	"The inline schemas have a property that Pet does not have, or another type for a common property: not SubSchemas."

	^ self schemasJson:
		  '`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`}}},`Holder`:{`type`:`object`,`properties`:{`extra`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`other`:{`type`:`string`}}},`retyped`:{`type`:`object`,`properties`:{`id`:{`type`:`string`}}}}}'
]

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> subSetOfComponentJson [
	"The inline schema of the property pet has two of the three properties of the component Pet, with the same value schemas."

	^ self schemasJson:
		  '`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`},`tag`:{`type`:`string`}}},`Holder`:{`type`:`object`,`properties`:{`pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`}}}}}'
]

{ #category : 'tests - merge inline schema into component' }
FamixOpenApiMergeTest >> testComponentKeepsItsOwnPointerAndListsTheMergedInlinePointer [

	| model name |
	model := self importOpenApi3: self inlineEqualToComponentJson.
	name := self componentSchemaNamed: 'Name' in: model.
	self
		assert: name canonicalPointer
		equals: '#/components/schemas/Name'.
	self
		assert: name mergedPointers asArray
		equals: #( '#/components/schemas/Holder/properties/n' )
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testComponentKnowsItsSubSchemas [

	| model holder pet inline |
	model := self importOpenApi3: self subSetOfComponentJson.
	holder := self componentSchemaNamed: 'Holder' in: model.
	pet := self componentSchemaNamed: 'Pet' in: model.
	inline := self mergedSchemaOf: holder property: 'pet'.
	self assert: pet subSchemas size equals: 1.
	self assert: pet subSchemas anyOne == inline
]

{ #category : 'tests - merge inline schema into component' }
FamixOpenApiMergeTest >> testComponentReferrerIsListedAfterMerge [

	| model name holder |
	model := self importOpenApi3: self inlineEqualToComponentJson.
	name := self componentSchemaNamed: 'Name' in: model.
	holder := self componentSchemaNamed: 'Holder' in: model.
	self assert: name usedAsPropertyValueBy size equals: 1.
	self assert: name usedAsPropertyValueBy anyOne schema == holder
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testComponentSchemaIsNeverTurnedIntoASubSchema [
	"A component that is a strict subset of another component stays a plain, named Schema."

	| model |
	model := self importOpenApi3: (self schemasJson:
			          '`Big`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`}}},`Small`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}}').
	self deny: ((self componentSchemaNamed: 'Small' in: model) isKindOf:
			 (self generatedClassNamed: #SubSchema)).
	self assert:
		(model allWithType: (self generatedClassNamed: #SubSchema)) isEmpty
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testComponentsAreNeverMergedTogether [
	"Two component schemas with the same content stay two named entities."

	| model |
	model := self importOpenApi3:
		         (self schemasJson:
			          '`A`:{`type`:`string`},`B`:{`type`:`string`}').
	self assert: (self schemasIn: model) size equals: 2.
	self assert: (self componentSchemaNamed: 'A' in: model)
		~~ (self componentSchemaNamed: 'B' in: model)
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testIdenticalNestedInlineSchemasMergeBottomUp [

	| model x y |
	model := self importOpenApi3: (self schemasJson:
			          '`X`:{`type`:`object`,`properties`:{`p`:{`type`:`object`,`properties`:{`a`:{`type`:`boolean`}}}}},`Y`:{`type`:`object`,`properties`:{`p`:{`type`:`object`,`properties`:{`a`:{`type`:`boolean`}}}}}').
	x := self componentSchemaNamed: 'X' in: model.
	y := self componentSchemaNamed: 'Y' in: model.
	self assert: (self mergedSchemaOf: x property: 'p')
		== (self mergedSchemaOf: y property: 'p').
	self assert: (self schemasIn: model) size equals: 4
]

{ #category : 'tests - merge across operations (step B)' }
FamixOpenApiMergeTest >> testIdenticalParameterSchemasOfTwoOperationsAreMerged [
	"The inline schemas of two parameters of different operations are one entity."

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`parameters`:[{`name`:`p`,`in`:`query`,`schema`:{`type`:`string`}}],`responses`:{`200`:{`description`:`ok`}}}},`/b`:{`get`:{`operationId`:`opB`,`parameters`:[{`name`:`q`,`in`:`query`,`schema`:{`type`:`string`}}],`responses`:{`200`:{`description`:`ok`}}}}}'.
	self assert:
		(self operationWithId: 'opA' in: model) parameters anyOne schema
		== (self operationWithId: 'opB' in: model) parameters anyOne schema.
	self assert: (self schemasIn: model) size equals: 1.
	self
		assert: (self schemasIn: model) anyOne mergedPointers size
		equals: 1
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testIndexRedirectsAMergedPointerToTheSurvivor [
	"A pointer of a merged inline schema resolves to the surviving entity."

	| model merged other |
	model := self importOpenApi3: self twinInlineJson.
	merged := self
		          mergedSchemaOf: (self componentSchemaNamed: 'A' in: model)
		          property: 'x'.
	other := merged mergedPointers anyOne.
	self assert:
		(importer index resolveReference: other from: '#' expecting: nil)
		== merged.
	self assert: (importer index
			 resolveReference: merged canonicalPointer
			 from: '#'
			 expecting: nil) == merged
]

{ #category : 'tests - merge inline schema into component' }
FamixOpenApiMergeTest >> testInlineSchemaEqualToAComponentMergesIntoTheComponent [

	| model holder name |
	model := self importOpenApi3: self inlineEqualToComponentJson.
	holder := self componentSchemaNamed: 'Holder' in: model.
	name := self componentSchemaNamed: 'Name' in: model.
	self assert: (self mergedSchemaOf: holder property: 'n') == name.
	self assert: (self schemasIn: model) size equals: 2
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testInlineStrictSubsetOfAComponentBecomesASubSchema [

	| model holder pet inline |
	model := self importOpenApi3: self subSetOfComponentJson.
	holder := self componentSchemaNamed: 'Holder' in: model.
	pet := self componentSchemaNamed: 'Pet' in: model.
	inline := self mergedSchemaOf: holder property: 'pet'.
	self assert:
		(inline isKindOf: (self generatedClassNamed: #SubSchema)).
	self assert: inline subSchemaOf == pet
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testItemsOfTwoSchemasAreMergedAndRepointed [

	| model b c |
	model := self importOpenApi3: (self schemasJson:
			          '`B`:{`type`:`array`,`items`:{`type`:`integer`}},`C`:{`type`:`array`,`items`:{`type`:`integer`}}').
	b := self componentSchemaNamed: 'B' in: model.
	c := self componentSchemaNamed: 'C' in: model.
	self assert: b items == c items.
	self assert: b items usedAsItemsBy size equals: 2.
	self assert: (self schemasIn: model) size equals: 3
]

{ #category : 'tests - merge inline schema into component' }
FamixOpenApiMergeTest >> testMergeIntoComponentDoesNotDependOnDeclarationOrder [
	"Name is declared after Holder in the fixture: the merge happens anyway."

	| model |
	model := self importOpenApi3: self inlineEqualToComponentJson.
	self assert:
		(model allWithType: (self generatedClassNamed: #SubSchema)) isEmpty.
	self assert: (self schemasIn: model) size equals: 2
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testMergeIsDeterministic [
	"Importing twice the same text gives the same number of schemas and the same merged pointers."

	| first second |
	first := self importOpenApi3: self tripletInlineJson.
	second := self importOpenApi3: self tripletInlineJson.
	self
		assert: (self schemasIn: first) size
		equals: (self schemasIn: second) size.
	self
		assert: (self
				 mergedSchemaOf: (self componentSchemaNamed: 'A' in: first)
				 property: 'x') mergedPointers asSet
		equals: (self
				 mergedSchemaOf: (self componentSchemaNamed: 'A' in: second)
				 property: 'x') mergedPointers asSet
		description: 'merged pointers'
]

{ #category : 'tests - merge inline schema into component' }
FamixOpenApiMergeTest >> testMergeReportCountsTheInlineSchemaMergedIntoAComponent [

	| report |
	self importOpenApi3: self inlineEqualToComponentJson.
	report := importer mergeReport.
	self assert: (report at: #merged) equals: 1.
	self assert: (report at: #subSchemas) equals: 0
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testMergeReportCountsTheMergedSchemas [

	| report |
	self importOpenApi3: self tripletInlineJson.
	report := importer mergeReport.
	self assert: (report at: #merged) equals: 2.
	self assert: (report at: #subSchemas) equals: 0.
	self assert: (report at: #inlineSchemas) >= 1
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testMergeReportCountsTheSubSchemas [

	| report |
	self importOpenApi3: self subSetOfComponentJson.
	report := importer mergeReport.
	self assert: (report at: #subSchemas) equals: 1
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testMergedSchemaListsTheOtherPointerInMergedPointers [
	"The entity keeps one of the two pointers as canonicalPointer and lists the other one in mergedPointers."

	| model merged pointers |
	model := self importOpenApi3: self twinInlineJson.
	merged := self
		          mergedSchemaOf: (self componentSchemaNamed: 'A' in: model)
		          property: 'x'.
	self assert: merged mergedPointers size equals: 1.
	pointers := Set with: merged canonicalPointer.
	pointers addAll: merged mergedPointers.
	self assert: pointers equals: (Set
			 with: '#/components/schemas/A/properties/x'
			 with: '#/components/schemas/A/properties/y')
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testMergesInlineSchemasFalseCreatesNoSubSchema [

	| model |
	model := self importWithoutMerging: self subSetOfComponentJson.
	self assert:
		(model allWithType: (self generatedClassNamed: #SubSchema)) isEmpty.
	self assert:
		(self componentSchemaNamed: 'Pet' in: model) subSchemas isEmpty
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testMergesInlineSchemasFalseKeepsEveryInlineSchema [

	| model a |
	model := self importWithoutMerging: self twinInlineJson.
	a := self componentSchemaNamed: 'A' in: model.
	self assert: (self mergedSchemaOf: a property: 'x')
		~~ (self mergedSchemaOf: a property: 'y').
	self assert: (self schemasIn: model) size equals: 3.
	self assert: ((self schemasIn: model) allSatisfy: [ :each |
			 each mergedPointers isEmpty ])
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testMergesInlineSchemasFalseKeepsTheInlineSchemaEqualToAComponent [

	| model holder name |
	model := self importWithoutMerging: self inlineEqualToComponentJson.
	holder := self componentSchemaNamed: 'Holder' in: model.
	name := self componentSchemaNamed: 'Name' in: model.
	self assert: (self mergedSchemaOf: holder property: 'n') ~~ name.
	self assert: name mergedPointers isEmpty.
	self assert: (self schemasIn: model) size equals: 3
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testMergesInlineSchemasFalseReportsNothingMerged [

	| report |
	self importWithoutMerging: self tripletInlineJson.
	report := importer mergeReport.
	self assert: (report at: #merged) equals: 0.
	self assert: (report at: #subSchemas) equals: 0
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testMergingIsEnabledByDefault [

	self assert: FamixOpenApiImporter new mergesInlineSchemas
]

{ #category : 'tests - merge across operations (step B)' }
FamixOpenApiMergeTest >> testMergingKeepsMediaTypesDistinct [
	"Two media types whose inline schema is the same share the schema, not the MediaType."

	| model content |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`post`:{`operationId`:`opA`,`requestBody`:{`content`:{`application/json`:{`schema`:{`type`:`string`}},`text/plain`:{`schema`:{`type`:`string`}}}},`responses`:{`200`:{`description`:`ok`}}}}}'.
	content := (self operationWithId: 'opA' in: model) requestBody
		           content.
	self assert: content size equals: 2.
	self assert: (content collect: #schema) asSet size equals: 1
]

{ #category : 'tests - merge across operations (step B)' }
FamixOpenApiMergeTest >> testParameterSchemaEqualToAComponentMergesIntoTheComponent [

	| model |
	model := self importOpenApi3:
		         '`paths`:{`/a`:{`get`:{`operationId`:`opA`,`parameters`:[{`name`:`p`,`in`:`query`,`schema`:{`type`:`string`,`maxLength`:9}}],`responses`:{`200`:{`description`:`ok`}}}}},`components`:{`schemas`:{`Short`:{`type`:`string`,`maxLength`:9}}}'.
	self assert:
		(self operationWithId: 'opA' in: model) parameters anyOne schema
		== (self componentSchemaNamed: 'Short' in: model).
	self assert: (self schemasIn: model) size equals: 1
]

{ #category : 'tests - index and options' }
FamixOpenApiMergeTest >> testReferenceToAMergedPointerResolvesToTheSurvivor [
	"A $ref written toward the pointer of a merged inline schema reaches the surviving entity."

	| model a z |
	model := self importOpenApi3: (self schemasJson:
			          '`A`:{`type`:`object`,`properties`:{`x`:{`type`:`string`},`y`:{`type`:`string`}}},`Z`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/A/properties/y`}},`W`:{`type`:`array`,`items`:{`$ref`:`#/components/schemas/A/properties/x`}}').
	a := self componentSchemaNamed: 'A' in: model.
	z := self componentSchemaNamed: 'Z' in: model.
	self assert: z items == (self mergedSchemaOf: a property: 'x').
	self assert:
		(self componentSchemaNamed: 'W' in: model) items == z items.
	self assert: importer diagnostics hasErrors not
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testReferrersOfAMergedSchemaAreRepointedToTheSurvivor [
	"Every property that held a merged inline schema now holds the surviving entity, which knows all its referrers."

	| model a merged |
	model := self importOpenApi3: self tripletInlineJson.
	a := self componentSchemaNamed: 'A' in: model.
	merged := self mergedSchemaOf: a property: 'x'.
	a properties do: [ :each | self assert: each valueSchema == merged ].
	self assert: merged usedAsPropertyValueBy size equals: 3
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testSchemaWithAnExtraPropertyOrAnotherTypeIsNotASubSchema [

	| model |
	model := self importOpenApi3: self notASubSetJson.
	self assert:
		(model allWithType: (self generatedClassNamed: #SubSchema)) isEmpty.
	self assert:
		(self componentSchemaNamed: 'Pet' in: model) subSchemas isEmpty
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testSchemasThatDifferByOneKeywordAreNotMerged [

	| model schemas |
	model := self importOpenApi3: (self schemasJson:
			          '`A`:{`type`:`object`,`properties`:{`p`:{`type`:`string`},`q`:{`type`:`string`,`format`:`uuid`},`r`:{`type`:`string`,`maxLength`:3},`s`:{`type`:`string`,`enum`:[`a`]},`t`:{`type`:`integer`}}}').
	schemas := (self componentSchemaNamed: 'A' in: model) properties
		           collect: #valueSchema.
	self assert: schemas asSet size equals: 5.
	self assert: (self schemasIn: model) size equals: 6
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testSubSchemaIsASchemaButNotListedByAllWithType [
	"allWithSubTypesOf: lists the SubSchemas, allWithType: leaves them out."

	| model schemaClass |
	model := self importOpenApi3: self subSetOfComponentJson.
	schemaClass := self generatedClassNamed: #Schema.
	self
		assert: (model allWithSubTypesOf: schemaClass) size
		equals: (model allWithType: schemaClass) size + 1
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testSubSchemaIsStillReachedThroughItsReferrer [

	| model holder inline |
	model := self importOpenApi3: self subSetOfComponentJson.
	holder := self componentSchemaNamed: 'Holder' in: model.
	inline := self mergedSchemaOf: holder property: 'pet'.
	self assert: inline usedAsPropertyValueBy size equals: 1.
	self assert: inline usedAsPropertyValueBy anyOne schema == holder
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testSubSchemaKeepsItsOwnPointerAndItsOwnProperties [

	| model holder inline |
	model := self importOpenApi3: self subSetOfComponentJson.
	holder := self componentSchemaNamed: 'Holder' in: model.
	inline := self mergedSchemaOf: holder property: 'pet'.
	self
		assert: inline canonicalPointer
		equals: '#/components/schemas/Holder/properties/pet'.
	self
		assert: (inline properties collect: #name) asSet
		equals: #( 'id' 'name' ) asSet.
	self assert: inline types asArray equals: #( 'object' )
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testThreeIdenticalInlineSchemasListTwoMergedPointers [

	| model merged |
	model := self importOpenApi3: self tripletInlineJson.
	merged := self
		          mergedSchemaOf: (self componentSchemaNamed: 'A' in: model)
		          property: 'x'.
	self assert: (self schemasIn: model) size equals: 2.
	self assert: merged mergedPointers size equals: 2.
	self assert: merged mergedPointers asSet size equals: 2.
	self deny: (merged mergedPointers includes: merged canonicalPointer)
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testTwoIdenticalInlineSchemasBecomeOneEntity [

	| model a |
	model := self importOpenApi3: self twinInlineJson.
	a := self componentSchemaNamed: 'A' in: model.
	self assert: (self mergedSchemaOf: a property: 'x')
		== (self mergedSchemaOf: a property: 'y').
	self assert: (self schemasIn: model) size equals: 2.
	self assert: a properties size equals: 2
]

{ #category : 'tests - SubSchema' }
FamixOpenApiMergeTest >> testTwoIdenticalSubSchemasMergeIntoOneSubSchema [

	| model holder first second |
	model := self importOpenApi3: (self schemasJson:
			          '`Pet`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`},`name`:{`type`:`string`},`tag`:{`type`:`string`}}},`Holder`:{`type`:`object`,`properties`:{`one`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}},`two`:{`type`:`object`,`properties`:{`id`:{`type`:`integer`}}}}}').
	holder := self componentSchemaNamed: 'Holder' in: model.
	first := self mergedSchemaOf: holder property: 'one'.
	second := self mergedSchemaOf: holder property: 'two'.
	self assert: first == second.
	self assert: first mergedPointers size equals: 1.
	self
		assert: (self componentSchemaNamed: 'Pet' in: model) subSchemas size
		equals: 1
]

{ #category : 'tests - merge identical inline schemas' }
FamixOpenApiMergeTest >> testUnmergedSchemaHasNoMergedPointers [

	| model |
	model := self importOpenApi3: self twinInlineJson.
	self assert:
		(self componentSchemaNamed: 'A' in: model) mergedPointers isEmpty
]

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> tripletInlineJson [

	^ self schemasJson:
		  '`A`:{`type`:`object`,`properties`:{`x`:{`type`:`string`},`y`:{`type`:`string`},`z`:{`type`:`string`}}}'
]

{ #category : 'fixtures' }
FamixOpenApiMergeTest >> twinInlineJson [
	"Two identical inline schemas, the properties x and y of A."

	^ self schemasJson:
		  '`A`:{`type`:`object`,`properties`:{`x`:{`type`:`string`},`y`:{`type`:`string`}}}'
]
