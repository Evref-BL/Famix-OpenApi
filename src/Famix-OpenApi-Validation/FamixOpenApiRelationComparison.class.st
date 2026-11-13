"
One relation of one owner compared by the relation check: the OWNER (FamixOpenApiRelationOwner), the RULE (FamixOpenApiRelationRule), the EXPECTED targets (the canonical pointers the source designates, in order) and the FOUND ones (the canonical pointers of the entities the relation holds; a target of another family than the rule says is written pointer (ClassName), so that it never equals an expected one). It says whether the two lists are equivalent for the compare mode of the rule and, when they are not, what is missing, what is extra and whether only the order differs.
"
Class {
	#name : 'FamixOpenApiRelationComparison',
	#superclass : 'Object',
	#instVars : [
		'owner',
		'rule',
		'expected',
		'found'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> consume: anElement from: anOrderedCollection [
	"Take one occurrence of the element out of the collection: true when there was one"

	| index |
	index := anOrderedCollection indexOf: anElement.
	index = 0 ifTrue: [ ^ false ].
	anOrderedCollection removeAt: index.
	^ true
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> expected [
	"The canonical pointers of the targets the source designates, in the order of the source"

	^ expected
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> expected: aCollection [

	expected := aCollection asArray
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> extra [
	"The targets that the relation holds and the source does not designate"

	^ self list: found without: expected
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> found [
	"The canonical pointers of the entities the relation holds (see the class comment)"

	^ found
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> found: aCollection [

	found := aCollection asArray
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> gapKind [
	"#countMismatch for a relation compared by its count, #relationMismatch otherwise"

	^ rule compareMode == #count
		  ifTrue: [ #countMismatch ]
		  ifFalse: [ #relationMismatch ]
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> isEquivalent [
	"True when the relation holds what the source designates, for the compare mode of the rule"

	rule compareMode == #count ifTrue: [ ^ expected size = found size ].
	rule compareMode == #set ifTrue: [
		^ self missing isEmpty and: [ self extra isEmpty ] ].
	^ expected = found
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> isOrderDifference [
	"True when the relation holds the expected targets, in another order"

	^ self isEquivalent not and: [
		  self missing isEmpty and: [ self extra isEmpty ] ]
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> list: aCollection without: anotherCollection [
	"The elements of aCollection, minus one occurrence for each element of anotherCollection"

	| rest |
	rest := anotherCollection asOrderedCollection.
	^ aCollection reject: [ :each | self consume: each from: rest ]
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> message [
	"What the relation holds and the source designates, as text: the missing and the extra targets, or the order"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: rule specObject;
			  nextPut: $.;
			  nextPutAll: rule fieldKey;
			  nextPutAll: ' -> ';
			  nextPutAll: rule targetClassName;
			  nextPutAll: ' (';
			  nextPutAll: rule ownerClassName;
			  nextPutAll: '>>';
			  nextPutAll: rule selector;
			  nextPutAll: '): '.
		  self writeDifferenceOn: stream ]
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> missing [
	"The expected targets that the relation does not hold (each occurrence counted once)"

	^ self list: expected without: found
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> owner [

	^ owner
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> owner: aRelationOwner [

	owner := aRelationOwner
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> rule [

	^ rule
]

{ #category : 'accessing' }
FamixOpenApiRelationComparison >> rule: aRelationRule [

	rule := aRelationRule
]

{ #category : 'comparing' }
FamixOpenApiRelationComparison >> writeDifferenceOn: aStream [

	rule compareMode == #count ifTrue: [
		^ aStream
			  nextPutAll: 'the source designates ';
			  print: expected size;
			  nextPutAll: ' targets, the relation holds ';
			  print: found size ].
	self isOrderDifference ifTrue: [
		^ aStream
			  nextPutAll: 'order differs: the source says ';
			  print: expected;
			  nextPutAll: ', the relation holds ';
			  print: found ].
	aStream
		nextPutAll: 'missing ';
		print: self missing;
		nextPutAll: ', extra ';
		print: self extra
]
