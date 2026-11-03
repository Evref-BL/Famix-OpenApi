"
The mutation sweeps of the value check: for the rich documents of each version and the fixtures of the existence check, every slot that the check compares is changed in turn to a value that is not equivalent to the expected one (FamixOpenApiValueComparator>>aDifferentValueFrom:, or one element more or less for a count) and the check of its node must report exactly that slot, with its expected and found values; and every comparator is exercised. A slot changed to what it already holds (the control) gives no gap.
"
Class {
	#name : 'FamixOpenApiValueSweepTest',
	#superclass : 'FamixOpenApiValueTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiValueSweepTest >> defaultTimeLimit [
	"The sweeps change every slot of the rich documents in turn: they error under the default 10 seconds when the machine is loaded"

	^ 2 minutes
]

{ #category : 'tests' }
FamixOpenApiValueSweepTest >> testAChangedSlotThatNoRuleReadsIsNotDetected [
	"The names that are structural are not compared, and nothing else is invented"

	| model check |
	model := self modelOf: self documentValues30.
	check := self valueCheckOf: self documentValues30 model: model.
	(self entity: OPInfo at: '#/info' in: model) name: 'something else'.
	self assert:
		(check checkOnly: (check expandedInventory nodeAt: '#/info')) gaps
			isEmpty.
	(self entity: OPInfo at: '#/info' in: model) title: 'something else'.
	self deny:
		(check checkOnly: (check expandedInventory nodeAt: '#/info')) gaps
			isEmpty
]

{ #category : 'tests' }
FamixOpenApiValueSweepTest >> testASlotChangedToWhatItHoldsIsNotAGap [
	"The control of the sweeps: the check is not sensitive to a slot it does not compare"

	| check |
	check := self valueCheckOf: self documentValues30.
	check comparisons copy do: [ :each |
		each comparator gapKind == #valueMismatch ifTrue: [
			each entity
				perform: (each rule selector , ':') asSymbol
				with: each rawFound.
			self assert: (check checkOnly: each node) gaps isEmpty ] ]
]

{ #category : 'tests' }
FamixOpenApiValueSweepTest >> testEveryComparatorIsExercisedByTheSweepsOfTheFixtures [

	| names |
	names := self allDocuments , {
		         ('values30' -> self documentValues30).
		         ('values31' -> self documentValues31).
		         ('valuesSwagger2' -> self documentValuesSwagger2) }
		         flatCollect: [ :each |
			         (self valueCheckOf: each value) comparisons collect: [
				         :comparison | comparison rule comparatorName ] ]
		         as: Set.
	self assert: names equals: FamixOpenApiValueComparator allNames asSet
]

{ #category : 'tests' }
FamixOpenApiValueSweepTest >> testEverySlotOfTheFixturesOfTheExistenceCheckIsDetectedWhenItIsChanged [

	| killed |
	killed := self allDocuments inject: 0 into: [ :sum :each |
		          sum
		          + (self assertValueSweepIn: each value named: each key) ].
	self assert: killed > 5000
]

{ #category : 'tests' }
FamixOpenApiValueSweepTest >> testEverySlotOfTheRichDocumentsIsDetectedWhenItIsChanged [

	| killed |
	killed := (self
		           assertValueSweepIn: self documentValues30
		           named: 'values30')
	          +
	          (self
		           assertValueSweepIn: self documentValues31
		           named: 'values31') + (self
		           assertValueSweepIn: self documentValuesSwagger2
		           named: 'valuesSwagger2').
	self assert: killed > 900
]
