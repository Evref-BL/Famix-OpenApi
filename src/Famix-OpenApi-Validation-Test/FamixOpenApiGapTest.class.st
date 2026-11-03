"
Tests of FamixOpenApiGap: the expected and found values it keeps in a FamixOpenApiGapValues (to stay below ten instance variables), its default values and its printing.
"
Class {
	#name : 'FamixOpenApiGapTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiGapTest >> testAGapKeepsItsExpectedAndFoundValues [

	| gap |
	gap := FamixOpenApiGap
		       kind: #valueMismatch
		       pointer: '#/info'
		       specObject: 'Info'.
	gap
		expected: 'a';
		found: 1.
	self assert: gap expected equals: 'a'.
	self assert: gap found equals: 1
]

{ #category : 'tests' }
FamixOpenApiGapTest >> testAGapPrintsItsKindPointerAndValues [

	| gap |
	gap := FamixOpenApiGap
		       kind: #valueMismatch
		       pointer: '#/info'
		       specObject: 'Info'.
	gap
		expected: 'a';
		found: 'b'.
	self
		assert: gap printString
		equals: 'valueMismatch #/info (Info): expected ''a'', found ''b'''
]

{ #category : 'tests' }
FamixOpenApiGapTest >> testANewGapHoldsNoValues [

	| gap |
	gap := FamixOpenApiGap new.
	self assert: gap expected isNil.
	self assert: gap found isNil
]

{ #category : 'tests' }
FamixOpenApiGapTest >> testTwoGapsDoNotShareTheirValues [

	| first second |
	first := FamixOpenApiGap new
		         expected: 1;
		         yourself.
	second := FamixOpenApiGap new
		          expected: 2;
		          yourself.
	self assert: first expected equals: 1.
	self assert: second expected equals: 2
]
