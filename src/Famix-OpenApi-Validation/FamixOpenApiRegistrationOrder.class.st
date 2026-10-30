"
The order in which the importer creates the entities of the path items, needed for the path items designated by a $ref inside a callback: the importer shares the entity already created for the target and reads the target again (a clone) when it does not exist yet. It creates the components (a component path item that is not an alias) first, then the path items of paths in the order of the document (an entity exists as soon as it is visited: an entry of paths, a $ref entry, and the path items of the callbacks inside an entry, in depth-first order), then those of webhooks. #isRegistered:beforeSite: says whether the entity of a target exists when the importer reaches a callback at a site. The order of the keys is the one of the raw document (the inventory must be read like the importer does: FamixOpenApiSourceWalker>>walkString:). Experiments on the importer (3.0 and 3.1) gave: a callback $ref to a component path item shares it; to a path item of an earlier (or the same) entry, or one that comes before the site in the same entry, it shares it; to a later one it clones it.
"
Class {
	#name : 'FamixOpenApiRegistrationOrder',
	#superclass : 'Object',
	#instVars : [
		'inventory'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiRegistrationOrder class >> componentsPointer [

	^ '#/components'
]

{ #category : 'data' }
FamixOpenApiRegistrationOrder class >> dataSections [
	"The sections of the document in the order the importer reads them (the components first, then the paths, then the web hooks); any other one after them"

	^ #( '#/components' '#/paths' '#/webhooks' )
]

{ #category : 'instance creation' }
FamixOpenApiRegistrationOrder class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> child: aToken of: aValue [
	"The value of aValue at the key or index aToken, nil when there is none"

	| key |
	key := FamixOpenApiSourceNode unescapeToken: aToken.
	aValue isDictionary ifTrue: [ ^ aValue at: key ifAbsent: [ nil ] ].
	^ aValue isArray
		  ifTrue: [ aValue at: key asNumber + 1 ifAbsent: [ nil ] ]
		  ifFalse: [ nil ]
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> comparePointer: aPointer with: anotherPointer [
	"-1, 0 or 1 when the importer visits aPointer before, as, or after anotherPointer: the sections in their order, then the document order of the keys (an ancestor is visited before what it holds)"

	| first second value |
	first := self tokensOf: aPointer.
	second := self tokensOf: anotherPointer.
	value := self rootValue.
	1 to: (first size min: second size) do: [ :index |
		| a b |
		a := first at: index.
		b := second at: index.
		a = b
			ifTrue: [ value := self child: a of: value ]
			ifFalse: [
				^ ((self positionOf: a in: value at: index)
				   - (self positionOf: b in: value at: index)) sign ] ].
	^ (first size - second size) sign
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> inventory: aSourceInventory [

	inventory := aSourceInventory
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> isComponentPathItem: aNode [
	"A component path item has an entity unless it is an alias"

	^ (aNode pointer beginsWith: '#/components/pathItems/') and: [
		  aNode isReference not ]
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> isInComponents: aNode [

	^ aNode pointer = self class componentsPointer or: [
		  FamixOpenApiSourceNode
			  pointer: aNode pointer
			  isBelow: self class componentsPointer ]
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> isRegistered: aTargetNode beforeSite: aSiteNode [
	"True when the entity of the path item aTargetNode exists when the importer reaches aSiteNode: a component that is not an alias, or a path item of paths or webhooks that the importer visited before the site (an ancestor of the site, or what comes before it in the document; the components are visited first, so a site in the components comes before them)"

	(self isInComponents: aTargetNode) ifTrue: [
		^ self isComponentPathItem: aTargetNode ].
	^ (self comparePointer: aTargetNode pointer with: aSiteNode pointer)
	  <= 0
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> positionOf: aToken in: aValue at: aDepth [
	"The place of the key or index aToken among its siblings (at the first depth: the order the importer reads the sections of the document)"

	| key |
	aDepth = 1 ifTrue: [
		^ self class dataSections
			  indexOf: '#/' , aToken
			  ifAbsent: [ self class dataSections size + 1 ] ].
	key := FamixOpenApiSourceNode unescapeToken: aToken.
	^ aValue isDictionary
		  ifTrue: [ aValue keys indexOf: key ]
		  ifFalse: [ key asNumber ]
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> rootValue [

	^ (inventory nodeAt: FamixOpenApiSourceNode rootPointer) value
]

{ #category : 'ordering' }
FamixOpenApiRegistrationOrder >> tokensOf: aPointer [
	"The tokens of the pointer below the root, still escaped"

	^ aPointer size < 3
		  ifTrue: [ #(  ) ]
		  ifFalse: [ (aPointer allButFirst: 2) splitOn: $/ ]
]
