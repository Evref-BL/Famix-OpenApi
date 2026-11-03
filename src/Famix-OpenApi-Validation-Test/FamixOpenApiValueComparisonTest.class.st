"
Tests of FamixOpenApiValueComparison: which expected values are informative (not a default, so that an equal slot is not an equality by chance).
"
Class {
	#name : 'FamixOpenApiValueComparisonTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> comparisonExpecting: anExpectedValue [

	^ FamixOpenApiValueComparison
		  rule: nil
		  node: nil
		  entry: '' -> anExpectedValue
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testBooleansAreInformativeOnlyWhenTrue [

	self deny: (self comparisonExpecting: false) isInformative.
	self assert: (self comparisonExpecting: true) isInformative
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testCollectionsAreInformativeWhenNotEmpty [

	self deny: (self comparisonExpecting: #(  )) isInformative.
	self deny:
		(self comparisonExpecting: OrderedCollection new) isInformative.
	self assert: (self comparisonExpecting: #( 'a' )) isInformative
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testJsonTextIsInformativeAsAnyText [
	"The JSON texts of the example, the default... are strings: even the text null (a default that is null) is a value"

	self assert:
		(self comparisonExpecting: '{"a":[1,2.5]}') isInformative.
	self assert: (self comparisonExpecting: 'null') isInformative.
	self assert: (self comparisonExpecting: '[]') isInformative
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testNilIsNeverInformative [

	self deny: (self comparisonExpecting: nil) isInformative
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testNumbersAreInformativeZeroIncluded [

	self assert: (self comparisonExpecting: 0) isInformative.
	self assert: (self comparisonExpecting: 3) isInformative.
	self assert: (self comparisonExpecting: 2.5) isInformative.
	self assert: (self comparisonExpecting: -1) isInformative
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testTextsAreInformativeWhenNotEmpty [

	self deny: (self comparisonExpecting: '') isInformative.
	self assert: (self comparisonExpecting: 'a') isInformative.
	self assert: (self comparisonExpecting: ' ') isInformative
]

{ #category : 'tests' }
FamixOpenApiValueComparisonTest >> testTheEntityPointerIsThePointerOfTheNodeAndTheSuffix [

	| comparison |
	comparison := FamixOpenApiValueComparison
		              rule: nil
		              node: (FamixOpenApiSourceNode new
				               pointer: '#/a';
				               yourself)
		              entry: '/b' -> 1.
	self assert: comparison entityPointer equals: '#/a/b'.
	self assert: comparison hasSuffix.
	self assert: comparison expected equals: 1
]
