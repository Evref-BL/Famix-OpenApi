"
Moose model holding the entities of one or several OpenAPI documents (an OpenApi entity is the root of each document).


"
Class {
	#name : 'OPModel',
	#superclass : 'MooseModel',
	#traits : 'OPTEntityCreator',
	#classTraits : 'OPTEntityCreator classTrait',
	#category : 'Famix-OpenAPI-Model-Model',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Model'
}

{ #category : 'examples support' }
OPModel class >> addNotFoundResponseTo: anOperation in: aModel components: aComponents [
	"Add the 404 Response of anOperation. The reusable NotFound response is shared by value: the operation gets its own copy, which owns its status code and its operation and keeps the ref of the reusable original. Its canonicalPointer is its own position in the document (the 404 of anOperation)."

	| original copy |
	original := self entityNamed: 'NotFound' in: aComponents responses.
	copy := self
		        addResponseTo: anOperation
		        status: '404'
		        description: original description
		        in: aModel.
	copy ref: original canonicalPointer.
	original content do: [ :each |
		self
			addMediaTypeTo: copy
			type: each mediaType
			schema: each schema
			in: aModel ].
	^ copy
]

{ #category : 'accessing' }
OPModel class >> allSubmetamodelsPackagesNames [

	<ignoreForCoverage>
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits')
]

{ #category : 'meta' }
OPModel class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Model super: #MooseModel>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]
