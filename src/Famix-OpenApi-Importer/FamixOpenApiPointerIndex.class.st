"
I map canonical JSON pointers (like '#/components/schemas/Pet') to model entities and resolve $ref strings to them strictly, following alias chains and reporting every problem in a FamixOpenApiDiagnostics.
"
Class {
	#name : 'FamixOpenApiPointerIndex',
	#superclass : 'Object',
	#instVars : [
		'diagnostics',
		'entities',
		'aliases',
		'order',
		'translation'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'instance creation' }
FamixOpenApiPointerIndex class >> diagnostics: aFamixOpenApiDiagnostics [
	"Answer a new index reporting its problems in aFamixOpenApiDiagnostics."

	^ self new
		  setDiagnostics: aFamixOpenApiDiagnostics;
		  yourself
]

{ #category : 'private' }
FamixOpenApiPointerIndex >> checkKindOf: anEntity expecting: aClassOrNil reference: aRefString site: aSitePointer [
	"Answer anEntity when it is of the expected kind, otherwise report a refKindMismatch and answer nil."

	(aClassOrNil isNil or: [ anEntity isKindOf: aClassOrNil ]) ifTrue: [
		^ anEntity ].
	diagnostics
		error: #refKindMismatch
		pointer: aSitePointer
		message: 'Reference ' , aRefString printString , ' expected a '
			, aClassOrNil name , ' but found a ' , anEntity class name.
	^ nil
]

{ #category : 'accessing' }
FamixOpenApiPointerIndex >> diagnostics [
	"Answer the diagnostics receiving the problems found."

	^ diagnostics
]

{ #category : 'accessing' }
FamixOpenApiPointerIndex >> entities [
	"Answer an Array of the registered entities, in insertion order."

	^ (order select: [ :each | entities includesKey: each ]) collect: [
		  :each | entities at: each ]
]

{ #category : 'private' }
FamixOpenApiPointerIndex >> followAliasesFrom: aRefString site: aSitePointer [
	"Answer the pointer of the first non alias target reached from aRefString, or nil after reporting a refCycle."

	| current visited chain |
	current := translation value: aRefString.
	visited := Set new.
	chain := OrderedCollection with: current.
	[ aliases includesKey: current ] whileTrue: [
		(visited includes: current) | (visited size >= self maxAliasDepth)
			ifTrue: [
				diagnostics
					error: #refCycle
					pointer: aSitePointer
					message: 'Reference cycle: ' , (', ' join: chain).
				^ nil ].
		visited add: current.
		current := translation value: (aliases at: current).
		chain add: current asString ].
	^ current
]

{ #category : 'testing' }
FamixOpenApiPointerIndex >> includesPointer: aPointer [
	"Answer whether aPointer holds an entity or an alias."

	^ (entities includesKey: aPointer) or: [
		  aliases includesKey: aPointer ]
]

{ #category : 'initialization' }
FamixOpenApiPointerIndex >> initialize [

	super initialize.
	diagnostics := FamixOpenApiDiagnostics new.
	translation := [ :ref | ref ].
	self reset
]

{ #category : 'testing' }
FamixOpenApiPointerIndex >> isAlias: aPointer [
	"Answer whether aPointer holds an alias."

	^ aliases includesKey: aPointer
]

{ #category : 'lookup' }
FamixOpenApiPointerIndex >> lookup: aPointer [
	"Answer the entity registered at aPointer, or nil. Aliases are not followed."

	^ entities at: aPointer ifAbsent: [ nil ]
]

{ #category : 'private' }
FamixOpenApiPointerIndex >> maxAliasDepth [
	"Answer the maximum number of aliases followed for one reference."

	^ 64
]

{ #category : 'accessing' }
FamixOpenApiPointerIndex >> pointers [
	"Answer an Array of the registered pointers (entities and aliases), in insertion order."

	^ order asArray
]

{ #category : 'registering' }
FamixOpenApiPointerIndex >> register: anEntity at: aPointer [
	"Register anEntity at aPointer and answer the entity held there. The first registration wins: a different entity for a known pointer is reported as a duplicatePointer warning."

	| existing |
	existing := entities at: aPointer ifAbsent: [ nil ].
	(existing isNil and: [ (aliases includesKey: aPointer) not ])
		ifTrue: [
			order add: aPointer.
			^ entities at: aPointer put: anEntity ].
	existing == anEntity ifTrue: [ ^ anEntity ].
	diagnostics
		warning: #duplicatePointer
		pointer: aPointer
		message: 'Pointer ' , aPointer asString
			, ' is already registered; keeping the first definition'.
	^ existing
]

{ #category : 'registering' }
FamixOpenApiPointerIndex >> registerAlias: aPointer to: aRefString [
	"Register aPointer as an alias of the raw reference aRefString (a component that is only a $ref)."

	((entities includesKey: aPointer) or: [
		 aliases includesKey: aPointer ]) ifTrue: [
		^ diagnostics
			  warning: #duplicatePointer
			  pointer: aPointer
			  message: 'Pointer ' , aPointer asString
				  , ' is already registered; keeping the first definition' ].
	order add: aPointer.
	aliases at: aPointer put: aRefString
]

{ #category : 'initialization' }
FamixOpenApiPointerIndex >> reset [
	"Forget every registered entity and alias (the reference translation is kept)."

	entities := Dictionary new.
	aliases := Dictionary new.
	order := OrderedCollection new
]

{ #category : 'lookup' }
FamixOpenApiPointerIndex >> resolveNestedReference: aRefString from: aSitePointer expecting: aClassOrNil [
	"Answer the entity designated by aRefString, possibly a nested pointer such as #/components/schemas/A/properties/b; the inline entity must have been registered at its own pointer."

	^ self
		  resolveReference: aRefString
		  from: aSitePointer
		  expecting: aClassOrNil
]

{ #category : 'lookup' }
FamixOpenApiPointerIndex >> resolveReference: aRefString from: aSitePointer expecting: aClassOrNil [
	"Answer the entity designated by aRefString written at aSitePointer, or nil after recording a diagnostic."

	| target |
	(FamixOpenApiJsonPointer isLocalReference: aRefString) ifFalse: [
		diagnostics
			warning: #unresolvedReference
			pointer: aSitePointer
			message: 'External or invalid reference: ' , aRefString printString.
		^ nil ].
	target := self followAliasesFrom: aRefString site: aSitePointer.
	target ifNil: [ ^ nil ].
	(entities includesKey: target) ifFalse: [
		diagnostics
			warning: #unresolvedReference
			pointer: aSitePointer
			message: 'Unresolved reference ' , aRefString printString.
		^ nil ].
	^ self
		  checkKindOf: (entities at: target)
		  expecting: aClassOrNil
		  reference: aRefString
		  site: aSitePointer
]

{ #category : 'initialization' }
FamixOpenApiPointerIndex >> setDiagnostics: aFamixOpenApiDiagnostics [

	diagnostics := aFamixOpenApiDiagnostics
]

{ #category : 'accessing' }
FamixOpenApiPointerIndex >> size [
	"Answer the number of registered entities and aliases."

	^ order size
]

{ #category : 'accessing' }
FamixOpenApiPointerIndex >> translateRefsWith: aOneArgBlock [
	"Set the block mapping a raw $ref String to the canonical pointer used for lookup."

	translation := aOneArgBlock
]
