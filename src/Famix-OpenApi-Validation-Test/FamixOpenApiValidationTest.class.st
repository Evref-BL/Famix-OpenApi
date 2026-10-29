"
Intentionally minimal smoke tests of the validation package skeleton: they only check that the entry point answers a description and that the model package is loadable.
"
Class {
	#name : 'FamixOpenApiValidationTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiValidationTest >> testDescriptionIsNotEmptyString [
	"Intentionally minimal smoke test."

	| description |
	description := FamixOpenApiValidation description.
	self assert: description isString.
	self deny: description isEmpty
]

{ #category : 'tests' }
FamixOpenApiValidationTest >> testModelPackageIsLoadable [
	"Intentionally minimal smoke test: the generated model must be loaded."

	self assert: (Smalltalk includesKey: #OPInfo)
]
