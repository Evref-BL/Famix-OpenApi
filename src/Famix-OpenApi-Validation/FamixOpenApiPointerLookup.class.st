"
Index of the entities of an OPModel by canonical pointer, for the fidelity checks. Several entities may share a pointer when they are legitimately different (an OPProperty and its value OPSchema; an OPOAuthFlow and the Swagger 2 OPSecurityScheme it comes from; an OPReference at the site of its $ref), so the lookup answers collections and can be narrowed to a FAMILY: the class directly below OPEntity (OPSubSchema belongs to the family OPSchema).
"
Class {
	#name : 'FamixOpenApiPointerLookup',
	#superclass : 'Object',
	#instVars : [
		'entitiesByPointer'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'families' }
FamixOpenApiPointerLookup class >> familyOf: anEntity [
	"The family of an entity: its class directly below OPEntity"

	^ self familyOfClass: anEntity class
]

{ #category : 'families' }
FamixOpenApiPointerLookup class >> familyOfClass: aClass [
	"The class directly below OPEntity among aClass and its superclasses, aClass itself when there is none"

	^ aClass withAllSuperclasses
		  detect: [ :each | each superclass == OPEntity ]
		  ifNone: [ aClass ]
]

{ #category : 'instance creation' }
FamixOpenApiPointerLookup class >> onEntities: aCollection [

	^ self new
		  entities: aCollection;
		  yourself
]

{ #category : 'instance creation' }
FamixOpenApiPointerLookup class >> onModel: anOPModel [
	"The lookup of every entity of the model"

	^ self onEntities: anOPModel allModelEntities
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> allEntities [
	"Every indexed entity, the ones without pointer included"

	^ entitiesByPointer values flatCollect: #yourself
]

{ #category : 'initialization' }
FamixOpenApiPointerLookup >> entities: aCollection [
	"Index the entities by canonical pointer; an entity without pointer is indexed under nil"

	entitiesByPointer := aCollection groupedBy: [ :each |
		                     each canonicalPointer ]
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> entitiesAt: aPointer [
	"Every entity whose canonical pointer is aPointer; none gives an empty Array"

	^ (entitiesByPointer at: aPointer ifAbsent: [ #(  ) ]) asArray
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> entitiesAt: aPointer inFamily: aFamilyClass [
	"The entities at aPointer whose family is aFamilyClass (a class directly below OPEntity)"

	^ (self entitiesAt: aPointer) select: [ :each |
		  (self class familyOf: each) == aFamilyClass ]
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> entitiesAt: aPointer ofClass: aClass [
	"The entities at aPointer that are exactly instances of aClass"

	^ (self entitiesAt: aPointer) select: [ :each | each class == aClass ]
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> entityAt: aPointer inFamily: aFamilyClass [
	"The first entity of the family at aPointer, nil when there is none (ask #entitiesAt:inFamily: to detect several)"

	^ (self entitiesAt: aPointer inFamily: aFamilyClass)
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :found | found first ]
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> includesPointer: aPointer [

	^ entitiesByPointer includesKey: aPointer
]

{ #category : 'querying' }
FamixOpenApiPointerLookup >> pointers [
	"The pointers carrying an entity, nil excluded"

	^ entitiesByPointer keys reject: #isNil
]
