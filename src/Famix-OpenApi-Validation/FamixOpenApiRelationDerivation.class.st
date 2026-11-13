"
How the targets of one relation are derived from the source document: the abstract class of the derivations of the relation check (FamixOpenApiRelationRules names them in its rows, FamixOpenApiRelationDerivation class>>named:arguments: builds them). #targetsOf:in: answers the ordered list of the canonical pointers of the entities that the relation of an owner should hold, or nil when the source cannot be compared (the check then counts the relation as deferred, with #reason). The check (FamixOpenApiRelationCheck) gives the services: the expanded inventory, the pointer of the entity that a node gives for a family of classes (following the $ref the way the importer does), the entities derived without node. The arguments are the data of the row: the keys of the source or the segments of the pointers.
"
Class {
	#name : 'FamixOpenApiRelationDerivation',
	#superclass : 'Object',
	#instVars : [
		'arguments',
		'family'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiRelationDerivation class >> dataClassNames [
	"The name of the class of each derivation"

	^ Dictionary newFromPairs:
		  #( #children #FamixOpenApiChildrenDerivation
		     #directChildren #FamixOpenApiDirectChildrenDerivation
		     #container #FamixOpenApiContainerDerivation
		     #synthetic #FamixOpenApiSyntheticDerivation
		     #syntheticAt #FamixOpenApiSyntheticAtDerivation
		     #sequence #FamixOpenApiSequenceDerivation
		     #servers #FamixOpenApiServersDerivation
		     #alias #FamixOpenApiAliasDerivation
		     #own #FamixOpenApiOwnDerivation #propertyValue #FamixOpenApiPropertyValueDerivation
		     #mediaTypeSchema #FamixOpenApiMediaTypeSchemaDerivation
		     #mappingTarget #FamixOpenApiMappingTargetDerivation
		     #requirementScheme #FamixOpenApiRequirementSchemeDerivation
		     #linkOperation #FamixOpenApiLinkOperationDerivation
		     #unresolved #FamixOpenApiUnresolvedDerivation
		     #parameterSchema #FamixOpenApiParameterSchemaDerivation )
]

{ #category : 'instance creation' }
FamixOpenApiRelationDerivation class >> named: aSymbol arguments: anArray family: aClass [
	"The derivation called aSymbol in the rows of FamixOpenApiRelationRules (#children, #directChildren, #container, #synthetic, #syntheticAt, #sequence, #servers, #alias, #own, #propertyValue, #mediaTypeSchema, #mappingTarget, #requirementScheme, #linkOperation, #unresolved, #parameterSchema)"

	^ (Smalltalk at: (self dataClassNames at: aSymbol)) new
		  arguments: anArray;
		  family: aClass;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiRelationDerivation >> arguments [
	"The data of the row of the table: the keys of the source or the segments of the pointers"

	^ arguments
]

{ #category : 'accessing' }
FamixOpenApiRelationDerivation >> arguments: anArray [

	arguments := anArray
]

{ #category : 'accessing' }
FamixOpenApiRelationDerivation >> family [
	"The family of the entities that the targets must be (the class directly below OPEntity)"

	^ family
]

{ #category : 'accessing' }
FamixOpenApiRelationDerivation >> family: aClass [

	family := aClass
]

{ #category : 'deriving' }
FamixOpenApiRelationDerivation >> inOrderOf: aValue nodes: aCollection [
	"The nodes in the order of the keys of the map (or of the elements of the array) of the source that holds them: the inventory adds the clones of the $ref responses and path items after the other nodes, the source says the order; the nodes as they are when the value does not hold all of them (a clone site whose value is only a $ref)"

	| keys |
	aValue isDictionary ifFalse: [ ^ aCollection ].
	keys := aValue keys.
	(aCollection allSatisfy: [ :each | keys includes: each key ])
		ifFalse: [ ^ aCollection ].
	^ aCollection asArray sorted: [ :a :b |
		  (keys indexOf: a key) <= (keys indexOf: b key) ]
]

{ #category : 'deriving' }
FamixOpenApiRelationDerivation >> lastKeyOf: aPointer [
	"The key of the last token of the pointer (unescaped)"

	^ FamixOpenApiSourceNode unescapeToken: (aPointer copyAfterLast: $/)
]

{ #category : 'deriving' }
FamixOpenApiRelationDerivation >> pointerOf: aPointer child: aKey [
	"The pointer of the child of the pointer (the key is escaped)"

	^ FamixOpenApiSourceNode pointerOf: aPointer child: aKey
]

{ #category : 'deriving' }
FamixOpenApiRelationDerivation >> pointersOfNodes: aCollection in: aCheck [
	"The pointers of the entities of the family that the nodes give, each one once, in the order of the nodes"

	| pointers |
	pointers := OrderedCollection new.
	aCollection do: [ :each |
		(aCheck targetPointerOf: each family: family) ifNotNil: [ :pointer |
			(pointers includes: pointer) ifFalse: [ pointers add: pointer ] ] ].
	^ pointers asArray
]

{ #category : 'accessing' }
FamixOpenApiRelationDerivation >> reason [
	"Why the relation is not derived when #targetsOf:in: answers nil"

	^ 'not derivable from the source'
]

{ #category : 'deriving' }
FamixOpenApiRelationDerivation >> targetOfNode: aNodeOrNil in: aCheck [
	"The pointer of the entity of the family that the node gives, as a list of one pointer, empty when the node gives none"

	^ aNodeOrNil ifNil: [ #(  ) ] ifNotNil: [
		  (aCheck targetPointerOf: aNodeOrNil family: family)
			  ifNil: [ #(  ) ]
			  ifNotNil: [ :pointer | { pointer } ] ]
]

{ #category : 'deriving' }
FamixOpenApiRelationDerivation >> targetsOf: anOwner in: aCheck [
	"The canonical pointers of the entities that the relation of the owner (FamixOpenApiRelationOwner) should hold, in order; nil when the source cannot be compared (the check counts the relation as deferred)"

	^ self subclassResponsibility
]
