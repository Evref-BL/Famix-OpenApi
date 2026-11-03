"
Tests of the comparator table of the value check (FamixOpenApiValueRules): every row names a comparator and an OP class that exist and understand the slot and its setter, no row is about a field that the conformance says is not modelled, the fields compared are the ones the conformance maps to a slot, the names are compared only where they are the source value, and the reasons why the other fields are not compared.
"
Class {
	#name : 'FamixOpenApiValueRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'conformanceRows'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> comparatorsOfMaximumIn: aVersion [
	"The names of the comparators of the key maximum of a schema"

	^ (FamixOpenApiValueRules rulesFor: 'Schema' in: aVersion)
		  select: [ :each | each fieldKey = 'maximum' ]
		  thenCollect: #comparatorName
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> conformanceRowFor: aRule in: aVersion [

	^ self conformanceRows
		  detect: [ :row |
			  row version = aVersion and: [
				  row specObject = aRule specObject and: [
					  row fieldName = aRule fieldKey ] ] ]
		  ifNone: [ nil ]
]

{ #category : 'helpers' }
FamixOpenApiValueRulesTest >> conformanceRows [
	"The rows of the conformance check, computed once"

	^ conformanceRows ifNil: [ conformanceRows := FamixOpenApiMetamodelConformance check rows ]
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> hasSpecObject: aName in: aVersion [

	^ self conformanceRows anySatisfy: [ :row |
		  row version = aVersion and: [ row specObject = aName ] ]
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testEveryComparatorIsUsedByARule [

	self
		assert: FamixOpenApiValueComparator allNames asSet
		equals:
		(FamixOpenApiValueRules rules collect: #comparatorName) asSet
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testEveryRuleNamesAComparatorThatExists [

	FamixOpenApiValueRules rules do: [ :each |
		self
			assert:
			(FamixOpenApiValueComparator allNames includes: each comparatorName)
			description: each printString.
		self assert: each comparator name equals: each comparatorName ]
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testEveryRuleTargetsASlotOfAnExistingClassWithItsSetter [

	FamixOpenApiValueRules rules do: [ :each |
		| class |
		class := Smalltalk at: each targetClassName asSymbol.
		self
			assert: (class canUnderstand: each selector)
			description: each printString.
		self
			assert: (class canUnderstand: (each selector , ':') asSymbol)
			description: each printString ]
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testNamesAreComparedOnlyWhereTheyAreTheSourceValue [

	self
		assert: (FamixOpenApiValueRules rules
				 select: [ :each | each selector = #name ]
				 thenCollect: #specObject) asSet
		equals: #( 'Tag' 'Parameter' 'Contact' 'License' 'XML' ) asSet
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testNoRuleIsAboutAFieldTheConformanceSaysIsNotModelled [

	self conformanceRows do: [ :row |
		row isNotModelled ifTrue: [
			self
				deny:
					((FamixOpenApiValueRules rulesFor: row specObject in: row version)
						 anySatisfy: [ :each | each fieldKey = row fieldName ])
				description: row printString ] ]
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testRulesForASpecObjectAndVersionAreTheOnesOfThatVersion [

	self
		assert:
		((FamixOpenApiValueRules rulesFor: 'Info' in: #v2) collect:
			 #fieldKey)
		equals: #( 'title' 'description' 'termsOfService' 'version' ).
	self
		assert:
			((FamixOpenApiValueRules rulesFor: 'OpenAPI' in: #v2) collect:
				 #fieldKey)
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testTheBoundsOfOpenApi30AndSwagger2AreMovedAndTheOnesOf31AreNumbers [

	self
		assert: (self comparatorsOfMaximumIn: #v30)
		equals: #( #inclusiveMaximum ).
	self
		assert: (self comparatorsOfMaximumIn: #v2)
		equals: #( #inclusiveMaximum ).
	self assert: (self comparatorsOfMaximumIn: #v31) equals: #( #number )
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testTheDeferredSlotsAreTheOnesOfAReference [
	"Reference.summary and Reference.description of OpenAPI 3.1: the entity (OPReference) exists only for a $ref that does not resolve"

	| deferred |
	deferred := self conformanceRows select: [
		            :row |
		            row status ~~ #notApplicable and: [
			            (FamixOpenApiValueRules reasonNotComparedFor: row)
			            = 'deferred slot' ] ].
	self
		assert:
			(deferred collect: [ :row | row specObject , '.' , row fieldName ])
				asSet
		equals: #( 'Reference.summary' 'Reference.description' ) asSet
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testTheReasonsAreTheDocumentedOnes [

	| reasons |
	reasons := Set new.
	self conformanceRows do: [ :row |
		row status == #notApplicable ifFalse: [
			reasons add: (FamixOpenApiValueRules reasonNotComparedFor: row) ] ].
	self assert: reasons equals: (Set withAll:
			 { nil. 'extension (V9)'. 'notModelled (V9)'. 'relation (V10)'.
			 'deferred slot'. 'implicit: structure (V10)' })
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testTheRulesOfAFieldAreForVersionsInWhichTheConformanceHasIt [
	"For the versions in which the spec object exists. The pseudo fields (the key in braces, the $ref of a site that a clone replaced, the formData parameters of an operation) have no conformance row of their own"

	FamixOpenApiValueRules rules do: [ :rule |
		(#( '$ref' 'parameters' ) includes: rule fieldKey)
		| (rule fieldKey first = ${) ifFalse: [
			#( #v30 #v31 #v2 ) do: [ :version |
				((rule appliesTo: version) and: [
					 self hasSpecObject: rule specObject in: version ]) ifTrue: [
					self
						assert: (self conformanceRowFor: rule in: version) isNotNil
						description: rule printString , ' ' , version ] ] ] ]
]

{ #category : 'tests' }
FamixOpenApiValueRulesTest >> testTheSlotOfASlotRowIsTheOneOfTheConformanceExceptForTheVersionOfOpenApi [
	"The importer keeps the text of the source version in sourceVersion; the conformance says openapiVersion, which is the version it normalises to (3.1.0): the rule compares the source text with sourceVersion"

	| differences |
	differences := OrderedCollection new.
	FamixOpenApiValueRules rules do: [ :rule |
		(self conformanceRowFor: rule in: #v30) ifNotNil: [ :row |
			(row status == #modelledSlot and: [
				 (rule appliesTo: #v30) and: [
					 row targetClassName = rule targetClassName and: [
						 row targetSelector ~= rule selector ] ] ]) ifTrue: [
				differences add: rule ] ] ].
	self
		assert:
			(differences collect: [ :each |
				 each specObject , '.' , each fieldKey ]) asArray
		equals: #( 'OpenAPI.openapi' )
]
