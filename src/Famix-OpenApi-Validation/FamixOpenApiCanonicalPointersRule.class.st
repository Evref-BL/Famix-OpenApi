"
Invariants of the canonical pointers (the JSON pointer of the document node an entity was built from) of an imported model: (a) every entity has a non-blank canonicalPointer, except the classes listed by #pointerlessClassNames (none: the importer creates every entity through one method that takes a pointer, and the synthetic ones carry the pointer of their origin, e.g. the OPServer of a Swagger 2 host/basePath is at #/servers/0 and the OPRequestBody built from a body parameter is at the pointer of that parameter) (#pointerMissing); (b) a canonicalPointer is unique among the entities of one family, that is entities that share the same class below OPEntity (an OPSubSchema counts as an OPSchema) (#pointerDuplicated); (c) a pointer kept in the mergedPointers of a family member (the pointers of the schemas merged into it) is neither its own canonicalPointer, nor the canonicalPointer of another member, nor in the mergedPointers of another member (#pointerConflict). Entities of different families legitimately share a pointer and are never compared: an OPProperty and its value OPSchema, an OPReference and the entity at the site of the $ref, an OPSecurityScheme and its OPOAuthFlow. Severity: #error.
"
Class {
	#name : 'FamixOpenApiCanonicalPointersRule',
	#superclass : 'FamixOpenApiValidationRule',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> checkDuplicatesIn: aCollection into: aFindings [
	"Report every entity that shares its canonical pointer with another entity of its family."

	(self groupedByPointer: aCollection) do: [ :group |
		group size > 1 ifTrue: [
			(group groupedBy: [ :each | self familyOf: each ]) do: [
				:sameFamily |
				sameFamily size > 1 ifTrue: [
					self reportDuplicates: sameFamily into: aFindings ] ] ] ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> checkMergedPointersIn: aCollection into: aFindings [
	"Report every entity that keeps a merged pointer that is also a canonical pointer, or is kept by another entity, in its family."

	| canonical |
	canonical := self groupedByPointer: aCollection.
	(self mergedGroupsIn: aCollection) keysAndValuesDo: [ :pointer :owners |
		(owners groupedBy: [ :each | self familyOf: each ])
			keysAndValuesDo: [ :family :sameFamily |
				(self
					 is: sameFamily
					 conflictingWith: (canonical at: pointer ifAbsent: [ #(  ) ])
					 in: family) ifTrue: [
					self reportConflicts: sameFamily pointer: pointer into: aFindings ] ] ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> checkModel: aModel into: aFindings [

	| entities |
	entities := aModel allModelEntities.
	entities do: [ :each | self checkPresenceOf: each into: aFindings ].
	self checkDuplicatesIn: entities into: aFindings.
	self checkMergedPointersIn: entities into: aFindings
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> checkPresenceOf: anEntity into: aFindings [

	(self pointerlessClassNames includes: anEntity class name) ifTrue: [
		^ self ].
	(self hasPointer: anEntity) ifTrue: [ ^ self ].
	self
		addFindingTo: aFindings
		entity: anEntity
		code: #pointerMissing
		message: anEntity class name , ' has no canonical pointer'
]

{ #category : 'description' }
FamixOpenApiCanonicalPointersRule >> code [

	^ #pointerMissing
]

{ #category : 'description' }
FamixOpenApiCanonicalPointersRule >> codes [

	^ #( #pointerMissing #pointerDuplicated #pointerConflict )
]

{ #category : 'description' }
FamixOpenApiCanonicalPointersRule >> description [

	^ 'Every entity has a non-blank canonical pointer (#pointerMissing), a pointer is unique among the entities of one family, that is of one class below OPEntity (#pointerDuplicated), and a pointer kept in the mergedPointers of an entity is neither its own pointer, nor the pointer of another entity of its family, nor kept by another one (#pointerConflict). Limits: entities of different families (an OPProperty and its value OPSchema, an OPReference and the entity at the site of its $ref) may share a pointer and are not compared; the pointer is not compared with the position of the entity in the model, and a pointer that is wrong but unique is not detected.'
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> familyOf: anEntity [
	"Answer the class of anEntity directly below OPEntity: entities of a family may be compared by pointer (see FamixOpenApiPointerLookup)."

	^ FamixOpenApiPointerLookup familyOf: anEntity
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> groupedByPointer: aCollection [
	"Answer a Dictionary pointer->entities of aCollection that have this canonical pointer."

	^ (aCollection select: [ :each | self hasPointer: each ]) groupedBy: [
		  :each | each canonicalPointer ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> hasPointer: anEntity [

	| pointer |
	pointer := anEntity canonicalPointer.
	^ pointer isString and: [ pointer trimBoth isNotEmpty ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> is: someOwners conflictingWith: someEntities in: aFamily [
	"Answer whether the owners of a merged pointer are several, or one of the entities that have it as canonical pointer is of aFamily."

	^ someOwners size > 1 or: [
		  someEntities anySatisfy: [ :each |
			  (self familyOf: each) == aFamily ] ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> mergedGroupsIn: aCollection [
	"Answer a Dictionary pointer->entities of aCollection that keep this pointer in their mergedPointers."

	| pairs |
	pairs := aCollection flatCollect: [ :each |
		         (self mergedPointersOf: each) asSet collect: [ :pointer |
			         pointer -> each ] ].
	^ (pairs groupedBy: [ :each | each key ]) collect: [ :group |
		  group collect: [ :each | each value ] ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> mergedPointersOf: anEntity [
	"Answer the mergedPointers of anEntity, none when its class has no such property."

	^ (anEntity mooseDescription propertyNamed: #mergedPointers)
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :property | anEntity mmGetProperty: property ]
]

{ #category : 'description' }
FamixOpenApiCanonicalPointersRule >> pointerlessClassNames [
	"Answer the names of the classes whose entities may have no canonical pointer. None, found by exploration of the 20 corpus files and of the samples: every entity is created by the importer with a pointer; the entities without a node of their own carry the pointer of their origin (the OPServer built from the host and basePath of a Swagger 2 document is at #/servers/0, the OPRequestBody built from a body or form parameter at the pointer of that parameter, the unresolved OPReference at the pointer of the site of its $ref)."

	^ #(  )
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> reportConflicts: aCollection pointer: aPointer into: aFindings [

	| message |
	message := '{1} keeps the merged pointer {2} that is also used by another entity or by itself'.
	aCollection do: [ :each |
		self
			addFindingTo: aFindings
			entity: each
			code: #pointerConflict
			message: (message format: {
						 each class name.
						 aPointer printString }) ]
]

{ #category : 'checking' }
FamixOpenApiCanonicalPointersRule >> reportDuplicates: aCollection into: aFindings [

	| message others |
	message := '{1} shares the canonical pointer {2} with {3} other(s)'.
	others := aCollection size - 1.
	aCollection do: [ :each |
		self
			addFindingTo: aFindings
			entity: each
			code: #pointerDuplicated
			message: (message format: {
						 each class name.
						 each canonicalPointer printString.
						 others }) ]
]

{ #category : 'description' }
FamixOpenApiCanonicalPointersRule >> severity [

	^ #error
]
