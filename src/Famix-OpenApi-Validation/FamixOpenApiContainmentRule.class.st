"
Invariant: every entity other than the OPOpenApi root is anchored in the model, i.e. some other entity owns or references it (no orphan). Derived from the Fame meta-description, with no class hard-coded. An entity is anchored when (1) one of its container properties (FM3Property>>isContainer: the child side of a containment such as Operation>>path, Schema>>components, Property>>schema) is set, or (2) one of its back-pointer relations is set: the reverse side of a shared reference (usedBy* and usedAs* properties such as Schema>>usedByParameters or Schema>>usedAsItemsBy, which let one reusable object, e.g. a Parameter, Header or Schema, be owned by Components yet referenced by several operations, responses, media types...) and, among the two sides of a relation where neither is a container nor a usedBy/usedAs one, the single-valued side (SubSchema>>subSchemaOf). Forward relations (Operation>>parameters, Schema>>items) do not anchor, otherwise a parent would anchor itself. Conservative by design: any one anchor is enough. Finding: #orphanEntity, #warning.
"
Class {
	#name : 'FamixOpenApiContainmentRule',
	#superclass : 'FamixOpenApiValidationRule',
	#instVars : [
		'anchorCache'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'metamodel' }
FamixOpenApiContainmentRule >> anchorPropertiesOf: aClass [
	"Answer the Fame properties of aClass that anchor an instance in the model, computed once per class."

	^ anchorCache at: aClass ifAbsentPut: [
		  aClass mooseDescription allProperties select: [ :each |
			  self isAnchorProperty: each ] ]
]

{ #category : 'checking' }
FamixOpenApiContainmentRule >> check: anEntity into: aFindings [

	(self isRoot: anEntity) ifTrue: [ ^ self ].
	(self isAnchored: anEntity) ifTrue: [ ^ self ].
	self
		addFindingTo: aFindings
		entity: anEntity
		message:
		anEntity class name , ' is not owned nor referenced by any entity'
]

{ #category : 'description' }
FamixOpenApiContainmentRule >> code [

	^ #orphanEntity
]

{ #category : 'description' }
FamixOpenApiContainmentRule >> description [

	^ 'Every entity other than the OPOpenApi root is owned or referenced by another entity.'
]

{ #category : 'initialization' }
FamixOpenApiContainmentRule >> initialize [

	super initialize.
	anchorCache := Dictionary new
]

{ #category : 'checking' }
FamixOpenApiContainmentRule >> is: aProperty setIn: anEntity [

	| value |
	value := anEntity mmGetProperty: aProperty.
	^ aProperty isMultivalued
		  ifTrue: [ value notEmpty ]
		  ifFalse: [ value isNotNil ]
]

{ #category : 'metamodel' }
FamixOpenApiContainmentRule >> isAnchorProperty: aProperty [
	"Answer whether aProperty is a relation that points from a child to its owner."

	aProperty type isPrimitive ifTrue: [ ^ false ].
	aProperty isContainer ifTrue: [ ^ true ].
	aProperty opposite ifNil: [ ^ false ].
	aProperty opposite isContainer ifTrue: [ ^ false ].
	^ self isBackPointer: aProperty
]

{ #category : 'checking' }
FamixOpenApiContainmentRule >> isAnchored: anEntity [

	^ (self anchorPropertiesOf: anEntity class) anySatisfy: [ :each |
		  self is: each setIn: anEntity ]
]

{ #category : 'metamodel' }
FamixOpenApiContainmentRule >> isBackPointer: aProperty [
	"Answer whether aProperty is the reverse side of a non-containment relation: a usedBy/usedAs property, or the single-valued side when neither side is named so."

	^ (self isUsageName: aProperty name) or: [
		  (self isUsageName: aProperty opposite name) not and: [
			  aProperty isMultivalued not ] ]
]

{ #category : 'checking' }
FamixOpenApiContainmentRule >> isRoot: anEntity [

	^ anEntity class includesBehavior: OPOpenApi
]

{ #category : 'metamodel' }
FamixOpenApiContainmentRule >> isUsageName: aName [

	^ (aName beginsWith: 'usedBy') or: [ aName beginsWith: 'usedAs' ]
]

{ #category : 'description' }
FamixOpenApiContainmentRule >> severity [

	^ #warning
]
