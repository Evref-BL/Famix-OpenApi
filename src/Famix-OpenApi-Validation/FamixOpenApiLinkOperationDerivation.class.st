"
Derivation #linkOperation, for a link: the operation that its operationId names (the first operation of the document that has this operationId) or that its local operationRef designates (VERIFIED by import); nothing when the operation is not in the document.
"
Class {
	#name : 'FamixOpenApiLinkOperationDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiLinkOperationDerivation >> operationNamed: anId in: aCheck [
	"The first operation of the document that has the operationId"

	^ (aCheck inventory nodesOf: 'Operation')
		  detect: [ :each | (each valueAt: 'operationId') = anId ]
		  ifFound: [ :each | self targetOfNode: each in: aCheck ]
		  ifNone: [ #(  ) ]
]

{ #category : 'deriving' }
FamixOpenApiLinkOperationDerivation >> operationReferencedBy: aText in: aCheck [
	"The operation that a local reference designates"

	| node |
	(aText isString and: [ aText beginsWith: '#' ]) ifFalse: [ ^ #(  ) ].
	node := aCheck nodeExpectation nodeForReference: aText.
	^ (node isNotNil and: [ node specObject = 'Operation' ])
		  ifTrue: [ self targetOfNode: node in: aCheck ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'deriving' }
FamixOpenApiLinkOperationDerivation >> targetsOf: anOwner in: aCheck [

	| node |
	node := anOwner node.
	(node valueAt: 'operationId') ifNotNil: [ :id |
		^ self operationNamed: id in: aCheck ].
	(node valueAt: 'operationRef') ifNotNil: [ :reference |
		^ self operationReferencedBy: reference in: aCheck ].
	^ #(  )
]
