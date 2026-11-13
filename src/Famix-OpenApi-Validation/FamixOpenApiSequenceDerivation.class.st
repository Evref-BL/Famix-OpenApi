"
Derivation #sequence: the arguments are rows (derivation name, arguments) and the targets are the ones of each part, one after the other (the example of a media type, then its examples; the allOf made of the $ref of an alias, then the allOf of the source). Not derivable when one of the parts is not.
"
Class {
	#name : 'FamixOpenApiSequenceDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#instVars : [
		'parts'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiSequenceDerivation >> parts [
	"The derivations of the rows, built once"

	^ parts ifNil: [
		  parts := arguments collect: [ :row |
			           FamixOpenApiRelationDerivation
				           named: row first
				           arguments: row second
				           family: family ] ]
]

{ #category : 'accessing' }
FamixOpenApiSequenceDerivation >> reason [

	^ 'keys beside a $ref (OpenAPI 3.1) are not walked'
]

{ #category : 'deriving' }
FamixOpenApiSequenceDerivation >> targetsOf: anOwner in: aCheck [

	| pointers |
	pointers := OrderedCollection new.
	self parts do: [ :each |
		(each targetsOf: anOwner in: aCheck)
			ifNil: [ ^ nil ]
			ifNotNil: [ :targets | pointers addAll: targets ] ].
	^ pointers asArray
]
