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

	^ 'Every entity other than the OPOpenApi root is owned or referenced by another entity (no orphan). Limit: the check is one hop only, an entity is anchored as soon as ONE of its container or back-pointer relations is set, whatever the owner is, so a whole subtree detached from the root (a path with its operations) is anchored by its own members and not reported (see FamixOpenApiReachabilityRule). It relies on the Fame meta-description and on the naming convention of the reverse side of a shared reference (the usedBy* and usedAs* properties): a relation renamed outside that convention is no longer seen as a back-pointer.'
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

{ #category : 'checking' }
FamixOpenApiContainmentRule >> isAnchored: anEntity [

	^ (self anchorPropertiesOf: anEntity class) anySatisfy: [ :each |
		  self is: each setIn: anEntity ]
]

{ #category : 'description' }
FamixOpenApiContainmentRule >> severity [

	^ #warning
]
