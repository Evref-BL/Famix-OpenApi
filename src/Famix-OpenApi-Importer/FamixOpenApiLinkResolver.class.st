Class {
	#name : 'FamixOpenApiLinkResolver',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiLinkResolver >> operationDesignatedBy: anOperationRef [
	"Answer the Operation registered at the local pointer anOperationRef, or nil."

	| target |
	(FamixOpenApiJsonPointer isLocalReference: anOperationRef) ifFalse: [
		^ nil ].
	target := self index lookup:
		          (context pointerForReference: anOperationRef).
	^ (target isKindOf: OPOperation) ifTrue: [ target ]
]

{ #category : 'visiting' }
FamixOpenApiLinkResolver >> reportUnresolved: aLink because: aReason [

	self diagnostics
		warning: #linkOperationUnresolved
		pointer: aLink canonicalPointer
		message: 'Link ' , aLink name printString , ': ' , aReason
]

{ #category : 'visiting' }
FamixOpenApiLinkResolver >> resolve [
	"Set the operation of every Link of the model, from its operationId or its operationRef. A Link whose operation is not found is reported as a linkOperationUnresolved warning."

	| operationsById |
	operationsById := Dictionary new.
	(self model allWithType: OPOperation) do: [ :each |
		each operationId ifNotNil: [ :id |
			operationsById at: id ifAbsentPut: [ each ] ] ].
	(self model allWithType: OPLink) do: [ :each |
		self
			guard: [ self resolve: each using: operationsById ]
			at: each canonicalPointer ]
]

{ #category : 'visiting' }
FamixOpenApiLinkResolver >> resolve: aLink using: anOperationsById [

	| operation |
	aLink operationId ifNotNil: [ :id |
		operation := anOperationsById at: id ifAbsent: [ nil ].
		operation ifNil: [
			^ self
				  reportUnresolved: aLink
				  because: 'no operation has the operationId ' , id printString ].
		^ aLink operation: operation ].
	aLink operationRef ifNotNil: [ :ref |
		operation := self operationDesignatedBy: ref.
		operation ifNil: [
			^ self
				  reportUnresolved: aLink
				  because: 'no operation at the operationRef ' , ref printString ].
		^ aLink operation: operation ]
]
