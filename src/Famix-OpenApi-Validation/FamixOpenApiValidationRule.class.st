"
Abstract rule of the model coherence validator: it checks one invariant that the importer must guarantee on an imported OPModel (NOT the completeness of the source OpenAPI document) and records FamixOpenApiFinding objects. Protocol: `code` (stable Symbol of the findings), `description`, `severity` are subclass responsibilities; `checkModel:into:` is the entry point called by the validator and by default evaluates `check:into:` (a no-op hook by default) on every entity of the model, so a per-entity rule only implements `check:into:`; a model-wide rule overrides `checkModel:into:` instead. Registry: `FamixOpenApiValidationRule class>>allRules` answers one instance of every concrete subclass (those not answering true to `isAbstract`), sorted by class name. Subclass discovery (allSubclasses) was chosen over a class-side pragma because it needs no declaration beyond the subclassing itself, cannot be forgotten, and the order is deterministic by sorting.
"
Class {
	#name : 'FamixOpenApiValidationRule',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'registry' }
FamixOpenApiValidationRule class >> allRules [
	"Answer one instance of every concrete rule, in a deterministic order (sorted by class name)."

	^ self concreteRuleClasses collect: [ :each | each new ]
]

{ #category : 'registry' }
FamixOpenApiValidationRule class >> concreteRuleClasses [
	"Answer the concrete rule classes, sorted by class name."

	^ (self allSubclasses reject: [ :each | each isAbstract ]) sorted: [
		  :a
		  :b | a name <= b name ]
]

{ #category : 'testing' }
FamixOpenApiValidationRule class >> isAbstract [
	"Answer whether the receiver is an abstract rule, ignored by the registry."

	^ self == FamixOpenApiValidationRule
]

{ #category : 'checking' }
FamixOpenApiValidationRule >> addFindingTo: aFindings entity: anEntity message: aString [
	"Record in aFindings a finding with the code and the severity of the receiver."

	| finding |
	finding := FamixOpenApiFinding
		           severity: self severity
		           code: self code
		           entity: anEntity
		           message: aString.
	aFindings add: finding.
	^ finding
]

{ #category : 'checking' }
FamixOpenApiValidationRule >> check: anEntity into: aFindings [
	"Check anEntity and record the violations in aFindings. Implemented by the per-entity rules; does nothing by default, so that a model-wide rule only overrides #checkModel:into:."

	
]

{ #category : 'checking' }
FamixOpenApiValidationRule >> checkModel: aModel into: aFindings [
	"Check aModel and record the violations in aFindings. By default evaluate #check:into: on every entity of aModel."

	aModel allModelEntities do: [ :each |
		self check: each into: aFindings ]
]

{ #category : 'description' }
FamixOpenApiValidationRule >> code [
	"Answer the stable Symbol of the findings of the receiver."

	^ self subclassResponsibility
]

{ #category : 'description' }
FamixOpenApiValidationRule >> description [
	"Answer the String describing the invariant checked."

	^ self subclassResponsibility
]

{ #category : 'description' }
FamixOpenApiValidationRule >> name [
	"Answer the name of the class of the receiver."

	^ self class name
]

{ #category : 'description' }
FamixOpenApiValidationRule >> severity [
	"Answer the default severity (#error, #warning or #info) of the findings of the receiver."

	^ self subclassResponsibility
]
