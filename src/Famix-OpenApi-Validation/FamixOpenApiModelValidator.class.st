"
Runs the coherence rules (FamixOpenApiValidationRule) on an imported OPModel and answers a FamixOpenApiFindings. `validate:` uses every registered concrete rule, `validate:rules:` a subset given as rule classes. A rule that raises an Error does not abort the run: the exception is recorded as an #error finding with the code #ruleFailed whose message names the rule class. The validator is a pure function of the model: it never modifies it, never imports anything and never reads the importer diagnostics.
"
Class {
	#name : 'FamixOpenApiModelValidator',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'validating' }
FamixOpenApiModelValidator >> recordFailureOf: aRule because: anError into: aFindings [

	aFindings add: (FamixOpenApiFinding
			 severity: #error
			 code: #ruleFailed
			 entity: nil
			 message:
			 'Rule ' , aRule name , ' failed: ' , anError messageText asString)
]

{ #category : 'validating' }
FamixOpenApiModelValidator >> run: aRule on: aModel into: aFindings [

	[ aRule checkModel: aModel into: aFindings ]
		on: Error
		do: [ :error |
		self recordFailureOf: aRule because: error into: aFindings ]
]

{ #category : 'validating' }
FamixOpenApiModelValidator >> validate: aModel [
	"Answer the FamixOpenApiFindings of every registered rule on aModel."

	^ self
		  validate: aModel
		  rules: FamixOpenApiValidationRule concreteRuleClasses
]

{ #category : 'validating' }
FamixOpenApiModelValidator >> validate: aModel rules: aCollectionOfRuleClasses [
	"Answer the FamixOpenApiFindings of the rules of aCollectionOfRuleClasses on aModel, a failing rule being reported as a #ruleFailed error."

	| findings |
	findings := FamixOpenApiFindings new.
	aCollectionOfRuleClasses do: [ :each |
		self run: each new on: aModel into: findings ].
	^ findings
]
