"
Unit tests of the comparators of the value check on small source nodes: the applicability (compared, not applicable, wrong type), the expected value for the absent key, the explicit value and the other JSON types, the equivalences (nil and false, 1 and 1.0, the order of the keys of a JSON text), the conversions and the values that the mutation sweeps put in a slot.
"
Class {
	#name : 'FamixOpenApiValueComparatorTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiValueComparatorTest >> contextIn: aVersion [

	^ FamixOpenApiValueContextStub new
		  version: aVersion;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiValueComparatorTest >> expectedIn: aVersion of: aJsonObjectText key: aKey by: aName [
	"The first expected value of the comparator"

	^ ((FamixOpenApiValueComparator named: aName)
		   entriesOf: (self nodeOf: aJsonObjectText)
		   rule: (self ruleFor: aKey comparator: aName)
		   context: (self contextIn: aVersion)) first value
]

{ #category : 'helpers' }
FamixOpenApiValueComparatorTest >> expectedOf: aJsonObjectText key: aKey by: aName [

	^ self
		  expectedIn: #v31
		  of: aJsonObjectText
		  key: aKey
		  by: aName
]

{ #category : 'helpers' }
FamixOpenApiValueComparatorTest >> nodeOf: aJsonObjectText [
	"The node of an object of the source, at #/info of an OpenAPI 3.1 document"

	^ (FamixOpenApiSourceWalker new walkString:
		   '{"openapi":"3.1.0","info":' , aJsonObjectText , '}') nodeAt:
		  '#/info'
]

{ #category : 'helpers' }
FamixOpenApiValueComparatorTest >> ruleFor: aKey comparator: aName [

	^ FamixOpenApiValueRule
		  specObject: 'Info'
		  className: 'OPInfo'
		  row: {
				  aKey.
				  #title.
				  aName }
]

{ #category : 'helpers' }
FamixOpenApiValueComparatorTest >> statusOf: aJsonObjectText key: aKey by: aName [
	"#compare, #notApplicable or #wrongType, in a document of OpenAPI 3.1"

	^ (FamixOpenApiValueComparator named: aName)
		  applicabilityOf: (self nodeOf: aJsonObjectText)
		  rule: (self ruleFor: aKey comparator: aName)
		  context: (self contextIn: #v31)
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testANumberIsWrongTypeWhenItIsAString [

	self
		assert:
		(self statusOf: '{"maxLength":"4"}' key: 'maxLength' by: #number)
		equals: #wrongType.
	self
		assert:
		(self statusOf: '{"maxLength":true}' key: 'maxLength' by: #number)
		equals: #wrongType
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testAStringListThatHoldsSomethingElseIsWrongType [

	self
		assert:
		(self statusOf: '{"tags":["a",1]}' key: 'tags' by: #stringList)
		equals: #wrongType.
	self
		assert: (self statusOf: '{"tags":"a"}' key: 'tags' by: #stringList)
		equals: #wrongType
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testBoundsOf30AreWrongTypeWhenTheNumberOrTheBooleanHasAnotherType [

	self
		assert:
		(self
			 statusOf: '{"maximum":"5"}'
			 key: 'maximum'
			 by: #inclusiveMaximum)
		equals: #wrongType.
	self
		assert: (self
				 statusOf: '{"maximum":5,"exclusiveMaximum":3}'
				 key: 'exclusiveMaximum'
				 by: #exclusiveMaximum)
		equals: #wrongType.
	self
		assert:
		(self statusOf: '{"maximum":5}' key: 'maximum' by: #inclusiveMaximum)
		equals: #compare
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testBoundsOf30MoveTheNumberToTheExclusiveSlotWhenTheBooleanIsTrue [

	self assert: (self
			 expectedOf: '{"maximum":5,"exclusiveMaximum":true}'
			 key: 'maximum'
			 by: #inclusiveMaximum) isNil.
	self
		assert: (self
				 expectedOf: '{"maximum":5,"exclusiveMaximum":true}'
				 key: 'exclusiveMaximum'
				 by: #exclusiveMaximum)
		equals: 5.
	self
		assert: (self
				 expectedOf: '{"maximum":5,"exclusiveMaximum":false}'
				 key: 'maximum'
				 by: #inclusiveMaximum)
		equals: 5.
	self assert: (self
			 expectedOf: '{"maximum":5,"exclusiveMaximum":false}'
			 key: 'exclusiveMaximum'
			 by: #exclusiveMaximum) isNil.
	self
		assert:
		(self
			 expectedOf: '{"minimum":2}'
			 key: 'minimum'
			 by: #inclusiveMinimum)
		equals: 2.
	self assert: (self
			 expectedOf: '{"exclusiveMinimum":true}'
			 key: 'exclusiveMinimum'
			 by: #exclusiveMinimum) isNil.
	self
		assert: (self
				 expectedOf: '{"minimum":2,"exclusiveMinimum":true}'
				 key: 'exclusiveMinimum'
				 by: #exclusiveMinimum)
		equals: 2
]

{ #category : 'tests - canonical text' }
FamixOpenApiValueComparatorTest >> testCanonicalTextKeepsTheUnicode [

	| text |
	text := 'dé→ü'.
	self
		assert: (NeoJSONReader fromString:
				 (FamixOpenApiJsonTextComparator canonicalTextOf: text))
		equals: text
]

{ #category : 'tests - canonical text' }
FamixOpenApiValueComparatorTest >> testCanonicalTextOfTheScalars [

	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: nil)
		equals: 'null'.
	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: true)
		equals: 'true'.
	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: false)
		equals: 'false'.
	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: 'a"b')
		equals: '"a\"b"'.
	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: #(  ))
		equals: '[]'
]

{ #category : 'tests - canonical text' }
FamixOpenApiValueComparatorTest >> testCanonicalTextSortsTheKeysOfTheObjects [

	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf:
				 (NeoJSONReader fromString:
					  '{"b":1,"a":{"d":[2,{"z":null,"y":true}],"c":"x"}}'))
		equals: '{"a":{"c":"x","d":[2,{"y":true,"z":null}]},"b":1}'
]

{ #category : 'tests - canonical text' }
FamixOpenApiValueComparatorTest >> testCanonicalTextWritesAWholeFloatAsAnInteger [

	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: 1.0)
		equals: (FamixOpenApiJsonTextComparator canonicalTextOf: 1).
	self
		assert:
		(FamixOpenApiJsonTextComparator canonicalTextOf: #( 1 2.5 -3.0 ))
		equals: '[1,2.5,-3]'.
	self
		assert: (FamixOpenApiJsonTextComparator canonicalTextOf: 1.5)
		equals: '1.5'
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testCountsAreTheSizeOfTheArrayAndWrongTypeForSomethingElseThanObjects [

	self
		assert: (self expectedOf: '{"tags":[{},{}]}' key: 'tags' by: #count)
		equals: 2.
	self assert: (self expectedOf: '{}' key: 'tags' by: #count) equals: 0.
	self
		assert: (self statusOf: '{}' key: 'servers' by: #explicitCount)
		equals: #notApplicable.
	self
		assert: (self statusOf: '{"tags":[1]}' key: 'tags' by: #count)
		equals: #wrongType.
	self assert: ((FamixOpenApiValueComparator named: #count)
			 isEquivalent: #( 1 2 )
			 to: 2).
	self assert:
		((FamixOpenApiValueComparator named: #count) isEquivalent: nil to: 0).
	self
		assert: (FamixOpenApiValueComparator named: #count) gapKind
		equals: #countMismatch
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testExplicitTextIsNotComparedWhenAbsent [

	self
		assert: (self statusOf: '{}' key: 'style' by: #explicitText)
		equals: #notApplicable.
	self
		assert:
		(self statusOf: '{"style":"form"}' key: 'style' by: #explicitText)
		equals: #compare.
	self
		assert:
		(self statusOf: '{"style":1}' key: 'style' by: #explicitText)
		equals: #wrongType
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testFlagAbsentAndFalseAreTheSameExpectedValueAndNilAndFalseTheSameFoundValue [

	| comparator |
	comparator := FamixOpenApiValueComparator named: #flag.
	self
		assert: (self expectedOf: '{}' key: 'deprecated' by: #flag)
		equals: false.
	self
		assert:
		(self expectedOf: '{"deprecated":false}' key: 'deprecated' by: #flag)
		equals: false.
	self
		assert:
		(self expectedOf: '{"deprecated":true}' key: 'deprecated' by: #flag)
		equals: true.
	self assert: (comparator isEquivalent: nil to: false).
	self assert: (comparator isEquivalent: false to: false).
	self deny: (comparator isEquivalent: nil to: true).
	self deny: (comparator isEquivalent: false to: true)
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testFlagIsWrongTypeWhenItIsNotABoolean [

	self
		assert:
		(self statusOf: '{"deprecated":"true"}' key: 'deprecated' by: #flag)
		equals: #wrongType.
	self
		assert:
		(self statusOf: '{"deprecated":1}' key: 'deprecated' by: #flag)
		equals: #wrongType.
	self
		assert: (self statusOf: '{}' key: 'deprecated' by: #explicitFlag)
		equals: #notApplicable
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testJsonTextIsExpectedAsCanonicalTextAndNilWhenAbsent [

	self
		assert: (self
				 expectedOf: '{"enum":[1,{"b":2.0,"a":null}]}'
				 key: 'enum'
				 by: #jsonText)
		equals: '[1,{"a":null,"b":2}]'.
	self
		assert:
		(self expectedOf: '{"default":null}' key: 'default' by: #jsonText)
		equals: 'null'.
	self
		assert:
		(self expectedOf: '{"default":"null"}' key: 'default' by: #jsonText)
		equals: '"null"'.
	self assert:
		(self expectedOf: '{}' key: 'default' by: #jsonText) isNil
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testJsonTextOfTheSlotIsParsedBeforeItIsCompared [

	| comparator |
	comparator := FamixOpenApiValueComparator named: #jsonText.
	self assert: (comparator
			 isEquivalent: '{ "b" : 2 , "a" : [1.0] }'
			 to: '{"a":[1],"b":2}').
	self assert: (comparator isEquivalent: 'null' to: 'null').
	self deny: (comparator isEquivalent: nil to: 'null').
	self deny: (comparator isEquivalent: '"x"' to: '"y"').
	self deny: (comparator isEquivalent: 'not json' to: '"not json"').
	self assert: (comparator foundFrom: 'not json') equals: 'not json'.
	self assert: (comparator foundFrom: 5) equals: '5'
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testNullableOfOpenApi30IsTheKeywordAndTheOneOf31IsTheTypeNull [

	self
		assert: (self
				 expectedIn: #v30
				 of: '{"nullable":true}'
				 key: 'nullable'
				 by: #nullable30)
		equals: true.
	self
		assert: (self
				 expectedIn: #v30
				 of: '{"nullable":false}'
				 key: 'nullable'
				 by: #nullable30)
		equals: false.
	self
		assert: (self
				 expectedIn: #v30
				 of: '{}'
				 key: 'nullable'
				 by: #nullable30)
		equals: false.
	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":["string","null"]}'
				 key: 'type'
				 by: #nullable31)
		equals: true.
	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":"null"}'
				 key: 'type'
				 by: #nullable31)
		equals: true.
	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":"string","nullable":true}'
				 key: 'type'
				 by: #nullable31)
		equals: false.
	self
		assert: (self
				 expectedIn: #v31
				 of: '{}'
				 key: 'type'
				 by: #nullable31)
		equals: false
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testNumbersAreEquivalentByValue [

	| comparator |
	comparator := FamixOpenApiValueComparator named: #number.
	self
		assert:
		(self expectedOf: '{"maxLength":1.0}' key: 'maxLength' by: #number)
		equals: 1.
	self assert: (comparator isEquivalent: 1 to: 1.0).
	self assert: (comparator isEquivalent: 2.5 to: 2.5).
	self deny: (comparator isEquivalent: 1 to: 2).
	self deny: (comparator isEquivalent: nil to: 0).
	self assert:
		(self expectedOf: '{}' key: 'maxLength' by: #number) isNil
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testScopesGiveOneEntryPerStringDescriptionAtTheEscapedPointer [

	| entries |
	entries := (FamixOpenApiValueComparator named: #scopes)
		           entriesOf:
		           (self nodeOf: '{"scopes":{"a":"da","t/u":"du","n":5}}')
		           rule: (self ruleFor: 'scopes' comparator: #scopes)
		           context: (self contextIn: #v31).
	self assert: entries asArray equals: {
			('/scopes/a' -> 'da').
			('/scopes/t~1u' -> 'du') }
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testStringListIsComparedInOrderWithDuplicates [

	| comparator |
	comparator := FamixOpenApiValueComparator named: #stringList.
	self
		assert:
		(self
			 expectedOf: '{"tags":["b","a","b"]}'
			 key: 'tags'
			 by: #stringList)
		equals: #( 'b' 'a' 'b' ).
	self
		assert: (self expectedOf: '{}' key: 'tags' by: #stringList)
		equals: #(  ).
	self assert: (comparator isEquivalent: nil to: #(  )).
	self assert: (comparator
			 isEquivalent: #( 'b' 'a' ) asOrderedCollection
			 to: #( 'b' 'a' )).
	self deny: (comparator isEquivalent: #( 'a' 'b' ) to: #( 'b' 'a' ))
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testTextIsComparedWhenAStringOrAbsentAndWrongTypeOtherwise [

	self
		assert: (self statusOf: '{"title":"t"}' key: 'title' by: #text)
		equals: #compare.
	self
		assert: (self statusOf: '{}' key: 'title' by: #text)
		equals: #compare.
	self
		assert: (self statusOf: '{"title":5}' key: 'title' by: #text)
		equals: #wrongType.
	self
		assert: (self statusOf: '{"title":null}' key: 'title' by: #text)
		equals: #wrongType.
	self
		assert: (self statusOf: '{"title":["a"]}' key: 'title' by: #text)
		equals: #wrongType
]

{ #category : 'tests - scalars' }
FamixOpenApiValueComparatorTest >> testTextIsExpectedVerbatimAndNilWhenAbsent [

	self
		assert: (self expectedOf: '{"title":"dé→ü"}' key: 'title' by: #text)
		equals: 'dé→ü'.
	self assert: (self expectedOf: '{}' key: 'title' by: #text) isNil
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTheBoundsAreCompatibleWithTheNumbersOf31 [
	"In OpenAPI 3.1 both keys are numbers: the number comparator, no move"

	self
		assert: (self
				 expectedOf: '{"maximum":5,"exclusiveMaximum":9}'
				 key: 'exclusiveMaximum'
				 by: #number)
		equals: 9.
	self
		assert: (self
				 expectedOf: '{"maximum":5,"exclusiveMaximum":9}'
				 key: 'maximum'
				 by: #number)
		equals: 5
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTheCollectionFormatsGiveAStyleAndAnExplodeExceptTheTabSeparated [

	#( #( 'csv' 'form' false ) #( 'multi' 'form' true )
	   #( 'ssv' 'spaceDelimited' false )
	   #( 'pipes' 'pipeDelimited' false )
	   #( 'tsv' nil nil ) #( 'foo' nil nil ) ) do: [ :row |
		| json |
		json := '{"collectionFormat":"' , row first , '"}'.
		self
			assert:
			(self expectedOf: json key: 'collectionFormat' by: #collectionStyle)
			equals: (row at: 2).
		self
			assert:
			(self
				 expectedOf: json
				 key: 'collectionFormat'
				 by: #collectionExplode)
			equals: (row at: 3) ].
	self assert:
		(self expectedOf: '{}' key: 'collectionFormat' by: #collectionStyle)
			isNil
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTheExplodeOfACollectionFormatIsComparedExactly [

	| comparator |
	comparator := FamixOpenApiValueComparator named: #collectionExplode.
	self deny: (comparator isEquivalent: nil to: false).
	self assert: (comparator isEquivalent: false to: false)
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTheSwagger2ConversionsAreTheVerifiedOnes [

	self
		assert:
		(self expectedOf: '{"type":"basic"}' key: 'type' by: #securityTypeV2)
		equals: 'http'.
	self
		assert:
		(self
			 expectedOf: '{"type":"apiKey"}'
			 key: 'type'
			 by: #securityTypeV2)
		equals: 'apiKey'.
	self
		assert:
		(self expectedOf: '{"type":"basic"}' key: 'type' by: #basicSchemeV2)
		equals: 'basic'.
	self assert:
		(self expectedOf: '{"type":"oauth2"}' key: 'type' by: #basicSchemeV2)
			isNil.
	self
		assert:
		(self
			 expectedOf: '{"flow":"accessCode"}'
			 key: 'flow'
			 by: #flowTypeV2)
		equals: 'authorizationCode'.
	self
		assert:
		(self
			 expectedOf: '{"flow":"application"}'
			 key: 'flow'
			 by: #flowTypeV2)
		equals: 'clientCredentials'.
	self
		assert:
		(self expectedOf: '{"flow":"implicit"}' key: 'flow' by: #flowTypeV2)
		equals: 'implicit'.
	self
		assert:
		(self expectedOf: '{"flow":"password"}' key: 'flow' by: #flowTypeV2)
		equals: 'password'.
	self assert:
		(self expectedOf: '{}' key: 'flow' by: #flowTypeV2) isNil
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTheValueAMutationPutsInASlotIsNeverEquivalentToTheExpectedValue [

	#( #( #text nil ) #( #text 'x' ) #( #text '' ) #( #flag false )
	   #( #flag true ) #( #number nil ) #( #number 0 ) #( #number 2.5 )
	   #( #jsonText nil ) #( #jsonText 'null' ) #( #jsonText '[1]' )
	   #( #stringList #(  ) ) #( #stringList #( 'a' ) )
	   #( #types #(  ) ) #( #types #( 'a' ) ) #( #nullable30 true )
	   #( #inclusiveMaximum nil ) #( #inclusiveMaximum 3 )
	   #( #collectionExplode nil ) #( #collectionExplode
	      false ) #( #securityTypeV2 'http' ) #( #key 'get' ) #( #referenceText nil )
	   #( #referenceText '#/a' ) ) do: [ :row |
		| comparator |
		comparator := FamixOpenApiValueComparator named: row first.
		self
			deny: (comparator
					 isEquivalent: (comparator aDifferentValueFrom: row second)
					 to: row second)
			description: row printString ]
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTypesOfOpenApi30AreTheStringAndAnArrayIsWrongType [

	self
		assert: (self
				 expectedIn: #v30
				 of: '{"type":"string"}'
				 key: 'type'
				 by: #types)
		equals: #( 'string' ).
	self
		assert: (self
				 expectedIn: #v30
				 of: '{}'
				 key: 'type'
				 by: #types)
		equals: #(  ).
	self
		assert: ((FamixOpenApiValueComparator named: #types)
				 applicabilityOf: (self nodeOf: '{"type":["string"]}')
				 rule: (self ruleFor: 'type' comparator: #types)
				 context: (self contextIn: #v30))
		equals: #wrongType
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testTypesOfOpenApi31AreTheStringsOfTheArrayWithoutNull [

	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":["integer","null","string"]}'
				 key: 'type'
				 by: #types)
		equals: #( 'integer' 'string' ).
	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":"null"}'
				 key: 'type'
				 by: #types)
		equals: #(  ).
	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":["string",5,"string"]}'
				 key: 'type'
				 by: #types)
		equals: #( 'string' 'string' ).
	self
		assert: (self
				 expectedIn: #v31
				 of: '{"type":[]}'
				 key: 'type'
				 by: #types)
		equals: #(  )
]

{ #category : 'tests - schema keywords' }
FamixOpenApiValueComparatorTest >> testUnknownComparatorNamesRaiseAnError [

	self
		should: [ FamixOpenApiValueComparator named: #noSuchComparator ]
		raise: Error
]
