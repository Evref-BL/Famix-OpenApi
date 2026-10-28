Class {
	#name : 'OPEntity',
	#superclass : 'MooseEntity',
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPEntity class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Entity super: #MooseEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	<abstract>
]

{ #category : 'testing' }
OPEntity class >> isAbstract [

	<ignoreForCoverage>
	<generated>
	^ self == OPEntity
]

{ #category : 'meta' }
OPEntity class >> metamodel [

	<ignoreForCoverage>
	<generated>
	^ OPModel metamodel
]
