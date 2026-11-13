"
The owner of the relations that the relation check (FamixOpenApiRelationCheck) compares: the canonical POINTER of the entity that holds the relations, the source NODE of the expanded inventory that the targets are derived from (nil for an entity that has no node of its own: a media type of Swagger 2, a mapping entry, a security requirement item) and the ENTITY of the model (nil when the model has none). The pointer of the entity is the one of the node, except for the components of Swagger 2 (the root node, the entity at #/components).
"
Class {
	#name : 'FamixOpenApiRelationOwner',
	#superclass : 'Object',
	#instVars : [
		'pointer',
		'node',
		'entity'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiRelationOwner class >> pointer: aPointer node: aNodeOrNil [

	^ self new
		  pointer: aPointer;
		  node: aNodeOrNil;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> entity [
	"The entity of the model that holds the relation, nil when there is none"

	^ entity
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> entity: anEntity [

	entity := anEntity
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> node [
	"The source node the targets are derived from, nil when the entity has none"

	^ node
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> node: aSourceNode [

	node := aSourceNode
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> pointer [
	"The canonical pointer of the entity that holds the relation"

	^ pointer
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> pointer: aPointer [

	pointer := aPointer
]

{ #category : 'printing' }
FamixOpenApiRelationOwner >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: pointer asString;
		nextPut: $)
]

{ #category : 'accessing' }
FamixOpenApiRelationOwner >> sourcePointer [
	"The pointer of the source node, the one of the entity when it has none"

	^ node ifNil: [ pointer ] ifNotNil: [ :each | each pointer ]
]
