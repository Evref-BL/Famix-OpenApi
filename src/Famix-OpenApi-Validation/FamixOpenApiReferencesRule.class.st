"
Invariants of the representation of references (the importer keeps a $ref as a raw `ref` text on the entity that carries it, and records a target that cannot be resolved as an OPReference owned by the OPOpenApi, in its unresolvedReferences). Established on the corpus and on small probe documents (existing, missing, external, cyclic and aliased targets): (1) every OPReference has a non-blank target text and is owned by an OPOpenApi (#referenceMalformed); (2) every entity that has a `ref` property and sets it holds a non-blank String (#referenceMalformed); (3) an OPSchema whose ref is set is either linked to its resolved target (its allOf is not empty, 3.0 aliases and 3.1 siblings of $ref alike) or has an OPReference of the same target text (#referenceNotRepresented). Not checked, because the importer does not guarantee it: that a ref designates an existing component (a missing target is a document fact, not an importer bug), and any link between a Response or Path `ref` and its target (they are copies made at import). Severity: #error.
"
Class {
	#name : 'FamixOpenApiReferencesRule',
	#superclass : 'FamixOpenApiValidationRule',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiReferencesRule >> addMalformedTo: aFindings entity: anEntity message: aString [

	^ self
		  addFindingTo: aFindings
		  entity: anEntity
		  code: #referenceMalformed
		  message: aString
]

{ #category : 'checking' }
FamixOpenApiReferencesRule >> checkModel: aModel into: aFindings [

	| targets |
	targets := ((aModel allWithType: OPReference) collect: #target) asSet.
	aModel allModelEntities do: [ :each |
		self checkReference: each into: aFindings.
		self checkRefText: each into: aFindings.
		self checkSchema: each targets: targets into: aFindings ]
]

{ #category : 'checking' }
FamixOpenApiReferencesRule >> checkRefText: anEntity into: aFindings [
	"A ref that is set is a non-blank String."

	| ref |
	ref := self refOf: anEntity.
	(ref isNil or: [ self isText: ref ]) ifTrue: [ ^ self ].
	self
		addMalformedTo: aFindings
		entity: anEntity
		message:
			anEntity class name , ' has a ref that is not a non-blank String: '
			, ref printString
]

{ #category : 'checking' }
FamixOpenApiReferencesRule >> checkReference: anEntity into: aFindings [
	"An unresolved Reference has a target text and is owned by the OPOpenApi."

	(anEntity class includesBehavior: OPReference) ifFalse: [ ^ self ].
	(self isText: anEntity target) ifFalse: [
		self
			addMalformedTo: aFindings
			entity: anEntity
			message: 'OPReference without a target text' ].
	anEntity openApi ifNil: [
		self
			addMalformedTo: aFindings
			entity: anEntity
			message: 'OPReference not owned by an OPOpenApi' ]
]

{ #category : 'checking' }
FamixOpenApiReferencesRule >> checkSchema: anEntity targets: aSet into: aFindings [
	"A schema with a ref is linked to its target or has an unresolved Reference of the same text."

	| ref |
	(anEntity class includesBehavior: OPSchema) ifFalse: [ ^ self ].
	ref := self refOf: anEntity.
	(ref isNil or: [ (self isText: ref) not ]) ifTrue: [ ^ self ].
	(anEntity allOf isNotEmpty or: [ aSet includes: ref ]) ifTrue: [
		^ self ].
	self
		addFindingTo: aFindings
		entity: anEntity
		code: #referenceNotRepresented
		message: 'OPSchema with ref ' , ref printString
			, ' has neither a resolved target in allOf nor an OPReference'
]

{ #category : 'description' }
FamixOpenApiReferencesRule >> code [

	^ #referenceMalformed
]

{ #category : 'description' }
FamixOpenApiReferencesRule >> codes [

	^ #( #referenceMalformed #referenceNotRepresented )
]

{ #category : 'description' }
FamixOpenApiReferencesRule >> description [

	^ 'References are represented coherently: every OPReference has a non-blank target and is owned by an OPOpenApi; a ref set on an entity is a non-blank String (#referenceMalformed); an OPSchema with a ref is linked to its resolved target (its allOf is not empty) or has an OPReference with the same target text (#referenceNotRepresented). Limits: it does not check that a ref designates an existing component (a missing target is a fact of the document), it does not compare a ref with the canonical pointer of its target (a ref may be relative, escaped or external), and the ref of a Response or a Path (a copy made at import) is only checked as text.'
]

{ #category : 'checking' }
FamixOpenApiReferencesRule >> isText: aValue [

	^ aValue isString and: [ aValue trimBoth isNotEmpty ]
]

{ #category : 'checking' }
FamixOpenApiReferencesRule >> refOf: anEntity [
	"Answer the value of the ref property of anEntity, nil when its class has none or it is unset."

	^ (anEntity mooseDescription propertyNamed: #ref) ifNotNil: [
		  :property | anEntity mmGetProperty: property ]
]

{ #category : 'description' }
FamixOpenApiReferencesRule >> severity [

	^ #error
]
