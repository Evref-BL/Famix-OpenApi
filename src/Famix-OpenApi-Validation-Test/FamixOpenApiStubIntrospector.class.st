"
Introspector of the real metamodel that claims some more scalar slots, to prove the conformance status is computed and not asserted by the mapping data. The real metamodel is never modified.
"
Class {
	#name : 'FamixOpenApiStubIntrospector',
	#superclass : 'FamixOpenApiMetamodelIntrospector',
	#instVars : [
		'extraSelectors'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'stubbing' }
FamixOpenApiStubIntrospector >> claimSlot: aSelector in: aClassName [
	"Pretend that the class named aClassName has a scalar slot named aSelector."

	(extraSelectors
		 at: aClassName asSymbol
		 ifAbsentPut: [ OrderedCollection new ]) add: aSelector asSymbol
]

{ #category : 'initialization' }
FamixOpenApiStubIntrospector >> initialize [

	super initialize.
	extraSelectors := Dictionary new
]

{ #category : 'slots' }
FamixOpenApiStubIntrospector >> slotsOf: aClass [

	^ (super slotsOf: aClass)
	  ,
		  ((extraSelectors at: aClass name ifAbsent: [ #(  ) ]) collect: [
			   :each |
			   FamixOpenApiModelSlot new
				   declaringClassName: aClass name;
				   selector: each;
				   kind: #slot;
				   targetName: 'String';
				   isMany: false;
				   yourself ])
]
