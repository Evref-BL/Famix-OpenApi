"
Derives the clones of a source document by re-rooting. For a $ref response or path item at a use site (not an entry of the components, which is an alias), the importer reads the target again AT THE POINTER OF THE SITE: the entities below the site are the ones the target would give if it stood there (verified by import experiments: Swagger 2, 3.0 and 3.1, nested clones, aliases, cycles, unresolved targets). #expandedInventory answers a COPY of the inventory where the node of every such site is replaced by a copy of the node it designates (the references met on the way are followed on the ORIGINAL inventory, as the importer reads the document: FamixOpenApiReferenceChain), walked again at the site pointer, so that the ordinary derivations (FamixOpenApiNodeExpectation and the synthetic ones) apply to the clone as they apply to the document. A site is cloned only when FamixOpenApiNodeExpectation says it gives the clone entity (resolved, not an alias, not a callback path item that the importer shares); nothing is cloned below an unresolved or cyclic site, and a path item is not cloned inside a clone of the same $ref (the importer reports #refCycle). In OpenAPI 3.1 the keys beside the $ref of a path item override the target. The depth of the nested clones is bounded (dataMaxDepth). The original inventory is not changed. #isBelowCloneSite: tells whether a pointer lies below a cloned site (the rule name #cloneSubtree).
"
Class {
	#name : 'FamixOpenApiCloneExpansion',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'expanded',
		'expectation',
		'chain',
		'sites'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiCloneExpansion class >> dataMaxDepth [
	"The deepest nesting of clones that is expanded (a clone inside a clone inside...): the importer has no such limit but stops on the cycles, and no document nests that much; deeper clones are a known limit (see FamixOpenApiSyntheticExpectations class>>knownLimits)"

	^ 32
]

{ #category : 'instance creation' }
FamixOpenApiCloneExpansion class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> cloneSitePointers [
	"The pointers of the sites that were cloned"

	self expandedInventory.
	^ sites keys
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> cloneSitesBelow: aPointer [
	"The reference nodes of the expanded inventory below aPointer (the root: every one) that are of a spec object a $ref clones, outer ones first"

	^ (expanded allNodes select: [ :each |
		   each isReference and: [
			   (self isCloneSpecObject: (expanded siteSpecObjectOf: each))
				   and: [
					   aPointer = FamixOpenApiSourceNode rootPointer or: [
						   FamixOpenApiSourceNode
							   pointer: each pointer
							   isBelow: aPointer ] ] ] ]) sorted: [ :a :b |
		  a pointer size <= b pointer size ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> depthOf: aSite [
	"The number of clone sites above aSite"

	^ sites keys count: [ :each |
		  FamixOpenApiSourceNode pointer: aSite pointer isBelow: each ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> expand [

	| pending |
	expanded := inventory copy.
	expectation := FamixOpenApiNodeExpectation on: expanded.
	chain := FamixOpenApiReferenceChain on: inventory.
	sites := Dictionary new.
	pending := OrderedCollection withAll:
		           (self cloneSitesBelow: FamixOpenApiSourceNode rootPointer).
	[ pending isEmpty ] whileFalse: [
		| site |
		site := pending removeFirst.
		(self isExpandable: site) ifTrue: [
			self expandSite: site.
			pending addAll: (self cloneSitesBelow: site pointer) ] ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> expandSite: aSite [
	"Replace aSite by the node it designates, walked again at the pointer of the site"

	| edge root |
	edge := expanded edgeAt: aSite pointer.
	root := FamixOpenApiSourceNode
		        specObject: (expanded siteSpecObjectOf: aSite)
		        pointer: aSite pointer
		        in: expanded
		        value: (self valueReadAt: aSite).
	sites at: aSite pointer put: aSite referenceText.
	expanded removeNodeAt: aSite pointer.
	FamixOpenApiSourceWalker new walkRoot: root into: expanded edge: edge
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> expandedInventory [
	"A copy of the inventory where the clone sites hold what their target holds (built once)"

	expanded ifNil: [ self expand ].
	^ expanded
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> inventory: aSourceInventory [

	inventory := aSourceInventory
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> isActiveReferenceAbove: aSite [
	"True when a path item cloned above aSite was cloned from the same $ref"

	^ (sites associations select: [ :each |
		   FamixOpenApiSourceNode pointer: aSite pointer isBelow: each key ])
		  anySatisfy: [ :each | each value = aSite referenceText ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> isBelowCloneSite: aPointer [
	"True when aPointer lies below a site that was cloned"

	^ self cloneSitePointers anySatisfy: [ :each |
		  FamixOpenApiSourceNode pointer: aPointer isBelow: each ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> isCloneSpecObject: aName [

	^ FamixOpenApiNodeExpectation dataCloneClassNames anySatisfy: [ :each |
		  each first = aName ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> isExpandable: aSite [
	"True when the importer clones the target of aSite at the site: it gives the clone entity, its $ref resolves, the depth is bounded and a path item does not clone its own $ref again"

	| spec |
	aSite referenceText ifNil: [ ^ false ].
	spec := expanded siteSpecObjectOf: aSite.
	((expectation expectedClassNamesFor: aSite) includesAll:
		 (expectation cloneClassNamesOf: spec)) ifFalse: [ ^ false ].
	(chain outcomeOf: aSite) == #resolved ifFalse: [ ^ false ].
	^ (self depthOf: aSite) < self class dataMaxDepth and: [
		  spec ~= 'PathItem' or: [ (self isActiveReferenceAbove: aSite) not ] ]
]

{ #category : 'expanding' }
FamixOpenApiCloneExpansion >> valueReadAt: aSite [
	"The value the importer reads at aSite: the one of the target (end of the chain of references), overridden by the keys beside the $ref in OpenAPI 3.1 for a path item"

	| target merged |
	target := chain targetOf: aSite.
	((expanded siteSpecObjectOf: aSite) = 'PathItem' and: [
		 aSite version = #v31 ]) ifFalse: [ ^ target value ].
	merged := target value copy.
	aSite value keysAndValuesDo: [ :key :each |
		key = '$ref' ifFalse: [ merged at: key put: each ] ].
	^ merged
]
