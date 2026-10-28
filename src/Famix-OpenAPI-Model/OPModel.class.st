Class {
	#name : 'OPModel',
	#superclass : 'MooseModel',
	#traits : 'OPTEntityCreator',
	#classTraits : 'OPTEntityCreator classTrait',
	#category : 'Famix-OpenAPI-Model-Model',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Model'
}

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
