"
Tests of the model coherence validator infrastructure and rules (see the class of the same name without Test).
"
Class {
	#name : 'FamixOpenApiFindingTest',
	#superclass : 'FamixOpenApiValidatorTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiFindingTest >> finding [

	^ FamixOpenApiFinding
		  severity: #warning
		  code: #orphanEntity
		  entity: nil
		  message: 'lonely'
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testAccessors [

	| finding |
	finding := self finding.
	self assert: finding severity equals: #warning.
	self assert: finding code equals: #orphanEntity.
	self assert: finding message equals: 'lonely'.
	self assert: finding entity isNil
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testDifferentPartsMakeFindingsDifferent [

	| other |
	other := FamixOpenApiFinding
		         severity: #error
		         code: #orphanEntity
		         entity: nil
		         message: 'lonely'.
	self deny: other equals: self finding.
	other := FamixOpenApiFinding
		         severity: #warning
		         code: #orphanEntity
		         entity: OPSchema new
		         message: 'lonely'.
	self deny: other equals: self finding
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testEqualityAndHash [

	self assert: self finding equals: self finding.
	self assert: self finding hash equals: self finding hash
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testPointerIsEmptyWhenTheEntityHasNoCanonicalPointer [

	| finding |
	finding := FamixOpenApiFinding
		           severity: #error
		           code: #x
		           entity: OPSchema new
		           message: 'm'.
	self assert: finding pointer equals: ''
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testPointerIsEmptyWithoutEntity [

	self assert: self finding pointer equals: ''
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testPointerIsTheCanonicalPointerOfTheEntity [

	| schema finding |
	schema := OPSchema new
		          name: 'Pet';
		          yourself.
	schema canonicalPointer: '#/components/schemas/Pet'.
	finding := FamixOpenApiFinding
		           severity: #error
		           code: #x
		           entity: schema
		           message: 'm'.
	self assert: finding pointer equals: '#/components/schemas/Pet'.
	self assert: finding entity identicalTo: schema
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testPrintOn [

	self
		assert: self finding printString
		equals: 'warning orphanEntity at : lonely'
]

{ #category : 'tests' }
FamixOpenApiFindingTest >> testSeverityPredicates [

	self assert: self finding isWarning.
	self deny: self finding isError.
	self deny: self finding isInfo
]
