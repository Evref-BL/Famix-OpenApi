"
Invariant: every entity of the model is reachable from an OPOpenApi root by following FORWARD relations only, from owner to owned entity and from user to used entity (Paths, Path>>operations, Operation>>parameters, Parameter>>schema, Schema>>items, Components>>schemas, OPOpenApi>>unresolvedReferences ...). The forward properties are the relation properties of the Fame meta-description that are not anchor properties of the containment rule: neither the container side (Operation>>path), nor the usedBy*/usedAs* back-pointers, nor the single-valued reverse side (SubSchema>>subSchemaOf). Back-pointers must not count: they let a subtree detached from the root look anchored by its own members, which the one-hop FamixOpenApiContainmentRule does not see. Shared reusable objects (Components entries) and schemas designated by a $ref are reached through the forward relations that use them (Components>>schemas, Operation>>parameters, Schema>>allOf, Property>>valueSchema, MediaType>>schema ...); on the 20 corpus files and the samples, merged or not, this yields no finding. With no root nothing is checked (FamixOpenApiOneRootRule reports it). Finding: #unreachableEntity, #warning, one per unreachable entity.
"
Class {
	#name : 'FamixOpenApiReachabilityRule',
	#superclass : 'FamixOpenApiValidationRule',
	#instVars : [
		'propertyCache'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiReachabilityRule >> checkModel: aModel into: aFindings [

	| roots reached |
	roots := aModel allModelEntities select: [ :each | self isRoot: each ].
	roots ifEmpty: [ ^ self ].
	reached := self entitiesReachedFrom: roots.
	aModel allModelEntities
		reject: [ :each | reached includes: each ]
		thenDo: [ :each |
			self addFindingTo: aFindings entity: each message: each class name
				,
				' is not reachable from the OPOpenApi root through forward relations' ]
]

{ #category : 'description' }
FamixOpenApiReachabilityRule >> code [

	^ #unreachableEntity
]

{ #category : 'description' }
FamixOpenApiReachabilityRule >> description [

	^ 'Every entity is reachable from the OPOpenApi root by following forward relations only (owner to owned, user to used); the container side, the usedBy*/usedAs* back-pointers and SubSchema>>subSchemaOf do not count, so that a subtree detached from the root (a path with its operations, a schema attached to a detached parent) is reported, which the one-hop containment rule misses. Limits: the forward properties are derived from the Fame meta-description and from the usedBy*/usedAs* naming convention of the reverse side of a shared reference; one finding per unreachable entity, so a detached subtree gives several; an entity reachable only through a relation that the importer does not set is reported even if the document designates it; with no root nothing is checked.'
]

{ #category : 'checking' }
FamixOpenApiReachabilityRule >> entitiesReachedFrom: aCollection [
	"Answer an IdentitySet of the entities of aCollection and of those they reach through forward relations, breadth first."

	| reached pending |
	reached := aCollection asIdentitySet.
	pending := aCollection asOrderedCollection.
	[ pending isEmpty ] whileFalse: [
		| fresh |
		fresh := (self forwardEntitiesOf: pending removeFirst) reject: [
			         :each | reached includes: each ].
		reached addAll: fresh.
		pending addAll: fresh ].
	^ reached
]

{ #category : 'checking' }
FamixOpenApiReachabilityRule >> forwardEntitiesOf: anEntity [
	"Answer the entities anEntity holds in its forward relations."

	^ (self forwardPropertiesOf: anEntity class) flatCollect: [ :each |
		  self relatedEntitiesOf: anEntity through: each ]
]

{ #category : 'checking' }
FamixOpenApiReachabilityRule >> forwardPropertiesOf: aClass [
	"Answer the forward relation properties of aClass (relations that are not anchor properties), computed once per class."

	^ propertyCache at: aClass ifAbsentPut: [
		  (self relationPropertiesOf: aClass) reject: [ :each |
			  self isAnchorProperty: each ] ]
]

{ #category : 'initialization' }
FamixOpenApiReachabilityRule >> initialize [

	super initialize.
	propertyCache := Dictionary new
]

{ #category : 'description' }
FamixOpenApiReachabilityRule >> severity [

	^ #warning
]
