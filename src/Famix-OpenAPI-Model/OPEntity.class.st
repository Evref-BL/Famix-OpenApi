Class {
	#name : 'OPEntity',
	#superclass : 'MooseEntity',
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	<abstract>
	^ self
]

{ #category : 'testing' }
OPEntity class >> isAbstract [

	<generated>
	^ self == OPEntity
]

{ #category : 'meta' }
OPEntity class >> metamodel [

	<generated>
	^ OPModel metamodel
]
