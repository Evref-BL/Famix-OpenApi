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
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits')
]

{ #category : 'meta' }
OPModel class >> annotation [
	<FMClass: #OPModel super: #MooseModel>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]
