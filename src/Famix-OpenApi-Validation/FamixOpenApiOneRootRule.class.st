"
Invariant: an imported model contains exactly one OPOpenApi root. A model-wide rule: it overrides #checkModel:into:. Finding: #rootCount, #error (one finding without entity when there is no root, one per root when there are several).
"
Class {
	#name : 'FamixOpenApiOneRootRule',
	#superclass : 'FamixOpenApiValidationRule',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiOneRootRule >> checkModel: aModel into: aFindings [

	| roots |
	roots := aModel allWithType: OPOpenApi.
	roots size = 1 ifTrue: [ ^ self ].
	roots isEmpty
		ifTrue: [
			self
				addFindingTo: aFindings
				entity: nil
				message: 'the model has no OPOpenApi root' ]
		ifFalse: [ self reportSeveralRoots: roots into: aFindings ]
]

{ #category : 'description' }
FamixOpenApiOneRootRule >> code [

	^ #rootCount
]

{ #category : 'description' }
FamixOpenApiOneRootRule >> description [

	^ 'The model contains exactly one OPOpenApi root.'
]

{ #category : 'checking' }
FamixOpenApiOneRootRule >> reportSeveralRoots: aCollection into: aFindings [

	| message |
	message := 'the model has {1} OPOpenApi roots' format:
		           { aCollection size }.
	aCollection do: [ :each |
		self addFindingTo: aFindings entity: each message: message ]
]

{ #category : 'description' }
FamixOpenApiOneRootRule >> severity [

	^ #error
]
