"
Invariants of the sub-schemas (OPSubSchema: a schema recognised by the importer as a part of a larger one, e.g. an allOf member that is a subset of another schema): (1) subSchemaOf is set and the larger schema lists the sub-schema in its subSchemas (#subSchemaDetached); (2) the subSchemaOf chain does not loop: a sub-schema is not its own larger schema, directly or through other sub-schemas (#subSchemaCycle). Per-entity rule, only on OPSubSchema. On the corpus the larger schema of a sub-schema is always a plain OPSchema, but a chain of sub-schemas is not forbidden. Severity: #error.
"
Class {
	#name : 'FamixOpenApiSubSchemaRule',
	#superclass : 'FamixOpenApiValidationRule',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiSubSchemaRule >> addDetachedTo: aFindings entity: anEntity message: aString [

	^ self
		  addFindingTo: aFindings
		  entity: anEntity
		  code: #subSchemaDetached
		  message: aString
]

{ #category : 'checking' }
FamixOpenApiSubSchemaRule >> check: anEntity into: aFindings [

	(anEntity class includesBehavior: OPSubSchema) ifFalse: [ ^ self ].
	self checkParentOf: anEntity into: aFindings.
	(self isOnCycle: anEntity) ifTrue: [
		self
			addFindingTo: aFindings
			entity: anEntity
			code: #subSchemaCycle
			message:
			'OPSubSchema is its own larger schema, directly or through other sub-schemas' ]
]

{ #category : 'checking' }
FamixOpenApiSubSchemaRule >> checkParentOf: aSubSchema into: aFindings [
	"The larger schema is set and lists aSubSchema."

	| parent |
	parent := aSubSchema subSchemaOf.
	parent ifNil: [
		^ self
			  addDetachedTo: aFindings
			  entity: aSubSchema
			  message: 'OPSubSchema without a larger schema (subSchemaOf)' ].
	(parent subSchemas anySatisfy: [ :each | each == aSubSchema ])
		ifFalse: [
			self
				addDetachedTo: aFindings
				entity: aSubSchema
				message:
				'OPSubSchema not listed in the subSchemas of its larger schema' ]
]

{ #category : 'description' }
FamixOpenApiSubSchemaRule >> code [

	^ #subSchemaDetached
]

{ #category : 'description' }
FamixOpenApiSubSchemaRule >> codes [

	^ #( #subSchemaDetached #subSchemaCycle )
]

{ #category : 'description' }
FamixOpenApiSubSchemaRule >> description [

	^ 'Every OPSubSchema has a larger schema (subSchemaOf) that lists it in its subSchemas (#subSchemaDetached), and the subSchemaOf chain does not loop, a sub-schema is not its own larger schema (#subSchemaCycle). Limits: it does not check that the sub-schema really is a subset of the larger schema, and a cycle is reported on the sub-schemas that are on it, not on those that only lead to it.'
]

{ #category : 'checking' }
FamixOpenApiSubSchemaRule >> isOnCycle: aSubSchema [
	"Answer whether following subSchemaOf from aSubSchema leads back to it."

	| seen current |
	seen := IdentitySet new.
	current := aSubSchema.
	[
	(current class includesBehavior: OPSubSchema) and: [
		(seen includes: current) not ] ] whileTrue: [
		seen add: current.
		current := current subSchemaOf ].
	^ current == aSubSchema
]

{ #category : 'description' }
FamixOpenApiSubSchemaRule >> severity [

	^ #error
]
