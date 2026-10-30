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
FamixOpenApiValidationRule >> addFindingTo: aFindings entity: anEntity code: aCode message: aString [
	"Record in aFindings a finding of the severity of the receiver with the code aCode (one of #codes)."

	| finding |
	finding := FamixOpenApiFinding
		           severity: self severity
		           code: aCode
		           entity: anEntity
		           message: aString.
	aFindings add: finding.
	^ finding
]

{ #category : 'checking' }
FamixOpenApiValidationRule >> addFindingTo: aFindings entity: anEntity message: aString [
	"Record in aFindings a finding with the code and the severity of the receiver."

	^ self
		  addFindingTo: aFindings
		  entity: anEntity
		  code: self code
		  message: aString
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
FamixOpenApiValidationRule >> codes [
	"Answer the Symbols of every finding code the receiver can record (the primary #code by default; a rule recording several codes overrides it)."

	^ { self code }
]

{ #category : 'description' }
FamixOpenApiValidationRule >> description [
	"Answer the String describing the invariant checked."

	^ self subclassResponsibility
]

{ #category : 'metamodel' }
FamixOpenApiValidationRule >> isAnchorProperty: aProperty [
	"Answer whether aProperty is a relation that points from a child to its owner."

	aProperty type isPrimitive ifTrue: [ ^ false ].
	aProperty isContainer ifTrue: [ ^ true ].
	aProperty opposite ifNil: [ ^ false ].
	aProperty opposite isContainer ifTrue: [ ^ false ].
	^ self isBackPointer: aProperty
]

{ #category : 'metamodel' }
FamixOpenApiValidationRule >> isBackPointer: aProperty [
	"Answer whether aProperty is the reverse side of a non-containment relation: a usedBy/usedAs property, or the single-valued side when neither side is named so."

	^ (self isUsageName: aProperty name) or: [
		  (self isUsageName: aProperty opposite name) not and: [
			  aProperty isMultivalued not ] ]
]

{ #category : 'metamodel' }
FamixOpenApiValidationRule >> isRoot: anEntity [

	^ anEntity class includesBehavior: OPOpenApi
]

{ #category : 'metamodel' }
FamixOpenApiValidationRule >> isUsageName: aName [
	"Answer whether aName follows the naming convention of the reverse side of a shared reference (usedBy* and usedAs*)."

	^ (aName beginsWith: 'usedBy') or: [ aName beginsWith: 'usedAs' ]
]

{ #category : 'description' }
FamixOpenApiValidationRule >> name [
	"Answer the name of the class of the receiver."

	^ self class name
]

{ #category : 'metamodel' }
FamixOpenApiValidationRule >> relatedEntitiesOf: anEntity through: aProperty [
	"Answer an Array of the entities anEntity holds in the relation aProperty (none when it is unset)."

	| value |
	value := anEntity mmGetProperty: aProperty.
	aProperty isMultivalued ifTrue: [ ^ value asArray ].
	^ value ifNil: [ #(  ) ] ifNotNil: [ { value } ]
]

{ #category : 'metamodel' }
FamixOpenApiValidationRule >> relationPropertiesOf: aClass [
	"Answer the Fame relation properties of aClass that have an opposite (primitive and derived properties excluded)."

	^ aClass mooseDescription allProperties select: [ :each |
		  each type isPrimitive not and: [
			  each isDerived not and: [ each opposite isNotNil ] ] ]
]

{ #category : 'description' }
FamixOpenApiValidationRule >> severity [
	"Answer the default severity (#error, #warning or #info) of the findings of the receiver."

	^ self subclassResponsibility
]
