"
Derivation #unresolved, for the root: the OPReference entities that the importer keeps for the $ref it cannot resolve (unresolved, external or cyclic), at their sites, whatever the order the importer meets them in (the relation is compared as a set). The site of a $ref that the importer reports with a diagnostic and keeps no OPReference for (the target is not an object) is not expected (FamixOpenApiRelationCheck>>isReferenceExcusedAt:).
"
Class {
	#name : 'FamixOpenApiUnresolvedDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiUnresolvedDerivation >> isUnresolved: aNode in: aCheck [
	"True when the importer should keep an OPReference at the site of the node: it gives one for the $ref it cannot resolve, unless it reports the $ref with a diagnostic and keeps none"

	^ ((aCheck nodeExpectation expectedClassNamesFor: aNode) includes:
		   'OPReference') and: [
		  (aCheck isReferenceExcusedAt: aNode pointer) not ]
]

{ #category : 'deriving' }
FamixOpenApiUnresolvedDerivation >> targetsOf: anOwner in: aCheck [

	^ (aCheck expandedInventory allNodes
		   select: [ :each | self isUnresolved: each in: aCheck ]
		   thenCollect: #pointer) asArray sorted
]
