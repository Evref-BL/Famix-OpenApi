"
Tests of FamixOpenApiRegistrationOrder: the order in which the importer creates the entities of the path items (components first, then the entries of paths in document order, then the web hooks), which tells whether a callback $ref to a path item shares an existing entity or clones.
"
Class {
	#name : 'FamixOpenApiRegistrationOrderTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'fixtures' }
FamixOpenApiRegistrationOrderTest >> document [
	"Entries /a, /b of paths, a web hook, a component path item and an alias of it (3.1)"

	^ '{"openapi":"3.1.0","info":{"title":"t","version":"1"},"paths":{"/a":{"get":{"responses":{"200":{"description":"d"}}}},"/b":{"$ref":"#/paths/~1a"}},"webhooks":{"w":{"post":{"responses":{"200":{"description":"d"}}}}},"components":{"pathItems":{"PI":{"get":{"responses":{"200":{"description":"d"}}}},"PA":{"$ref":"#/components/pathItems/PI"}}}}'
]

{ #category : 'tests' }
FamixOpenApiRegistrationOrderTest >> testAComponentThatIsNotAnAliasExistsBeforeEverySite [

	| inventory order site |
	inventory := self inventoryOf: self document.
	order := FamixOpenApiRegistrationOrder on: inventory.
	site := inventory nodeAt: '#/paths/~1a/get'.
	self assert: (order
			 isRegistered: (inventory nodeAt: '#/components/pathItems/PI')
			 beforeSite: site).
	self deny: (order
			 isRegistered: (inventory nodeAt: '#/components/pathItems/PA')
			 beforeSite: site)
]

{ #category : 'tests' }
FamixOpenApiRegistrationOrderTest >> testAPathItemExistsForASiteInItselfAbovePointersAndInWhatComesBeforeButNotAfter [

	| inventory order a b webhook |
	inventory := self inventoryOf: self document.
	order := FamixOpenApiRegistrationOrder on: inventory.
	a := inventory nodeAt: '#/paths/~1a'.
	b := inventory nodeAt: '#/paths/~1b'.
	webhook := inventory nodeAt: '#/webhooks/w'.
	self assert: (order isRegistered: a beforeSite: a).
	self assert: (order isRegistered: a beforeSite: b).
	self deny: (order isRegistered: b beforeSite: a).
	self deny: (order isRegistered: webhook beforeSite: b).
	self assert: (order isRegistered: b beforeSite: webhook)
]

{ #category : 'tests' }
FamixOpenApiRegistrationOrderTest >> testAPathItemOfACallbackExistsWhenItWasVisitedBeforeTheSite [
	"documentCallbackTargets: {$x} of /a is visited before {$y} and {$z} of the same entry, /a/post after them, /b after /a and before /c"

	| inventory order |
	inventory := self inventoryOf: self documentCallbackTargets.
	order := FamixOpenApiRegistrationOrder on: inventory.
	self assert: (order
			 isRegistered:
			 (inventory nodeAt: '#/paths/~1a/get/callbacks/cb/{$x}')
			 beforeSite:
			 (inventory nodeAt: '#/paths/~1a/get/callbacks/cb/{$z}')).
	self deny: (order
			 isRegistered:
			 (inventory nodeAt: '#/paths/~1a/post/callbacks/cb/{$k}')
			 beforeSite:
			 (inventory nodeAt: '#/paths/~1a/get/callbacks/cb/{$y}')).
	self assert: (order
			 isRegistered:
			 (inventory nodeAt: '#/paths/~1a/get/callbacks/cb/{$x}')
			 beforeSite:
			 (inventory nodeAt: '#/paths/~1b/get/callbacks/cb/{$w}')).
	self deny: (order
			 isRegistered:
			 (inventory nodeAt: '#/paths/~1c/get/callbacks/cb/{$m}')
			 beforeSite:
			 (inventory nodeAt: '#/paths/~1b/get/callbacks/cb/{$v}'))
]

{ #category : 'tests' }
FamixOpenApiRegistrationOrderTest >> testTheKeysOfAnObjectInAnArrayAreOrderedLikeTheOnesOfTheDocument [
	"Below an array: the elements by index, then the keys of the element in the order of the document (name, in, type, items)"

	| order |
	order := FamixOpenApiRegistrationOrder on:
		         (self inventoryOf: self documentSwagger2Typed).
	self
		assert: (order
				 comparePointer: '#/paths/~1p/get/parameters/3'
				 with: '#/paths/~1p/get/parameters/5')
		equals: -1.
	self
		assert: (order
				 comparePointer: '#/paths/~1p/get/parameters/0/items'
				 with: '#/paths/~1p/get/parameters/0/type')
		equals: 1.
	self
		assert: (order
				 comparePointer: '#/paths/~1p/get/parameters/0/name'
				 with: '#/paths/~1p/get/parameters/0/type')
		equals: -1.
	self
		assert: (order
				 comparePointer: '#/paths/~1p/get/parameters/1/name'
				 with: '#/paths/~1p/get/parameters/0/name')
		equals: 1
]

{ #category : 'tests' }
FamixOpenApiRegistrationOrderTest >> testThePointersAreVisitedByTheSectionsThenInTheOrderOfTheDocument [
	"Components, paths, web hooks; then the order of the keys of the document (not the alphabetical one: /c is after /b, post after get); an ancestor before what it holds"

	| order |
	order := FamixOpenApiRegistrationOrder on:
		         (self inventoryOf: self documentCallbackTargets).
	self
		assert: (order comparePointer: '#/webhooks/w' with: '#/paths/~1b')
		equals: 1.
	self
		assert: (order comparePointer: '#/paths/~1c' with: '#/paths/~1b')
		equals: 1.
	self
		assert: (order
				 comparePointer: '#/paths/~1a'
				 with: '#/paths/~1a/get/responses/200')
		equals: -1.
	self
		assert:
		(order comparePointer: '#/paths/~1a/post' with: '#/paths/~1a/get')
		equals: 1.
	self
		assert:
		(order comparePointer: '#/paths/~1a/get' with: '#/paths/~1a/get')
		equals: 0.
	order := FamixOpenApiRegistrationOrder on:
		         (self inventoryOf: self document).
	self
		assert:
		(order
			 comparePointer: '#/components/pathItems/PI'
			 with: '#/paths/~1a')
		equals: -1
]

{ #category : 'tests' }
FamixOpenApiRegistrationOrderTest >> testTheSectionsAreVisitedInTheOrderOfTheImporter [

	self
		assert: FamixOpenApiRegistrationOrder dataSections
		equals: #( '#/components' '#/paths' '#/webhooks' )
]
