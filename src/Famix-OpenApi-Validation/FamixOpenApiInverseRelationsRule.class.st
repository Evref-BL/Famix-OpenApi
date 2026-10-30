"
Invariant: the two sides of every relation of the model agree. For every entity and every relation property that has an opposite in the Fame meta-description (1-1, 1-n and n-n, containers and usedBy*/usedAs* back-pointers alike, no class hard-coded), each related entity holds the entity back in the opposite property. The Fame setters keep both sides in step, so a finding means a slot written directly or an importer bug. Each violation is seen from the side that points to the other and reported once, on the entity that holds the one-sided link. Primitive and derived properties are ignored. Finding: #inverseMismatch, #error.
"
Class {
	#name : 'FamixOpenApiInverseRelationsRule',
	#superclass : 'FamixOpenApiValidationRule',
	#instVars : [
		'propertyCache'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'checking' }
FamixOpenApiInverseRelationsRule >> check: anEntity into: aFindings [

	(self propertiesOf: anEntity class) do: [ :each |
		self check: anEntity property: each into: aFindings ]
]

{ #category : 'checking' }
FamixOpenApiInverseRelationsRule >> check: anEntity property: aProperty into: aFindings [
	"Record a finding for every entity related through aProperty that does not hold anEntity back."

	(self relatedEntitiesOf: anEntity through: aProperty) do: [ :each |
		(self does: each hold: anEntity through: aProperty opposite)
			ifFalse: [
				self
					addFindingTo: aFindings
					entity: anEntity
					message:
					(self messageFor: anEntity property: aProperty related: each) ] ]
]

{ #category : 'description' }
FamixOpenApiInverseRelationsRule >> code [

	^ #inverseMismatch
]

{ #category : 'description' }
FamixOpenApiInverseRelationsRule >> description [

	^ 'For every relation of the Fame meta-description that has an opposite (1-1, 1-n, n-n), each related entity holds the entity in the opposite property. Generic: no class is hard-coded. Limits: it only compares the two sides of relations declared with an opposite, it does not judge whether a relation should be set, and a related entity that is not part of the model is still checked through its own slots (it is not looked up in the model). Primitive and derived properties are ignored.'
]

{ #category : 'checking' }
FamixOpenApiInverseRelationsRule >> does: aRelated hold: anEntity through: anOpposite [
	"Answer whether aRelated holds anEntity (by identity) in its relation anOpposite."

	((self propertiesOf: aRelated class) includes: anOpposite) ifFalse: [
		^ false ].
	^ (self relatedEntitiesOf: aRelated through: anOpposite) anySatisfy: [
		  :each | each == anEntity ]
]

{ #category : 'initialization' }
FamixOpenApiInverseRelationsRule >> initialize [

	super initialize.
	propertyCache := Dictionary new
]

{ #category : 'checking' }
FamixOpenApiInverseRelationsRule >> messageFor: anEntity property: aProperty related: aRelated [

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: anEntity class name;
			  nextPut: $>;
			  nextPutAll: aProperty name;
			  nextPutAll: ' holds ';
			  nextPutAll: aRelated class name;
			  space;
			  print: aRelated name;
			  nextPutAll: ' which does not hold it back in ';
			  nextPutAll: aProperty opposite name ]
]

{ #category : 'checking' }
FamixOpenApiInverseRelationsRule >> propertiesOf: aClass [
	"Answer the relation properties of aClass with an opposite, computed once per class."

	^ propertyCache
		  at: aClass
		  ifAbsentPut: [ self relationPropertiesOf: aClass ]
]

{ #category : 'description' }
FamixOpenApiInverseRelationsRule >> severity [

	^ #error
]
