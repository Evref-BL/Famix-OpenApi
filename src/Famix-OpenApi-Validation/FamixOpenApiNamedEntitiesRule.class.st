"
Invariant: every entity of the model has a non-nil, non-blank name, except the classes whose name is naturally optional (OPContact, OPLicense, OPTag, OPXmlElement). The exception list is copied as data from the importer's naming sweep, not referenced. Findings: #unnamedEntity, #error.
"
Class {
	#name : 'FamixOpenApiNamedEntitiesRule',
	#superclass : 'FamixOpenApiValidationRule',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiNamedEntitiesRule class >> namelessClassNames [
	"Class names whose entities may legitimately have no name: contact, license, tag and XML element are optional in the OpenAPI source, so the importer does not invent a name. Copied from the importer naming sweep test on purpose (no dependency on it)."

	^ #( #OPContact #OPLicense #OPTag #OPXmlElement )
]

{ #category : 'checking' }
FamixOpenApiNamedEntitiesRule >> check: anEntity into: aFindings [

	(self isNaturallyNameless: anEntity) ifTrue: [ ^ self ].
	(self hasBlankName: anEntity) ifFalse: [ ^ self ].
	self
		addFindingTo: aFindings
		entity: anEntity
		message: anEntity class name , ' has no name'
]

{ #category : 'description' }
FamixOpenApiNamedEntitiesRule >> code [

	^ #unnamedEntity
]

{ #category : 'description' }
FamixOpenApiNamedEntitiesRule >> description [

	^ 'Every entity has a non-blank name, except the classes whose name is naturally optional.'
]

{ #category : 'checking' }
FamixOpenApiNamedEntitiesRule >> hasBlankName: anEntity [

	^ anEntity name isNil or: [ anEntity name asString trimBoth isEmpty ]
]

{ #category : 'checking' }
FamixOpenApiNamedEntitiesRule >> isNaturallyNameless: anEntity [

	^ self class namelessClassNames includes: anEntity class name
]

{ #category : 'description' }
FamixOpenApiNamedEntitiesRule >> severity [

	^ #error
]
