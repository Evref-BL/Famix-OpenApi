"
One value to compare: the rule (field, slot, comparator), the source node whose field it is, the pointer suffix of the entity that carries the slot (empty for the entity of the node itself), the expected value (already normalised by the comparator) and, once the check has found it, the entity. It reads the slot of the entity and says whether it is equivalent to the expected value. Used by FamixOpenApiValueCheck.
"
Class {
	#name : 'FamixOpenApiValueComparison',
	#superclass : 'Object',
	#instVars : [
		'rule',
		'node',
		'suffix',
		'expected',
		'entity'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiValueComparison class >> rule: aRule node: aNode entry: anAssociation [
	"The comparison for an entry of the comparator: pointer suffix -> expected value"

	^ self new
		  rule: aRule;
		  node: aNode;
		  suffix: anAssociation key;
		  expected: anAssociation value;
		  yourself
]

{ #category : 'comparing' }
FamixOpenApiValueComparison >> comparator [

	^ rule comparator
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> entity [
	"The entity that carries the slot"

	^ entity
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> entity: anEntity [

	entity := anEntity
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> entityPointer [
	"The pointer where the entity should be"

	^ node pointer , suffix
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> expected [
	"The expected value, normalised"

	^ expected
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> expected: anObject [

	expected := anObject
]

{ #category : 'comparing' }
FamixOpenApiValueComparison >> found [
	"What the slot holds, normalised as the expected value"

	^ self comparator foundFrom: self rawFound
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> hasSuffix [

	^ suffix isNotEmpty
]

{ #category : 'comparing' }
FamixOpenApiValueComparison >> isEquivalent [
	"True when the slot holds what the source says"

	^ self found = expected
]

{ #category : 'comparing' }
FamixOpenApiValueComparison >> isInformative [
	"True when the expected value is not a default one (nil, false, an empty text or collection): a comparison that cannot pass by chance"

	^ expected ifNil: [ false ] ifNotNil: [
		  expected isCollection
			  ifTrue: [ expected isNotEmpty ]
			  ifFalse: [ expected ~= false ] ]
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> node [
	"The source node whose field is compared"

	^ node
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> node: aNode [

	node := aNode
]

{ #category : 'comparing' }
FamixOpenApiValueComparison >> rawFound [
	"What the slot of the entity holds. The slot is read by its selector: the table of the rules is data (FamixOpenApiValueRules), a boundary where the reflective send is the point"

	^ entity perform: rule selector
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> rule [

	^ rule
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> rule: aRule [

	rule := aRule
]

{ #category : 'accessing' }
FamixOpenApiValueComparison >> suffix: aString [

	suffix := aString
]
